# EVID-142 — Varredura do bot: 10 heróis em Dagruve e Docas (mapas de 5 min)

Data: 2026-10-01 · build após BAL-011 (duração 300 s, chefe aos 5:00) e MEC-029/030/033/034/035
Execução: `tools/overnight.ps1` (123 min) · 30 sementes por herói e fase · bot `tools/bot.gd`, dt 0,05, até 3 fases
Dados: `.atena/generated/overnight/2026-10-01_0419/` (RESUMO.md, bot-resumo.csv, logs, sprites-audit.csv; não versionado)

O bot joga com kite e escolhas heurísticas: serve para comparar heróis e versões entre si, **não** para dizer se um humano acha difícil.
Não monta o cenário (destrutíveis fixos, armadilhas, props) nem usa a regra de Sorte do cenário.

## Verificações
- Testes: **0 falhas**.
- Sprites (`audit_hero_motion`): nenhum contrato quebrado; único quadro tocando borda: Maelor `move_s` (2 quadros).

## Nível médio do bot (mediana entre parênteses)
| Herói | Dagruve | Docas | Docas ÷ Dagruve | Linha de base EVID-110 (8 min, 5 sem.) |
|---|---:|---:|---:|---:|
| Korrak | 13,5 (13,5) | 14,7 (15,0) | 1,09 | 14,4 |
| Maelor | 11,5 (12,0) | 10,4 (11,0) | 0,90 | 14,4 |
| Sylas | 10,9 (9,5) | 9,9 (9,5) | 0,91 | 9,6 |
| Bromnor | 9,5 (9,5) | 8,6 (9,0) | 0,91 | 11,6 |
| Brook | 8,8 (8,5) | 6,0 (6,0) | 0,68 | 7,0 |
| Leoric | 8,6 (8,0) | 6,0 (4,5) | 0,70 | 7,6 |
| Durvall | 6,6 (6,0) | 4,5 (4,0) | 0,68 | 5,8 |
| Zynara | 5,8 (4,0) | 3,7 (3,0) | 0,64 | 1,0 |
| Kayron | 5,6 (4,5) | 3,9 (3,0) | 0,70 | 10,2 |
| Nyrelia | 4,1 (3,0) | 2,5 (2,0) | 0,61 | 6,0 |

Passagem de fase (sementes que derrotaram o chefe e chegaram à fase seguinte, de 30): Dagruve → Docas: Korrak 5, Sylas 5, Maelor 1, Kayron 1, Leoric 1, os demais 0 (**13 de 300, 4 %**).
Docas → Shedaklah: Korrak 10, Bromnor 6, Brook 4, Leoric 4, Sylas 2, Maelor 2, Durvall 1, Kayron 1, Nyrelia 1, Zynara 1 (**32 de 300, 11 %**).

## Leitura
1. **Ordem dos heróis:** Korrak, Maelor, Sylas e Bromnor no topo; Durvall, Zynara, Kayron e Nyrelia no fundo. A linha de base de Korrak e Sylas se mantém; o Sylas sobe junto com a cópia-isca (MEC-029).
2. **Docas passa mais que Dagruve apesar de dar menos nível.** O chefe das Docas (Guardião Alado, 60 PV) é muito mais frágil que o de Dagruve (Sacerdote, 260 PV), então quem sobrevive aos 5 min vence com mais facilidade. Candidato a ajuste de números (BAL-012).
3. **Kayron caiu quase pela metade** (10,2 → 5,6) e **Nyrelia caiu um terço** (6,0 → 4,1). Os demais variaram de −20 % a +26 % (efeito esperado de 8 → 5 min). Pode ser regressão em arma, habilidade ou passiva, ou efeito do mapa mais curto; precisa de investigação (BAL-013, BAL-014).
4. **Zynara melhorou muito** (1,0 → 5,8), mas continua entre as quatro últimas.
5. Comparação com EVID-110 é só indicativa: durações, sementes e builds diferem.

## Cartões abertos por esta varredura
BAL-012 (chefes de Dagruve e Docas), BAL-013 (Kayron), BAL-014 (Nyrelia, Zynara e Durvall frágeis).

## Investigação do Kayron (BAL-013) — 2026-10-01: **não é regressão**
Comparação controlada, 30 sementes, só Dagruve, Kayron e dois heróis de controle:
- **A:** build antiga (`adaf31b`, linha de base de EVID-110), mapa de 8 min.
- **B:** build atual, mas com `data/stages.json` de 8 min (isola o efeito da duração).
- **C:** build atual, 5 min (a varredura acima).

| Herói | A (antiga, 8 min) | B (atual, 8 min) | C (atual, 5 min) |
|---|---:|---:|---:|
| Kayron | 5,8 (mediana 4,5) | 5,3 (4,0) | 5,6 (4,5) |
| Korrak | 14,6 (15,0) | 13,7 (13,5) | 13,5 (13,5) |
| Durvall | 6,9 (6,0) | 6,4 (5,0) | 6,6 (6,0) |

Conclusões:
1. Com 30 sementes o Kayron já era **~5,8 na build antiga**: o "10,2" de EVID-110 saiu de **5 sementes** e era ruído. Não houve queda por conteúdo novo.
2. O mapa de 5 min praticamente não muda o resultado do bot (B ≈ C).
3. Há uma queda pequena e uniforme da build antiga para a atual (−0,5 a −1,0 nível nos três heróis, dentro do erro de ~0,8). A causa mais provável é o loot dos destrutíveis (55 % de chance em vez de sempre soltar algo, MEC-033), que reduz poções e ímãs. Não é específica do Kayron.
4. O **Kayron é simplesmente um herói fraco para o bot** nas duas builds (mediana 4 a 4,5). Isso é um tema de balanceamento (BAL-014), não de regressão.
5. A comparação de EVID-110 com sementes baixas **não é confiável**; o mesmo pode valer para a queda aparente da Nyrelia (6,0 → 4,1).
Dados brutos: logs `out_A_*`/`out_B_*` em `F:\dev\_wt_tmp\` (fora do repositório).

## Nyrelia e Zynara com 30 sementes (BAL-014) — 2026-10-01
Mesma comparação controlada, só Dagruve (A = build antiga `adaf31b`, 8 min; B = build atual com 8 min; C = build atual, 5 min, da varredura):

| Herói | A (antiga, 8 min) | B (atual, 8 min) | C (atual, 5 min) |
|---|---:|---:|---:|
| Nyrelia | 5,8 (mediana 4,0; dp 5,2) | 4,4 (3,0; dp 3,8) | 4,1 (3,0) |
| Zynara | 8,0 (8,0; dp 4,3) | 8,1 (8,5; dp 4,3) | 5,8 (4,0) |

- **Nyrelia:** fraca nas três condições (mediana 3 a 4). A diferença A→B (−1,4) fica **dentro do erro** (~1,8 com 30 sementes): não dá para afirmar regressão. O mapa de 5 min não muda nada (B ≈ C).
- **Zynara:** a 8 min é um herói **mediano** (8,0 nas duas builds); a 5 min cai para 5,8 (**−28 %**), enquanto Korrak, Durvall e Kayron variam menos de 6 %. **O corte para 5 min prejudica a Zynara**: ela depende do tempo para render (Suspensão Temporal tem recarga de 20 s). Efeito colateral de BAL-011.
- Conclusão: a Nyrelia precisa de ajuste próprio; a Zynara precisa de uma partida inicial mais forte ou de outra alavanca antes de se mexer nos números gerais. Confirmar no playtest humano.

## Ajuste de Nyrelia e Zynara (BAL-014) — 2026-10-01
Entrevista com o dono: alavancas escolhidas e meta "meio da tabela, nível médio 7 a 9" (bot, Dagruve de 5 min, 30 sementes).

| Mudança | Antes | Depois |
|---|---|---|
| Nyrelia: Dominar Pessoa | 1d4, recarga 4,5 s | **1d6, recarga 3,5 s** (atordoamento 2,5 s mantido) |
| Nyrelia: PV base e CA | 26 PV, CA 0 | **30 PV, CA 1** |
| Zynara: Suspensão Temporal | recarga 20 s | **14 s** |
| Zynara: Ampulheta do Silêncio Eterno | 2d6, recarga 5,5 s | **2d8, recarga 5,0 s** (2ª alavanca, aplicada porque a recarga sozinha não bastou) |

Resultado (nível médio; mediana):
- **Nyrelia:** 4,1 (3,0) → **8,8 (7,5)**.
- **Zynara:** 5,8 (4,0) → só a recarga **6,2 (5,5)** → com a arma **7,9 (6,5)**.

Efeitos colaterais a vigiar: `dominar_pessoa` e `ampulheta` também podem ser obtidas por outros heróis e pelo item "Ampulheta do Silêncio Eterno"; essas armas ficaram mais fortes para todos. Não foi medido o efeito nos demais heróis. Confirmar no playtest humano.

## Efeito do ajuste nos outros 8 heróis — 2026-10-01
Mesma configuração (Dagruve de 5 min, 30 sementes), com `dominar_pessoa` e `ampulheta` já mais fortes. "Antes" = varredura desta EVID.

| Herói | Antes | Depois (mediana) | Δ |
|---|---:|---:|---:|
| Korrak | 13,5 | 12,0 (12,0) | −1,5 |
| Sylas | 10,9 | 11,0 (11,5) | +0,1 |
| Maelor | 11,5 | 10,7 (11,0) | −0,8 |
| Bromnor | 9,5 | 8,6 (8,0) | −0,9 |
| Brook | 8,8 | 9,1 (8,5) | +0,3 |
| Leoric | 8,6 | 7,1 (6,0) | −1,5 |
| Durvall | 6,6 | 7,2 (6,0) | +0,6 |
| Kayron | 5,6 | 6,0 (5,0) | +0,4 |

Leitura: **nenhum herói se mexeu além do ruído** (erro de ~0,8 a 1,0 por média de 30 sementes; a maior variação é −1,5 em Korrak e Leoric, pouco mais de 1 desvio). A soma das variações é praticamente zero (−3,3 em 8 heróis, média −0,4), então não há inflação geral. A `dominar_pessoa` aparece nos itens de 4 a 11 runs por herói (a mais usada em Brook e Leoric) e a `ampulheta` em 0 a 2: a mudança alcança outros heróis, mas sem efeito detectável.
Ordem após o ajuste: Korrak 12,0 · Sylas 11,0 · Maelor 10,7 · Brook 9,1 · **Nyrelia 8,8** · Bromnor 8,6 · **Zynara 7,9** · Durvall 7,2 · Leoric 7,1 · Kayron 6,0. A tabela ficou mais compacta, com Kayron como único herói claramente abaixo.
