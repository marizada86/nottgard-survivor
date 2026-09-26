# SPEC-028 — Restos ósseos genéricos de Dagruve

Status: **concluída e reconciliada em 2026-09-24**

## Objetivo

Adicionar três conjuntos de restos ósseos genéricos ao chão de Dagruve, criando variedade de ambientação sem definir espécie, evento, facção ou lore novo.

## Escopo

- Gerar e integrar três PNGs inéditos de `ossos` em `256x256` com alfa.
- Expor `ossos` no componente de prop e posicionar uma instância de cada variante em Dagruve.
- Registrar candidatas, referências e hashes no manifesto.
- Testar presença, dimensão, alfa e registro do tipo.

## Procedência

- Referência externa aprovada: `D:\dev\nottgard\games\IA\nottcard-ai\assets\world\props\ossos.png`.
- Referências internas aprovadas: `assets/props/rede_01.png`, `assets/props/rede_02.png` e `assets/props/rede_03.png`.
- As saídas são designs originais, não cópias.

## Critérios de aceite

1. Os três PNGs possuem dimensões `256x256`, alfa real e não exibem crânios, texto, símbolos, runas ou identificação de espécie.
2. A cena Dagruve resolve as três variantes pelo componente de props existente.
3. Validador de assets e testes Godot passam.

## Reconciliação

- `assets/props/ossos_01.png` a `ossos_03.png` foram integrados com as candidatas versionadas.
- O componente de props e a cena Dagruve passaram a resolver as três variantes determinísticas de `ossos`.
- O manifesto passou de 254 para 257 PNGs esperados e de 246 para 249 gerações previstas.
- A evidência de produção e validação está em `EVID-022-ossos-de-dagruve.md`.
