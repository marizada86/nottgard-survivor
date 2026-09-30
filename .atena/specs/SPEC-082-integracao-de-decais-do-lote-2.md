# SPEC-082 — Integração de decais do Lote 2

Status: **implementada parcialmente — 16 decais admitidos; Docas aguarda âncora seca** (2026-09-29).

## Intenção

Adicionar remendos e trilhas aprovados do Lote 2 como decoração determinística
do chão dos nove biomas, sem mudar navegação, colisão, seed de batalha, ondas
ou o contrato de y-sort.

## Escopo

- Admitir em `assets/decals/` as versões normalizadas aprovadas de remendo e
  trilha dos oito biomas com área seca declarada. Docas permanece no cofre até
  receber uma âncora de cais aprovada.
- Criar uma camada visual abaixo de props, heróis, inimigos e interações, mas
  acima do piso-base, com seleção determinística por `stage_id` e `visual_seed`.
- Manter a estrutura grande fora deste primeiro corte: sua admissão depende da
  inspeção visual manual do BUG-013.
- Adicionar testes para determinismo, isolamento de colisão e existência dos
  assets usados por cada bioma.

## Não objetivos

- Não trocar props existentes, mover nós nas cenas, editar PNGs brutos ou
  alterar `block_radius`, pathfinding, terreno lógico, balanceamento e VFX.
- Não admitir estruturas nem integrar a HQ-piloto nesta spec.

## Plano de voo

1. Definir o manifesto de remendo/trilha por bioma e os destinos oficiais.
2. Implementar o renderer de decais no chão com posições derivadas apenas de
   `stage_id` e `visual_seed`.
3. Promover os 18 PNGs derivados necessários, sem sobrescrever fontes brutas.
4. Testar seed, ordem visual e invariância de colisões; executar suíte e smoke.
5. Capturar cada bioma no QA e reconciliar a fila.
6. Corrigir e auditar a máscara alfa das candidatas antes de nova inspeção
   visual; o posicionamento fino só é decidido depois que a composição puder
   ser lida sem o fundo cromático.
7. Rejeitar áreas de água, corrente, Estige e bloqueios para todo decal;
   manter Docas sem prévia até que uma âncora seca de cais seja definida.

## Critérios de aceite

1. Cada bioma com área seca declarada mostra ao menos um remendo e uma trilha
   coerentes com seu piso. Docas fica explicitamente sem prévia até receber
   uma âncora de cais aprovada.
2. Reabrir a mesma seed preserva posição e variante de todos os decais.
3. Decais não bloqueiam, não recebem y-sort e não ocultam atores ou props.
4. Suíte, smoke e inspeção visual dos nove biomas passam.

## Gate

BUG-013 foi fechado após a inspeção visual aprovada. Os 16 decais dos oito
biomas com área seca foram admitidos nesta spec. A integração posterior dos
dois decais de Docas e das nove estruturas foi executada pela SPEC-100; Docas
segue sem prévia até existir uma âncora seca. HQs permanecem fora do escopo
aprovado. Ver EVID-127.

## Reconciliação posterior — 2026-09-30

Os arquivos dos decais de Docas agora existem em `assets/decals/` e o manifesto
usa esses caminhos oficiais, mas `GroundDecals.placements("docas", seed)` segue
vazio para não desenhar sobre a água. A SPEC-100 cobre essa admissão e as
estruturas; os critérios de determinismo e segurança desta spec continuam
válidos para os oito biomas ativos.
