---
id: "SPEC-177"
title: "Game feel e apresentação: marco M2 da demo (PLAN-103)"
status: "DRAFT r2 em 2026-10-14: R1 a R4 (F-1, F-2, F-6, F-7, F-9) feitas; resta conferência visual do dono e R5 (estética sem imagem)"
origin: planned
implementation_preceded_spec: false
request_classification: IN_PLAN
created: "2026-10-14"
revision: "r1 (2026-10-14)"
relations: ["[[PLAN-103-demo-completa-e-polida-2026-10-14]]", "[[SPEC-116-dopamina-tematica]]", "[[EVID-249-m2-auditoria-de-game-feel-rodada-1-2026-10-14]]"]
cards: ["MEC-031", "MEC-003", "ART-007", "ART-028", "ART-029", "ART-030"]
content_state: DRAFT
---

# SPEC-177 — Game feel e apresentação (M2)

Origem: PLAN-103, lote B-003, aprovado pelo dono em 2026-10-14 enquanto o B-002 espera imagens. Sem geração de imagem: usa só arte já aceita.

## Rodadas

| Rodada | Conteúdo | Estado |
|---|---|---|
| R1 | Auditoria: uma run por fase com `tools/capture_game_feel.tscn`, medindo números flutuantes, efeitos e estado; nada do jogo é alterado | **feita** (EVID-249) |
| R2 | Correções F-1 e F-2 aprovadas no gate G-M2-1 | **feita** (EVID-249; suíte 0 falhas, smoke ok, pico de rótulos 51 → 6) |
| R3 | Conferência dos VFX DRAFT já admitidos (habilidades) e inventário de SFX emprestado na camada A | **feita** (achados F-4 a F-9; gate G-M2-2) |
| R4 | Correções F-6, F-7 e F-9 aprovadas no gate G-M2-2 | **feita** (EVID-249; F-4 e F-5 recusadas pelo dono) |
| R5 | Lotes 2 e 3 da estética (HUD, brilho, partículas) que não dependem de imagem | a propor |

## Achados da R1

| # | Achado | Gravidade | Proposta |
|---|---|---|---|
| F-1 | **Dano contínuo da névoa emite um evento `hurt` por quadro** (`_update_edge_fog` e a Maré pós-chefe chamam `_hurt_hero` todo `step`). Em `ui/run.gd` cada evento cria o rótulo "-0", toca `player.hurt` e arma `_shake = 0.6`. Medido: 44 a 51 rótulos simultâneos na tela (limite visual dos acertos é 14), todos "-0" | **P1 de game feel** | Acumular o dano contínuo e emitir um único `hurt` a cada 0,5 s com o total inteiro; sem som de golpe nem tremor para dano contínuo; sem rótulo quando o total é 0 |
| F-2 | O contador `_numbers` (limite 14) só protege os acertos; `hurt`, `text`, cura e nome de loot ignoram o limite | baixo | Limite único por categoria, ou rótulo de dano contínuo como parte do F-1 |
| F-3 | A auditoria por bot simples morreu nas nove fases em 6 a 42 s; só mede o começo da run | limitação da ferramenta | Não é achado de jogo (o bot de balanceamento chega às fases finais). Para a R3 usar `qa_launch` com nível e armas preparados |

## Fora de escopo da R1

Mudar números de balanceamento, arte nova, trocar sons. O botão ART-047 e a moldura do HUD que pedem imagem ficam para o M5.

## Verificação prevista (R2)

Teste automatizado: dano contínuo de névoa por 3 s emite no máximo 6 eventos `hurt` e o total confere com `hero.hp` perdido; suíte, smoke de nove fases e nova captura do mesmo cenário.

## Achados da R3 (EVID-249, seção R3)

| # | Achado | Tipo | Proposta |
|---|---|---|---|
| F-4 | Erik e Arlindo tocam os arquivos de som da habilidade de Korrak e Sylas | SFX emprestado, camada A | Som novo (Ludo.ai aprovado) ou variação por tom/filtro como piso mínimo |
| F-5 | Quebráveis reusam `combat.impact` e `world.chest`; `world.camara` sem som; `world.arcanista` é alias do altar | SFX emprestado / silêncio | Som novo para Câmara Selada (prioridade); quebráveis podem ficar como "provisório aceito" |
| F-6 | Armas distintas dividem arquivo (bola de fogo ↔ descarga estelar etc.) | SFX | Camada B/C; diferenciar por tom no manifesto (sem arquivo novo) |
| F-7 | 8 corpo a corpo, 5 projéteis e 3 novas sem arte própria, quase todas evoluções de armas que têm arte | VFX, só código | Estender as famílias existentes às evoluções (`MeleeVfx.WEAPON_SHAPES`, `ProjectileVfx.FAMILIES`, `RadiantPulseVfx.WEAPONS`), com conferência visual sua antes de fechar |
| F-8 | Habilidades de Erik e Arlindo sem arte própria (anéis procedurais) | VFX, precisa imagem | M5 (ART-030 cobre 10 heróis) |
| F-9 | "Modify Memory" (habilidade) vs "Memória Alterada" (arma) | texto | Decisão do dono: manter o nome do Vault em inglês ou traduzir |

Verificado: as 12 habilidades disparam em run real; 10 mostram a arte DRAFT admitida e legível.

## Decisões do gate G-M2-2 (2026-10-14)
F-7 e F-6 aprovadas; F-9 aprovada (nome em português); F-4 e F-5 **recusadas** (sem prompts de SFX por ora). Novo achado F-10: `validate_audio.js` aponta os eventos `boss.discipulo_pestilento.*` ausentes (cai no som genérico).

## R5 (G-M2-3, 2026-10-15)
Opções A (vinheta de vida baixa) e B (números legíveis) feitas e commitadas por outra sessão (EVID-257). Opção E feita e amostras de C e D geradas para Dagruve, Molor e Durao (EVID-261). Achados F-11 (textos de aviso e de introdução sem contraste) e F-12 (HUD atrás da pausa translúcida); correções aguardam o gate G-M2-4.

## R5 gate G-M2-4 (2026-10-15): F-11, F-12, F-13 e Atmosfera (C+D) implementados
F-11 e F-12 aprovados; C e D entram juntos (opção "Atmosfera", padrão Leve). F-13 (contorno do relógio, fase, armas e chefe em piso claro) saiu da conferência e entrou no mesmo lote por ser a mesma classe de problema. Evidência: EVID-261. Pendente humano: aceite visual dos 9 perfis e medição em máquina fraca.
