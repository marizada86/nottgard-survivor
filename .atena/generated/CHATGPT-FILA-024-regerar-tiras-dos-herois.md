---
id: "CHATGPT-FILA-024"
title: "Fila de geração — regerar tiras de heróis com defeito de dimensão (PRIORIDADE ALTA)"
status: "W01–W15 e A01–A10 integrados após auditoria; lote concluído; EVID-145"
priority: "alta"
created: "2026-10-02"
relations: ["[[ART-PROMPTS-055-regerar-caminhadas-e-acoes-dos-herois]]", "[[EVID-146-auditoria-de-dimensoes-dos-herois-2026-10-02]]"]
---

# CHATGPT-FILA-024 — Tiras de heróis (prioridade alta)

Compilação operacional de [[ART-PROMPTS-055-regerar-caminhadas-e-acoes-dos-herois]]; em caso de dúvida, o ART-PROMPTS prevalece. **Esta fila passa na frente das demais** (pedido do dono em 2026-10-02: heróis esticam, crescem ou afinam ao andar).

## Ordem de envio

1. Uma tira por chamada, na mesma conversa por herói. Anexar o `idle.png` do herói (identidade e escala) e a tira defeituosa (pose).
2. Pedir a tira **já na grade 256 × 384 por quadro**, com a folga de 10 px, altura e base-alvo do ART-PROMPTS-055.
3. Destino dos candidatos: `.atena/generated/art-candidates/heroes-dimensoes/<heroi>/<sequencia>.png`. Nada entra no runtime sem passar na auditoria de aceite.

Marque `[x]` ao gerar e `[a]` ao aprovar.

## P1 — enviar primeiro (erro visível no jogo)

- [x] gerada · [ ] aprovada — W01 Kayron `move_se`
- [x] gerada · [ ] aprovada — W02 Korrak `move_e`
- [x] gerada · [ ] aprovada — W03 Korrak `move_se`
- [x] gerada · [ ] aprovada — W04 Korrak `move_ne`
- [x] gerada · [ ] aprovada — W05 Korrak `move_s`
- [x] gerada · [ ] aprovada — W06 Bromnor `move_e`
- [x] gerada · [ ] aprovada — W07 Bromnor `move_se`
- [x] gerada · [ ] aprovada — W08 Sylas `move_ne`

## P2 — caminhadas

- [x] W09 Kayron `move_n` · `move_s` — geradas, auditadas e integradas
- [x] W10 Sylas `move_s` — gerada, auditada e integrada
- [x] W11 Brook `move_n` · `move_ne` — geradas, auditadas e integradas
- [x] W12 Durvall `move_ne` · `move_e` — geradas, auditadas e integradas
- [x] W13 Nyrelia `move_e` — gerada, auditada e integrada
- [x] W14 Maelor `move_n` · `move_ne` · `move_e` · `move_se` · `move_s` — geradas, auditadas e integradas
- [x] W15 Bromnor `move_n` · `move_ne` · `move_s` — N/NE reempacotadas após reauditoria; S regenerada; todas integradas

## P2 — ação

- [x] A01 Zynara `attack`
- [x] A02 Korrak `active`
- [x] A03 Sylas `active`
- [x] A04 Bromnor `attack` · `active`
- [x] A05 Durvall `attack` · `active`
- [x] A06 Brook `attack` · `active`
- [x] A07 Leoric `attack` · `active`
- [x] A08 Kayron `active`
- [x] A09 Maelor `active`
- [x] A10 Nyrelia `active`

## Texto de envio (copiar por chamada)

> Use o bloco comum e as regras de dimensão 1–8 do ART-PROMPTS-055. Herói: `<HEROI>`. Sequência: `<SEQUENCIA>` (`<N>` quadros, direção na tela: `<DIRECAO>`). Altura do corpo em todos os quadros: `<ALTURA>` px; sola do pé na linha y = `<BASE>` px; célula 256 × 384 por quadro, 10 px de folga, arma e capa inteiras dentro da célula. Mesma massa e mesmo lado da arma do idle anexado. Entregar a tira com alfa real, sem sombra, texto ou grade.

W02 integrado localmente sob o pedido de adicionar as imagens ao jogo, sem atribuir aprovação visual individual ao dono. Matriz selecionada: korrak/move_e_v03.png. Tira empacotada: korrak/move_e.png; original runtime anterior preservado. Altura267px, base350, seis quadros, massa0,990–1,035xidle, sem bordas; relatório de equalização vazio. Runtime habilitado apenas na direção direita; outras sete mantêm o fallback provisório. W01 permanece candidato por halo; não integrado.

Continuação de 2026-10-02: W03 (move_se_v02) e W05 (move_s_v01) integrados após auditoria: seis quadros, 267 px de altura, base 350, sem bordas, massa 0,965–1,027 e 0,886–0,944 × idle respectivamente. Capturas no jogo conferidas. Runtime usa E/SE/S; outras direções continuam provisórias. W04 v01/v02 rejeitados visualmente por halo marrom mesmo com métricas geométricas válidas; v03 em geração. Prompts: bloco comum ART-PROMPTS-055, direção visual explícita, alternância de seis passos e transparência limpa; v02 W04 pediu extração do fundo, v03 regeneração com referência limpa de W05. Originais preservados.

W04 v03 corrigiu a transparência no gerador; massa 0,791–0,856 × idle, altura267/base350 em seis quadros, aceite sem falhas, integrado. W06/W07 Bromnor v01: altura241/base364; massa0,975–1,049 e0,944–1,019; W08 Sylas v01: altura304/base376; massa0,845–0,930. Todas sem cortes, capturas no jogo inspecionadas, originais preservados. Manifesto agora40 PNGs (33 novos +7 substituições). Testes de animação e VFX:0 falhas. Suite completa do workspace compartilhado:11 falhas em test_level_design.gd sobre props de durao; sem falhas de animação. HEAD alterado por outro chat para18d504f; mudanças compartilhadas preservadas. W15 reauditorado: três tiras ainda têm1–2 falhas de base de2–3px, sem cortes; não dar como encerrado ainda. W09–W11 iniciados pela prioridade P2. W01 continua aguardando escolha sobre limpeza de alfa.

W09–W11 integrados (cinco tiras v01): Kayron N/S altura316/base376/massa0,994–1,062; Sylas S304/376/massa1,036–1,054; Brook N/NE259/368/massa0,788–0,926. Todos6quadros, sem bordas, alfa original preservado no empacotamento. Manifesto45PNGs; prompts exatos desse lote em heroes-walk-prompts-2026-10-02.json. W12–W14 em geração. Testes/capturas gerais do lote ainda serão atualizados.

W12 Durvall NE v01 e W13 Nyrelia E v02 integrados; Durvall E v01 perdeu espada em um quadro, v02 juntou duas silhuetas, v03 em geração. Nyrelia v01 sobrepunha roupas; v02 compacta passou, massa0,810–0,855. W14 Maelor NE/E/SE/S v01 integrados, altura299/base364, massa0,733–0,963; N v01 rejeitado por massa0,673–0,728, v02 em geração. W15 Bromnor N/NE: arte atual recuperável, grade/base corrigidas sem redesenhar, altura241/base364, massa1,034–1,148, integradas. S recuperou a métrica, mas revisão visual identificou fragmento de braço vizinho; candidato empacotado não integrado, nova tira em geração. Manifesto53PNGs, incluindo duas correções técnicas de tiras existentes. A01–A06 em geração, uma chamada por tira, referência idle e ação original, escala constante e VFX compactos; originais preservados.

Caminhadas W02–W15 concluídas. Últimas selecionadas: Durvall E v03(espada inteira, massa1,087–1,181), Maelor N v02(massa0,795–0,822), Bromnor S v01(massa0,900–0,937). A04 Bromnor active v01 admitido:241/base364/massa1,036–1,063. Manifesto57PNGs, incluindo2reempacotamentos técnicos de BromnorN/NE. Demais ações em correção de largura/halo; nada com defeito foi integrado. Korrak N existente reauditorado:0falhas, altura261–269/base350/massa1,099–1,148; não foi regenerado. W01 continua fora do runtime. Capturas e validação final desse lote em andamento.

## Fechamento do lote de heróis — 2026-10-02

W02–W15 integrados e A01/A03–A10 integrados: 13 tiras de ação ao todo (5 ataques de quatro quadros, 8 ativas de seis quadros). A02 Korrak active permanece na arte anterior: v01/v02 inválidas e v03 com apenas três grupos de alfa por sobreposição entre seis figuras; nenhuma delas admitida. W01 Kayron move_se permanece candidato por halo e aguarda a decisão de limpeza de alfa já apresentada ao dono. Não aplicar a autorização de limpeza de Molor aos heróis.

Manifesto acumulado: 69 PNGs = 33 novos fora dos heróis + 36 tiras de heróis substituídas/corrigidas, das quais duas são reempacotamentos técnicos de Bromnor N/NE. Neste prosseguimento foram admitidas 35 tiras, pois Korrak E já estava admitido anteriormente. Geração pelo imagegen integrado, originais e versões rejeitadas preservados. Prompts exatos recentes: heroes-walk-prompts-2026-10-02.json, heroes-walk-prompts-correcoes-2026-10-02.json e heroes-action-prompts-2026-10-02.json.

Ações selecionadas: Zynara attack v02; Sylas active v02; Bromnor attack v02/active v01; Durvall attack/active v02; Brook attack v03/active v02; Leoric attack v02/active v01; Kayron, Maelor e Nyrelia active v01. Quando a arma sobe acima da cabeça, o empacotamento usa pontos cabeça/sola anotados para preservar a altura do corpo: Bromnor 219 px (o idle completo tem 241 px por causa do martelo), Durvall 231 px e Brook 259 px. Não confundir extensão da arma com altura do personagem. RGB/alfa originais preservados; nenhuma limpeza de alfa por código nos heróis.

Validação: aceite de cada candidata sem falhas; focused Animation queue: 0; suite completa: 0 falhas (as 11 falhas anteriores de Durão desapareceram após a atualização do workspace compartilhado); smoke das nove fases: ok; relatório read-only de equalização vazio; runtime Korrak E/SE/S/NE confirmado, quatro direções provisórias preservadas; capturas de todas as tiras novas efetuadas, amostras de caminhadas e ataques inspecionadas no jogo; git diff --check sem erros. Aviso ambiental de certificados do Godot não interrompeu os processos.

Build local: build/image-priority-heroes/NottgardSurvivors.exe, identificador 942fbe8+, 403909160 bytes, SHA256 F953F829C9E2E4CE56B7941FEFB6A63609CDE97582492E1BAFEA12D922B65C89. Exportação e inicialização do executável terminaram com código 0. Inclui os 69 arquivos do manifesto. Alterações de outros chats preservadas; sem commit/push desta execução. FILA-024 permanece parcial pelas duas pendências citadas; restante da fila global ainda aberto.

## Retomada autorizada pelo dono — 2026-10-02
Pedido “atena continuar”: nova tentativa com referências limpas existentes. W01 Kayron move_se v04 e A02 Korrak active v04 passaram: seis silhuetas separadas, alfa do gerador preservado, sem limpeza por código. Kayron316/base376/massa0,923–0,989; Korrak267/base350/massa0,890–0,958; sem cortes. Integrados, backups preservados, capturas runtime inspecionadas. FILA-024 concluída localmente sob autorização geral; não atribuir aprovação visual individual ao dono. Manifesto71PNGs. Exceção conhecida de massa Kayron retirada do teste. Próximo item da prioridade original: completar os25quadros restantes de Blogbog (identidade já aprovada), uma chamada por quadro conforme ART-PROMPTS-045.