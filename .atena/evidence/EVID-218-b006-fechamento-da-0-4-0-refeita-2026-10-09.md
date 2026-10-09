---
id: "EVID-218"
title: "PLAN-083 B-006: 0.4.0 refeita (sem 0.5.0), documentos dos testers e verificação final"
created: "2026-10-09"
spec: "SPEC-157"
cards: ["MEC-039", "MEC-001", "MEC-050"]
status: "documentos prontos e verificados localmente; sem commit; sem push; aviso aos testers pendente"
---

# EVID-218 — B-006 do PLAN-083

## Mudança de rota (PLAN_CHANGE_REQUEST)

O dono respondeu em 2026-10-09: "vamos refazer a 0.4.0 com todas as novas atualizações e tentar limpar o maior número possível de planos e specs". Efeito no plano ([plan-083, `route_change`](../state/plan-083-segredos-nas-outras-fases.yaml)):

| Passo | Antes | Agora |
|---|---|---|
| S-019 | versão 0.5.0 | **versão continua 0.4.0** (`core/version.gd` e `export_presets.cfg` intactos); seção 0.4.0 do RELEASES atualizada |
| S-020 | changelog 0.4.0 → 0.5.0 e guia 0.5.0 | changelog **0.3.1 → 0.4.0** e guia 0.4.0 refeitos (os testers nunca receberam o aviso da 0.4.0) |
| S-021 | questionário 008 | questionário **007** atualizado; sem 008 |
| S-023 | commit da versão e push | commit dos documentos; **republicar exige push e aprovação à parte** |

Névoa de borda (SPEC-158) e setas de evento (SPEC-159), de outra sessão, entram nos documentos só quando commitadas (decisão do dono).

## O que mudou

| Arquivo | Mudança |
|---|---|
| `changelogs/CHANGELOG-0.4.0.html` e PDF | oito mapas com segredos (seis em 84×84), chaves por mapa, relíquias, Espelho, 32 Ecos, ofertas com W/A S/D e Enter, ícone nas linhas Doar, altar oco consertado; 4 páginas |
| `changelogs/GUIA-FACIL-0.4.0.html` e PDF | resumo da seção 4 com os oito mapas; 2 páginas |
| `questionarios/QUESTIONARIO-007-v0.4.0.html`, PDF e `.md` | frases 1, 2 e 11 atualizadas; 1 página; mapa pergunta → cartão atualizado |
| `RELEASES.md` | seção 0.4.0 "refeita", conteúdo, "O que testar" (itens 6, 7 e novo 15) e checklist com "republicar" |
| `changelogs/README.md` | linha do changelog 0.4.0 |

## Verificações (S-022)

| Verificação | Resultado |
|---|---|
| `tests/run_all.gd` | `testes: 0 falha(s)` |
| `res://tools/smoke.tscn` | `smoke: ok` |
| `res://tools/kit_test.tscn` | `kit: OK` |
| `tools/audit_projeto.gd` | `erros=0; avisos=7` (os 7 avisos já existiam: chefes sem entrada em `boss_presentations`) |
| `tools/backlog_check.ps1` | P0=0, P1 abertos=4, aguardando playtest=14, alertas de organização=0 |
| Bot por herói | EVID-217: segredos sem regressão; queda geral atribuída à névoa de borda (SPEC-158, outra sessão) |
| PDFs | changelog 4 páginas, guia 2, questionário 1 (contagem de páginas; changelog aberto na primeira página) |

## Pendências do fechamento

- **Commit dos documentos:** aguarda aprovação.
- **Republicar a 0.4.0:** a release `latest` de 2026-10-08 não tem os segredos nem as ofertas pelo teclado; só muda com **push** (aprovação à parte). Antes, a outra sessão (SPEC-158/159) precisa fechar ou o dono decidir se a névoa de borda entra, porque derruba o bot.
- **Rodapé:** conferir que o `.exe` baixado do `latest` novo diz 0.4.0.
- **Limpeza de planos e specs:** pedido novo; o inventário é só leitura (165 specs, 76 rascunhos de plano, 34 arquivos de estado, 402 evidências); remoção ou arquivamento só com aprovação.
