# Cérebro nativo C++ (GDExtension)

Versão C++ do cérebro operacional (`MnBrain`), compilável neste repo com **SCons + g++**.
Espelha a lógica de `miami3d/core/*.gd` e carrega o mesmo `content/`.

```
native/
  SConstruct          ← build
  src/                ← C++ (MnBrain)
  godot-cpp/          ← bindings (clonado no setup; não commitado)
  bin/                ← .so gerado
build.sh              ← um comando: setup + compile
```

A biblioteca compilada é copiada para `../miami3d/bin/` e carregada por
`miami3d/bin/miami_brain.gdextension`.

## Compilar (Linux x86_64)

```bash
cd Miami_2/godot/native
./build.sh                 # debug (padrão)
./build.sh release         # release
./build.sh debug android   # arm64 Android (precisa NDK + config extra)
```

Requisitos: `g++`, `python3`, `scons` (`pip install scons`), `git`.

## Usar no Godot

1. Compile pelo menos uma vez (`./build.sh`).
2. Abra `miami3d/project.godot`.
3. O autoload `Bootstrap` prefere `MnBrain` (C++) se a `.so` estiver em `bin/`;
   senão cai no `MnGame` GDScript.

```gdscript
# exemplo direto
var brain = MnBrain.new()
brain.boot("res://content", "user://saves")
brain.new_game("Alex", "m")
brain.interact("fridge", "snack")
print(brain.snapshot())
```

## Android

Depois do NDK configurado no Godot:

```bash
./build.sh release android
```

Gera `libmiami_brain.android.template_release.arm64.so` em `miami3d/bin/`.
