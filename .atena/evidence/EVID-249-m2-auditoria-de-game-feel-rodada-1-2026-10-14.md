# EVID-249 — M2, auditoria de game feel, rodada 1 (2026-10-14)

Plano: PLAN-103 / B-003 / SPEC-177. Conteúdo: DRAFT. Nenhum arquivo do jogo foi alterado.

## Ferramenta
`tools/capture_game_feel.tscn` (nova): joga cada fase com kite simples por teclas, 60 s de jogo, foto a cada 3 s e em cada oferta; mede rótulos flutuantes, filhos de `Fx`, inimigos e níveis. Executável: `Godot_v4.7.2-stable_win64.exe --path . res://tools/capture_game_feel.tscn --resolution 1280x720`.

## Resultado (semente 12345, um herói por fase)
| Fase | Herói | Tempo | Nível | Rótulos (pico) | Inimigos (pico) |
|---|---|---|---|---|---|
| dagruve | durvall | 42,5 s | 2 | 51 | 51 |
| docas | brook | 34,7 s | 1 | 12 | 39 |
| shedaklah | maelor | 15,2 s | 1 | 6 | 24 |
| molor | sylas | 29,0 s | 1 | 9 | 29 |
| durao | kayron | 41,2 s | 1 | 50 | 37 |
| feng_tu | korrak | 24,2 s | 1 | 5 | 41 |
| shendilavri | leoric | 18,9 s | 1 | 6 | 25 |
| goranthis | nyrelia | 16,2 s | 1 | 1 | 35 |
| pilares | zynara | 6,2 s | 1 | 1 | 14 |

Todas terminaram em `revive_offer`: o kite da ferramenta é fraco; vale como amostra do começo da run, não como curva de dificuldade.

## Diagnóstico do pico de rótulos
Sonda em dagruve (40 s): no pico, 43 de 44 rótulos eram "-0" (um "-1"). Origem: `core/battle.gd` `_update_edge_fog` (névoa de borda, `bypass_generic_defenses`) chama `_hurt_hero(max_hp * pct * dt)` todo quadro; o dano por quadro é < 1 e `int()` zera; `ui/run.gd` trata cada evento `hurt` com rótulo, som e tremor. Contadores terminam em 1 (sem vazamento).

## Capturas
`.atena/generated/m2-game-feel/auditoria-v01/` (77 PNG, `resumo.json`, `log.txt`). Sonda: `.atena/generated/m2-game-feel/sonda/`.

## Pendente
Humano: sentir o tremor e o som contínuos na borda do mapa (Dagruve) e dizer se incomoda. Subjetivo, não verificado.

## R2 — correções F-1 e F-2 (aprovadas pelo dono em 2026-10-14, gate G-M2-1)
- `core/battle.gd`: `_emit_continuous_hurt` acumula o dano das fontes `mare_nevoa` e `borda_nevoa`; emite um `hurt` com `continuous: true` e o inteiro acumulado no máximo a cada 0,5 s; fração fica guardada (nunca "-0"); descarrega ao morrer. Dano pontual (golpe, armadilha, pacto) segue imediato.
- `ui/run.gd`: `hurt` contínuo não toca `player.hurt` nem treme a tela; `_float_text` ganhou `counted_as_hit`: acertos seguem no limite de 14, os demais textos (dano recebido, status, cura, loot) têm limite próprio de 8 e descartam o excedente.
- Teste novo `tests/test_continuous_hurt.gd`: 3 s de névoa emitem de 1 a 6 avisos, a soma acompanha a vida perdida, fração < 1 não emite, pontual continua imediato, morte descarrega, limite auxiliar.
- Verificação: suíte 0 falhas; smoke das 9 fases ok; sonda Dagruve 40 s, mesma semente: pico de rótulos 44 a 51 → **6** (`.atena/generated/m2-game-feel/sonda-r2/`).
- Pendente humano: sentir a borda de Dagruve (som/tremor mais discretos) — subjetivo, não verificado.

## R3 — conferência de VFX das habilidades e cobertura de SFX/VFX (2026-10-14)
Ferramentas novas: `tools/capture_ability_vfx.tscn` (dispara a habilidade de cada herói numa run real com 3 zumbis à frente e fotografa em 0,18 s) e `tools/audit_sfx_coverage.tscn` (cobertura por conteúdo; relatório em `.atena/generated/m2-game-feel/sfx-vfx-cobertura.md`). Capturas: `.atena/generated/m2-game-feel/habilidades-v01/` (12 PNG + `resumo.json`).

**Habilidades:** as 12 disparam em run real. 10 usam a arte DRAFT admitida (ex.: Comunhão e Ruptura Sombria conferidas visualmente: anel dourado e arco prateado legíveis, sem poluição). Erik (Navios em Chamas) e Arlindo (Modify Memory) caem no desenho procedural (anéis).

**SFX (manifesto, 280 eventos):** todo herói, arma, inimigo e chefe tem evento próprio, mas há reaproveitamento de arquivo:
- Erik usa os arquivos da habilidade de Korrak e Arlindo os de Sylas (`hero.erik.active`, `hero.arlindo.active`).
- Sete a oito objetos quebráveis reusam `combat.impact` (ação) e `world.chest` (morte).
- `world.camara` (Câmara Selada) não tem evento: silêncio; `world.arcanista` é alias de `world.altar`.
- Armas diferentes dividem arquivo: bola_de_fogo/descarga_estelar, tocha_do_incendiario/espada_sombria, martelo_da_luz/martelo_da_gloria etc. (evoluções da mesma família dividem de propósito).

**VFX por arma:** corpo a corpo 9 com arte / 8 procedurais; projétil 8 / 5; nova 7 / 3; zona 0 / 3. A maioria dos procedurais são evoluções de armas que já têm arte (maca_demolidora, raio_da_ruina, dominio_da_vontade, memoria_alterada, dominio_coletivo, lamina_de_sombra…).

**Texto:** o nome da habilidade de Arlindo aparece em inglês ("Modify Memory"), enquanto a arma é "Memória Alterada". O Vault grafa *Modify Memory* em itálico (nome de magia); decisão do dono.

## R4 — correções F-6, F-7 e F-9 (aprovadas pelo dono em 2026-10-14, gate G-M2-2; F-4 e F-5 recusadas)
- **F-7 (VFX, só código, arte já aceita):** `core/melee_vfx.gd` (`romper_armadura` → corte_medio; `maca_demolidora` e `esmagar_defesas` → arco_largo), `core/projectile_vfx.gd` (`raio_da_ruina` e `dominio_coletivo` → orbe_arcano), `core/radiant_pulse_vfx.gd` (`constelacao_de_silva` → pulso radiante). `tests/test_projectile_and_ability_vfx.gd` atualizado com as duas evoluções. **Ficam fora de propósito:** `lamina_de_sombra`, `dominio_da_vontade` e `memoria_alterada` (armas avulsas excluídas pelo contrato ART-PROMPTS-053, testado), as melee radiantes/de fogo (`golpe_do_juizo`, `martelo_da_gloria`, `martelo_da_luz`, `machado_de_xargath`, `tocha_do_incendiario`, o kit é só físico) e `bola_de_fogo`/`tormenta_de_fogo` e as zonas (pedem arte nova, M5).
- **F-6 (SFX, sem arquivo novo):** `core/sfx.gd` lê o campo opcional `pitch` do evento; `data/audio_manifest.json` ganhou tom próprio em 8 armas que dividiam arquivo com outra família: bola_de_fogo e tormenta_de_fogo 0,84; tocha_do_incendiario 0,88; lamina_de_sombra 0,85; dominio_da_vontade 0,88; memoria_alterada 1,10; romper_armadura e esmagar_defesas 1,12. Evoluções da mesma família seguem dividindo.
- **F-9:** `data/abilities.json`: a habilidade de Arlindo passa a se chamar "Memória Alterada" (id `modify_memory` intacto).
- **Testes:** `tests/test_vfx_sfx_coverage.gd` novo; suíte 0 falhas; smoke das 9 fases ok.
- **Conferência visual:** `tools/capture_weapon_vfx.tscn`, esquerda procedural (antes) e direita arte (depois), em `.atena/generated/m2-game-feel/armas-vfx-v01/` (6 PNG). Verifiquei Maça Demolidora, Raio da Ruína e Constelação de Silva: a arte aparece e é legível. Julgamento de estilo e escala é seu.
- **Nota:** `node tools/validate_audio.js` lista eventos ausentes `boss.discipulo_pestilento.*` (arrival, phase, defeat). Não vem desta mudança; o jogo cai no som genérico de chefe. Fica como achado F-10.
