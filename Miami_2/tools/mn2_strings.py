#!/usr/bin/env python3
"""Decodifica os 56 pacotes de texto de RES_STRINGS (entradas 102..157).

Uso:
    python3 tools/mn2_strings.py build/mn2 build/mn2/strings.json [--txt [build/mn2/strings.txt]]

Formato de um pacote de strings:
    byte 0        : largura dos inteiros (2 ou 3 bytes, big-endian)
    [1 .. 1+n)    : quantidade de strings
    tabela        : `count` offsets relativos ao inicio da area de dados
    dados         : strings UTF-8 terminadas em \\0

Marcacoes dentro dos textos (interpretadas pelo motor de texto do jogo):
    \\n  quebra de linha            \\pN  troca de paleta/cor da fonte (N = 1..8)
    \\mX\\m texto so para jogador masculino   \\fX\\f texto so para jogador feminino
    \\x  nome do jogador            \\d  nome do(a) namorado(a)/par
    \\o  nome do local               \\v  versao do MIDlet / \\v1..\\v1 \\v600..\\v600 variantes
    ]   quebra de pagina no dialogo  ^texto^  destaque
"""
import json
import os
import sys

FIRST, LAST = 102, 157  # ids das entradas de RES_STRINGS no indice "0"


def decode_pack(b: bytes):
    if not b:
        return []
    n = b[0]
    count = int.from_bytes(b[1:1 + n], 'big')
    base = 1 + n + count * n
    out = []
    for k in range(count):
        off = int.from_bytes(b[1 + n + k * n:1 + n + (k + 1) * n], 'big') + base
        end = b.index(b'\0', off)
        out.append(b[off:end].decode('utf-8', 'replace'))
    return out


def main(build_dir, out_json, out_txt=None):
    manifest = json.load(open(os.path.join(build_dir, 'manifest.json')))
    packs = {}
    for m in manifest:
        if FIRST <= m['id'] <= LAST:
            data = open(os.path.join(build_dir, 'entries', m['file']), 'rb').read()
            packs[m['id'] - FIRST] = decode_pack(data)
    json.dump(packs, open(out_json, 'w'), ensure_ascii=False, indent=1)
    total = sum(len(v) for v in packs.values())
    print(f'{len(packs)} pacotes, {total} strings -> {out_json}')
    if out_txt:
        with open(out_txt, 'w') as f:
            for p, strs in packs.items():
                f.write(f'##### PACK {p} ({len(strs)}) #####\n')
                for i, s in enumerate(strs):
                    f.write(f'[{i}] {s}\n')
                f.write('\n')


if __name__ == '__main__':
    if len(sys.argv) < 3:
        print(__doc__)
        sys.exit(1)
    txt = None
    if '--txt' in sys.argv:
        i = sys.argv.index('--txt')
        # caminho opcional; sem ele grava ao lado do JSON com extensao .txt
        txt = sys.argv[i + 1] if i + 1 < len(sys.argv) else os.path.splitext(sys.argv[2])[0] + '.txt'
    main(sys.argv[1], sys.argv[2], txt)
