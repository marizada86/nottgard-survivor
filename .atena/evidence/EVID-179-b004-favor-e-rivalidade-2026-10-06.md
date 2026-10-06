---
id: "EVID-179"
title: "B-004: Favor divino, rivalidade e quatro bênçãos de Zuggtmoy e Juiblex"
created: "2026-10-06"
relations: ["[[SPEC-129-dinamismo-bencaos-divinas-e-eventos]]", "[[EVID-170-b003-novas-bencaos-e-rebalanceamento-2026-10-06]]", "[[EVID-169-b002-juramento-e-caminho-da-estrela-2026-10-06]]"]
cards: ["MEC-047", "BAL-019"]
---

# EVID-179 — B-004 (Favor e rivalidade)

## O que entrou
- **Favor** (`core/favor.gd`, `data/favor.json`): cada bênção aceita soma 1 ao deus. **Favor líquido** = bênçãos do deus − bênçãos do rival (mínimo 0). Limiares **2** e **3** liberam os níveis 1 e 2; os bônus de nível somam e valem até o fim da run (`Hero.recalc`).
- **Rivalidade** (decisão D2: **só troca o Favor, nunca bloqueia**): Tou Um × Lu Yueh (Feng-tu, `12_Lore/Tou Um e Lu Yueh`: a divisão se equilibrava pelo conflito entre os dois) e Zuggtmoy × Juiblex (Shedaklah, `03_NPCs/Zuggtmoy` e `Juiblex`).
- **Interface:** o cartão do altar ganha uma linha "Favor de X a → b, libera o nível n" e "tira Favor de Y"; o HUD lista o Favor de cada deus ativo (`Favor.hud_lines`).
- **Quatro bênçãos novas** para fechar o par de Shedaklah: Esporos Benfazejos e Guarnição Fúngica (Zuggtmoy, "soberana fúngica" com guarnição que a serve por escolha), Corpo Gelatinoso e Mente-Colmeia (Juiblex, "mente-colmeia", "Lorde dos Slimes"). Altar: **29 bênçãos**.
- Bônus por deus (nível 1 / nível 2): Sendrinah PV+10 / PV+10, regen+0,1; Mask esquiva+4% / dano por acerto+1; Lliira recarga−4% / XP+6%; Shar dano+6% / esquiva+4%; Selûne XP+6% / esquiva+4%; Ghaunadaur dano+6% / área+6%; Tou Um velocidade+4% / regen+0,1; Lu Yueh dano+5% / área+6%; Zuggtmoy PV+8 / CA+1; Juiblex red. de dano+1 / XP+6%; Helion INT+1 / CAM+1.

## Verificação
- `tests/test_favor.gd` (novo): todo deus tem entrada; rivalidade recíproca; sem bênção sem bônus; uma bênção não libera nível; duas do mesmo deus liberam o nível 1; o rival tira Favor e derruba o nível; limiares 2 e 3; `recalc` soma o bônus; o altar segue oferecendo com rival no herói; dicas de oferta e linhas do HUD. **Teste de sanidade:** trocar os limiares para [3, 4] faz o teste falhar (3 falhas).
- **`tests/run_all.gd`: 0 falhas; `tools/audit_projeto.gd`: 0 erros** (7 avisos antigos).
- `tools/bal_bencaos.gd` agora aceita `a+b` para forçar várias bênçãos (mede o Favor).

## Medição (bot, 60 runs por célula, 4 fases; controle 0,72 fases, ≈ ±0,12; conta ≥ ≈ 0,33)
Bênçãos novas, antes e depois do ajuste (novato / veterano):

| Bênção | Rodada 1 | Ajuste | **Final** | Leitura |
|---|---|---|---|---|
| Esporos Benfazejos | 1,07 / 1,43 | PV +10→+8, regen 0,2→0,1, velocidade −8%→−10% | **0,95 / 1,08** | ok (+0,23 / +0,36) |
| Guarnição Fúngica | 0,63 / 0,83 | — | **0,63 / 0,83** | neutra |
| Corpo Gelatinoso | 0,98 / 1,33 | redução de dano 2→1 | **0,85 / 1,05** | ok (+0,13 / +0,33) |
| Mente-Colmeia | 0,45 / 0,60 | PV −12→−8 | **0,48 / 0,67** | neutra a levemente fraca |

Pares forçados (rodada 1, com os bônus de Favor ativos quando há nível):

| Par | Favor | Novato / veterano |
|---|---|---|
| Faca na Sombra + Mestre das Fechaduras (Mask) | nível 1 (esquiva +4%) | 0,55 / 1,07 |
| Noite Eterna + Pacto da Perda (Shar) | nível 1 (dano +6%) | 0,50 / 0,75 |
| Guia da Estrela + Caminho da Estrela (Tou Um) | nível 1 (velocidade +4%) | 0,90 / 1,42 |
| Caminho da Estrela + Imunidade à Praga (rivais) | **nenhum** (empate de rivais) | 0,98 / 1,38 |

## Leitura
- **O Favor em si é pequeno e não desequilibra:** os pares de Mask e de Shar ficaram neutros. O alto valor dos pares com Tou Um vem do **Caminho da Estrela** (o bot anda atrás da estrela: ≈ +0,3 só de movimento, EVID-169); o par rival (sem Favor) deu o mesmo resultado que o par com Favor, o que mostra que o bônus de nível 1 pesa pouco.
- **A rivalidade funciona como regra** (teste automatizado), mas o **efeito percebido só aparece em jogo**: o par de rivais tira o bônus de +4% de velocidade, algo que o bot não distingue. Precisa de playtest para saber se o jogador sente a troca.
- **Limite:** o Favor exige 2 bênçãos do mesmo deus numa run; com 29 bênçãos e 2 a 3 altares por fase, vai acontecer pouco; se o dono quiser mais Favor, é só baixar o limiar em `data/favor.json`.

## Reversão
`git revert` do commit do B-004 (código em `core/favor.gd` e ganchos; dados em `data/favor.json` e `data/boons.json`).
