---
id: "SPEC-150"
title: "Três armas e magias novas do Nottcard: Bola de Fogo, Lâmina de Sombra e Romper Armadura (MEC-042)"
status: "EM EXECUCAO em 2026-10-08 (PLAN-081 B-005)"
origin: planned
implementation_preceded_spec: false
request_classification: PLAN_DEVIATION
created: "2026-10-08"
relations: ["[[SPEC-148-lancamento-da-v0-4-0]]", "[[SPEC-149-npc-de-upgrade-de-magia-arcanista]]", "[[PROPOSTA-conteudo-novo-v0-4-0-armas-magias-e-equipamentos-2026-10-08]]"]
cards: ["MEC-042"]
---

# SPEC-150 — Três armas e magias novas (MEC-042)

Aprovado pelo dono em 2026-10-08 ("aprovo ... o conteúdo como recomendado"): W1 a W3 como na proposta; **evolução para W1 e W3, nenhuma para W2**. Fonte: `F:\dev\nottcard\data\core\cards.json` (cartas que o jogo ainda não tem). Um commit, um teste e uma medição do bot por arma. Risco: **baixo** (dados) com **um** campo novo de combate (`ignore_def`).

## Armas

Todas entram como `src: "Carta: <nome>"`, o que as põe sozinhas no sorteio de "NOVA" ao subir de nível, para qualquer herói com slot livre. O Arcanista melhora W1 e W2 (magias, pela regra da SPEC-149); o ferreiro melhora W3.

| Id | Nome | `kind` / `dtype` / `attr` | Base | Níveis 2 a 5 | Evolução |
|---|---|---|---|---|---|
| `bola_de_fogo` | Bola de Fogo | `nova` / `fogo` / `inteligencia` | `3d6`, recarga 6,0 s, raio 3,4 | `3d8`; raio +0,5; recarga −0,8; `4d8` e +2 de dano | passiva `foco_arcano` → `tormenta_de_fogo` |
| `lamina_de_sombra` | Lâmina de Sombra | `bolt` / `magico` / `inteligencia` | `1d8`, recarga 1,8 s, alcance 9, velocidade 11, perfura 1, `ignore_def` 1 | `1d10`; perfura +1; recarga −0,2; projéteis +1 e `ignore_def` +1 | nenhuma |
| `romper_armadura` | Romper Armadura | `melee` / `fisico` / `forca` | `1d6`, recarga 1,5 s, alcance 1,8, cone 55, `weaken` 1 | `1d8`; `weaken` +1; recarga −0,2; `2d6` e +2 de dano | passiva `cota_de_malha` → `esmagar_defesas` |

Evoluções (nomes provisórios; trocar o nome é só texto em `weapons.json`):
- `tormenta_de_fogo` (`src: "Evolução"`): `nova` / `fogo` / INT, `5d8`, recarga 4,0 s, raio 5,0, "O céu queima".
- `esmagar_defesas` (`src: "Evolução"`): `melee` / `fisico` / FOR, `3d8`, recarga 1,1 s, alcance 2,4, cone 90, `weaken` 3, "Rasga a guarda de qualquer um".

## Campo novo: `ignore_def`

`Enemy.typed_evasion(dtype, ignore := 0)` desconta `ignore` pontos da defesa usada (CA se `fisico`, CAM caso contrário) antes de calcular a esquiva; `_hero_hit` passa `int(p.get("ignore_def", 0))`. Só afeta a chance de acerto de armas que o declaram. Rótulo na descrição de nível: "ignora defesa".

## Provisórios

Sem PNG em `assets/icons/weapons/`: o ícone cai no fallback atual (letra). Entra em ART-042 (ícones de armas e itens novos) e na caixa "Isto é provisório". Sem som próprio (usa o de arma genérica).

## Critérios de aceite

1. As 3 armas e as 2 evoluções existem com dado válido (dado `NdM`, evolução e passiva existentes, `levels` com 4 entradas nas que sobem).
2. `Weapon.is_spell`: W1 e W2 magias, W3 arma (Arcanista × ferreiro).
3. W1 fere todo inimigo no raio com `fogo`; W2 acerta mais um alvo de CAM alta que a mesma arma sem `ignore_def` (medido nas chances); W3 reduz CA e CAM do alvo em `weaken`.
4. Cada arma aparece nas ofertas "NOVA" de um herói com slot livre; as evoluções só com a passiva.
5. Suíte, smoke e `audit_projeto` sem falhas novas; bot por arma antes → depois (`tools/bal_armas.gd`) registrado no EVID.
6. Mutação: sem `ignore_def` em `_hero_hit` o teste de W2 falha.

## Lacunas

| Id | Lacuna | Classe | Tratamento |
|---|---|---|---|
| G1 | Nomes das evoluções | NON_BLOCKING | Provisórios; o dono pode renomear |
| G2 | Números de partida | NON_BLOCKING | Medidos pelo bot; ajuste só em JSON, uma alavanca por vez |
