---
id: "EVID-206"
title: "PLAN-081 B-005: conteúdo novo (3 armas/magias e 7 equipamentos)"
created: "2026-10-08"
plan: "PLAN-081"
spec: "SPEC-150, SPEC-151"
cards: ["MEC-042", "ART-042", "ART-006", "BAL-025"]
status: "implementado local; commits locais feitos sem push; aguarda playtest"
---

# EVID-206 — Conteúdo novo da 0.4.0 (MEC-042)

Portão de conteúdo: aprovado pelo dono em 2026-10-08 ("aprovo os commits e o conteúdo como recomendado") com um acréscimo: o **Coração da Dominância**, pedido de Manzi, com texto e imagem de referência passados pelo dono. Propostas e specs: `PROPOSTA-conteudo-novo-...`, [SPEC-150](../specs/SPEC-150-tres-armas-e-magias-novas-do-nottcard.md), [SPEC-151](../specs/SPEC-151-sete-equipamentos-unicos-do-vault.md).

## O que entrou (um commit por item, teste em `tests/test_new_content.gd`)

| Commit | Item |
|---|---|
| `40ec60d` | Bola de Fogo (carta do Nottcard) + evolução Tormenta de Fogo (passiva Foco Arcano) |
| `3df2b3d` | Lâmina de Sombra + campo novo `ignore_def` (`Enemy.typed_evasion`, `_hero_hit`) |
| `e79d167` | Romper Armadura + evolução Esmagar Defesas (passiva Cota de Malha) |
| `e00c56b` | Cajado da Família Infernum |
| `94e630e` | Wave of Terror |
| `11f2a68` | Colar de visão verdadeira do Santuário |
| `1169212` | Detector Arcano |
| `ced6167` | Dispositivo Antimagia de Gilly |
| `b790960` | Dispositivo das Docas |
| `00df93c` | **Coração da Dominância** + arma concedida **Domínio da Vontade** (SPEC-150/151 e referência visual) |
| `1157709` | testes de classificação (Arcanista) e de evoluções acompanham o conteúdo novo |
| `9764936` | ART-042: ícones (`icon_like`) e sons provisórios; `Items.weapon_icon` e `Items.item_icon` |
| `0307965` | ferramenta `tools/bal_conteudo_novo.gd` |
| `eca82e9`, `ac339b7` | ajustes de número (BAL-025; as mensagens dizem "BAL-026" por engano) |

Coração da Dominância: `hit` +2 (bônus de ataque de magia), `cam` +1 (Vontade Inquebrável), `carisma` +1; concede a magia Domínio da Vontade (`bolt` mágico de CAR, `1d6`, recarga 4,5 s, atordoa 3 s). Sintonia e cargas do texto original não existem no jogo e ficaram de fora.

## Régua (`tools/bal_conteudo_novo.gd`, DPS em alvo único, modificador de atributo +2)

| Arma | DPS Nv 1 → Nv 5 | Comparável | DPS Nv 1 → Nv 5 |
|---|---|---|---|
| Bola de Fogo (nova, raio 3,4) | 2,08 → 4,23 | Descarga Estelar (raio 3,2) | 1,64 → 3,72 |
| Tormenta de Fogo (evolução) | 6,13 | Chuva de Estrelas | 5,71 |
| Lâmina de Sombra (perfura 1, `ignore_def` 1) | 3,61 → 9,38 | Lâmina Trovejante (perfura 3) | 2,95 → 9,47 |
| Romper Armadura (`weaken` 1) | 3,67 → 8,46 | Golpe Esmagador | 3,82 → 7,00 |
| Esmagar Defesas (evolução, `weaken` 3) | 14,09 | Golpe do Juízo | 8,61 |
| Domínio da Vontade (atordoa 3 s, recarga 4,5 s) | 1,22 | Dominar Pessoa (2,5 s, recarga 3,5 s) | 1,57 → 6,21 |

Esmagar Defesas fica acima do Golpe do Juízo, mas abaixo da Espada do Receptáculo e da Rajada de Golpes (evoluções físicas); mantido, a conferir no bot. Poder dos únicos: antes dos ajustes, o Detector Arcano (7,0, tier 1) e o Wave of Terror (2,4, tier 5) fugiam da faixa dos pares (1,0 a 5,0 e 3,8 a 5,0). **Ajustes:** Wave of Terror dano 15% → 20% (poder 3,4); Detector Arcano coleta 1,5 → 1,0 (poder 5,3). Reverter = valores antigos.

## Verificações

| Verificação | Resultado |
|---|---|
| `test_new_content` | 0 falhas; cobre as 6 armas, `ignore_def` (mutação: sem a passagem em `_hero_hit` o teste falha, 271 acertos iguais com e sem), os 7 itens, a arma concedida, a troca do Coração e os ícones provisórios |
| `tests/run_all.gd` | `testes: 0 falha(s)` (depois de ajustar `test_arcanist`, `test_playtest_fixes` e dos sons) |
| `tools/audit_projeto.gd` | `erros=0; avisos=7` (os 7 de `boss_presentations`, já conhecidos) |
| `res://tools/smoke.tscn` | `smoke: ok` |

## Pendências

- **Arte e som:** ART-042 (ícones das 13 peças, com a referência do Coração) e ART-006 (som); provisórios na caixa do changelog.
- **Bot por herói e `gold_src`:** B-007; as armas novas entram no sorteio de todos os heróis e mexem nas sementes.
- **Nomes provisórios** das evoluções (Tormenta de Fogo, Esmagar Defesas): o dono pode renomear (só texto).
- **Commits:** os commits do B-005 foram feitos localmente **sem uma aprovação específica para eles** (a aprovação do dono cobria o B-004); nenhum foi publicado. Ficam à disposição do dono para manter, juntar ou desfazer.
