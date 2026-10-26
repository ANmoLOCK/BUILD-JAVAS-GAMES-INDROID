# Fases do projeto Godot

Cada fase é um incremento jogável. Não pule a ordem sem necessidade.
Detalhe completo: `../09-engenharia-reversa-docs/08-plano-progressivo-godot.md`.

| Fase | Nome | Status | Onde vive no disco |
|---|---|---|---|
| **A** | Cérebro + apartamento jogável | **em andamento (este branch)** | `core/*` + `game/phases/a_apartment/` |
| B | Personagem, NPC, diálogo, 1 missão, economia | pendente | `game/phases/b_social/` + sistemas já no core |
| C | Prólogo (praia → delegacia) | pendente | `game/phases/c_prologue/` |
| D | 4 empregos + minigames | pendente | `game/phases/d_jobs/` |
| E | Namoro, casa, pets | pendente | `game/phases/e_life/` |
| F | Paridade da história | pendente | conteúdo em `content/` |
| G | Mods / packs externos | pendente | `core/content_registry.gd` |
| H | Polimento Android / loja | pendente | `export_presets.cfg` |

## Fase A — critério de pronto

- [x] Todos os arquivos `core/*.gd` do plano 08 existem e compilam em Godot 4
- [x] `ContentRegistry` carrega `content/`
- [x] Time 1 s = 1 min; 16 stats com taxas/colapso
- [x] Interagir com objeto aplica efeitos (dormir / banho / lanchar)
- [x] Cena mínima `game/main.tscn` + HUD de necessidades
- [x] Teste de texto: `tests/text_day.gd` simula 24 h
- [ ] APK no device (export; fazer na H ou quando houver template Android no ambiente)

## Como evoluir sem bagunça

1. Não reescreva o `core/` a cada fase — só estenda.
2. Novas cenas → pasta da fase.
3. Atualize a linha **Status** desta tabela a cada PR.
4. Um branch por fase: `cursor/miami-godot-fase-<letra>-…-1983`.
