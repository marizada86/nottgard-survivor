---
id: "SPEC-108"
title: "Ciclo de animação de guardiao_copia"
status: "ciclo completo aprovado visualmente; admissão no runtime depende de SPEC própria"
created: "2026-09-30"
relations:
  - "[[PLAN-048-geracao-animacoes-mobs-onda-1-2026-09-30]]"
  - "[[SPEC-107-piloto-visual-guardiao-copia]]"
  - "[[ART-PROMPTS-037-ciclo-guardiao-copia]]"
  - "[[EVID-135-piloto-guardiao-copia-2026-09-30]]"
  - "[[EVID-136-ciclo-guardiao-copia-2026-09-30]]"
  - "[[SPEC-109-admissao-animacoes-guardiao-copia]]"
---

# SPEC-108 — Ciclo de animação da variante guardiao_copia

## Intenção

Completar o ciclo candidato de 26 quadros de guardiao_copia reutilizando os
quadros aprovados de guardiao_verdadeiro somente como referências de pose. Os
três quadros do piloto aprovado em SPEC-107 são preservados; gerar somente as
23 poses ausentes.

## Escopo

- Gerar exatamente idle_01–03, move_00–05, attack_00–01, attack_03,
  death_00–04 e special_00–05.
- Em cada uma das 23 chamadas independentes, usar
  assets/enemies/guardiao_copia.png como referência de identidade e o quadro
  aprovado correspondente de
  .atena/generated/art-candidates/enemies-wave-1/guardiao_verdadeiro/frames/
  como referência de pose.
- Guardar os 23 candidatos selecionados em
  .atena/generated/art-candidates/enemies-wave-1/guardiao_copia/frames/;
  manter os três quadros aprovados em guardiao_copia/pilot/, sem cópias.
- Completar o índice do ciclo no manifesto e registrar prompts, originais,
  resultados e QA em evidência local.

Quadros-fonte exatos:

| Estado | Arquivos de pose |
|---|---|
| idle | guardiao_verdadeiro_idle_01_v01.png, idle_02_v01.png, idle_03_v01.png |
| move | guardiao_verdadeiro_move_00_v01.png até move_05_v01.png |
| attack | guardiao_verdadeiro_attack_00_v01.png, attack_01_v01.png, attack_03_v01.png |
| death | guardiao_verdadeiro_death_00_v01.png até death_04_v01.png |
| special | guardiao_verdadeiro_special_00_v01.png até special_05_v01.png |

## Não objetivos

- Regenerar idle_00, attack_02 ou death_05, aprovados no piloto.
- Alterar arte oficial, runtime, cenas, dados, código, animações instaladas ou
  gameplay; admitir, versionar, publicar ou compartilhar candidatos.
- Gerar poses além das 23 listadas, usar PNGs finalizados do verdadeiro como
  substitutos ou usar provedor pago/CLI alternativo.
- Enviar qualquer quadro de pose novo ao ImageGen antes da autorização
  específica de transferência das referências enumeradas nesta SPEC.

## Critérios de aceite

1. Há 23 novos candidatos, um por estado listado, e o índice de 26 estados
   aponta para esses 23 e para os três arquivos já aprovados no piloto.
2. Cada candidato final mede 320×480, tem RGBA com cantos transparentes,
   silhueta conectada com solidez mínima de 0,90, figura inteira e ancoragem
   inferior estável. Margem lateral mínima de 8 px quando a pose permitir;
   exceções de pose são documentadas sem cortar partes do personagem.
3. Os quadros preservam armadura cinza/prata, detalhes dourados, asas
   cinza-escuras e a lança curta dourada/de aço da cópia; não incluem runas ou
   brilho violeta, veios violetas, olhos brilhantes nem cajado cristalino longo
   do verdadeiro.
4. Os estados e as poses individuais continuam legíveis, com escala coerente
   entre os 26 quadros. A inspeção visual e técnica é registrada por estado;
   geração não equivale a aprovação visual final do ciclo.
5. Prompts, arquivos-fonte autorizados, hashes, originais e resultados finais
   têm trilha local rastreável. Nenhuma referência fonte é alterada.
6. Todos os 23 quadros continuam candidatos fora do runtime; nenhum asset
   oficial ou de runtime muda.

## Impactos e limites

Escritas locais limitadas a esta SPEC, ao registro de prompts do ciclo, a 23
novos candidatos e seus originais/metadados locais, ao manifesto, e à evidência
e pranchas de QA. O dono autorizou a geração e, em 2026-09-30, a transferência
somente destes 24 arquivos:

- assets/enemies/guardiao_copia.png (identidade, em conjunto com cada pose);
- 23 arquivos de pose listados acima, somente para a geração correspondente.

Cada chamada recebe apenas a imagem estática da cópia e uma pose correspondente.
Nenhuma outra referência local está autorizada.

## Plano de voo

1. Transferência confirmada pelo dono para os exatos 24 arquivos acima; em cada
   chamada independente, enviar a imagem de identidade e apenas uma pose.
2. Conferir novamente fontes, destinos livres e hashes; se alguma fonte faltar
   ou houver colisão de saída, pausar e registrar a exceção.
3. Executar 23 chamadas individuais pelo ImageGen integrado, cada uma com a
   imagem estática da cópia como identidade e apenas a pose correspondente como
   referência de ação/composição. Não enviar referências adicionais.
4. Preservar cada saída bruta em caminho novo e derivar PNG 320×480 por
   vizinho-mais-próximo, preservando alfa; registrar caminho e hash dos dois.
5. Auditar dimensões, alfa, solidez, margens, escala e identidade; produzir uma
   prancha e evidência por lote e atualizar o manifesto.
6. Parar com os 26 candidatos organizados para revisão do dono. Qualquer
   regeneração, admissão no runtime ou alteração de escopo exige decisão própria.

## Reconciliação

Após os critérios verificáveis, registrar a aprovação de geração já recebida,
o gate de transferência, os resultados e as exceções. Manter a variante de
guardiao_copia separada da linha-base de 160 quadros de PLAN-048 e do asset
oficial até aprovação visual e SPEC de admissão próprias.

## Resultado da execução — 2026-09-30

As 23 chamadas autorizadas foram concluídas; cada uma usou a identidade estática
da cópia e apenas a pose correspondente previamente listada. Os 23 originais
1024×1536 RGBA e derivados 320×480 RGBA foram preservados em `raw/` e `frames/`.
O índice do manifesto agora relaciona estado, saída, pose-fonte e original.
QA por `tools/audit_alpha_solidity.gd` registrou 23 arquivos, solidez mínima
0,9685 (arredondada a 0,969 pelo auditor), acima de 0,90; dimensões,
transparência dos cantos e hashes estão no [[EVID-136-ciclo-guardiao-copia-2026-09-30]].
Dois quadros têm margem visível direita inferior a 8 px por causa da pose/arma
(`attack_01`: 4 px; `death_00`: 5 px); sem corte visível. Franjas alfa de 1/255
alcançam algumas bordas, mas permanecem abaixo do limiar de visibilidade usado
no QA. Em 2026-09-30, o dono aprovou visualmente o ciclo completo. A aprovação
cobre a aceitação dos candidatos, não sua admissão no runtime. Nenhum candidato
foi admitido nem alterou asset oficial, cena, dado ou código.
