---
id: "PLAN-035"
title: "Geração em lotes dos assets visuais pendentes"
status: "Lotes A, B e C executados; reconciliação de evidências em curso"
created: "2026-09-28"
relations:
  - "[[SPEC-061-preparacao-da-regeneracao-do-piloto-de-zumbi]]"
  - "[[SPEC-062-fila-de-geracao-externa-de-assets]]"
  - "[[SPEC-063-objetos-quebraveis-e-rebalanceamento-de-pocao]]"
  - "[[ART-PROMPTS-024-cenario-e-quebraveis-por-bioma]]"
  - "[[CHATGPT-PROMPTS-ZUMBI-V01]]"
---

# PLAN-035 — Geração em lotes dos assets visuais pendentes

## Descoberta consolidada

O manifesto histórico de produção está completo para seus 269 assets, mas o
último commit adicionou uma fila posterior, ainda fora dele. Ela contém 48
novas saídas de imagem:

| Lote | Entregáveis | Quantidade | Prioridade |
|---|---|---:|---|
| A | Quebráveis definitivos, um por bioma | 7 | Alta |
| B | Props decorativos, três por bioma | 21 | Média |
| C | Células da animação do Zumbi | 20 | Alta, mas tecnicamente mais arriscada |

Os quebráveis já funcionam com imagens provisórias reaproveitadas. Nenhum
arquivo oficial será substituído durante a geração de candidatos.

## Escopo

- Produzir candidatos PNG para os 7 quebráveis de `ART-PROMPTS-024`:
  `saco_de_esporos_quebravel`, `casulo_viscoso_quebravel`,
  `urna_funeraria_quebravel`, `lanterna_de_papel_quebravel`,
  `espelho_ilusorio_quebravel`, `estatua_rachada_quebravel` e
  `relicario_instavel_quebravel`.
- Depois de aprovar o lote A, produzir os 21 props decorativos descritos em
  `ART-PROMPTS-024`, em grupos de três por bioma.
- Depois de aprovar os lotes estáticos, produzir 20 células independentes
  para `idle`, `move`, `attack` e `death` do Zumbi, conforme SPEC-061.
- Normalizar candidatos, validar transparência, enquadramento e legibilidade;
  só então apresentar uma prancha de revisão para escolha humana.

## Não objetivos

- Não alterar lore, prompts canônicos, dados de jogo, colisões ou regras de
  combate.
- Não sobrescrever os PNGs atuais sob `assets/` sem aprovação explícita de
  admissão após a revisão visual.
- Não gerar variantes ilimitadas: cada asset recebe uma primeira candidata;
  uma nova tentativa só acontece quando um critério objetivo de QA falhar.
- Não misturar assets provisórios e candidatos: candidatos permanecem em
  `.atena/generated/` até admissão.

## Estratégia de geração

Usar o gerador de imagem nativo em uma chamada por asset distinto. Para os
assets estáticos, solicitar PNG com fundo realmente transparente e preservar
o alfa; isso substitui o fundo magenta/ciano indicado nos prompts, que era um
contorno para uma ferramenta que não garantia transparência. Os requisitos
visuais, câmera isométrica, margem, luz, paleta e itens proibidos dos prompts
originais permanecem inalterados.

Para o Zumbi, cada uma das 20 células será uma chamada independente. A
consistência entre células é o maior risco; portanto, este lote só começa
depois de uma candidata de `idle` ser aprovada como referência de identidade.

## Plano de voo

1. **Preparação e congelamento.** Ler os prompts aprovados e as imagens
   oficiais apenas como referência local; registrar para cada chamada o
   prompt final, destino de candidata e critérios de descarte.
2. **Lote A — quebráveis.** Gerar sete candidatas RGBA, uma por bioma, em
   `.atena/generated/art-candidates/breakables/`. Inspecionar silhueta sólida
   a 62 px, ausência de texto/cenário e coerência com o bioma.
3. **Gate A.** Criar prancha de revisão e apresentar as sete candidatas. Só a
   seleção explícita do dono permite normalizar e admitir qualquer uma em
   `assets/enemies/`.
4. **Lote B — props.** Processar um bioma por vez (três props), mantendo a
   mesma referência de terreno e paleta do bioma. Cada grupo recebe a própria
   prancha e gate de aprovação; os arquivos permanecem em
   `.atena/generated/art-candidates/props/<bioma>/`.
5. **Gate B.** Após cada grupo, validar 256×256 RGBA, margem, alpha e leitura
   no cenário correspondente antes de qualquer admissão em `assets/props/`.
6. **Lote C — Zumbi.** Gerar primeiro os quatro frames de `idle`; se a
   identidade e cobertura opaca forem aprovadas, gerar as outras 16 células,
   montar as quatro tiras candidatas em
   `.atena/generated/zumbi-regeneration/v01/` e testar em runtime.
7. **Admissão separada.** Para cada lote aprovado, copiar somente as versões
   escolhidas aos paths oficiais, atualizar o manifesto/registro de ativos e
   conservar a proveniência da candidata.
8. **Verificação e reconciliação.** Rodar a suíte automatizada e o smoke
   existente, abrir uma run de QA por bioma afetado e registrar evidência com
   prompts, caminhos, checksums, decisão visual e exceções.

## Critérios de aceite

1. Cada candidata respeita o prompt aprovado: pixel art sombria, câmera
   isométrica 3/4, luz superior esquerda, sem texto, moldura, personagem ou
   cenário indevido.
2. Arquivos estáticos possuem alfa real, uma silhueta sólida e leitura clara
   em escala de jogo; nenhum contém halo ou fundo residual.
3. Props admitidos são PNG RGBA de até 256×256 e não alteram gameplay.
4. O Zumbi só é admitido se as 20 células preservarem identidade, base,
   enquadramento e opacidade em uma run real — não apenas numa prancha.
5. Nenhuma substituição oficial ocorre sem a seleção explícita do dono.
6. A suíte e o smoke continuam verdes após cada admissão.

## Impactos e riscos

- **Visual:** substitui placeholders por arte específica de bioma.
- **Técnico:** a geração não toca código; a admissão pode exigir atualização
  do manifesto e importação do Godot.
- **Risco principal:** variação de identidade/escala entre imagens geradas,
  sobretudo no Zumbi. Os gates por lote limitam esse risco.
- **Custo e escopo:** 48 chamadas base, mais apenas as regenerações justificadas
  por falhas de QA. Lotes A, B e C não devem ser executados de uma só vez.

## Evidência e reconciliação esperadas

- Registro por chamada com prompt final, data, candidata e resultado de QA.
- Prancha de revisão por lote e captura runtime para cada bioma/entidade
  admitida.
- Manifesto de assets atualizado somente após admissão.
- Evidência em `.atena/evidence/` ligada à SPEC correspondente; a fila
  SPEC-062 marca cada item como processado apenas ao final.

## Progresso

- 2026-09-28: o dono aprovou o plano e liberou o Lote A. Sete candidatas
  foram geradas com alfa real, revisadas e admitidas em `assets/enemies/` após
  aprovação explícita. Os placeholders foram preservados em
  `.atena/evidence/EVID-098-pre-admission-backup/`; suíte e smoke passaram.
- 2026-09-28: o dono liberou e aprovou o grupo Shedaklah do Lote B. As três
  candidatas foram normalizadas, admitidas em `assets/props/`, expostas no
  componente de props e instanciadas em `ui/stages/shedaklah.tscn` sem colisão.
  A suíte e o smoke passaram.
- 2026-09-28: o dono liberou o grupo Molor do Lote B. As candidatas
  `estalactite_01`, `estalactite_02` e `resina_01` foram geradas com alfa real,
  aprovadas, normalizadas e admitidas em `assets/props/`. Foram expostas no
  componente de props e instanciadas em `ui/stages/molor.tscn` sem colisão; a
  suíte e o smoke passaram.
- 2026-09-28: o dono liberou o grupo Durao do Lote B. As candidatas
  `corrente_01`, `corrente_02` e `osso_01` foram geradas, aprovadas,
  normalizadas e admitidas em `assets/props/`. Foram expostas no componente de
  props e instanciadas em `ui/stages/durao.tscn` sem colisão; a suíte e o
  smoke passaram.
- 2026-09-28: o dono aprovou os grupos Feng-tu, Shendilavri, Goranthis e
  Pilares do Lote B. As quatro trincas foram admitidas em `assets/props/`,
  expostas no componente de props e instanciadas nas respectivas cenas sem
  colisão; a suíte e o smoke passaram em cada etapa.
- 2026-09-29: o dono aprovou o Lote C. As 20 células do Zumbi foram geradas,
  revisadas na prancha EVID-103, normalizadas nas quatro tiras oficiais e
  admitidas com backup em EVID-104. A suíte e o smoke passaram; a captura
  visual interativa ficou pendente por limitação do renderer headless.

## Gate de aprovação

Este é um rascunho de plano. Os lotes A, B e C foram liberados e aprovados
explicitamente pelo dono ao longo da execução. Nenhuma publicação, commit ou
push está incluído nesta aprovação.
