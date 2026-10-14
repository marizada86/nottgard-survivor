---
id: PLAN-103
title: Demo completa e polida (jogo atual no acabamento final do escopo)
spec: SPEC-176 (M1, movimento dos heróis, DRAFT)
cards: [BUG-025, BUG-027, BUG-028, BUG-029, ART-028, ART-029, ART-030, ART-033, ART-041, ART-042, ART-043, ART-045, ART-046, ART-047, ART-048, MEC-003, MEC-031, MEC-067, BAL-016, BAL-018]
status: estrutura de marcos, Definição de Pronto e nível de aprovação aprovados pelo dono em 2026-10-14; conteúdo segue DRAFT; aguarda SPEC-176 do M1 e aprovação do lote B-002
approval_mode: per-batch
content_state: DRAFT
route: plano novo; PLAN-100 (decisões do dono pendentes) e PLAN-071 (arquivado) preservados
---

# PLAN-103 — Demo completa e polida

Origem: pedido do dono em 2026-10-14 ("planejamento para concluir a demo, deixar o jogo 100% com a cara que eu gostaria; polir o que existe e, em alguns casos, adicionar mecânicas"). Estado: **DRAFT**. Nada aqui é canônico nem executável até a aprovação.

## 1. Decisões do dono (2026-10-14)

| # | Decisão | Consequência |
|---|---|---|
| D1 | **Alvo:** o jogo atual completo, polido (9 fases, 12 heróis); "demo" = vitrine do jogo como o dono quer que seja | Nada é cortado; o corte é de **acabamento**, não de conteúdo |
| D2 | **Frentes de polimento:** arte e animação, *game feel* e dificuldade, UI/onboarding/clareza | Áudio **não** foi marcado: ver lacuna R1 |
| D3 | **Plataforma:** Windows, teclado/mouse e controle | Mobile (PLAN-067) e Web (PLAN-071) ficam **pós-demo**; não bloqueiam o aceite |
| D4 | **Ritmo:** por marcos, sem data | Cada marco tem critério de aceite e playtest; o dono decide quando fecha |
| D5 | **Sequência:** validação e mecânicas novas **em paralelo** | Ver mitigação em §5 (rastreio por mecânica) |
| D6 | **Lacunas de mecânica:** chefes marcantes, variedade/sinergia de builds, rejogabilidade e meta, identidade única por fase | Quatro frentes de design no M4 |
| D7 | **Movimento dos heróis:** marco próprio, com decisão do dono pelo olho | M1, antes de gerar mais tiras |
| D8 | **Arte nova:** priorizar por visibilidade; o resto vira "provisório aceito" por escrito | M5 classifica a fila em A/B/C |

## 2. Ponto de partida (verificado em 2026-10-14)

- v0.4.0 publicada (`602cef5`); **aviso aos testers pendente** (ação do dono).
- 21 planos entregues aguardando playtest humano; 4 bugs P1 abertos e 16 implementados sem confirmação em jogo; verificações automáticas verdes (suíte, smoke de nove fases, controller 94/0, mobile 146/0).
- Estética: lote 1 feito (filtro e fontes, PLAN-100, com decisões do dono ainda abertas); lotes 2 e 3 da "nova UI" e da estética (botão, moldura do HUD, brilho, partículas, impacto) **não iniciados**.
- Movimento: BUG-028 (patinar) adiado, BUG-029 (pixels soltos) com a variante C não adotada, BUG-027 (costas) sem tiras novas; ART-045 com 4 tiras pendentes (AO09, AO10, ER03, ER06).
- Arte DRAFT admitida só local (VFX de projéteis e habilidades, NPCs, Erik e Arlindo); ícones e props de conteúdo novo ainda provisórios (ART-041 a 048).
- Dificuldade: relatos de "fácil nas fases iniciais" e "enjoa depois do 3º ou 4º mapa" (BAL-001, BAL-016); bot sem medida de jogador humano.

## 3. Marcos

Cada marco termina em: suíte + smoke, evidência, atualização do backlog e checklist de playtest. Commit, push, exportação e aviso exigem aprovação à parte (`add.yaml`).

### M0 — Base e validação contínua (corre durante todo o plano)
- Aviso da 0.4.0 aos testers (dono) e roteiro de playtest já preparado em `.atena/generated/v040-lancamento/`.
- Decidir as pendências do PLAN-100 (filtro padrão, fonte) e commitar/publicar o que está só local (com aprovação).
- Cada versão de playtest sai com `stamp_build.ps1` e "O que testar"; triagem pelo INTAKE.
- **Aprovar a Definição de Pronto da demo (§4).**

### M1 — Movimento dos heróis (marco próprio)
- Diagnóstico: medir a passada por quadro; 2 ou 3 caminhos testados lado a lado (velocidade/fps, regerar tiras E/SE/NE com passada maior, pré-redução de escala, baixar `SPEED_PX`).
- **O dono escolhe pelo olho** antes de qualquer geração em lote.
- Aplicar nos 12 heróis; fechar BUG-027/028/029 e a revisão de escala completa (BUG-025); resolver as 4 tiras pendentes da ART-045.
- Aceite: checklist de movimento por herói em 8 direções, janela real.

### M2 — Game feel e apresentação
- Estética lotes 2 e 3: botão de ação (ART-047), moldura e brilho do HUD, partículas, feedback de impacto, números de dano (ART-007).
- Integrar e conferir em jogo os VFX DRAFT já admitidos (golpes, projéteis, habilidades dos heróis; ART-028/029/030).
- Conferir MEC-031 (D4 a D6) e as transições (MEC-003) numa run real.
- Aceite: clipes de uma run por fase sem poluição visual (pilar 2 do PLAN-001).

### M3 — UI, onboarding e clareza
- Lote 3 da nova UI (ofertas e HUD da run); direção visual DRAFT → decisão de promoção a CANON.
- Primeiros minutos: o que o jogador aprende sem texto (hoje cada sistema novo pede explicação); dicas contextuais e `?`.
- Aceite: um jogador novo explica sozinho level-up, bênção, extrair/descer e questlog.

### M4 — Mecânicas (quatro frentes, uma spec, um teste e um commit por mecânica)
Cada frente começa por uma **proposta** em `vault/drafts/` com 2 ou 3 opções e recomendação, e só vira spec com escolha do dono.
| Frente | Perguntas de partida | Já existe |
|---|---|---|
| 4a Chefes marcantes | Padrão e arena próprios por chefe? telegráfos, entrada, fase final | `boss_phases.json`, `boss_presentations.json` (70% e 35%) |
| 4b Builds e sinergias | Identidade de golpe por arma; sinergias legíveis; evoluções restantes | MEC-067, evoluções, sinergias, Coração da Dominância |
| 4c Rejogabilidade e meta | Desafios por herói, modo infinito/Síntese, uso das Marcas | Marcas (9), conquistas, Ecos, 2x |
| 4d Identidade por fase | Um acontecimento ou regra marcante por fase que o jogador lembre | regras ambientais, MEC-038, segredos |
- Limite recomendado: no máximo 2 mecânicas novas por frente na demo (risco de escopo; D5).

### M5 — Arte por visibilidade
Classificação da fila em três camadas, aprovada pelo dono:
| Camada | Critério | Meta |
|---|---|---|
| A | Visível nos primeiros 15 min, em todo herói e no HUD | **Zerar provisórios** |
| B | Visível em fases avançadas, chefes e eventos raros | Fechar o que couber; resto vira C |
| C | Raro ou periférico | **"Provisório aceito" por escrito** |
Candidatos à camada A: ícones das armas e únicos novos (ART-042), eventos (ART-046), botão (ART-047), pilar (ART-048), Arcanista (ART-041), altar animado (ART-044), tiras de Erik e Arlindo (ART-045), animações dos inimigos das fases 1 a 3 (PLAN-053).

### M6 — Balanceamento final (por último, com o conteúdo congelado)
- Bot por herói com 45 sementes; fechar BAL-001, BAL-016, BAL-018, BAL-027/028 com decisões por herói.
- Curas só reduzidas, nunca melhoradas (regra do dono).
- Duas fontes (bot + humano) antes de mexer em número.

### M7 — Candidata a demo
- Congelar conteúdo; bateria completa (suíte, smoke, controller, desempenho em máquina fraca).
- Playtest de aceite com os testers; changelog em PDF, guia e questionário; build com `stamp_build.ps1`.
- Aprovações separadas: commit, push, exportação, aviso.

## 4. Definição de Pronto da demo (proposta para aprovação)

1. **0 P0 e 0 P1 abertos** sem decisão registrada do dono.
2. **Nenhum asset provisório na camada A** (§M5); camadas B e C listadas no changelog.
3. **Movimento dos 12 heróis** aprovado pelo checklist do M1.
4. **Run completa** da primeira à última fase sem travamento; **60 fps** na máquina de referência e sem quedas graves na máquina fraca emulada.
5. **Controle e teclado/mouse** aceitos fisicamente (Xbox e PlayStation, MEC-052).
6. **Playtest de aceite:** pelo menos três testers terminam uma campanha e nenhum relato bloqueante fica sem tratamento.
7. **Dificuldade:** curva medida pelo bot por herói e confirmada por dois jogadores humanos.
8. **Legibilidade:** os cinco pilares do PLAN-001 conferidos em capturas por fase.

## 5. Riscos e mitigações

| Risco | Mitigação |
|---|---|
| **Paralelo (D5):** feedback mistura mecânica nova com o que ainda não foi validado | Cada mecânica entra em lote próprio, marcada em "O que testar" e em commit isolado (`git revert` por mecânica); o questionário separa "base" de "novo" |
| Escopo de mecânicas explode (quatro frentes) | Proposta antes de spec; teto de 2 por frente; M6 só depois do congelamento |
| Arte depende de gerar imagens (gargalo do dono) | Camadas A/B/C; admissão contínua; nada de regerar o que já está aceito |
| Movimento sem solução de código | Marco próprio com decisão do dono; plano B declarado como "conhecido" |
| Balanceamento medido só pelo bot | Regra de duas fontes; humano decide |

## 6. Lacunas

| Tipo | Item | Padrão recomendado |
|---|---|---|
| BLOCKING | nenhum | — |
| RESOLVIDA | **R1. Áudio** não foi priorizado, mas há som emprestado em itens, eventos e interações novas | **Decidido (2026-10-14):** piso mínimo: nenhum SFX emprestado na camada A e um passe de mixagem em M2; música por fase fica C |
| RESOLVIDA | **R2. Nível de aprovação** do plano | **Decidido:** por lote (marcos = lotes `B-001` a `B-008`, com M0 = B-001 contínuo) |
| RESOLVABLE | **R3. Direção visual** ainda DRAFT (UI) | Decisão de promoção ao fim do M3, com capturas |
| RESOLVIDA | **R4. Ordem dos marcos** | **Decidido:** M1 primeiro; M2/M3 podem andar em paralelo com M4; Definição de Pronto (§4) aprovada como está |
| DEFERRED | Mobile, Web, Steam/loja, localização, modo cooperativo | Pós-demo |

## 7. Próximo passo

1. Dono aprova (ou ajusta) a estrutura de marcos, a Definição de Pronto e o nível de aprovação.
2. Atena escreve a SPEC-176 e a trilha `.atena/state/plan-103-demo-completa-e-polida.yaml`, registra o modo e o primeiro checkpoint em `plan.yaml`.
3. Execução apenas do primeiro marco aprovado.
