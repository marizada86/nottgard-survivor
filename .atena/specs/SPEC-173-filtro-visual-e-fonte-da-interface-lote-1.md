---
id: "SPEC-173"
title: "Filtro visual de tela e fonte da interface (lote 1 da estética)"
status: "IMPLEMENTADA LOCAL em 2026-10-13 (PLAN-100, EVID-242); r3: Pixel descartado, IM Fell como padrão dos títulos; commits locais; aguarda playtest"
origin: planned
implementation_preceded_spec: false
request_classification: PLAN_DEVIATION
created: "2026-10-13"
relations: ["[[SPEC-132-lettering-e-cursor-do-jogo]]", "[[SPEC-165-sistema-de-ui-e-menu-de-pausa-mec-003]]", "[[SPEC-172-telemetria-de-quadros-e-maquina-fraca-emulada]]"]
cards: ["MEC-065", "MEC-066"]
content_state: DRAFT
---

# SPEC-173 — Filtro visual de tela e fonte da interface (lote 1)

Origem: pedido do dono em 2026-10-13 ("faça sugestões do que pode ser melhorado esteticamente… um filtro novo de pixelart… uma fonte de letras mais estilizadas…"), seguido de "abre a spec do lote 1, aprovação por lote". O lote 1 é a parte **só código** da lista de sugestões: não gera nem altera arte em `assets/`. Botões de arte, moldura do HUD, brilho, partículas e feedback de impacto ficam para os lotes 2 e 3 (ver "Fora do escopo").

## Estado de partida (verificado no código em 2026-10-13)
- Nenhum shader de tela. Só `ui/lettering_gradient.gdshader` (ouro no Label) e a névoa de borda (`ui/edge_fog.gd`).
- Render `gl_compatibility`, esticamento `canvas_items`, 1280×720 base, filtro de textura padrão `nearest` (`project.godot`).
- Fonte do corpo: `AlegreyaSans-Regular.ttf` no `ui/theme.tres` (`default_font`, 20 pt). Fonte de títulos: `CinzelDecorative-Bold.ttf` em `Lettering.FONT_PATH` (`ui/lettering.gd:6`) e carregada direto em `ui/title.gd` e `ui/menu.tscn`.
- Opções: `OptionsPanel` (`ui/options_panel.gd`) grava em `Game.profile.data.settings` e é usado pela aba Opções do Quartel e pela pausa; já tem seção "TELA".
- Camadas da cena de partida: fundo da fase em `layer = -10` (`ui/run.gd:164`), mundo na camada 0, `Hud` como instância de `CanvasLayer`, camada de encontros (névoa, introdução de chefe) em `layer = 20` (`ui/run.gd:186`).
- A arte é pintada em alta resolução, não pixel art estrita: um pixelizador cego pode borrar rostos de heróis. Por isso o lote entrega **três variantes comparáveis**, não uma só.

## Decisões do dono (2026-10-13)
| # | Decisão |
|---|---|
| D1 | Escopo: o lote 1 da proposta (filtro de tela e fonte). Lotes 2 e 3 não fazem parte desta spec. |
| D2 | Aprovação **por lote** (`per-batch`): uma aprovação antes de cada `B-XXX`. |

## Revisão r3 (2026-10-13, após o fechamento do PLAN-100)
Decisões do dono, no retorno do playtest das capturas: (1) **Pixel do mundo descartado**: "ficou ruim"; perfis com `visual_filter = pixel` voltam para `off`. (2) **Paleta e dither fica como opção**. (3) **IM Fell English é o padrão dos títulos**; a Cinzel vira opção (`cinzel`) e fallback; o id antigo `padrao` vira o padrão novo. (4) **Uncial Antiqua** segue como opção e candidata a outros usos. (5) Avaliar a IM Fell English também como **fonte do jogo inteiro** (corpo): fora desta spec, tratada como análise (ver EVID-242).
Os trechos abaixo sobre a variante "Pixel do mundo" e o padrão "Cinzel" descrevem a r1/r2 e ficam como histórico.

## Lacunas
| Tipo | Item | Padrão recomendado |
|---|---|---|
| BLOCKING | nenhuma | — |
| RESOLVABLE | **Rota do desvio.** O plano ativo é o PLAN-071 (B-006/S-011, aguardando aceite em aparelho). Esta spec é um `PLAN_DEVIATION` (DEV-040). | Confirmar "fazer agora e voltar ao PLAN-071", como no DEV-039. A spec foi aberta a pedido explícito; nenhuma execução antes da confirmação. |
| RESOLVABLE | **Download das fontes** (B-002). Baixar arquivo exige aprovação com nome, origem e tamanho. | Pedir no início do B-002: nomes e tamanhos exatos, origem `google/fonts` (OFL), com os `OFL-*.txt` junto, como as fontes atuais. |
| RESOLVABLE | **Qual fonte vence.** Subjetivo. | Entregar candidatas lado a lado e deixar o dono escolher; nenhuma é trocada como padrão sem aceite. |
| DEFERRED | Filtro em menus, título e Quartel (hoje só a partida). | Fora do lote; reavaliar depois do playtest. |
| DEFERRED | Paleta reduzida **por bioma** (a variante B usa níveis por canal, não paleta própria de cada bioma). | Lote 3, junto com o grading por bioma. |

## Comportamento novo

### Filtro visual (B-001, MEC-065)
1. Nova opção **Visual** na seção "TELA" do `OptionsPanel`, com quatro valores: **Desligado** (padrão), **Pixel do mundo**, **Paleta e dither**, **Gravura**. Chave nova `visual_filter` em `settings` (`off`, `pixel`, `paleta`, `gravura`); valor desconhecido ou ausente vira `off` (migração em `Profile._migrate_settings`).
2. Um nó `VisualFilter` (`CanvasLayer` com um `ColorRect` de tela cheia e `ShaderMaterial` com `hint_screen_texture`), criado pela partida (`ui/run.gd`), posicionado **acima do mundo e abaixo da `Hud`** e abaixo da camada de encontros, para que HUD, texto, cartas de oferta e janelas fiquem nítidos. A posição exata das camadas é decidida na implementação e coberta por teste (a HUD não pode estar sob o filtro).
3. Variantes, num único `ui/visual_filter.gdshader` com uniform de modo:
   - **Pixel do mundo:** amostra a tela em blocos de 2 px (parâmetro) com `nearest`, quantizando a coordenada; mantém a nitidez da HUD.
   - **Paleta e dither:** quantiza cada canal em poucos níveis (parâmetro, 5 a 8) com dither ordenado de Bayer 4×4 leve.
   - **Gravura:** contorno escuro de 1 px por detecção de borda na luminância, grão fixo e vinheta suave.
4. Aplica na hora ao mudar a opção (inclusive pela pausa), sem reiniciar a fase; recarrega ao abrir a partida seguinte.
5. Desligado = o `ColorRect` fica **invisível e sem material ativo** (custo zero, nada de passada extra).
6. Em aparelho de toque, a opção existe mas continua **desligada por padrão**; nada é forçado.
7. Respeita `reduced_impact`: a variante Gravura reduz o grão (sem cintilação) quando o impacto reduzido está ligado.

### Fonte da interface (B-002, MEC-066)
1. Resolutor `UiFonts` (estático): devolve a fonte de **título** a partir da chave `ui_font` em `settings`. Valores: `padrao` (Cinzel Decorative, como hoje) e um identificador por candidata cujo arquivo esteja em `assets/fonts` (candidata ausente nem aparece na lista). **Revisão r2 (2026-10-13, B-002):** só os títulos mudam; o corpo (Alegreya), os botões e os números de dano, HP e tempo ficam como estão, o que cumpre o item 5 sem mexer nos nós da HUD.
2. `Lettering.style` (que cobre o título do Quartel, as placas e os banners) e `ui/title.gd` passam a consultar o resolutor; a cadeia de fallback inclui sempre a fonte atual, então acento ou símbolo ausente na candidata cai na fonte padrão (sem "quadradinho").
3. Nova opção **Fonte** na seção "TELA" do `OptionsPanel`. Troca aplica ao **reabrir** a tela/pausa; reiniciar o jogo não é necessário.
4. Candidatas (todas de título; decisão e download no B-002): *Almendra Display*, *Uncial Antiqua*, *Pirata One* e *IM Fell English*. Cada uma passa por teste de cobertura dos glifos usados no jogo (acentos do português, `…`, `—`, `Nv`, algarismos).
5. Números de dano, HP e tempo mantêm fonte legível de algarismos (não vão para a fonte decorativa).

## Fora do escopo
Qualquer arte nova ou alterada em `assets/`; kit de botões e molduras (ART-047 e o kit ampliado); moldura do HUD de partida; brilho aditivo, partículas, flash de impacto e grading por bioma; filtro em menus e título; mudança de jogabilidade, balanceamento, dados ou versão do jogo.

## Lotes e etapas (aprovação por lote)
| Lote | Título | Etapas | Entrega |
|---|---|---|---|
| **B-001** | Filtro visual de tela (MEC-065) | S-001 shader e nó `VisualFilter`; S-002 setting, migração e `Game`; S-003 opção em `OptionsPanel` e aplicação na partida; S-004 testes; S-005 capturas das 3 variantes em 3 biomas e medição de custo | Filtro funcional, desligado por padrão, com evidência |
| **B-002** | Fonte da interface (MEC-066) | S-006 pedido de download (aprovação); S-007 `UiFonts` e ligação em `Lettering`, tema, título e menu; S-008 opção e testes de cobertura; S-009 capturas comparativas | Candidatas selecionáveis, padrão intacto |
| **B-003** | Fechamento | S-010 suíte, smoke, `controller_check`, `mobile_buttons_check`, `kit_test`; S-011 EVID-242, cartões, índices e `backlog_check`; S-012 retorno ao PLAN-071 | Lote fechado e rastreado |

Cada lote termina com checkpoint: resultado real, evidência e objetivo seguinte; o próximo só começa com aprovação explícita.

## Aceite
1. **Desligado não custa nada:** com `visual_filter = off` o nó não desenha e o resultado da partida é idêntico ao de hoje (teste de estado do nó e captura sem diferença).
2. **HUD fora do filtro:** teste prova que a `Hud` não está abaixo do `VisualFilter` e que a camada de encontros fica acima.
3. **Migração:** perfil sem a chave, com valor inválido e com valor válido resultam em `off`, `off` e o valor preservado; o perfil real do dono não é tocado pelos testes.
4. **Variantes:** as três variantes compilam e produzem imagem diferente da original e diferentes entre si (captura de 3 biomas: Dagruve, Molor, Coranthis, escolha por contraste de tom).
5. **Custo medido:** passo e tempo de quadro com e sem filtro, em 1 bioma, pelo `FrameStats` ou `perf_probe` (SPEC-172), registrados no EVID-242 com o limite declarado (GPU real não emulada).
6. **Fonte:** cobertura de glifos verificada por candidata; fallback comprovado ao remover um glifo; `padrao` idêntico ao atual.
7. Suíte, smoke, `controller_check`, `mobile_buttons_check` e `kit_test` sem falhas novas; `backlog_check` sem alertas novos.
8. **Subjetivo, pendente de playtest do dono:** se alguma variante "fica bonita", se o texto segue legível, se a fonte combina com o jogo. Nenhuma métrica substitui isso.

## Playtest (antes de rodar, Atena explica; o dono joga e julga)
- **O que testar:** as três variantes do filtro e (após o B-002) as fontes candidatas, comparando com Desligado/padrão.
- **Build e escopo:** `.exe` local em `build/` com o nome padrão de playtest, gerado só quando o dono pedir; sem commit nem push implícitos.
- **Objetivo:** escolher qual variante e qual fonte (se alguma) merece virar candidata a padrão ou recurso opcional.
- **Procedimento:** Opções → TELA → Visual; jogar 2 a 3 minutos em Dagruve e Coranthis em cada variante; repetir com as fontes.
- **Observações:** legibilidade da HUD e dos números de dano; rostos dos heróis; cansaço visual; quedas de fluidez em máquina mais fraca.
- **Critérios:** o dono marca "manter", "ajustar" ou "descartar" por variante e por fonte; nada vira padrão sem esse retorno.

## Riscos
- `hint_screen_texture` em `gl_compatibility` força uma cópia da tela por quadro (custo em máquina fraca): por isso desligado por padrão e medido no S-005.
- A detecção de borda da Gravura pode realçar o ruído da arte pintada; o parâmetro de limiar é exposto e ajustado na captura.
- Troca de fonte pode mudar largura de textos e estourar caixas fixas: testes de cobertura e capturas das telas com maior densidade de texto (ficha C, Quartel).
