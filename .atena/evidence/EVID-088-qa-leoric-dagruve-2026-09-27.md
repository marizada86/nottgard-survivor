# EVID-088 — Captura QA: Leoric em Dagruve (playtest 2026-09-27)

Data: 2026-09-27
Origem: pacote de evidências exportado pelo kit de playtest (`core/playtest.gd`,
`F7`), perfil **qa**, recebido em
`NS-EV-qa-20260927-200612.zip` (fora do repositório, em
`%APPDATA%/Godot/app_userdata/Nottgard Survivors/evidence-kit/qa/outbox/`).
Cópia íntegra do conteúdo do ZIP em
`.atena/evidence/EVID-088-qa-leoric-dagruve-2026-09-27/` (manifesto, notas,
log, cenário QA e as 6 capturas).

## Proveniência (manifest.json)

- Jogo/versão: Nottgard Survivors 0.1.0, build `qa`, plataforma Windows.
- Sessão exportada em `2026-09-27T23:06:12Z`; notas entre `19:53:24` e
  `20:05:38` (hora local do log).
- Contexto no momento da exportação: herói **Leoric**, fase **dagruve**,
  regra **rituals**, nível 16, 24/24 PV, habilidade **constelação**, estado
  `levelup`.
- Campo `qa.cenario` registrado em todas as notas: `qa.durao.running`, seed
  `1001` — herdado da última navegação pelo Navegador QA (`qa/scenario.json`
  confirma `stage_id=durao`, `hero_id=nyrelia`). A run efetivamente jogada nas
  notas é em **Dagruve com Leoric**, ou seja, o playtester saiu do cenário QA
  navegado e seguiu jogando normalmente; o rótulo `qa.cenario` ficou
  desatualizado em relação ao contexto real das notas. Não há evidência de
  perda de dados — é uma imprecisão de rotulagem, registrada aqui para
  decisão em [[SPEC-020-ferramentas-playtest-e-qa]] / [[SPEC-050-atalho-f4-navegador-qa]].
- `log.txt` mostra a sequência real da sessão: quatro runs anteriores
  (`durvall`/dagruve, QA/durao, `nyrelia`/durao, todas com derrota rápida) até
  a run de `leoric em dagruve` às `19:41:29`, que é a run coberta pelas notas.

## Notas do playtester (transcrição completa em `notas.md`)

| # | Hora | Tema | Resumo |
|---|---|---|---|
| 1 | 19:53:24 | UX — tela de level-up | Pedido de navegação só por teclado (WASD + Enter) para escolher recompensas/opções. |
| 2 | 19:58:29 | UX — menu de pausa (Esc) | Pedido de catálogo de itens (desbloqueados visíveis, bloqueados escurecidos/sem info), tela de opções/configurações e um guia de "como jogar" (referência ao próprio guia usado em outro jogo do playtester, "nottcard"). |
| 3 | 19:59:49 | HUD | Pedido de barra de progresso do tempo restante da fase/mapa. |
| 4 | 20:02:03 | HUD — ficha de personagem | Pedido de tecla (`C`) para abrir efeitos/itens/magias/bênçãos coletados na run atual. |
| 5 | 20:04:43 | Legibilidade visual | Números de dano pequenos/escuros; pedido de aumentar tamanho/contraste, citando "Death Must Die" e "Vampire Survivors" como referência. |
| 6 | 20:05:38 | **Bug** | "O personagem Leoric está funcionando mas seu asset está bugado, quase transparente com pixel soltos." |

## Inspeção visual das 6 capturas

As seis capturas (`screenshots/001-nota.png` a `006-nota.png`) mostram a HUD,
o nome "Leoric · Nv 15" e a barra de vida normalmente, mas em nenhuma delas há
um sprite de personagem claramente visível na posição esperada do jogador (o
ponto de mira/anel laranja que acompanha a câmera). Isso é consistente com o
relato da Nota 6: o sprite oficial de Leoric (admitido em
[[EVID-081-leoric-admissao-oficial-2026-09-27]], no mesmo dia) não está sendo
desenhado de forma visível durante a run real, apesar de a verificação estática
de `EVID-081-leoric-oficial-runtime-v01.png` (atlas em fundo neutro, fora de
cena) ter sido considerada válida.

## Observação sem confirmação

Não foi possível, só com esta evidência, isolar a causa (alfa do PNG,
`self_modulate`/material herdado, escala, camada de desenho, ou conflito com a
sobreposição visual de divindades de [[SPEC-056-sobreposicao-visual-das-divindades]]
introduzida na mesma janela de tempo). Investigação fica registrada como
próximo passo em [[PLAN-029-triagem-evidencia-qa-leoric-e-ux-2026-09-27]].
