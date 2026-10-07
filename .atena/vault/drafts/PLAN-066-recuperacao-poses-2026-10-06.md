---
title: Recuperação da corrida de Durvall por poses
created: 2026-10-06
plan: PLAN-066
spec: SPEC-133
canonical: false
status: REJECTED_CONTACT_PAIR
request_classification: IN_PLAN
approval_mode: per-batch
checkpoint: B-002 / S-005 / R-001
---

Gerar uma pose por imagem em vez de seis poses simultâneas é a proposta para reduzir a repetição das pernas observada na EVID-173. A mudança permanece no piloto lateral, com mesmo personagem, velocidade, seis quadros e 10 fps. Não altera arquitetura do jogo, dependências, lore ou contratos canônicos.

A classificação inicial como mudança que exigia nova aprovação foi revisada antes de perguntar ao dono: é escolha técnica no escopo já autorizado por “atena pode seguir as recomendações”. A revisão exigida após três tentativas está concluída; recuperação limitada a seis imagens, começando pela dupla de contatos e interrompendo se falhar. Aprovação visual de integração final continua independente.

Resultado: somente contatos 1/4 produzidos; não demonstram alternância correta. Lote interrompido nessa dupla, quatro imagens restantes não geradas. EVID-173 registra a falha e a proposta de representação articulada R-002.

## Escopo e voo proposto

Lote de até seis imagens no ImageGen, usando somente aparência oficial autorizada e guia local de pose. Primeiro gerar contato 1 (perna A à frente) e contato 4 (perna B à frente). Inspecionar identidade anatômica, enquadramento e sobreposição. Se a dupla ainda não alternar corretamente, interromper esse lote sem gerar as outras quatro poses. Se passar, gerar apoio/recuperação e impulso das duas pernas com a mesma escala e origem.

As seis imagens serão lidas pelo adaptador local como seis texturas, com configuração de apresentação comum. Nenhuma normalização individual de escala ou origem para mascarar erros. Conferir contato, loop 6→1 e amplitude moderada; inserir somente candidata que passe na triagem, no teste isolado com entrada real e alternância atual/piloto. O dono avalia antes das outras direções.

## Impacto e aceite

Impacto: até seis chamadas de geração neste novo lote em vez de uma folha por tentativa; cada fase permite inspeção própria, com risco de variação de identidade entre imagens. Mitigação: mesma referência corporal e escala, conferência dos contatos antes do restante, sem corrigir anatomia por transformação de pixels. Não há garantia de sucesso.

Aceite: duas pernas identificáveis alternando o apoio; poses diferentes para as duas metades; passada moderada; origem e corpo consistentes; espada e câmera preservadas; ciclo legível no tamanho do jogo. Reutilizar os demais critérios da SPEC-133. Gap BLOCKING técnico: nenhum; aprovação visual final pendente.

## Evidência e recuperação

Preservar PNGs e prompts de cada pose, auditar alfa/enquadramento e hashes dos originais. Revalidar movimento real e F8 somente se houver candidata integrada. Se reprovar, manter v03/revisão 2 no teste e registrar o defeito sem admitir os novos assets. Commit, publicação, B-003/B-004 e aprovação visual permanecem gates separados.
