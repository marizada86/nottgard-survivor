---
id: "CHATGPT-FILA-015"
title: "Fila de geração — animações dos inimigos de Durao"
status: "integrado — Durão completo: 126 quadros/25 tiras; menor reutiliza chefe"
created: "2026-10-01"
relations: ["[[ART-PROMPTS-046-mobs-durao]]", "[[PLAN-041-animacao-padrao-zumbi-para-inimigos-e-interacoes-2026-09-29]]"]
---

# CHATGPT-FILA-015 — Durao (126 quadros)

Compilação operacional de [[ART-PROMPTS-046-mobs-durao]]; em caso de dúvida, o ART-PROMPTS prevalece.

## Ordem de envio

1. **Gate de identidade:** gerar `I01`–`I06` (um `idle_00` por alvo), anexando a arte estática. **Pare e devolva ao dono** para aprovar cada identidade.
2. Só depois da aprovação, gerar os demais quadros de cada alvo, um alvo por vez, na mesma conversa, anexando a arte estática e o `idle_00` aprovado.
3. Apresentar uma prancha por estado e uma prancha geral para revisão. Nada entra no runtime nesta fila; a admissão segue o rito do SPEC-111.

Marque `[x]` ao gerar e `[a]` ao aprovar.

## Gate de identidade

- [x] gerada · [a] aprovada — I01 `alma_penada_idle_00`
- [x] gerada · [a] aprovada — I02 `demonio_de_gehenna_idle_00`
- [x] gerada · [a] aprovada — I03 `carcereiro_de_pedra_idle_00`
- [x] gerada · [a] aprovada — I04 `aberracao_shu_idle_00`
- [x] gerada · [a] aprovada — I05 `ezro_idle_00`
- [x] gerada · [a] aprovada — I06 `molydeus_chefe_idle_00`

## Quadros por alvo

### `alma_penada` — Alma Penada (19 quadros a gerar, fora o `idle_00`)
Destino: `.atena/generated/art-candidates/enemies-durao/alma_penada/`

- [x] `idle_01`
- [x] `idle_02`
- [x] `idle_03`
- [x] `move_00`
- [x] `move_01`
- [x] `move_02`
- [x] `move_03`
- [x] `move_04`
- [x] `move_05`
- [x] `attack_00`
- [x] `attack_01`
- [x] `attack_02`
- [x] `attack_03`
- [x] `death_00`
- [x] `death_01`
- [x] `death_02`
- [x] `death_03`
- [x] `death_04`
- [x] `death_05`

### `demonio_de_gehenna` — Demônio de Gehenna (19 quadros a gerar, fora o `idle_00`)
Destino: `.atena/generated/art-candidates/enemies-durao/demonio_de_gehenna/`

- [x] `idle_01`
- [x] `idle_02`
- [x] `idle_03`
- [x] `move_00`
- [x] `move_01`
- [x] `move_02`
- [x] `move_03`
- [x] `move_04`
- [x] `move_05`
- [x] `attack_00`
- [x] `attack_01`
- [x] `attack_02`
- [x] `attack_03`
- [x] `death_00`
- [x] `death_01`
- [x] `death_02`
- [x] `death_03`
- [x] `death_04`
- [x] `death_05`

### `carcereiro_de_pedra` — Carcereiro de Pedra (19 quadros a gerar, fora o `idle_00`)
Destino: `.atena/generated/art-candidates/enemies-durao/carcereiro_de_pedra/`

- [x] `idle_01`
- [x] `idle_02`
- [x] `idle_03`
- [x] `move_00`
- [x] `move_01`
- [x] `move_02`
- [x] `move_03`
- [x] `move_04`
- [x] `move_05`
- [x] `attack_00`
- [x] `attack_01`
- [x] `attack_02`
- [x] `attack_03`
- [x] `death_00`
- [x] `death_01`
- [x] `death_02`
- [x] `death_03`
- [x] `death_04`
- [x] `death_05`

### `aberracao_shu` — Shu (19 quadros a gerar, fora o `idle_00`)
Destino: `.atena/generated/art-candidates/enemies-durao/aberracao_shu/`

- [x] `idle_01`
- [x] `idle_02`
- [x] `idle_03`
- [x] `move_00`
- [x] `move_01`
- [x] `move_02`
- [x] `move_03`
- [x] `move_04`
- [x] `move_05`
- [x] `attack_00`
- [x] `attack_01`
- [x] `attack_02`
- [x] `attack_03`
- [x] `death_00`
- [x] `death_01`
- [x] `death_02`
- [x] `death_03`
- [x] `death_04`
- [x] `death_05`

### `ezro` — Ezro (19 quadros a gerar, fora o `idle_00`)
Destino: `.atena/generated/art-candidates/enemies-durao/ezro/`

- [x] `idle_01`
- [x] `idle_02`
- [x] `idle_03`
- [x] `move_00`
- [x] `move_01`
- [x] `move_02`
- [x] `move_03`
- [x] `move_04`
- [x] `move_05`
- [x] `attack_00`
- [x] `attack_01`
- [x] `attack_02`
- [x] `attack_03`
- [x] `death_00`
- [x] `death_01`
- [x] `death_02`
- [x] `death_03`
- [x] `death_04`
- [x] `death_05`

### `molydeus_chefe` — Molydeus, Carcereiro-Chefe (25 quadros a gerar, fora o `idle_00`)
Destino: `.atena/generated/art-candidates/enemies-durao/molydeus_chefe/`

- [x] `idle_01`
- [x] `idle_02`
- [x] `idle_03`
- [x] `move_00`
- [x] `move_01`
- [x] `move_02`
- [x] `move_03`
- [x] `move_04`
- [x] `move_05`
- [x] `attack_00`
- [x] `attack_01`
- [x] `attack_02`
- [x] `attack_03`
- [x] `death_00`
- [x] `death_01`
- [x] `death_02`
- [x] `death_03`
- [x] `death_04`
- [x] `death_05`
- [x] `special_00`
- [x] `special_01`
- [x] `special_02`
- [x] `special_03`
- [x] `special_04`
- [x] `special_05`


2026-10-03: I01–I06 Durão v01 geradas pelo imagegen integrado, uma chamada por identidade; fontes1254x1254 preservadas com alfa nativo. Auditoria seis silhuetas sem cortes, solidez0,929–0,975, nenhum halo amplo na prancha inspecionada. Referências estáticas orientam anatomia e câmera; sem espelhamento de pixels no preparo. Gehenna conserva quatro braços/duas lanças da fonte. Revisão priority-review/durao_identities_v01.png, ordem Alma/Gehenna/Carcereiro/Shu na linha superior, Ezro/Molydeus na inferior. Prompts/resultados em durao-identity-{prompts,results}-2026-10-03.json; auditorias durao-identity-{review,bounds,solidity}-2026-10-03.log. Gate FILA-015 pendente de aprovação humana;120quadros de ciclos não iniciados, nenhuma identidade de Durão admitida no runtime. Não registrar [a] antes da resposta do dono.

2026-10-03: dono aprovou as seis identidades Durão v01 com ‘atena pode seguir’, após apresentação da prancha e pergunta explícita do gate. Pedido IN_PLAN. Iniciar Alma Penada,19quadros restantes; preservar identidades aprovadas como fonte principal.

2026-10-04: Shu admitido20quadros/4tiras. Seleção técnica move03v02, attack02v03, death03v03, death04v02; demaisv01. Cota liberada, testes focados e captura aprovados, manifesto125. Próximo Ezro19quadros.


2026-10-04: Ezro admitido20quadros/4tiras. idle02v02/death04v02, attack02v01 com escala técnica uniforme registrada em frame-selection.json. Candidatos largos v02/v03/v04 rejeitados por halo. Manifesto129; build129 validada, ciclos de Molydeus em geração.

2026-10-04 — Durão concluído localmente (PLAN-053/SPEC-121 S-006). Molydeus26 quadros/5 tiras admitidos: move00v02 mantém cabeça aprovada; death03v02 e death05v02 preservam direção de queda, encerrando com olhos fechados. Special02/03 usam escala uniforme1,25 para continuidade física, sem alterar RGB/alfa; escolhas em frame-selection.json e transforms em strips/packing.json. Fontes selecionadas sem cortes; solidez mínima0,957. Chefe body_height101/feet356, menor usa source_id=molydeus_chefe sem PNG duplicado; escalas reais1,9/1,6 verificadas. A habilidade aoe existente toca special do chefe. Captura real priority-review/molydeus_chefe_runtime.png inspecionada. Durão6 atores novos/126quadros/25tiras, mais menor reutilizado; manifesto134 assets/hashes válidos. Suite0 falhas, smoke9 fases, queue0, runtime chefe+menor0, export0, EXE60frames0. Build8307924+ em build/image-priority-durao-complete/NottgardSurvivors.exe,415238352bytes,SHA2562EB63495BD5F805DEB815E04397DAD29C4C9AE8560DDB4DB0B111A2A29829673. Validação duraocompleta registrada em durao-complete-build-validation-2026-10-04.json. Build inclui mudanças de balanceamento da sessão paralela sob revisão separada. BUG-025 e playtest humano permanecem pendentes; sem commit/push. Estado central PLAN-056 preservado; cursor próprio PLAN-053. Próximo checkpoint: seis pilotos de Feng Tu antes de ciclos.
