# Fases A–G — locais e sistemas

Fonte canônica: `../content/phases.json` (`MnPhaseCatalog`).

## Locais (cumulativos)

| Fase | Locais liberados nesta etapa |
|---|---|
| A | `player_apartment` (LOW) + `apartment_garden` + `first_street` |
| B | `police_station` |
| C | `south_beach` |
| D | `yuca_restaurant`, `glight_club`, `newspaper_office`, `stadium` |
| E | `little_havana`, `ocean_drive`, `coconut_grove`, `lounge`, `beauty_clinic`, `cuban_cafe` |
| F | aptos NPC / Heather-Dean, `mansion`, `everglades`, porto/iate, ilhas, Beach, downtown, grand_avenue |
| G / Expansão | packs externos (`mods`) |

Aliases do plano → IDs reais: `restaurant_yuca`→`yuca_restaurant`, `press_office`→`newspaper_office`, `beauty_salon`→`beauty_clinic`.

## Sistemas (fase mínima)

| Sistema | Fase |
|---|---|
| Time + 4 necessidades + colapso | A |
| Relacionamento / social / quests / rules / economy / appearance / crime | B |
| 12 stats restantes + city_map | C |
| Jobs ×4 + dança | D |
| Dating / home / móveis / anões / pets / cirurgia | E |
| Mid/Hi + paridade história | F |
| Mods | G |

API: `MnGame.set_phase("e")`, `require_system("jobs")`, `BrainFacade.system_unlocked("dating")`.
