---
id: "SPEC-148"
title: "Lançamento da v0.4.0 (Major): consolidar o que existe e entregar conteúdo novo"
status: "PLANEJADA em 2026-10-08 (PLAN-081); aguarda início explícito; nada executado"
origin: planned
implementation_preceded_spec: false
request_classification: PLAN_DEVIATION
created: "2026-10-08"
relations: ["[[SPEC-119-segredos-ecos-e-mapa-maior]]", "[[SPEC-141-marcas-do-abismo-entrega-1]]", "[[SPEC-143-marcas-do-abismo-entrega-2]]", "[[SPEC-142-balanceamento-da-economia-de-ouro]]", "[[SPEC-147-correcoes-dos-playtests-v032-e-v033]]", "[[SPEC-132-lettering-e-cursor-do-jogo]]", "[[EVID-147-auditoria-vault-x-jogo-2026-10-03]]"]
cards: ["MEC-039", "MEC-041", "MEC-042", "MEC-040", "BAL-023", "BAL-018"]
---

# SPEC-148 — Lançamento da v0.4.0

Pedido do dono (2026-10-08): "atena, vamos fazer um plano para trabalhar para lançar a v0.4.0". Pela regra de tipos de [RELEASES](../backlog/RELEASES.md) é um **Major-update**: leva changelog em PDF, guia fácil e questionário novo (007), e sai de um `PLAN` aprovado.

## Situação de partida (lida em 2026-10-08)

| Fato | Fonte |
|---|---|
| Última versão **publicada**: 0.3.1. A 0.3.2 e a 0.3.3 existem só como `.exe` local; `HEAD` ainda marca 0.3.2 em `core/version.gd` e a 0.3.3 está na árvore suja | `RELEASES.md`, `git diff core/version.gd` |
| `main` = `origin/main` = `94a6a2f`; push na `main` republica o release `latest` | `git status`, memória "push publica a build" |
| Já commitado e publicado, mas sem playtest: Marcas do Abismo (`78c6f39`, `1144155`), diagnóstico do BUG-028 (`525cd25`), PLAN-080 (BUG-034 a 037, MEC-053 a 057, BAL-024; `531d1eb` a `b89960d`) | `plan.yaml` |
| Só na árvore de trabalho (56 itens, várias sessões): economia de ouro (PLAN-075), F7/ZIP (PLAN-078), esqueleto de lettering e cursor (PLAN-065), pacote Durvall/Caio (PLAN-079), versão 0.3.3, `export_presets.cfg`, specs, evidências e estados | `git status` |
| Bugs: P0 = 0; P1 abertos = 4 (BUG-027, BUG-028, BUG-029, BUG-033); 14 implementados aguardando playtest; 8 verificações manuais pendentes | hook de sessão, `BUGS.md` |
| Aceite físico pendente: Xbox/PlayStation (MEC-052), celular (MEC-049), ranking (PLAN-071) | `MECANICAS.md`, `plan.yaml` |

## Decisões do dono (2026-10-08)

| Tema | Decisão |
|---|---|
| Tipo | Major (0.4.0), com PDF, guia fácil e questionário 007 |
| Escopo | **Consolidar + conteúdo novo** |
| MEC-039 | **Fatia piloto:** Ecos, pontos de interesse, aba de Ecos no Diário e 1 relíquia em 3 fases (Shedaklah, Molor, Durao), com mapa 84×84 só nelas |
| MEC-041 + MEC-042 | NPC de upgrade de magia (o ferreiro deixa de melhorar magias) + **3 armas/magias novas** + **6 equipamentos**. **Emenda 2026-10-08 (portão de conteúdo, `IN_PLAN`):** aprovado como recomendado, evolução só para a Bola de Fogo e o Romper Armadura, e **7 equipamentos**: o Coração da Dominância entra por pedido do Manzi, via dono |
| Arte pendente | **Não trava** o lançamento: sai provisória e marcada; arte aprovada até o fechamento entra |
| Aprovação | **Por plano** (uma aprovação para o escopo). Commit, push, exportação e publicação seguem exigindo aprovação explícita (`add.yaml`) |
| Rota | Planejar agora; PLAN-071 preservado e retomado em B-006/S-011 depois |

## Escopo

### A. Higiene e linha de base (sem mudar o jogo)
1. Triar a árvore suja em seis grupos, cada um com seu commit: **G1** ouro (BAL-023), **G2** F7/ZIP, **G3** lettering e cursor (código, sem arte), **G4** diagnóstico e pacote Caio (BUG-028), **G5** documentos Atena (estados, specs, evidências, rascunhos), **G6** versão (`core/version.gd`, `export_presets.cfg`; fica por último, no fechamento).
2. Arquivos compartilhados entre grupos (`core/battle.gd`, `core/playtest.gd`, `tests/`) são separados por trecho. Como `git add -p` é interativo e não roda aqui, o trecho é montado a partir do `HEAD` e gravado no índice (`git hash-object` + `git update-index`), método já usado no commit `94a6a2f`.
3. Verificar em **cópia limpa do `HEAD`** (como no PLAN-080) que a suíte passa sem depender de arquivos não commitados.
4. Rodar `backlog_check` e registrar a lista de bugs abertos.

### B. Bugs e verificação
5. Suíte completa, smoke das nove fases e `tools/kit_test.gd` sobre a árvore já separada; qualquer falha nova vira bug.
6. Reteste do BUG-033 (botão Jogar com controle) e das 8 verificações manuais (BUG-003 a 010) em uma run real, quando o dono puder; o que não for visto entra em "O que testar".
7. **Fora do escopo, listados como "Conhecidos":** BUG-027 (costas ao andar para cima), BUG-028 (patinar), BUG-029 (pixels soltos), BUG-022 (HQ). Se o especialista Caio devolver uma correção do BUG-028 antes do fechamento, ela entra como minor-fix com teste.

### C. Arte e áudio provisórios
8. Integrar, com fallback, o que o dono aprovar até o fechamento: lettering e cursor (ART-036/037, [SPEC-132](SPEC-132-lettering-e-cursor-do-jogo.md) B-003/B-004), ícones das bênçãos novas (ART-038), ícone de Eco e do NPC de magia. O que faltar usa o visual atual e vai para a caixa "Isto é provisório" do changelog.

### D. Mecânicas novas (uma spec, um teste e um commit por mecânica)
9. **MEC-041 NPC de upgrade de magia.** Evento próprio que melhora magias (`kind` `nova`, `bolt` etc.); o ferreiro passa a melhorar só armas corpo a corpo e equipamentos. Decisão E10 (2026-10-04): entra na próxima major. Spec filha: **SPEC-149** (número a conferir no início).
10. **MEC-042 conteúdo novo.** 3 armas ou magias novas, cada uma com níveis e evolução em `data/weapons.json`, e 6 equipamentos em `data/items.json`, com lore do Vault (os 29 itens e documentos do Vault ainda fora do jogo, [EVID-147](../evidence/EVID-147-auditoria-vault-x-jogo-2026-10-03.md) §4). Um commit por item; o bot mede cada arma antes e depois. Specs filhas: **SPEC-150** (armas e magias) e **SPEC-151** (equipamentos).
11. **MEC-039 fatia piloto.** Resumo da [SPEC-119](SPEC-119-segredos-ecos-e-mapa-maior.md) restrito a Shedaklah, Molor e Durao: 84×84 (`tools/enlarge_stage_maps.gd`, `tools/rebalance_stage_props.gd`, `tools/bake_ground.gd`), 3 a 4 pontos de interesse por fase em `data/level_design.json` ou `data/scenery.json`, 3 a 5 Ecos por fase, aba "Ecos" no Diário do Quartel e 1 relíquia por fase. Posição fixa por fase, sem consumir a RNG da batalha. Spec filha: **SPEC-152**.
12. **Portão de conteúdo (independe do nível de aprovação):** a lista final das 3 armas/magias, dos 6 equipamentos, dos textos dos Ecos e das relíquias volta ao dono **antes** de entrar no código. Os Ecos seguem a regra da SPEC-119: paráfrase curta do Vault com `fonte_vault`, e nada de "cânone do mestre" (segredos que o grupo não sabia) sem decisão do dono.

### E. Balanceamento
13. Nova linha de base do bot por herói depois do conteúdo (compara com EVID-110, 142, 144, 160 e 193); ajustes só de números em JSON, uma alavanca por vez, antes → depois anotado.
14. Conferir a meta de ouro com `gold_src` (BAL-023) nos arquivos de estatística dos testers, se houver; senão registrar "sem dado novo".

### F. Fechamento e lançamento
15. `VERSION` e `file_version`/`product_version` para **0.4.0** no mesmo commit; `RELEASES.md` ganha a seção 0.4.0, a linha em "Histórico" e absorve as seções "Aguardando versão", 0.3.3 e 0.3.2 (como a 0.2.3 absorveu a 0.2.1).
16. **Changelog 0.4.0 em PDF** (de 0.3.1 para 0.4.0, modelo em `changelogs/CHANGELOG-0.3.0.html`, regras de `changelogs/README.md`), **guia fácil 0.4.0** (atualizar versão, teclas conferidas em `core/game.gd` e `core/playtest.gd`) e **questionário rápido 007** com mapa pergunta → cartão.
17. Exportar o `.exe` em `build/` **a partir de um commit limpo**, com o hash no rodapé (diferente da 0.3.2 e da 0.3.3, exportadas de árvore suja).
18. Push na `main` (publica o `latest`) e aviso aos testers: **só com aprovação explícita à parte**, depois de o dono ver o `.exe` e o PDF.

## Não objetivos

BUG-027, BUG-028, BUG-029; mudança global de dificuldade fora do bot e do JSON; relíquias e Ecos nas outras seis fases; geração de imagens (a cota e a aprovação são do dono, trilha separada); mecânica de risco alto não listada; dependências novas.

## Lacunas

| Id | Lacuna | Classe | Tratamento |
|---|---|---|---|
| G1 | Quais 3 armas/magias e 6 equipamentos | NON_BLOCKING | Proposta do Vault apresentada no portão do item 12; nada é codificado antes da resposta |
| G2 | Textos dos Ecos e relíquias de cada fase piloto | NON_BLOCKING | Mesmo portão; rascunho já existe na SPEC-119 §3 e §4 |
| G3 | O aceite físico (Xbox, celular, ranking) trava a versão? | NON_BLOCKING | Padrão assumido: **não trava**; entra em "O que testar". O dono pode mudar |
| G4 | Perfil de build do `.exe` (QA, playtest público) | NON_BLOCKING | Igual ao da 0.3.x (`export_presets.cfg`); confirmar no fechamento |
| G5 | Custo de 84×84 em desempenho no `.exe` | NON_BLOCKING | Medido na verificação de MEC-039; se cair de 60 fps de forma visível, a fatia reduz para 72×72 |
| G6 | Quantas semanas/datas | NON_BLOCKING | Sem data fixada; o plano é por lotes e termina quando os critérios batem |

**Zero lacunas `BLOCKING`.**

## Critérios de aceite

1. A árvore de trabalho não tem mais mudanças não registradas: cada grupo G1 a G5 foi commitado com aprovação, ou o dono decidiu descartar ou adiar de forma registrada.
2. Em cópia limpa do `HEAD` final: suíte completa sem falhas, smoke das nove fases, `kit_test` e testes novos passando.
3. MEC-041: o ferreiro não oferece upgrade de magia; o NPC novo oferece, com preço, rerrolagem e "Sair" sem custo; marcas e bênçãos não quebram; teste cobre os dois lados.
4. MEC-042: cada arma, magia e equipamento novo tem teste, evolução ou sinergia onde se aplica, ícone (ou fallback marcado) e linha de balanceamento do bot.
5. MEC-039: nas três fases piloto o mapa é 84×84 sem queda visível de desempenho; cada fase tem os Ecos, os pontos de interesse e a relíquia definidos; tocar um Eco pausa ≤ 2 s e grava o texto no Diário; teste de dados verifica `fonte_vault` e a lista de termos proibidos.
6. Bot por herói: nenhum herói com regressão maior que a do EVID anterior sem decisão registrada.
7. `core/version.gd`, `export_presets.cfg`, rodapé do jogo e título do release dizem 0.4.0.
8. Changelog PDF (3 a 4 páginas A4, sem jargão interno), guia fácil e questionário 007 gerados, abertos e conferidos página a página.
9. `.exe` exportado de commit limpo e testado: abre, joga uma fase e mostra o hash.
10. `backlog_check.ps1` rodado antes de exportar e antes de commitar; `RELEASES.md`, `INBOX.md`, cartões e `plan.yaml` reconciliados; EVID com os resultados.
11. Push e aviso aos testers só depois de aprovação explícita.

## Riscos

- **Mistura de sessões:** vários grupos tocam `core/battle.gd` e `core/playtest.gd`. Mitigação: separar por trecho a partir do `HEAD`, conferir `git diff --cached` antes de cada commit e nunca usar `git checkout` ou `reset` sobre arquivos sujos.
- **Push publica a build:** cada push na `main` troca o release `latest`. Mitigação: um único push no fechamento, depois da aprovação.
- **Escopo grande:** três mecânicas, nove itens de conteúdo e a limpeza da árvore. Mitigação: lotes independentes; se o MEC-039 estourar, a fatia piloto cai para uma fase ou sai da versão por decisão do dono (item 12).
- **Lore:** Ecos e relíquias usam material do Vault. Mitigação: portão de conteúdo e teste de termos proibidos.
- **Bot não explora e não mede Ecos:** o efeito do MEC-039 só aparece em playtest humano (SPEC-119 §6).
- **Versões puladas:** quem jogou a 0.3.2 ou 0.3.3 local (Manzi, Daniel) vê o changelog de 0.3.1 → 0.4.0 e as correções do PLAN-080 como "problemas consertados".
