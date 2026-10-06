---
id: "EVID-170"
title: "B-003: nove bênçãos novas e rebalanceamento de seis bênçãos (medido com o bot)"
created: "2026-10-06"
relations: ["[[SPEC-129-dinamismo-bencaos-divinas-e-eventos]]", "[[EVID-166-b001-medicao-das-bencaos-2026-10-06]]", "[[EVID-169-b002-juramento-e-caminho-da-estrela-2026-10-06]]"]
cards: ["BAL-019", "MEC-047"]
---

# EVID-170 — B-003 (só dados; nenhum código de jogo)

## O que mudou (`data/boons.json`, `data/boon_effects.json`)
**Nove bênçãos novas** (efeitos já existentes; o altar passa de 16 para 25 bênçãos):

| Bênção (deus) | Regra | Base no Vault |
|---|---|---|
| Faca na Sombra (Mask) | +2 de dano por acerto, +6% de esquiva, −10 PV | divindade das sombras e do furto |
| Mestre das Fechaduras (Mask) | +1 de Sorte (baús melhores), −6% de velocidade | idem |
| Passo Leve (Lliira) | −6% de recarga, +6% de velocidade, mover-se acelera recargas, −8 PV | divindade da alegria |
| Pacto da Perda (Shar) | +22% de dano, −12 PV | deusa da perda e do domínio |
| Véu da Noite (Shar) | +10% de esquiva e esquivar dá breve invulnerabilidade, −10% de área | idem |
| Luar Prateado (Selûne) | +0,2 PV/s, +4% de esquiva, −10% de dano | divindade da lua |
| Massa Faminta (Ghaunadaur) | +20% de dano, +10% de área, receber dano fere próximos, −2 CA e −2 CAM | fome e massa viscosa |
| Resto da Tarn (Helion) | +3 CA, +2 CAM, excesso de cura vira barreira, −12% de velocidade | Helion ergueu a Tarn |
| Imunidade à Praga (Lu Yueh) | imune a poças, +12% de dano, −8 PV | deus das epidemias (primeira bênção dele) |

Total no jogo: **25 bênçãos** (14 antigas + 9 novas + 2 do B-002). Nenhuma das 9 exige motor novo.

**Rebalanceamento** (valores finais após 3 rodadas): Cura (Sendrinah) +0,8 → **+0,25 PV/s** e −8% → **−12% de dano**; Fome do Abismo roubo de vida 6% → **3%** (PV −12 → −14); Olho Devorador "+2 de dano recebido" → **+1**.

## Medição (bot, 10 heróis × novato/veterano × 6 sementes = 60 runs por célula, 4 fases)
Controle (sem bênção): **0,72 fases**, erro-padrão ≈ 0,12; só conta diferença ≥ ≈ 0,33. Dados e resumos por rodada na pasta `EVID-170-…/` (`curva_rodada*.csv`, `resumo_rodada*.txt`; `rodar.sh` e `resumo.sh` reproduzem).

| Bênção | Antes (EVID-166) | Rodada 1 | **Final** (novato / veterano) | Leitura |
|---|---|---|---|---|
| Cura | 1,25 / 1,72 | 1,12 / 1,52 | **0,97 / 1,33** (rodada 3) | **ainda acima no veterano** (+0,61) |
| Fome do Abismo | 1,20 / 1,53 | 1,10 / 1,30 | **0,85 / 1,03** (rodada 2) | ok (+0,13 / +0,31) |
| Olho Devorador | 0,42 / 0,77 | 0,63 / 0,83 | **0,63 / 0,83** | corrigida, neutra |
| Resto da Tarn | — | 0,88 / 1,35 | **0,88 / 1,22** (rodada 2) | acima no veterano (+0,50) |
| Luar Prateado | — | 0,98 / 1,22 | **0,80 / 1,07** (rodada 2) | ok |
| Pacto da Perda | — | 0,33 / 0,57 | **0,48 / 0,62** (rodada 2) | neutra a fraca (−0,24 / −0,10) |
| Imunidade à Praga | — | 0,45 / 0,77 | **0,62 / 0,72** (rodada 2) | neutra |
| Massa Faminta | — | 0,77 / 0,90 | **0,77 / 0,90** | neutra |
| Véu da Noite | — | 0,85 / 0,97 | **0,85 / 0,97** | neutra |
| Faca na Sombra | — | 0,53 / 0,98 | **0,53 / 0,98** | neutra |
| Passo Leve | — | 0,70 / 0,98 | **0,70 / 0,98** | neutra (bot não usa o efeito) |
| Mestre das Fechaduras | — | 0,60 / 0,97 | **0,60 / 0,97** | neutra (bot não mede Sorte) |

## Leitura
- **Meta cumprida na maioria:** 10 das 12 ficaram dentro de ±0,33 do controle no novato e dentro de +0,5 no veterano; Olho Devorador saiu de fraca para neutra.
- **Cura continua alta no veterano (+0,61)** mesmo com a regeneração em 0,25 PV/s e −12% de dano: a causa provável é o efeito "excesso de cura vira barreira" (`overheal_shield`), que com PV cheio transforma a regeneração em barreira constante (até 25% do PV máximo). Baixar mais os números não resolve; a saída é **mexer no efeito** (ex.: barreira só até 10% ou só quando um curandeiro/fonte curar), o que é **código**, fora do escopo de "só dados" deste lote. **Fica para decisão do dono.**
- **Resto da Tarn** usa o mesmo efeito (`overheal_shield`) e também sobe no veterano (+0,50), pelo mesmo motivo.
- **Limites:** o bot não usa esquiva voluntária nem mede Sorte, e usa a bênção desde o início da run; neutras podem estar subestimadas. Sem playtest. Sem ícones por bênção (ART a registrar).

## Aceite (SPEC-129 B-003)
- Bênçãos novas aparecem no altar com texto claro (testes de dados: `tests/run_all.gd` **0 falhas**; `tools/audit_projeto.gd` **0 erros**, 7 avisos antigos).
- Rodada do bot em cada ajuste de números: feita (3 rodadas).
- As 14 bênçãos antigas mantêm o formato; só Cura, Fome e Olho tiveram número alterado.
- **Não cumprido:** nenhuma bênção passar de +0,5 — **Cura** (+0,61) no veterano; Resto da Tarn (+0,50) no limite.

## Reversão
`git revert` do commit do B-003 (um único commit de dados).
