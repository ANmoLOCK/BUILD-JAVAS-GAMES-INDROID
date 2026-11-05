# Player apartment — kit fiel ao Miami Nights 2 (LOW)

Sprites originais:

- `25_RES_LOCATION_LOWAPARTMENTA_SPRITES` — TV, janela, closet, fogão, mesa, prateleira, azulejo, corrimão
- `RES_GLOBAL_*` — cama (0248), sofá laranja (0264 pal1), geladeira (0320), chuveiro (0288), vaso (0287), pia (0286)

Pipeline: `tools/build_apartment_kit.py` → `items/*.png` (×4 nearest) + `tiles/{floor,wall,bath}.png`.

Runtime: `MnApartmentKit` + `Sprite3D` em `MnInteractable` (iso, sem billboard de corpo).
