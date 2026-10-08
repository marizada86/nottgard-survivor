---
id: "EVID-198"
title: "F7 reúne as evidências de playtest em um ZIP"
spec: "SPEC-145"
plan: "PLAN-078"
created: "2026-10-07"
status: "B-001 a B-003 concluídos localmente; sem commit, push ou exportação do .exe"
---

# EVID-198 — F7 empacota `evidencias/` num ZIP

## Entregue

| Peça | Onde |
|---|---|
| Ação `zip` para o F7 | [core/playtest.gd](../../core/playtest.gd) `shortcut_action` |
| `evidence_files`, `unique_zip_path`, `build_evidence_zip` (estáticos, testáveis) | [core/playtest.gd](../../core/playtest.gd) |
| `zip_evidence()` com avisos, log e bloqueio com F5/F1 abertos | [core/playtest.gd](../../core/playtest.gd) |
| F7 ignorado na Web (junto de F4/F5/F6) | [core/playtest.gd](../../core/playtest.gd) `_input` |
| Textos: guia F1 (passos 4 e 5), atalhos, rodapé da central, README | `core/playtest.gd`, [README.md](../../README.md) |
| Testes | [tests/test_playtest.gd](../../tests/test_playtest.gd), [tools/kit_test.gd](../../tools/kit_test.gd) |

Onde o ZIP cai: ao lado da pasta `evidencias/` (a pasta do executável nos builds de playtest e QA); pelo editor, em
`%APPDATA%\Godot\app_userdata\Nottgard Survivors\`. Nome `evidencias-AAAA-MM-DD-HHMMSS.zip`, sufixo `-02` se repetir.
Dentro: `evidencias/relato.txt`, `evidencias/logs/…`, `evidencias/imagens/…`. Os originais ficam onde estão.

## Verificação

- Suíte completa (`tests/run_all.gd`, headless): **0 falhas**.
- `tools/kit_test.tscn` (com janela): **kit: OK** — print, nota, log e F7 criando exatamente um ZIP, sem mover o `relato.txt`.
- Teste do empacotador (pasta temporária em `user://`): pasta vazia não gera ZIP; só extensões permitidas entram
  (`save.dat` e `manifest.json` ficam de fora); nomes `…010203.zip` e `…010203-02.zip` sem sobrescrever; o segundo ZIP não
  contém o primeiro; conteúdo e caminhos lidos de volta com `ZIPReader`; originais intactos.

Critérios da SPEC-145: 1, 2, 3 e 4 (falha de gravação coberta por remoção do ZIP parcial no código; não simulada), 5 e 6.

## Não verificado

- Pressionar o F7 num `.exe` exportado: a build de playtest não foi exportada nesta entrega.
- Falha de gravação real (pasta sem permissão): o caminho existe no código, mas não foi provocado em teste.

## Risco em aberto

O anexo do Discord e a importação de estatísticas do PLAN-071 podem não aceitar `.zip`. O ZIP serve para guardar tudo
junto; os arquivos soltos continuam em `evidencias/` e valem para o envio atual.

## Retorno

PLAN-071 continua `active_plan` em B-006/S-011. Snapshot: `.atena/generated/playtest-zip/plan-before-078.yaml`.
