---
id: "SPEC-174"
title: "Evoluções das armas sem evolução (lote 1, cinco armas) e atributo mínimo para evoluir"
status: "IMPLEMENTADA LOCAL em 2026-10-13 (PLAN-101, EVID-243); DRAFT; aguarda playtest humano; commitada local (563c07b), sem push"
origin: planned
implementation_preceded_spec: false
request_classification: PLAN_DEVIATION
created: "2026-10-13"
relations: ["[[SPEC-150]]", "[[SPEC-147-correcoes-dos-playtests-v032-e-v033]]", "[[SPEC-173-filtro-visual-e-fonte-da-interface-lote-1]]"]
cards: ["MEC-067"]
content_state: DRAFT
approval_mode: per-plan
plan_id: PLAN-101
---

# SPEC-174 — Evoluções das armas sem evolução (lote 1) e atributo mínimo

Origem: rascunho [PROPOSTA-evolucoes-armas-sem-evolucao-2026-10-13](../vault/drafts/PROPOSTA-evolucoes-armas-sem-evolucao-2026-10-13.md) (DEV-041) e a resposta do dono em 2026-10-13: *"aprovo o plano com 5 evoluções"*, mais a ideia de um **atributo mínimo para poder evoluir** (exemplo dele: Martelo do Alvorecer pede Constituição 16) e o pedido de checar o vault para o nome da evolução do Sopro de Estrela.

## Estado de partida (verificado no código em 2026-10-13)

- Evolução = `evolve: {passive, into}` na arma base e uma entrada `src: "Evolução"` própria (`data/weapons.json`). A oferta sai em `core/battle.gd:2585` quando `Weapon.can_evolve()` (nível 5) **e** o herói tem a passiva (nível ≥ 1); peso 9.
- Nenhum atributo entra na regra. `hero.attr(nome)` = atributo-base + mods (passivas de atributo +1 por nível, itens, bênçãos); atributos **não sobem por nível** do herói (`level_growth` só dá PV).
- Os atributos iniciais dos 12 heróis variam de 8 a 18 (`data/heroes.json`).
- Pontos que lêem `can_evolve` / `evolve`: `core/weapon.gd:43`, `core/battle.gd` (oferta, `evolve_hint`, `evolution_text`, escolha), `ui/character_sheet.gd:435-452` (selo "pronta para evoluir"), `tools/audit_projeto.gd:62`, `tests/test_data.gd`, `tests/test_battle.gd`.

## Decisões do dono (2026-10-13)

| # | Decisão |
|---|---|
| D1 | **Aprovado o lote 1 com 5 evoluções** (conteúdo desta spec). Números ainda são hipóteses até a bateria (§Verificação). |
| D2 | Sopro de Estrela: o nome da evolução deve se relacionar a **Sylvaris** ou a **Silva** (checar o vault). Resultado em §Nomes. |
| D3 | **Proposta do dono:** exigir um mínimo de atributo para evoluir, como balanceamento (ex.: Constituição 16 no Martelo; "considerar outro número"). Regra em §Atributo mínimo; os valores aguardam escolha. |
| D4 | Nível de aprovação: **por plano** (`per-plan`). |
| D5 | Mínimo de atributo **16 em todas** as 5 evoluções novas (Martelo em Constituição, como o dono sugeriu). Nomes: **Constelação de Silva** e **Martelo da Luz**. |

## Escopo

### 1. As cinco evoluções (dados)

`levels: []`, `src: "Evolução"`, `icon_like` para o ícone da base (mesmo caminho da Tormenta de Fogo e do Esmagar Defesas). Régua e comparação com as evoluções existentes: [regua.js](../generated/evolucoes-armas-2026-10-13/regua.js).

| Base | Evolução (nome provisório) | Passiva | Parâmetros | ST | MULTI 0,2 |
|---|---|---|---|--:|--:|
| Dominar Pessoa | Domínio Coletivo | Sabedoria | bolt mágico CAR; **2d8 cd 2,6 count 3 pierce 1 stun 3** | 6,2 → 12,7 | 6,2 → 25,4 |
| Golpe Esmagador | Maça Demolidora | Pele de Pedra | melee físico FOR; **3d10 cd 1,3 alc. 2,2 cone 80 stun 1,5** | 7,0 → 14,2 | 7,0 → 14,2 |
| Martelo da Glória | **Martelo da Luz** *(escolha do dono; ver §Nomes)* | Cota de Malha | melee radiante FOR; **4d10 cd 1,8 alc. 2,3 cone 130 knock 2,0 stun 1** | 8,5 → 13,3 | 8,5 → 16,0 |
| Raio Enfraquecedor | Raio da Ruína | Robe Arcano | bolt mágico INT; **2d6 cd 1,2 count 3 pierce 2 weaken 4** | 13,1 → 22,5 | 13,1 → 67,5 |
| Sopro de Estrela | **Constelação de Silva** *(escolha do dono; ver §Nomes)* | Sabedoria | nova radiante CAR; **5d8 cd 4,6 r 4,8 slow 3 weaken 2** | 2,7 → 5,3 | 27,1 → 77,1 |

Regras que o lote respeita: nenhuma evolução com `heal` ou `lifesteal` (decisão do dono, BAL-022); sem Regeneração como passiva; as 10 evoluções existentes **não mudam**; valores abaixo da faixa das evoluções atuais (ST máx. 22,5 contra 44,3 da Tempestade).

### 2. Atributo mínimo para evoluir (mecânica nova, pequena)

Proposta técnica para a ideia do dono:

- Campo opcional no bloco `evolve` da arma base: `"min_attr": {"constituicao": 16}` (uma chave de atributo, valor inteiro). Sem o campo, nada muda (as 10 evoluções atuais continuam iguais).
- Regra: a evolução só é **oferecida** (peso 9) quando nível 5 **e** passiva **e** `hero.attr(chave) >= valor`. Usa o atributo efetivo (base + passivas + itens + bênçãos), então investir na passiva do atributo abre a evolução.
- Nada se perde se o atributo cair depois: a arma segue como está; a evolução só deixa de ser oferecida.
- Texto: `evolve_hint` passa a listar o que falta, no mesmo formato de hoje ("Falta: nível 5 (agora 3), passiva Sabedoria, Constituição 16 (agora 14)"), e o selo "▲ pronta para evoluir" da ficha só acende com as três condições.
- Efeito no build: o atributo vem de uma passiva de atributo (+1 por nível), que ocupa um dos 5 espaços de passiva ao lado da passiva da evolução. Atributo base 8–10 com mínimo 16 exige +6 a +8 e na prática **não evolui** (teto +5 pela passiva, mais itens). É o efeito pretendido de "especialização".

Quem cumpre o mínimo **de saída** (atributo-base, 12 heróis; calculado de `data/heroes.json`):

| Evolução | Atributo | Mín. 14 | Mín. 16 | Mín. 17 | Mín. 18 |
|---|---|---|---|---|---|
| Domínio Coletivo | Carisma | 7 | 2 (Leoric, Nyrelia) | 0 | 0 |
| Maça Demolidora | Força | 4 | 4 (Durvall, Korrak, Erik, Bromnor) | 1 (Korrak) | 1 |
| Martelo (Constituição, como o dono sugeriu) | Constituição | 6 | 4 (Brook, Maelor, Korrak, Bromnor) | 0 | 0 |
| Martelo (Força, o atributo de dano) | Força | 4 | 4 (Durvall, Korrak, Erik, Bromnor) | 1 | 1 |
| Raio da Ruína | Inteligência | 5 | 2 (Sylas, Zynara) | 0 | 0 |
| Constelação de Silva | Carisma | 7 | 2 (Leoric, Nyrelia) | 0 | 0 |

Leitura: com **16**, o herói para quem a evolução foi pensada já cumpre de saída (Nyrelia, Sylas, Leoric, Bromnor) e os outros pagam de 1 a 4 níveis de passiva de atributo. Com **17**, ninguém cumpre de saída e todo mundo precisa investir, inclusive o herói da arma.

### 3. Nomes (D2, checado no vault de Nottgard)

Fontes: `06_Itens/Sopro de Estrela.md`, `03_NPCs/Sylvaris.md`, `03_NPCs/Leoric.md`, `02_Personagens/Leoric.md`, `06_Itens/Martelo da Glória.md`.

- **Sylvaris** é a grafia canônica; **Silva** é o apelido; *Silvaris* é só grafia de transcrição antiga (não usar).
- Sylvaris é elfo, oráculo e amigo de Helion; fez pacto com Sendrinah e vive em Dagruve cuidando de um templo. **Ensina Leoric a ler as estrelas** (Meditação Estelar, Sessões 13 e 14) e é mestre em comum de Leoric e Korrak ("um mestre em comum chamado Silva", Sessão 10).
- Leoric manifesta o **Modo de Constelação** (forma estrelada, reforço radiante aos aliados, Sessão 18) e o Sopro de Estrela é a concha de João usada para abrir o portal de Feng-tu (Sessão 18).
- O vault não registra nenhuma arma ou magia chamada com o nome de Sylvaris/Silva: o nome abaixo é **batismo de jogo**, não fato do vault.

| Opção | Por que | Cuidado |
|---|---|---|
| **Constelação de Silva** *(recomendada)* | Junta o Modo de Constelação de Leoric ao mestre que o ensinou; usa o apelido que o próprio Leoric usa | Nenhum segredo do mestre envolvido |
| Meditação Estelar | A prática que Silva ensina e Leoric falha em dominar (S14); evolução como "conseguiu" | Menos ligada à concha e à nova radiante |
| Sopro de Sylvaris | Mantém "Sopro" e usa o nome canônico | Soa como item do Sylvaris, e a concha é de João |

Martelo da Glória (`aliases: Martelo da Luz`): a luz do martelo "mudou de amarela para vermelha" ao virar Glória (Sessão 12). "Martelo do Alvorecer" é invenção desta proposta; **"Martelo da Luz"** é o nome canônico anterior e pode servir como nome da evolução (a arma volta à origem de Bromnor). Decisão do dono.

Domínio Coletivo, Maça Demolidora e Raio da Ruína seguem **provisórios** (sem objeção do dono até agora; sem checagem de lore feita).

## Critérios de aceite

1. `data/weapons.json` tem as 5 evoluções e os 5 blocos `evolve`, todos os `into` e passivas existentes; `tests/test_data.gd` passa.
2. As 10 evoluções anteriores têm resultado idêntico ao de antes (teste de regressão por herói).
3. Cada evolução nova é oferecida no level-up com a arma no nível 5, a passiva e o atributo mínimo; **não** é oferecida faltando qualquer um dos três (teste por evolução).
4. `evolve_hint` mostra o que falta, inclusive o atributo com o valor atual; o selo "pronta para evoluir" da ficha (que hoje só olhava o nível) passa a exigir também o atributo mínimo quando a evolução o pede. A passiva nunca fez parte do selo e não passou a fazer.
5. Nenhuma evolução nova tem `heal` ou `lifesteal`; nenhum valor excede o das evoluções existentes (verificado por `bal_conteudo_novo.gd`).
6. Som: toda evolução nova tem evento `weapon.<id>.fire` no `audio_manifest.json`; `icon_like` válido.
7. Suíte e smoke passam; bot em Nyrelia, Sylas, Bromnor e Leoric (2 fases) sem alarme novo de mortes.
8. Fica **pendente de playtest humano** a sensação das cinco evoluções e dos mínimos; nenhum número é dado como aprovado por métrica.

## Lacunas

| Tipo | Item | Padrão recomendado |
|---|---|---|
| BLOCKING | nenhuma | — |
| RESOLVABLE | Aplicar o mínimo também às 10 evoluções antigas? | Não: só às 5 novas (não muda o que já foi jogado) |
| DEFERRED | Ícones e sons próprios (arte); evoluções de Ampulheta, Vela Sagrada e Machado; as de Arlindo, Erik e Lâmina de Sombra | Depois do playtest do lote 1 |
| DEFERRED | Subir o teto de atordoamento contra chefe (0,6 s) | Decisão própria, fora desta spec |

## Verificação planejada

`tools/bal_conteudo_novo.gd` antes e depois; `tests/run_all.gd`; smoke; `tools/bot_curva.gd` (alarme, não veredito); `tools/audit_projeto.gd`; evidência EVID-243. Sem playtest humano não há afirmação de que ficou divertido ou equilibrado.

## Fora do escopo

Mudar valores de armas ou evoluções existentes; mexer em cura; novas passivas; arte, ícones e sons próprios; commit, push, build ou exportação (cada um com aprovação própria).
