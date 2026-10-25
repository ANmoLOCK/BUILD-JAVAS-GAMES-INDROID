#!/usr/bin/env python3
"""Extrai TUDO do JAR de Miami Nights 2 e organiza por etapa numa pasta central.

Uso:
    python3 tools/mn2_extract_all.py "Miami 2 PR-BR.jar" Miami_2 [--cfr cfr.jar] [--src pasta_java]

Encadeia mn2_unpack / mn2_strings / mn2_asprite / mn2_rooms e organiza a saida:

    Miami_2/
      00-original/              JAR original
      01-jar-extraido/          conteudo bruto do JAR (classes, META-INF, RES_*, indice "0")
      02-codigo-descompilado/   fontes Java (CFR) + CLASSES.md com o papel de cada classe
      03-indice-e-packs/        indice "0" decodificado (json/csv) + 38 packs LZMA descomprimidos
      04-entradas/<PACK>/       1 039 entradas separadas, com nome descritivo e extensao
      05-strings/               56 pacotes de texto (json, txt geral e um txt por pacote)
      06-sprites/<PACK>/        sprites ASprite renderizados (frames, modulos, animacoes json)
      07-salas/                 11 mapas: grade ASCII, objetos, NPCs, eventos (json/txt)
      08-audio/                 MIDI / WAV / AMR com extensao correta
      CATALOGO.md               tabela das 1 039 entradas (id, pack, tipo, tamanho, nome)

--cfr   caminho do cfr.jar: descompila as classes (precisa de `java`).
--src   pasta com .java ja descompilados (usada se --cfr nao for dado).
"""
import csv
import json
import os
import shutil
import struct
import subprocess
import sys
import tempfile
import zipfile

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
from mn2_unpack import PACKS, INDEX_ENTRIES, INDEX_ENTRY_SIZE, INDEX_SIZES_OFFSET  # noqa: E402

EXT = {'asprite': '.asprite', 'midi': '.mid', 'wav': '.wav', 'amr': '.amr', 'png': '.png',
       'bin': '.bin', 'empty': '.empty'}

STRING_PACK_NAMES = [
    'sistema_softkeys_creditos', 'ui_geral_locais_avisos', 'presentes_de_npc', 'news_flash',
    'cabelos', 'racas_de_cao', 'tops', 'bottoms', 'calcados', 'conquistas_titulos',
    'menus_sociais_presentes', 'nomes_de_npc', 'objetos_interativos', 'locais_e_acoes_de_objeto',
    'citacoes_loading', 'stats', 'avisos_de_necessidade', 'foto_de_perfil', 'missoes',
    'desbloqueios', 'interesses', 'falas_de_topico', 'reacoes_ofendidas', 'reacoes_de_tedio',
    'categorias_de_assunto', 'encontros', 'telefonemas_scott_callie', 'saudacoes',
    'convites_por_telefone', 'tutorial', 'dicas_de_npc', 'moveis', 'aluguel', 'huggy',
    'beatrice_westwood', 'charm', 'opal', 'festa', 'heather_dean', 'friend_apart', 'ceviche',
    'fianca', 'goldsax', 'vitamina', 'joey_proprietario', 'sanchez', 'policia_e_coco',
    'encanador_e_classificados', 'imobiliaria', 'joey_proprietario_b', 'yacht',
    'guarda_identidade', 'mansao_elizabeth_xavier', 'mid_apartment_a', 'mid_apartment_b',
    'hi_apartment_a',
]

CLASSES_MD = """# Classes do JAR (ofuscadas) e seus papéis

| Classe | Tamanho | Papel |
|---|---|---|
| `GloftMMN2` | 1 KB | MIDlet: `startApp` / `pauseApp` / `destroyApp`; cria o canvas `f` |
| `f` | 374 KB | Canvas principal: loop de jogo, máquina de estados, render isométrico, UI, interpretador de scripts, save (RMS), áudio, tabelas de dados |
| `d` | 41 KB | Ator / objeto do mundo: jogador, NPC, mobília, zona, portal; posição em ponto fixo, animação, interação |
| `a` | 14 KB | ASprite (magic 0x05DF): sprites, animações, fontes bitmap, paletas |
| `e` | 3 KB | Pathfinder A\\* em grade, 8 direções, custo 10 reto |
| `c` | 0,7 KB | Helper do tutorial de movimento |
| `b` | 25 KB | IGP ("In-Game Promotion", catálogo "Mais Jogos!") — irrelevante para a jogabilidade |

Descompilado com CFR (`--renamedupmembers --renameillegalidents --renameenumidents`).
Campos com nome `var_int_arr_ab`, `eZ`, `fa`… são referenciados em `docs/03-sistemas-de-jogo.md`.
"""


def run(cmd):
    print('>', ' '.join(cmd))
    subprocess.run(cmd, check=True)


def label(e):
    """Nome descritivo de uma entrada a partir do id / pack."""
    i, p, k = e['id'], e['pack_name'], e['kind']
    if p == 'RES_STRINGS' and 102 <= i <= 157:
        return f'strings_pack{i - 102:02d}_{STRING_PACK_NAMES[i - 102]}'
    if p in ('RES_ROOM', 'RES_ROOM_2') and i >= 168:
        r, part = divmod(i - 168, 3)
        return f'sala{r:02d}_' + ('script', 'eventos', 'mapa')[part]
    if i == 672:
        return 'esqueleto_paperdoll_masc'
    if i == 673:
        return 'esqueleto_paperdoll_fem'
    if p == 'RES_SOUNDS':
        return {'midi': 'musica', 'wav': 'sfx', 'amr': 'jingle'}.get(k, k)
    if p == 'RES_WORLDMAP':
        return 'mapa_da_cidade' if k == 'asprite' else k
    return {'asprite': 'sprite'}.get(k, k)


def main(argv):
    if len(argv) < 3:
        print(__doc__)
        sys.exit(1)
    jar, out = argv[1], argv[2]
    cfr = argv[argv.index('--cfr') + 1] if '--cfr' in argv else None
    src = argv[argv.index('--src') + 1] if '--src' in argv else None
    os.makedirs(out, exist_ok=True)
    tmp = tempfile.mkdtemp(prefix='mn2_')

    # pipeline bruto
    run([sys.executable, os.path.join(HERE, 'mn2_unpack.py'), jar, tmp])
    run([sys.executable, os.path.join(HERE, 'mn2_strings.py'), tmp, os.path.join(tmp, 'strings.json'), '--txt'])
    run([sys.executable, os.path.join(HERE, 'mn2_asprite.py'), tmp, os.path.join(tmp, 'png')])
    run([sys.executable, os.path.join(HERE, 'mn2_rooms.py'), tmp, os.path.join(tmp, 'rooms')])
    manifest = json.load(open(os.path.join(tmp, 'manifest.json')))

    def d(name):
        p = os.path.join(out, name)
        os.makedirs(p, exist_ok=True)
        return p

    # 00 / 01
    shutil.copy2(jar, os.path.join(d('00-original'), os.path.basename(jar)))
    jar_out = d('01-jar-extraido')
    with zipfile.ZipFile(jar) as z:
        z.extractall(jar_out)

    # 02 codigo
    code = d('02-codigo-descompilado')
    if cfr:
        run(['java', '-jar', cfr, jar, '--outputdir', code, '--silent', 'true',
             '--renamedupmembers', 'true', '--renameillegalidents', 'true', '--renameenumidents', 'true'])
    elif src:
        for f in os.listdir(src):
            if f.endswith('.java'):
                shutil.copy2(os.path.join(src, f), code)
    open(os.path.join(code, 'CLASSES.md'), 'w', encoding='utf-8').write(CLASSES_MD)

    # 03 indice + packs
    idx_dir = d('03-indice-e-packs')
    raw = open(os.path.join(jar_out, '0'), 'rb').read()
    index = []
    for i in range(INDEX_ENTRIES):
        o = i * INDEX_ENTRY_SIZE
        pack, flag = raw[o], raw[o + 1]
        size, off = struct.unpack('>II', raw[o + 2:o + 10])
        index.append({'id': i, 'pack': pack, 'pack_name': PACKS[pack], 'flag': flag, 'size': size, 'offset': off})
    pack_sizes = [struct.unpack('>I', raw[INDEX_SIZES_OFFSET + 4 * k:INDEX_SIZES_OFFSET + 4 * k + 4])[0] for k in range(len(PACKS))]
    json.dump({'entries': index, 'pack_sizes': dict(zip(PACKS, pack_sizes))},
              open(os.path.join(idx_dir, 'indice.json'), 'w'), indent=1)
    with open(os.path.join(idx_dir, 'indice.csv'), 'w', newline='') as f:
        w = csv.DictWriter(f, fieldnames=list(index[0].keys()))
        w.writeheader()
        w.writerows(index)
    pk = os.path.join(idx_dir, 'packs')
    os.makedirs(pk, exist_ok=True)
    for f in os.listdir(os.path.join(tmp, 'packs')):
        shutil.copy2(os.path.join(tmp, 'packs', f), pk)

    # 04 entradas (por pack, com nome e extensao) + 08 audio
    ent = d('04-entradas')
    aud = d('08-audio')
    names = {}
    for e in manifest:
        lab = label(e)
        names[e['id']] = lab
        if e['kind'] == 'empty':
            continue
        fname = f"{e['id']:04d}_{lab}{EXT.get(e['kind'], '.bin')}"
        pdir = os.path.join(ent, f"{e['pack']:02d}_{e['pack_name']}")
        os.makedirs(pdir, exist_ok=True)
        srcf = os.path.join(tmp, 'entries', e['file'])
        shutil.copy2(srcf, os.path.join(pdir, fname))
        if e['kind'] in ('midi', 'wav', 'amr'):
            shutil.copy2(srcf, os.path.join(aud, fname))

    # 05 strings
    st = d('05-strings')
    shutil.copy2(os.path.join(tmp, 'strings.json'), st)
    shutil.copy2(os.path.join(tmp, 'strings.txt'), os.path.join(st, 'strings_todos.txt'))
    strings = json.load(open(os.path.join(tmp, 'strings.json')))
    for k, lst in strings.items():
        n = int(k)
        with open(os.path.join(st, f'pack{n:02d}_{STRING_PACK_NAMES[n]}.txt'), 'w', encoding='utf-8') as f:
            for i, s in enumerate(lst):
                f.write(f'[{i}] {s}\n')

    # 06 sprites (por pack)
    sp = d('06-sprites')
    by_id = {e['id']: e for e in manifest}
    for f in sorted(os.listdir(os.path.join(tmp, 'png'))):
        eid = int(f[:4])
        e = by_id[eid]
        pdir = os.path.join(sp, f"{e['pack']:02d}_{e['pack_name']}")
        os.makedirs(pdir, exist_ok=True)
        rest = f[len(e['file'][:-4]):]            # ex.: "_frames_pal0.png" / ".json"
        shutil.copy2(os.path.join(tmp, 'png', f), os.path.join(pdir, f'{eid:04d}_{names[eid]}{rest}'))

    # 07 salas
    rm = d('07-salas')
    for f in os.listdir(os.path.join(tmp, 'rooms')):
        shutil.copy2(os.path.join(tmp, 'rooms', f), rm)

    # catalogo
    with open(os.path.join(out, 'CATALOGO.md'), 'w', encoding='utf-8') as f:
        f.write('# Catálogo das 1 039 entradas de recursos\n\n')
        f.write('Gerado por `tools/mn2_extract_all.py`. Arquivos em `04-entradas/<pack>/`, sprites renderizados em `06-sprites/<pack>/`.\n\n')
        f.write('| Id | Pack | Tipo | Bytes | Nome |\n|---|---|---|---|---|\n')
        for e in manifest:
            f.write(f"| {e['id']:04d} | {e['pack_name']} | {e['kind']} | {e['size']} | {names[e['id']]} |\n")

    shutil.rmtree(tmp, ignore_errors=True)
    print(f'ok -> {out}')


if __name__ == '__main__':
    main(sys.argv)
