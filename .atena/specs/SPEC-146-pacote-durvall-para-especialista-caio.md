---
id: "SPEC-146"
title: "Pacote .zip de assets e prompts do Durvall para o especialista Caio"
status: "IMPLEMENTADA localmente em 2026-10-08 (PLAN-079); envio feito pelo dono"
origin: planned
implementation_preceded_spec: false
request_classification: PLAN_DEVIATION
created: "2026-10-08"
cards: ["BUG-028", "BUG-025"]
relations: ["[[PLAN-079-pacote-durvall-caio-2026-10-08]]", "[[EVID-197-diagnostico-instrumentado-do-patinar-bug-028-2026-10-07]]"]
---

# SPEC-146 — Pacote do Durvall para o Caio

Pedido do dono (2026-10-08): "compile os assets de durval e seus prompts em um .zip para eu enviar para o especialista Caio
tentar resolver". O dono envia o arquivo; Atena só gera o .zip local (nenhum envio, publicação ou commit).

## Conteúdo (escolha do dono: pacote enxuto com contexto)

1. `assets/`: tiras de `assets/animations/heroes/durvall/` (13 PNGs, com `move_w/nw/sw` marcadas como não usadas em jogo),
   `assets/heroes/durvall.png` e `assets/portraits/durvall.png`.
2. `prompts/`: ART-PROMPTS-002, 015, 016, 055, CHATGPT-FILA-024, guia de poses do PLAN-066 e os `generation-prompts-v01` e
   `review-manifest` do `durvall-animation-package`.
3. `historico/`: SPEC-018 e EVID-169 a EVID-175 (tentativas anteriores de movimento/corrida).
4. `diagnostico/`: resumo do BUG-028, EVID-197 e `stride.csv`.
5. `LEIA-ME.md`: o problema, o contrato técnico das tiras e o que se pede ao Caio.

Fora: candidatas de arte (~89 MB), código-fonte, builds, perfis de jogador e qualquer arquivo de outro herói.

## Aceite

- AC-1: o .zip abre, usa `/` nos caminhos e contém os itens acima.
- AC-2: PNGs do pacote são idênticos aos do projeto (hash).
- AC-3: sem trechos de cânone secreto do mestre; sem credenciais.
- AC-4: tamanho informado ao dono.

## Lacunas

Sem BLOCKING. Os arquivos ART-PROMPTS-016/055 e FILA-024 são multi-herói: seguem inteiros e o LEIA-ME aponta as linhas do Durvall.

## Nota de versionamento (2026-10-08, PLAN-081 B-001, decisão D2 do dono)

O `.zip` (6,4 MB) fica **só local**, fora do Git: `.atena/generated/caio-durvall/Durvall-para-Caio-2026-10-08.zip`. Para regerar, reunir os itens listados acima.
