# SPEC-026 — Barris de Dagruve

Status: **concluída e reconciliada em 2026-09-24**

## Objetivo

Adicionar três barris de carga às docas de Dagruve, ampliando a leitura ambiental sem introduzir escrita, símbolo, facção ou lore novo.

## Escopo

- Gerar e integrar três PNGs inéditos de `barril` em `256x256` com alfa.
- Expor `barril` no componente de prop e posicionar uma instância de cada variante em Dagruve.
- Registrar candidatas, referências e hashes no manifesto.
- Testar presença, dimensão, alfa e registro do tipo.

## Procedência

- Referência externa aprovada: `D:\dev\nottgard\games\IA\nottcard-ai\assets\world\props\barril.png`.
- Referências internas aprovadas: `assets/props/caixote_01.png`, `assets/props/caixote_02.png` e `assets/props/caixote_03.png`.
- As saídas são designs originais, não cópias.

## Critérios de aceite

1. Os três PNGs possuem dimensões `256x256`, alfa real e não exibem marcação, texto ou simbologia.
2. A cena Dagruve resolve as três variantes pelo componente de props existente.
3. Validador de assets e testes Godot passam.

## Reconciliação

- `assets/props/barril_01.png` a `barril_03.png` foram integrados em `256x256`.
- `ui/prop.gd` expõe o tipo `barril`; `ui/stages/dagruve.tscn` contém uma instância de cada variante.
- O manifesto passou de 248 para 251 entradas e registra candidatas, referências e hashes do lote.
- Evidência: `../evidence/EVID-020-barris-de-dagruve.md`.
