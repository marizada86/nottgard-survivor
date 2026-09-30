# EVID-113 — Candidatas do Lote 2 e HQ-piloto aprovadas

Data: 2026-09-29  
Decisão: aprovação explícita do dono após a geração em lote.

## Escopo aprovado

- 27 candidatas de cenário: estrutura, remendo e trilha para os nove biomas,
  em `.atena/generated/art-candidates/scenery/`.
- 27 versões normalizadas com alfa, em
  `.atena/generated/art-candidates/scenery-normalized/`.
- 4 candidatas da HQ-piloto `hq_n01`, em
  `.atena/generated/art-candidates/hq/`.

## Verificação executada

- As 31 candidatas têm proporção coerente com seu tipo: estruturas quadradas,
  decais em paisagem e HQs em 16:9.
- Os fundos quase magenta/ciano dos brutos de cenário foram convertidos em
  alfa nas versões derivadas; as 27 têm os quatro cantos transparentes.

## Gates preservados

- O Lote 2 não entra em `assets/` até BUG-013 passar na inspeção visual manual
  e existir a spec de integração de decais.
- A HQ-piloto não entra no jogo até sua integração e a conferência de
  fidelidade aos retratos dos personagens.

## Preparação técnica posterior

- A SPEC-082 criou uma prévia de remendos e trilhas limitada ao sandbox de QA.
  Ela lê as versões normalizadas no cofre e não adiciona PNGs do Lote 2 a
  `assets/`.
- A admissão definitiva continua condicionada à inspeção visual dos nove
  biomas e ao fechamento formal do BUG-013 para estruturas.
