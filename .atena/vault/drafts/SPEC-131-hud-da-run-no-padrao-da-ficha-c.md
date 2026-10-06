---
id: SPEC-131
title: HUD da run (canto superior esquerdo) no padrão visual da ficha C
status: implemented-pending-playtest (2026-10-06); EVID-168; commit local aguarda aprovação
origin: pedido do dono (2026-10-06), "a HUD ao apertar C está muito boa, vamos seguir esse padrão"
cards: MEC-048
risk: baixo (UI da run; sem efeito no combate nem em números)
plan: PLAN-064 (por plano; side-plan, arquivos disjuntos do PLAN-062: ui/hud.*, ui/hero_panel.gd, tests/)
---

# SPEC-131

## Pedido
A HUD fixa da run (nome, PV, XP, `Moedas / Abates / CA / CAM`, dica `[C]`) ainda é a da primeira versão: texto cru, barras lisas, sem ícones. Atualizá-la para acompanhar a ficha C (SPEC-130), que o dono aprovou.

## Estado atual (lido no código, 2026-10-06)
- `StatBox` (`ui/hud.tscn`) com `NameLabel`, `HpBar`+`HpLabel`, `XpBar`, `InfoLabel`, `ActiveLabel`/`ActiveIcon` (ocultos desde a SPEC-127) e `ItemsHintLabel`; atualizada em `Hud.update_stats` (`ui/hud.gd`).
- A ficha C já tem os ícones `assets/icons/ui/{ca,cam,coin,kill,health,xp}.png`, retrato por herói (`assets/portraits/<id>.png`, 640×427), cores de atributo, paleta ferro/ouro velho e o texto de ajuda de CA/CAM (`CharacterSheet.defense_tip`).

## Decisões do dono (2026-10-06)
| # | Decisão |
|---|---|
| D1 | Aprovação **por plano**. |
| D2 | **Retrato pequeno** do herói à esquerda, com nome e nível ao lado. |
| D3 | Painel **translúcido com moldura fina** (versão leve da ficha C), sem competir com o combate. |
| D4 | Extras pedidos: **ícones de CA e CAM** (como na ficha C), **ícones das bênçãos ativas** e **atributos FOR/INT/CON/CAR**. |

## Escopo
1. Novo componente `ui/hero_panel.gd` (`HeroPanel`), montado por código como a ficha C, que substitui os nós de texto do `StatBox`:
   - retrato (quadrado, recorte centralizado), nome em ouro, `Nv N` em cinza, dica `[C] Ficha` à direita;
   - barra de PV com ícone de coração, valor `atual / máx`; a barreira vira uma faixa azul fina sobre a barra e `+N` no valor;
   - barra de XP fina (mantém o pulso da SPEC-116 D3);
   - linha de atributos `FOR / INT / CON / CAR` nas cores da ficha;
   - linha de chips com ícone e valor: moeda, abates, escudo CA e escudo CAM (valor e % de esquiva), com tooltip da ficha C;
   - fileira de ícones das bênçãos ativas (aparece só com bênção), com tooltip de nome, deus e descrição; sem ícone, quadrado com a inicial.
2. `Hud.update_stats` delega ao `HeroPanel`; as linhas do Estige continuam como texto sob o painel.
3. Remover os nós antigos do `hud.tscn` e do gerador `tools/build_scenes.gd`; ajustar `tests/test_ability_hud.gd`.
4. Tooltip de CA/CAM sem BBCode reaproveitando o texto de `CharacterSheet.defense_tip` (função estática de limpeza).

## Fora do escopo
Slot de habilidade (SPEC-127, não muda), cronômetro, barra do chefe, lista de armas, mudança de números ou de teclas, nova arte (moldura por código; ART-035 segue pendente).

## Lacunas
| ID | Pergunta | Severidade | Resolução |
|---|---|---|---|
| G1 | A HUD ficará mais alta que antes (~110 → ~170 px) | não bloqueia | Fundo translúcido (~70%); conferir em captura que não cobre o herói no canto. |
| G2 | Tooltip só por mouse (a HUD não recebe foco) | não bloqueia | A ficha C continua sendo o caminho por teclado/controle. |

## Critérios de aceite
- Painel com retrato, nome, nível, PV, XP, atributos, moedas, abates, CA e CAM com ícones; valores batem com `Hero`/`Battle`.
- Barreira visível sem texto longo; linhas do Estige preservadas.
- Fileira de bênçãos reflete `hero.boons` e some quando vazia.
- Tooltips de CA/CAM com o texto da ficha C.
- Sem erro de script quando falta ícone (retrato, bênção).
- Teste novo + `tests/run_all.gd` sem falhas + `tools/audit_projeto.gd` sem erros; capturas em 2 resoluções, com 3 heróis, registradas na EVID.

## Riscos e reversão
Baixo: UI isolada. Um commit isolado; reverter restaura o `StatBox` antigo. Não toca no combate.
