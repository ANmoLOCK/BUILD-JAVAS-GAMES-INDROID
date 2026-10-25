# tools/ — ferramentas de extração e validação

Todas em Python 3 (≥ 3.8). As ferramentas `mn2_*` usam **apenas a biblioteca padrão** e
regeneram, a partir do JAR em `../00-original/`, tudo o que está nas pastas `01` a `08` de
`Miami_2/`.

## Tudo de uma vez (gera a estrutura por etapa)

```bash
cd Miami_2
python3 tools/mn2_extract_all.py "00-original/Miami 2 PR-BR.jar" . --cfr /caminho/cfr.jar
#   --cfr  descompila as classes (precisa de java + cfr.jar; https://www.benf.org/other/cfr/)
#   --src  alternativa: copia .java já descompilados de uma pasta
```

Saída (sobrescreve as pastas numeradas):

| Pasta | Conteúdo |
|---|---|
| `00-original/` | JAR original |
| `01-jar-extraido/` | conteúdo bruto do JAR (classes, `META-INF`, `RES_*`, índice `0`) |
| `02-codigo-descompilado/` | `a.java`…`f.java`, `GloftMMN2.java` + `CLASSES.md` |
| `03-indice-e-packs/` | `indice.json` / `indice.csv` (1 039 entradas decodificadas) + `packs/RES_*.bin` descomprimidos |
| `04-entradas/<NN_PACK>/` | cada entrada em arquivo próprio: `NNNN_<nome>.<ext>` (`.asprite`, `.mid`, `.wav`, `.bin`) |
| `05-strings/` | `strings.json`, `strings_todos.txt` e `packNN_<nome>.txt` por pacote |
| `06-sprites/<NN_PACK>/` | `NNNN_<nome>_frames_palK.png`, `_modules.png`, `.json` (animações) |
| `07-salas/` | `room_NN.json`, `room_NN.txt` (grade ASCII), `rooms_summary.json` |
| `08-audio/` | MIDI / WAV / AMR com extensão |
| `CATALOGO.md` | tabela id → pack → tipo → tamanho → nome |

## Passo a passo (ferramentas individuais)

```bash
# 1. índice "0" + 38 packs LZMA -> entradas tipadas + manifest.json
python3 tools/mn2_unpack.py "00-original/Miami 2 PR-BR.jar" /tmp/mn2

# 2. 56 pacotes de strings -> JSON (+ TXT)
python3 tools/mn2_strings.py /tmp/mn2 /tmp/mn2/strings.json --txt

# 3. sprites ASprite -> PNG + JSON (todos, ou --one para um arquivo)
python3 tools/mn2_asprite.py /tmp/mn2 /tmp/mn2/png
python3 tools/mn2_asprite.py --one /tmp/mn2/entries/0050_p00_asprite.bin /tmp/mn2/png

# 4. salas -> grade ASCII, objetos, NPCs, eventos
python3 tools/mn2_rooms.py /tmp/mn2 /tmp/mn2/rooms

# 5. valida um pack de conteúdo do remake (requer: pip install jsonschema)
python3 tools/validate_content.py 10-remake-3d/content --strict
```

## Referência rápida dos formatos

Ver `09-engenharia-reversa-docs/02-formatos-de-arquivo.md`. Resumo:

* **Índice `0`**: 1 039 × 10 bytes `{u8 pack, u8 flag, u32be size, u32be offset}` seguidos de
  38 × `u32be` tamanhos de pack.
* **Packs**: LZMA "alone" (`lzma.FORMAT_ALONE`).
* **Strings**: `u8 n; count; offsets; UTF-8 \0`.
* **ASprite**: magic `0x05DF`, módulos/fmodules/frames/aframes/anims, paletas, pixels
  (RLE/1/2/4/8 bpp).
* **Salas**: entrada `168 + 3·sala` (+0 script, +1 eventos, +2 mapa de registros `short` LE).

## Dependências

* `mn2_*.py`: nenhuma (`mn2_extract_all.py --cfr` precisa de `java`).
* `validate_content.py`: `jsonschema >= 4.18`.
