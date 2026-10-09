# RELEASES — quadro de versões de playtest

Cada versão é um **pacote de conteúdo para testar**. Decisão do dono
(2026-09-29): playtesters se empolgam mais quando a build traz **variedade de
conteúdo para experimentar**, então uma versão de playtest pode juntar várias
mecânicas, arte e correções. Isso substitui o limite antigo de "2 mecânicas por
lote" (ver [README](README.md)).

O que continua valendo, para poder desfazer sem perder o resto:
- uma spec, um teste e **um commit por mecânica** (nunca misturar com arte ou bug-fix);
- o bot de balanceamento quando a mecânica mexe em números;
- todo item novo entra na lista "O que testar" da versão (abaixo), que também
  alimenta o próximo questionário.

## Tipos de atualização: Minor-update e Major-update

Decisão do dono (2026-09-30). Toda versão publicada é de um dos dois tipos, e o tipo
define o número, o que entra e o que se entrega aos testers.

| | **Minor-update** | **Major-update** |
|---|---|---|
| Serve para | Manter a build saudável entre playtests | A grande atualização, depois de coletar o relatório dos testers |
| Conteúdo | Bugfixes gerais, balanceamentos pequenos (só números em JSON), ajustes pequenos de texto/UI/arte | Mecânicas novas, eventos, sistemas, telas, conteúdo e arte grande; junta correções e ajustes que vieram junto |
| Número | Último dígito: `0.2.0` → `0.2.1` → `0.2.2` | Dígito do meio: `0.2.x` → `0.3.0` (volta o último a zero) |
| Origem | Bug do [BUGS](BUGS.md), cartão pequeno do [BALANCEAMENTO](BALANCEAMENTO.md) ou de [ARTE](ARTE.md) | Relatório dos testers triado (INTAKE) e plano `PLAN-nnn` aprovado |
| Entrega aos testers | Notas curtas no aviso do Discord (lista de 3 a 8 linhas). **Sem PDF, sem questionário novo** | **Changelog em PDF** + questionário rápido novo |
| Não pode conter | Mecânica nova, regra nova, mudança de dificuldade global | — |
| Risco | Baixo: `git revert` isolado por commit | Médio/alto: um commit por mecânica (regra acima) |

**Como decidir o tipo:** se o tester precisa **aprender algo novo** para jogar (tecla, tela,
regra, evento), é **major**. Se ele só percebe "isso parou de dar problema" ou "está um
pouco mais fácil/difícil", é **minor**. Se um minor crescer até exigir explicação, vira major.

**Fluxo do major:** relatório dos testers → INTAKE → triagem → `PLAN` → implementação por
trilha (bugs → arte → mecânicas → balanceamento) → suíte + smoke + bot → versão em
`core/version.gd` e `export_presets.cfg` → **changelog PDF** (guia e modelo em
[changelogs/README.md](changelogs/README.md)) → push → aviso aos testers.

**Fluxo do minor:** bug ou ajuste → commit → suíte + smoke → versão (último dígito) →
push → aviso curto. Sem plano novo, sem PDF. A tabela de conteúdo da versão ganha uma
linha em "Histórico" (abaixo).

## Estados de uma versão

`planejada → em preparação → publicada (playtest) → avaliada`

Avaliada = as EVID dos testers foram triadas. Só então os cartões "aguardando
playtest" viram verificados ou reabertos.

## Aguardando versão (sem build)

Nada: tudo o que estava aqui entrou na [0.4.0](#versão-040--major-update-pronta-publicação-pendente).

## Versão 0.4.0 — Major-update, publicada (aviso aos testers pendente)

Plano [PLAN-081](../vault/drafts/PLAN-081-lancamento-da-v0-4-0-2026-10-08.md) / [SPEC-148](../specs/SPEC-148-lancamento-da-v0-4-0.md). **Absorve a 0.3.2 e a 0.3.3** (só existiram como `.exe` local; ficam como histórico, abaixo) e tudo o que estava em "Aguardando versão". Changelog do tester: **0.3.1 → 0.4.0** ([CHANGELOG 0.4.0](changelogs/CHANGELOG%200.4.0%20-%20Nottgard%20Survivors.pdf), fonte [HTML](changelogs/CHANGELOG-0.4.0.html)), [GUIA FACIL 0.4.0](changelogs/GUIA%20FACIL%200.4.0%20-%20Nottgard%20Survivors.pdf) e [QUESTIONARIO Rápido - 007](questionarios/QUESTIONARIO%20R%C3%A1pido%20-%20007.pdf) (mapa em [QUESTIONARIO-007](questionarios/QUESTIONARIO-007-v0.4.0.md)). `0.4.0` em `core/version.gd` e `export_presets.cfg`. Evidências: EVID-202 a 208 e o EVID final do B-008.

**Conteúdo novo desta major (um commit por mecânica):** Arcanista (MEC-041), Bola de Fogo, Lâmina de Sombra e Romper Armadura com duas evoluções e sete equipamentos únicos, entre eles o Coração da Dominância (MEC-042), e a fatia piloto de segredos com mapa 84×84, Ecos, câmaras e relíquias em Shedaklah, Molor e Durao (MEC-039, MEC-012). Arte e som desses itens são **provisórios** (ART-042, ART-043, ART-006).

### O que testar (0.4.0)

1. **Marcas do Abismo** (Quartel → Marcas): nove marcas, cada uma liberada por uma conquista; − e + escolhem o nível; efeito na run inteira.
2. **Ouro:** o ganho no Quartel ficou menor nas fases finais; a venda de peças vale só na run; o Chicote Avarento rende pouco. A primeira compra no Quartel chega em até duas runs?
3. **Arcanista:** evento novo que melhora **magias**. O **ferreiro** agora melhora só **armas e equipamentos**. Dá para entender quem faz o quê?
4. **Armas e magias novas:** Bola de Fogo, Lâmina de Sombra e Romper Armadura (e as evoluções Tormenta de Fogo e Esmagar Defesas) aparecem no level-up? Parecem fortes ou fracas demais?
5. **Equipamentos únicos novos:** Cajado da Família Infernum, Wave of Terror, Colar de visão verdadeira, Detector Arcano, Dispositivo Antimagia de Gilly, Dispositivo das Docas e **Coração da Dominância** (concede a magia Domínio da Vontade).
6. **Mapas maiores com segredos** (Shedaklah, Molor e Durao, 84×84): Ecos de Nottgard (brilham de perto; texto vai ao Diário), ruína com baú, covil com elite que acorda, câmara selada com **relíquia**. Vale a pena explorar? Os mapas ficaram vazios demais?
7. **Diário → Ecos:** cada fase mostra "Ecos n/4" e a relíquia; conquista "Ecos de <fase>".
8. **Ficha C:** C abre e fecha; mostra próximo nível e evolução das armas; bônus com o nome antes do valor.
9. **HUD:** nada sobreposto no topo; quests em destaque com realce no mundo; indicador do Estige; o bloco de notas (F5) prende o foco.
10. **Primeiro baú** só aos 45 s; a arma base não volta como "NOVA" depois de evoluir.
11. **Bênçãos:** Juramento de Lliira, Caminho da Estrela e as outras novas; Favor e rivalidade; recusar a bênção.
12. **Curas mais fracas** (Vela Sagrada, Regeneração, Machado de Xar'gath): ainda dá para ficar imortal?
13. **Controles:** Xbox e PlayStation (ícones, mapa Padrão/Legado, L1/LB e R1/RB nas abas) e **toque no celular** (ainda em teste de aparelho).
14. **Ranking** na tela inicial (carrega ao abrir a aba) e **F7** (reúne as evidências num ZIP ao lado do executável).
15. **Verificações pendentes** (reteste dispensado em 2026-10-08): fechar a ficha com C e Esc; loja, ferreiro e curandeiro com "Sair"; equipar ou vender item; quebráveis (drop, respawn, poção só de elite); segurar o clique para andar; nível de equipamento; sinergias arma + acessório + magia.

**Conhecidos (não precisa reportar):** heróis patinam ao andar de lado (BUG-028); Zynara, Leoric e Nyrelia aparecem de frente ao andar para cima (BUG-027); pixels soltos nos heróis (BUG-029); HQ da Peregrinação com o braço do Korrak fundido ao machado (BUG-022); ícones e sons de itens, Ecos e câmaras são provisórios.

### Fechar a versão (checklist)

- [x] Suíte, smoke e bot por herói (EVID-208)
- [x] `VERSION` e `file_version`/`product_version` em 0.4.0 no mesmo commit
- [x] Esta seção e a tabela de histórico; `backlog_check` sem alertas
- [ ] `.exe` local exportado de commit limpo (**não feito**: o `.exe` dos testers é o do CI; exportar só se o dono pedir)
- [x] Push na `main` em 2026-10-08 (`94a6a2f..aa496f2`); release `latest` = *Playtest v0.4.0 (aa496f2…)*, pré-release ([EVID-209](../evidence/EVID-209-b008-publicacao-da-v0-4-0-2026-10-08.md))
- [ ] Aviso aos testers com os três PDFs (changelog, guia fácil e questionário 007): **ação do dono**; antes, conferir que o rodapé do jogo baixado diz 0.4.0

### Detalhe de itens que vinham como "Aguardando versão"


#### Marcas do Abismo (MEC-040, SPEC-141 e SPEC-143, PLAN-074 e PLAN-076)

1. **Liberação por conquista:** cada marca nasce bloqueada; a aba **Marcas** mostra, em cada uma, a conquista que falta e a condição (por exemplo "Marca do Abismo: Horda: derrote 1.000 inimigos"). Ao ganhar a conquista, só aquela marca libera, em qualquer fase. Conferir as nove: Carapaça (chefe de Dagruve), Pressa (10 min numa run), Horda (1.000 abates), Elites despertos (25 elites), Fúria (50 abates seguidos sem dano), Abismo vivo (4 fases), Fome (nível 20), Chefe desperto (3 chefes) e Sem trégua (4 chefes numa run).
2. **Escolha:** na aba Marcas, − e + em cada uma das nove marcas (0 a 3; Sem trégua só 1), com mouse, controle e toque; o total e o bônus de moeda (+10% por ponto) atualizam; a escolha continua depois de fechar o jogo. Na aba Jogar, a fase mostra o resumo ("Marcas do Abismo: nível N...").
3. **Efeito na run:** o selo roxo "Marcas N" aparece na HUD (passe o mouse para ver a lista). Horda: mais inimigos ao mesmo tempo. Fúria: golpes doem mais. Carapaça: inimigos e chefe com mais PV. Pressa: inimigos mais rápidos. Fome: toda cura rende menos (nível 3 = 25% da cura). Elites despertos: elites com mais afixos (e 1 elite extra por minuto no nível 3). Chefe desperto: chefe com mais PV e uma fase extra a 15% de PV. Abismo vivo: a regra do andar (rituais, poças, raios) acontece mais vezes. Sem trégua: nenhuma loja, ferreiro nem curandeiro na run.
4. **Run inteira:** as marcas continuam valendo nas fases seguintes, depois do portal.
5. **Recompensa e recorde:** o resultado mostra "Marcas do Abismo: nível N (moedas +X%)" e "novo recorde" quando vence a fase inicial com nível maior; as conquistas de pontuação Marcado pelo Abismo (5), Selo do Abismo (10), Abismo Sem Fundo (15), Coroa do Abismo (20) e Abismo Desperto (25) dão moedas. **Atenção:** o teto de moeda da economia de ouro (`reward_cap` 3,0) limita o bônus acima de 20 pontos.
6. **Sem marcas:** a run deve ser igual à de antes (nenhuma marca ligada).
7. **Perguntar ao tester:** o nível máximo (25) é desafiador ou impossível? Qual marca é a mais injusta?

#### Economia de ouro (BAL-023, SPEC-142, PLAN-075)

1. **Ganho no Quartel menor nas fases finais:** o ouro de cada fase entra no Quartel em valor-base (sem o ×5 das fases finais). Uma vitória até Feng-tu deve render algo perto de 9.000 a 13.000 moedas (antes ~23.000 a 30.000). Anote quanto a tela de resultado mostra.
2. **Bônus de moedas:** Ganância, Anel de Prata, Carisma e a Aura Amarela agora valem em qualquer fase (+10% de bônus = +10% de moedas).
3. **Venda de peças:** vende por mais nas fases altas (acompanha o preço da loja), mas **não conta mais para o Quartel**, só para gastar na run.
4. **Chicote Avarento:** rende no máximo 0,15 moeda por segundo; não é mais uma máquina de dinheiro.
5. **Teto da recompensa:** descida e Marcas do Abismo juntas nunca passam de ×3,0.
6. **Perguntar ao tester:** a primeira compra no Quartel chega em até 2 runs? O ritmo de ~20 vitórias para comprar tudo parece justo? Os arquivos de estatística da run trazem `gold_src` (ouro por fonte), que calibra a meta.



## Versão 0.3.3 — build local exportada (absorvida pela 0.4.0)

Decisão do dono (2026-10-07): subir para **0.3.3** e exportar o `.exe` local `build/NottgardSurvivors-Playtest 0.3.3.exe` (22:44). `0.3.3` em `core/version.gd` e `export_presets.cfg`. **Sem commit de versão nem push** (push na `main` publica o release `latest`). Exportada da árvore de trabalho sobre `1144155+` (suja): leva as Marcas do Abismo (commits `78c6f39`, `1144155`) e a economia de ouro (BAL-023, ainda sem commit) das seções "Aguardando versão" acima, mais o diagnóstico opt-in do BUG-028 (inerte sem `--walk-debug`). Suíte 0 falhas e fumaça ok antes do export. Atenção: por conter mecânica nova (Marcas do Abismo), pela regra de tipos seria Major; o número 0.3.3 foi escolha do dono.

## Versão 0.3.2 — Minor-update, build local exportada (absorvida pela 0.4.0)

Decisão do dono (2026-10-06): subir a versão para **0.3.2** e exportar o `.exe` local em `build/`. `0.3.2` em `core/version.gd` e `export_presets.cfg`. Ainda **sem commit de versão nem push**: o CI só publica o release `latest` com a 0.3.2 depois disso.

Entra, além da 0.3.1 já publicada (commits `cbdcae7` a `ced9d8e`): famílias de bênção Juramento e Caminho (Juramento de Lliira, Caminho da Estrela de Tou Um; cura da Estrela 0,3 PV/s), explosão do Passo pelas Sombras do Sylas `3d8` → `1d10` (BAL-021), arte estática de inimigos assentada na sombra, **baú vira Mímico uma vez só** (BUG-030) e **item de baú com slot vazio pausa e mostra o item** (BUG-031, [EVID-173](../evidence/EVID-173-bau-mimico-e-pausa-ao-pegar-item-2026-10-06.md)).

**Atenção: o `.exe` foi exportado da árvore de trabalho, não de um commit.** Reexportado em 2026-10-06 às 15:51 sobre `a09d460+` (sujo), já com o trabalho da outra sessão (lettering e cursor da SPEC-132). Além do commit, ele leva mudanças ainda **não commitadas**: novas bênçãos e rebalanceamento da SPEC-129 B-003 (`data/boons.json`, `data/boon_effects.json`, `EVID-170`), e o esqueleto de lettering e cursor da SPEC-132 B-002 (`core/game.gd`, `ui/run.gd`, com fallback; sem arte nova). O release `latest` do CI, ao contrário, sairá só do que for commitado.

### O que testar (0.3.2, itens novos)

1. **Baú Mímico:** um baú vira Mímico no máximo uma vez; o baú que ele larga sempre dá item.
2. **Item de baú:** com o slot vazio, o jogo pausa e mostra o item (ícone, raridade, atributos) com o botão Equipar; confira também o baú do chefe.
3. **Sylas, Passo pelas Sombras:** a explosão da isca ainda ajuda sem limpar a primeira horda?
4. **Bênçãos Juramento e Caminho:** aparecem nos altares? A cura da Estrela de Tou Um parece justa?

## Versão 0.3.1 — Minor-update por decisão do dono, a publicar (playtest)

Decisão do dono (2026-10-05): a versão do balanceamento da SPEC-122 e dos inimigos novos do PLAN-053 sai como **0.3.1 "por enquanto"**, em vez de 0.4.0. Pela regra de tipos (acima) isso seria Major, porque traz a raridade Incomum e muda a dificuldade; por isso esta versão **não tem changelog em PDF nem questionário novo**, e o [QUESTIONARIO-006](questionarios/QUESTIONARIO-006-v0.3.0.md) não cobre estes itens.

Notas curtas para o aviso aos testers (lista "O que testar"):

- XP mais lento: o herói deve sair de Dagruve por volta do nível 8 a 10 (antes ~14). [EVID-152](../evidence/EVID-152-b002-xp-ritmo-de-nivel-2026-10-04.md)
- Armas iniciais mais fracas (Espada Sombria e Raio de Luz atacam mais devagar).
- Menos baús, fontes e altares espalhados e menos acontecimentos opcionais por mapa.
- Itens: Raro e Único bem mais raros no começo, nova raridade **Incomum** (entre Mágico e Raro) e preços por raridade.
- Dano e PV dos inimigos reajustados por fase (mais suave no início, mais duro no fim).
- Inimigos novos animados em Shedaklah, Durao, Molor e Feng Tu.
- **Conhecido:** Zynara, Leoric e Nyrelia aparecem de frente ao andar para cima (BUG-027, arte nova ainda não gerada).

Commits: `7d2f262`, `35796ba`, `5fc8d04`, `d86fbef`, `eecced9` (mecânicas, um por commit), `2d3cd14` (arte), mais o commit de versão. `0.3.1` em `core/version.gd` e `export_presets.cfg`.

Acrescentado depois, ainda na 0.3.1 (build publicada em 2026-10-05): inimigos **20 % mais rápidos** (SPEC-124, `69ec21c`) e **inimigos mais duros de Docas em diante** (SPEC-125, `05264f0`; [EVID-162](../evidence/EVID-162-b003-inimigos-por-fase-2026-10-05.md)). Dagruve, heróis, chefes e curva de poder não mudaram.

### O que testar (lista curta para os testers, 0.3.1)

1. **Início (Dagruve):** continua fácil, certo ou difícil demais? Em que nível você saiu do mapa (esperado: 8 a 10)?
2. **Docas:** a luta aperta de verdade? Você chegou a ficar com pouco PV ou morreu?
3. **Shedaklah, Molor e Durao:** o dano dos inimigos machuca sem ser injusto? Se morreu, anote o mapa e o tempo.
4. **Feng-tu em diante:** se chegou, está fácil, certo ou injusto? (É onde há menos dados.)
5. **Chefes:** as lutas ficaram longas demais ou continuam rápidas?
6. **Inimigos mais rápidos:** o kite (fugir e atacar) ainda funciona? Heróis lentos sofrem?
7. **Armas iniciais:** Espada Sombria e Raio de Luz atacam mais devagar; o começo ficou lento ou mais tenso?
8. **Itens:** Raro e Único aparecem bem menos no começo? Você viu a raridade verde **Incomum**? Os preços por raridade fazem sentido?
9. **Mapa:** menos baús, fontes e altares e menos acontecimentos: faz falta ou ficou melhor?
10. **Inimigos novos animados** em Shedaklah, Durao, Molor e Feng-tu: algum estranho ou com defeito?
11. **Bênção opcional:** no altar de bênção aparece "Recusar a bênção". Recusar apaga o altar sem prêmio. (No altar da doação não há recusa, porque o item já foi entregue.)
12. **Habilidade Q/RMB:** o slot da habilidade mostra o ícone, a recarga (varredura e segundos) e brilha ao ficar pronta? Dá para saber a hora de usar sem olhar texto?
13. **Ficha C em abas:** abas, grade de ícones e detalhe estão claros? A habilidade aparece com descrição e recarga? Os textos de CA e CAM ajudam?
14. **Painel do herói (canto superior esquerdo):** no mesmo padrão da ficha C; retrato, PV, XP, atributos, moedas, abates, CA e CAM, e as bênçãos ativas estão legíveis? (Sylas agora aparece como Malafas.)
15. **Invulnerabilidade depois de levar dano:** caiu de 0,4 s para 0,1 s (SPEC-128). Golpes em sequência ficaram mais perigosos? Ficou injusto ou mais tenso?

Para cada morte, traga: herói, fase, tempo e se foi "difícil mas justo" ou "injusto". Se alguma fase ficou fácil, diga qual.

**Conhecidos (não precisa reportar):** Zynara, Leoric e Nyrelia aparecem de frente ao andar para cima (BUG-027); heróis patinam ao andar de lado (BUG-028); pixels soltos nos heróis (BUG-029).

## Versão 0.3.0 — Major-update, publicada (playtest)

Pedido do dono (2026-10-03): os testers anteriores não responderam o questionário, só conversaram o que precisava mudar (a conversa levou ao PLAN-055). Por isso o questionário desta versão é **curto (1 página)** e pensado para **novos testers**; leva também o changelog em PDF e um **guia fácil** em PDF. `0.3.0` em `core/version.gd` e `export_presets.cfg`.

- Changelog para os testers (PDF, 0.2.3 → 0.3.0): [CHANGELOG 0.3.0](changelogs/CHANGELOG%200.3.0%20-%20Nottgard%20Survivors.pdf) (fonte em [HTML](changelogs/CHANGELOG-0.3.0.html)).
- Questionário rápido: [QUESTIONARIO Rápido - 006](questionarios/QUESTIONARIO%20R%C3%A1pido%20-%20006.pdf) (mapa em [QUESTIONARIO-006](questionarios/QUESTIONARIO-006-v0.3.0.md)). Traz 4 linhas de dificuldade por faixa de mapas e "onde morreu" para **comparar com o bot** (EVID-148 a 150).
- Guia fácil (PDF, 2 páginas, para quem nunca jogou): [GUIA FACIL 0.3.0](changelogs/GUIA%20FACIL%200.3.0%20-%20Nottgard%20Survivors.pdf) (fonte em [HTML](changelogs/GUIA-FACIL-0.3.0.html)).
- Conteúdo: SPEC-118 (acontecimentos exclusivos de Shedaklah a Pilares), SPEC-120 parte A (dano inimigo por fase, afixos de elite e de chefe, horda; [EVID-149](../evidence/EVID-149-curva-base-spec-120-parte-a-2026-10-03.md) e [EVID-150](../evidence/EVID-150-curva-base-em-escala-2026-10-03/EVID-150-curva-base-em-escala-2026-10-03.md); `dmg_mult` de Shedaklah 1,4, Molor 1,75, Durao 1,9, Feng-tu 2,1, Shendilavri 2,3 sem medição do bot depois do último ajuste), chão assado e desenho de nível nos 9 biomas (PLAN-054 F1), animações novas dos 10 heróis e dos mobs de Shedaklah e Molor, efeitos de golpe corpo a corpo, fila de imagens prioritária (PLAN-053), 13 SFX reais (Ludo.ai), tela que só treme com dano, Korrak ajustado, grafia Durao.
- **Fora desta versão:** SPEC-119 (segredos e mapa maior) e Marcas do Abismo (SPEC-120 parte B), ainda rascunhos; animações de Zuggtmoy, Gárgula e Receptáculo de Juiblex (trabalho de outra sessão, não commitado).
- Suíte e fumaça verdes em 2026-10-03.
- [ ] Aviso aos testers com os três PDFs (changelog, guia fácil e questionário 006).

## Versão 0.2.3 — publicada (playtest), junta 0.2.0 + 0.2.1

Decisão do dono (2026-10-02): **nenhum playtester jogou a 0.2.0 nem a 0.2.1**, então a 0.2.3 as engloba e as duas ficam sem aviso próprio (0.2.2 foi pulada). Os testers saem da **0.1.0** e vão direto para a 0.2.3. `0.2.3` em `core/version.gd` e `export_presets.cfg`.

- Changelog para os testers (PDF, 0.1.0 → 0.2.3): [CHANGELOG 0.2.3](changelogs/CHANGELOG%200.2.3%20-%20Nottgard%20Survivors.pdf) (fonte em [HTML](changelogs/CHANGELOG-0.2.3.html)).
- Questionário rápido: [QUESTIONARIO Rápido - 005](questionarios/QUESTIONARIO%20R%C3%A1pido%20-%20005.pdf) (mapa em [QUESTIONARIO-005](questionarios/QUESTIONARIO-005-v0.2.3.md)).
- Conteúdo: tudo da 0.2.0 e da 0.2.1 (abaixo) mais, depois da 0.2.1: BAL-012 (Guardião Alado das Docas 60 → 480 PV), BAL-015 (início de Dagruve mais justo para Leoric, Kayron, Durvall, Sylas e Zynara), limpeza do fundo magenta em estruturas e remendos, correção da tira de ataque do Durvall (BUG-021) e do erro de número de dano fundido (BUG-024), conquistas Estátua Viva (MEC-037) e Leoric, o Infeliz (MEC-036).
- Suíte e fumaça verdes em 2026-10-02. Balanceamento dos heróis segue adiado até o feedback humano (PLAN-052).
- [ ] Aviso aos testers com o PDF do changelog e o PDF do questionário 005.

## Versão 0.2.1 — substituída pela 0.2.3 (nunca jogada por testers)

Pedido direto do dono em 2026-10-01 ("atualize a build de playtester para v0.2.1 com as novas atualizações"). **Fora da regra de minor-update:** esta versão traz mecânicas novas (Maré do Abismo, falas, números de dano), então os testers precisam aprender coisas novas; não há PDF nem questionário novo, só as notas abaixo. `0.2.1` em `core/version.gd` e `export_presets.cfg`.

### O que testar (notas curtas para o aviso)

- Retratos dos heróis no menu e no painel de itens agora aparecem inteiros (antes cortavam).
- Heróis e inimigos encostam os pés na sombra (antes flutuavam alguns pixels).
- Eventos do mapa (loja, ferreiro, curandeiro, aposta, doação, ampulheta, altar, fonte, ritual, portal) ficaram maiores; baús mantêm o tamanho.
- Dopamina (MEC-031): estouro ao matar, pausa curta em crítico e abate de elite ou chefe, tom da coleta subindo em sequência, números de dano por tipo com soma de acertos rápidos, brilho e nome do loot por raridade. Opção **Reduzir efeitos de impacto** em Opções.
- **Maré do Abismo:** abates em sequência (10, 25, 50, 100, 200) dão aviso e +2% de XP por 5 s (máx. +10%). Três conquistas novas por abates seguidos sem dano.
- **Alma e história (MEC-032):** epígrafe de cada fase, contexto de chefe, textos temáticos dos eventos e **falas dos heróis** (balão na entrada, no chefe e com pouca vida; desligável em Opções).
- Questionário para os testers: [QUESTIONARIO Rápido - 004](questionarios/QUESTIONARIO%20R%C3%A1pido%20-%20004.pdf) (mapa em [QUESTIONARIO-004](questionarios/QUESTIONARIO-004-v0.2.1.md)).
- Cenário (MEC-030, 033, 034, 035): destrutíveis com loot e Sorte, armadilhas de cenário e layout por zonas em Dagruve e Docas; arte de estradas ainda provisória.
- **Estátua Viva (MEC-037):** nova conquista por ficar 2 minutos seguidos parado numa run.
- **Crônicas e rumor de Adam (MEC-032 H4, H6):** o Diário ganhou uma crônica por fase (libera ao vencer o chefe, com aviso); nas Docas e em Shedaklah aparece uma linha sobre Adam depois da epígrafe.
- **Heróis ajustados (BAL-013, 014):** Nyrelia (Dominar Pessoa mais forte, mais PV e CA), Zynara (Suspensão Temporal mais frequente, Ampulheta mais forte) e Kayron (Sobrecarga Mística e Poder Místico melhores).
- **Proporção dos sprites (BUG-021):** os heróis não devem mais mudar de tamanho ao andar nem ao atacar; a Nyrelia andando para a direita ainda fica um pouco menor.

## Versão 0.2.0 — Major-update, publicada (playtest)

Changelog para os testers (PDF, de 0.1.0 para 0.2.0): [CHANGELOG 0.2.0](changelogs/CHANGELOG%200.2.0%20-%20Nottgard%20Survivors.pdf)
(fonte em [HTML](changelogs/CHANGELOG-0.2.0.html)). Também entraram na build `latest`, depois do primeiro
push: suporte a joystick (SPEC-096), tela de título nova, skin de Leoric, animações do cultista de adaga
(SPEC-099) e estruturas por bioma (SPEC-100); o changelog já os cobre.

Origem: [PLAN-038](../vault/drafts/PLAN-038-atualizacao-pos-playtests-t01-t02-t03-2026-09-29.md)
(0.1.1 e 0.2.0 viraram uma versão só) e [PLAN-039](../vault/drafts/PLAN-039-roteiro-run-qa-para-versao-0-1-1-2026-09-29.md)
(roteiro da run QA, dispensado pelo dono: os bugs serão validados no próprio playtest). `0.2.0` em `core/version.gd` e `export_presets.cfg`. Publicada pelo CI no release `latest` (Playtest v0.2.0); o commit da build fica registrado no título do release.

| Trilha | Conteúdo | Cartão / spec | Estado |
|---|---|---|---|
| Bugs | Espelho de Shendilavri fora do mapa; inimigos presos em objetos; props flutuando; prévia do ferreiro | BUG-011, 012, 013, 015 | implementado, aguarda playtest |
| Bugs | Regra do ritual | BUG-014 → MEC-026 | implementado, aguarda playtest |
| Mecânicas | Comparação de equipamento (loja, forja, oferta) | MEC-019 · SPEC-081 | implementado |
| Mecânicas | Loja e ferreiro mostram todas as opções | MEC-023 · SPEC-082 | implementado |
| Mecânicas | Abertura de fase mais cheia | MEC-024 · SPEC-083 | implementado |
| Mecânicas | Bênção do Selo ao interromper o ritual | MEC-026 · SPEC-084 | implementado |
| Mecânicas | Velocidade 2x em mapas vencidos e evento Ampulheta | MEC-010 · SPEC-085 | implementado |
| Mecânicas | Faixa de dano, dica de evolução, Baú do Chefe, quebráveis, fontes, névoa e INT do Estige | MEC-007, 008, 013, 017, 018, 020, 022 · SPEC-086 | implementado |
| Mecânicas | Fidelidade do item (3 recusas sobem o nível) e eventos Altar da Doação e Mesa de Aposta | MEC-021, 005 · SPEC-087 | implementado |
| Mecânicas | Meta ampliado (5 aprimoramentos, 10 níveis em Força e Vitalidade) e +1 PV por nível a partir do 15 | MEC-014, 015 · SPEC-088 | implementado |
| Mecânicas | Conquistas novas, aprimoramentos travados por conquista e biografias do vault | MEC-016 · SPEC-089 | implementado |
| Mecânicas | IA de cerco: perseguidores flanqueiam | MEC-011 · SPEC-090 | implementado |
| Mecânicas | Mini-cinemática de evolução de arma | MEC-009 · SPEC-091 | implementado (procedural) |
| Mecânicas | Mapas maiores: 60×60 em todas as fases (props escalados, terreno esticado) | MEC-012 · SPEC-093 | implementado |
| Mecânicas | Ofertas em cartão resumido: detalhes no hover ou com Shift (item, loja, ferreiro, nível, altar) | MEC-027 · SPEC-094 | implementado |
| Arte | Cor de raridade, rótulos de loja/ferreiro/curandeiro, ímã provisório, texto de "redução" | ART-009, 015, 016, 017 | implementado (provisório onde indicado) |
| Balanceamento | Ajustes de números pós-playtest: névoa, quebráveis, fontes, baú do chefe, abertura de fase | BAL-001, 004, 005, 006, 007 · SPEC-083, 086 | implementado, aguarda playtest |
| Ferramentas | Hash do commit no rodapé, no log e nas notas | TOOL-001 | implementado |

### O que testar (texto para os testers)

1. Abrir loja e ferreiro sem moeda suficiente: todas as opções aparecem?
2. Trocar equipamento: dá para ver o que se ganha e o que se perde?
3. Interromper um ritual: apareceu a bênção? Valeu a pena?
4. Os primeiros minutos de cada fase estão mais movimentados? Ficou difícil demais?
5. Inimigos contornam objetos, sem ficar presos? Props encostam no chão?
6. Cores de raridade ficaram claras nas ofertas?
7. Mapas já vencidos: a tecla T (2x) e o evento Ampulheta ajudam a jogar mais rápido?
8. Altar da Doação e Mesa de Aposta: entendeu o risco? Valeu a pena?
9. Os inimigos chegam de vários lados? Isso ficou interessante ou injusto?
10. Ao evoluir uma arma, a tela de evolução explica como foi? Dá para pular?
11. Quer comprar algo no meta? Novos aprimoramentos, conquistas e biografias: motivam a jogar mais?
12. A fase tardia (Shendilavri em diante) continuou melhorando o herói?
13. Os mapas ficaram maiores: acabou a sensação de apertado ou ficaram vazios demais? Inimigos demoram muito a chegar?
14. As ofertas (item, loja, ferreiro, nível, altar) ficaram mais fáceis de entender? O hover e o Shift (segurar) mostram o que faltava?

### Fechar a versão (checklist)

- [x] Suíte, smoke e (se houver mudança de dados) bot verdes
- [ ] Roteiro do PLAN-039 rodado em run real; resultado vira EVID *(dispensado pelo dono em 2026-09-29; validar no playtest)*
- [x] `VERSION` em `core/version.gd` e `file_version`/`product_version` em `export_presets.cfg` atualizados no mesmo commit
- [x] Esta tabela revisada, com commits
- [x] `tools/backlog_check.ps1` sem alertas novos
- [x] Push na `main` (CI grava o commit da build e publica o `latest`)
- [x] Changelog em PDF para os testers (2026-09-30)
- [ ] Aviso aos testers com o changelog em PDF, a lista "O que testar" e o [questionário rápido 003](questionarios/QUESTIONARIO%20R%C3%A1pido%20-%20003.pdf) (mapa pergunta → cartão em [QUESTIONARIO-003](questionarios/QUESTIONARIO-003-verificacao-v0.2.0.md))

## Histórico

| Versão | Tipo | Publicada | Commit da build | Avaliada em |
|---|---|---|---|---|
| 0.4.0 | Major (changelog 0.3.1 → 0.4.0 + guia fácil + questionário 007; absorve 0.3.2 e 0.3.3) | 2026-10-08 (release `latest`, Playtest v0.4.0) | `aa496f2` | — (aguardando testers) |
| 0.3.2 | Minor (build local exportada; sem PDF nem questionário novo) | pendente (falta commit de versão e push) | `a09d460+` (árvore suja, reexportada 2026-10-06 15:51) | — |
| 0.3.1 | Minor (decisão do dono; sem PDF nem questionário novo) | 2026-10-05 (release `latest`, Playtest v0.3.1) | ver título do release | — (aguardando testers) |
| 0.3.0 | Major (changelog + guia fácil + questionário 006) | 2026-10-03 (release `latest`, Playtest v0.3.0) | ver título do release | — (aguardando testers) |
| 0.2.3 | Atualização de playtest (pedido do dono; junta 0.2.0 + 0.2.1) | 2026-10-02 (release `latest`, Playtest v0.2.3) | ver título do release | — (aguardando testers) |
| 0.2.1 | Atualização de playtest (pedido do dono; traz mecânicas) | 2026-10-01 (release `latest`, Playtest v0.2.1) | ver título do release | — (aguardando testers) |
| 0.2.0 | Major | 2026-09-29 (release `latest`, Playtest v0.2.0) | `adc9ae6` (tag `latest` em 2026-09-30; primeira publicação: `fce670d`; republicada a cada push na `main`) | — (aguardando testers) |
| 0.1.0 | Major (primeira) | 2026-09-29 (playtest T01, T02, T03) | não registrado (builds anteriores ao TOOL-001) | EVID-106, 107, 108 |
