---
id: "SPEC-080"
title: "HQs de transição importadas do Nottcard"
status: "rascunho — aguardando decisões D1 a D5; nada implementado"
created: "2026-09-29"
relations:
  - "[[EVID-109-importacao-das-hqs-do-nottcard-2026-09-29]]"
  - "[[SPEC-062-fila-de-geracao-externa-de-assets]]"
  - "[[SPEC-076-redefinicao-visual-de-brook]]"
---

# SPEC-080 — HQs de transição importadas do Nottcard

> **Atualização (2026-09-29):** o dono decidiu fazer HQs **novas** a partir do
> vault de Nottgard, usando as do Nottcard como inspiração. Esta spec passa a
> cobrir a tela, o perfil e o Diário, que servem às HQs importadas e às novas;
> o catálogo, os gatilhos e as conquistas ficam no
> [[PLAN-040-hqs-novas-highlights-do-vault-2026-09-29]]. O gatilho por fase
> vencida e o campo `trigger` do JSON permanecem válidos.

## Intenção

Atender ao ART-013 (IN-016 do playtest T01): pequenas cutscenes de imagens com
acontecimentos da história de Nottgard, reaproveitando as HQs que **já existem**
no Nottcard (`F:\dev\nottcard`). Nenhuma imagem nova é gerada e nenhuma lore
nova é escrita: os textos e a arte vêm do Nottcard sem alteração de conteúdo.

Fonte no Nottcard: `data/core/hq.json`, `assets/hq/`, e o desenho de tela na
SPEC-034 do Nottcard (`.atena/reference/nottcard-ai/specs/`) e no guia HQ-000.

## Escopo

| HQ | Título | Quadros | Texto |
|---|---|---|---|
| `hq_001` | Da Fenda nas Docas aos Guardiões de Nottgard | 4 | "A fenda nas Docas foi selada." · Maelor: "A cidade está respirando outra vez." · "Mas Nottgard ainda precisava de guardiões." · Helion: "Nottgard reconhece sua coragem." |
| `hq_002` | Guardiões de Nottgard | 4 | Castle Rodhe, broche de Guardião, Helion apresenta Brook França, estrada até Dagruve |
| `hq_003` | O mapa de Dagruve | 2 | Ritual interrompido; mapa de Dagruve com três lugares marcados |

Total: **10 quadros com texto** (11 imagens copiadas; ver D2).

## Achados na importação

1. `hq_001_q1..q4` já têm 1280×720; as demais têm 1672×941 (16:9 aproximado).
2. Existe `hq_003_q3.png` **sem texto correspondente** no `hq.json` do Nottcard
   (a HQ só cita dois quadros). A imagem mostra o grupo, com **uma figura infantil
   entre eles**, descendo a estrada para uma cidade ao pôr do sol.
3. Nenhuma imagem traz texto embutido; o texto é composto pela interface.
4. A ordem do Nottcard é Docas (M1) → Castle Rodhe → Dagruve (M2). No Survivors,
   **Dagruve vem primeiro** (`unlock: start`) e as Docas depois. Ver D1.

## Decisões pendentes (dono)

| ID | Pergunta | Recomendação da Atena |
|---|---|---|
| D1 | Ordem cronológica. `hq_001` diz "a fenda nas Docas foi selada" e `hq_002` manda o grupo *para* Dagruve, mas no Survivors Dagruve é jogada antes das Docas | Gatilho pela fase: `hq_003` ao vencer Dagruve pela primeira vez; `hq_001` e `hq_002` em sequência ao vencer as Docas pela primeira vez. A inversão narrativa fica registrada; aceitar, ou reescrever o texto de `hq_002`/`hq_003` (o que já seria lore nova) |
| D2 | O que fazer com `hq_003_q3` (figura infantil sem texto nem canon no Survivors) | Não importar até haver texto canônico; deixar como candidata fora do jogo |
| D3 | HQ **forçada** (aparece uma vez ao vencer, antes do resultado, pulável) ou **só no Diário** | Uma vez, pulável com Esc, e depois disponível no Diário; mesma decisão do Nottcard |
| D4 | Onde fica o Diário | Nova aba no Quartel (`ui/menu.gd` já usa `%Tabs`); sem botão desabilitado para HQs não vistas |
| D5 | Redimensionamento das 7 imagens de 1672×941 para 1280×720 | Filtro de área (as ilustrações não seguem uma grade de pixels), não nearest; `hq_001` já está no tamanho |

## Projeto (proposto, não iniciado)

- **Dados:** `data/hqs.json`, declarativo: `id`, `title`, `trigger` (`stage_cleared`
  = id da fase) e `panels[{image, speaker, text}]`. Sem lógica.
- **Perfil:** `Profile.data.hqs_seen` (dicionário id → true), criado por `fresh()`
  com migração segura para perfis antigos (sem a chave = nenhuma vista).
- **Tela:** `ui/hq_screen.*`, quadro em tela cheia com faixa escura para
  legenda/fala; fade curto; clique ou Enter avança; **Esc pula a HQ inteira**;
  sempre pulável.
- **Fluxo:** em `ui/run.gd::_show_result`, se a run foi vitória e a fase foi vencida
  pela primeira vez, abrir a HQ correspondente **antes** de `hud.show_result`.
  Derrota e desistência nunca mostram HQ.
- **Arte ausente:** fundo escuro liso com o texto por cima (mesma regra do projeto).
- **Assets:** `assets/hq/<hq_id>_q<n>.png`, 1280×720, admitidos só após o dono
  aprovar o redimensionamento (D5) e o backup de qualquer substituição.

## Não objetivos

- Não gera arte nova nem escreve texto novo; as "outras 21 HQs" do Nottcard não
  entram aqui.
- Não vende HQ na loja do meta (MEC-015) nem trava HQ por conquista (MEC-016).
- Não altera combate, drops, economia ou balanceamento.
- Não escreve no repositório do Nottcard (somente leitura).

## Critérios de aceite

1. Vencer Dagruve pela primeira vez mostra `hq_003`; vencer as Docas pela
   primeira vez mostra `hq_001` e depois `hq_002`. Das segundas vitórias em
   diante nada aparece.
2. Esc pula a HQ inteira; clique/Enter avança; nenhuma HQ passa de ~15 s de leitura.
3. Sem arte, os quadros rodam com o fundo de fallback e o texto.
4. O Diário lista apenas HQs já vistas e permite reassistir.
5. Perfil antigo (sem `hqs_seen`) carrega sem erro e sem perda.
6. Derrota e desistência não mostram HQ; testes de perfil e de fluxo passam.
7. Legibilidade a 1280×720 e a 1920×1080 conferida em uma run real.

## Riscos

- **Médio (fluxo):** insere uma tela entre o fim da run e o resultado; mexe em
  `ui/run.gd`, `core/profile.gd` e `ui/menu.gd`. Mitigação: Esc sempre pula, e a
  chamada fica atrás de uma flag de dados.
- **Baixo (narrativo):** D1 pode expor a inversão de ordem ao jogador.
- **Regra do backlog:** é mecânica (tela com função nova, MEC-025) e **não entra
  no mesmo commit que arte ou bug-fix**. A cópia das imagens é um commit separado.

## Plano de voo (após D1 a D5)

1. Redimensionar e admitir as imagens aprovadas (commit de arte).
2. Perfil + dados + tela + gatilho (commit de mecânica), com testes.
3. Diário no Quartel.
4. Suíte, smoke, run real de Dagruve e Docas, evidência `EVID-110`.

## Gate

Rascunho. Nada foi implementado e nenhum arquivo do jogo foi alterado.
