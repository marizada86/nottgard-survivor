---
id: "EVID-180"
title: "B-005: eventos divinos (Altar disputado em Feng-tu e Shedaklah, recompensa god_boon)"
created: "2026-10-06"
relations: ["[[SPEC-129-dinamismo-bencaos-divinas-e-eventos]]", "[[SPEC-118-acontecimentos-exclusivos-por-fase]]", "[[EVID-179-b004-favor-e-rivalidade-2026-10-06]]"]
cards: ["MEC-047", "MEC-038", "MEC-005"]
---

# EVID-180 — B-005 (eventos divinos)

## O que entrou
- **Recompensa nova `god_boon`** em `Happenings._apply_reward`: concede uma **bênção permanente** (a primeira da lista que o herói ainda não tem), com a aura divina do deus como no altar, e ela **conta para o Favor** (B-004). Se o herói já tem todas as bênçãos daquela lista, **não duplica**: cai ouro no lugar.
- **Dois acontecimentos "Altar disputado"** (tipo `pact`, reaproveitando o motor da SPEC-118; `pool: optional`, **somam** aos eventos atuais, decisão D4):
  - **Feng-tu** (aos 170 s): Tou Um × Lu Yueh. *Seguir a Estrela do Norte*: bênção de Tou Um (Guia da Estrela ou Caminho da Estrela) e 6 larvas de Lu Yueh atacam. *Aceitar a praga*: bênção de Lu Yueh (Imunidade à Praga) e a estrela se apaga (−15% de dano por 30 s). Base: `12_Lore/Tou Um e Lu Yueh` (Feng-tu se equilibrava pelo conflito dos dois; Lu Yueh tomou o templo).
  - **Shedaklah** (aos 150 s): Zuggtmoy × Juiblex. *Servir Zuggtmoy*: bênção de Zuggtmoy e 6 slimes de Juiblex atacam. *Servir Juiblex*: bênção de Juiblex e 6 servos de Zuggtmoy atacam. Base: `03_NPCs/Zuggtmoy` e `Juiblex` (Juiblex avança sobre o território de Zuggtmoy).
  - Os dois podem ser **recusados** ("Não tomar partido") sem custo; o cartão resumido mostra a bênção e a consequência antes de aceitar.
- **O que o jogador sente:** escolher um lado dá a bênção e o **Favor** (e, com 2 do mesmo deus, o nível 1), mas **chama a revolta do rival**; aceitar os dois lados em eventos diferentes anula o Favor (B-004).

## Verificação
- `tests/test_divine_events.gd` (novo): dados dos dois eventos (opcionais, bênçãos existentes, os dois deuses oferecidos); abrir o altar com E; recusar sempre existe e não dá nada; a escolha 1 dá 1 bênção do primeiro deus e 6 inimigos do rival; a escolha 2 dá a bênção do segundo deus; sem bênção nova para dar não duplica e cai ouro. **Sanidade:** reduzir o `n` das larvas faz o teste falhar.
- **`tests/run_all.gd`: 0 falhas; `tools/audit_projeto.gd`: 0 erros** (7 avisos antigos).
- Captura real (`tools/shot.gd`, Feng-tu): o HUD mostra "Altar disputado — escolha entre Tou Um e Lu Yueh (E)" e o ponto do evento aparece no mapa; o altar comum mostra as bênçãos novas (ex.: Corpo Gelatinoso).
- `data/stage_events.json`: só duas linhas novas (sem reformatar o arquivo).

## Limites
- **O bot não abre pactos**, então o impacto no equilíbrio **não foi medido**: o que as 6 criaturas rivais fazem na hora (Feng-tu: larvas pequenas; Shedaklah: slimes e servos) e o que a bênção rende só o playtest dirá. A consequência é só os 6 inimigos e, no caso de Lu Yueh, −15% de dano por 30 s: moderada de propósito.
- **Arte provisória:** o ponto do evento usa o losango colorido padrão dos acontecimentos; sem ícone próprio por deus (ART a registrar; o ART-038 já cobre os ícones das bênçãos novas).
- **Não incluído (de propósito):** *Juramento de Lliira como evento* e a *Provação de Xar'gath*; o motor `god_boon` já permite fazê-los depois só em dados.
- Nenhum evento de Shedaklah/Feng-tu já existente foi alterado.

## Reversão
`git revert` do commit do B-005 (código em `core/happenings.gd`, dados em `data/stage_events.json`).
