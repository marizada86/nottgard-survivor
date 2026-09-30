---
id: "PLAN-045"
title: "Geração do piloto de animação do cultista de adaga"
status: "execução reconciliada; 24 candidatas aprovadas e versões alfa preparadas; método 1 recomendado para próximas ondas"
created: "2026-09-29"
relations:
  - "[[SPEC-097-geracao-das-imagens-de-arte-pendentes]]"
  - "[[ART-PROMPTS-031-piloto-animacao-cultista-adaga]]"
---

# PLAN-045 — Piloto de animação do cultista de adaga

## Pedido do dono

Preparar um plano para gerar apenas as imagens do piloto de animação do
cultista de adaga.

## Descoberta

O CANDIDATES-MANIFEST-002 lista 24 saídas do piloto sem arquivos nos caminhos
esperados: 20 imagens independentes e quatro tiras.

## Escopo

- Executar os dois métodos do piloto do cultista, incluindo um quadro inicial
  de identidade e a comparação visual e de esforço entre os métodos.
- Atualizar os manifestos de fila e registrar evidências somente depois de
  conferir os arquivos resultantes.
- Manter as candidatas isoladas de `assets/` até revisão e decisão explícitas.

## Fora de escopo

- Gerar HQs ou assets adicionais fora do piloto.
- Admitir candidatos, alterar o jogo ou substituir assets oficiais.

## Plano de voo

1. **Gate de execução:** aprovar SPEC-097 e este plano de voo.
2. **Piloto do cultista:** gerar E01 com a arte oficial como referência. Após
   aprovar a identidade, completar E02–E20 mantendo a referência aprovada;
   gerar E21–E24 como quatro tiras. Conservar os resultados separados e
   comparar consistência, recorte, regenerações e esforço manual.
3. **Revisão e reconciliação:** conferir nomes e dimensões, montar prancha,
   atualizar CANDIDATES-MANIFEST-002 (ou sucessor versionado), guardar
   evidência e reconciliar ART-PROMPTS-031.
4. **Decisão posterior:** apresentar as candidatas para seleção. Admissão em
   `assets/` e integração técnica exigem seu próprio gate e não fazem parte
   desta geração.

## Critérios de aceite

1. O piloto contém todas as 24 saídas solicitadas por ART-PROMPTS-031, com
   identidade coerente, direção para a direita, leitura das pernas no ciclo de
   movimento e distinção clara entre os métodos.
2. A comparação do piloto permite decidir qual método usar em ondas futuras,
   com número de regenerações e esforço de ajuste registrados.
3. Manifesto e evidência correspondem aos arquivos realmente presentes;
   nenhum arquivo oficial é alterado nesta fase.

## Riscos e controles

- **Inconsistência do piloto:** aprovar E01 antes de usá-lo como referência;
  comparar as duas abordagens antes de escolher método futuro.
- **Geração confundida com admissão:** salvar apenas nas pastas de candidatas e
  não tocar nos caminhos oficiais.

## Portão ADD

Rascunho para aprovação do plano de voo. A SPEC-097 define o limite e os
critérios; nenhuma imagem foi gerada nesta etapa. Após a aprovação, a execução
Execução concluída dentro do escopo. Em 2026-09-30 o dono aprovou as 24
candidatas; as versões alfa preservam os PNGs originais. A comparação mostrou
que o recorte automático das tiras E22–E24 corta detalhes entre células, então
o método 1 (quadros individuais) é recomendado para próximas ondas. Os
resultados estão em [[EVID-125-piloto-cultista-aprovacao-alfa-comparacao-2026-09-30]].

As candidatas permanecem fora de `assets/`; admissão e integração técnica
exigem seu próprio gate.
