# SPEC-022 — Braseiros de Dagruve

Status: **concluída e reconciliada em 2026-09-24**

## Objetivo

Adicionar três braseiros decorativos e bloqueadores à cena de Dagruve, mantendo a leitura isométrica e o fallback procedimental do prop.

## Escopo

- Gerar três PNGs inéditos de `braseiro`, em `256x256`, com canal alfa.
- Armazenar as candidatas em `.atena/generated/asset-candidates/props/dagruve/`.
- Integrar as versões aprovadas em `assets/props/braseiro_01.png` a `braseiro_03.png`.
- Expor `braseiro` como tipo de prop e posicionar uma instância de cada variante em `ui/stages/dagruve.tscn`.
- Cobrir presença, dimensão, alfa e registro do tipo com teste automatizado.

## Não objetivos

- Alterar o trabalho local de animações da Brook ou qualquer outro herói.
- Copiar arquivos do `nottcard-ai` para o jogo.
- Alterar dados de combate, ondas, lore ou balanceamento.

## Referências e procedência

- Referência externa autorizada pelo dono: `D:\dev\nottgard\games\IA\nottcard-ai\assets\world\props\braseiro.png`.
- Referências internas autorizadas: `assets/props/pilar_01.png` e `assets/props/cristal_01.png`.
- As referências orientam estilo; os três resultados são composições novas e não cópias.

## Critérios de aceite

1. As três imagens existem em `256x256` e têm transparência real.
2. A cena Dagruve resolve as três variações pelo mecanismo normal de props.
3. `braseiro` aparece no seletor do componente de prop.
4. O teste geral do projeto, o teste específico e a validação do manifesto passam.

## Plano de voo

1. Inspecionar as referências e gerar três silhuetas deliberadamente distintas.
2. Conferir alfa e normalizar cópias de integração para `256x256`.
3. Integrar os arquivos, o tipo e as instâncias da cena sem modificar o lote de Brook.
4. Registrar a procedência, atualizar o manifesto e executar as validações.

## Reconciliação

- `assets/props/braseiro_01.png` a `braseiro_03.png` foram integrados em `256x256`.
- `ui/prop.gd` expõe o tipo `braseiro`; `ui/stages/dagruve.tscn` contém uma instância por variante.
- O manifesto passou de 236 para 239 entradas e registra hashes, candidatas e referências do lote.
- Evidência: `../evidence/EVID-016-braseiros-de-dagruve.md`.
