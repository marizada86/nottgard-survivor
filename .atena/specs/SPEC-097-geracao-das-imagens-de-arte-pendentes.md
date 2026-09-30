---
id: "SPEC-097"
title: "Geração do piloto de animação do cultista de adaga"
status: "24 candidatas aprovadas; alfa preparado; método 1 recomendado para as próximas ondas"
created: "2026-09-29"
relations:
  - "[[PLAN-045-piloto-animacao-cultista-adaga-2026-09-29]]"
  - "[[ART-PROMPTS-031-piloto-animacao-cultista-adaga]]"
  - "[[PLAN-041-animacao-padrao-zumbi-para-inimigos-e-interacoes-2026-09-29]]"
---

# SPEC-097 — Geração do piloto de animação do cultista de adaga

## Descoberta

O manifesto CANDIDATES-MANIFEST-002 lista 24 saídas do piloto do cultista de
adaga e nenhuma delas existe no caminho esperado: 20 quadros independentes
(método 1) e quatro tiras (método 2). Este trabalho compara os métodos para
o piloto; não estende a geração aos demais inimigos.

## Escopo

1. Executar o piloto do cultista de adaga conforme ART-PROMPTS-031: primeiro
   E01 para aprovação de identidade; depois E02–E20 quadro a quadro e E21–E24
   como tiras, preservando os dois métodos para comparação.
2. Manter todas as saídas em `.atena/generated/art-candidates/` e registrar
   arquivo, prompt, versão, referência e resultado da inspeção no manifesto
   correspondente.
3. Preparar pranchas e evidência para decisão humana sobre qualidade e sobre
   o método do piloto.

## Não objetivos

- Não alterar, promover nem sobrescrever arquivos em `assets/`.
- Não integrar quadros em spritesheets de runtime nem mudar código, dados,
  lore ou regras do jogo.
- Não gerar novas variações além da primeira candidata; repetir uma geração
  apenas se um critério objetivo falhar, registrando a causa.
- Não estender o piloto do cultista aos demais inimigos ou interações.
- Não gerar HQs.

## Critérios de aceite

1. O piloto mantém o contrato de identidade, câmera, direção para a direita,
   fundo removível e silhueta sólida definido em ART-PROMPTS-031.
2. O piloto contém E01–E20 e E21–E24, sem confundir os dois métodos; todas as
   imagens são legíveis e recortáveis para a célula de 256×384.
3. Cada saída tem caminho e proveniência rastreáveis; nenhuma candidata é
   admitida em `assets/` sem seleção explícita e o fluxo de aprovação previsto
   nos registros de origem.
4. As pranchas, as contagens geradas/reprovadas e as decisões ficam registradas
   em `.atena/evidence/`; os manifestos refletem os arquivos reais.

## Impactos

- Candidatas e manifestos em `.atena/generated/art-candidates/` e
  `.atena/generated/`.
- Evidência de revisão em `.atena/evidence/`.
- ART-PROMPTS-031 recebe reconciliação de execução depois das gerações e
  decisões correspondentes; intenção canônica não é alterada.

## Plano de voo

1. Aprovar este escopo e o plano de voo.
2. Congelar os prompts e conferir referências e nomes de saída antes de cada
   lote; preservar os candidatos já existentes como baseline.
3. Gerar E01 do cultista como identidade. Após aprovação visual, produzir
   E02–E20 quadro a quadro e E21–E24 em tiras; revisar os métodos lado a lado.
4. Auditar arquivos, nomes, contagens e legibilidade; atualizar manifestos e
   registrar pranchas e evidências.
5. **Decisão registrada:** o dono aprovou as 24 candidatas. A comparação em
   EVID-125 recomenda o método 1 para próximas ondas, pois o recorte automático
   das tiras E22–E24 cortou detalhes que atravessam os limites das células.
   Encerrar a geração sem admissão automática em `assets/`.

## Evidência e reconciliação

Inventário e prompts estão registrados em
[[EVID-124-piloto-cultista-candidatas-geradas-2026-09-29]] e
[[IMAGEGEN-LOG-001-piloto-cultista-2026-09-29]]. A aprovação visual das 24
candidatas, as cópias alfa, a comparação dos métodos e a recomendação do método
1 para próximas ondas estão reconciliadas em
[[EVID-125-piloto-cultista-aprovacao-alfa-comparacao-2026-09-30]] e
[[ART-PROMPTS-031-piloto-animacao-cultista-adaga]]. A admissão e integração
estavam fora da geração; o dono as autorizou depois em [[SPEC-099-integracao-animacoes-cultista-adaga]],
com resultado em [[EVID-126-integracao-animacoes-cultista-adaga-2026-09-30]].
