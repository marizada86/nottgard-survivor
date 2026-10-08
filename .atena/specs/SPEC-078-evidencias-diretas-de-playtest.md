# SPEC-078 — Evidências diretas de playtest

Status: **implementada e validada (2026-09-29)**.

> Atualização 2026-10-07: o ponto "F7 não possui ação" e o não objetivo "Não criar ZIP" foram substituídos pela
> [SPEC-145](SPEC-145-f7-zip-de-evidencias.md) (F7 reúne `evidencias/` num ZIP ao lado do executável). O restante vale.

## Decisão

Substituir o kit de evidências baseado em rascunho e ZIP por arquivos diretos
criados ao lado do executável da build de playtest:

```text
<diretório do executável>/
├── NottgardSurvivor.exe
└── evidencias/
    ├── relato.txt
    ├── logs/jogo.log
    └── imagens/print-AAAA-MM-DD-HHMMSS.png
```

`F5` abre a nota e acrescenta relato textual com data, hora e contexto da
partida. `F6` cria uma captura PNG. `F4` abre o Navegador QA nas builds de
playtest e QA interno; nenhuma dessas ferramentas aparece em produção. `F7`
não possui ação.

## Escopo

- Criar somente diretórios e arquivos `.txt`, `.log` e `.png` no fluxo.
- Derivar o destino pela pasta do executável exportado, sem fallback para
  `user://`; informar erro claro e acionável se a pasta não for gravável.
- Remover pacote, manifesto, rascunho, exportação e todas as APIs ZIP do kit.
- Manter o sandbox que preserva o save real quando o Navegador QA inicia uma
  run.
- Atualizar os documentos operacionais: o envio ao Discord é individual, na
  task correspondente, usando os arquivos de `evidencias/`.

## Não objetivos

- Não criar ZIP, vídeo, save, binário auxiliar, telemetria remota ou envio
  automático.
- Não alterar as evidências ADD históricas; elas registram o comportamento
  anterior e são substituídas operacionalmente por esta spec.
- Não publicar, fazer push, release, deploy ou mudar configuração remota.

## Critérios de aceite

1. A build Windows de playtest cria `evidencias/` ao lado do executável.
2. F4 abre o Navegador QA; F5 grava `relato.txt`; F6 grava PNG em `imagens/`.
3. `logs/jogo.log` contém logs de texto higienizados.
4. F7 não é reconhecido e nenhum ZIP, JSON, pacote ou `user://evidence-kit`
   é criado pelo fluxo.
5. Produção não expõe ferramentas de evidência ou Navegador QA.
6. A suíte, o teste do kit e a exportação Windows de playtest passam.

## Plano de voo

1. Reestruturar o armazenamento e as teclas do autoload `Playtest`.
2. Ajustar o gate do navegador e sandbox para perfis de playtest autorizados.
3. Atualizar testes, teste interativo e documentos operacionais.
4. Executar as validações, registrar a evidência ADD e reconciliar a
   `SPEC-020` e esta spec.

## Impactos e reconciliação

- Código: `core/playtest.gd`, `core/game.gd` e testes associados.
- Documentação operacional: `README.md`, guia F1 e plano de intake ativo.
- A `SPEC-020` passa a apontar para esta substituição no que se refere a
  armazenamento, F4 e teclas de evidência.
- Evidência de execução: `../evidence/EVID-105-spec-078-evidencias-diretas-2026-09-29.md`.
