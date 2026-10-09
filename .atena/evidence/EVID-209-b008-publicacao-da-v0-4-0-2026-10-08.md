---
id: "EVID-209"
title: "PLAN-081 B-008: publicação da v0.4.0 e fechamento do plano"
created: "2026-10-08"
plan: "PLAN-081"
spec: "SPEC-148"
cards: ["MEC-039", "MEC-041", "MEC-042", "MEC-040", "BAL-023", "BAL-025"]
status: "publicada; aviso aos testers e .exe local pendentes"
---

# EVID-209 — Publicação da v0.4.0 (B-008)

## O que foi feito

| Passo | Resultado |
|---|---|
| S-023 versão | `0.4.0` em `core/version.gd` e nos três presets de `export_presets.cfg`; `RELEASES.md` com a seção da 0.4.0 e o histórico; `backlog_check` com 0 alertas |
| S-024 changelog e guia | `CHANGELOG-0.4.0.html` e PDF (4 páginas A4; 0.3.1 → 0.4.0); `GUIA-FACIL-0.4.0.html` e PDF (2 páginas) |
| S-025 questionário | `QUESTIONARIO-007` (md, html e PDF de 1 página, 11 frases) |
| S-026 verificação | suíte `0 falha(s)`, `smoke: ok`, `kit: OK`, `audit_projeto` `erros=0` na árvore da 0.4.0. **O `.exe` local não foi exportado** (decisão: o `.exe` dos testers é o do CI); FPS medido só em janela (EVID-207) |
| S-027 commit e push | commit `5850182` (versão) e `aa496f2` (atualização do ADD no `AGENTS.md`, vinda de outra sessão); **push `94a6a2f..aa496f2`** (34 commits), aprovado pelo dono em 2026-10-08 ("commit e push"); `main` = `origin/main` |
| CI e release | Build and Release `#131` (commit `aa496f2`) foi iniciado; o release `latest` passou de *Playtest v0.3.2 (94a6a2f…)* para ***Playtest v0.4.0 (aa496f29a053c697c755b35554d01e7931e6fd01)***, marcado pré-release, com 4 assets e o zip `NottgardSurvivors-windows.zip`. A página da execução `#131` não pôde ser aberta (HTTP 404 sem login), então o resultado do CI foi inferido do título novo do release |
| S-028 reconciliação | `plan.yaml`: DEV-013 e PLAN-081 concluídos; PLAN-071 de volta como `active_plan` em B-006/S-011; recibo do push; `plan-081-…yaml` fechado |

## Critérios da SPEC-148

| # | Critério | Situação |
|---|---|---|
| 1 | Árvore sem mudança solta | **Cumprido** nos grupos G1 a G5 (EVID-202); ficam locais por decisão o ZIP do Caio, `unit-profile` e capturas extras |
| 2 | Cópia limpa: suíte, smoke e testes novos | **Cumprido** em B-001 (HEAD `94a6a2f`, `5953d44`); suíte repetida na árvore final |
| 3 a 5 | MEC-041, MEC-042, MEC-039 (testes, mapa, Ecos, relíquias, desempenho) | **Cumpridos** (EVID-205, 206, 207); desempenho medido em janela |
| 6 | Bot por herói sem regressão | **Cumprido** (EVID-208) |
| 7 | Versão 0.4.0 no código, rodapé e título do release | Código e título do release: **cumprido**; rodapé do `.exe` baixado: **a conferir pelo dono** |
| 8 | Changelog, guia e questionário conferidos | PDFs gerados; changelog conferido por captura; **o PDF não pôde ser aberto aqui** (falta `pdftoppm`) |
| 9 | `.exe` exportado de commit limpo e testado | **Não feito** (ver acima) |
| 10 | `backlog_check`, RELEASES, INBOX, cartões e `plan.yaml` reconciliados | **Cumprido** |
| 11 | Push e aviso só com aprovação | Push com aprovação; **aviso aos testers pendente** (ação do dono) |

## Pendências

1. **Aviso aos testers** (dono): enviar os três PDFs (`CHANGELOG 0.4.0`, `GUIA FACIL 0.4.0`, `QUESTIONARIO Rápido - 007`) depois de baixar o release `latest` e conferir que o rodapé diz 0.4.0.
2. **`.exe` local** (opcional): exportar de um commit limpo se o dono quiser testar antes dos testers.
3. **Abrir o PDF do changelog** e conferir a paginação (4 páginas esperadas).
4. **Aceite físico** pendente: Xbox/PlayStation, celular e ranking (PLAN-071, PLAN-067, PLAN-068).
5. **Playtest** da 0.4.0: arte e som provisórios (ART-042, ART-043, ART-006) e a dificuldade dos mapas 84×84.
