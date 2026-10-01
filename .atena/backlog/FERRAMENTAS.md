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
