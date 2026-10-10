---
id: "SPEC-149"
title: "NPC de upgrade de magia: o Arcanista (MEC-041)"
status: "IMPLEMENTADA e publicada (PLAN-081 B-004, EVID-205); aguarda playtest e arte própria (ART-041)"
origin: planned
implementation_preceded_spec: false
request_classification: PLAN_DEVIATION
created: "2026-10-08"
relations: ["[[SPEC-148-lancamento-da-v0-4-0]]", "[[SPEC-143-marcas-do-abismo-entrega-2]]", "[[SPEC-064]]"]
cards: ["MEC-041"]
---

# SPEC-149 — Arcanista (MEC-041)

Origem: decisão do dono em 2026-10-04 ("o ferreiro não deve melhorar magias; um NPC próprio faz esse upgrade"; E10: entra na próxima major) e plano da 0.4.0 (SPEC-148 item 9). Risco: **médio**.

## Situação de hoje

`Battle._open_shop_event("ferreiro")` (`core/battle.gd`) oferece melhoria (`shop_weapon_up`) a **todas** as armas do herói que não são `granted` e não estão no nível máximo, mais a melhoria de equipamento (`shop_item_up`). Não há marca de "magia" em `data/weapons.json`. Metade dos heróis começa com uma magia (`raio_de_luz`, `raio_enfraquecedor`, `descarga_estelar`, `sentenca_de_lliira`, `sopro_de_estrela`, `dominar_pessoa`, `ampulheta`).

## Regra de "magia"

`Weapon.is_spell(def)`: o campo opcional `"spell": true|false` do JSON manda; sem ele, é magia toda arma com `kind != "melee"` (`bolt`, `nova`, `zone`) **ou** `dtype == "magico"` (inclui a Estocada Mística, que é corpo a corpo mágica). São armas, e continuam com o ferreiro: Espada Sombria, Golpe Esmagador, Golpe Rápido, Golpe Atordoante, Golpe do Juízo, Chicote Avarento, Martelo da Glória, Machado de Xar'gath, Lâmina da Digestão e as evoluções corpo a corpo físicas. Nenhum JSON precisa mudar.

## Regras

1. **Ferreiro:** passa a oferecer melhoria só de armas que **não** são magia, mais equipamentos (inalterado). Título: "Ferreiro — forje uma arma ou equipamento". Sem nada forjável: "Nada para melhorar" com a dica "Magias são com o Arcanista."
2. **Arcanista (`kind` `arcanista`):** evento igual aos de loja, ferreiro e curandeiro (pausa, sempre "Sair" sem custo, mostra opções travadas por falta de moeda). Oferece melhoria de até 2 magias não `granted` e abaixo do nível máximo, com a mesma oferta `shop_weapon_up`, o mesmo cartão e o mesmo texto de nível (`_level_desc`, `_level_brief`). Sem magia melhorável: "Nada para estudar" com a dica "Armas e equipamentos são com o ferreiro."
3. **Preço:** igual ao do ferreiro, `(20 + 10 × nível) × coin_mult`. Nenhum número de balanceamento muda; só quem vende.
4. **Aparição:** peso `1` em `stages.json` (`interactions.arcanista`) nas nove fases, como o ferreiro. O sorteio de interativos soma um peso a mais (≈ +7%); o teto `max_alive` não muda. Não há posição fixa (Oficina do Cais continua só ferreiro).
5. **Sem trégua** (Marca do Abismo): `arcanista` entra em `TRUCE_KINDS`, e a descrição passa a "Sem loja, ferreiro, arcanista nem curandeiro durante a run inteira."
6. **Interação:** `E` abre o Arcanista (lista de `interact()`, dica da HUD "estudar com o arcanista", botão mobile "Estudar", título "Arcanista — aprimore uma magia").
7. **Arte e som provisórios:** sem PNG; o overlay desenha o losango roxo com o rótulo "arcanista [E/oeste]" (padrão dos eventos sem arte). Som: alias `world.arcanista` → `world.altar`. Cartões ART-041 (NPC) e ART-006 (som) registram o que falta.
8. **Compatibilidade:** `granted`, `max_level`, a melhoria ao subir de nível, as sinergias e a Mesa de Aposta não mudam.

## Não objetivos

Mudar preços, níveis máximos ou o texto das magias; NPC com lore própria (nome genérico, igual a "ferreiro"); posição fixa no cenário; arte nova.

## Lacunas

| Id | Lacuna | Classe | Tratamento |
|---|---|---|---|
| G1 | Nome do NPC | NON_BLOCKING | "Arcanista" (papel genérico, sem lore inventada) |
| G2 | Peso 1 dilui os outros eventos | NON_BLOCKING | Medido em B-007 (bot); ajustar só o peso em JSON |
| G3 | Heróis cujas armas são todas magia nunca usam o ferreiro | NON_BLOCKING | Esperado; é o que o dono pediu. Equipamento segue com o ferreiro |

Zero lacunas `BLOCKING`.

## Critérios de aceite

1. `Weapon.is_spell` classifica as 30 armas como esperado (11 armas e 19 magias) e respeita `"spell"` explícito.
2. Ferreiro com um herói de arma e magia oferece só a arma (e equipamento); Arcanista oferece só a magia; os dois comprados sobem o nível em 1 e fecham a oferta.
3. Ferreiro e Arcanista sem nada elegível mostram a mensagem com a dica do outro e "Sair".
4. `_spawn_random_interaction` produz `arcanista` nas nove fases; com Sem trégua nunca produz.
5. `interact()` abre `shop_arcanista`; HUD, mobile e overlay têm rótulo e título.
6. Suíte, smoke e `tools/audit_projeto.gd` (sem aviso de interação desconhecida) sem falhas novas.
7. Mutação: sem o filtro de magia no ferreiro, o teste falha.
