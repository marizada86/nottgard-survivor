# PLAN-001 — Nottgard Survivors (título de trabalho)

Status: **CANON — aprovado pelo dono em 2026-09-21** (aprovou todas as recomendações).
Data: 2026-09-21

## 1. Visão

Survivor-like **lento, legível e denso em conteúdo**, com visual sombrio e isométrico à la *Diablo II* / *Halls of Torment*, ambientado em Nottgard e centrado no **Plano Abissal**. **Sem história**: a lore entra só como sabor (nomes, descrições, bestiário, itens), nunca como narrativa ou spoiler.

Pilares:
1. **Ritmo Halls of Torment / Death Must Die** — dezenas de inimigos, não centenas; golpes com peso, telégrafos claros, elites e chefes que pedem posicionamento.
2. **Pouca poluição visual** — poucos efeitos por vez, números de dano discretos, paleta escura, névoa/vinheta. Legibilidade acima de espetáculo.
3. **Nottgard como banco de conteúdo** — personagens, cartas, equipamentos, inimigos, itens e locais vêm do Nottcard e do vault.
4. **Abismo como estrutura** — cada camada do Abismo é um bioma com regras próprias.
5. **Jogável cedo** — primeiro playtest antes de qualquer expansão de conteúdo.
6. **Laboratório de IA** — registrar (em `evidence/`) o que a IA fez bem/mal: geração de conteúdo, balanceamento por simulação, código.

## 2. Decisões já tomadas (respostas do dono, 2026-09-21)

| Tema | Decisão |
|---|---|
| Controle | **Alternável em opções**: (a) auto-ataque + mira no mouse; (b) auto-ataque total. Habilidades ativas em ambos. |
| Arte | **Placeholder + reaproveitar assets do Nottcard**; arte final entra por troca de `asset_id`, sem mexer em código. |
| Perspectiva | **Isométrico estilo Diablo II** já na fase 1. |
| Engine | Godot 4.7.2, GL Compatibility, GDScript (mesma do Nottcard). |

### Consequência técnica do isométrico (decisão de arquitetura)
Simular tudo em um **plano de chão plano** (x, y, top-down) e só **projetar para a tela** (2:1: `sx = (x − y)·w/2`, `sy = (x + y)·h/2`). Movimento, colisão, alcance, hitbox e mira ficam simples; o isométrico é só camada de render (Y-sort por profundidade, sombras, oclusão de props). Mira com mouse: inverter a projeção. Isso evita o custo clássico de colisão isométrica.

## 3. Regras herdadas do Nottcard (mapeamento)

Fonte: `games/godot/nottcard/data/core/*.json`, `core/*.gd`, vault. **Lore/fatos moram no vault**; este jogo guarda só decisões de mecânica em `.atena/vault/canon/`.

| Nottcard | Nottgard Survivors |
|---|---|
| 4 cores/atributos: Vermelho=Força, Amarelo=Inteligência, Azul=Constituição, Roxo=Carisma | 4 stats de build. Força→dano físico; Inteligência→dano/área mágica e cooldown; Constituição→PV/regeneração; Carisma→sorte, moedas, alcance de coleta |
| CA / CAM | **Armadura** (físico) e **Resistência mística** (mágico); armaduras já têm CA/CAM (Couro 1/0, Cota 3/−1, Placa 5/−3, Robe 0/2) |
| Cartas (ataque, reação, enfraquecer, localizar, atordoamento, cura, comunhão) | **Habilidades**. `enfraquecer` = debuff de armadura/CAM; `localizar` = marca (+dano); `atordoamento` = stun; `reação` = habilidade defensiva com gatilho; `cura` = "uso único" viram poções/relíquias |
| Poder Místico, Guarda, Corrente | Recursos de classe (Kayron: Poder; Brook: Guarda; Corrente = combo de acertos) |
| d20, crítico natural, falha crítica, Sorte | Chance de crítico/falha (pequena, em cascata), "usos de Sorte" = rerrolls de level-up |
| Armas (adaga, espada, maça, cajado, cetro) + armaduras | Slot de arma e armadura com identidade de golpe (ex.: adaga = rápida; maça = pode atordoar; cetro = marca) |
| XP, moedas, derrota mantém 50% do XP | Idem: moedas por run, meia recompensa ao morrer |
| Upgrades (Força Bruta +4%, Vitalidade +2 PV, Mão Cheia, Rerrolagem, Sorte, Bolso Fundo, Ganância) | **Loja permanente do menu**, com os mesmos custos/curvas como ponto de partida |
| Conquistas com benefício (Dois Veteranos, Sorte de Sendrinah, O infeliz…) | Conquistas que **destravam bônus/personagens/itens** |
| HQ / QG | **Quartel** (hub em menu): loja, personagens, conquistas, códex |
| Eventos/salas aleatórias | Interações aleatórias no mapa (seção 6) |

## 4. Personagens

Jogáveis iniciais (atributos do Nottcard): **Durvall** (FOR16 INT14), **Brook França** (CON16 CAR14, paladino), **Maelor** (CON16, devoto de Sendrinah, cura/localizar), **Sylas Malafaia** (INT16, devoto de Mask, controle/enfraquecer), **Kayron** (CAR14, aasimar, Poder Místico/radiante).
Desbloqueáveis por conquista: **Korrak** (Machado de Xar'gath), **Leoric** (Modo de Constelação), e depois NPCs de apoio como "heróis alternativos" (ex.: Nyrelia, Zynara, Bromnor) — a definir com o dono.
Cada herói tem: arma inicial, 1 habilidade de classe (as `class_ability` das cartas existentes), stats base, passiva.

## 5. Inimigos e chefes

**Já existem no Nottcard (com stats):** Cultista (adaga/cajado/arqueiro), Zumbi/Notívago, Slime corrosivo, Mímico, Criatura corrompida pela névoa, Guardião alado (cópia/verdadeiro), Sacerdote da Mente Derretida (invoca zumbis).
**Do vault, para criar:** Gárgulas da Biblioteca Corrompida, Arch-hag e tentáculos de Kraken (Docas), Molydeus (carcereiros de Durao), Reaper do Estige, Blogbog, Death Tyrant, Master of Cruelties, Shu, Ezro, Receptáculo de Juiblex, súcubos/ilusões de Rivenheart, fungos de Zuggtmoy, cultistas de Ghaunadaur.
**Chefe final / modo infinito:** **A Síntese Abissal** (resistência a físico/psíquico, só radiante fura → *diversidade de build obrigatória*).

Arquétipos de comportamento (poucos, bem distintos): perseguidor, atirador, investida telegrafada, invocador, área persistente, agarrador, kamikaze/slime que divide, elite com afixos.

## 6. Mapa e interações aleatórias

Mapa procedural por chunks dentro de um bioma; **inimigos por ondas pré-definidas** (tabela por minuto) + elites em pontos fixos do tempo.
Interações aleatórias: baú (ou **Mímico**), altar de divindade (bênção com custo — Sendrinah, Mask, Lliira, Shar, Ghaunadaur), poço/fonte, ritual de cultistas (elite + recompensa), **portal** (exige essência da camada → puxa para a camada seguinte), Rio Estige (corrente de almas: risco/recompensa), mercador raro, "Baralho de Muitas Coisas" (evento aleatório de alto impacto).

## 7. Camadas do Abismo = biomas/fases

Progressão de fases (todas do vault, "Camadas do Plano Abissal"):
0. **Dagruve / Docas** (plano material) — tutorial/fase 1 do MVP: cultistas, zumbis, slimes, Arch-hag/Kraken.
1. **Shedaklah** — fungo (Zuggtmoy) × slime (Juiblex).
2. **Molor** — caverna de bolhas de slime; chefe **Blogbog**.
3. **Durao** — deserto árido, rio de almas, jaula; **Molydeus**.
4. **Feng-tu** — estética oriental (Tou Um, Lu Yueh).
5. **Shendilavri / Rivenheart** — súcubos, ilusões; Castelo Argento (Graz'zt).
6. **Goranthis** — "o verdadeiro Paraíso", cachoeira, ilusão; palco final.
7. **Pilares / Síntese Abissal** — endgame e modo infinito.

Cada camada: paleta, inimigos, regra ambiental própria (ex.: slime deixa poça; ilusão revela falsos inimigos; rio de almas empurra), 1 chefe, 1 tipo de essência.

## 8. Loop de run e progressão

- **Run**: 12–15 min por camada (MVP: 1 camada); level-up com **escolha de 3** (arma/habilidade, passiva, evolução); **evoluções** de arma combinando item + passiva (à Vampire Survivors; conecta com "Corrente" do Nottcard); chefe no fim.
- **Ritmo lento**: cooldowns longos, ataques com anticipation, teto de inimigos vivos baixo, sem chuva de projéteis.
- **Menu / meta**: loja (upgrades permanentes), seleção de herói, conquistas, códex (bestiário/itens desbloqueados — só sabor, sem spoilers), dificuldade/“Maldição” opcional.
- **Itens**: equipamento com raridade e afixos estilo Diablo II (mágico/raro/único). Únicos vêm do vault: Machado de Xar'gath, Martelo da Glória, Lâmina da Digestão, Chicote Avarento, Cajado dos Desejos Sussurrantes, Olho de Ghaunadaur, Colar dos Tentáculos, Anéis de Graz'zt, Manto do Pântano, Anel da Passagem Sombria, Sopro de Estrela, Ampulheta do Silêncio Eterno, Lasca de Ailalore, Luneta de Korrak, Broche Celestial, Amuleto da Luz etc. (vault `06_Itens`, filtrando o que for "canônico").

## 9. Referências de mecânicas a copiar

- **Halls of Torment**: auto-ataque, upgrades curtos por habilidade, campeões/elites, hub de progressão, ritmo lento, visual sombrio.
- **Death Must Die**: chefes de peso, bênçãos de divindades (→ nossos altares), builds com sinergia, telegrafia.
- **Vampire Survivors**: evoluções, passivas, baús, "maldição" de dificuldade.
- **Diablo II**: raridades/afixos, resistências por tipo, atmosfera, poções.

## 10. Arquitetura técnica

- Godot 4.7.2 (mesmo do Nottcard), estrutura `core/ ui/ data/ tests/ tools/ assets/`.
- **Data-driven**: heróis, inimigos, ondas, itens, habilidades, conquistas em JSON/Resource; conteúdo novo = dado novo.
- **Inimigos sem `RigidBody`**: movimento próprio + separação por spatial hash, pooling; meta de 300 entidades a 60 fps (mesmo com design para ~80 simultâneos).
- Simulação **determinística por seed** (RNG próprio), habilitando testes headless e **bots de balanceamento**.
- `asset_id` como ponte de arte (placeholder → definitivo).
- Save em JSON (perfil, upgrades, conquistas, códex).
- Testes: runner headless como `nottcard/tests/run_all.gd`; portão de aceite por spec.

## 11. Fases e specs (proposta)

| Fase | Entrega | Critério de aceite | Marco |
|---|---|---|---|
| F0 | Bootstrap Godot + estrutura + runner de teste | import headless ok, 0 falhas | — |
| F1 | Mundo isométrico (projeção, câmera, Y-sort), herói move (WASD), mapa tilado placeholder | anda por um chão isométrico a 60 fps | — |
| F2 | Combate: auto-ataque, 2 modos de mira, 1 habilidade ativa, dano/CA/CAM | Durvall mata inimigos parados/andando | — |
| F3 | Inimigos + ondas + XP + level-up (escolha de 3) | run de 5 min completável | **PLAYTEST 0** |
| F4 | Itens/equipamento, baús, interações aleatórias, poções | drop e equipar funcionando | — |
| F5 | Menu: loja permanente, seleção de herói, conquistas, save | progressão persiste entre runs | — |
| F6 | Fase 1 completa (Dagruve/Docas) + 1 chefe + 5 heróis | run de 12–15 min do início ao chefe | **PLAYTEST 1 (MVP)** |
| F7 | Camadas do Abismo 1–3, portais/essências, mais inimigos/itens/conquistas | 4 fases jogáveis | Playtest 2 |
| F8 | Camadas 4–6, Síntese Abissal, modo infinito, evoluções completas | jogo fechado | Playtest 3 |
| F9 | Polimento: áudio, VFX contidos, arte definitiva, balanceamento por bot | build exportável | — |

Cada fase vira uma `SPEC-00N` aprovada antes de implementar; evidências em `.atena/evidence/`.

## 12. Uso da IA como teste (registrar em evidence)

- Geração em lote de conteúdo **a partir do vault** (inimigos, itens, descrições) como draft → revisão do dono → canon.
- Bot de simulação headless para balancear ondas/dano (curva de morte por minuto).
- Agentes paralelos por área (dados, UI, testes), com relatório de acertos/erros.
- Geração de sprites/arte: pós-MVP, pipeline separado.

## 13. Riscos

| Risco | Mitigação |
|---|---|
| Arte isométrica não existe (assets do Nottcard são retratos/cenas, não sprites de 8 direções) | Placeholder por formas/sprites simples; `asset_id`; arte na F9 |
| Escopo de conteúdo explode | Data-driven + gate por fase; MVP só 1 camada |
| Isométrico complica mira/colisão | Simular no plano, projetar só no render |
| Balanceamento lento sem dados | Bot headless por seed |
| Spoiler/lore incerta | Só itens/locais com status canônico; sem narrativa |

## 14. Decisões finais (2026-09-21)

1. Nome: **Nottgard Survivors**.
2. Godot 4.7.2: extrair de `Downloads/Godot_v4.7.2-stable_win64.exe.zip`.
3. `git init` aprovado; **commits seguem exigindo aprovação explícita** (`add.yaml`).
4. **NPCs entram como heróis jogáveis** desbloqueáveis (Nyrelia, Zynara, Bromnor e outros), além de Korrak e Leoric. Lista final definida por conquista ao longo das fases F5–F8.
5. O vault é fonte para extração de conteúdo (sempre como draft → revisão → canon).

## 15. Mecânicas de aprofundamento aprovadas (2026-09-22)

O dono aprovou a implementação integral das recomendações de game design registradas nas SPEC-012 a SPEC-014:

1. habilidade ativa própria para cada herói;
2. level-up estruturado entre sinergia, defesa e nova direção;
3. escolha explícita entre extrair e descer, com risco e recompensa crescentes;
4. uma regra principal e legível por camada;
5. chefes com transições de fase em 70% e 35% de vida;
6. altares com consequências jogáveis além de modificadores numéricos;
7. itens únicos capazes de alterar comportamento, usando eventos limitados e sem recursão.

Implementação verificada em 2026-09-22 pelos testes automatizados, smoke das oito fases e bot determinístico. Evidência: `EVID-007-mecanicas-game-design.md`.
