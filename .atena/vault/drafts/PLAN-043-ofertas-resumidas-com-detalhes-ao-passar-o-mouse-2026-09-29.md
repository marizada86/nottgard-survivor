---
id: "PLAN-043"
title: "Ofertas resumidas: informação principal no cartão, detalhes e comparação ao passar o mouse"
status: "implementado em 2026-09-29 (fases 1 a 5), validação em playtest"
created: "2026-09-29"
relations:
  - "[[SPEC-059-descricao-de-itens-e-slots-visiveis]]"
  - "[[SPEC-081-comparacao-de-equipamento]]"
  - "[[SPEC-082-loja-e-ferreiro-mostram-todas-as-opcoes]]"
  - "[[SPEC-087-fidelidade-e-eventos-de-risco]]"
---

# PLAN-043 — Ofertas resumidas, detalhes no hover

## Pedido do dono (2026-09-29)

Na tela "Item encontrado — equipar ou manter?" (print de referência) o texto está
pesado: a lista de atributos aparece duas vezes (`Contra o atual` repete tudo que
o item já mostra), com preço de venda e Fidelidade empilhados. Deixar **só o
principal no cartão** e mover **detalhes e comparações para o mouse por cima**.
Vale também para **lojas** (loja, ferreiro, curandeiro), **aprimoramentos**
(subida de nível, ferreiro, evolução) e demais ofertas (altar, doação, aposta).

## Diagnóstico

- Todas as ofertas usam o mesmo modelo: `{t, name, desc, tooltip?}`, e `desc` é um
  texto único com `\n` (`core/battle.gd:1421-1548`, `1601-1702`).
- `ui/hud.gd:177-221` desenha tudo num `Button` de texto (`btn.text`), 620×62 px,
  e só usa `tooltip_text` para uma segunda lista de atributos.
- No print, o cartão 2 repete 3 vezes a mesma informação: mods do item, `Contra o
  novo` (o inverso exato do cartão 1) e preço. O jogador não vê de relance
  "melhora ou piora?".

## Princípio de design

1. **Cartão = decisão em 2 segundos:** nome, raridade, ícone, 1 linha de destaque,
   1 selo de veredito, preço quando houver.
2. **Hover = auditoria:** tudo o que hoje está no texto, organizado em tabela.
3. **Nada que mude a decisão some do cartão:** maldição do altar, custo, "faltam N
   moedas" e "sem efeito" ficam visíveis.
4. **Sem mudança de regra, número ou economia.** Só apresentação.

## Anatomia do cartão (novo)

```
[ícone]  1. Cajado Feroz da Raposa  [raro]              ▲ 4  ▼ 3
         +1 INT, +1 CAM, +16% dano                       vende o atual: 16
```

- **Linha de destaque:** até 3 atributos mais relevantes do item (ver "Relevância").
- **Selo de veredito (só em troca de item/loja):** `▲ n` atributos que sobem (verde),
  `▼ n` que descem (vermelho); `=` cinza se nada muda.
- **Preço/venda** alinhado à direita, em ouro; cartão travado mostra `faltam N`.
- Cor do nome continua sendo a raridade (ART-016).

## Conteúdo do hover (painel customizado)

Duas colunas + diferença, cores por sinal:

```
                     Novo             Atual (Cetro Blindado Nv 1)     Diferença
INT                  +1               —                                ▲ +1
CAM                  +1               —                                ▲ +1
Recarga              +9%              —                                ▲ +9%
Dano                 +16%             —                                ▲ +16%
Coleta               +0.4             —                                ▲ +0.4
CAR                  —                +1                               ▼ -1
Área                 —                +5%                              ▼ -5%
CA                   —                +2                               ▼ -2
Vende o atual por 16 moedas · Fidelidade 2/3 (manter 3 vezes seguidas sobe o nível)
```

Conteúdo por tipo de oferta:

| Oferta | Cartão | Hover |
|---|---|---|
| Item achado (`item_swap`) | nome, raridade, 3 destaques, ▲/▼, valor de venda do outro | tabela novo × atual × diferença; Fidelidade; efeito da arma concedida |
| Loja (`shop_item`) | nome, raridade, preço, chip `Slot livre` ou `Substitui <item>`, ▲/▼ | tabela contra o equipado; preço e saldo após a compra |
| Ferreiro (`shop_item_up`, `shop_weapon_up`) | `Nv 2 → 3`, ganho principal, preço | Nv atual × seguinte lado a lado, ganho completo, bônus final do super-upgrade |
| Curandeiro (`shop_heal`) | `Cura completa`, PV restaurados, preço | PV antes → depois |
| Subida de nível (`weapon_up`, `passive`, `weapon_new`, `evolve`, `synergy_activate`) | nome, tag (SINERGIA/DEFESA/NOVA DIREÇÃO), efeito em 1 linha | descrição completa, nível antes → depois, dica de evolução, herói que sinergiza |
| Altar (`boon`) | nome do deus, **bênção 1 linha + maldição 1 linha** | descrição completa e `_boon_effect_desc` |
| Doação/aposta | `Perde: … / Ganha: …` curto | detalhes e odds |
| Sair, info | inalterados | — |

## Modelo de dados

Cada oferta passa a carregar campos estruturados, mantendo `desc` para os testes
antigos e para o modo sem UI:

- `brief` (String): linha de destaque do cartão.
- `badge` (Dictionary opcional): `{up:int, down:int}` ou `{text, color}`.
- `price_text` (String): direita do cartão.
- `detail` (Dictionary): `{title, columns:[...], rows:[{label, cols:[...], delta}], footer:[...]}`,
  renderizado pelo painel de hover. `tooltip` textual antigo vira fallback.

Geração concentrada em `core/items.gd` (`Items.brief_text`, `Items.compare_table`)
e chamadas de `core/battle.gd` (`give_item`, `_open_shop_event`, `_open_risk_event`,
`_offer_pool`). A tabela usa `Items.diff_mods`, já testado.

## Relevância dos destaques

Escolher 3 atributos por **peso fixo por tipo** (dano, recarga, velocidade, PV e CA
acima de coleta/moedas), desempatando pelo maior valor absoluto; para a diferença,
o de maior |delta| ponderado. Tabela de pesos em `Items.STAT_WEIGHT`, sem tocar em
`hero.recalc()`. Depois pode ficar por herói (INT para mago), fora deste plano.

## Interface (Godot)

- Novo `ui/offer_card.gd` (`extends Button` ou `PanelContainer`) com `setup(offer)`
  que monta: `HBox[ícone | VBox[nome, brief] | VBox[badge, preço]]`. Substitui o
  `btn.text` em `ui/hud.gd:182`.
- Hover: `_make_custom_tooltip(for_text)` devolve um `PanelContainer` com grade
  (`GridContainer` + `RichTextLabel`), cores de sinal, fundo do tema do HUD.
  Atraso do tooltip reduzido para ~0,15 s (`gui/timers/tooltip_delay_sec`) só nesta
  tela, ou popup próprio via `mouse_entered` se o global incomodar.
- **Teclado:** atalhos 1–9 continuam escolhendo. Adicionar **Shift (segurar)** ou
  **Tab** para expandir o detalhe do cartão focado, para quem joga sem mouse.
- Cartão travado (sem moedas) continua com hover ativo (Godot mostra tooltip em
  botão desabilitado; a verificar).
- Largura do painel e altura do cartão diminuem; ganha espaço para 3-4 ofertas
  sem rolagem.

## Fases

| Fase | Entrega | Verificação |
|---|---|---|
| 1 | `Items.brief_text`, `compare_table`, `STAT_WEIGHT`; campos novos nas ofertas de item/loja/ferreiro | `tests/test_battle.gd`: `brief` ≤ 3 atributos, ▲/▼ batem com `diff_mods`, `desc` antigo preservado |
| 2 | `ui/offer_card.gd` + tooltip customizado; `hud.gd` usa o cartão | Godot headless carrega; captura de tela do cartão e do hover (item, loja, ferreiro) |
| 3 | Subida de nível, altar, doação/aposta, curandeiro | Captura de cada tipo; maldição do altar visível no cartão |
| 4 | Teclado (Shift/Tab), atraso do tooltip, ajuste de fonte/contraste | Playtest curto; sem regressão nos atalhos 1–9 e no rerrolar (R) |
| 5 | Documentação: SPEC-094, MEC-027, EVID, nota em RELEASES | `tools/backlog_check.ps1` sem alertas |

## Riscos

- **Tooltip em jogo pausado:** confirmar que o HUD processa tooltips durante a
  pausa da oferta (hoje funciona com `tooltip_text`, então tende a passar).
- **Descoberta:** jogador pode não saber que há detalhes. Mitigar com dica
  `passe o mouse para comparar` no rodapé do painel e selo ▲/▼ que já convida.
- **Regressão de texto:** testes atuais procuram `Contra o atual: …` em `desc`
  (`tests/test_battle.gd:630`); por isso `desc` fica preservado.
- **Peso de destaque errado:** um atributo importante fora do top 3 some do cartão;
  o selo ▲/▼ e o hover cobrem, e o peso é tabela ajustável.
- **Dispositivo sem mouse:** coberto só pelo atalho de teclado; toque não é escopo.

## Decisões pedidas ao dono

1. **Selo de veredito** `▲ 4 ▼ 3` (contagem) ou `melhor em: INT, CAM / pior em: CAR`
   (nomes)? Recomendo contagem no cartão e nomes no hover.
2. **Ver detalhes sem mouse:** segurar Shift, Tab, ou ignorar por ora? Recomendo Shift.
3. **Altar:** manter bênção e maldição sempre visíveis no cartão (recomendado) ou
   esconder a maldição no hover?
4. Aplicar já em **todas** as telas de oferta (recomendado, o cartão é reaproveitado)
   ou só item achado + loja na primeira build?

## Encaixe no backlog

Nova mecânica **MEC-027** (UX, risco médio, sem números) + **SPEC-094**, uma
mecânica por commit, conforme `add.yaml`. Não altera balanceamento. Critério de
aceite: um jogador novo, sem ler texto longo, diz se o item novo é melhor ou pior
que o atual, e o hover confirma o porquê.
