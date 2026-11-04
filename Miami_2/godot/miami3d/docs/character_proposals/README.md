# Personagem principal — 4 propostas remaster (M + F)

Direção: **híbrido 2D/3D estilo Everwind** — volumes 3D estilizados + silhueta/leitura 2D,
fiel ao paper-doll Java (`RES_MANPARTS` / `RES_WOMANPARTS`) e ao vetor de 10 ints do remake.

```
[gênero, pele, cabelo, corCabelo, top, corTop, bottom, corBottom, calçado, corCalçado]
```

Slots Godot: `heads · hair · tops · bottoms · shoes` (`manifest.json`).

---

## Original (Java ME)

| | Path |
|--|------|
| Cabeça M | `06-sprites/35_RES_MANPARTS/0678_…` → [`original-head-m.png`](original-head-m.png) |
| Cabeça F | `06-sprites/36_RES_WOMANPARTS/0803_…` → [`original-head-f.png`](original-head-f.png) |
| Cabelo M0 / F0 | `0679_…` / `0804_…` |
| Faces | `34_RES_CHARACTER/0674_…` |

Criação original: **CRIAR PERSONAGEM** → gênero · nome · pele · cabelo · camisa (+ closet).

---

## Pipeline Everwind (implementação)

1. Um `Skeleton3D` compartilhado (`rig_human.glb`).
2. 5 malhas skinned trocáveis (paper-doll).
3. Tint de pele/cabelo/roupa via `ShaderMaterial` + índices de cor do vetor.
4. Opcional: billboard 2D do rosto para fala/emote (camada “2D dinâmica” no 3D).
5. Presets abaixo viram chips no `character_creator` — ver [`presets.json`](presets.json).

Mock UI: [`char-creator-everwind-mock.jpg`](char-creator-everwind-mock.jpg)

---

## As 4 propostas (homem + mulher)

### 01 — South Beach Classic
[`char-prop-01-south-beach-classic.jpg`](char-prop-01-south-beach-classic.jpg)

Remaster mais próximo do base MN2. Ideal como **default** do creator.

- M: camisa branca aberta · short teal · loafers  
- F: sundress coral · sandálias  

### 02 — Neon Nightlife
[`char-prop-02-neon-nightlife.jpg`](char-prop-02-neon-nightlife.jpg)

Fase club / romance. Rim light coral↔ciano alinhado à marca.

- M: blazer + camisa magenta · calça preta  
- F: cocktail branca · saltos  

### 03 — Art Deco Ambition
[`char-prop-03-art-deco-ambition.jpg`](char-prop-03-art-deco-ambition.jpg)

Carreira / high society. Silhueta limpa para paper-doll premium.

- M: blazer linho creme · calça bege  
- F: midi teal + cinto dourado  

### 04 — Ocean Drive Sun
[`char-prop-04-ocean-drive-sun.jpg`](char-prop-04-ocean-drive-sun.jpg)

Dia / praia / turismo. Alto contraste solar.

- M: polo teal · short branco · tênis  
- F: crop amarelo · short jeans · sandálias  

---

## Próximo passo (após escolha)

1. Congelar 1 proposta como **base mesh style** (proporção cabeça/corpo Everwind).  
2. Modelar packs `*_m_*` / `*_f_*` para os 5 slots cobrindo os vetores do preset.  
3. Ligar `character_creator` a preview 3D + chips P01–P04.  
4. Exportar thumbs para `assets/ui/previews/`.

**Neon Nightlife (02) IMPLEMENTADO** em `0.9.0-neon-nightlife`:
billboard Everwind + volume 3D + faces + avarias + `MnAnimController` (todos os clips).
Ver `assets/characters/neon_nightlife/`.
