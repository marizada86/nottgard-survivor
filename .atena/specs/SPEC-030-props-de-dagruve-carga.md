# SPEC-030 — Carga abandonada de Dagruve

Status: **concluída e reconciliada em 2026-09-24**

## Objetivo

Adicionar três volumes de carga abandonada ao chão de Dagruve, criando variedade visual com sacos e tecido sem revelar conteúdo, dono, facção ou lore novo.

## Escopo

- Gerar e integrar três PNGs inéditos de `carga` em `256x256` com alfa.
- Expor `carga` no componente de prop e posicionar uma instância de cada variante em Dagruve.
- Registrar candidatas, referências e hashes no manifesto.
- Testar presença, dimensão, alfa e registro do tipo.

## Procedência

- Referências internas aprovadas: `assets/props/doca_01.png`, `assets/props/doca_02.png`, `assets/props/doca_03.png`, `assets/props/caixote_01.png`, `assets/props/caixote_02.png` e `assets/props/caixote_03.png`.
- As saídas são designs originais, não cópias.

## Critérios de aceite

1. Os três PNGs possuem dimensões `256x256`, alfa real e não exibem texto, símbolos, runas, emblemas ou conteúdo identificável.
2. A cena Dagruve resolve as três variantes pelo componente de props existente.
3. Validador de assets e testes Godot passam.

## Reconciliação

- `assets/props/carga_01.png` a `carga_03.png` foram integrados com as candidatas versionadas.
- O componente de props e a cena Dagruve passaram a resolver as três variantes determinísticas de `carga`.
- O manifesto passou de 260 para 263 PNGs esperados e de 252 para 255 gerações previstas.
- A evidência de produção e validação está em `EVID-024-carga-de-dagruve.md`.
