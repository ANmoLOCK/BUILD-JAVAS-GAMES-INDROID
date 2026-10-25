#!/usr/bin/env python3
"""Exporta as salas (mapas isometricos) de RES_ROOM / RES_ROOM_2 para JSON + ASCII.

Uso:
    python3 tools/mn2_rooms.py build/mn2 build/mn2/rooms

Cada sala ocupa 3 entradas consecutivas a partir do id 168 (sala N => 168 + 3N):
    +0  scripts   : bytecode de gatilhos/condicoes/acoes (byte 0 = numero de grupos)
    +1  eventos   : tabela de registros de 6 bytes [off u16 BE, len u16 BE, tipo u16 BE];
                    ultimo byte do arquivo = quantidade. Tipo 1 = ao entrar na sala,
                    tipo 0 = periodico (a cada 5 min de jogo), demais = disparos do motor.
    +2  mapa      : stream de registros de shorts LE: [tipo, id, x, y, nParams, params...]
        tipo 1001  grid: params -> [origemX_px, origemY_px, ?, largura, altura]  (campos 2,3,5,6)
        tipo 1002  retangulo de colisao (flag 1 = parede ; variante 2 => flag 32)
        tipo 1003  celula unica com flag 4 (porta/portal)
        tipo 1005  retangulo zona flag 16 (variante 0) ou 8 (variante 1)   (calcada/rota NPC)
        tipo 1006  retangulo zona flag 64 (variante 0) ou 128 (variante 1)  (rua/area livre NPC)
        tipo 1004  ponto especial
        tipo 10    camada/fundo ("layer") -> sprite, posicao, paralaxe
        tipo >=400 template de decoracao (mobilia) -> id-400 e o indice de template
        tipo 1,2   objeto interativo (1 = mobilia; 2 = com animacao); campos: 5 sprite?, 6 sprite id,
                   7 frame, 8 flags, 9/10 offset, 11 camada, 12 string id, 13 ligacao
        tipo 3     spawn do jogador
        tipo 4     NPC (campo 6 slot, 7 sprite, 12 modo de escolha do NPC, 13/15 id por genero,
                   14 humor inicial, 16 anim, 17 flags, 19 ?, 20 personagem)
        tipo 5, 8  zona de gatilho (retangulo em celulas)
        tipo 6, 9  area nomeada (ex.: pista de danca, fila)
        tipo 19    objeto de roupa/closet
        tipo 2000/9000/2101/2110  tabelas auxiliares (horarios, portas entre salas, etc.)

Projecao isometrica 2:1 (losango 24x12 px):
    tela_x = P + (gx - gy) * 12          tela_y = Q + (gx + gy) * 6
    gx = ((ty-Q)*256 + (tx-P)*128) / 3072      gy = ((ty-Q)*256 - (tx-P)*128) / 3072
Posicoes de atores sao armazenadas em ponto fixo: celula << 4 (16 sub-passos por celula).
"""
import json
import os
import struct
import sys

FIRST_ROOM_ENTRY = 168
MAX_ROOMS = 24

TYPE_NAMES = {1: 'object', 2: 'object_anim', 3: 'player_spawn', 4: 'npc', 5: 'trigger_zone',
              6: 'area', 8: 'trigger_zone_b', 9: 'area_b', 10: 'layer', 19: 'closet_item',
              1001: 'grid', 1002: 'collision_rect', 1003: 'door_cell', 1004: 'point',
              1005: 'zone_rect_16_8', 1006: 'zone_rect_64_128', 2000: 'table_2000',
              9000: 'table_9000', 2101: 'table_2101', 2110: 'table_2110'}


def jdiv(a, b):
    q = abs(a) // abs(b)
    return q if (a >= 0) == (b >= 0) else -q


def screen_to_cell(sx, sy, P, Q):
    x, y = (sx - P) << 8, (sy - Q) << 8
    return jdiv(y + (x >> 1), 3072), jdiv(y - (x >> 1), 3072)


def parse_records(c: bytes):
    i, recs = 0, []
    while i + 10 <= len(c):
        n = struct.unpack_from('<H', c, i + 8)[0] + 5
        recs.append([struct.unpack_from('<h', c, i + 2 * k)[0] for k in range(n)])
        i += 2 * n
    return recs


def build_grid(recs):
    g = next((r for r in recs if r[0] == 1001), None)
    if not g:
        return None, None
    P, Q, W, H = g[2], g[3], g[5], g[6]
    grid = [[0] * W for _ in range(H)]

    def fill(gx, gy, w, h, f):
        for yy in range(h):
            for xx in range(w):
                if 0 <= gx + xx < W and 0 <= gy + yy < H:
                    grid[gy + yy][gx + xx] |= f
    for r in recs:
        if r[0] == 1002:
            gx, gy = screen_to_cell(r[2], r[3], P, Q)
            fill(gx, gy, r[5], r[6], 32 if r[7] == 2 else 1)
        elif r[0] == 1003:
            gx, gy = screen_to_cell(r[2], r[3], P, Q)
            fill(gx, gy, 1, 1, 4)
        elif r[0] == 1005:
            gx, gy = screen_to_cell(r[2], r[3], P, Q)
            fill(gx, gy, r[5], r[6], 16 if r[7] == 0 else 8)
        elif r[0] == 1006:
            gx, gy = screen_to_cell(r[2], r[3], P, Q)
            fill(gx, gy, r[5], r[6], 64 if r[7] == 0 else 128)
    return dict(originX=P, originY=Q, width=W, height=H), grid


def ascii_grid(grid):
    rows = []
    for row in grid:
        s = ''
        for f in row:
            ch = '.'
            if f & 1:
                ch = '#'
            elif f & 32:
                ch = '%'
            elif f & 4:
                ch = 'D'
            elif f & 16:
                ch = ','
            elif f & 8:
                ch = ';'
            elif f & 64:
                ch = '^'
            elif f & 128:
                ch = 'v'
            s += ch
        rows.append(s)
    return rows


def main(build_dir, out_dir):
    os.makedirs(out_dir, exist_ok=True)
    manifest = {m['id']: m for m in json.load(open(os.path.join(build_dir, 'manifest.json')))}

    def load(i):
        return open(os.path.join(build_dir, 'entries', manifest[i]['file']), 'rb').read()
    summary = []
    for room in range(MAX_ROOMS):
        base = FIRST_ROOM_ENTRY + room * 3
        scripts, events, mapdata = load(base), load(base + 1), load(base + 2)
        if not mapdata:
            continue
        recs = parse_records(mapdata)
        grid_info, grid = build_grid(recs)
        nev = events[-1] if events else 0
        ev = [dict(offset=struct.unpack_from('>H', events, i * 6)[0],
                   length=struct.unpack_from('>H', events, i * 6 + 2)[0],
                   type=struct.unpack_from('>H', events, i * 6 + 4)[0]) for i in range(nev)]
        counts = {}
        for r in recs:
            key = TYPE_NAMES.get(r[0], 'decor_template' if 400 <= r[0] < 1000 else f'type_{r[0]}')
            counts[key] = counts.get(key, 0) + 1
        out = dict(room=room, entries=[base, base + 1, base + 2],
                   scripts=dict(bytes=len(scripts), trigger_groups=scripts[0] if scripts else 0),
                   events=ev, grid=grid_info, record_counts=counts,
                   records=[dict(type=r[0], name=TYPE_NAMES.get(r[0], 'decor_template' if 400 <= r[0] < 1000 else 'unknown'),
                                 id=r[1], x=r[2], y=r[3], params=r[5:]) for r in recs],
                   collision_ascii=ascii_grid(grid) if grid else None)
        json.dump(out, open(os.path.join(out_dir, f'room_{room:02d}.json'), 'w'), indent=1)
        if grid:
            with open(os.path.join(out_dir, f'room_{room:02d}.txt'), 'w') as f:
                f.write(f"# sala {room} {grid_info['width']}x{grid_info['height']} "
                        f"origem=({grid_info['originX']},{grid_info['originY']})\n")
                f.write('# #=parede %=flag32 D=porta ,=zona16 ;=zona8 ^=zona64 v=zona128 .=livre\n')
                f.write('\n'.join(out['collision_ascii']) + '\n')
        summary.append(dict(room=room, grid=grid_info, scripts_bytes=len(scripts),
                            trigger_groups=out['scripts']['trigger_groups'], records=counts))
        print(f"sala {room:2d}: grid={grid_info} scripts={len(scripts)}B grupos={out['scripts']['trigger_groups']} {counts}")
    json.dump(summary, open(os.path.join(out_dir, 'rooms_summary.json'), 'w'), indent=1)


if __name__ == '__main__':
    if len(sys.argv) != 3:
        print(__doc__)
        sys.exit(1)
    main(sys.argv[1], sys.argv[2])
