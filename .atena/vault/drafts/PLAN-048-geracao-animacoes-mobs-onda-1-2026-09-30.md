---
id: "PLAN-048"
title: "Geração das animações dos mobs — Onda 1: Dagruve e Docas"
status: "lotes A–C e ciclo variante de guardiao_copia admitidos e verificados em 2026-09-30"
created: "2026-09-30"
relations:
  - "[[PLAN-041-animacao-padrao-zumbi-para-inimigos-e-interacoes-2026-09-29]]"
  - "[[PLAN-045-piloto-animacao-cultista-adaga-2026-09-29]]"
  - "[[PLAN-046-integracao-animacoes-cultista-adaga-2026-09-30]]"
  - "[[EVID-125-piloto-cultista-aprovacao-alfa-comparacao-2026-09-30]]"
  - "[[EVID-126-integracao-animacoes-cultista-adaga-2026-09-30]]"
  - "[[EVID-127-mobs-wave-1-gate-identidade-2026-09-30]]"
  - "[[EVID-135-piloto-guardiao-copia-2026-09-30]]"
  - "[[EVID-136-ciclo-guardiao-copia-2026-09-30]]"
---

# PLAN-048 — Geração das animações dos mobs, Onda 1

## Objetivo

Gerar candidatos de animação consistentes para os mobs ainda estáticos das
duas primeiras fases jogáveis — Dagruve e Docas — usando o padrão visual do
Zumbi e o método validado no piloto do `cultista_adaga`.

Ao final desta onda haverá candidatas revisáveis, prontas para uma decisão de
admissão posterior. Este plano **não** admite assets no jogo nem altera
gameplay, dados, cenas ou código.

## Estado conhecido

O runtime já contém três inimigos animados: `zumbi`, `cultista_adaga` e
`sacerdote_mente_derretida`. O piloto do cultista confirmou que o método de
**quadros individuais** preserva melhor a silhueta; tiras geradas diretamente
não serão usadas como fonte de produção nesta onda.

Os alvos remanescentes da Onda 1 são:

| Fase | Alvo | Perfil | Entrega de quadros |
|---|---|---|---:|
| Dagruve | `slime_corrosivo` | A — móvel | 20 |
| Dagruve | `cultista_arqueiro` | A — móvel | 20 |
| Dagruve | `cultista_cajado` | A — móvel | 20 |
| Dagruve | `notivago` | A — móvel | 20 |
| Dagruve/Docas | `criatura_corrompida` | A — móvel | 20 |
| Docas | `arch_hag` | A — móvel | 20 |
| Docas | `tentaculo_kraken` | C — imóvel | 14 |
| Docas | `guardiao_verdadeiro` | B — chefe | 26 |
| Docas | `guardiao_copia` | variante visual com reuso de poses | 26 (23 novos; fora do total único) |
| **Total único da linha-base** | | | **160** |

Perfis: A = `idle` 4, `move` 6, `attack` 4, `death` 6; B = perfil A +
`special` 6; C = `idle` 4, `attack` 4, `death` 6. A cópia reutiliza poses do
guardião verdadeiro apenas como referência; sua arte é gerada como variante
separada após a aprovação explícita da animação-base.

## Escopo

- Preparar prompts, fila e manifesto versionado para as 160 imagens candidatas.
- Gerar, conferir e organizar apenas candidatos em
  `.atena/generated/art-candidates/enemies-wave-1/`.
- Produzir pranchas de revisão por lote e evidências de dimensões, transparência,
  cobertura e consistência de escala.
- Registrar uma decisão por lote: aprovar, regenerar ou descartar.

## Fora de escopo

- Substituir `assets/enemies/*.png`, escrever em `assets/animations/`, ou
  modificar `ui/enemy_view.gd`, testes, JSONs ou balanceamento.
- Animar interações, quebráveis ou mobs de Shedaklah e fases posteriores.
- Criar direções norte/sul ou oito direções; a animação-base olha para a direita
  e a inversão horizontal de movimento é tratada apenas numa futura integração.
- Publicar, enviar ou compartilhar qualquer material fora do repositório local.

## Contrato artístico e técnico

Cada quadro candidato deve:

1. Usar a arte estática oficial de seu mob como referência de identidade.
2. Manter pixel art dark-fantasy em vista frontal 3/4, figura inteira, base no
   rodapé, margem lateral mínima de 8 px e fundo liso cromático removível.
3. Medir 256×384 para perfis A/C ou 320×480 para o chefe; ter canal alfa e
   solidez mínima de 0,90 — exceções exigem justificativa registrada.
4. Manter a mesma escala, paleta, silhueta e linha de chão dentro do estado.
5. Exibir uma ação legível: passo alternado no `move`, preparação/impacto/
   retorno no `attack`, e queda inequívoca no `death`.
6. Para `guardiao_verdadeiro`, reservar `special` para a habilidade de chefe;
   efeitos projetados ficam fora do sprite do personagem.

## Plano de voo

1. **Preparação controlada.** Criar `ART-PROMPTS-032`, `CHATGPT-FILA-005` e
   `CANDIDATES-MANIFEST-003`; cada item aponta para a arte estática, para o
   quadro do Zumbi e para o contrato deste plano.
2. **Gate de identidade.** Gerar e revisar somente um `idle_00` por alvo único
   (oito imagens). Nenhum ciclo é expandido antes de sua identidade ser aceita.
3. **Lote A — Dagruve básico.** Após o gate, gerar os quatro perfis A de maior
   exposição: slime, arqueiro, cajado e Notívago (80 quadros). Revisar uma
   prancha antes de continuar.
4. **Lote B — transição Dagruve/Docas.** Gerar criatura corrompida e Arch-hag
   (40 quadros); validar legibilidade e escala contra o cenário das Docas.
5. **Lote C — casos especiais.** Gerar o tentáculo imóvel (14 quadros) e o
   guardião verdadeiro (26 quadros, incluindo `special`). Só então preparar a
   proposta de reuso para `guardiao_copia`.
6. **QA e reconciliação.** Conferir manifestos contra arquivos reais, medir
   dimensões/alfa/solidez, revisar as pranchas e registrar `EVID-127` ou seu
   próximo ID livre. Candidatas reprovadas permanecem isoladas e recebem motivo
   de rejeição.
7. **Gate de admissão separado.** Apresentar as candidatas aprovadas e propor
   uma SPEC exclusiva para composição das tiras, integração no runtime e teste
   em run real. Nada entra em `assets/` sem essa aprovação.

## Critérios de aceite

1. As 160 candidatas previstas — ou as exceções explicitamente aprovadas —
   existem em caminhos versionados e batem com o manifesto.
2. Cada alvo aprovado tem prancha de revisão e relatório de qualidade; nenhum
   lote segue para o próximo sem registrar sua decisão.
3. Cada quadro aceito atende ao contrato visual/técnico, sem variação perceptível
   de escala ou identidade dentro do ciclo.
4. Nenhum asset oficial, arquivo de código ou dado de jogo é alterado.
5. A evidência permite uma futura admissão sem ambiguidade: origem, estado,
   dimensão, resultado da revisão e destino pretendido são rastreáveis.

## Riscos e controles

| Risco | Controle |
|---|---|
| Deriva de identidade entre imagens | Gate de `idle_00`; usar o quadro aprovado e a arte oficial em todas as gerações subsequentes. |
| Volume e retrabalho | Lotes de 80, 40 e 40 quadros, com decisão humana entre eles. |
| Slime e tentáculo perdem leitura pela altura | Revisar a composição em prancha; ajustar a ocupação da célula antes de completar o ciclo. |
| Chefe mistura personagem e VFX | `special` anima só a pose; VFX e telégrafos continuam como sistemas separados. |
| Candidata confundida com asset oficial | Raiz de candidatas isolada, manifesto e gate de admissão explícito. |

## Decisões solicitadas

| ID | Decisão | Recomendação |
|---|---|---|
| D-M1 | Executar esta primeira onda de oito criações únicas (160 quadros) | Aprovar; prioriza tudo que o jogador encontra em Dagruve e Docas. |
| D-M2 | Confirmar método de quadros individuais | Aprovar; o piloto mostrou perda de detalhes ao recortar tiras. |
| D-M3 | Autorizar reuso de `guardiao_verdadeiro` em `guardiao_copia`, sujeito à aprovação da base | Aprovar; preserva a identidade de uma cópia e evita geração redundante. |
| D-M4 | Manter o gate de identidade e revisão entre lotes | Aprovar; reduz regeneração em massa e protege consistência. |

## Gate ADD

Este é um rascunho de plano, não uma mudança de intenção canônica. A execução
começa somente após sua aprovação explícita de D-M1 a D-M4. A admissão dos
assets aprovados no jogo exigirá um segundo plano e uma SPEC limitada.

## Progresso reconciliado

Em 2026-09-30, o dono aprovou I01–I08; a decisão está registrada em
[[EVID-127-mobs-wave-1-gate-identidade-2026-09-30]]. Os quatro mobs do Lote A
receberam 20 quadros cada em células nativas 256×384 e foram aprovados pelo dono
([[EVID-128-lote-a-animacoes-mobs-2026-09-30]]). A produção avança agora para o
Lote B, com `criatura_corrompida` e `arch_hag`, recebeu 20 quadros candidatos
por mob (38 imagens novas e dois `idle_00` aprovados reaproveitados), em células
256×384; o dono aprovou os ciclos em 2026-09-30
([[EVID-133-lote-b-mobs-2026-09-30]]). Inicia-se o Lote C: `tentaculo_kraken`
(14 quadros, perfil C) e `guardiao_verdadeiro` (26 quadros, perfil B), em
células 256×384 e 320×480, respectivamente. Os 40 quadros candidatos estão
prontos, incluindo 38 imagens novas e dois `idle_00` aprovados reaproveitados;
QA e pranchas foram aprovados pelo dono em 2026-09-30
([[EVID-134-lote-c-mobs-2026-09-30]]). A condição de aprovação explícita do
ciclo-base para `guardiao_copia` está satisfeita. A comparação com a arte
estática da cópia revelou diferença de paleta e arma. O dono aprovou testar
uma variante que reutiliza poses, não os PNGs do verdadeiro; a SPEC-107 e os
prompts do piloto foram redigidos e a SPEC-107 foi aprovada pelo dono em
2026-09-30. O dono também autorizou a transferência das quatro referências
nomeadas; foram gerados três candidatos, registrados com QA e prancha em
[[EVID-135-piloto-guardiao-copia-2026-09-30]]. Em 2026-09-30, o dono aprovou
os três quadros do piloto e autorizou a geração das 23 poses restantes,
limitada à SPEC-108 e aos candidatos fora do runtime. Em 2026-09-30, o dono
autorizou também a transferência dos 24 arquivos nomeados na SPEC-108 e
ART-PROMPTS-037. A admissão de qualquer asset no runtime continua dependendo de
outra SPEC e aprovação.
A revisão interna regenerou `cultista_arqueiro_idle_02` como v02 por apresentar
postura de ataque na primeira versão e `slime_corrosivo_move_03` como v02 para
preservar o lado original da boca. Os ciclos aprovados ficam como candidatos
isolados até o gate de admissão separado.
O ciclo variante de `guardiao_copia` foi concluído sob SPEC-108: os 26 estados
estão indexados (23 saídas novas, além dos três quadros do piloto); QA técnico e
proveniência foram registrados em [[EVID-136-ciclo-guardiao-copia-2026-09-30]].
Em 2026-09-30, o dono aprovou visualmente os 23 quadros novos, completando a
aprovação do ciclo. A admissão ou integração no runtime continua dependendo de
SPEC própria e autorização separada.
