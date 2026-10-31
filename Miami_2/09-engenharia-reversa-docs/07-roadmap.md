# 07 — Roadmap de implementação

Fases ordenadas por dependência técnica. Cada fase tem um critério de "pronto" verificável.
Não há estimativas de calendário: o tamanho é dado pelos componentes envolvidos.

> **Plano operacional completo (cérebro + arquivos + inventário + expansão):**  
> [`08-plano-progressivo-godot.md`](08-plano-progressivo-godot.md) — use esse documento
> ao pedir “implementa a próxima fase”.

## Fase 0 — Repositório e ferramentas (este PR)

* Documentação de engenharia reversa (`docs/01–04`).
* Ferramentas de extração (`tools/`) para gerar referências locais a partir do JAR.
* Schemas e exemplos de conteúdo (`schemas/`, `content/`).

**Pronto quando:** `tools/mn2_unpack.py` + `mn2_strings.py` + `mn2_asprite.py` +
`mn2_rooms.py` rodam sem erro sobre o JAR e os JSON de exemplo validam contra os schemas.

## Fase 1 — Núcleo de simulação (sem gráficos)

Componentes: `core/` (time, stats, relationship, economy, schedule, quest_machine,
rule_interpreter, content_registry, save). Testes unitários cobrindo taxas por hora, limiares,
colapso de necessidade, decaimento de relacionamento, máquina de missão de exemplo.

**Pronto quando:** um "jogo de texto" em linha de comando roda um dia inteiro com um NPC e
uma missão usando apenas JSON de `content/`.

## Fase 2 — Mundo 3D mínimo

Componentes: projeto Godot, câmera 3/4, 1 local (apartamento LOW) com grade lógica, portal
para 1 rua (First Street), *tap-to-move*, A\* em grade, 3 objetos com ações (cama, chuveiro,
geladeira), HUD de necessidades, ciclo de luz 24 h.

**Pronto quando:** o jogador vive 1 dia completo satisfazendo as 4 necessidades em APK no
dispositivo.

## Fase 3 — Personagem modular e NPCs

Componentes: rig humanoide, 5 slots de paper-doll, criação de personagem, `AnimationTree`,
`Npc.tscn` com rotina, população genérica, menu social com os 4 menus e assuntos.

**Pronto quando:** é possível criar um personagem, conversar com 3 NPCs e subir amizade a 2
estrelas; NPCs aparecem/somem conforme horário.

## Fase 4 — Missões, economia e empregos

Componentes: interpretador de regras completo, agenda/telefone, mapa da cidade, banco,
aluguel, 4 empregos, prólogo (missões 0–5) e arco do apartamento (12–22) como conteúdo.

**Pronto quando:** o prólogo é jogável do início ao apartamento, com aluguel cobrado na
primeira semana.

## Fase 5 — Locais e conteúdo de paridade

Componentes: os 25 locais (11 kits de cena), 99 missões, 60 móveis, closet/boutique,
clínica, animais, minigame de dança, encontros, anões, mansão.

**Pronto quando:** checklist de `04-inventario-de-conteudo.md` coberto; a história
principal fecha ("Sua Própria História").

## Fase 6 — Polimento Android e lançamento

Componentes: otimização (LOD, atlas, Compatibility renderer), *safe area*, localização
(pt-BR + en), AAB assinado, *crash reporting*, *store listing*.

## Fase 7 — Expansibilidade

Componentes: carregamento de packs em `user://mods`, validador CLI, editor simples de
rotinas/missões (pode ser uma cena Godot em modo ferramenta), documentação para criadores.

**Pronto quando:** um pack externo adiciona um local + NPC + missão sem recompilar o APK.

## Ordem sugerida de locais (por valor/custo)

1. Apartamento LOW (14) — menor, tutorial.
2. First Street/Downtown (0) — hub, delegacia ao lado.
3. Delegacia (1) — prólogo.
4. South Beach (9) — maior e mais icônico; vale o investimento de kit.
5. Restaurante Yuca (12), Glight Club (2), Escritório do Jornal (3), Estádio (4) — empregos.
6. Little Havana (11), Ocean Drive (13), Coconut Grove (7), Lounge (8), Clínica (5).
7. Apartamentos de NPC, mansão, Everglades, porto/iate, Pelican Island, Key Biscayne.
