---
id: "SPEC-061"
title: "Preparação da regeneração do piloto de Zumbi"
status: "aprovada — brief local preparado; geração autorizada, aguardando execução externa pelo dono"
created: "2026-09-28"
relations:
  - "[[PLAN-032-proxima-atualizacao-pos-playtest-2026-09-28]]"
  - "[[EVID-091-playtest-higo-hiago-build-c-e-item-offer-2026-09-28]]"
  - "[[SPEC-049-preparacao-da-regeneracao-do-piloto-de-leoric]]"
  - "[[SPEC-038-integridade-visual-dos-inimigos]]"
---

# SPEC-061 — Preparação da regeneração do piloto de Zumbi

## Origem

Playtest de 2026-09-28 (resposta 7 do questionário,
[[EVID-091-playtest-higo-hiago-build-c-e-item-offer-2026-09-28]]): Zumbi
relatado "transparente com pixel soltos, como Leoric estava antes de ser
consertado". Investigação de código na mesma evidência descarta bug de
dimensão/grade/import: `ui/enemy_view.gd` espera célula `256×384` com
`idle=4, move=6, attack=4, death=6`, e os quatro PNGs em
`assets/animations/enemies/zumbi/` têm exatamente as dimensões esperadas.
[[SPEC-038-integridade-visual-dos-inimigos]] já audita alfa/conteúdo visível
de Zumbi sem falha. Ou seja: o defeito não é de renderização nem de
integridade de arquivo — é o mesmo tipo de problema que Leoric teve, uma
cobertura de opacidade fraca dentro da arte já gerada, que um teste
automatizado de "existe pixel visível" não pega.

## Intenção

Preparar de forma local, rastreável e reversível o piloto de regeneração de
Zumbi, seguindo o mesmo pipeline já validado em
[[SPEC-049-preparacao-da-regeneracao-do-piloto-de-leoric]]: quatro frames de
`idle`, seis de `move`, quatro de `attack` e seis de `death` (20 células).
Esta spec não gera imagens, não transfere referências e não altera assets
oficiais.

## Escopo

- Congelar as referências atuais de Zumbi (os quatro PNGs oficiais e o brief
  de `ART-PROMPTS-011-herois-run-e-inimigos-legado.md`), hashes, prompts e
  negativos no brief.
- Preparar 20 IDs de célula, ordem, pose, formato e critérios de descarte.
- Definir inspeção, montagem dos candidatos, QA runtime, seleção e admissão —
  mesmo fluxo de SPEC-049.

## Não objetivos

- Chamar serviço de geração, configurar credencial, aceitar licença, enviar
  arquivos, gastar créditos ou criar job.
- Montar strips, copiar PNGs ou alterar arquivos sob `assets/`.
- Alterar dados de combate do Zumbi (`hp`, `atk`, `xp`, habilidades de
  invocação etc.), lore, SFX, cenas ou outros inimigos.
- Investigar ou regenerar Sacerdote da Mente Derretida ou qualquer herói —
  fica registrado como risco em observação em
  [[PLAN-032-proxima-atualizacao-pos-playtest-2026-09-28]], não decidido para
  execução nesta spec.

## Contratos

1. Cada célula é RGBA 256×384, sem fundo, com margem lateral mínima de 8 px,
   ancorada na borda inferior da célula (mesma convenção que `enemy_view.gd`
   já usa para Zumbi hoje — sem margem especial de rodapé como a de Nyrelia).
   `idle` e `attack` têm 4 frames; `move` e `death` têm 6.
2. Zumbi permanece um cadáver humano movido pela névoa: roupas portuárias
   rasgadas, pele cinza, postura curvada, morto comum e sem gore excessivo
   (brief de `ART-PROMPTS-011`). Nenhum frame pode ser só traço ou VFX, e a
   silhueta precisa ter cobertura de opacidade real e sólida — não pixels
   esparsos sobre fundo majoritariamente transparente.
3. Candidatos ficam somente em `.atena/generated/zumbi-regeneration/v01/`.
4. Seleção artística e admissão nos paths oficiais são gates independentes.

## Gates

- Aprovar esta SPEC prepara somente artefatos locais.
- Autorização posterior de geração define método, licença, referências que
  podem sair do workspace, máximo de jobs e teto de gasto quando aplicável.
- Só uma admissão explícita pode substituir os arquivos oficiais.

## Critérios de aceite

1. O brief identifica as 20 células, referências, dimensões, poses, negativos
   e condições de descarte sem ambiguidade.
2. Não há fornecedor, licença, custo ou job inferidos.
3. A preparação não modifica os quatro PNGs oficiais, lock ou registros
   canônicos de Zumbi.
4. Cada candidato aprovado tem cobertura de opacidade visivelmente sólida na
   silhueta, verificada por inspeção humana **numa cena de jogo real, em
   movimento** — não só um atlas estático em fundo neutro. Essa lacuna
   específica (verificação só estática) foi o que deixou o defeito de Leoric
   passar despercebido antes; não se repete aqui.

## Plano de voo proposto

1. Congelar referências, hashes, prompts e negativos no brief.
2. Aguardar autorização explícita do dono para gerar (gate separado desta
   aprovação de spec).
3. Gerar, normalizar e validar os 20 frames candidatos em
   `.atena/generated/zumbi-regeneration/v01/`.
4. Captura runtime dos candidatos em escala real **dentro de uma run/QA de
   verdade**, não só atlas em fundo neutro.
5. Seleção artística e admissão explícita do dono nos paths oficiais.
6. Rodar suíte e smoke, registrar evidência antes de reconciliar.

## Limites

- Nenhuma geração nem substituição de arquivo acontece sem autorização
  explícita separada em cada etapa (geração, depois admissão), conforme os
  Gates acima.

## Reconciliação

- O dono aprovou esta SPEC em 2026-09-28.
- Preparação local concluída: `BRIEF-ZUMBI-REGEN-V01.md` e
  `PILOT-REQUEST-TEMPLATES-001.json` em
  `.atena/generated/zumbi-regeneration/v01/`, com as 20 células, referências
  hasheadas (quatro PNGs oficiais + fallback estático), contrato visual e
  condições de descarte.
- O dono autorizou a geração em 2026-09-28. Diferente do lote de Leoric, esta
  sessão do Claude Code não tem nenhuma ferramenta de geração de imagem
  disponível — o Leoric foi gerado em outra sessão/ambiente com essa
  integração. O dono vai gerar os 20 frames externamente, usando o brief e
  os prompts já preparados, e devolver os PNGs para esta sessão normalizar,
  validar em runtime e conduzir a seleção/admissão.
- Convenção esperada para o retorno: 4 folhas brutas em
  `.atena/generated/zumbi-regeneration/v01/sheets/{idle,move,attack,death}_source.png`,
  cada uma já como tira horizontal (célula 256×384 × contagem de frames da
  respectiva animação), mesmo padrão usado no lote de Leoric.
- 2026-09-28: prompts revisados especificamente para o gerador de imagem do
  ChatGPT em
  `.atena/generated/zumbi-regeneration/v01/CHATGPT-PROMPTS-ZUMBI-V01.md` —
  20 parágrafos autocontidos (um por frame), com aviso explícito de que o
  ChatGPT não gera tiras de animação pixel-perfeitas diretamente; exige
  montagem manual dos 20 frames numa grade 256×384 depois de gerados.
- Nenhum PNG oficial, lock ou registro canônico de Zumbi foi tocado.
