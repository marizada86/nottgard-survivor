---
id: EVID-175
created: 2026-10-06
plan: PLAN-066
spec: SPEC-133
checkpoint: B-002 / S-005 / R-002
request_classification: IN_PLAN
method_change_approval: 'Dono respondeu Imagem e piloto articulado ao esclarecimento de alcance'
status: IMPLEMENTED_AWAITING_OWNER_PLAYTEST
component_attempts: 2
official_assets_changed: false
owner_visual_acceptance: PENDING
---

# Piloto lateral com pernas articuladas

O esclarecimento explícito do dono aprovou a imagem corrigida e a mudança de método [R-002](../vault/drafts/PLAN-066-piloto-articulado-2026-10-06.md). A execução ficou limitada ao piloto lateral E/W em cópia isolada. A entrega deste registro é o teste jogável, não o aceite visual nem a conclusão do PLAN-066.

## Arte e montagem

ImageGen integrado produziu duas tentativas de componentes transparentes. A [primeira](../generated/durvall-articulated/v01/rig-project/components-v01.png), com [prompt preservado](../generated/durvall-articulated/v01/components-v01-prompt.txt), mantinha tecido sobre os joelhos. A [segunda](../generated/durvall-articulated/v01/rig-project/components-v02.png), com [prompt de edição](../generated/durvall-articulated/v01/components-v02-prompt.txt), encurtou/recuou o tecido para expor as articulações. Braços, mãos e espada pertencem ao mesmo componente do tronco: a pegada permanece a mesma nos seis quadros.

A geração entregou peças em tamanhos diferentes; não satisfez uma escala uniforme do atlas. O [rig no Godot](../generated/durvall-articulated/v01/rig-project/rig.gd) usa regiões e pivôs estáticos, com calibração fixa de cada peça pela distância entre suas articulações. O comprimento dos segmentos permanece constante, sem normalização variável entre quadros. A perna próxima e a distante têm peças distintas, diferença de fase de três quadros e joelhos calculados por duas articulações. As peças não foram retocadas por script; o próprio Godot compõe e renderiza as poses.

As fases de apoio alternam A/B entre as duas metades do ciclo; contatos dianteiros ocorrem nos quadros 1/4. O alcance dos tornozelos é controlado em ±19 px no tamanho de jogo, com recuo de 19 px por quadro de apoio a 10 fps para a velocidade base de 190 px/s. A recuperação eleva os pés. Isso não demonstra ausência perceptiva de deslizamento: o runtime exibe quadros discretos, e sincronização com bônus/lentidão permanece fora do escopo. Não foi validada uma redução percentual exata da amplitude relativamente à v03.

## Resultado e teste

- [Prévia dos seis quadros](../generated/durvall-articulated/v01/pose-board-v02.png).
- [Tira exportada pelo Godot](../generated/durvall-articulated/v01/move_e-rig-v02.png): 1536×384, seis quadros 256×384, PNG transparente.
- [Telemetria das poses](../generated/durvall-articulated/v01/rig-pose-telemetry-v02.json) e [log de captura](../generated/durvall-articulated/v01/capture.log).
- [Abrir novo teste](../generated/durvall-articulated/v01/Abrir-teste-Durvall-articulado.cmd) e [instruções](../generated/durvall-articulated/v01/COMO-TESTAR.md).

A partida é identificada por `durvall-rig-r002-local` / `Teste articulado R002 revisao 3`. Somente E/W usam o piloto, com W espelhado; F8 compara as animações atual e candidata. Repouso, ataque e demais direções permanecem atuais na cópia. Seis quadros a 10 fps, escala 60/231 e offset −184 mantêm o contrato vigente; a altura visível exportada de 230 px corresponde a aproximadamente 59,74 px em jogo.

O [smoke da partida](../generated/durvall-articulated/v01/playtest-smoke.log) terminou com `DURVALL_PLAYTEST_SMOKE_OK`, sem erros. A [sonda de movimento](../generated/durvall-articulated/v01/playtest-movement-probe.json) reconheceu D no piloto e A no modo atual, árvore sem pausa e deslocamento de 91,832 px por modo em aproximadamente 0,4833 s. O evento F8 alternou para atual e retornou ao piloto. O harness verificou também seis quadros/10 fps, espelhamento W e retorno às ações/direções atuais. [Captura em tamanho de jogo](../generated/durvall-articulated/v01/playtest-rig-smoke.png) e [parâmetros do smoke](../generated/durvall-articulated/v01/playtest-rig-smoke.json) preservados. Perfil e cache foram redirecionados à pasta descartável local para não usar o progresso oficial.

## Verificação e limites

O [recibo de auditoria](../generated/durvall-articulated/v01/pilot-audit.json) registra seis quadros com pixels distintos, fases A/B deslocadas por meio ciclo, ausência de recorte nas bordas e bounds alfa ≥26 `(3,146,249,376)` em todos os quadros. A caixa constante resulta do tronco fixo, não de pernas repetidas. Fundo transparente e pé inferior em y=375 foram conferidos. [Auditoria reproduzível](../generated/durvall-articulated/v01/audit-pilot.py) somente lê os pixels e grava o recibo.

O verificador local confirma os 23 hashes oficiais da linha de base, contrato ADD, links e igualdade entre os harnesses fonte/cópia. Os arquivos `core/hero.gd`, `core/battle.gd` e `ui/run.gd` são idênticos aos oficiais; adaptações ficam no projeto/visual/harness da cópia. [Hashes da cópia](../generated/durvall-articulated/v01/playtest-source-hashes.json) e [verificador](../generated/durvall-run-refinement/v01/check-local-test.cjs). Sem dependências novas, alterações de velocidade, commit, push ou admissão oficial. V01–v07, imagem corrigida e teste v03 permanecem disponíveis.

Tronco, cabelo e braços estão fixos neste piloto, podendo produzir rigidez perceptiva. A montagem pode revelar emendas nos joelhos/tornozelos e diferenças de proporção ou iluminação; avaliar em movimento no tamanho do jogo. A inspeção das poses confirmou continuidade mão/cabo/lâmina, mas o dono ainda precisa avaliar qualidade, passada, apoio e transição do loop. B-003/B-004 continuam sem autorização. O próximo checkpoint é a avaliação visual do dono; nenhuma direção adicional foi iniciada.

Backlog conferido: P0=0; quatro P1 abertos (BUG-025, BUG-027, BUG-028, BUG-029), sete implementados aguardando playtest e oito verificações manuais pendentes. Nenhum bug foi encerrado com base neste piloto.

Nota de publicação (2026-10-07): fontes, imagens e projetos de teste dos pilotos Durvall permanecem locais, aguardando decisão do dono após bloqueio da revisão automática. As referências históricas a `.atena/generated/durvall-*` registram trabalho local; não indicam assets admitidos ou publicados. Os registros e o mapa das referências pendentes estão na evidência de consolidação.
