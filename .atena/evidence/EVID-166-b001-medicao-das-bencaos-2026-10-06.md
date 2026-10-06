---
id: "EVID-166"
title: "Medição das 14 bênçãos atuais com o bot (SPEC-129 B-001, BAL-019)"
created: "2026-10-06"
relations: ["[[SPEC-129-dinamismo-bencaos-divinas-e-eventos]]", "[[EVID-160-linha-de-base-bal-018-2026-10-05]]", "[[EVID-163-relato-t04-manzi-sylas-2026-10-05]]"]
cards: ["BAL-019", "MEC-047"]
---

# EVID-166 — Poder das 14 bênçãos atuais (nada do jogo foi alterado)

**Commit base:** `048832e` (árvore com mudanças de outra sessão, SPEC-127, em `core/battle.gd` e `ui/hud.gd`; não afetam bênçãos).
**Ferramenta nova:** [tools/bal_bencaos.gd](../../tools/bal_bencaos.gd) (cópia do piloto de `bot_curva.gd`; o herói começa com **uma** bênção forçada ou nenhuma; nos altares **sempre recusa**; em level-up nunca escolhe bênção).
**Matriz:** 15 configurações (14 bênçãos + controle `none`) × 10 heróis × 2 metas (m0 novato, m1 veterano) × 6 sementes = **60 runs por bênção e meta**, 4 primeiras fases (Dagruve, Docas, Shedaklah, Molor), `dt` 0,1, mapa 60. Reprodução: `bash rodar.sh 6` e `bash resumo.sh` nesta pasta. Dados: [curva_bencaos.csv](EVID-166-b001-medicao-das-bencaos-2026-10-06/curva_bencaos.csv) (3.387 linhas), resumo em `resumo_bruto.txt`.
Cinco combinações do veterano saíram vazias na primeira passada (execuções muito longas) e foram **refeitas isoladamente** com os mesmos parâmetros.

**Métrica principal:** fases **superadas** por run (0 a 4). Controle: **0,72** nas duas metas, erro-padrão ≈ 0,11–0,13. Uma diferença só conta como real se passar de **≈ 0,3** (2 erros-padrão da diferença). Colunas extras: nível médio ao fim da run e % das runs que morrem já em Dagruve.

## Ranking (fases superadas · nível final · % que morre em Dagruve)

| Bênção | Novato (m0) | Veterano (m1) | Leitura |
|---|---|---|---|
| **Sendrinah: Bênção da Cura** (+0,8 PV/s, −8% dano) | **1,25** · 14,6 · 25% | **1,72** · 16,8 · 17% | **forte demais**: +0,53 / +1,00 sobre o controle |
| **Ghaunadaur: Fome do Abismo** (roubo de vida 6%, −12 PV) | **1,20** · 13,1 · 33% | **1,53** · 15,9 · 20% | **forte demais** (sustento) |
| Sendrinah: Vida Nova (+20 PV, −6% vel.) | 0,95 · 12,7 · 48% | 1,28 · 14,0 · 32% | acima (real só no veterano) |
| Lliira: Dança da Alegria (−12% recarga, −10 PV) | 0,73 · 10,4 · 62% | 1,18 · 13,3 · 43% | acima no veterano |
| Selûne: Luar Protetor (+8% esquiva, +10% XP, −8% dano) | 0,80 · 10,7 · 52% | 1,13 · 13,2 · 42% | acima no veterano |
| Mask: Manto de Sombras (+10% esquiva, +12% vel., −2 CA) | 0,60 · 8,7 · 67% | 1,08 · 13,1 · 43% | neutra a acima |
| Mask: Mão de Ladrão | 0,78 · 10,8 · 55% | 0,97 · 12,4 · 45% | neutra |
| Shar: Dádiva da Perda (+2 CA/CAM, −10% XP) | 0,68 · 9,3 · 60% | 0,95 · 11,4 · 48% | neutra |
| Tou Um: Guia da Estrela | 0,58 · 8,9 · 65% | 0,95 · 12,1 · 52% | neutra a abaixo |
| Shar: Noite Eterna (+18% dano, −15% área) | 0,77 · 10,1 · 55% | 0,93 · 11,8 · 43% | neutra |
| Lliira: Sorriso da Sorte | 0,58 · 8,9 · 65% | 0,92 · 12,2 · 53% | neutra (o bot não mede Sorte) |
| Selûne: Guia das Estrelas | 0,55 · 9,2 · 65% | 0,87 · 12,0 · 52% | neutra a abaixo |
| Ghaunadaur: Olho Devorador (+30% dano, +2 dano recebido) | **0,42** · 7,6 · 68% | 0,77 · 10,1 · 63% | **fraca** (−0,30 no novato) |
| Helion: Cadernos Vinculados (+2 INT, −1 FOR) | 0,65 · 8,8 · 53% | 0,73 · 10,5 · 58% | neutra (depende de herói de INT) |
| *Controle (sem bênção)* | *0,72 · 9,4 · 53%* | *0,72 · 10,2 · 62%* | — |

## O que os números dizem
1. **Duas bênçãos dominam por sustento**: Cura e Fome do Abismo. Regeneração e roubo de vida pesam mais que dano ou velocidade; o custo (−8% de dano, −12 PV) mal aparece. Para o dinamismo isso importa: se a melhor escolha é sempre a de cura, a escolha não é interessante.
2. **Uma é claramente fraca**: Olho Devorador. O "+2 de dano por golpe" do inimigo pesa mais que +30% de dano em fase inicial.
3. **A maioria é neutra** (dentro do ruído de ±0,3): trocar +X por −Y quase se anula. Isso reforça a leitura do Hiago e do Manzi: bênção hoje é só troca de estatística e raramente muda a run.
4. **Quanto mais forte o herói (m1), mais as bênçãos de sustento e de recarga se destacam.** Bênção ruim não piora o veterano além do ruído.

## Limites desta medição
- O bot **não usa** efeitos de comportamento (esquiva voluntária, andar para recarregar, coleta de baús, Sorte de drop); então Dança da Alegria (`moving_cooldown`), Mão de Ladrão, Sorriso da Sorte e Manto de Sombras podem estar **subestimadas**. É um alarme, não um veredito.
- A bênção é forçada **no início** da run (no jogo só aparece no altar, a partir de ~1 min), então os ganhos de sustento estão **superestimados** no começo.
- Só 4 fases e só bots; nenhuma medição por herói isolado (dois heróis têm patrono, Sendrinah e Shar; não foi cruzado).
- O controle deu 0,72 nas duas metas apesar do veterano; atribuído a ruído (n = 60), não investigado.

## Consequência para o SPEC-129
- **Não mexer nos números agora** (decisão pertence ao dono e à B-003). O que fica registrado: Cura e Fome são o teto a rebaixar ou o padrão a copiar; Olho Devorador precisa de ajuste para cima; as novas famílias (juramento, caminho, custo) devem nascer com **custo que pese**, e não só "+X, −Y".
- O B-002 pode começar sem depender deste ranking.
- Cartão **BAL-019** passa a "medido em 2026-10-06 (EVID-166)".
