---
id: PLAN-065
title: Lettering do jogo e cursor do mouse temáticos
spec: SPEC-132
cards: [ART-039, ART-040, MEC-058]
status: aprovado por plano em 2026-10-06; B-001 e B-002 feitas (EVID-172); B-003 aguarda o gerador de imagem
approval_mode: per-plan
---

# PLAN-065

Spec: [[SPEC-132-lettering-e-cursor-do-jogo]]. Estado operacional: `.atena/state/plan-065-lettering-cursor.yaml`.

## Ordem na fila de imagens
(1) PLAN-053 heróis, (2) CHATGPT-FILA-025 ficha C, **(3) CHATGPT-FILA-026 (esta)**, (4) FILA-021 E e F, (5) FILA-022 e 023. O código da B-002 não depende da fila e pode andar antes.

## Lotes

### B-001 Direção, inventário e prompts (sem código do jogo)
| Passo | O quê |
|---|---|
| S-001 | Inventário das strings de UI com candidatas a lettering (`ui/*.gd`, `data/hqs.json`); fecha a lista L01 a L06+ e P01 a P03. |
| S-002 | Quadro de estilo: Cinzel Decorative, ferro escuro + ouro velho + roxo abissal ([RESEARCH-003](../research/RESEARCH-003-paleta-das-deidades-2026-09-27.md)); referências locais (`title_background.png`, `evolucao_painel_moldura.png`, `victory/defeat_background.png`) e do Nottcard, se houver. |
| S-003 | `ART-PROMPTS-058` (peças, tamanhos, magenta `#FF00FF` para chave, critérios de aceite, grafia) e `CHATGPT-FILA-026` com a **L01 logo primeiro** (define o tom, como a A01 da ficha C). |
| S-004 | Cartões ART-039, ART-040 e MEC-058 no backlog; numeração do README. |

### B-002 Esqueleto de código com fallback (independe da arte)
| Passo | O quê |
|---|---|
| S-005 | `ui/cursor_skin.gd` (helper estático): carrega 3 PNGs de `assets/ui/cursor/`, aplica `Input.set_custom_mouse_cursor` por forma, hotspots em `data/cursor.json`; sem arte, não faz nada. Chamado em `Game`. |
| S-006 | Run: forma `CROSS` só com mira por mouse e sem modal; troca AUTO/MOUSE e abrir/fechar modal atualizam. |
| S-007 | `ui/lettering.gd` (helper estático): estilo de `Label` dinâmico e criação de placa de nove fatias com fallback para o visual atual. |
| S-008 | `tests/test_cursor.gd` e `tests/test_lettering_assets.gd` (tolerantes à arte ausente até a B-003), `run_all.gd`, `audit_projeto`. |

### B-003 Arte: gerar, normalizar, aprovar, admitir (depende do gerador de imagem)
| Passo | O quê |
|---|---|
| S-009 | **L01 logo** gerada pelo dono/Codex; **portão visual G1** (dono aprova o tom antes das demais). |
| S-010 | Demais peças L e P, 3 candidatos por peça em `.atena/generated/art-candidates/lettering/`; cursores C01 a C03 (4×) em `.../cursor/`. |
| S-011 | `tools/normalize_lettering.gd`: chave magenta, corte, redução, auditoria de alfa (reaproveita `audit_candidate_alpha`); cursores reduzidos a 32/40 px com tabela de hotspots. Fallback por script se o cursor não ler a 32 px. |
| S-012 | Prévia: banners e placas sobre capturas reais; cursores compostos sobre captura no hotspot. **Portão visual G2** (aprovação do dono por peça). |
| S-013 | Admissão em `assets/ui/title/`, `assets/ui/lettering/`, `assets/ui/cursor/`; `ASSET-APPROVAL-REGISTER` e manifesto. **Commit de arte** (só com aprovação). |

### B-004 Integração, verificação e fechamento
| Passo | O quê |
|---|---|
| S-014 | Ligar título, fim de fase, evolução, chefe, HQ e quartel às peças. `ui/hud.gd`, `ui/character_sheet.gd` e `ui/hero_panel.gd` só depois dos commits de PLAN-063/064 (G-5). |
| S-015 | Capturas 1280×720 e 1920×1080; suíte completa com 0 falhas; conferência de modais e AUTO/MOUSE no cursor. |
| S-016 | EVID, itens "O que testar" em `RELEASES.md`, cartões, reconciliação, spec para `implemented-pending-playtest`. **Commit de código** separado (só com aprovação). |

## Portões independentes do nível de aprovação
G1 e G2 (visuais do dono), commits, push, build e release continuam exigindo aprovação explícita. Nada de dependência nova: Godot nativo e scripts GDScript/PowerShell já usados.

## Riscos
| Risco | Mitigação |
|---|---|
| Gerador erra acento ou letra | Camada 2 (placa + fonte) e conferência letra a letra. |
| Cursor ilegível em 32 px | Fallback por script; teste de hotspot e composição visual. |
| Hotspot da mira desalinha o tiro | Hotspot no centro, teste numérico e rodada manual com mira por mouse. |
| Cursor invisível nas capturas (é do SO) | Composição por script e item de verificação manual no playtest. |
| Conflito com PLAN-063/064 em `ui/hud.gd` e ficha C | Integração desses arquivos espera os commits (G-5). |
| Cota do gerador | Plano segue em B-001/B-002 sem ele; B-003 pausa e retoma. |

## Reversão
Por lote: os dois commits (arte, código) são independentes; o código tem fallback sem arte.
