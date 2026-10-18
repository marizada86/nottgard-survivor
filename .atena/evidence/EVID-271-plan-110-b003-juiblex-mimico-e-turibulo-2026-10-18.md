# EVID-271 — PLAN-110 / SPEC-185, lote B-003 (Manifestação de Juiblex, Mímico e Turíbulo; LOT13 e LOT14)

Data: 2026-10-18 · Estado: DRAFT (direção visual aceita pelo dono no pacote do Codex; preparação técnica e admissão são deste escopo) · Desvio: DEV-045.

## Fontes

50 PNGs individuais de 1254×1254 copiados para `.atena/generated/chatgpt-integration-2026-10-17/b003/` com SHA-256 conferido contra os manifestos (50 de 50): Juiblex JI00 v02 + JI01..03, JM00..05, JA00..03, JD00..05, JS00..05 (v01); Mímico MI00..03, MM00..05 (MM01 e MM05 v02), MA00..03, MD00..05 (MD03 v02); Turíbulo TI00..03. Não usadas: JI00 v01 (substituída), as tentativas não selecionadas e **toda a ruptura do Turíbulo (TD00..TD04)**.

## Preparação (`tools/prepare_actor_strips.gd`, relatório em `b003/atores-preparacao.json`)

- Limpa só o ruído de alfa < 16/255 e torna opaco o sólido (alfa ≥ 0,9).
- Todos os quadros do ator são reduzidos pelo MESMO fator (altura visível do primeiro quadro do idle: Juiblex 250 px, Mímico e Turíbulo 300 px; fatores 0,41 / 0,34 / 0,37). A base de cada quadro vai para a linha dos pés e o centro da parte baixa para o meio da célula, só por translação (registro). Células: Juiblex 512×320 (pés em 292), Mímico e Turíbulo 384×352 (pés em 324); 0 pixel fora da célula.
- `body_height` calculado para o tamanho em tela casar com o da arte estática (Juiblex 266,1; Mímico 403,4; Turíbulo 515,4).
- Saída em `assets/animations/enemies/<id>/<estado>.png`: Juiblex idle 4, move 6, attack 4, death 6, special 6; Mímico idle 4, move 6, attack 4, death 6; Turíbulo idle 4.

## Ligação

`ui/enemy_view.gd`: 3 entradas em `ANIMATED` e `FEET_Y`. `ui/run.gd`: o estado `special` da Manifestação de Juiblex acompanha o chamado (`summon`) e o anel (`ring`), como Zuggtmoy, Socothbenoth e a Síntese Abissal; dano, alcance, invocação e recompensas não mudaram (o Mímico segue gerando o baú pela SPEC-134). `tests/test_actor_strips_b003.gd` cobre estados, tamanhos das tiras, idle inicial e a ausência da ruptura TD.

## Retido (NÃO integrado)

- **Ruptura do Turíbulo (TD00..TD04):** retida pelo pacote depois de três tentativas (crescimento da base, `LOT14_TD_BASE_GROWTH_AFTER_THREE_ATTEMPTS`); o Turíbulo segue sem animação de morte (desvanece, como antes). TD03/v03 e TD02/v02 também não foram usadas.
- As retenções de preparação do LOT13 e do LOT14 (alfa, margem, registro) foram tratadas pela preparação acima; o aceite do dono é de direção, não de fluidez.

## Verificação

- Importação sem erro; `tests/run_all.gd` **0 falhas** e sem SCRIPT ERROR; smoke das 9 fases `ok`; `controller_check` 94/0; `mobile_buttons_check` 146/0 (perfis regravados restaurados).
- Capturas (`b003/capturas/`): idle, movimento, ataque, especial e morte (início, meio e fim) dos três atores, ao lado do Zumbi.

## Não verificado

Fluidez, ritmo (idle 10 fps, ataque 12, morte 9, padrão do `EnemyView`), tamanho do Juiblex em luta real e o corte da pata traseira na mordida do Mímico (MA01: oclusão, não corrigida): **o dono avalia**. Sem playtest, commit, push, build nem exportação.
