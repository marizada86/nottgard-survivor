# SPEC-024 — Velas de Dagruve

Status: **concluída e reconciliada em 2026-09-24**

## Objetivo

Adicionar três pequenas fontes de luz para Dagruve, reforçando a atmosfera de névoa sem introduzir símbolos, facções ou lore novo.

## Escopo

- Gerar e integrar três PNGs inéditos de `velas` em `256x256` com alfa.
- Expor `velas` no componente de prop e posicionar uma instância de cada variante em Dagruve.
- Registrar candidatas, referências e hashes no manifesto.
- Testar presença, dimensão, alfa e registro do tipo.

## Não objetivos

- Integrar os candidatos anteriores que continham ornamentação ritualística ou emblema.
- Criar símbolos, runas, facções, eventos ou alterações de lore.
- Alterar combate, ondas, fases ou o lote de animação da Brook.

## Procedência

- Referência externa aprovada: `D:\dev\nottgard\games\IA\nottcard-ai\assets\world\props\vela.png`.
- Referências internas aprovadas: `assets/props/pilar_01.png`, `assets/props/caixote_01.png` e `assets/props/caixote_02.png`.
- As saídas aprovadas são originais e não copiam a referência.

## Critérios de aceite

1. Os três PNGs possuem dimensões `256x256`, alfa real e não incluem escrita, símbolo, runa, emblema ou bandeira.
2. A cena Dagruve resolve as três variantes pelo componente de props existente.
3. Validador de assets e testes Godot passam.

## Reconciliação

- `assets/props/velas_01.png` a `velas_03.png` foram integrados em `256x256`.
- `ui/prop.gd` expõe o tipo `velas`; `ui/stages/dagruve.tscn` contém uma instância de cada variante.
- O manifesto passou de 242 para 245 entradas e registra candidatas, referências e hashes do lote.
- Evidência: `../evidence/EVID-018-velas-de-dagruve.md`.
