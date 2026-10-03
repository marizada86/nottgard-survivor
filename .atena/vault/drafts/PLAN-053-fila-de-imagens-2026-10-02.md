---
id: PLAN-053
title: Execução da fila de imagens por prioridade
created: 2026-10-02
status: em execução
---

# Fila de imagens

Autorização: pedido do dono em 2026-10-02 para executar os prompts, criar as imagens e adicionar ao jogo. A integração local está autorizada; commits e publicação não foram pedidos.

## Ordem

1. ART-024: miniatura de Docas (ART-PROMPTS-039).
2. T01: título (CHATGPT-FILA-009).
3. C03–C11: props do piloto; depois C01–C02: fundos (CHATGPT-FILA-010).
4. S01–S02: isca de Sylas; reconciliar animações existentes antes de produzir novamente.
5. Mobs: Molor, Shedaklah, Durao, Feng Tu, Shendilavri, Goranthis, Pilares. Identidade e validação de cada bioma antes do seguinte.
6. Reconciliar lote 1 com assets já admitidos; gerar só faltantes.
7. S03–S05: ampulheta, doação e aposta.
8. HQs pendentes, respeitando decisões de mecânica; Trilha C permanece condicionada à aprovação de MEC-015.
9. UI/VFX da fila 012; ART-004 depende da decisão da mecânica.
10. VFX novos: piloto 020 antes das filas 021–023. A prioridade relativa deste bloco não estava definida na tabela de 2026-10-01.

## Método

Usar imagegen integrado, uma chamada por asset. Guardar matriz versionada em `.atena/generated/art-candidates/`, conferir aparência e contrato técnico, normalizar dimensões e preservar alfa. Fundos opacos; props com transparência real substituem o chroma-key originalmente previsto. Integrar em caminhos consumidos pelo jogo e registrar o resultado. Não criar mecânicas condicionadas a playtest apenas para consumir arte.

## Progresso

- Miniatura: gerada e integrada em `assets/stages/docas_thumb.png`, RGB 480×320.
- Título: gerado e integrado em `assets/ui/title/title_background.png`, RGB 1920×1080.
- FILA-010 C01–C11: integrados os nove props e os dois fundos; estrada validada em runtime após correção isométrica. Cais usa dimensões e espaçamento próprios nos dados. Carroça e carga usam destrutíveis existentes com dois novos IDs e eventos de áudio reaproveitados.
- FILA-011 S01–S05: isca (segunda versão), explosão 2×2, ampulheta, altar de doação e mesa de aposta integrados e capturados no jogo.
- FILA-012 U07–U09: subida de nível, flare de evolução e moldura integrados; efeitos respeitam Reduzir efeitos de impacto. Margem do painel corrigida após captura.
- Molor I01–I03: candidatas guardadas, nenhuma admitida. I01 foi tentada três vezes, todas com halo externo; interromper repetição automática conforme `max_retries: 3` em `.atena/add.yaml`. I02/I03 também têm halo. Os ciclos de animação dependem de identidades tecnicamente válidas e da revisão visual prevista na FILA-014.
- FILA-020 A03: piloto de estilo gerado; ainda sem os demais quadros e sem integração. A FILA-020 pede devolução ao dono neste ponto para aprovar o estilo.
- Testes após os dois primeiros assets: 0 falhas. Smoke das nove fases: ok. Godot reportou avisos de recursos em uso ao encerrar; não é validação visual interativa.
- U01–U06: pendentes, ligados a MEC-002/003/004 ainda sem implementação no backlog; não implementar novos sistemas apenas para consumir imagens.
- HQs reconciliadas: HQN-01–14 já registradas em `data/hqs.json`, 56 caminhos conferidos sem ausências; integração e prévia documentadas em EVID-128/EVID-133. Não regenerar a remessa histórica.
- Lote 1 reconciliado: P01–P08 oficiais existem; EVID-110 documenta admissão. Lote 2 já admitido por EVID-127. Não há geração nova necessária nessas remessas históricas.
- Build Windows exportada em `build/image-priority/NottgardSurvivors.exe`, identificação `38cbc95+` (árvore local com alterações), inicialização headless conferida. Não publicada.
- A03 v02 e B03 aprovados pelo dono. Piloto completo de 12 quadros gerado e integrado em dois atlas; oito direções e sete cores conferidas. Build local atualizada em `build/image-priority-vfx/NottgardSurvivors.exe`, identificação `0217b2f+`.
- FILA-021 C03 v02 apresentado para o próximo gate. Molor I02/I03 v02 não resolveram o halo; limpeza técnica por Godot ou nova geração aguardam escolha do dono.
- Filas 013–019 e 021–023: pendentes das validações dos pilotos. Não declarar a fila inteira concluída.

Prompts executados: ART-PROMPTS-039, T01 literal da FILA-009, C03 da FILA-010 com transparência real e correção de alinhamento; C04 da FILA-010 com transparência real.

Complemento: todos os C01–C11 da FILA-010, todos os S01–S05 da FILA-011, U07–U09 da FILA-012, I01–I03 de ART-PROMPTS-045 e A03 da FILA-020. Usado apenas imagegen integrado. Fundo magenta/ciano substituído por transparência real; nenhuma matriz bruta apagada. Destinos e validação em EVID-145.

Atualização da prioridade: FILA-024 / ART-PROMPTS-055 (BUG-025) passa à frente dos próximos lotes, conforme pedido do dono registrado no backlog em 2026-10-02. Concluir primeiro a geração do Cultista já disparada, preservar candidatos e iniciar W01 Kayron move_se. Não iniciar os ciclos de Blogbog ou os próximos biomas antes de atender esta prioridade. C03 v02, D03 v01 e as três identidades limpas de Molor já foram aprovados; Estocada, Chicote e Bolha de Slime estão integrados localmente. Suite: zero falhas; smoke: nove fases ok; escala, âncora, término de ataque e limpeza após morte da Bolha conferidos.
- Cultista concluído: 20 quadros e quatro strips integrados, ataque02 corrigido em v02, pranchas inspecionadas e runtime conferido. Zero falhas na suite e smoke das nove fases ok. Total local: 33 PNGs integrados. Build atualizada em image-priority-molor, identificação4510c64+.
- FILA-024 W01: v01–v03 preservadas; halo persiste, limite de três tentativas alcançado; decisão do dono sobre extensão da limpeza de alfa por código pendente. W02 Korrak move_e iniciado e em correção de corte do machado. Nenhuma tira nova de herói integrada ainda.
- W02 Korrak move_e concluído e integrado: seis quadros267px/base350, massa99–103%doidle, sem cortes. Captura no jogo conferida; ativado na direita, demais sete direções provisórias. Suite finalzero falhas. Build4510c64+ (image-priority-molor) atualizada, SHA256 A55E3C7EFA5F2590C2376DBC1D9814300759CD4CD8E58785549DA16CA0B5E352, inicialização exit0. Próxima pendência: escolha sobre limpeza do alfa de W01, que continua candidato após três tentativas. Não declarar toda a fila pronta.

W04 v03 corrigiu a transparência no gerador; massa 0,791–0,856 × idle, altura267/base350 em seis quadros, aceite sem falhas, integrado. W06/W07 Bromnor v01: altura241/base364; massa0,975–1,049 e0,944–1,019; W08 Sylas v01: altura304/base376; massa0,845–0,930. Todas sem cortes, capturas no jogo inspecionadas, originais preservados. Manifesto agora40 PNGs (33 novos +7 substituições). Testes de animação e VFX:0 falhas. Suite completa do workspace compartilhado:11 falhas em test_level_design.gd sobre props de durao; sem falhas de animação. HEAD alterado por outro chat para18d504f; mudanças compartilhadas preservadas. W15 reauditorado: três tiras ainda têm1–2 falhas de base de2–3px, sem cortes; não dar como encerrado ainda. W09–W11 iniciados pela prioridade P2. W01 continua aguardando escolha sobre limpeza de alfa.

## Fechamento do lote de heróis — 2026-10-02

W02–W15 integrados e A01/A03–A10 integrados: 13 tiras de ação ao todo (5 ataques de quatro quadros, 8 ativas de seis quadros). A02 Korrak active permanece na arte anterior: v01/v02 inválidas e v03 com apenas três grupos de alfa por sobreposição entre seis figuras; nenhuma delas admitida. W01 Kayron move_se permanece candidato por halo e aguarda a decisão de limpeza de alfa já apresentada ao dono. Não aplicar a autorização de limpeza de Molor aos heróis.

Manifesto acumulado: 69 PNGs = 33 novos fora dos heróis + 36 tiras de heróis substituídas/corrigidas, das quais duas são reempacotamentos técnicos de Bromnor N/NE. Neste prosseguimento foram admitidas 35 tiras, pois Korrak E já estava admitido anteriormente. Geração pelo imagegen integrado, originais e versões rejeitadas preservados. Prompts exatos recentes: heroes-walk-prompts-2026-10-02.json, heroes-walk-prompts-correcoes-2026-10-02.json e heroes-action-prompts-2026-10-02.json.

Ações selecionadas: Zynara attack v02; Sylas active v02; Bromnor attack v02/active v01; Durvall attack/active v02; Brook attack v03/active v02; Leoric attack v02/active v01; Kayron, Maelor e Nyrelia active v01. Quando a arma sobe acima da cabeça, o empacotamento usa pontos cabeça/sola anotados para preservar a altura do corpo: Bromnor 219 px (o idle completo tem 241 px por causa do martelo), Durvall 231 px e Brook 259 px. Não confundir extensão da arma com altura do personagem. RGB/alfa originais preservados; nenhuma limpeza de alfa por código nos heróis.

Validação: aceite de cada candidata sem falhas; focused Animation queue: 0; suite completa: 0 falhas (as 11 falhas anteriores de Durão desapareceram após a atualização do workspace compartilhado); smoke das nove fases: ok; relatório read-only de equalização vazio; runtime Korrak E/SE/S/NE confirmado, quatro direções provisórias preservadas; capturas de todas as tiras novas efetuadas, amostras de caminhadas e ataques inspecionadas no jogo; git diff --check sem erros. Aviso ambiental de certificados do Godot não interrompeu os processos.

Build local: build/image-priority-heroes/NottgardSurvivors.exe, identificador 942fbe8+, 403909160 bytes, SHA256 F953F829C9E2E4CE56B7941FEFB6A63609CDE97582492E1BAFEA12D922B65C89. Exportação e inicialização do executável terminaram com código 0. Inclui os 69 arquivos do manifesto. Alterações de outros chats preservadas; sem commit/push desta execução. FILA-024 permanece parcial pelas duas pendências citadas; restante da fila global ainda aberto.

## Retomada autorizada pelo dono — 2026-10-02
Pedido “atena continuar”: nova tentativa com referências limpas existentes. W01 Kayron move_se v04 e A02 Korrak active v04 passaram: seis silhuetas separadas, alfa do gerador preservado, sem limpeza por código. Kayron316/base376/massa0,923–0,989; Korrak267/base350/massa0,890–0,958; sem cortes. Integrados, backups preservados, capturas runtime inspecionadas. FILA-024 concluída localmente sob autorização geral; não atribuir aprovação visual individual ao dono. Manifesto71PNGs. Exceção conhecida de massa Kayron retirada do teste. Próximo item da prioridade original: completar os25quadros restantes de Blogbog (identidade já aprovada), uma chamada por quadro conforme ART-PROMPTS-045.
Retomada: FILA-024 concluída com KayronSE/Korrakactive v04. FILA-014 Molor concluída66quadros/13ciclos, incluindo Blogbog;76PNGs no manifesto. Suite0falhas, smoke9fases, build image-priority-molor-complete pronta. Próximo gate FILA-013: oito identidades de Shedaklah antes dos158quadros restantes.
Shedaklah: dono aprovou I01–I08 v03. Servo concluído20quadros/4tiras e integrado; manifesto80PNGs, testes focados0falhas e runtime conferido. Cogumelo Fúngico em geração, mantendo ordem por alvo. Build anterior Molor ainda76PNGs.
Shedaklah: Servo e Cogumelo Fúngico concluídos40quadros/8tiras e integrados, manifesto84PNGs. Cogumelo body188/base356, morte corrigida em death03–05 pelo gerador. Testes focados0falhas e captura no cenário conferida; Esporo Voador em geração.
2026-10-03: Shedaklah60quadros/12tiras integrados (Servo/Cogumelo/Esporo), manifesto88PNGs, testes focados0falhas e capturas runtime conferidas. Limo de Juiblex parcialmente gerado; bloqueado pelo limite do gerador; três últimos mobs e Zuggtmoy ainda aguardam execução, identidades já aprovadas.

2026-10-03: Servo, Cogumelo e Esporo integrados (60 quadros / 12 tiras), manifesto 88 PNGs. Suite zero falhas; smoke nove fases ok. Limo: sete novos quadros preservados (idle_01–03, move_00–03), mais idle_00 aprovado; faltam 12 quadros. Gerador bloqueado por HTTP 429 usage_limit_reached; liberação prevista 03/10/2026 10:19:52 America/Sao_Paulo. Pudim, Gargula, Receptaculo e Zuggtmoy aguardam 82 quadros; retomada total 94 prompts em shedaklah-resume-after-limit-2026-10-03.json. Nenhum ciclo incompleto foi admitido.

2026-10-03 retomada: liberação confirmada às 10h27; Limo de Juiblex concluído e integrado (20 quadros/4 tiras), total Shedaklah 80 quadros/16 tiras, manifesto 92 PNGs. Correções do gerador: move01/02 v02, death01/05 v02. Prancha e captura runtime conferidas; testes focados zero falhas, escala/base, ataque e morte corretos. Próximo: Pudim Negro; 82 novos quadros para quatro alvos restantes. Build anterior ainda contém 88 assets.

2026-10-03: Pudim Negro concluído e integrado (20 quadros/4 tiras; body109/base356). Correções pelo gerador: move00 v02 para orientação, idle03/move03/death00 v02 para paleta. Alfa nativo preservado. Testes focados zero falhas, runtime e captura conferidos. Shedaklah: cinco alvos completos, 100 quadros/20 tiras; manifesto 96 PNGs. Próximo Gárgula; faltam 63 novos quadros em Gárgula/Receptáculo/Zuggtmoy.
