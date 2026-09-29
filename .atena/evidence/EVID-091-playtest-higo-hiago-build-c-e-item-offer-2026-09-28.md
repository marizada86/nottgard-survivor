# EVID-091 — Respostas do questionário de playtest (build com painel `C` e escolha de item)

Data: 2026-09-28
Origem: questionário de [[PLAN-031-proximo-playtest-reavaliacao-e-questionarios-2026-09-28]]
(guia PDF enviado ao playtester).
Jogadores: **Higorino (Higo)** — dono/dev — jogando com assistência de
**Hiagola (Hiago)**, o playtester original desta rodada de feedback.

## Respostas literais

1. "Achei sozinho talvez algum lugar que indique a apertar 'c' para ver
   detalhes."
2. "Sim, mas sem muito detalhes, talvez a opção de ao passar o mouse em cima
   mostrar mais detalhes caso não esteja especifico."
3. "Sim, faltou as informações gerais do personagem, Ex: a foto ou o asset de
   jogo dele e embaixo o total de suas caracteristicas com os itens e efeitos
   aplicados."
4. "até gostei"
5. "Sim por enquanto"
6. "Não"
7. "Sim o Zumbi está transparente com pixel soltos, como leoric estava antes
   de ser consertado."
8. "Sim, candelabros, caixas, arbusto, depende do ambiente por exemplo caixas
   e candelabros não combinam com alguns mapas do abismo. seria bom o evento
   de loja no jogo."
9. "9"
10. "Adionar mais eventos aleatórios; os monstros normais não devem dropar
    poções, somente itens quebraveis(como no vampire survivors) e monstros
    maiores 'elite' e a chance deve ser baixa; a opção de clicar e segurar o
    clique esquerdo para andar é bem vinda(como em vampire survivors)."

## Achado técnico correlacionado (investigado nesta sessão)

A resposta 7 relata em Zumbi o mesmo padrão visual já visto em Leoric antes do
conserto. Comparação de código e arquivos:

- `ui/enemy_view.gd` declara Zumbi com célula `256×384` e frames
  `idle=4, move=6, attack=4, death=6`. Os quatro PNGs em
  `assets/animations/enemies/zumbi/` têm exatamente as dimensões esperadas
  (`1024×384`, `1536×384`, `1024×384`, `1536×384`) — sem divergência de grade
  ou contagem de frame.
- [[SPEC-038-integridade-visual-dos-inimigos]] já audita os 49 IDs de
  `data/enemies.json`, inclusive Zumbi, quanto a existência, importação,
  canal alfa e "conteúdo visível", e passou sem falhas em 2026-09-27 — antes
  desta sessão de playtest.
- Ou seja: a grade/dimensão está certa e o teste automatizado de alfa já
  passa, mas o relato humano ainda descreve o personagem como quase
  transparente com pixels soltos. Isso aponta para o mesmo tipo de problema
  que Leoric teve — cobertura de opacidade fraca dentro da arte gerada, que
  um teste de "tem algum pixel visível" não pega — e não para um bug de
  código de renderização (que já foi descartado por dimensão/import
  corretos).

Nenhuma alteração de arquivo foi feita para investigar isso — só leitura e
comparação.
