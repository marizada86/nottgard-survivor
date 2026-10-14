# EVID-243 — Evoluções do lote 1 e atributo mínimo para evoluir (2026-10-13)

**Origem:** dono, "aprovo o plano com 5 evoluções" (2026-10-13), sobre o rascunho de evoluções das armas sem evolução (DEV-041).
**Plano:** PLAN-101 / SPEC-174; modo **por plano**; conteúdo DRAFT; mínimo de atributo 16 em todas (Martelo em Constituição); nomes Constelação de Silva e Martelo da Luz.
**Estado medido:** HEAD `25c75a4` + árvore de trabalho (depois commitada: código em `563c07b`, documentos no commit seguinte); Godot 4.7.2.

## 1. Entregue (local)
| Peça | O que faz |
|---|---|
| `data/weapons.json` | 5 evoluções (`src: "Evolução"`, `levels: []`, `icon_like` da base) e 5 blocos `evolve` com `min_attr` nas bases |
| `data/audio_manifest.json` | 5 eventos `weapon.<id>.fire` (clone do som da base, como o ART-042) |
| `core/weapon.gd` | `evolve_min_attr()` e `missing_attrs(hero)`; `ATTR_FULL` |
| `core/battle.gd` | A evolução só é oferecida com nível 5 **e** passiva **e** atributo efetivo ≥ mínimo; `evolve_hint` lista o atributo que falta ("Constituição 16 (agora 14)") |
| `ui/character_sheet.gd` | O selo "▲ pronta para evoluir" e o brilho do slot respeitam o atributo mínimo |
| `tools/audit_projeto.gd`, `tests/test_data.gd` | Validam `min_attr` (atributo conhecido, faixa 8 a 30) |
| `tests/test_new_content.gd` | Testes do lote (dados, som, ícone, oferta presente/ausente por condição, passiva de atributo abre a evolução, regressão das 10 antigas) |
| `tests/test_arcanist.gd`, `tests/test_playtest_fixes.gd` | Contagens atualizadas (2 armas de corpo a corpo novas; 15 armas que evoluem; controle de base de item; arma sem evolução da ficha) |
| `tools/bal_conteudo_novo.gd` | Régua inclui as 5 evoluções e referências |

As 10 evoluções anteriores não têm `min_attr` e se comportam como antes (teste de regressão). Nenhuma evolução nova tem `heal` ou `lifesteal`. Sem arte, sem mudança de versão.

## 2. As cinco evoluções (estado final dos dados)
| Base | Evolução | Passiva | Mínimo | Parâmetros |
|---|---|---|---|---|
| Dominar Pessoa | Domínio Coletivo | Sabedoria | Carisma 16 | 2d8 cd 2,6 count 3 pierce 1 stun 3 |
| Golpe Esmagador | Maça Demolidora | Pele de Pedra | Força 16 | 3d10 cd 1,3 alc. 2,2 cone 80 stun 1,5 |
| Martelo da Glória | Martelo da Luz | Cota de Malha | Constituição 16 | 4d10 cd 1,8 alc. 2,3 cone 130 knock 2,0 stun 1 |
| Raio Enfraquecedor | Raio da Ruína | Robe Arcano | Inteligência 16 | 2d6 cd 1,2 count 3 pierce 2 weaken 4 |
| Sopro de Estrela | Constelação de Silva | Sabedoria | Carisma 16 | 5d8 cd 4,6 r 4,8 slow 3 weaken 2 |

## 3. Verificação
| Verificação | Resultado |
|---|---|
| `tests/run_all.gd` | **0 falhas** (a 1ª rodada achou 7 falhas de contagem em testes antigos, corrigidas) |
| Mutação: remover a condição de atributo da oferta | **6 falhas** nos testes novos; restaurado, suíte volta a 0 |
| `tools/smoke.tscn` | 9 fases ok |
| `tools/audit_projeto.gd` | 0 erros; 7 avisos antigos de `boss_presentations` (não ligados a esta mudança) |
| `tools/backlog_check.ps1` | P0=0, P1 abertos=4, P1 implementados aguardando playtest=16, verificações manuais=0; 1 alerta antigo (ART-045 duplicado) |
| `tools/bal_conteudo_novo.gd` | ST das evoluções novas: 12,7 / 14,2 / 13,3 / 22,5 / 5,3, abaixo de Tempestade (44,3) e Luz Mais Pura (34,1) |

### Duelo no motor (`.atena/generated/evolucoes-armas-2026-10-13/duelo.gd`)
Herói parado e imortal, 45 s de jogo, 6 sementes por linha; "alvo" = 1 boneco de 1e6 PV; "horda" = 30 bonecos num raio de 2 a 7. Dano por segundo, base no nível 5 contra a evolução:

| Evolução (herói) | Alvo: base → evolução | Horda: base → evolução |
|---|---|---|
| Domínio Coletivo (Nyrelia) | 5,9 → 11,4 (1,9×) | 6,0 → 22,3 (3,7×) |
| Maça Demolidora (Durvall) | 6,5 → 13,6 (2,1×) | 54,0 → 200,4 (3,7×) |
| Martelo da Luz (Bromnor) | 7,3 → 10,8 (1,5×) | 133,9 → 224,0 (1,7×) |
| Raio da Ruína (Sylas) | 17,2 → 31,4 (1,8×) | 17,7 → 92,2 (5,2×) |
| Constelação de Silva (Leoric) | 2,3 → 4,7 (2,1×) | 71,8 → 140,6 (2,0×) |

Referência, as evoluções que já existem (alvo / horda): Espada do Receptáculo 13,7 / 233,7; Esmagar Defesas 13,6 / 193,0; Golpe do Juízo 4,5 / 96,2; Rajada de Golpes 18,9 / 174,8; Luz Mais Pura 30,4 / 207,0; Chuva de Estrelas 6,6 / 196,4; Tormenta de Fogo 7,1 / 194,8; Julgamento da Glória 4,5 / 142,7; Tempestade 55,6 / 339,6; Inferno de Cera 47,8 / 1403,2.

Leitura: nenhuma evolução nova passa a faixa das existentes. Dois pontos para o playtest vigiar: **Raio da Ruína** tem o maior ST do lote (31,4, um pouco acima da Luz Mais Pura) e o maior salto na horda (5,2×); **Domínio Coletivo** fica fraco na horda (22,3): é arma de controle e nenhuma evolução existente fica tão baixa lá (a menor é o Golpe do Juízo, 96,2). A régua analítica subestimou o corpo a corpo na horda (Maça: previa 2,0×, motor deu 3,7×): inimigos se amontoam em volta do herói, mais do que a densidade 0,2 assumida.

### Bot (alarme)
`tools/bot_curva.gd`, meta 1, 2 sementes, 2 fases, Nyrelia, Sylas, Bromnor e Leoric: 11 linhas, 5 passaram a fase, 6 morreram, sem erro de execução. **Não é medida das evoluções:** o bot sai das fases entre os níveis 3 e 14 e não chega com arma no nível 5 + passiva + atributo 16, então não exerceu nenhuma evolução nova. Serve só para dizer que o resto do jogo não quebrou.

## 4. Limites e pendências
- **Playtest humano pendente** (sensação, dificuldade, se o mínimo 16 limita demais ou de menos). Nenhuma métrica aqui prova que ficou divertido ou equilibrado.
- Evoluções de Ampulheta, Vela Sagrada, Machado, Arlindo, Erik e Lâmina de Sombra ficam para depois do playtest.
- Ícones e sons próprios (arte) pendentes; hoje `icon_like` e som clonado da base.
- Chefe limita atordoamento a 0,6 s (`core/battle.gd:869-872`): Domínio Coletivo, Maça Demolidora e Martelo da Luz continuam limitados contra chefe. Decisão própria do dono.
- **Nome:** Leoric já tem a habilidade ativa **Constelação** (`data/abilities.json`, id `constelacao`); a arma "Constelação de Silva" tem id próprio (`constelacao_de_silva`), mas o nome pode confundir na lista. Nome batizado pelo dono; fica o aviso.
- A suíte regrava `.atena/generated/controller-experience/v01/unit-profile.json` (e `.bak`), como já acontecia; fora do escopo e sem relação com a mudança.
- Commits locais (código `563c07b` e documentos); sem push, build ou exportação.
