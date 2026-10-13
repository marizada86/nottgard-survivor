---
id: "SPEC-169"
title: "Lançamento oficial da 0.4.0 para os playtesters (documentos, verificação e pacote)"
status: "PREPARADA em 2026-10-10 (PLAN-096, EVID-238); o código já foi publicado (602cef5); commit dos documentos e aviso aos testers aguardam o dono"
origin: planned
implementation_preceded_spec: false
request_classification: PLAN_DEVIATION
created: "2026-10-10"
relations: ["[[SPEC-148-lancamento-da-v0-4-0]]", "[[SPEC-157]]", "[[SPEC-158]]", "[[SPEC-163]]", "[[SPEC-164]]", "[[SPEC-165]]", "[[SPEC-166]]", "[[SPEC-167]]", "[[SPEC-168]]"]
cards: ["MEC-001", "MEC-002", "MEC-003", "MEC-005", "MEC-059", "MEC-060", "MEC-061", "MEC-062", "MEC-063", "MEC-064", "BUG-039", "BUG-040", "BUG-041", "BUG-042"]
---

# SPEC-169 — Lançamento oficial da 0.4.0

Origem: pedido do dono em 2026-10-10: "atena, agora vamos lançar a v0.4.0 oficialmente, prepare tudo para os playtesters". Decisões do dono no mesmo dia: rota **fazer agora e voltar ao PLAN-071**; aprovação **por plano**; **incluir** BUG-042 e MEC-064 na 0.4.0; release continua o **pré-lançamento `latest`** (sem mudar o workflow).

## Situação lida em 2026-10-10

- `VERSION` = `0.4.0` (`core/version.gd`) e `file_version`/`product_version` = `0.4.0.0` (`export_presets.cfg`). **Não muda**: a 0.4.0 foi refeita em 2026-10-09 e não haverá 0.5.0 (RELEASES).
- **Atualizado às 02:25:** o dono commitou e publicou `602cef5` (BUG-042, MEC-064, registro de Erik/Arlindo) em outra sessão; `origin/main` = `HEAD` = `602cef5`. CI do `ce2d259` verde (run 38026139860); CI do `602cef5` em andamento (run 38027372176) e o release `latest` ainda aponta para `ce2d259` até ele terminar (pré-lançamento, zip e `.exe`). **Todo o código da 0.4.0 já está publicado ou em publicação**; o que falta são documentos, verificação e aviso.
- Documentos dos testers (changelog, guia e questionário 007) foram refeitos em 2026-10-09 (c0ebc87) e **não descrevem** o que entrou depois: barra de progresso da fase, seis eventos aleatórios, menu de pausa em abas, Quartel/Códex/Opções no novo padrão, fade entre jogo e janelas, clique na HUD sem mover o herói, questlog à direita e avisos do topo. Dizem 2% a 6% na névoa de borda (hoje 3% a 9%) e arte emprestada para Arlindo e Erik (hoje têm arte própria, ce2d259).
- O aviso aos testers da 0.4.0 **nunca foi enviado** (RELEASES). Os testers jogam pelo link `latest`.

## Entrega (escopo)

1. **Documentos** reescritos para o estado real da build: `CHANGELOG-0.4.0.html` (e PDF), `GUIA-FACIL-0.4.0.html` (e PDF), `QUESTIONARIO-007` (md, html e PDF); linguagem para leigo, teclas e números conferidos no código e nos JSON (regras de `changelogs/README.md`).
2. **RELEASES.md** (seção 0.4.0, "O que testar", checklist) e `changelogs/README.md` alinhados.
3. **Pacote do lançamento** em `.atena/generated/v040-lancamento/`: os três PDFs, o texto do aviso do Discord (pronto para colar) e o resumo do que conferir após o push.
4. **Verificação** do commit que será publicado em checkout limpo: suíte, smoke, `kit_test`, `mobile_buttons_check`, `controller_check`, `backlog_check`.
5. **`.exe` local** exportado de commit limpo (`build/`, fora do Git), para o dono abrir antes do push.
6. **Conferência** do CI do `602cef5`, dos assets do `latest` e do rodapé 0.4.0. Os documentos são só `.atena/` (commit local); **push deles é opcional** e republicaria o `latest` com o mesmo jogo. **Aviso aos testers é do dono.**

## Fora do escopo

Mecânica, arte, número de balanceamento ou bug novo; mudar `VERSION`; tornar o release "completo" (`prerelease: false`); resolver BUG-025/027/028/029 (aguardam arte do dono); enviar o aviso em nome do dono.

## Padrões (não bloqueiam)

| # | Decisão | Padrão |
|---|---|---|
| P1 | Barra de progresso nos documentos | Descrita, marcada como provisória (sem arte final; ART-002 opcional) |
| P2 | Questionário 007 | Mesmo arquivo, perguntas novas só para o que os testers ainda não viram |
| P3 | Nome do `.exe` local | `NottgardSurvivors-Playtest 0.4.0.exe` |
| P4 | Commit de outra sessão (`602cef5`) mistura BUG-042, MEC-064, registros e o piloto de tiras do Kayron | Não reescrever o histórico (não publicado ainda, mas o dono o fez assim); registrar o desvio da regra "um commit por mecânica" |

## Portões

Commit local, push (publica a build), exportação e aviso aos testers: **cada um exige "sim" explícito**, mesmo com aprovação por plano. Sem dependência nova; nada em `assets/` além do que já está commitado; mudanças de outras sessões preservadas.

## Aceite

Documentos conferidos item a item contra o código; PDFs abertos e olhados; `VERSION` bate com `export_presets.cfg`; suíte e smoke sem falhas no commit publicado; após o push, CI verde e rodapé do `.exe` baixado = 0.4.0. Diversão, legibilidade e conforto ficam com o playtest do dono e dos testers.
