# SPEC-029 — Estruturas de doca de Dagruve

Status: **concluída e reconciliada em 2026-09-24**

## Objetivo

Adicionar três estruturas de doca baixas a Dagruve, reforçando o tema portuário com tábuas, estacas e amarras sem inserir propriedade, facção ou lore novo.

## Escopo

- Gerar e integrar três PNGs inéditos de `doca` em `256x256` com alfa.
- Expor `doca` no componente de prop e posicionar uma instância de cada variante em Dagruve.
- Registrar candidatas, referências e hashes no manifesto.
- Testar presença, dimensão, alfa e registro do tipo.

## Procedência

- Referências internas aprovadas: `assets/props/rede_01.png`, `assets/props/rede_02.png`, `assets/props/rede_03.png`, `assets/props/barril_01.png`, `assets/props/barril_02.png` e `assets/props/barril_03.png`.
- As saídas são designs originais, não cópias.

## Critérios de aceite

1. Os três PNGs possuem dimensões `256x256`, alfa real e não exibem texto, símbolos, runas, emblemas ou marcações de propriedade.
2. A cena Dagruve resolve as três variantes pelo componente de props existente.
3. Validador de assets e testes Godot passam.

## Reconciliação

- `assets/props/doca_01.png` a `doca_03.png` foram integrados com as candidatas versionadas.
- O componente de props e a cena Dagruve passaram a resolver as três variantes determinísticas de `doca`.
- O manifesto passou de 257 para 260 PNGs esperados e de 249 para 252 gerações previstas.
- A evidência de produção e validação está em `EVID-023-estruturas-de-doca-de-dagruve.md`.
