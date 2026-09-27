# EVID-074 — Captura de runtime de Nyrelia para a SPEC-045

Data: 2026-09-27.

## Capturas produzidas

- `SPEC-045-nyrelia-runtime-baseline.png`: captura de Nyrelia em uma run de
  Dagruve, no renderer normal.
- `SPEC-045-nyrelia-qa-baseline-v3.png`: comparação de `idle`, `move_se` e
  `attack`, tanto na escala real de jogo quanto a 2,35x, com ponto lógico de
  chão explícito.
- `SPEC-045-nyrelia-pilot-frames.png`: os 14 frames do piloto congelados no
  `AnimatedSprite2D` que a run realmente usa.

As cenas `tools/nyrelia_qa.tscn` e `tools/nyrelia_qa_frames.tscn` existem
apenas para diagnóstico. Elas não são carregadas pela run normal.

## Constatações

1. O ponto de chão permanece estável nos três clips. A hipótese de flutuação
   por âncora de runtime não se confirmou.
2. `idle` e `move_se` têm silhueta muito pouco legível em escala real: a
   leitura fica concentrada em traços dourados e partículas.
3. Os quatro frames de `attack` não preservam uma figura corporal clara junto
   ao efeito, portanto não comunicam uma ação de personagem legível.
4. As cópias preservadas antes da normalização mostram o mesmo problema
   visual. Seus hashes diferem dos atuais, pois a normalização deslocou bytes,
   mas não há evidência de que ela tenha causado a falha de direção de arte.

## Resultado técnico

`tests/run_all.gd` terminou com `testes: 0 falha(s)`. O renderer normal salvou
as capturas; o modo headless permanece incapaz de fornecer imagem de viewport
para este projeto. Não foram gerados candidatos e nenhum asset oficial foi
substituído.

## Decisão pendente

A recomendação técnica é classificar `idle`, `move_se` e `attack` como
`regerar ou redesenhar manualmente`. Esta é uma recomendação, não uma decisão
canônica: o dono deve escolher entre manter a exceção, solicitar um brief de
retoque manual ou solicitar uma proposta de regeneração antes de qualquer
novo byte ser criado.
