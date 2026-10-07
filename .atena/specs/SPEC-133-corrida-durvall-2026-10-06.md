---
id: SPEC-133
title: Corrida de Durvall com passada mais ampla
created: 2026-10-06
status: B002_AWAITING_VISUAL_REVIEW
origin: guided-add
implementation_preceded_spec: false
request_classification: NEW_PLAN
approval_mode: per-batch
approved: 2026-10-06
latest_approved_checkpoint: B-002
approval_basis: "Dono respondeu aprovado à proposta de iniciar B-001 por lote."
plan: "../vault/drafts/PLAN-066-corrida-durvall-2026-10-06.md"
---

# Corrida de Durvall com passada mais ampla

Refinar a leitura de corrida de Durvall por meio das poses de locomoção, mantendo sua velocidade e identidade. A entrega começa com um piloto lateral; somente uma solução visual aprovada se estende às demais direções.

## Evidência e diagnóstico

O runtime usa seis quadros a 10 fps por direção, com ciclo de 0,6 segundo. A altura-alvo de Durvall é 60 pixels, com escala calculada sobre idle de 231 pixels-fonte. A velocidade base é 190 pixels de tela por segundo, sujeita aos modificadores existentes.

A inspeção das tiras move_e e move_se mostra tronco predominantemente ereto e pouca diferenciação de impulso e recuperação. A abertura das pernas, isoladamente, não mede a distância percorrida por um ciclo: a [EVID-158](../evidence/EVID-158-velocidade-de-movimento-x-passo-da-arte-2026-10-05.md) é uma estimativa histórica, não uma medida exata de patinação. Ela registra também a rejeição da cadência acelerada; o BUG-028 registra a reversão de 15 fps e speed_scale.

O código atual carrega cinco fontes direcionais e espelha três direções. Há arquivos W/SW/NW no diretório, mas sua existência não prova uso no runtime. O [contrato canônico](../vault/canon/PLAN-001-nottgard-survivors.md#26-contrato-de-animação-integral-dos-heróis-2026-09-30) prevê oito fontes independentes no programa de animação. Esta entrega deve respeitar esse alvo para Durvall sem migrar os outros heróis.

## Escopo

- Medir e registrar a locomoção atual de Durvall em E, SE, NE, S e N, incluindo suas direções opostas efetivamente exibidas.
- Preparar um piloto E com maior extensão de quadril/pernas, recuperação clara do joelho e impulso legível, preservando espada, mão, armadura, rosto e silhueta reconhecível.
- Comparar a arte atual e a candidata sobre um chão com referências fixas, primeiro com seis quadros e 10 fps, na mesma velocidade e escala.
- Após aprovação visual do piloto, produzir e revisar as oito direções independentes.
- Integrar apenas candidatos aprovados, com configuração específica de Durvall quando necessária para a seleção de direções.
- Validar contato dos pés, loop, transições de idle/ação, tamanho, ancoragem e regressões dos outros heróis.

## Direção artística proposta

Revisão autorizada pelo dono em 2026-10-06 ("atena pode seguir as recomendações"), após EVID-172: reforçar alternância anatômica e moderar o alcance lateral em aproximadamente 20% frente à v03, como alvo inicial de comparação. Até três tentativas neste ciclo de revisão, preservando as anteriores. O piloto revisado e o teste isolado precedem o aceite das outras direções. Sem mudança de velocidade, contagem ou fps.

Corrida firme e controlada: perna de apoio empurra para trás, a outra recupera com o joelho flexionado, o pé alcança à frente e o contato alterna de forma clara. Inclinação moderada do corpo, braço livre acompanhando o passo e espada estável com inércia discreta. Cabelo e tecido acompanham o movimento como efeitos secundários.

Não normalizar cada quadro pela caixa alfa. Preservar uma referência corporal e a origem do sprite; flexão e extensão intencionais não devem ser eliminadas para igualar alturas. A fase de apoio mantém contato com o chão; eventual fase aérea é breve e precisa de aprovação visual.

## Não objetivos

Alterar velocidade, colisão, balanceamento, dano, regras, estados de gameplay ou outros personagens. Não regenerar idle, ataques, habilidade ou morte; usá-los como referências para transição. Não modificar lore, dependências ou intenções canônicas. Não substituir assets oficiais sem aceite visual; não fazer commit, push ou publicação.

## Aceite

1. O dono reconhece a candidata como corrida com passada mais ampla no tamanho real de jogo, com melhora em relação à atual.
2. A comparação usa mesma escala, deslocamento, câmera e duração de captura. Distingue referência técnica de preferência visual.
3. O ciclo fecha sem salto ou quadro repetido indevido; alternância dos apoios e recuperação do joelho são legíveis. O pé de apoio não escorrega de forma perceptível em movimento uniforme.
4. Durvall mantém identidade, espada e mão; não cresce, afina ou muda de proporção ao alternar movimento, idle e ação.
5. Células 256×384, transparência real e margens suficientes; nenhuma parte da espada ou do corpo cortada. Triagem usa SPEC-106, com apoio na linha-base e movimentos intencionais de corrida avaliados visualmente.
6. Oito direções usam suas fontes aprovadas, inclusive costas em N/NE/NW; nenhum espelhamento é adotado implicitamente para Durvall.
7. Testes relevantes e auditorias passam; demais heróis preservam roteamento, cadência e escala. Hashes de gameplay comprovam que velocidade e combate não mudaram.
8. Todos os candidatos e fontes anteriores são preservados. Evidência registra aprovação de cada sequência, hashes, dimensões, cadência, limitações e build ID do playtest local.

## Gaps e limites

- BLOCKING técnicos para aprovar o plano local: nenhum. Modo por lote, B-001 e B-002 aprovados em 2026-10-06; aceite visual S-005 permanece pendente.
- RESOLVABLE: amplitude/cadência ideais. O piloto e sua comparação resolvem a escolha, sem atribuir um número exato de passada a uma estimativa de silhueta.
- RESOLVABLE: seis ou oito quadros. Default: seis para o primeiro piloto. Oito entram como alternativa explícita após a avaliação, com duração de ciclo declarada; oito quadros a 10 fps prolongariam o ciclo para 0,8 segundo.
- Gate independente: os três PNGs de Durvall foram autorizados no ImageGen junto ao B-002 em 2026-10-06. Nenhum vault, perfil, documento pessoal ou outro herói será enviado.
- Gate independente: aprovação visual do piloto e de cada sequência antes da admissão, mesmo em modo por plano.
- DEFERRED: sincronização automática da cadência com bônus/lentidão. A tentativa anterior foi revertida e não será reaplicada por inferência.

## Plano de voo, validação e evidência

Executar B-001 a B-004 do [PLAN-066](../vault/drafts/PLAN-066-corrida-durvall-2026-10-06.md). Medir posição de apoio, movimento relativo ao chão e fase do ciclo, não somente largura da silhueta. Comparar idle → corrida → parada e corrida → ação em velocidade normal; bônus/lentidão servem para registrar limites, sem implementar sincronização automática.

Usar Godot em D:/Godot/godot.exe, dados de teste isolados e candidatos em .atena/generated/durvall-run-refinement/v01/. Antes de substituir qualquer arquivo oficial, preservar original e registrar o gate visual. Testes/auditorias planejados: tests/test_animation_assets.gd, tests/test_iso_hero.gd, suíte completa, audit_hero_motion, estabilidade/base/bordas e smoke local.

Registrar resultados por critério e reconciliar apenas o escopo Durvall do BUG-028/BUG-025 e o cursor próprio. Não fechar o bug geral dos dez heróis. O plano central foi ativado após aprovação B-001; esse lote terminou com a [EVID-169](../evidence/EVID-169-durvall-corrida-b001-2026-10-06.md), sem alterar arte oficial ou gameplay.
