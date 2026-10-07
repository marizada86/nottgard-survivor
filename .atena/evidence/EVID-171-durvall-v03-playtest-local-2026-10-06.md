---
id: EVID-171
created: 2026-10-06
plan: PLAN-066
spec: SPEC-133
checkpoint: B-002 / S-005
status: READY_FOR_OWNER_PLAYTEST
official_admission: false
---

# Teste jogável local da v03 de Durvall

O dono pediu “preciso testar no jogo pra saber”. Classificação IN_PLAN: execução da comparação/aceite visual S-005 em uma cópia completa do jogo. O pedido autoriza preparar e abrir esse teste; não aprova a arte nem inicia admissão oficial B-004 ou produção B-003.

## Entrega

- [Abrir o teste](../generated/durvall-run-refinement/v01/Abrir-teste-Durvall.cmd).
- [Como testar](../generated/durvall-run-refinement/v01/COMO-TESTAR.md).
- [Captura da candidata em uma partida real](../generated/durvall-run-refinement/v01/playtest-v03-smoke.png).
- [Resultado da verificação](../generated/durvall-run-refinement/v01/playtest-v03-smoke.json).
- [Hashes fonte/cópia](../generated/durvall-run-refinement/v01/playtest-source-hashes.json).
- [Log de smoke](../generated/durvall-run-refinement/v01/playtest-smoke.log).

A cópia `playtest-v03/` contém core, ui, data e assets do projeto. Abre Dagruve com Durvall, seed 12345 e perfil descartável em APPDATA/LOCALAPPDATA locais. HQs iniciais são marcadas como vistas apenas nesse perfil para chegar imediatamente ao movimento. Progresso real não é carregado nem alterado.

O adaptador existe só na cópia de HeroView. Lê diretamente seis regiões 512×512 da grade bruta 3×2 da v03 e converte uniformemente a apresentação por 60/360, apoio 470. A animação E é substituída temporariamente; W usa seu espelhamento habitual. Outras direções, idle, ataque, habilidade e morte usam a arte atual, com retorno automático à escala original. Não houve edição ou normalização dos pixels da candidata.

F8 alterna a textura atual e a candidata no mesmo movimento. A/D ou setas testam a lateral; W/S e diagonais preservam as outras direções. O rótulo superior informa ATUAL/PILOTO. A velocidade e o combate não mudaram. Fechar a janela encerra o teste.

## Validação

Godot 4.7.2: importação isolada concluída sem erro; smoke de partida real com renderização Windows/OpenGL concluído (`DURVALL_PLAYTEST_SMOKE_OK`). Conferidos E atual/piloto, seis quadros a 10 fps, escala/offset correspondentes, W espelhado, retorno à escala atual em S e ataque. Velocidade observada: 190 px/s. Captura da partida inspecionada.

core/hero.gd, core/battle.gd e ui/run.gd são idênticos à fonte no snapshot. Conferência dos 23 hashes originais: zero mudanças. Apenas configuração, adaptador visual e inicializador da cópia têm mudanças. `.gdignore` na pasta gerada evita importar os snapshots como classes do projeto principal.

O primeiro lançamento assíncrono pela ferramenta de execução foi encerrado ao terminar seu processo pai. O lançador passou a oferecer `-Hold` para manter a sessão viva enquanto a janela está aberta. A execução interativa fica vinculada à sessão da ferramenta; o arquivo Abrir-teste-Durvall.cmd também permite reabrir manualmente.

Não foi feita avaliação estética em nome do dono. Alternância das pernas, apoio do quadro 4, câmera e continuidade da espada continuam pendentes conforme EVID-170. Nenhum bug fechado, commit, push ou publicação. B-002/S-005 aguarda o relato de playtest do dono; B-003/B-004 permanecem pendentes.

## Correção da abertura — revisão 2

O dono relatou que o personagem não movimentava no teste. Pedido classificado IN_PLAN no S-005. A reprodução mostrou `tree_paused: true`, tempo travado em 0,1333 s e deslocamento zero. A primeira verificação acima conferia o roteamento das animações, mas não o movimento real; portanto não demonstrava que a partida recebia comandos.

Causa: o autoload Playtest abre a guia de boas-vindas após um frame para um perfil novo. O inicializador escondia o autoload, mas a guia ainda pausava a árvore e capturava foco. O inicializador agora marca nome/boas-vindas somente no perfil descartável antes dessa checagem, fecha uma guia já aberta na inicialização e libera foco. Nenhuma alteração em core/playtest.gd, ui/run.gd ou regras de pausa do jogo oficial.

Verificação corrigida no Godot com renderização: entrada física D reconhecida; árvore sem pausa; relógio avançou de 0,5 para 0,9833 s; deslocamento real de 91,832 px; velocidade de 190 px/s mantida. [Sonda de movimento](../generated/durvall-run-refinement/v01/playtest-movement-probe.json). A verificação agora falha se houver pausa, entrada ausente, deslocamento abaixo de 80 px ou relógio parado. As verificações de animação também passaram (`DURVALL_PLAYTEST_SMOKE_OK`); captura atualizada e inspecionada. O título e o painel identificam revisão 2. É necessário fechar a janela antiga e reabrir pelo mesmo lançador.

Reconciliação final: 23 hashes oficiais preservados, contrato ADD presente, 15 links locais dos registros verificados, inicializador fonte/cópia idêntico e `git diff --check` sem erro. B-002/S-005 continua aguardando avaliação visual do dono.

Nota de publicação (2026-10-07): fontes, imagens e projetos de teste dos pilotos Durvall permanecem locais, aguardando decisão do dono após bloqueio da revisão automática. As referências históricas a `.atena/generated/durvall-*` registram trabalho local; não indicam assets admitidos ou publicados. Os registros e o mapa das referências pendentes estão na evidência de consolidação.
