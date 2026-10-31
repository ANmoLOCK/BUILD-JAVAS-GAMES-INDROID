# Menu principal — original Java × propostas Miami Life

Referência extraída do JAR (`menutitle.png` + packs de strings) e **duas** propostas visuais
alinhadas à marca atual (logo coral→ciano, hero de praia, HueHueGames).

**Sugestão B implementada** em `game/flow/main_menu.tscn` (v0.8.1). HueHueGames no canto inferior esquerdo; Opções / Ajuda / Créditos / Resetar ativos.

---

## Como era no Java (Miami Nights 2)

### Arte de título
- Arquivo: `01-jar-extraido/menutitle.png` (320×240, paleta indexed)
- Cópia aqui: [`original-menutitle.png`](original-menutitle.png) · zoom ×4 [`original-menutitle-x4.png`](original-menutitle-x4.png)
- Cena: quatro personagens fashion, hotel neon, praia ao fundo, logo **MIAMI NIGHTS 2** + *the city is yours* · © 2009 Gameloft

### Fluxo (máquina de estados)
```
SPLASH → LOGO → MENU PRINCIPAL ─┬─ NOVA PARTIDA → criar personagem → prólogo → JOGO
                                 └─ CONTINUAR → JOGO
```

### Itens do MENU PRINCIPAL (`pack00`)
| # | String original | Papel |
|---|-----------------|-------|
| 23 | CONTINUAR | Retoma save |
| 24 | NOVA PARTIDA | Novo jogo / criador |
| 26 | OPÇÕES | Som, vibração, autosave, setas, dicas |
| 27 | AJUDA | Controles / tutorial |
| 28 | SOBRE | Versão + créditos (pages 34–52) |
| 29 | SAIR DO JOGO | Confirma saída |
| 75 | REDEFINIR JOGO? | Confirma wipe de progresso |
| 25 | MAIS JOGOS! | Cross-promo Gameloft — **não** portar |

### Pausa in-game (`pack01`)
CONTINUAR · MAPA · OPÇÕES · AJUDA · SALVAR · MENU PRINCIPAL · SAIR DO JOGO

### Opções típicas (`pack00` 66–73)
SOM · VIBRAÇÃO · AUTOSALVAR · SETAS AUXIL. · DICAS · LIG./DESL.

---

## Mapeamento → Miami Life

| Original | Proposta Miami Life | Nota |
|----------|---------------------|------|
| NOVA PARTIDA | Nova partida | Mantém |
| CONTINUAR | Continuar | Desabilitado sem save |
| OPÇÕES | Opções | Som / autosave / dicas (vibração Android) |
| AJUDA | Ajuda | Controles touch + tip |
| SOBRE | Créditos | HueHueGames + aviso humorístico do pack |
| REDEFINIR JOGO? | Resetar jogo | Confirmação modal |
| SAIR DO JOGO | Sair | |
| MAIS JOGOS! | — | Removido |

---

## Sugestão A — Lista clássica centrada

Arquivo: [`miami-life-menu-sugestao-a.jpg`](miami-life-menu-sugestao-a.jpg)

- Hero full-bleed + scrim leve
- Logo + tagline no topo
- Lista central CAPS, foco com underline coral→ciano
- Mais fiel ao Java ME (só texto, sem painel)
- Ideal se quiser “menu de celular clássico” modernizado

## Sugestão B — Trilho direito / marca à esquerda

Arquivo: [`miami-life-menu-sugestao-b.jpg`](miami-life-menu-sugestao-b.jpg)

- Hero à esquerda (marca dominante)
- Trilho escuro à direita com os mesmos 7 itens
- Foco com barra + fill gradient da marca
- Linha de status (`fase · save`) — útil no remake atual
- Casa melhor com o landscape 1280×720 já usado no APK

---

## Comparativo rápido

Abrir [`index.html`](index.html) no browser.

Quando escolher A ou B (ou um híbrido), o próximo passo é reescrever
`game/flow/main_menu.tscn` + `.gd` e espelhar itens em `pause_menu`.
