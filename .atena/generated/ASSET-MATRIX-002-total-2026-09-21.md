# ASSET-MATRIX-002 — Cobertura visual total de Nottgard Survivors

Status: **executada e reconciliada em 2026-09-22**
Data: 2026-09-21  
Relações: `PLAN-003-geracao-total-assets-2026-09-21`, `RESEARCH-002-biblioteca-visual-desktop-2026-09-21`, `ART-PROMPTS-001..010`

## Resumo executivo

O alvo recomendado é uma coleção final coerente de **236 PNGs** e **1 ícone vetorial do aplicativo**. Os 15 PNGs atuais continuam funcionando durante a transição, mas entram como referências/legado: a recomendação para a versão final é harmonizar os 5 retratos e os 10 inimigos existentes.

**Resultado final:** 236/236 PNGs integrados e verificados, sendo 228 gerações distintas e 8 aliases determinísticos, além do SVG do aplicativo. O estado linha a linha está em `ASSET-PRODUCTION-MANIFEST-001.json`.

Com oito ícones de item único reutilizando exatamente a arte da arma homônima, a produção exige **228 gerações-base**. Esse número é o piso de chamadas, não um lote único: a produção será parcelada e qualquer nova candidata só corrige um defeito objetivo.

## Matriz por família

| Família | Arquivos finais | Presentes hoje | Ação recomendada | Gerações-base | Pacote de prompt |
|---|---:|---:|---|---:|---|
| Retratos de herói | 10 | 5 | harmonizar os 10; 9 com referência local, Nyrelia pelo vault | 10 | revisar `ART-PROMPTS-002` |
| Sprites de herói na run | 10 | 0 | criar os 10 em câmera isométrica | 10 | novo `ART-PROMPTS-011` |
| Inimigos | 49 | 10 | criar 39 lacunas e remasterizar 10 legados | 49 | `003..006` + novo `011` |
| Atlas de piso | 8 | 0 | um atlas modular por camada | 8 | `007` |
| Props | 24 | 0 | três variantes por família de bioma | 24 | `007` |
| Interações | 8 | 0 | pares ativo/gasto e objetos únicos | 8 | `008` |
| Thumbnails de fase | 8 | 0 | um por `stage_id` | 8 | `007` |
| Ícones de armas/evoluções | 30 | 0 | um por ID em `weapons.json` | 30 | `009` |
| Ícones de item-base | 13 | 0 | um por base concreta, afixos sem novo ícone | 13 | `009` |
| Ícones de item único | 18 | 0 | 10 novos + 8 aliases das armas homônimas | 10 | `009` |
| Ícones de passivas | 14 | 0 | um por ID | 14 | `010` |
| Ícones de bênçãos | 12 | 0 | pares compartilham linguagem da divindade | 12 | `010` |
| Ícones de habilidade ativa | 10 | 0 | um por herói/ID de `abilities.json` | 10 | novo `ART-PROMPTS-012` |
| Ícones de regra de camada | 8 | 0 | um por `stage_id`/regra | 8 | novo `ART-PROMPTS-012` |
| Ícones de HUD | 8 | 0 | moeda, abate, CA, CAM, vida, XP, alvo e essência | 8 | `010` |
| Pickups de mapa | 3 | 0 | XP, ouro e poção | 3 | novo `ART-PROMPTS-012` |
| Fundos de tela | 3 | 0 | Quartel/menu, vitória e derrota | 3 | novo `ART-PROMPTS-013` |
| Ícone do aplicativo | 1 SVG | 1 provisório | redesenhar por vetor/código, sem ImageGen de texto | 0 | diretiva vetorial em `013` |

## IDs ainda sem prompt completo

### Habilidades ativas

`ruptura_sombria`, `guarda_de_lliira`, `comunhao`, `passo_pelas_sombras`, `sobrecarga_mistica`, `impacto_de_xargath`, `constelacao`, `dominacao`, `suspensao_temporal`, `concordia`.

### Regras de camada

`dagruve_rituals`, `shedaklah_puddles`, `molor_bubbles`, `durao_current`, `feng_tu_strikes`, `shendilavri_illusions`, `goranthis_sanctuary`, `pilares_rotation`.

### Pickups

`xp_shard`, `gold_coin`, `health_potion`.

### Telas

`quartel_background`, `victory_background`, `defeat_background`.

## Reuso lógico sem nova geração

### Itens únicos que usam a âncora da arma

`machado_de_xargath`, `martelo_da_gloria`, `lamina_da_digestao`, `chicote_avarento`, `cajado_dos_desejos`, `colar_dos_tentaculos`, `sopro_de_estrela`, `ampulheta`.

O manifesto deve apontar arma e item para o mesmo source asset ou produzir cópia determinística; não gerar duas interpretações concorrentes do mesmo objeto.

### Conquistas

Os 18 IDs de `achievements.json` recebem `icon_ref` para herói, chefe, fase, item ou ícone de sistema já aprovado. Medalhas exclusivas ficam fora do primeiro passe e só entram se o teste de UI mostrar ambiguidade.

### Upgrades permanentes

Os 12 IDs de `upgrades.json` reutilizam passivas/HUD quando houver equivalência. `mao_cheia`, `rerrolagem`, `bolso_fundo`, `ima`, `segunda_chance` e `ressonancia` devem primeiro ser resolvidos como pictogramas vetoriais/Godot; somente viram PNG gerado se a galeria demonstrar perda de leitura.

## O que não deve ser gerado por IA

- textos, números, logo tipográfico e rótulos de botão;
- barras de vida/XP, molduras, painéis, slots e NinePatch;
- flashes de dano, sombras, telegráfos, círculos de área, mira e seleção;
- anéis de fase de chefe, projéteis simples e pós-imagens;
- névoa, poças animadas, corrente do Estige, raios, ilusões e partículas;
- estados de cooldown e dessaturação.

Esses elementos são mais consistentes, escaláveis e baratos como desenho/shader/partículas no Godot. A direção deles deve ser registrada em um brief técnico, não em prompt de ImageGen.

## Cobertura dos pacotes de prompt

| Pacote | Situação |
|---|---|
| `ART-PROMPTS-001` | revisar regras de referência, caminhos e piloto ampliado |
| `ART-PROMPTS-002` | ampliar de 5 para 10 retratos harmonizados e mapear Desktop/vault |
| `ART-PROMPTS-003..006` | manter 39 lacunas; reconciliar com o manifesto e lore |
| `ART-PROMPTS-007` | manter 8 pisos, 24 props e 8 thumbnails |
| `ART-PROMPTS-008` | manter 8 interações |
| `ART-PROMPTS-009` | manter armas/itens; converter 8 duplicatas em aliases |
| `ART-PROMPTS-010` | manter passivas, bênçãos e HUD; registrar reuso em conquistas/upgrades |
| `ART-PROMPTS-011` | criar 10 sprites de herói + 10 remasters de inimigo legado |
| `ART-PROMPTS-012` | criar habilidades ativas, regras de camada e pickups |
| `ART-PROMPTS-013` | criar fundos de tela e diretiva do ícone vetorial |

## Estados do manifesto de produção

Cada linha do manifesto futuro deve usar apenas: `missing_prompt`, `prompt_ready`, `reference_review`, `approved_to_generate`, `candidate`, `qa_failed`, `approved`, `integrated`, `verified`.

Campos mínimos: `asset_id`, `family`, `consumer`, `final_path`, `candidate_path`, `prompt_id`, `vault_sources`, `visual_references`, `reference_role`, `dimensions`, `alpha`, `anchor`, `generation_status`, `selected_version`, `sha256`, `qa_notes`.
