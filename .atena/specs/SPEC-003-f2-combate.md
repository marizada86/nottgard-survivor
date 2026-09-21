# SPEC-003 — F2: combate (Durvall)

Status: aprovada (2026-09-21).

## Escopo
- Dados em JSON (`data/enemies.json`, `data/heroes.json`) com stats do Nottcard (Zumbi, Cultista, Slime corrosivo; Durvall FOR16 INT14 CON12 CAR10, Cota de malha CA3/CAM-1).
- `Battle` (simulação pura, sem nós, RNG por seed): herói, inimigos, tempo, eventos para a UI.
- Auto-ataque lento (cd 1,2 s): d20 + bônus vs CA do alvo; 20 natural = crítico (dano dobrado), 1 natural = erro; dano 1d8 + mod FOR.
- **Dois modos (Tab alterna)**: AUTO (bate no inimigo mais próximo ao alcance) e MOUSE (golpe em cone na direção do mouse, atinge todos no cone).
- 1 habilidade ativa (Q ou botão direito): **Romper Armadura** (carta do Nottcard): 1d6 + mod, CA do alvo −2; cd 6 s.
- Inimigos perseguem e atacam corpo a corpo (d20 + bônus vs CA do herói, cd 1 s); herói morre a 0 PV; R reinicia; F spawna inimigos (teste).
- HUD mínimo (PV, modo, cooldowns), números de dano discretos, barra de vida nos inimigos.

## Critérios de aceite
1. Testes headless determinísticos: acerto/erro por CA, crítico, habilidade reduz CA, cone do modo MOUSE, inimigo mata herói parado, XP ao matar.
2. `run_all` 0 falhas; cena roda sem erro; screenshot com combate.
3. Playtest manual do dono.
