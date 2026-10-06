---
id: SPEC-126
title: Bênção opcional no altar (poder recusar todas as opções)
status: implemented-committed
origin: playtest-t04-manzi-2026-10-05
card: MEC-046
evidence: EVID-163
risk: baixo
plan: PLAN-060 (por plano)
---

# SPEC-126

## Pedido
Manzi (T04, IN-056): a oferta de bênção não permite não escolher nenhuma. Algumas bênçãos têm desvantagem (ex.: Fontes curam só metade); o jogador deve poder recusar.

## Estado atual (lido no código)
`Battle._open_altar()` (`core/battle.gd:~1961`) monta 3 ofertas `{"t": "boon", ...}` e entra em `state = "altar"` com `offer_kind = "altar"`. `choose(i)` aplica a oferta e volta a `running`. Não existe oferta de recusa. O padrão de "manter" já existe nas ofertas de item (MEC-021).

## Decisões do dono (2026-10-05)
- Recusar **consome o altar, sem prêmio** (`it.used` permanece; sem ouro, PV ou outro ganho).
- Aprovação por plano.

## Escopo
1. Acrescentar às ofertas do altar uma quarta opção fixa **"Recusar a bênção"** (`t: "skip"`), sempre no fim, com texto curto ("Seguir sem bênção. O altar se apaga.").
2. `choose(i)` com `t == "skip"`: não adiciona bênção, não altera `visual_god`/`visual_boon_selected`, registra um evento `toast` ("Você recusou a bênção.") e volta a `running`.
3. A interface de oferta (`ui/hud.gd`, `ui/offer_card.gd`) mostra a opção como cartão discreto (sem selo de ganho/perda) e aceita teclado, mouse e controle como as demais.
4. Contagem: `stats` ganha `boons_declined` (apenas contador; sem efeito em jogo).

## Fora do escopo
Novas bênçãos e entidades (MEC-047), balanceamento das bênçãos (BAL-019), outros tipos de oferta (level-up, item, pacto), recompensa por recusar.

## Critérios de aceite
- Altar com 3 bênçãos + "Recusar" visível; escolher "Recusar" não muda `hero.boons`, volta a `running` e o altar não reabre.
- Nenhuma regressão: escolher uma bênção continua igual (incl. afinidade divina e visuais).
- Se o herói já tem todas as bênçãos (`offer` só com a recusa), o altar abre com a opção de recusa em vez de não abrir (ou o comportamento atual é mantido e documentado).
- Teste novo em `tests/` (recusa não altera bênçãos; estado volta a `running`); `tests/run_all.gd` 0 falhas; `tools/audit_projeto.gd` 0 erros.

## Riscos e reversão
Baixo; um commit isolado (`git revert`). Bot (`tools/bot.gd`, `bot_curva.gd`) escolhe ofertas por índice: conferir que não passa a escolher a recusa por engano.

## Resultado (2026-10-05)
Implementada no commit `048832e`; evidência em EVID-164. Ajuste em relação à spec: o altar da doação (MEC-005) não oferece recusa, para não perder o item sem bênção.
