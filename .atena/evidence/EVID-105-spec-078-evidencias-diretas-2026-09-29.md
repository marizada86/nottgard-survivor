# EVID-105 — SPEC-078: evidências diretas de playtest

Data: 2026-09-29  
Spec: `../specs/SPEC-078-evidencias-diretas-de-playtest.md`

## Resultado

- O autoload `Playtest` grava o relato, o log e os prints diretamente em
  `evidencias/` ao lado do executável da build exportada.
- `F5` salva somente texto em `relato.txt`, com data/hora e contexto; `F6`
  gera PNG em `imagens/`; `F4` abre o Navegador QA em playtest e QA interno.
- `F7`, ZIP, manifestos, rascunhos e o destino `user://evidence-kit` foram
  removidos do fluxo ativo. A lista permitida de saída é `.txt`, `.log`,
  `.png`, `.jpg`, `.jpeg` e `.webp`.
- O erro de pasta sem permissão informa que a build deve ser movida para um
  local gravável; não há fallback de evidências para `user://`.
- Produção continua sem ferramentas de playtest: o gate de perfil só autoriza
  playtest público e QA interno.

## Validações executadas

1. `godot --headless --path . -s res://tests/run_all.gd`  
   Resultado: `testes: 0 falha(s)`.
2. `godot --path . res://tools/kit_test.tscn`  
   Resultado: `kit: OK`; valida F4, F5, F6, estrutura `evidencias/`, relato
   higienizado, log, PNG e ausência de ação para F7/arquivo ZIP.
3. `godot --headless --path . --export-release "Windows Playtest Publico" build/NottgardSurvivors-Playtest.exe`  
   Resultado: exportação concluída; executável criado em `build/`.
4. A build exportada foi iniciada brevemente em modo sem janela. Ela criou
   `build/evidencias/relato.txt` e `build/evidencias/logs/jogo.log`; a inspeção
   encontrou somente extensões `.txt` e `.log` nesse estado inicial.
5. Busca estática no fluxo ativo não encontrou `ZIPPacker`, `ZIPReader`,
   `export_zip` nem `user://evidence-kit`; `git diff --check` não apontou
   erros de espaço.

## Reconciliação

- `SPEC-020` foi marcada como substituída para o armazenamento e as teclas de
  evidência; o registro histórico do sandbox QA foi preservado.
- O `README`, o guia F1 e o plano de intake ativo agora instruem o envio
  individual de texto e imagem da pasta `evidencias/` na task do Discord.
- Evidências ADD antigas que mencionam o pacote anterior não foram reescritas:
  são registros históricos, não instruções operacionais vigentes.

## Limitações observadas

- A primeira tentativa de exportação dentro do sandbox não pôde acessar os
  templates locais do Godot. A repetição autorizada com acesso local concluiu
  a exportação normalmente.
- O runner headless informa avisos já presentes sobre log `user://`,
  certificados e recursos/RIDs no encerramento; a suíte terminou com zero
  falhas.
