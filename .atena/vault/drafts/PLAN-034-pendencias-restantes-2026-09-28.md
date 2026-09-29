# PLAN-034 — Plano para as pendências restantes

Status: **alinhado com o dono em 2026-09-28 — ordem definida, primeira spec
em preparação.**

## Decisões da entrevista de alinhamento (2026-09-28)

1. **Nível de equipamento**: o ferreiro (SPEC-064) ganha uma segunda oferta
   para subir o nível do equipamento atual (armadura/amuleto/anel) pagando
   moeda — sem depender de achar duplicata. A escolha de equipar/vender da
   SPEC-060 não muda.
2. **Super upgrade no nível máximo**: bônus próprio definido à mão por base
   de item (como o `evolve` das armas), não uma fórmula genérica.
3. **Ordem**: segurar clique pra andar → Fase C (nível de equipamento,
   depois sinergias) → rótulo `qa.cenario` → questionário de playtest
   (quando fizer sentido cronologicamente).
4. **Rótulo `qa.cenario`**: corrigir.

## Escopo deste plano

Por pedido do dono, ficam **fora** deste plano (já resolvidos ou tratados
à parte):
- Geração de arte pendente (Zumbi, quebráveis, props de cenário) — em
  andamento, fora deste plano.
- Commit do trabalho acumulado — resolvido depois, fora deste plano.
- Checagem manual interativa — **feita**, funcionando bem, sem muito a
  acrescentar agora.

Ficam dentro deste plano as quatro pendências restantes listadas no status
anterior:

1. Fase C do backlog original do Hiago (nível máximo de equipamento +
   sinergias combinadas) — nunca iniciada.
2. "Segurar clique esquerdo para andar" — pedido novo, sem spec.
3. Questionário de playtest desatualizado (PLAN-031 não cobre loja/
   ferreiro/curandeiro nem os quebráveis por bioma).
4. Rótulo `qa.cenario` do Navegador QA ficando desatualizado — cosmético,
   registrado, nunca decidido.

## 1. Fase C: nível máximo de equipamento + sinergias

### Discovery

- **Equipamento hoje não tem nível.** `data/items.json` só define `bases`
  (mods fixos), `affixes` (faixa de valor por raridade) e `uniques` (mods
  fixos + `tier`). Não existe conceito de "nível 1, 2, 3..." para
  armadura/amuleto/anel — cada item é um objeto único, rolado uma vez.
- **Armas já têm exatamente o padrão pedido**: `data/weapons.json` tem
  `levels: [...]` (progressão por nível) e `evolve: {"passive": ..., "into":
  ...}` (evolução ao combinar arma + passiva no nível máximo). O pedido do
  Hiago é, na prática, "quero isso para armadura/amuleto/anel também".
- **Não existe hoje nenhum caminho pra um item ganhar nível.** Ao encontrar
  um segundo item pro mesmo slot, [[SPEC-060-escolha-de-equipar-ou-vender-loot]]
  já oferece equipar-o-novo ou vender-um-dos-dois — nunca "combinar os dois
  num nível mais alto". Isso precisa de uma decisão de design (ver pergunta
  abaixo).
- **O ferreiro (SPEC-064) hoje só sobe nível de arma.** Ele já sabe fazer
  "subir 1 nível por moeda" — extremamente próximo do que o Hiago pediu para
  equipamento, só que restrito a `hero.weapons` hoje.
- **Decisão já tomada na entrevista anterior:** nível máximo/sinergia vale
  para qualquer run, não só o modo infinito — sem regra especial por
  profundidade.

### Decisões necessárias antes de abrir a spec

1. **Como um item ganha nível?** Não há resposta óbvia porque, ao contrário
   de armas (ID fixo), itens de armadura/amuleto/anel são rolados com
   afixos aleatórios — "o mesmo item" não é uma noção clara. Três caminhos
   possíveis, sem ordem de preferência minha:
   - Encontrar outro item da **mesma base** (ex. dois itens "Cota de Malha",
     independente da raridade/afixos) no mesmo slot já equipado
     **consolida em nível** em vez de abrir a escolha de equipar/vender da
     SPEC-060.
   - O **ferreiro** (SPEC-064) ganha uma segunda oferta: subir o nível do
     equipamento atual (armadura/amuleto/anel), não só de arma — sem
     depender de encontrar duplicata, só de ter moeda.
   - Os dois juntos: duplicata consolida nível de graça; ferreiro também
     oferece subir nível pagando.
2. **Nível máximo entrega o quê?** O exemplo do Hiago ("Cota de Malha nível
   máximo → +1 CA e +2 Força") sugere um bônus fixo e nomeado por base de
   item, não uma fórmula genérica — ou seja, cada uma das ~11 bases de
   `data/items.json` precisaria de um "super-upgrade" próprio definido à
   mão, parecido com o `evolve` das armas. Confirmar se é isso mesmo ou se
   um bônus genérico (ex. "+20% de todos os mods do item") serve.
3. **Sinergias (item 7) dependem do item 6 existir primeiro** — só faz
   sentido combinar arma+acessório+magia "no nível máximo" depois que
   acessório tiver nível. Proponho uma spec para nível de equipamento
   primeiro, sinergias depois, como já estava em
   [[PLAN-030-backlog-hiago-itens-equipamento-e-economia-2026-09-27]].

## 2. Segurar clique esquerdo para andar

### Discovery

- Hoje o movimento é só WASD/setas (`Hero.movement_input()`,
  `ui/run.gd:_physics_process`). O mouse já é usado continuamente pra mirar
  no modo Mira MOUSE (`battle.aim_dir`/`aim_pos`, recalculado todo frame pela
  posição do cursor) — **sem precisar de clique**. Isso significa que
  segurar o botão esquerdo pra andar **não deveria conflitar** com a mira:
  a mira já não depende de clique nenhum, então sobra o botão esquerdo livre
  pra virar uma entrada de movimento.
- Implementação provável: enquanto o botão esquerdo estiver pressionado,
  computar uma direção de movimento a partir do vetor herói→mouse (como o
  `aim_dir` já faz) e somar/substituir a leitura de `Hero.movement_input()`
  em `ui/run.gd`.

### Risco a decidir

- Clicar em botões de UI (loja, level-up, etc.) usa o mesmo botão esquerdo
  do mouse — precisa garantir que segurar o clique sobre um botão não também
  mova o herói por baixo do painel. Isso é resolvível (checar
  `battle.state == "running"` antes de tratar o clique como movimento, o que
  já bloqueia automaticamente durante ofertas/pausas), mas é um detalhe de
  execução, não uma decisão de design.

## 3. Atualizar o questionário de playtest

[[PLAN-031-proximo-playtest-reavaliacao-e-questionarios-2026-09-28]] e o PDF
já enviado foram escritos antes de SPEC-061/063/064 existirem. Proponho
atualizar (nova versão do documento e do PDF) pra incluir:
- Perguntas sobre loja/ferreiro/curandeiro (descoberta, se os preços parecem
  justos, se a pausa pra negociar incomoda).
- Pergunta se os quebráveis por bioma foram notados (avisando que a arte
  ainda é placeholder, pra não confundir isso com bug).
- Manter as perguntas antigas que ainda não tiveram resposta de um segundo
  playtester (risco de amostra única, já registrado).

Isso não depende de decisão de design — só depende de quando vai rolar o
próximo playtest, pra saber se vale atualizar agora ou esperar a arte
chegar primeiro (pra perguntar sobre os quebráveis com a arte certa, não a
provisória).

## 4. Rótulo `qa.cenario` desatualizado

Achado original em EVID-088: ao navegar pelo Navegador QA e depois continuar
jogando normalmente, o campo `qa.cenario` do manifesto de evidência fica
com o cenário antigo, não o contexto real da nota.

**Discovery ampliada (2026-09-28)**: o problema não é só o rótulo. Só existe
um jeito de encerrar `Game.qa_sandbox`/`qa_launch` — o botão "encerrar
sandbox" do próprio Navegador QA (`Playtest._end_qa()`). O botão "voltar ao
menu" do HUD durante uma run QA (`ui/run.gd:45`, usado em pausa/derrota/
vitória) não encerra o sandbox. Enquanto ele fica preso em `true`, uma run
normal jogada depois pelo menu herda a preparação QA antiga e tem seu
resultado salvo em `user://qa-sandbox/<sessão>/profile.json`, não no save
real — sem aviso. O `qa.cenario` errado é sintoma desse vazamento, não a
causa isolada. Isso já era o comportamento pretendido por
[[SPEC-020-ferramentas-playtest-e-qa]] ("sair do cenário descarta a sessão
sandbox"), só nunca implementado para a saída via HUD.

**Decisão (2026-09-28)**: corrigir o vazamento do sandbox (não só o rótulo),
fazendo o botão de menu do HUD encerrar o sandbox quando ele estiver ativo —
ver [[SPEC-074-correcao-do-vazamento-do-sandbox-qa]]. Mantém a ordem já
combinada no PLAN-034 (não pula a frente do questionário de playtest), por
afetar somente o build QA interno.

## Progresso

1. **Segurar clique pra andar**: [[SPEC-072-segurar-clique-para-andar]]
   aprovada e **executada em 2026-09-28** — suíte e smoke verdes; checagem
   manual interativa do dono pendente. Evidência em
   [[EVID-096-spec-072-segurar-clique-para-andar-2026-09-28]].
2. **Fase C — nível de equipamento**:
   [[SPEC-073-nivel-de-equipamento-e-super-upgrade]] aprovada e **executada
   em 2026-09-28** — suíte e smoke verdes; checagem manual interativa do
   dono pendente. Evidência em
   [[EVID-097-spec-073-nivel-de-equipamento-2026-09-28]]. Sinergias
   combinadas (item 7 do backlog original) foram planejadas e executadas em
   seguida — ver [[PLAN-035-sinergias-combinadas-arma-acessorio-magia-2026-09-28]]
   e [[SPEC-075-sinergias-combinadas-arma-acessorio-magia]].
3. **Rótulo `qa.cenario`**: [[SPEC-074-correcao-do-vazamento-do-sandbox-qa]]
   aprovada e **executada em 2026-09-28** — suíte e smoke verdes; checagem
   manual interativa do dono pendente. Evidência em
   [[EVID-098-spec-074-vazamento-do-sandbox-qa-2026-09-28]].
4. **Questionário de playtest**: fica pra quando fizer sentido
   cronologicamente com o próximo playtest.

## Limites

- Nenhuma spec foi aberta a partir deste plano ainda.
- Nenhum arquivo de jogo foi alterado nesta análise.
