# PLAN-055 — Mapas vivos, segredos do Vault e dificuldade (2026-10-03)

Origem: relato do playtester **T03 (Daniel)**, passado verbalmente pelo dono em
2026-10-03:

1. O jogo está **fácil demais**.
2. Falta **coisa para fazer no mapa**: mapa maior, **coisas escondidas** e
   **referências à história de Nottgard** (Vault).
3. Dono: "depois do 3º ou 4º mapa fica enjoativo"; pede **eventos ou
   acontecimentos exclusivos de cada mapa**.

Relacionados: MEC-005 (mais eventos), MEC-012 (mapas maiores), MEC-030 (riqueza
de cenário), MEC-032 / [[SPEC-117-alma-e-historia-na-run]] (alma e história),
BAL-001 (dificuldade inicial), BAL-002 (progressão tardia), BAL-015 (mortes no
início de Dagruve), [[PLAN-052-padrao-de-qualidade-do-balanceamento-dos-herois-2026-10-02]].

## Decisões do dono (2026-10-03)

| # | Pergunta | Decisão |
|---|---|---|
| D1 | O que roda sozinho à noite | **Analisar, medir e escrever specs.** Nada muda no jogo; o dono aprova de manhã. Sem commit. |
| D2 | Dificuldade | **As duas coisas:** endurecer um pouco a curva base (fase 3 em diante) **e** criar níveis opcionais de dificuldade (**Marcas do Abismo**) com recompensa maior. |
| D3 | Até onde vai a história | **Segredos colecionáveis:** coisas escondidas no mapa revelam fragmentos curtos do Vault que vão para o Diário. Continua "lore como sabor", mas recompensa quem explora. Cânone do mestre continua fora. |

## Diagnóstico (fatos do código em 2026-10-03)

- **Tamanho:** todas as 9 fases têm **60×60** (SPEC-093). O mapa é igual em
  área do Dagruve aos Pilares; o que muda é chão, props e regra ambiental.
- **Eventos exclusivos** (`data/stage_events.json`): só **Dagruve (2)** e
  **Docas (3)**. **Shedaklah, Molor, Durao, Feng-tu, Shendilavri, Goranthis e
  Pilares têm zero.** É exatamente a partir da 3ª fase que o jogo "enjoa".
- **Regras ambientais** (`data/stage_rules.json`) existem para as 9, mas são
  passivas (poças, bolhas, raios, ilusões): mudam o terreno, não dão objetivo.
- **Interações** (baú, fonte, altar, ritual, loja, ferreiro, curandeiro,
  ampulheta, doação, aposta) são **as mesmas em todas as fases**, com os mesmos
  pesos.
- **Ondas:** de 4 a 7 tipos de inimigo por fase, 2 ou 3 elites com horário fixo
  e 1 chefe. A dificuldade sobe só por `hp_mult` (1,0 → 6,5) e `cap` (45 → 70).
- **História:** `data/stage_story.json` já tem epígrafe, chefe e rumor por fase
  (SPEC-117), mas só aparece em texto de abertura e crônica: nada no mapa
  convida a explorar.
- Sinal anterior que bate: T01 "fácil até Feng-tu" (EVID-106); T03 já pedira
  "mais mobs, mais dano, menos PV" (EVID-108). Sinal contrário: o bot mostra
  heróis frágeis morrendo cedo em Dagruve (BAL-015). Por isso D2 separa
  **base** (pouco mais dura, sobretudo da fase 3 em diante) das **Marcas do Abismo**
  (opcional, para quem quer sofrer).

## Frentes

### F1 — Auditoria Vault × jogo (noite, só leitura)

Para cada fase, chefe, elite, herói e texto de `stage_story`, `chronicles`,
`barks`, `hero_bios` e `hqs`: conferir contra o Vault (`F:\dev\nottgard-vault`,
o registro de sessão vale mais que `16_Histórias`).

Saída: **EVID-147** com três tabelas:
1. **Divergências** (o jogo contradiz o Vault) → cartão de correção.
2. **Ganchos não usados** por fase: lugares, NPCs, eventos e objetos do Vault
   que caberiam como evento exclusivo ou segredo, com a fonte (nota e sessão).
3. **Proibidos:** o que é cânone do mestre / conteúdo não revelado e não pode
   entrar (só a referência, sem o conteúdo).

### F2 — Medição da dificuldade com o bot (noite)

Varredura nas 9 fases com heróis de perfis diferentes. Medir por fase: mortes,
PV mínimo, tempo abaixo de 50 % de PV, nível ao entrar e ao sair, tempo para
matar o chefe. Objetivo: achar **onde a curva achata** (onde o herói passa a
sobrar) para mirar o endurecimento da base. Lembrete: o bot não vê props nem
explora; é alarme, não veredito (PLAN-052). Saída: **EVID-148**.

### F3 — Eventos exclusivos por mapa (SPEC-118, rascunho para aprovação)

Meta: **toda fase com 2 ou 3 acontecimentos próprios**, um deles grande no meio
da fase, ancorados no Vault (F1). Molde mínimo por evento: aviso, objetivo
opcional, recompensa e consequência se ignorado. Tipos novos além dos que já
existem (`ritual`, `hazard`, `wave`, `elite`):

- **Objetivo com escolha:** proteger, destruir ou carregar algo por 30–45 s
  (ex.: escoltar um sobrevivente, apagar focos de esporos).
- **Mudança do mapa:** a fase troca de estado no meio (maré sobe, ponte cai,
  céu escurece) e libera ou fecha uma área.
- **Invasão:** um mini-chefe errante do bioma atravessa o mapa; matar dá baú de
  chefe, fugir custa nada.
- **Pacto:** NPC ou altar oferece troca risco/recompensa ligada à lore do bioma.

As sugestões concretas por fase saem da F1 (não inventar lore nova).

### F4 — Segredos e mapa maior (SPEC-119, rascunho para aprovação)

Mapa maior **só se houver o que achar** (T03 discordou de mapa maior em
EVID-108 Q8, quando ele estava vazio). Proposta:

- **Lado 60 → 80** nas fases 3 a 9 (Dagruve e Docas ficam 60 para o início ser
  rápido). Densidade de inimigos acompanha a área nova.
- **Pontos de interesse (POI)** nas bordas: ruína, câmara, santuário, cada um
  com algo a ganhar. O centro continua arena.
- **Ecos de Nottgard:** 3 a 5 por fase, escondidos (atrás de destrutível,
  numa zona da névoa, depois de um evento). Ao tocar, um fragmento curto do
  Vault vai para o **Diário** (paráfrase com fonte, como em `stage_story`).
- **Relíquia da fase:** 1 segredo maior por fase (câmara selada, chave dropada
  por elite) com item único ligado à lore.
- **Contador no Quartel:** "Segredos 2/5" por fase; completar a fase dá
  conquista e moeda (sumidouro e motivo para voltar, ligado a MEC-015/MEC-016).
- Indicador discreto (brilho, som) quando um Eco está perto, para não virar caça
  cega.

### F5 — Curva base e Marcas do Abismo (SPEC-120, rascunho para aprovação)

> O jogo já chama de "profundidade" a camada descida pelo portal (`descent_depth`); por isso o nome Marcas do Abismo.

- **Base (fase 3 em diante):** elites com **afixos** (rápido, blindado,
  explosivo, vampírico) em vez de só PV maior; uma **horda** por fase (onda
  densa curta); `cap` sobe onde o bot mostrar folga. Dagruve e Docas só mudam se
  o bot mostrar folga sem piorar BAL-015.
- **Marcas do Abismo:** ligadas no Quartel por fase já vencida. Cada nível
  soma um modificador visível (mais inimigos, elites extras, cura menor, chefe
  com fase nova, eventos mais frequentes) e +X % de moeda e chance de relíquia.
  Recorde por herói e fase.

## Sugestões extras para complementar o jogo

Para escolher depois; nenhuma entra sem cartão próprio.

1. **Contratos por fase:** 1 objetivo opcional sorteado ("mate 3 elites sem
   ser atingido", "termine com 2 Ecos") com recompensa no fim.
2. **Bestiário** no Diário que se preenche ao matar, com uma linha do Vault por
   criatura (mesma fonte dos Ecos).
3. **Aliados resgatáveis:** NPC do Vault preso num POI; libertado, luta por
   60 s ou abre uma loja especial.
4. **Rotas no portal:** depois do chefe, escolher entre 2 portais (fase normal
   ou variante com regra trocada), dando variedade sem arte nova.
5. **Modo Incursão:** run infinita num bioma vencido, com as Marcas
   subindo sozinhas; placar.
6. **Semente da semana:** mesma fase, herói e modificadores para todos os
   testers compararem.

## Ordem

1. **Noite (D1):** F1 → EVID-147; F2 → EVID-148; registrar o relato de Daniel
   (INBOX/cartões); rascunhos SPEC-118, SPEC-119 e SPEC-120.
2. **Manhã:** o dono aprova ou corta os rascunhos.
3. Implementar F3 primeiro (maior efeito contra o "enjoa"), depois F5 base,
   depois F4 e as Marcas do Abismo.
4. Playtest com Daniel de novo (é o tester de primeira vez que deu o sinal).

## Feito na noite de 2026-10-03

- **F1:** [EVID-147](../../evidence/EVID-147-auditoria-vault-x-jogo-2026-10-03.md). Os textos do jogo estão fiéis e sem vazamento de segredo; as divergências estão nos chefes; há 40+ ganchos por fase.
- **F2:** `tools/bot_curva.gd` (novo; mede cada fase) e [EVID-148](../../evidence/EVID-148-curva-de-dificuldade-por-fase-2026-10-03.md). Achado: a curva tem um degrau só (Dagruve mata 30 % dos novatos); das fases 3 a 9, 894 passagens com 0,8 % de mortes e PV mínimo médio de 85 %, com qualquer meta. Causa provável: o PV inimigo multiplica até ×6,5 e o dano não (só +1 por camada).
- **F3, F4, F5:** rascunhos [SPEC-118](../../specs/SPEC-118-acontecimentos-exclusivos-por-fase.md), [SPEC-119](../../specs/SPEC-119-segredos-ecos-e-mapa-maior.md) e [SPEC-120](../../specs/SPEC-120-curva-base-e-marcas-do-abismo.md).
- Backlog: IN-049 a IN-052, MEC-038 a MEC-040, BAL-016, BUG-026; MEC-005, MEC-012 e BAL-001 com o novo relato.
- Nada foi commitado; o jogo não mudou.

## Decisões do dono em 2026-10-03 (manhã)

- **D-01 (Shedaklah):** Zuggtmoy pode virar **aliada** se o jogador levar a ela um item-chave; é uma referência que recompensa quem entende a história, com dica do que ela precisa.
- **D-03 (Feng-tu):** O Discípulo Pestilento vira o chefe.
- **SPEC-118 aprovada e implementada** no mesmo dia.

## Decisões pendentes para o dono (texto da noite)

1. **Chefe de Shedaklah (D-01):** o grupo negociou com Zuggtmoy. Manter, trocar por manifestação de Juiblex (Zuggtmoy aliada) ou "Zuggtmoy corrompida"?
2. **Chefe de Feng-tu (D-03):** O Discípulo Pestilento vira chefe e Lu Yueh fica para as Marcas?
3. **SPEC-118:** aprovar a lista de acontecimentos (cortar ou trocar linhas) e o sorteio "1 grande fixo + 1 ou 2 menores".
4. **SPEC-119:** 84×84 nas fases 3 a 8? Aprovar os Ecos um a um (texto vai para o jogo).
5. **SPEC-120:** lista de afixos, horda por fase e lista das Marcas.
6. **BUG-026:** a cópia do Guardião nas Docas a 400 s é intencional?
7. Ordem de implementação: proposta F3 → F5 (base) → F4 → Marcas.

## Limites

- Vault e Nottcard são só leitura. Cânone do mestre fica fora (ver memória do
  colar de Adam e da Síntese).
- Amostra: "fácil" vem de T01 e T03; "difícil no início" vem só do bot. Por isso
  a base muda pouco e a as Marcas do Abismo carregam o desafio.
- Sem commit nem build sem aprovação do dono.
