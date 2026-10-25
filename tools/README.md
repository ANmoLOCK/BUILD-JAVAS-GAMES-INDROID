# tools/ — ferramentas de extração e validação

Todas em Python 3 (≥ 3.8). As ferramentas `mn2_*` usam **apenas a biblioteca padrão** e operam
sobre um JAR fornecido por você; a saída vai para `build/` (ignorada pelo git — os recursos
extraídos são da Gameloft e não devem ser commitados).

## Fluxo completo

```bash
# 1. abre o JAR, lê o índice "0", descomprime os 38 packs LZMA e separa as 1 039 entradas
python3 tools/mn2_unpack.py "Miami 2 PR-BR.jar" build/mn2

# 2. decodifica os 56 pacotes de strings (pt-BR) em JSON (+ .txt legível)
python3 tools/mn2_strings.py build/mn2 build/mn2/strings.json --txt

# 3. renderiza todos os sprites (ASprite) em PNG + JSON de animações
python3 tools/mn2_asprite.py build/mn2 build/mn2/png
#    ou apenas um:
python3 tools/mn2_asprite.py --one build/mn2/entries/0050_p00_asprite.bin build/mn2/png

# 4. exporta as 11 salas: grade ASCII, objetos, NPCs, portais, zonas, eventos
python3 tools/mn2_rooms.py build/mn2 build/mn2/rooms

# 5. valida um pack de conteúdo do remake contra schemas/ (requer: pip install jsonschema)
python3 tools/validate_content.py content/ --strict
```

## Saídas

| Caminho | Conteúdo |
|---|---|
| `build/mn2/jar/` | JAR extraído |
| `build/mn2/packs/RES_*.bin` | packs descomprimidos |
| `build/mn2/entries/NNNN_pPP_<tipo>.bin` | entrada NNNN do pack PP, tipo detectado (asprite, midi, wav, amr, png, bin, empty) |
| `build/mn2/manifest.json` | lista de entradas com pack, offset, tamanho e tipo |
| `build/mn2/strings.json` | `{ "0": [...], "1": [...], ... }` por pacote de strings |
| `build/mn2/png/NNNN_frames.png`, `NNNN_modules.png`, `NNNN_anims.json` | sprite sheets e animações |
| `build/mn2/rooms/room_NN.json`, `room_NN.txt`, `rooms_summary.json` | dados por sala |

## Referência rápida dos formatos

Ver `docs/02-formatos-de-arquivo.md`. Resumo:

* **Índice `0`**: 1 039 × 10 bytes `{u8 pack, u8 flag, u32be size, u32be offset}` seguidos de
  38 × `u32be` tamanhos de pack.
* **Packs**: LZMA "alone" (`lzma.FORMAT_ALONE`).
* **Strings**: `u8 n; count; offsets; UTF-8 \0`.
* **ASprite**: magic `0x05DF`, módulos/fmodules/frames/aframes/anims, paletas, pixels
  (RLE/1/2/4/8 bpp).
* **Salas**: entrada `168 + 3·sala` (+0 script, +1 eventos, +2 mapa de registros `short` LE).

## Dependências

* `mn2_*.py`: nenhuma.
* `validate_content.py`: `jsonschema >= 4.18` (traz `referencing`).
