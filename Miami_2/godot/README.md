# Godot 4 — Remake 3D (caminho progressivo)

Pasta **separada** da extração 2D (`00`–`08`) e da documentação (`09`).
Aqui mora só o jogo Godot, fase a fase, sem bagunça.

```
Miami_2/godot/
  README.md                 ← você está aqui
  PHASES.md                 ← o que cada fase entrega / status
  miami3d/                  ← projeto Godot 4 (abra ESTE no editor)
    project.godot
    core/                   ← CÉREBRO (estável em todas as fases)
    game/                   ← corpo 3D / UI (cresce por fase)
      phases/
        a_apartment/        ← cenas da Fase A
        b_social/           ← reserva Fase B (ainda vazia)
        c_prologue/         ← reserva Fase C
    content/                ← JSON do pack (cópia de trabalho do remake)
    tests/                  ← testes do cérebro (sem cena 3D)
```

## Como abrir

1. Instale **Godot 4.3+** (renderer Mobile ou Compatibility).
2. *(Opcional mas recomendado)* compile o cérebro C++:
   ```bash
   cd Miami_2/godot/native && ./build.sh
   ```
3. Importe `miami3d/project.godot`.
4. Rode a cena principal `game/main.tscn` (F5) — o título mostra se está em **C++** ou **GDScript**.
5. No Android: compile `./build.sh release android` (NDK) e exporte pelo preset em `export_presets.cfg`.

### Duas implementações do cérebro (mesmo comportamento)

| Camada | Onde | Quando usa |
|---|---|---|
| **C++ GDExtension** `MnBrain` | `native/src/` → `miami3d/bin/libmiami_brain.*.so` | Se a `.so` estiver compilada |
| **GDScript** `MnGame` | `miami3d/core/*.gd` | Fallback automático |

A fachada `game/brain_facade.gd` escolhe sozinha. Detalhes: [`native/README.md`](native/README.md).

## Como pedir a próxima fase (para não virar bagunça)

Digite exatamente: **“implementa a Fase B do godot/PHASES.md”** (ou C, D…).

Regras:
- Código do **cérebro** só em `miami3d/core/` — não misturar com cenas.
- Cenas/UI novas da fase vão em `miami3d/game/phases/<letra>_*/`.
- Conteúdo JSON em `miami3d/content/`.
- Nunca copiar sprites/áudios das pastas `00`–`08` para dentro do `godot/`.

## Fase atual

**Fase A — Cérebro + apartamento (MVP)** — ver `PHASES.md`.
