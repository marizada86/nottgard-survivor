---
id: "SPEC-117"
title: "Alma e história na run: mapa narrativo por fase e chefe"
status: "proposta para escolha do dono (2026-10-01)"
created: "2026-10-01"
relations: ["[[EVID-139-playtest-higor-qa-14b15e4-2026-10-01]]", "[[PLAN-050-pos-playtest-higor-2026-10-01]]", "[[SPEC-116-dopamina-tematica]]"]
sources: ["nottgard-vault/04_Locais (Dagruve, Docas, Camadas do Plano Abissal (Arco 01))", "nottgard-vault/05_Organizações/A Mente Derretida", "nottgard-vault/07_Criaturas/A Síntese Abissal", "nottgard-vault/12_Lore/Pilares Ativos e Plano Abissal", "data/hero_bios.json", "data/boss_presentations.json"]
---

# SPEC-117 — Alma e história na run (MEC-032)

Origem: relato do dono (IN-048, 2026-10-01): o jogo precisa de "consistência na história" e menos "jogado". Esta SPEC é **pesquisa + proposta**; nada foi implementado.

## Regras de fonte (do dono)
- O **Vault** é a fonte principal e vale mais que o Nottcard quando divergem. O registro de sessão prevalece sobre prosa derivada (`16_Histórias`).
- Seções de "cânone do mestre" são segredos que o grupo não sabia: **não entram sem decisão do dono**.
- Os arquivos `Dagruve.md` e `Docas.md` trazem a etiqueta `conteudo-nao-revelado`. Usei só o que está em "Base canônica" e nas **consolidações aprovadas das sessões**; qualquer texto novo deve ser conferido contra a etiqueta antes de ir ao jogo.
- Todo texto abaixo é **paráfrase curta do que está registrado**, sem lore nova.

## O que o jogo tem hoje de história
- `stages.json`: um subtítulo por fase ("Distrito negligenciado · névoa e culto").
- `boss_presentations.json`: título e subtítulo de cada chefe (Docas sem imagem).
- `hero_bios.json`: biografia de cada herói, derivada do Vault (liberada ao vencer uma fase com o herói).
- HQs de transição (`hqs.json`) e a mensagem de abertura da fase ("Dagruve — Distrito negligenciado · névoa e culto").
- Diagnóstico: a história está **fora da run** (HQs, biografias). Durante a partida não há contexto de "por que estou aqui" nem de "quem é o chefe".

## Mapa narrativo (nove fases)
Fonte principal: `04_Locais/Camadas do Plano Abissal (Arco 01)` (etiqueta `conteudo-conhecido`) e as páginas de cada local.

| # | Fase | O que o registro diz (resumo) | Chefe no jogo | Epígrafe proposta (rascunho) | Cuidado |
|---|---|---|---|---|---|
| 1 | Dagruve | Distrito mais negligenciado de Nottgard; uma fratura no cemitério deixa entrar a névoa; cultistas de A Mente Derretida (culto de Ghaunadaur) agem na Praça da Loucura | Sacerdote da Mente Derretida | "O distrito que Nottgard esqueceu. A névoa entra por uma fratura no cemitério." | Etiqueta `conteudo-nao-revelado` |
| 2 | Docas | Porto com rituais num porão de galpão, slime que corrói metal; mais tarde, invocação num navio abandonado traz uma Arch-hag e um Kraken | Guardião Alado (verdadeiro) | "No porão do galpão, um ritual espera. O metal vira ferrugem onde o slime passa." | Etiqueta `conteudo-nao-revelado`; o chefe vem do Nottcard e **não tem página própria no Vault**: decidir se é adaptação |
| 3 | Shedaklah (andar 222) | Domínio de Zuggtmoy (fungo) e Juiblex (slime), equilíbrio quebrado pela passagem de Juiblex | Zuggtmoy | "Fungo e limo dividem o andar. O equilíbrio já não segura." | — |
| 4 | Molor (andar 528) | Outro domínio de Juiblex; caverna de bolhas de slime; o Rio Estige volta a correr após o núcleo verde | Blogbog | "Bolhas de limo, um núcleo verde, e o Estige correndo de novo." | Thullgrime e o receptáculo de Juiblex aparecem na mesma camada: conferir antes de citar |
| 5 | Durao (andar 274) | Rio de almas, jaula gigante; guerra terminada; restam três Molydeus carcereiros | Molydeus, Carcereiro-Chefe | "Uma jaula do tamanho de um céu. Três carcereiros ficaram para guardá-la." | A jaula prende Vhaerith Aetherion e o Machado de Xar'gath vem daqui (relação com Korrak) |
| 6 | Feng-tu (andar 300) | Estética oriental; Tou Um e Lu Yueh; templo de Tou Um e peregrinação da estrela | Lu Yueh | "Lu Yueh tomou o andar. O templo de Tou Um ainda espera a peregrinação da estrela." | — |
| 7 | Shendilavri (camada 570) | Reino de Malcanthet; Rivenheart é murada e quase toda ilusão de súcubos | Malcanthet | "Uma única cidade, murada, quase toda feita de ilusão." | — |
| 8 | Goranthis (camada 597) | "O verdadeiro Paraíso"; castelo de Socothbenoth, todo ilusão sustentada por Juiblex; palco da batalha final do Abismo | Socothbenoth | "O Paraíso é uma ilusão, e todo o castelo a sustenta." | — |
| 9 | Pilares | Após a derrota da Síntese Abissal, pilares aparecem no horizonte; Sylas reconhece a pedra como a parede do mundo abissal; Ghaunadaur não foi destruído | Síntese Abissal | "Pilares no horizonte: a parede do mundo abissal. Querem puxar o céu para cá." | **A Síntese Abissal é a fusão de Durvall com a armadura de Astherion** e Durvall é herói jogável: decisão do dono sobre como (e se) mostrar |

A descida segue o **Rio Estige**; cada portal exige a **essência da própria camada** (o jogo já usa essências por fase).

## Proposta (do menor risco ao maior)

### H1 — Epígrafe de abertura da fase (risco baixo)
Ao entrar na fase, mostrar 1 a 2 linhas (coluna "Epígrafe proposta") no lugar do subtítulo atual, com a fonte registrada em `stages.json` (`epigrafe`, `fonte_vault`).
Teste: toda fase tem epígrafe e fonte; nenhuma passa de 140 caracteres.

### H2 — Apresentação do chefe com contexto (risco baixo)
Acrescentar a `boss_presentations.json` uma linha de contexto ("quem é") por chefe, a partir da mesma tabela. Docas só depois da decisão sobre o Guardião.

### H3 — Falas do herói em momentos-chave (risco médio)
Uma frase curta do herói ao entrar numa fase, ao chegar do chefe e ao ficar com pouca vida, em balão discreto. Texto escrito **a partir da ficha do herói** (`hero_bios.json`) e **aprovado pelo dono**; sem falas inventadas sobre cânone não revelado.
Dados em `data/barks.json` (herói × gatilho), com no máximo 2 variações para não repetir. Fica opcional em Opções.

### H4 — Diário de campanha desbloqueável (risco médio)
Cada fase vencida libera uma "crônica" curta no Diário/Códex, a partir de `16_Histórias` e do registro de sessão. Reaproveita o fluxo de HQs e biografias.

### H5 — Eventos com voz temática (risco baixo)
Os eventos de mapa (altar, ritual, ferreiro, curandeiro, poço de oferendas, oficina do cais) ganham um texto de abertura temático por fase, já que agora existem no cenário (SPEC-115).

## Ordem sugerida
H1 + H2 (dados e texto, sem mecânica) → H5 → H3 (depois de o dono aprovar as falas) → H4.

## Não objetivos
Lore nova, mudar o cânone, revelar segredos do mestre, alterar a ordem das fases.

## Perguntas para o dono
1. Quais itens entram (H1 a H5)? Proposta: H1, H2 e H5 já.
2. A epígrafe pode ser dita pelo narrador do jogo, ou prefere sempre uma citação de personagem?
3. **Guardião Alado (Docas):** adaptar para algo que o Vault registra (por exemplo, a Arch-hag ou o Kraken das Docas), ou manter e escrever uma linha sem pretensão de cânone?
4. **Síntese Abissal e Durvall:** mostrar a revelação (fusão com a armadura de Astherion) ao chegar nos Pilares, evitar o tema no jogo, ou tratar como segredo até uma decisão sua?
5. Quem escreve as falas (H3): eu proponho um rascunho por herói para você revisar, ou você escreve?

## Decisões do dono (2026-10-01) e correção
- Itens aprovados: **H1, H2 e H5** (dados e texto). **Síntese Abissal:** segredo por enquanto (a fusão de Durvall não aparece).
- **Docas:** o dono escolheu "trocar pela Arch-hag". É uma mudança de **design**, não de texto: o Guardião Alado tem animação completa (320×480), fases que invocam o Guardião Cópia, um teste que trava o chefe das Docas e arte do ciclo Guardião Cópia em produção; a Arch-hag hoje é elite sem animação.
  Por isso **não foi trocado**: a epígrafe das Docas já usa a Arch-hag e o Kraken (Sessão 13), e o chefe segue o Guardião até o dono confirmar o custo.
- **Correção — o fio de Adam (apontado pelo dono):** faltou o Adam no mapa narrativo. Pelo Vault (`03_NPCs/Adam`, `conteudo-conhecido`): suposto messias dos cultistas, tratado em Dagruve como libertador (Sessão 03); emissário de Ghaunadaur e "Messias do Caos" (Sessão 12); lidera a invasão pelo Domwieck e fere a estrela Ailalore, o que derruba a Tarn;
  conduz o ritual no Castelo da Fome e derrete em lodo quando Brook arranca o Colar de Ghaunadaur (Sessões 23 e 24); depois dele vem a Síntese Abissal.
  Aplicado em `data/stage_story.json`: Dagruve cita Adam como o messias que os cultistas esperam; Pilares abre dizendo que Adam caiu antes. Outros NPCs do Vault a considerar: Mago Helion, Arlindo Orlando, Kein/Elias, Astherion, Aila.
- **H6 (proposta nova) — Fio de Adam:** uma linha de rumor sobre ele em fases intermediárias (Docas, Shedaklah...), só com o que o grupo soube em cada sessão. Aguarda o dono.

## Cânone do mestre informado pelo dono (2026-10-01) — NÃO entra no texto do jogo
Dito pelo dono no chat, para facilitar a escrita:
- **O amuleto de Adam**: **quem o possui se torna o Adam.** Adam é, portanto, um papel que o amuleto impõe a quem o carrega. Esclarecimento do dono: **colar e amuleto são "quase a mesma coisa"**, ou seja, o amuleto é parente próximo do **Colar de Ghaunadaur** do Vault, **não necessariamente o mesmo objeto**; não tratar os dois como idênticos nem escrever um no lugar do outro.
- Esse amuleto é **uma das duas metades** da formação da **Síntese Abissal**: a outra é a **fusão de Astherion com Durvall**. As duas juntas dão a Síntese.

Como isto conversa com o Vault (leitura, sem alterar):
- O registro já diz, sobre o **Colar de Ghaunadaur** (parente do amuleto, ver acima), que **quem usa o colar é dominado pela consciência de Ghaunadaur** (Sylvaris em 1477; depois Adam) e que Marciela o reconhece como o mesmo trazido pela expedição dos pais de Erik (Sessões 23 e 24).
- Em seguida Adam derrete quando Brook arranca o colar e a Síntese passa a ser o chefe final.
- O Vault **não** diz que o colar "faz de quem o porta o Adam" nem que ele é metade da Síntese; isto é informação nova do dono. Se o dono quiser que vire cânone registrado, a decisão e o registro são dele (o Vault é somente leitura para este projeto).

Regras para o jogo:
- Esta ligação (colar → Adam → Síntese, com Durvall) é **segredo**, na mesma decisão de "Síntese Abissal: segredo por enquanto". Nenhum texto do jogo (epígrafe, contexto de chefe, falas, diário) pode afirmá-la.
- O que está no jogo hoje respeita isso: Dagruve fala de Adam como "o messias que os cultistas esperam", e os Pilares dizem "Adam caiu no Castelo da Fome. Depois dele veio uma monstruosidade abissal".
- Se o dono liberar a revelação, o lugar natural é o contexto do chefe dos Pilares e uma crônica do Diário (H4), com variação para quem joga de Durvall.

## H3 implementado (2026-10-01)
Falas aprovadas pelo dono (tom: seguir o Vault; Maelor, Sylas e Brook com humor, Brook irritado e curto). `data/barks.json` (herói × entrada/chefe/vida, até 2 variações), `ui/run.gd` (`_bark`, `_update_low_hp_bark`: balão acima do herói por ~3 s; "vida" abaixo de 30% de PV, rearma ao passar de 50%, no mínimo 20 s entre falas), opção **Opções → Falas dos heróis** (padrão ligada, `settings.barks`). Teste: `tests/test_barks.gd`. Falas por fase ficam para depois do playtest.
