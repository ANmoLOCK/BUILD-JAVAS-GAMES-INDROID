# Classes do JAR (ofuscadas) e seus papéis

| Classe | Tamanho | Papel |
|---|---|---|
| `GloftMMN2` | 1 KB | MIDlet: `startApp` / `pauseApp` / `destroyApp`; cria o canvas `f` |
| `f` | 374 KB | Canvas principal: loop de jogo, máquina de estados, render isométrico, UI, interpretador de scripts, save (RMS), áudio, tabelas de dados |
| `d` | 41 KB | Ator / objeto do mundo: jogador, NPC, mobília, zona, portal; posição em ponto fixo, animação, interação |
| `a` | 14 KB | ASprite (magic 0x05DF): sprites, animações, fontes bitmap, paletas |
| `e` | 3 KB | Pathfinder A\* em grade, 8 direções, custo 10 reto |
| `c` | 0,7 KB | Helper do tutorial de movimento |
| `b` | 25 KB | IGP ("In-Game Promotion", catálogo "Mais Jogos!") — irrelevante para a jogabilidade |

Descompilado com CFR (`--renamedupmembers --renameillegalidents --renameenumidents`).
Campos com nome `var_int_arr_ab`, `eZ`, `fa`… são referenciados em `docs/03-sistemas-de-jogo.md`.
