# SPEC-025 — Livros de Dagruve

Status: **concluída e reconciliada em 2026-09-24**

## Objetivo

Adicionar três props de livros e documentos abandonados a Dagruve, ampliando a variedade do cenário sem declarar conteúdo, facção ou lore novo.

## Escopo

- Gerar e integrar três PNGs inéditos de `livros` em `256x256` com alfa.
- Expor `livros` no componente de prop e posicionar uma instância de cada variante em Dagruve.
- Registrar candidatas, referências e hashes no manifesto.
- Testar presença, dimensão, alfa e registro do tipo.

## Não objetivos

- Incluir escrita legível, runas, símbolos, diagramas, emblemas ou marcas de facção.
- Alterar combate, ondas, fases ou lore.

## Procedência

- Referência externa aprovada: `D:\dev\nottgard\games\IA\nottcard-ai\assets\world\props\livros.png`.
- Referências internas aprovadas: `assets/props/caixote_01.png`, `assets/props/caixote_03.png` e `assets/props/velas_02.png`.
- As saídas são designs originais, não cópias.

## Critérios de aceite

1. Os três PNGs possuem dimensões `256x256`, alfa real e não exibem conteúdo legível ou simbologia.
2. A cena Dagruve resolve as três variantes pelo componente de props existente.
3. Validador de assets e testes Godot passam.

## Reconciliação

- `assets/props/livros_01.png` a `livros_03.png` foram integrados em `256x256`.
- `ui/prop.gd` expõe o tipo `livros`; `ui/stages/dagruve.tscn` contém uma instância de cada variante.
- O manifesto passou de 245 para 248 entradas e registra candidatas, referências e hashes do lote.
- Evidência: `../evidence/EVID-019-livros-de-dagruve.md`.
