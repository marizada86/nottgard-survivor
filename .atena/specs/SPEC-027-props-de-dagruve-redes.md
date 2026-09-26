# SPEC-027 — Redes de Dagruve

Status: **concluída e reconciliada em 2026-09-24**

## Objetivo

Adicionar três redes de pesca ao chão de Dagruve, fortalecendo o tema de docas sem inserir texto, simbologia, facções ou lore novo.

## Escopo

- Gerar e integrar três PNGs inéditos de `rede` em `256x256` com alfa.
- Expor `rede` no componente de prop e posicionar uma instância de cada variante em Dagruve.
- Registrar candidatas, referências e hashes no manifesto.
- Testar presença, dimensão, alfa e registro do tipo.

## Procedência

- Referência externa aprovada: `D:\dev\nottgard\games\IA\nottcard-ai\assets\world\props\rede.png`.
- Referências internas aprovadas: `assets/props/barril_01.png`, `assets/props/barril_02.png` e `assets/props/barril_03.png`.
- As saídas são designs originais, não cópias.

## Critérios de aceite

1. Os três PNGs possuem dimensões `256x256`, alfa real e não exibem marcação, texto ou simbologia.
2. A cena Dagruve resolve as três variantes pelo componente de props existente.
3. Validador de assets e testes Godot passam.

## Reconciliação

- `assets/props/rede_01.png` a `rede_03.png` foram integrados com as candidatas versionadas.
- O componente de props e a cena Dagruve passaram a resolver as três variantes determinísticas de `rede`.
- O manifesto passou de 251 para 254 PNGs esperados e de 243 para 246 gerações previstas.
- A evidência de produção e validação está em `EVID-021-redes-de-dagruve.md`.
