---
id: "SPEC-145"
title: "F7 empacota as evidências de playtest em um ZIP"
status: "IMPLEMENTADA localmente em 2026-10-07 (PLAN-078); sem commit, push ou exportação"
origin: planned
implementation_preceded_spec: false
request_classification: PLAN_DEVIATION
created: "2026-10-07"
relations: ["[[SPEC-078-evidencias-diretas-de-playtest]]", "[[SPEC-020-ferramentas-playtest-e-qa]]"]
---

# SPEC-145 — F7 empacota as evidências em um ZIP

Pedido do dono (2026-10-07): "ao apertar F7 compilar tudo em zip para a mesma pasta do executável do playtest".

## Relação com a SPEC-078

A SPEC-078 removeu o ZIP e deixou o F7 sem ação (critério 4). Esta spec **substitui só esse ponto**: o F7 volta, mas
sem rascunho, manifesto, pacote em `user://` ou limpeza de arquivos. O restante da SPEC-078 vale como está
(F4, F5, F6, `evidencias/` ao lado do executável, extensões `.txt`, `.log`, `.png`).

## Comportamento

- **F7** (Windows, perfis público e QA interno; ignorado na Web e em produção) cria
  `evidencias-AAAA-MM-DD-HHMMSS.zip` **ao lado de `evidencias/`**, isto é, na pasta do executável.
  Pelo editor do Godot, que usa `user://evidencias`, o ZIP fica em `user://` (`app_userdata\Nottgard Survivors\`).
- Conteúdo: tudo que está em `evidencias/` com extensão permitida (`relato.txt`, `logs/**`, `imagens/**`), sob a
  pasta `evidencias/` dentro do ZIP (`evidencias/relato.txt`, `evidencias/logs/…`, `evidencias/imagens/…`). Nada fora de `evidencias/`; nenhum ZIP anterior entra.
- **Copiar e manter** (decisão do dono): os arquivos originais não são movidos nem apagados.
- Nome único: se já existir, sufixo `-02`, `-03`. Nunca sobrescreve.
- Sem arquivos para empacotar: aviso, nenhum ZIP criado.
- Falha ao gravar: aviso claro e o ZIP parcial é removido.
- Com o bloco de notas (F5) ou o guia (F1) abertos, o F7 não age (mesma regra do F6).
- Conclusão: aviso na tela com o nome do ZIP, e linha no log do jogo.

## Não objetivos

Mover ou apagar originais; rascunho, manifesto ou JSON; incluir save, executável ou vídeo; envio automático;
compactar na Web; mudar a lista de extensões aceitas dentro de `evidencias/`; commit, push, exportação.

## Critérios de aceite

1. F7 mapeia para a ação `zip`; as demais teclas não mudam.
2. O ZIP contém exatamente os arquivos permitidos de `evidencias/`, com caminhos relativos, e os originais seguem
   intactos (teste com pasta temporária).
3. Dois F7 seguidos geram dois ZIPs distintos; o segundo não contém o primeiro.
4. Pasta vazia: nenhum ZIP. Falha de gravação: nenhum ZIP parcial.
5. Guia (F1), rodapé da central e README descrevem o F7; Web não anuncia nem reage ao F7.
6. Suíte e teste do kit passam; produção não expõe o F7.

## Risco registrado

O envio ao Discord e a importação de estatísticas do PLAN-071 aceitam arquivos `.log`/`.txt`/imagens individuais.
Um `.zip` pode não ser aceito pelo anexo do canal nem pela importação automática do ranking. Isso depende do
pipeline do dono e **não** é alterado aqui; o ZIP serve para reunir e guardar, e os arquivos soltos continuam em
`evidencias/`.

## Plano de voo

1. B-001 — função estática `build_evidence_zip` e nome do ZIP; ação `zip` no `shortcut_action`; tratamento do F7.
2. B-002 — textos (guia, central, README), testes e `tools/kit_test.gd`; reconciliar SPEC-078.
3. B-003 — suíte, evidência, retorno ao PLAN-071 (B-006/S-011).
