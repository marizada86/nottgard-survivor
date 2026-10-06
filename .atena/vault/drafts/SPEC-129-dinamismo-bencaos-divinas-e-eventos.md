---
id: SPEC-129
title: Dinamismo da run — bênçãos divinas com dinâmica própria e eventos ligados aos deuses
status: approved-per-batch (2026-10-06); B-001 em execução
origin: pedido-do-dono-2026-10-05 (após T04)
approval: dono, 2026-10-06 — por lote; D1 a D5 como sugeridas (Lliira e Tou Um primeiro; rivalidade só troca o Favor; maldição obrigatória só nas `stat` atuais; eventos divinos somam; Nott depois)
cards: MEC-047, BAL-019, MEC-005, MEC-038
evidence: EVID-163, EVID-165
risk: alto (nova forma de jogar); entrega em lotes pequenos, um deus por vez
plan: PLAN-062 (nível de aprovação ainda não escolhido)
---

# SPEC-129

## Pedido
O dono (2026-10-05): o jogo precisa ser mais **dinâmico**. A direção inclui **bênçãos novas e entidades que concedem**, **eventos**, e seguir o **Vault de Nottgard** para os deuses presentes na campanha e **como cada um funciona**. A análise do Hiago sobre dinamismo não está registrada; o mais próximo é EVID-091 resposta 10 ("mais eventos aleatórios"), IN-014 (T01: "doar item, arma ou habilidade por bênção") e IN-056 (Manzi). Se o dono lembrar o conteúdo, vale registrar como evidência.

## Estado atual (lido no código e nos dados)
- 14 bênçãos em 7 deuses (`data/boons.json`), todas no formato **"+X, mas −Y"** em modificadores numéricos; 11 efeitos extras em `data/boon_effects.json` (poças, barreira, raios, etc.).
- O altar aparece 2 ou 3 vezes por fase (`data/stages.json`, `interactions.altar`) e oferece 3 bênçãos aleatórias; a recusa já existe (SPEC-126, commit 048832e).
- Eventos de fase (SPEC-118) já têm 10 tipos, incluindo `pact`, mas **nenhum entrega bênção de um deus específico**.
- Resultado percebido: bênção é só uma troca de estatística; não muda o que o jogador **faz**.

## Base no Vault (somente leitura; só o marcado "conteúdo-conhecido")
Cada deus tem uma **dinâmica** na lore. A proposta é transformar essa dinâmica na regra da bênção, em vez de só números.

| Deus / entidade | O que o Vault diz (resumo) | Dinâmica proposta para a bênção |
|---|---|---|
| **Sendrinah** | Divindade de Maelor; sua religião foi forte e perdeu espaço para Nott; ligada à estrela (Ailalore) e à vida | **Vida da estrela:** cura que vira barreira, ressurgir; custo: perde força se o herói ficar muito tempo sem se curar |
| **Mask** | Divindade de Sylas e Nyrelia; aura amarela, máscara | **Furtividade:** golpe após esquiva, roubo de moeda; custo: defesa menor |
| **Lliira** | Divindade de Brook; o *Julgamento da Glória* cobra "atos que ofuscam as palavras" e o juramento quebrado | **Juramento:** objetivo condicional (ex.: 60 s sem levar dano); cumprir dá recompensa grande, quebrar dispara **Julgamento** (perde a bênção, sem morte) |
| **Shar** | Deusa que orienta Kayron; padroeira da perda; quer domínio | **Sacrifício:** paga PV ou item para ganhar dano/cooldown em rajada |
| **Tou Um** | Estrela do Norte, guia de Feng-tu: **seguir a estrela** (miragem que não se aproxima) cura quem é fiel; quem segue muito tempo "é derrotado no tempo dela" | **Caminho da estrela:** marcador que se move; andar na direção dele cura; seguir por tempo demais vira desgaste leve |
| **Lu Yueh** | Deus das epidemias; servos que espalham praga ao toque | **Contágio:** dano em área que se espalha entre inimigos; custo: "Doença" no herói (SPEC-118 já tem o debuff em Feng-tu) |
| **Ghaunadaur** | Fome e fusão ("vamos nos tornar um só"), domina por colar e por receptáculo | **Fome:** devora drops e moedas para crescer; custo: perde controle parcial (efeito visual e de dano, nunca inverte comandos) |
| **Nott** | Deusa da noite, padroeira de Nottgard | **Noite:** bônus fora de luz/em fases escuras (a definir com o dono) |
| **Amatsu-Mikaboshi** | Lorde do Caos e do Engano (ilusão) | **Engano:** bênção cujo efeito só aparece após alguns segundos (o tipo "ilusão" da SPEC-118) |
| **Tharizdun** | Quase primordial, "abomina a existência de qualquer outro deus" | **Anulação:** troca uma bênção atual por um poder maior; só como recompensa rara de evento |
| **Graz'zt** | Lorde do Abismo; pacto de sangue ("olhos" no plano material) | **Pacto de sangue:** só em evento `pact` (já há "O convite" em Shendilavri) |
| **Xar'gath, o Testador** | Provação por duelo; cobra "uma alma por dia"; é alimentado | **Provação:** já ligada à Arena do Testador de Durao; bênção de dano ao vencer |

Fora de uso, por decisão de cânone: o que o Vault marca como segredo do mestre ou ainda não revelado (ex.: o colar de Adam e a Síntese; o que Shar pesa na Sessão 24). Não entra texto do jogo sem decisão do dono.

## Regras de dinâmica propostas
1. **Famílias de bênção** (campo novo `kind`): `stat` (as atuais), `oath` (juramento/condição), `cost` (paga para usar), `path` (movimento), `delayed` (engano), `rival` (ver 2). Cada família tem motor próprio, um por vez, dirigido por `data/boons.json`.
2. **Rivalidade divina** (o Vault mostra duplas que se equilibram por conflito): Tou Um × Lu Yueh (Feng-tu), Zuggtmoy × Juiblex (Shedaklah); Sendrinah × Nott (devoção). Regra: aceitar uma bênção de um deus **fortalece o seu favor** e **azeda o do rival**. Efeito mínimo: duas bênçãos do mesmo deus liberam um bônus de **Favor**; aceitar a do rival enfraquece o Favor. Detalhe a decidir (D2).
3. **Altar com dono:** em cada fase o altar mostra o deus da região (Feng-tu: Tou Um ou Lu Yueh; Shedaklah: Zuggtmoy ou Juiblex; outras fases: deuses de herói e de lore), em vez de 3 bênçãos soltas.
4. **Eventos divinos:** acontecimentos que entregam bênção de um deus específico como recompensa (`reward: boon:<god>`), reaproveitando `pact`, `arena`, `rescue` e `escort` da SPEC-118. Ex.: **Altar disputado** (dois altares de deuses rivais; escolher um deixa o outro hostil por 30 s), **Juramento de Lliira** (60 s sem dano), **Peregrinação de Tou Um** (seguir a estrela, já esboçada em Feng-tu).
5. **Escolher sem receber:** SPEC-126 já permite recusar; juramento e provação precisam **aviso claro do custo** antes de aceitar (cartão resumido da SPEC-094).

## Escopo (lotes)
| Lote | Conteúdo | Risco |
|---|---|---|
| **B-001** | **Medir as 14 bênçãos atuais com o bot** (BAL-019): ranking por taxa de vitória e uso; sem mudar código de jogo. Gera EVID | baixo |
| **B-002** | **Motor das famílias** `oath` e `path` + **1 bênção piloto** cada (Lliira: *Juramento*; Tou Um: *Caminho da Estrela*), com testes | alto |
| **B-003** | **Bênçãos novas por deus (2 a 3 por deus)** nas famílias `stat`, `cost`, `delayed`, usando só `data/*.json` e efeitos existentes | médio |
| **B-004** | **Favor e rivalidade** (regra 2), só para as duplas de Feng-tu e Shedaklah | alto |
| **B-005** | **Eventos divinos** (regra 4) em Feng-tu e Shedaklah primeiro; depois replicar | alto |
| **B-006** | **Arte e áudio:** ícone por bênção e visual do altar por deus (registro ART; geração só com aprovação) | — |

Um deus por commit; um teste por família; rodada do bot em cada lote que mexe em números; `tests/run_all.gd` 0 falhas e `tools/audit_projeto.gd` 0 erros.

## Decisões do dono (BLOCKING para o lote indicado)
- **D1 (B-002):** quais deuses entram primeiro? Sugestão: **Lliira (Juramento) e Tou Um (Caminho da Estrela)**, por serem os mais "dinâmicos" e já terem lore e fase própria (Feng-tu).
- **D2 (B-004):** a rivalidade **bloqueia** a bênção rival, **penaliza** ou só **troca o Favor**? Sugestão: só troca o Favor (nunca bloqueia).
- **D3 (B-003):** a "maldição" de cada bênção continua obrigatória? Hoje toda bênção é "+X, mas −Y". Sugestão: manter nas `stat`; as famílias novas trazem custo próprio.
- **D4 (B-005):** os eventos divinos **substituem** os eventos `pact` atuais ou **somam**? Sugestão: somam, com `pool: optional`.
- **D5:** conteúdo de **Nott** (noite) entra agora ou depois, por ainda não ter arte e fase própria?

## Critérios de aceite
- B-001: tabela por bênção (n de runs, vitória, nível médio) em EVID; nenhum código de jogo alterado.
- Por bênção nova: texto no cartão resumido com bênção e custo; teste cobre aplicar, custo e término.
- `oath`: cumprir e quebrar o juramento são determinísticos com semente fixa; quebrar nunca mata o herói.
- Rivalidade: o Favor é visível na ficha `C` (ou no HUD) e some ao reiniciar a run.
- Nenhuma regressão: bênçãos atuais iguais; `boon_skip` intacto; bot não escolhe a recusa por engano.

## Riscos e reversão
Alto no conjunto, baixo por lote (um commit isolado, `git revert`). O principal risco é o balanceamento: bênções com condição podem ficar fortes demais; por isso B-001 vem antes e cada lote tem rodada do bot. Dependência de arte (ícones por deus e por bênção) não bloqueia: começa com os ícones existentes.

## Fora do escopo
Armas, magias e equipamentos novos (MEC-042); NPC de upgrade de magia (MEC-041); Marcas do Abismo (MEC-040); ficha `C` e habilidade ativa (MEC-043 a MEC-045, SPEC-127).
