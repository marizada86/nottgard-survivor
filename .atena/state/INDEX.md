# Índice de planos: o que está vivo

Atualizado em 2026-10-09 (Atena). Cada linha liga o plano à spec, ao que ele é e ao que **ainda falta**. O estado operacional (plano ativo, recibos de commit, desvios) fica em [`plan.yaml`](plan.yaml); o índice das specs, em [`../specs/INDEX.md`](../specs/INDEX.md) (gerado por `node tools/atena_index.js`). Os arquivos de plano não foram movidos nem renomeados: links antigos continuam valendo.

**Resumo:** 1 plano ativo · 19 entregues, aguardando playtest ou arte · 9 esperando arte, aparelho ou o dono · 12 fechados sem pendência. Total de arquivos de plano em `state/`: 41.

## Ativo

| Plano | Spec | O que é | Falta |
|---|---|---|---|
| PLAN-071 | SPEC-138 | Playtest Web e ranking por evidências do Discord | Aceite nos clientes finais (ranking e F7) e gates remotos; retomado em B-006/S-011 |

## Entregues, aguardando playtest

O código está na `main` (e, exceto o PLAN-093, no `origin`); o que falta é **o dono jogar** (e, onde indicado, arte).

| Plano | Spec | O que é | Falta |
|---|---|---|---|
| PLAN-059 | SPEC-125 | Balanceamento de desafio sobre a 0.3.1 | Playtest decide Docas, Molor e fases finais |
| PLAN-064 | SPEC-131 | HUD da run no padrão da ficha C | Playtest |
| PLAN-067 *(baú mímico)* | SPEC-134 | Baú vira Mímico uma vez só | Playtest |
| PLAN-068 *(baú e portal)* | SPEC-135 | Baú e portal fora de bloqueio de cenário | Playtest |
| PLAN-069 | SPEC-136 | Graz'zt limpa o mapa | Playtest |
| PLAN-074, PLAN-076 | SPEC-141, SPEC-143 | Marcas do Abismo (entregas 1 e 2) | Playtest |
| PLAN-075 | SPEC-142 | Economia de ouro | Playtest |
| PLAN-080 | SPEC-147 | Correções dos playtests v0.3.2 e v0.3.3 | Playtest |
| PLAN-081 | SPEC-148 | Lançamento da 0.4.0 | Aviso aos testers (ação do dono); `.exe` local opcional |
| PLAN-083 | SPEC-157 | Segredos nas outras fases (Ecos, câmaras, relíquias) | Playtest; arte ART-043 |
| PLAN-084 | SPEC-158 | Névoa de borda e Maré em todas as fases | Playtest decide se a faixa fere cedo demais (BAL-028) |
| PLAN-085 | SPEC-159 | Seta de evento na borda da tela | Playtest |
| PLAN-086 | SPEC-160 | Arlindo Orlando e Erik Blackthorn jogáveis | Playtest; arte própria ART-045 (fila FILA-027) |
| PLAN-089 | SPEC-163 | Barra de progresso da fase | Playtest |
| PLAN-090 | SPEC-072 | Clicar na HUD não move o herói (BUG-039) | Playtest |
| PLAN-091 | SPEC-164 | Seis eventos aleatórios novos | Playtest (equilíbrio, BAL-029); arte ART-046 (FILA-028) |
| PLAN-092 | SPEC-165 | UiKit e menu de pausa em abas | Playtest e **aprovação da direção visual** (rascunho); lote 2 da UI |
| PLAN-093 | SPEC-166 | Nova UI, lote 2: Quartel no UiKit, Códex no Catalog, Opções no OptionsPanel | Playtest (publicação: push pendente) |

## Esperando arte, aparelho ou o dono

| Plano | Spec | O que é | Espera por |
|---|---|---|---|
| PLAN-053 | SPEC-121 | Fila de imagens (animações dos inimigos e dos chefes) | Geração de imagens; suspenso para publicação |
| PLAN-057 | SPEC-123 | Revisão da movimentação dos heróis (BUG-027, BUG-028) | Gerador de imagem |
| PLAN-062 | SPEC-129 | Dinamismo: bênçãos divinas e eventos | B-006 (arte e áudio); playtest |
| PLAN-065 | SPEC-132 | Lettering e cursor temáticos | B-003 depende de arte |
| PLAN-066 *(corrida de Durvall)* | SPEC-133 | Refinamento da corrida de Durvall | Playtest do dono; suspenso |
| PLAN-067 *(mobile)* | SPEC-134 | Controles e menus por toque | Aceite em celular real |
| PLAN-068 *(Xbox/PlayStation)* | SPEC-135 | Experiência com controles | Aceite com controle físico |
| PLAN-073 | SPEC-140 | Consolidação do push | Ativos do piloto |
| PLAN-082 | SPEC-154 | Pixels soltos dos heróis (BUG-029) | Escolha visual do dono; pausado, variante C não adotada |

## Fechados sem pendência

| Plano | Spec | O que foi |
|---|---|---|
| PLAN-056 | SPEC-122 | Balanceamento do ritmo inicial (aceito pelo dono em 2026-10-05) |
| PLAN-060 | SPEC-126 | Bênção opcional no altar |
| PLAN-061 | SPEC-127 | Habilidade ativa na HUD e na ficha |
| PLAN-063 | SPEC-130 | Ficha C em abas, grade e detalhe (aceita pelo dono) |
| PLAN-066 *(Passo pelas Sombras)* | SPEC-133 | Dano da explosão do Passo pelas Sombras (Sylas) |
| PLAN-070 | SPEC-137 | Geração da FILA-025 (ficha C) |
| PLAN-072 | SPEC-139 | Integração da ficha C |
| PLAN-077 | SPEC-144 | Diagnóstico instrumentado do patinar (BUG-028) |
| PLAN-078 | SPEC-145 | F7 reúne evidências num ZIP |
| PLAN-079 | SPEC-146 | Pacote do Caio para Durvall (só local, por decisão do dono) |
| PLAN-087 | SPEC-161 | Fechar e organizar a 0.4.0 |
| PLAN-088 | SPEC-162 | Dívida de verificação manual e linha de base do bot |

## Atenção: registros com status que ainda diz "local"

Os arquivos de PLAN-072, 075, 077, 078, 079 e 080 ainda dizem `COMPLETED_LOCAL` no cabeçalho, mas o trabalho está no `HEAD` e no `origin` (árvore limpa e push feito). Não alterei esses seis porque não confirmei plano a plano o que "local" significava em cada um; o PLAN-079 é local de propósito.

## Numeração repetida (convivem, não foram renomeados)

| Número | Planos | Specs |
|---|---|---|
| 066 | corrida de Durvall · Passo pelas Sombras | SPEC-133 (duas) |
| 067 | baú mímico · controles mobile | SPEC-134 (duas) |
| 068 | baú e portal · Xbox/PlayStation | SPEC-135 (duas) |

As specs também repetem outros números (SPEC-047 a 050, 054, 100, 116 e mais; lista completa no [índice de specs](../specs/INDEX.md#números-repetidos)). Os caminhos completos distinguem cada uma; o [mapa de colisões](../evidence/consolidacao-id-collisions-2026-10-07.json) registra os IDs antigos. Renumerar mexeria em dezenas de links e não ajuda a achar o que está vivo, então ficou como está.

## Para atualizar

1. Ao fechar ou publicar um plano, mover a linha de grupo e ajustar a coluna "Falta".
2. `node tools/atena_index.js` regenera o índice de specs depois de mudar o cabeçalho de alguma.
3. `powershell -ExecutionPolicy Bypass -File tools/backlog_check.ps1` continua sendo o estado dos cartões (P0/P1, próximos livres).
