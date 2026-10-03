---
id: "SPEC-118"
title: "Acontecimentos exclusivos por fase"
status: "rascunho para aprovação do dono (2026-10-03)"
created: "2026-10-03"
relations: ["[[PLAN-055-mapas-vivos-segredos-e-dificuldade-2026-10-03]]", "[[EVID-147-auditoria-vault-x-jogo-2026-10-03]]", "[[SPEC-117-alma-e-historia-na-run]]", "[[SPEC-087-fidelidade-e-eventos-de-risco]]"]
cards: ["MEC-005", "MEC-038"]
---

# SPEC-118 — Acontecimentos exclusivos por fase (PLAN-055 F3)

Origem: T03 (Daniel) e o dono, 2026-10-03: "depois do 3º ou 4º mapa fica
enjoativo". Hoje só Dagruve (2) e Docas (3) têm eventos em
`data/stage_events.json`; as outras **7 fases têm zero**. Os eventos que
existem só soltam uma poça, uma onda ou um elite.

**Rascunho:** nada implementado. O dono aprova, corta ou troca cada linha.

## Objetivo

Toda fase com **2 ou 3 acontecimentos próprios**, sendo **um grande** no meio
da fase, que o jogador reconheça como "coisa desse mapa". Cada um tem:

1. **Aviso** (já existe: `warning_text`, 5 s).
2. **Objetivo opcional** claro (texto curto no HUD + marcador na borda da tela).
3. **Recompensa** se cumprir (baú, bênção temporária, moeda, Eco da SPEC-119).
4. **Consequência** se ignorar (mais inimigos, zona hostil, chefe mais forte),
   nunca morte instantânea.

## Motor: tipos novos em `stage_events.json`

Os quatro tipos atuais (`ritual`, `hazard`, `wave`, `elite`) continuam. Novos,
todos dirigidos por dados, reaproveitando zonas, interações e ofertas que já
existem em `core/battle.gd`:

| Tipo | Como funciona | Reaproveita |
|---|---|---|
| `collect` | Aparecem N objetos no mapa; levar todos a um ponto antes do prazo | pickups + interação `E` |
| `escort` | NPC lento anda de A a B; inimigos miram nele; chegar = recompensa | entidade aliada (base do clone-isca da SPEC-114) |
| `invasion` | Mini-chefe errante atravessa o mapa por X s e vai embora se não morrer | `_spawn_elite` + rota |
| `pact` | NPC/altar oferece 2 ou 3 escolhas de risco e recompensa | estado de oferta do altar (`state == "altar"`) |
| `arena` | Círculo prende o herói com um elite até um dos dois cair | zona `rule_ritual` invertida |
| `rescue` | K civis presos em pontos do mapa; tocar `E` em cada um | interação |
| `map_shift` | A regra ambiental da fase muda até o fim (outra regra, novo chão ou área aberta) | `stage_rule` + regra dos Pilares |

Campos comuns novos: `objective_text`, `deadline`, `reward` (`chest` /
`boon` / `coins` / `echo`), `fail` (`wave:<id>:<n>` / `buff_boss:<pct>` /
`zone`), `once_per_profile` (para eventos de história que não devem repetir
o texto toda run).

## Proposta por fase

Horários relativos à duração atual de cada fase. Fonte de cada um em EVID-147.

| Fase | Acontecimento | Tipo | Objetivo → recompensa / falha | Gancho |
|---|---|---|---|---|
| **Shedaklah** | **O portal sem vão** (grande, ~45 %) | `collect` | Levar 1 esporo de Zuggtmoy e 1 limo de Juiblex ao arco de pedra → baú raro + atalho de cura / os dois opostos explodem em poças | G-SHE-1 |
| Shedaklah | O barqueiro do Estige | `pact` | Pagar moeda ao Reaper → atravessa para uma margem com baú / recusar = nada | G-SHE-3 |
| Shedaklah | Guarnição fúngica | `escort` invertido (aliados) | Soldados de Zuggtmoy lutam ao lado por 45 s (só se D-01 virar "Zuggtmoy aliada") | G-SHE-2 |
| **Molor** | **Ritual de estagnação** (grande) | `escort` invertido | Cultistas carregam caixas de carne até a massa; cada um que chega dá +10 % de PV ao receptáculo; matar todos → baú das barracas de Thullgrime | G-MOL-1, G-MOL-3 |
| Molor | Emboscada na vigília | `wave` | Três gnolls demoníacos de um lado só → matar os três dá bênção curta | G-MOL-2 |
| **Durao** | **Desertores** (grande) | `rescue` + `invasion` | Três desertores fogem; o Molydeus patrulha e os caça. Salvar 2 ou 3 → moeda e bênção radiante / o Molydeus fica e vira elite | G-DUR-1, G-DUR-2 |
| Durao | Arena do Testador | `arena` | Círculo de fogo com um elite; vencer → bênção de dano; fala especial se o herói for Korrak | G-DUR-4 |
| Durao | Vhaerith na jaula | `pact` (`once_per_profile`) | Conversa curta; registra o pedido da runa (cadeia da SPEC-119) | G-DUR-3 |
| **Feng-tu** | **Escolta do peregrino** (grande) | `escort` | Levar João Barbosa até o templo; ele segue a estrela → bênção da estrela (cura forte) | G-FEN-1 |
| Feng-tu | Enxame pestilento | `wave` + regra | Larvas que explodem em pestilência ao morrer, por 30 s | G-FEN-2 |
| Feng-tu | Peregrinação | debuff de fase | Depois do elite do Discípulo, "Doença" (−20 % de dano); andar 40 m na direção da estrela cura | G-FEN-4 |
| **Shendilavri** | **O convite** (grande) | `pact` | Aceitar o convite de Malcanthet: encantamento de 8 s (lentidão + controles confusos) e depois baú raro / recusar = onda de guardas | G-SHN-2 |
| Shendilavri | Mercador de Rivenheart | `pact` | Itens baratos; 1 em 3 é ilusão sem efeito (revelado ao sair) | G-SHN-1 |
| Shendilavri | Vítimas drenadas | `rescue` | Libertar 4 enfeitiçados → Irmãs Radiantes lutam 30 s ao lado | G-SHN-3, G-SHN-5 |
| **Goranthis** | **Do trono ao lodo** (grande, ~60 %) | `map_shift` | O paraíso cai: chão vira carne, santuários param de curar, inimigos +15 % de velocidade até o fim; aviso forte | G-GOR-5 |
| Goranthis | A luz prateada | `pact` | Pegar tudo (maldição: −10 % de PV máx. na fase) ou um item escolhido (bênção) | G-GOR-2 |
| Goranthis | O nome dito três vezes | evento de chefe | Se o herói tiver o Anel de Graz'zt, Graz'zt entra por 10 s na luta contra Socothbenoth | G-GOR-4 |
| **Pilares** | O elevador do Castelo da Fome | `map_shift` cíclico | A cada 90 s, o chão "sobe": quem não estiver num pilar leva queda (atordoa 1 s) | G-PIL-1 |
| Dagruve | Os que esperam | `rescue` | Moradores desorientados na névoa; proteger 3 → bênção | G-DAG-2 |
| Docas | O navio do ritual (grande) | `collect` invertido | Destruir 3 focos do ritual autossustentável antes da invocação → sem elite extra | G-DOC-2 |

Os eventos de Dagruve e Docas são **troca** opcional dos atuais, para o início
também ganhar cara de "mapa vivo"; não aumentam a dificuldade inicial
(BAL-015).

## Aleatoriedade

Para não ficar previsível na 2ª run: cada fase tem um **grande fixo** e
**sorteia 1 ou 2** dos menores (semente da run). O horário varia ±15 %.

## Arte e áudio

Cada tipo novo precisa de **um marcador de objetivo** (ícone + seta de borda)
e um som de aviso; NPCs (João, desertores, Irmãs, civis) podem começar com
sprites existentes recoloridos. Gera um `ART-nnn` por NPC só depois da
aprovação.

## Testes

- `tests/`: cada tipo novo dispara, conclui e falha de forma determinística com
  semente fixa.
- Bot (`tools/bot_curva.gd`): conferir que nenhum evento dobra a taxa de morte
  da fase (alarme, não veredito).
- Playtest com T03.

## Pendência achada ao escrever

- **Docas:** o evento `copias_do_guardiao` está em `at: 400`, mas a fase dura
  300 s (BAL-011). Ele só dispara se a luta com o chefe passar de 100 s. Se a
  intenção era a cópia antes do chefe, mover para ~225 (cartão de bug).
