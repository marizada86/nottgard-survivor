---
id: SPEC-130
title: Ficha C reorganizada em abas, grade de ícones e painel de detalhe
status: accepted-by-owner (2026-10-06, testado); commit 7c4da5d; EVID-167; ART-035 (prompts) pendente
origin: playtest-t04-manzi-2026-10-05 + entrevista de layout com o dono (2026-10-06)
cards: MEC-045, ART-035
evidence: EVID-163
intake: IN-055 (+ observação final do Manzi sobre CA/CAM, registrada como IN-058)
risk: médio (UI de pausa; sem efeito no combate)
plan: PLAN-063 (por plano, aprovado pelo dono em 2026-10-06; layout primeiro)
---

# SPEC-130

## Pedido
Manzi (T04): a ficha C tem informação demais; espaçar, distribuir e agrupar itens, equipamentos e magias em categorias; criar prompts para embelezar. Observação final do Manzi: **CA e CAM não são claros**; algo deve explicar o que são.
Referências do dono: Castlevania, Blasphemous, Dead Cells, Vampire Survivors e Megabonk (simplicidade que funciona).

## Estado atual (lido no código, 2026-10-06)
- `ItemsPanel` (`ui/hud.tscn`): painel único de 560 px; cabeçalho (retrato 150×100, linha de herói, linha de atributos/PV/CA/CAM, linha de bônus), linha de slots, `ScrollContainer` de 360 px com um `RichTextLabel` que mistura habilidade, armas, passivas, equipamento, bênçãos e sinergias (`Hud.show_items_panel`, `ui/hud.gd:435`).
- O jogo fica pausado enquanto a ficha está aberta (`ui/run.gd:314`). Resolução base 1280×720.
- Dados já disponíveis: ícones em `assets/icons/{weapons,items,passives,boons,abilities}` e **`assets/icons/ui/ca.png` e `cam.png`**; equipamento tem 4 slots fixos (`Items.SLOTS`: arma, armadura, amuleto, anel); armas têm `4 + weapon_slots` slots; raridades: comum, mágico, incomum, raro, único.

## Decisões do dono (entrevista, 2026-10-06)

| # | Decisão |
|---|---|
| D1 | **Abas + painel de herói fixo** à esquerda. |
| D2 | Dentro de cada aba, **grade de ícones** com **painel de detalhe** do item em foco. |
| D3 | Detalhe **embaixo da grade, largura total** da área de abas. |
| D4 | **4 abas:** Armas e feitiços · Equipamento · Passivas e bênçãos · Sinergias e bônus totais. |
| D5 | Navegação: **Q/E (teclado) e LB/RB (controle)** trocam de aba; **setas/direcional** movem o foco entre itens; **mouse** clica nas abas e passa sobre os itens. |
| D6 | Coluna do herói sempre visível: retrato, nome e nível; atributos FOR/INT/CON/CAR; PV, CA e CAM com % de esquiva. |
| D7 | **Habilidade ativa (Q/RMB)** como **cartão fixo na coluna do herói**, abaixo de PV/CA/CAM (ícone, nome, descrição curta, recarga efetiva). Substitui a seção de texto da SPEC-127 na lista. |
| D8 | **CA e CAM explicados** por tooltip ao passar o mouse **e ao focar** (teclado/controle), com **ícones de escudo** (`ca.png`, `cam.png`) ao lado do número. |
| D9 | Estilo: **gótico sombrio limpo**. Fundo quase preto, moldura fina em ferro/ouro velho, cantos ornamentados discretos; ornamento só nas bordas, nunca atrás do texto. |
| D10 | Raridade e estado na grade: **borda do slot por raridade**, **selo de nível** no canto do ícone (com marca de máximo), **brilho/seta em arma pronta para evoluir**, **slots vazios visíveis** (ex.: armas 2/6, equipamento 3/4). |
| D11 | Painel **quase tela cheia (~85%)** com o jogo escurecido atrás. |
| D12 | Bônus totais: **lista com ícone e valor, agrupada** (ofensivo, defensivo, utilidade), na 4ª aba, no lugar da linha única de texto. |

## Layout (1280×720, painel de ~1090×610)

```
┌─────────────────────────────────────────────────────────────────────────────┐
│  FICHA                                                          [C / Esc]   │
├───────────────────┬─────────────────────────────────────────────────────────┤
│ [retrato]         │  ◂Q  [Armas] [Equipamento] [Passivas/Bênçãos] [Bônus] E▸ │
│ Sylas — Nv 8      ├─────────────────────────────────────────────────────────┤
│                   │                                                         │
│ FOR 12   INT 8    │   ┌──┐ ┌──┐ ┌──┐ ┌──┐ ┌╌╌┐ ┌╌╌┐                         │
│ CON 10   CAR 9    │   │⚔ │ │⚔ │ │⚔ │ │⚔ │ ╎  ╎ ╎  ╎   ← grade da aba         │
│                   │   └Nv┘ └Nv┘ └Nv┘ └Nv┘ └╌╌┘ └╌╌┘     (slots vazios)       │
│ PV 74/90          │                                                         │
│ [CA] 14  (28%)    ├─────────────────────────────────────────────────────────┤
│ [CAM] 11 (20%)    │  DETALHE DO ITEM EM FOCO (largura total)                │
│                   │  Nome · raridade · Nv x/y                               │
│ ┌ HABILIDADE ───┐ │  Descrição, dano mín./máx. (FOR/INT), dica de evolução  │
│ │ [ícone] Nome  │ │                                                         │
│ │ desc. · 12 s  │ │                                                         │
│ └───────────────┘ │                                                         │
└───────────────────┴─────────────────────────────────────────────────────────┘
```

- Coluna do herói: ~270 px. Área de abas: ~800 px. Grade com slots de ~72 px e espaçamento de 12 px.
- Aba **Armas e feitiços:** armas e feitiços (inclui os `granted`, marcados). **Equipamento:** 4 slots fixos em uma fileira. **Passivas e bênçãos:** duas fileiras (passivas, depois bênçãos com o deus). **Sinergias e bônus totais:** sinergias por camada e a lista agrupada de bônus; aba sempre presente (mostra "nenhum" quando vazia) para não mudar a ordem dos atalhos.
- Aba ativa com destaque; indicação de Q/E ou LB/RB nas pontas; troca por clique.
- Foco inicial: primeiro item da aba; ao trocar de aba, foco volta ao primeiro item. A aba vazia mostra texto curto ("Nenhum feitiço ainda"), nunca um painel em branco.

## Escopo
1. Reconstruir `ItemsPanel` em `ui/hud.tscn`/`ui/hud.gd` conforme D1 a D12, preservando `show_items_panel(b)`, `hide_items_panel()`, o sinal `items_closed` e o fechamento por C/Esc/botão.
2. Reaproveitar `Items.mods_text`, `Battle.weapon_damage_text`, `evolve_hint`, `active_def`/`active_cooldown_effective` (SPEC-127) e os ícones existentes; sem ícone, usar quadrado neutro com a inicial (sem erro de script).
3. Tooltips de CA e CAM com texto novo (ver D8), acessíveis por foco.
4. Entrada de controle: `LB/RB` e direcional, sem conflito com a pausa; `Q/E` só atuam com a ficha aberta (o jogo está pausado).
5. **ART-035:** moldura do painel, moldura de slot (um conjunto por raridade ou uma moldura neutra tingida por código), ícones de aba (4) e fundo do detalhe. Prompts escritos **depois** da aprovação deste layout; imagens geradas só com aprovação (cota e custo).

## Fora do escopo
Boneco de equipamento (silhueta por herói), reordenar/descartar itens, comparar itens, nova arte de ícones de itens/armas (ART-034 dispensado), mudança de números do jogo, mudança de teclas fora da ficha.

## Lacunas abertas
| ID | Pergunta | Severidade | Sugestão |
|---|---|---|---|
| G1 | Texto exato dos tooltips de CA/CAM (o jogo usa regra tipo D&D: CA reduz a chance de ser atingido por dano físico; CAM, por dano mágico) | não bloqueia | Escrever na spec de execução e validar com o dono. |
| G2 | Em resolução menor que 1280×720, o painel de ~85% reduz ou ativa rolagem na grade? | não bloqueia | Escalar o painel pela janela (stretch já é `canvas_items`); testar em 2 resoluções. |
| G3 | Cores exatas de raridade (cinza, azul, verde, dourado, vermelho/roxo) e acessibilidade (o nome também carrega a cor) | não bloqueia | Fixar na execução e conferir contraste. |
| G4 | Quantas fileiras de passivas cabem (28 ícones de passiva no jogo; máximo simultâneo ainda não verificado) | não bloqueia | Verificar `h.passives` máximo; a grade quebra em linhas e rola se passar. |

## Critérios de aceite
- Ficha em 4 abas navegáveis por clique, Q/E, LB/RB; foco por setas/direcional; detalhe do item em foco abaixo da grade.
- Nenhum bloco de texto longo na ficha fora do painel de detalhe e dos cartões; a coluna do herói nunca rola.
- Habilidade (SPEC-127) como cartão na coluna do herói; valores batem com `abilities.json` e `cd_pct`.
- CA e CAM com ícone e tooltip por mouse e foco; texto aprovado.
- Slots vazios, borda por raridade, selo de nível e indicador de evolução visíveis; verificação com herói em início de run e com herói cheio (4 armas + bônus, 4 equipamentos, várias passivas e bênçãos).
- Sem ícone para um item: sem erro de script.
- Teste novo (mapeamento aba→conteúdo, contagem de slots, texto dos tooltips, fallback de ícone); `tests/run_all.gd` 0 falhas; `tools/audit_projeto.gd` 0 erros.
- Capturas em 3 heróis e 2 resoluções registradas na EVID.

## Riscos e reversão
Médio: reescreve a UI de pausa. Um commit isolado; se a grade ou a navegação por controle falharem, reverter o commit restaura a ficha da SPEC-127. Não toca no combate.
