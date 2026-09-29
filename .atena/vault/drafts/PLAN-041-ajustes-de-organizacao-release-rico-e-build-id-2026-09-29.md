---
id: "PLAN-041"
title: "Ajustes de organização: versão rica em conteúdo, build id, ferramentas"
status: "aplicado em 2026-09-29"
created: "2026-09-29"
relations:
  - "[[PLAN-037-organizacao-do-trabalho-em-tres-trilhas-2026-09-29]]"
  - "[[PLAN-038-atualizacao-pos-playtests-t01-t02-t03-2026-09-29]]"
  - "[[SPEC-078-evidencias-diretas-de-playtest]]"
---

# PLAN-041 — Ajustes de organização

Revisão do PLAN-037 depois de três playtesters (EVID-106 a 108).

## Decisões do dono (2026-09-29)

1. **Build de playtest rica em conteúdo.** Os testers se empolgam mais com muita
   coisa nova para experimentar. O limite de "2 mecânicas por lote" sai; ficam
   uma spec, um teste e **um commit por mecânica**.
2. **Perguntas em aberto** não bloqueiam: vão para o próximo playtest.
3. Demais ajustes: a critério da Atena.

## O que mudou

| Lacuna encontrada | Ajuste |
|---|---|
| Não se sabia qual build cada tester jogou | **TOOL-001:** `Version.build_id()`, `data/build_info.json` (gitignored), `tools/stamp_build.ps1` e passo no CI. Aparece no rodapé, no log e em cada nota |
| Cartões sem ciclo de vida | Estados e regra "implementado e não citado de novo = corrigido" no README do backlog |
| Sem quadro de versão | `RELEASES.md`: conteúdo, "o que testar", checklist e histórico |
| Cabeçalhos velhos (BUGS, MECANICAS) | Atualizados; portão "bugs fechados antes de mecânica" dispensado |
| Sem trilha para infraestrutura | `FERRAMENTAS.md` (`TOOL-nnn`) |
| Perguntas aos testers sem lugar | Seção no INBOX |
| INTAKE descrevia o kit antigo (ZIP e manifesto) | Atualizado para a SPEC-078 |
| Lembrete de bugs dependia de memória | `tools/backlog_check.ps1` e hook de início de sessão em `.claude/settings.json` |
| Política só no texto | `add.yaml` (bloco `backlog`) espelha as novas regras |

## Riscos e limites

- Sem limite de mecânicas, uma versão pode ficar difícil de diagnosticar. Mitigação:
  commit por mecânica, hash da build nos relatos e lista "O que testar".
- O hash gravado localmente só existe se `stamp_build.ps1` rodar antes do export;
  sem ele a build mostra `dev`.
- O script e o hook usam `-ExecutionPolicy Bypass` só no processo; a política do
  sistema não foi alterada.
- Nenhuma mecânica, arte ou dado de jogo foi alterado; só identificação da build.
