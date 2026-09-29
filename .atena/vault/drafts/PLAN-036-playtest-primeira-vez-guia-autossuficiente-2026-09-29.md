# PLAN-036 — Playtest com quem nunca jogou (guia autossuficiente + questionário novo)

Status: **alinhado com o dono em 2026-09-29 — build definido, guia em PDF
redigido.**

## Contexto

O único playtest registrado até aqui (
[[PLAN-031-proximo-playtest-reavaliacao-e-questionarios-2026-09-28]] /
[[EVID-091-playtest-higo-hiago-build-c-e-item-offer-2026-09-28]]) foi com
Hiago, que já conhecia o jogo e estava comparando com a run anterior — o
questionário dele é de **reavaliação** ("isso resolveu o que você pediu?").
[[PLAN-034-pendencias-restantes-2026-09-28]] já registrava esse questionário
como desatualizado (não cobre loja/ferreiro/curandeiro nem quebráveis por
bioma) e pedia uma nova versão quando fizesse sentido cronologicamente.

Esta rodada é um público diferente: pessoas que **nunca jogaram nem testaram
o jogo antes**, jogando **sozinhas e remotamente**, sem o dono por perto para
tirar dúvida ao vivo. Isso muda duas coisas ao mesmo tempo:
- O **guia** precisa ser autossuficiente — explicar desde abrir o jogo até
  mandar o feedback de volta, sem jargão de jogo nem suposição de experiência
  prévia.
- O **questionário** precisa ser de **primeira impressão/onboarding**, não de
  comparação com versão anterior (não existe "versão anterior" pra essas
  pessoas).

## Decisões alinhadas com o dono (2026-09-29)

1. **Build**: Playtest Público (`NottgardSurvivors-Playtest.exe`,
   `export_presets.cfg`), não QA Interno — kit de evidências simplificado
   (F5 nota, F6 print, F7 exportar ZIP, F11 tela cheia, F1 guia interno),
   sem Navegador QA nem console QA.
2. **Entrega do jogo**: link de download que o dono envia diretamente — fora
   do escopo deste plano.
3. **Retorno do feedback**: o ZIP gerado pelo F7 é enviado por Discord (DM ou
   canal combinado com cada tester) — fora do escopo deste plano.
4. **Formato do guia**: PDF único, autossuficiente, linguagem simples, sem
   jargão — mesmo padrão de entrega usado com o Hiago (
   "guia PDF enviado ao playtester", EVID-091).

## O que mudou desde o último playtest (contexto do novo questionário)

- [[SPEC-059-descricao-de-itens-e-slots-visiveis]] — painel de itens (`C`).
- [[SPEC-060-escolha-de-equipar-ou-vender-loot]] — decisão de equipar/vender
  ao achar item de slot ocupado.
- [[SPEC-063-objetos-quebraveis-e-rebalanceamento-de-pocao]] (+ emenda) —
  quebráveis por bioma (arte ainda provisória para 7 dos 10 — ver conversa
  desta sessão sobre os `.import` pendentes) e rebalanceamento de poção.
- [[SPEC-064-eventos-economicos-loja-ferreiro-curandeiro]] — loja, ferreiro,
  curandeiro.
- [[SPEC-072-segurar-clique-para-andar]] — segurar clique esquerdo move o
  herói.
- [[SPEC-073-nivel-de-equipamento-e-super-upgrade]] — nível de equipamento.
- [[SPEC-075-sinergias-combinadas-arma-acessorio-magia]] — sinergias
  combinadas (não é algo que um primeiro-tester vá necessariamente alcançar
  numa run curta; não entra como pergunta direta, mas fica registrado caso
  algum tester chegue lá organicamente).
- [[SPEC-074-correcao-do-vazamento-do-sandbox-qa]] — não afeta o build
  Playtest Público (só QA Interno).

## Escopo do guia (entregável em PDF)

1. O que é o teste, por que a opinião sincera importa mais que "jogar bem".
2. Como baixar/abrir o `.exe` (incluindo o aviso do SmartScreen do Windows,
   esperado em builds não assinadas).
3. Primeira tela (Quartel): nome, abas, como escolher herói/fase e começar.
4. Controles essenciais (mover, habilidade, interagir, extrair, pausar,
   subir de nível) — sem listar todo o jogo, só o necessário pra uma
   primeira run.
5. O que esperar de uma partida, em ordem: combate automático, baús/altar/
   loja-ferreiro-curandeiro, chefe, decisão de extrair ou continuar.
6. Como registrar feedback ao vivo (F5 nota / F6 print / F1 lembrete de
   controles) — enfatizando anotar na hora, não confiar na memória depois.
7. Como fechar o teste (F7, onde o ZIP é salvo, como mandar por Discord).
8. O questionário (abaixo).
9. Agradecimento.

## Escopo do questionário (novo — primeira impressão, não comparação)

Categorias, cada uma com 2–4 perguntas curtas e sem sugerir a resposta certa
(mesmo princípio já usado no questionário do Hiago):

1. **Primeiras impressões** — entendeu sozinho o que fazer? Teve momento de
   "não sei o que fazer agora"? Alguma palavra/ícone confuso?
2. **Controles e jogabilidade** — fáceis de aprender? Movimento/combate
   pareceu natural? Ficou claro o que cada opção de level-up fazia?
3. **Dificuldade e ritmo** — fácil/difícil/na medida? Morreu e entendeu por
   quê? Teve trecho parado ou estressante demais?
4. **Sistemas novos** (loja/ferreiro/curandeiro, quebráveis) — notou? Preço
   pareceu justo? A pausa pra decidir incomodou? (pergunta sobre quebráveis
   já avisa que a arte de parte deles é provisória, pra não confundir com
   bug — mesmo cuidado já usado no PLAN-034).
5. **Visual e técnico** — algo visualmente quebrado/estranho? Texto/números
   legíveis?
6. **Fechamento** — nota 0–10 de "quanto gostaria de continuar jogando" +
   comentário livre.

Deliberadamente **não** inclui perguntas de comparação com versão anterior
(não fazem sentido pra quem nunca jogou) nem pergunta sobre sinergias
combinadas (SPEC-075) — chance baixa de um primeiro-tester alcançar isso
numa run de 15–30 min.

## Riscos e limites

- Amostra pequena e provavelmente única por pessoa (mesmo risco de "amostra
  única" já registrado em playtests anteriores) — tratar respostas como
  indício, não veredito, até haver mais de um tester.
- Sem o dono por perto: qualquer travamento de instalação (antivírus,
  SmartScreen) não tem como ser resolvido ao vivo — o guia antecipa o aviso
  do SmartScreen, mas outros problemas de ambiente (ex. falta de espaço,
  drivers gráficos) ficam fora do que o guia consegue cobrir sozinho.
- Perguntas evitam sugerir a resposta certa, mesmo princípio do
  [[PLAN-031-proximo-playtest-reavaliacao-e-questionarios-2026-09-28]].
- Este plano não abre, aprova nem executa nenhuma spec — é só preparação do
  playtest.

## Entregável

- `Guia-Playtest-Nottgard-Survivors.pdf` — guia completo + questionário,
  gerado nesta sessão.
- `build/NottgardSurvivors-Playtest.exe` — executável Playtest Público
  gerado e verificado nesta sessão (menu abre, rótulo confirma perfil
  `public`). Não commitado (`build/` no `.gitignore`) — ver
  [[EVID-105-export-playtest-publico-2026-09-29]]. Distribuição (link de
  download) segue a cargo do dono.

## Próximos passos

1. Dono distribui o link do `.exe` Playtest Público e o PDF aos testers.
2. Ao receber os ZIPs/respostas, abrir um PLAN de análise (mesmo padrão de
   [[PLAN-032-proxima-atualizacao-pos-playtest-2026-09-28]]) por tester ou
   consolidado, e registrar evidência (`EVID-*`) de cada resposta recebida.
3. Decidir mudanças de design só depois das respostas, evitando reagir a uma
   amostra única.
