---
id: "SPEC-160"
title: "Arlindo Orlando e Erik Blackthorn como heróis jogáveis"
status: "IMPLEMENTADA com arte provisória e publicada (d83c106, EVID-219); arte própria (ART-045) e decisão do BAL-027 (manter) pendentes de playtest"
origin: planned
implementation_preceded_spec: false
request_classification: PLAN_DEVIATION
created: "2026-10-09"
relations: ["[[PLAN-086-arlindo-orlando-jogavel-2026-10-09]]", "[[SPEC-157-segredos-nas-outras-fases-v0-5-0]]", "[[SPEC-148-lancamento-da-v0-4-0]]"]
cards: ["MEC-062", "MEC-063"]
---

# SPEC-160 — Arlindo Orlando e Erik Blackthorn jogáveis

Pedido do dono (2026-10-09): "introduzir personagem Arlindo Orlando (importante na história), jogável, assim como Erik Blackthorn". Decisões do dono no mesmo dia: **os dois entram no mesmo plano**; Arlindo é de **suporte e controle**, com a passiva **Olhos de Andarilho**, desbloqueado pela conquista **Ecos de Dagruve**. Os dois entram na **0.4.0** (sem trocar de versão). Fontes de lore: Vault `03_NPCs/Arlindo Orlando.md` e `Erik Blackthorn.md` (blocos aprovados, sem segredo do mestre) e a ficha jogável do Erik no Nottcard (`PERS-erik-blackthorn-ficha-jogavel.md`, somente leitura). Nome dos Grimholders: o dono corrigiu o jogo para **Grimhold/Grimholders**; o Vault ainda diz Greenholders (corrigir lá é do dono). **Aviso:** o herói Nyrelia já traz "Greenholders" no título (`data/heroes.json`); entra na correção de nomes, em decisão à parte.

## Heróis (propostas em DRAFT; números a medir com o bot)

| | **Arlindo Orlando** | **Erik Blackthorn** |
|---|---|---|
| Papel | suporte e controle (dono) | combatente de dano físico e fogo (Nottcard: Guerreiro) |
| Título | Humano · Líder dos Grimholders | Humano · Batedor dos Grimholders |
| Atributos (proposta) | FOR 10, INT 13, CON 14, CAR 15 | FOR 16, INT 12, CON 13, CAR 10 (ficha do Nottcard) |
| PV base / armadura | 34 · CA 2, CAM 0 | 38 · CA 4, CAM −1 |
| Passiva | **Olhos de Andarilho** (dono): Ecos e câmaras brilham de mais longe (pista ×1,5) e cada Eco dá um pouco de XP; valor a medir | **Incendiário Procurado** (Nottcard, adaptada): dano de fogo e de área +15% |
| Arma inicial | **Memória Alterada**: magia de alvo único que deixa o inimigo **lento** por pouco tempo | **Tocha do Incendiário**: golpe corpo a corpo de fogo em cone |
| Habilidade ativa | **Modify Memory** (da lore): inimigos num raio de ~4 tiles **esquecem o herói** (perdem os ataques por ~2 s), recarga ~18 s | **Navios em Chamas** (gancho do EVID-147): zona de fogo no chão por ~8 s que fere os inimigos, recarga ~16 s |
| Desbloqueio | conquista **Ecos de Dagruve** (dono) | conquista **Ecos de Docas** (proposta: ele incendiou navios nas Docas) |

Textos (bio e 3 falas de entrada, chefe e vida) saem **só dos fatos dos blocos aprovados** do Vault; nada de Adam, do colar, da Síntese nem de cânone do mestre. Arlindo: Dagruve, névoa, orgulho elfo, "aqui era nosso". Erik: Amuleto da Luz, imunidade à névoa, Lâmina da Digestão, cabeça raspada para não ser reconhecido.

## O que muda (por hero)

1. **Dados:** `data/heroes.json`, `data/weapons.json` (arma inicial), `data/abilities.json` (ativa), `data/hero_bios.json`, `data/barks.json`, `data/achievements.json` (desbloqueio e `bio_<herói>`), `data/audio_manifest.json` (`hero.<id>.active` por alias de um herói existente até haver som próprio).
2. **Código mínimo:**
   - Olhos de Andarilho: o `Battle._update_ecos` e o brilho do Eco leem `eco_pista` multiplicado por um mod do herói; XP por Eco como bônus único.
   - Habilidades novas: um `kind` para "esquecer" (reaproveitando a lógica de Domínio da Vontade) e um para a zona de fogo, se os existentes não servirem; arma lenta e de fogo pelos tipos já existentes.
3. **Arte provisória (decisão do dono pendente, G3):** hoje a animação de um herói vive em `assets/animations/heroes/<id>/` e nas tabelas de `ui/hero_view.gd`. Proposta: campo opcional **`art_like`** em `heroes.json` (como `icon_like` nos itens): o herói usa o conjunto de animações de outro até a arte própria chegar, com marca "arte provisória" na seleção. Sem isso os dois só entram quando houver sprites aprovados.
4. **Testes:** um teste por herói (dados, passiva, arma, ativa, desbloqueio), `tests/test_animation_assets.gd` com a lista de doze, bot por herói, bio e conquista.

## Não objetivos

Arte nova gerada (o limite diário de imagens é do dono; a arte é da trilha dele); HQ nova; mudar os dez heróis existentes; segredos do mestre; exclusividade do Arlindo ou do Erik em fases.

## Gates e riscos

- **Portão de conteúdo (independe do nível de aprovação):** números, textos e a escolha dos nomes das armas e habilidades voltam ao dono antes do código.
- **Arte:** sem sprite próprio, só com `art_like` provisório, e só se o dono aprovar G3.
- **Balanceamento:** a bateria do bot hoje é distorcida pela névoa de borda (SPEC-158, outra sessão; EVID-217); a medição dos dois heróis novos deve usar a mesma regra de comparação (com e sem a faixa).
- **Mistura de sessões:** `core/battle.gd`, `core/happenings.gd` e `ui/hero_view.gd` têm mudanças não commitadas de outras sessões; commits só dos trechos desta tarefa.
- **Commit e push:** só com aprovação explícita; push publica o `latest`.

## Critérios de aceite

1. Os dois heróis existem, aparecem na seleção bloqueados e liberam pelas conquistas certas; passiva, arma e ativa funcionam e têm teste (com mutação).
2. Olhos de Andarilho muda de fato o alcance do brilho e o XP do Eco, só para o Arlindo.
3. Bot por herói (doze heróis) sem anomalia de sobrevivência em relação aos dez atuais, com a regra da névoa de borda explícita.
4. Suíte, smoke, `kit_test` e `audit_projeto` sem falhas novas.
5. Bio e falas só com fatos aprovados do Vault; o nome do grupo é Grimholders.
6. Documentos da 0.4.0 (RELEASES, changelog, guia, questionário) refeitos com os dois heróis; push e aviso só com aprovação.

## Lacunas

| Id | Lacuna | Classe | Tratamento |
|---|---|---|---|
| G1 | Números, nomes de arma e ativa, passiva do Erik, desbloqueio do Erik | NON_BLOCKING | Propostas acima; o dono aprova ou ajusta no portão de conteúdo |
| G2 | Falas e bios dos dois | NON_BLOCKING | Escritas depois do portão, a partir do Vault |
| G3 | Arte provisória (`art_like`) ou esperar sprites | NON_BLOCKING | Decisão do dono; padrão recomendado: `art_like` provisório, para poder testar já |
| G4 | "Greenholders" no título da Nyrelia | NON_BLOCKING | Correção à parte, com o Vault; não faz parte deste plano |

Zero lacunas `BLOCKING`.
