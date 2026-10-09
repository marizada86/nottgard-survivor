---
id: PLAN-086
title: Arlindo Orlando como herói jogável (rascunho)
status: DRAFT planejado em 2026-10-09; nada executado; aguarda rota (DEV-018), decisões de conteúdo, nível de aprovação e início explícito
approval_mode: unconfigured
route: PLAN_DEVIATION (DEV-018) registrado como adiado, só planejamento; PLAN-083 segue ativo
origin: pedido do dono em 2026-10-09 ("preparar um plano para introduzir personagem Arlindo Orlando (importante na história) vamos colocá-lo como jogável assim como Erik Blackthorn")
---

# PLAN-086 — Arlindo Orlando jogável (rascunho, DRAFT)

Estado: **DRAFT**, sem SPEC ainda (a SPEC nasce quando o dono aprovar o escopo; ids livres: `PLAN-086`, SPEC a partir de `SPEC-160`). Nada de lore nova é canônica até o dono aprovar.

## 1. O que o Vault diz de Arlindo (`03_NPCs/Arlindo Orlando.md`, lido em 2026-10-09)

Fatos dos blocos de **consolidação aprovada** (Sessões 01–09) e das seções de sessão:

- Humano andarilho, **líder dos Greenholders** no Vault (o dono corrigiu o nome de jogo para **Grimholders/Grimhold**; ver §5). Primeiro aparece sentado à margem da via, antes da zona de névoa densa de Dagruve; adverte, não impede à força (S3-34).
- Fala dos cultistas que procuram Adam; é relato indireto, "nunca o viu" (S3-35). **Adam é segredo do mestre/colar: não entra em texto de jogo** (regra de sempre).
- Aponta o cemitério como o ponto mais denso; avisa dos notívagos; muitos dos seus morreram ali (S7-15, S3).
- Usa **Modify Memory** para mostrar a Brook uma memória canônica do Massacre Celestial em Fateridge (S8-11).
- "Pés na mesa", declara-se líder; diz que "aqui era nosso" (S9-37). Alerta Maelor e Kayron sobre o orgulho elfo (S9-39).
- Na S20 parte 2, ausente do QG rebelde: lidera uma força-tarefa na caça aos cultistas restantes de Ghaunadaur.

**Lacuna:** nenhuma sessão nomeia a classe mecânica dele (como no caso do Erik na Nottcard). Pelo que usa (Modify Memory) e como age (informante, negociador, líder de contrabandistas), a hipótese é conjurador de memória ou "face" de bando; **é decisão do dono**, não do Vault.

## 2. Estado do Erik Blackthorn (referência pedida)

- No **Nottcard** (somente leitura) Erik tem ficha jogável (`PERS-erik-blackthorn-ficha-jogavel.md`): Guerreiro, humano, FOR 16 INT 12 CON 13 CAR 10, passiva "Incendiário Procurado".
- No **Nottgard Survivors não existe**: o elenco atual são dez heróis (Durvall, Brook, Maelor, Sylas, Kayron, Korrak, Leoric, Nyrelia, Zynara, Bromnor). Portanto "como o Erik" vale como **padrão** (ficha jogável + passiva da lore); o plano abaixo **não inclui o Erik** a menos que o dono peça (ver decisão D1).

## 3. O que um herói novo exige (mapa pelo caso do Bromnor)

| Camada | Arquivos | Observação |
|---|---|---|
| Dados | `data/heroes.json`, `data/weapons.json`, `data/abilities.json`, `data/hero_bios.json`, `data/barks.json` | atributos, PV, passiva, arma inicial, habilidades, bio e falas |
| Desbloqueio e conquistas | `data/achievements.json`, `unlock` do herói | como os outros (início, conquista ou HQ) |
| HQ e história | `data/hqs.json`, `stage_story`/crônicas | só texto do Vault, sem segredo do mestre |
| Arte | retrato, tiras de animação e variantes (`assets/animations/...`, `ui/hero_view.gd`) | **trilha do dono** (assets): hoje o dono está refazendo a arte dos heróis principais (BUG-029); sem asset aprovado o herói entra com marcador provisório |
| Som | `data/audio_manifest.json` | alias dos eventos de um herói existente até haver som próprio |
| Testes | `tests/test_animation_assets.gd` e os testes de herói/bot | lista de heróis passa a onze; bot por herói (EVID-208 como linha de base) |
| Versão | cartão `MEC-0xx` + `BAL-0xx` | um cartão por mecânica |

## 4. Proposta de lotes (a confirmar depois das decisões)

| Lote | O quê |
|---|---|
| **B-001 Conteúdo** | ficha de Arlindo a partir do Vault: classe, raça (humano), atributos, passiva ligada à lore, arma e habilidades; bio e falas; portão de conteúdo com o dono |
| **B-002 Dados e código** | `heroes.json` e afins, passiva/arma com teste, desbloqueio, conquista |
| **B-003 Arte e som provisórios** | retrato e animação **só com assets aprovados pelo dono**; sem eles, marcador provisório assumido (como os `icon_like`) |
| **B-004 Balanceamento** | bot por herói, 15 sementes, comparado ao EVID-208; ajustes só em JSON |
| **B-005 Fechamento** | HQ ou crônica curta, guia/changelog da versão, verificação, commits com aprovação |

## 5. Divergência de nomes a resolver (Greenhold × Grimhold)

O dono afirmou em 2026-10-09 que **só existem Grimhold e Grimholders**. O Vault (`03_NPCs/Arlindo Orlando.md`, `Erik Blackthorn.md`, `04_Locais/Dagruve.md`) grafa **Greenholders/Greenhold** em vários trechos aprovados, e a Carta de Trégua de 1400 grafa **Grimhold**. O jogo segue o dono (Eco de Dagruve já usa Grimholders); a ficha de Arlindo usará "Grimholders". O Vault é somente leitura aqui: corrigir as páginas fica para o dono.

## 6. Decisões que preciso do dono (portão de conteúdo e de rota)

1. **D1 — Erik:** entra neste plano (dois heróis novos) ou fica para depois? Hoje ele só existe no Nottcard.
2. **D2 — Classe e estilo de jogo do Arlindo:** sugestão de partida (a validar): humano, "face"/conjurador de memória, jogo de suporte e controle (marca inimigos, desacelera, reaproveita Ecos), PV médio; ou outra direção sua.
3. **D3 — Passiva:** ligada à lore (por exemplo, "Memória Modificada": o primeiro golpe em cada inimigo o deixa lento; ou bônus perto de Ecos); você escolhe ou eu proponho três opções com números.
4. **D4 — Desbloqueio:** conquista, HQ ou herói inicial.
5. **D5 — Arte:** esperar a sua arte (recomendado) ou entrar provisório.
6. **D6 — Quando:** este plano **não roda agora**; o PLAN-083 (v0.5.0) segue ativo. Rota: fazer depois do B-004/B-005 do PLAN-083, na 0.6.0, ou outro momento.

## 7. Gates

Sem dependências novas; sem geração de imagens; só lore do Vault (nada de segredo do mestre: Adam, o colar, a Síntese); commit e push só com aprovação explícita; originais e mudanças de outras sessões intactos.
