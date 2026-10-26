# game/phases/ — corpo por fase (A–G)

Cada pasta guarda **só** cenas/UI extras daquela fase.
O mapa de locais + sistemas fica no cérebro: `content/phases.json` + `core/phase_catalog.gd`.

| Pasta | Fase | Locais liberados nesta etapa | Sistemas que abrem |
|---|---|---|---|
| `a_apartment/` | A | apto LOW, jardim, First Street | time, 4 necessidades, colapso |
| `b_social/` | B | `police_station` | social, quests, economy, appearance, crime |
| `c_prologue/` | C | `south_beach` | stats completas, city_map |
| `d_jobs/` | D | Yuca, Glight, Press, Stadium | jobs ×4, dança |
| `e_life/` | E | Havana / Ocean / Coconut / Lounge / clínica / café | dating, casa, anões, pets, cirurgia |
| `f_story/` | F | aptos NPC, mansão, Everglades, porto/iate, ilhas, Beach… | Mid/Hi + paridade história |
| `g_mods/` | G | (expansão via pack) | mods / packs externos |

**Regra:** locais são **cumulativos** — fase D inclui A+B+C+D.
Sistemas usam `BrainFacade.system_unlocked("jobs")` / `MnGame.require_system(...)`.

**Operação:** `MnPhaseDirector.start` via `Bootstrap.game.start_phase("b")` —
aplica `bootstrap` (quests, cash, local, cutscene) e `checklist` de cada `phase.json`.

Ver: `../../core/PHASES.md`, `../../core/EVENT_CONTRACT.md`, `../../content/phases.json`.
