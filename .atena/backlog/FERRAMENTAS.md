# FERRAMENTAS E BUILD — infraestrutura do projeto

O que não é arte, mecânica nem bug: kit de evidência, exportação, CI, scripts e
procedimentos. Prefixo `TOOL-nnn`. Mesma regra de estado dos outros backlogs.

## Abertos

| ID | Item | Origem | Estado |
|---|---|---|---|
| TOOL-002 | `tools/backlog_check.ps1`: confere IDs duplicados, links quebrados, próximos livres e conta P0/P1 abertos | [PLAN-041](../vault/drafts/PLAN-041-ajustes-de-organizacao-release-rico-e-build-id-2026-09-29.md) | implementado; rodar antes de commit e de export |
| TOOL-003 | Hook de início de sessão que roda o `backlog_check` (`.claude/settings.json`) | PLAN-041 | implementado; ver README de ferramentas abaixo |
| TOOL-004 | `tools/bot.gd`: responde a `item_offer`, trata `revive_offer` como morte, reporta o motivo real do fim e o tempo/PV mínimo na luta do chefe | [EVID-143](../evidence/EVID-143-bot-travado-em-item-offer-e-chefe-das-docas-2026-10-01.md) | implementado 2026-10-01; refazer a varredura `overnight.ps1` |

## Fechados

| ID | Item | Evidência |
|---|---|---|
| TOOL-001 | Identificador da build: `Version.build_id()` lê `data/build_info.json` (gravado por `tools/stamp_build.ps1` ou pelo CI). Aparece no rodapé do menu, no log (`Jogo iniciado`) e em cada nota (`"commit"`). Sem o arquivo mostra `dev`; `+` no fim indica árvore com alterações | PLAN-041 · implementado 2026-09-29 |
| TOOL-005 | **Verificações gravavam no save real:** `controller_check` trocava o perfil sem redirecionar `_save_path` e o `smoke` marcava fases como alcançadas e salvava em `user://profile.json`; corrigidos (perfil e arquivo descartáveis). Também: `mobile_buttons_check` com índices fixos de aba do Quartel (agora por nome) e `controller_check` com a expectativa velha de confirmação ao recusar bênção (removida em `d702247`). Resultado: controller 90/0, mobile 146/0. **O save real do dono já estava com o perfil de teste** | [EVID-230](../evidence/EVID-230-falhas-antigas-das-verificacoes-e-save-real-2026-10-09.md) |
| TOOL-006 | **Sonda de desempenho** `tools/perf_probe.tscn` (PLAN-098): `sim` joga `Battle` sem janela com política fixa e mede o `step()` real e por sub-rotina (21 seções, replica fiel provada por hash), `funcoes` cronometra funções internas por pico (subclasse só do probe), `scene` mede a fase aberta (com janela: sem vsync, draw calls, VRAM). Imprime `PROBE;...` e o **hash do estado final**: dois hashes iguais antes e depois de uma otimização provam que o resultado não mudou. Usa bloqueios reais da fase; perfil e save descartáveis | [EVID-240](../evidence/EVID-240-bateria-0-4-0-e-revisao-de-desempenho-2026-10-10.md), [SPEC-171](../specs/SPEC-171-bateria-da-0-4-0-e-revisao-de-desempenho-por-idade.md) |
| TOOL-007 | **Telemetria de quadros e máquina no kit e emulação de máquina fraca** (PLAN-099): `FrameStats` (histograma de 1 ms: fps, p95, p99, máx, quadros abaixo de 30 e de 20 fps) e `MachineInfo` (SO, CPU, RAM, GPU, renderer, tela, taxa). Entram no contexto de cada nota F5 (`maquina`, `quadros`), nos checkpoints `minute` (`quadros`) e `finish` (`quadros_total`, `maquina`) do registro da run e numa linha `Maquina:` do log, sem mudar o contrato v1 nem coletar usuário, pasta ou host. `tools/perf_emulate.ps1` roda a sonda com N núcleos, prioridade baixa e queimadores de CPU (1 queimador = ~2x mais lento); emula CPU, **não** GPU nem VRAM | [EVID-241](../evidence/EVID-241-telemetria-de-quadros-e-maquina-fraca-emulada-2026-10-11.md), [SPEC-172](../specs/SPEC-172-telemetria-de-quadros-e-maquina-fraca-emulada.md) |
| — | Kit de evidências direto, sem ZIP nem manifesto | [SPEC-078](../specs/SPEC-078-evidencias-diretas-de-playtest.md) |
| — | Recebimento de imagens do ChatGPT | [RECEBIMENTO-DE-ASSETS](RECEBIMENTO-DE-ASSETS.md) |

## Antes de exportar uma build de playtest

```powershell
powershell -File tools/stamp_build.ps1     # grava data/build_info.json
godot --headless --path . -s tests/run_all.gd
godot --headless --path . --export-release "Windows Playtest Publico" build/NottgardSurvivors-Playtest.exe
```

Build de playtest sempre com `tools/stamp_build.ps1`, para gravar o commit no
rodapé, no log e nas notas. O CI já grava o commit sozinho no passo "Gravar o identificador da build".
`data/build_info.json` fica fora do git de propósito.

## Rodar as verificações de controle e celular sem tocar no save real

```bash
godot --headless --path . res://tools/controller_check.tscn --resolution 1280x720   # 90 verificações, ~70 s (inclui o repouso de 60 s)
godot --path . res://tools/mobile_buttons_check.tscn --resolution 1280x720          # 146 verificações; precisa de janela
godot --headless --path . res://tools/smoke.tscn                                    # nove fases
```

As três usam perfil e arquivo descartáveis. **Se a janela for fechada de fora durante o repouso de 60 s, o controller_check termina sem resumo**; por isso `--headless`. `save_real_preservado` compara o hash de `user://profile.json` antes e depois.
