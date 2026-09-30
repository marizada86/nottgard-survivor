---
id: "SPEC-098"
title: "Geração das HQs da Trilha B — HQN-11 a HQN-14"
status: "concluída — 16 candidatas finais aprovadas pelo dono; HQN-14 Q1 corrigida em v02"
created: "2026-09-30"
relations:
  - "[[ART-PROMPTS-029-hqs-onda-2]]"
  - "[[PLAN-040-hqs-novas-highlights-do-vault-2026-09-29]]"
  - "[[SPEC-095-revisao-de-proporcao-e-identidade-das-hqs]]"
  - "[[EVID-124-hqn-11-a-14-candidatas-2026-09-30]]"
---

# SPEC-098 — Geração das HQs da Trilha B

## Descoberta

ART-PROMPTS-029 contém quatro quadros completos para cada HQN-11 a HQN-14.
As referências necessárias (Bromnor, Brook, Kayron, Sylas, Maelor, Zynara e
Nyrelia) existem em `assets/portraits/`. O inventário atual de candidatas v01
contém HQN-01 a HQN-10; não foram encontradas candidatas para esta trilha.

## Escopo

1. Gerar 16 candidatas v01, quatro quadros para cada HQN-11, HQN-12, HQN-13 e
   HQN-14, seguindo os prompts existentes em ART-PROMPTS-029.
2. Usar as referências de personagem especificadas em cada prompt; respeitar
   identidade racial/física, enquadramento, sequência, estilo, restrições de
   conteúdo e respiro inferior para a interface.
3. Salvar cada saída em
   `.atena/generated/art-candidates/hq/hq_n<nn>_q<n>_v01.png`, sem sobrescrever
   outros arquivos. Apresentar um quadro por vez e aguardar aprovação explícita
   antes de gerar o próximo.
4. Registrar arquivos gerados, revisões e aprovações em evidência e reconciliar
   o status de ART-PROMPTS-029 após a rodada.

## Não objetivos

- Não criar nem reescrever prompts, textos de UI, catálogo ou lore.
- Não gerar HQN-15 a HQN-18 (Trilha C opcional).
- Não alterar `assets/`, código, dados, mecânicas ou implementação das HQs.
- Não promover nem redimensionar candidatas; admissão no jogo é etapa separada.
- Não sobrescrever v01 existentes nem gerar variantes sem feedback explícito.

## Salvaguardas narrativas e visuais

- HQN-11: violência do Massacre Celestial somente por clarões e silhuetas; sem
  ferimentos, sangue ou atribuição de quem matou Bromnor.
- HQN-12: não misturar o Cerco da HQN-13; Gilly e Hrothgar ficam distantes ou
  em silhueta, sem fixar aparência não canônica.
- HQN-13: nunca mostrar a chacina; representar muralha e rocha sem vítimas
  visíveis; não expor como conhecimento do jogador o segredo pedido por Helion.
- HQN-14: não usar revelações de Nyrelia posteriores à Sessão 09; preservar o
  reencontro e as falas já propostas sem inserir texto na imagem.
- Em todas: pixel art sombria 16:9, sem texto/UI/marca-d'água, sem gore e com o
  terço inferior visualmente calmo; personagens nomeados seguem seus retratos.

## Critérios de aceite

1. Os 16 arquivos esperados existem com nomes versionados, sem alterar v01
   anteriores ou ativos oficiais.
2. Cada quadro segue o prompt correspondente e mantém continuidade visual com
   os demais quadros da mesma HQ.
3. Escala, anatomia adulta, raça, silhueta e vestuário dos personagens com
   referência são coerentes com os retratos; personagens sem referência não
   ganham características canônicas inventadas.
4. Cada candidata é aprovada explicitamente pelo dono antes da próxima geração;
   correções solicitadas são registradas e salvas sem sobrescrita.
5. Evidência registra o resultado final e ART-PROMPTS-029 deixa de dizer que
   toda a Onda 2 aguarda geração, sem marcar HQN-07 a HQN-10 como pendentes.

## Impactos

- Novas candidatas em `.atena/generated/art-candidates/hq/`.
- Evidência e reconciliação de estado em `.atena/evidence/` e
  `.atena/generated/ART-PROMPTS-029-hqs-onda-2.md`.
- Nenhuma mudança em lore canônica, `assets/`, runtime ou regras do jogo.

## Plano de voo

1. Aprovar este escopo e o plano.
2. Para cada quadro, carregar as referências nomeadas no prompt, gerar uma
   imagem distinta com a ferramenta ImageGen integrada e inspecioná-la contra
   os critérios e salvaguardas.
3. Copiar a candidata aprovada para o caminho versionado no projeto; apresentar
   ao dono e aguardar sua decisão antes de avançar.
4. Se reprovada, aplicar somente o ajuste solicitado e salvar como versão
   seguinte, preservando a anterior; se a causa implicar lore ou escopo, pausar
   e pedir direção.
5. Após os 16 quadros, conferir nomes e arquivos, registrar aprovações e
   reconciliar ART-PROMPTS-029. Não admitir as imagens em `assets/`.

## Evidência e reconciliação

A execução foi concluída e registrada em
[[EVID-124-hqn-11-a-14-candidatas-2026-09-30]]. Os 16 quadros finais foram
aprovados explicitamente, um por vez. HQN-14 Q1 usa a candidata v02 após a
clarificação do dono de que a figura encapuzada é Nyrelia; a v01 anterior foi
preservada, totalizando 17 arquivos no diretório para 16 quadros finais. As
outras 15 candidatas finais são v01. Todas as 17 imagens verificadas medem
1672×941 (razão 1,7768, formato praticamente 16:9). ART-PROMPTS-029 foi
reconciliado sem reescrever seus prompts. Nenhuma candidata foi promovida a
`assets/`.
