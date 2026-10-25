#!/usr/bin/env python3
"""Extrai os recursos do JAR de Miami Nights 2 (Gameloft, J2ME).

Uso:
    python3 tools/mn2_unpack.py "Miami 2 PR-BR.jar" build/mn2

Saida:
    build/mn2/jar/            conteudo bruto do JAR
    build/mn2/packs/*.bin     cada RES_* descomprimido (LZMA)
    build/mn2/entries/NNNN_pPP_tTIPO.bin  cada recurso individual
    build/mn2/manifest.json   indice (pack, offset, tamanho, tipo detectado)

Formato (ver docs/02-formatos-de-arquivo.md):
  * arquivo "0" = indice: 1039 entradas x 10 bytes
        [0]    pack id (0..37)
        [1]    flag (uso interno)
        [2..5] tamanho (big-endian)
        [6..9] offset dentro do pack descomprimido (big-endian)
    seguido de 38 x uint32 BE = tamanho descomprimido de cada pack.
  * cada RES_* = stream LZMA "alone" (13 bytes de header: props, dict, size).
Somente biblioteca padrao do Python.
"""
import json
import lzma
import os
import struct
import sys
import zipfile

PACKS = (
    ['RES_SYSTEM', 'RES_SOUNDS', 'RES_STRINGS', 'RES_WORLDMAP', 'RES_REACTIONS',
     'RES_ROOM', 'RES_ROOM_2', 'RES_GLOBAL_SPRITES']
    + ['RES_GLOBAL_%d_SPRITES' % i for i in range(1, 11)]
    + ['RES_LOCATION_%s_SPRITES' % n for n in [
        '1STSTREET', 'BEAUTYSALON', 'BELUGASSTADIUM', 'CALLE8', 'GRANDAVENUE',
        'GRANKAHUNA', 'HIAPARTMENTA', 'LOWAPARTMENTA', 'OCEANDRIVE', 'OLDSAILORBOAT',
        'PELICANMARINAPORT', 'POLICESTATION', 'PRESSOFFICE', 'RESTAURANT',
        'SOUTHBEACH', 'SPACENIGHTCLUB']]
    + ['RES_CHARACTER', 'RES_MANPARTS', 'RES_WOMANPARTS', 'RES_TEXTURES']
)
assert len(PACKS) == 38

INDEX_ENTRIES = 1039
INDEX_ENTRY_SIZE = 10
INDEX_SIZES_OFFSET = INDEX_ENTRIES * INDEX_ENTRY_SIZE  # 10390


def detect_kind(data: bytes) -> str:
    if not data:
        return 'empty'
    if data[:2] == b'\xdf\x05':
        return 'asprite'
    if data[:4] == b'MThd':
        return 'midi'
    if data[:4] == b'RIFF':
        return 'wav'
    if data[:5] == b'#!AMR':
        return 'amr'
    if data[:4] == b'\x89PNG':
        return 'png'
    return 'bin'


def main(jar_path: str, out_dir: str) -> None:
    os.makedirs(out_dir, exist_ok=True)
    jar_dir = os.path.join(out_dir, 'jar')
    with zipfile.ZipFile(jar_path) as z:
        z.extractall(jar_dir)

    index = open(os.path.join(jar_dir, '0'), 'rb').read()
    if len(index) != INDEX_SIZES_OFFSET + 38 * 4:
        print('aviso: indice com tamanho inesperado', len(index))

    pack_sizes = [struct.unpack_from('>I', index, INDEX_SIZES_OFFSET + 4 * i)[0] for i in range(38)]
    packs_dir = os.path.join(out_dir, 'packs')
    os.makedirs(packs_dir, exist_ok=True)
    packs = {}
    for pid, name in enumerate(PACKS):
        raw = open(os.path.join(jar_dir, name), 'rb').read()
        if len(raw) <= 18:          # pack vazio (apenas header LZMA)
            packs[pid] = b''
            continue
        data = lzma.LZMADecompressor(format=lzma.FORMAT_ALONE).decompress(raw)
        if len(data) != pack_sizes[pid]:
            print(f'aviso: {name}: {len(data)} bytes, indice diz {pack_sizes[pid]}')
        packs[pid] = data
        open(os.path.join(packs_dir, name + '.bin'), 'wb').write(data)
        print(f'{pid:2d} {name:40s} {len(raw):7d} -> {len(data):7d} bytes')

    entries_dir = os.path.join(out_dir, 'entries')
    os.makedirs(entries_dir, exist_ok=True)
    manifest = []
    for i in range(INDEX_ENTRIES):
        e = index[i * INDEX_ENTRY_SIZE:(i + 1) * INDEX_ENTRY_SIZE]
        pid, flag = e[0], e[1]
        size = struct.unpack('>I', e[2:6])[0]
        off = struct.unpack('>I', e[6:10])[0]
        data = packs.get(pid, b'')[off:off + size]
        kind = detect_kind(data)
        fname = f'{i:04d}_p{pid:02d}_{kind}.bin'
        open(os.path.join(entries_dir, fname), 'wb').write(data)
        manifest.append(dict(id=i, pack=pid, pack_name=PACKS[pid], flag=flag,
                             offset=off, size=size, kind=kind, file=fname))
    json.dump(manifest, open(os.path.join(out_dir, 'manifest.json'), 'w'), indent=1)
    kinds = {}
    for m in manifest:
        kinds[m['kind']] = kinds.get(m['kind'], 0) + 1
    print('entradas:', len(manifest), kinds)


if __name__ == '__main__':
    if len(sys.argv) != 3:
        print(__doc__)
        sys.exit(1)
    main(sys.argv[1], sys.argv[2])
