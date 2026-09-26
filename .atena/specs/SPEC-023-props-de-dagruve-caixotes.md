# SPEC-023 — Caixotes de Dagruve

Status: **concluída e reconciliada em 2026-09-24**

## Objetivo

Adicionar três caixotes de carga como props decorativos e bloqueadores à cena de Dagruve, reforçando o tema de docas.

## Escopo

- Gerar e integrar três PNGs inéditos de `caixote` em `256x256` com alfa.
- Armazenar candidatas rastreáveis em `.atena/generated/asset-candidates/props/dagruve/`.
- Expor `caixote` no componente de prop e usar uma instância de cada variante em Dagruve.
- Atualizar o manifesto e testar presença, dimensão, alfa e registro do tipo.

## Não objetivos

- Copiar o caixote de `nottcard-ai` para o jogo.
- Alterar dados de combate, ondas, lore, fases ou o lote pendente de Brook.

## Procedência

- Referência externa aprovada: `D:\dev\nottgard\games\IA\nottcard-ai\assets\world\props\caixote.png`.
- Referência interna aprovada: `assets/props/pilar_01.png`.
- As saídas são designs novos, não cópias.

## Critérios de aceite

1. Os três PNGs possuem dimensões `256x256` e transparência real.
2. A cena Dagruve resolve as três variantes pelo componente existente.
3. O tipo `caixote` fica disponível no editor.
4. Validador de assets e testes do Godot passam.

## Reconciliação

- `assets/props/caixote_01.png` a `caixote_03.png` foram integrados em `256x256`.
- `ui/prop.gd` expõe o tipo `caixote`; `ui/stages/dagruve.tscn` contém uma instância de cada variante.
- O manifesto passou de 239 para 242 entradas com hashes, candidatas e referências do lote.
- Evidência: `../evidence/EVID-017-caixotes-de-dagruve.md`.
