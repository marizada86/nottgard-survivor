# SPEC-020 — Ferramentas de playtest e navegação QA

Status: **aprovada (2026-09-23) — em execução**.

## Decisão proposta

Criar um kit de evidências com perfis explícitos de build e um Navegador QA
restrito ao build interno. O kit parte dos sistemas que já existem neste jogo,
mas o contrato abaixo substitui o comportamento operacional atual do kit quando
for aprovado. Esta spec não altera lore, conteúdo de jogo nem o save canônico.

## Discovery da arquitetura atual

- O projeto é Godot 4.7, abre em `ui/menu.tscn` e possui os autoloads `Game`,
  `Sfx` e `Playtest` (`project.godot`).
- `core/playtest.gd` já é uma camada persistente de evidências: F5 abre nota,
  F6 captura o viewport, F7 cria ZIP, F11 alterna tela cheia e o rascunho atual
  fica em `user://evidencias/rascunho`. Os limites atuais são 20 imagens, 8 MiB
  e 1.000 caracteres por nota. Não há F12 nem navegador QA.
- `core/game.gd` centraliza o perfil em `user://profile.json`; `Game.save()`
  sempre grava esse caminho. Encerrar uma run chama `Profile.apply_run()` e
  salva. Logo, navegar para uma run hoje pode contaminar o progresso real.
- O menu é o Quartel, com as abas Jogar, Melhorias, Conquistas, Códex e Opções
  (`ui/menu.tscn`). A única cena jogável é `ui/run.tscn`; ela instancia a cena
  de fase pelo identificador da run.
- A simulação `Battle` é separada da UI, aceita seed no construtor e já declara
  os estados `running`, `levelup`, `altar`, `dead` e `won`. Isso permite cenários
  reproduzíveis sem automação de teclado frágil. Há testes determinísticos e
  smoke para todas as fases em `tests/` e `tools/`.
- Os destinos jogáveis reais são: `dagruve`, `shedaklah`, `molor`, `durao`,
  `feng_tu`, `shendilavri`, `goranthis` e `pilares`. Suas regras de fase estão
  em `data/stage_rules.json`, e os chefes têm viradas aos 70% e 35% de vida em
  `data/boss_phases.json`.
- Hoje `Version.PLAYTEST_BUILD` é uma constante única e o preset Windows não
  declara perfis de recurso distintos. Portanto, a separação de builds será
  uma mudança técnica deliberada, não uma suposição sobre o export atual.

## Escopo

### 1. Perfis de build e atalhos

O runtime resolverá exatamente um perfil, usando uma feature de exportação
explícita. Build sem feature, ou com mais de uma feature, falha de modo seguro
como **produção** e registra o diagnóstico apenas no log local. Os perfis são:

| Atalho | Produção | Playtest público | QA interno |
|---|---|---|---|
| F5 | Sem ação do kit | Alterna nota e pausa a run | Igual ao público |
| F6 | Sem ação do kit | Captura evidência do viewport sem pausar | Igual ao público |
| F7 | Sem ação do kit | Empacota o rascunho em ZIP | Igual ao público, incluindo cenário QA |
| F11 | Alterna tela cheia e salva apenas a preferência normal | Igual | Igual |
| F12 | Sem ação do kit | Abre/fecha console de diagnóstico somente leitura, com log higienizado | Abre/fecha Console QA: mesmo log e comandos permitidos, sem avaliação livre de código |
| Ctrl+O+P | Sem ação | Sem ação | Abre o Navegador QA |

O acorde simultâneo Ctrl+O+P exibirá uma dica visível em QA e não interceptará
digitação enquanto um campo de texto estiver com foco. Nenhuma função QA será
desbloqueada apenas por argumento de linha de
comando, arquivo de save ou variável de ambiente.

Execuções visíveis de depuração, incluindo o jogo iniciado pelo editor Godot,
resolvem para QA Interno para permitir a validação local. Exports release sem
feature continuam em Produção; processos headless não habilitam o kit.

O console público não oferece execução, edição nem comandos de sistema. No QA,
os comandos são uma lista curta e declarada (ajuda, copiar diagnóstico
higienizado, repetir o cenário atual e voltar ao Quartel); a navegação e
injeção de estado continuam exclusivas do Navegador QA. Não haverá REPL,
`eval`, console da engine exposto ou comandos de arquivo.

### 2. Rascunho, pacote de evidências e privacidade

Cada build habilitado manterá um rascunho por sessão em:

```text
user://evidence-kit/<perfil>/drafts/<id-da-sessao>/
  item-001.json
  item-001.png                 # somente quando houver captura
  ...
user://evidence-kit/<perfil>/outbox/
  NS-EV-<perfil>-<utc>-<sequencia>.zip
```

`<perfil>` é `public` ou `qa`; produção não cria essas pastas. Ao exportar, a
interface mostra o caminho absoluto resolvido de `user://...`, para que a pessoa
possa localizar o arquivo. O ZIP terá este formato:

```text
manifest.json                  # versão, build, horário UTC, limites e contagens
notes.md                       # notas e contexto higienizado; ausente se não houver notas
log.txt                        # últimas 200 linhas higienizadas do log do jogo
screenshots/001-note.png
screenshots/002-shot.png
qa/scenario.json               # somente QA, com id do cenário, seed e parâmetros declarados
```

O manifesto registra versão do jogo, identificador do build, plataforma ampla,
horário UTC, número dos itens e contexto de jogo. Em uma run, o contexto inclui
herói, fase, seed, tempo, nível, vida, armas, habilidade ativa, profundidade,
estado, regra de fase e quantidade de inimigos. Ele **não** inclui o arquivo de
save, moedas/progresso persistente, nome de conta do sistema, caminhos
absolutos, argumentos de execução, IP, contatos nem variáveis de ambiente.

O nome do playtester é opcional, limitado a 24 caracteres e tratado como texto
fornecido voluntariamente. Capturas são apenas do viewport Godot, nunca da área
de trabalho. Antes de gravar notas, log e contexto, o kit remove nome de usuário
do sistema e caminhos conhecidos; a UI também avisa para não inserir dados
pessoais em uma nota. A higienização é defesa adicional, não promessa de
remover dados pessoais que alguém digitou deliberadamente.

O rascunho é gravado após cada nota ou captura mediante escrita atômica
(temporário + renomeação) e é restaurado ao reiniciar o jogo. O pacote aceita no
máximo 20 imagens, 8 MiB somando imagens e texto serializado, e 1.000 caracteres
por nota. A 80% do limite a interface alerta; no limite, recusa o novo item sem
descartar os anteriores. Arquivos de rascunho incompletos ou inválidos são
ignorados individualmente e registrados no console higienizado, preservando os
itens válidos.

F7 somente limpa o rascunho após concluir o ZIP, fechar o escritor e confirmar
que o arquivo final é legível e não vazio. A exportação usa arquivo temporário
no `outbox` e só então renomeia para o nome final. Se abrir ou escrever o ZIP
falhar (incluindo disco cheio, pasta sem permissão ou mídia removida), o kit:

1. informa uma falha acionável, sem dizer que a evidência foi salva;
2. mantém itens já persistidos e itens em memória para nova tentativa;
3. tenta uma única pasta de recuperação em `user://evidence-kit/<perfil>/recovery/`;
4. se a recuperação também falhar, não apaga, não sobrescreve e não tenta em
   ciclo; registra o motivo disponível e sugere liberar espaço/reabrir o jogo.

Caso salvar um item do rascunho falhe, ele permanece em memória marcado como
“não persistido”; F7 pode tentar incluí-lo. A sessão jamais descarta um pacote
por falta de espaço sem confirmação explícita da pessoa.

### 3. Navegador QA e sandbox de save

O Navegador QA será uma sobreposição interna, aberta por Ctrl+O+P. A ação
`Abrir destino` usa somente estados de run declarados, não campos livres de
caminho, cena ou serialização; `Abrir Quartel` continua separado. A lista é
preenchida a partir dos identificadores válidos de `data/*.json` e apresenta
nome legível, id técnico, seed e descrição do estado. Ele permite escolher:

- **Quartel:** as abas Jogar, Melhorias, Conquistas, Códex e Opções;
- **Início de run:** qualquer combinação válida de herói e uma das oito fases,
  ignorando bloqueios de desbloqueio somente dentro do sandbox;
- **Estado de decisão:** oferta de level-up e altar com seed fixada;
- **Combate de chefe:** entrada, virada de 70% e virada de 35% de cada chefe
  associado às oito fases;
- **Transição:** portal aberto após o chefe, extração disponível e resultado de
  vitória ou derrota;
- **Regra de fase:** rituais de Dagruve, esporos de Shedaklah, bolhas de Molor,
  corrente de Durao, raios de Feng-tu, ilusões de Shendilavri, santuário de
  Goranthis e rotação de regras nos Pilares.

Cada lançamento é descrito por um `QaLaunchRequest` serializável, com `id`,
`seed`, `hero_id`, `stage_id`, `target_state` e parâmetros estreitamente
validados. Um construtor de cenários prepara a mesma simulação `Battle` que a
run normal, aplicando apenas mutações declaradas para chegar ao estado. Não
serão usados cliques simulados, reflexões em nós privados, caminho arbitrário
de cena ou edição livre de JSON.

Toda navegação QA inicia uma sessão de perfil isolada. Durante a sessão:

- `Game` lê o perfil real apenas uma vez para criar uma cópia em memória, ou
  inicia o perfil mínimo declarado pelo cenário;
- qualquer operação que no fluxo normal chamaria `Game.save()` grava somente
  em `user://qa-sandbox/<id-da-sessao>/profile.json` ou é mantida em memória;
- o caminho real `user://profile.json` é tratado como somente leitura e nunca
  é aberto para escrita;
- sair do cenário descarta a sessão sandbox, salvo o rascunho de evidência;
- o navegador identifica visualmente “QA sandbox — progresso real preservado”.

Antes de iniciar e depois de sair da sessão, a implementação compara a presença
e o hash do save real. Uma divergência é falha de QA e impede declarar o cenário
como aprovado. O resultado da run mostrará resumo calculado para o sandbox, sem
conceder moedas, desbloqueios, conquistas ou entradas de Códex ao save real.

### 4. Cenários QA reproduzíveis

Os cenários abaixo constituem catálogo inicial. Cada um terá id estável, seed
fixa, parâmetros no manifesto de evidência e teste automatizado associado.

| Id | Preparação declarada | Verificação observável |
|---|---|---|
| `qa.menu.<aba>` | Abre cada aba real do Quartel no perfil sandbox | Aba selecionada e controles daquela tela carregados |
| `qa.run.<fase>.start` | `hero_id=durvall`, `stage_id=<fase>`, `seed=1000+ordem`, estado `running` | Cena, cenário, regra, herói e diretor da fase existem |
| `qa.levelup.dagruve` | Dagruve, seed 1101, XP suficiente para uma oferta | Estado `levelup`, 3 ou mais opções válidas; escolher retorna a `running` |
| `qa.altar.<fase>` | Fase, seed 1200+ordem, altar ativo próximo ao herói | Estado `altar`, três bênçãos válidas e retorno a `running` |
| `qa.boss.<fase>.enter` | Fase, seed 1300+ordem, chefe presente | Chefe correto, HUD e música de chefe ativáveis |
| `qa.boss.<fase>.p70` | Mesmo cenário, vida do chefe preparada acima do limiar e dano controlado | Uma virada de 70%, evento e ações declaradas em `boss_phases.json` |
| `qa.boss.<fase>.p35` | Mesmo cenário para a segunda virada | Uma virada de 35%, sem repetir a primeira |
| `qa.portal.<fase>` | Chefe derrotado em fase que tem próxima camada | Portal disponível; interação leva à fase `next` no sandbox |
| `qa.result.victory` / `qa.result.defeat` | Resultado construído no sandbox, seed 1401/1402 | Painel de resultado e resumo corretos, sem modificar save real |
| `qa.rule.<fase>` | Fase e seed que força a primeira ocorrência da regra | Evento/entidade própria da regra aparece de forma verificável |
| `qa.pilares.rotation` | Pilares, seed 1501, tempo no limiar de rotação | A próxima regra declarada substitui a anterior e é registrada |

`<fase>` só pode ser um dos oito ids declarados nesta spec. O catálogo poderá
ganhar cenários apenas por nova spec aprovada; a interface não permitirá inventar
ids. Para a matriz de heróis, o navegador aceitará todos os ids atuais de
`data/heroes.json`, ainda que bloqueados no jogo normal, e o teste verificará
que cada combinação selecionada por dados é válida ou devolve erro claro.

## Fora de escopo

- Mudança de balanceamento, regras, armas, heróis, inimigos, conquistas, fases
  ou conteúdo narrativo.
- Telemetria remota, upload automático, login, coleta de identificação ou envio
  do ZIP por rede.
- Console de desenvolvedor com execução arbitrária, inspeção de memória ou
  acesso a arquivos do computador.
- Alterar o save real, oferecer edição permanente de progresso ou converter o
  Navegador QA em menu de trapaças para builds públicas.
- Reestruturar cenas do menu/run além do adaptador mínimo necessário para
  receber um destino QA.

## Impactos previstos

- `project.godot`, `export_presets.cfg` e `core/version.gd`: enumeração de
  perfil e features de exportação; o valor único atual de playtest deixará de
  ser suficiente.
- `core/game.gd` e o acesso ao perfil: abstração de destino de persistência para
  garantir sandbox verificável, sem mudar o formato do save real.
- `core/playtest.gd`: máquina de estados do kit, captura, ZIP, limites,
  higienização, recuperação de disco, F12 e UI adaptada aos perfis.
- Novos componentes QA de lançamento/navegação, adaptadores pequenos em
  `ui/menu.gd` e `ui/run.gd`, sem duplicar simulação.
- `tests/`: testes de perfil de build, storage de evidências, privacidade,
  determinismo dos cenários e imutabilidade do save; smoke ampliado quando
  necessário.
- `SPEC-006` deverá receber reconciliação após a execução, pois documenta o kit
  anterior. Nenhum registro canônico será modificado nesta etapa de rascunho.

## Critérios de aceite

1. Os três perfis de build resolvem de forma exclusiva e todos os atalhos da
   tabela obedecem ao perfil, incluindo F11 em produção e a ausência completa de
   F5/F6/F7/F12/Ctrl+O+P fora dos perfis autorizados.
2. No playtest público é possível criar nota, captura e ZIP; o ZIP contém o
   formato prometido, respeita os limites e não inclui save, usuário do sistema
   nem caminho absoluto de teste conhecido.
3. Rascunho válido sobrevive a reinício. Em falha de gravação ou disco cheio, os
   itens não somem e a UI relata o estado real; o rascunho só é limpo depois de
   um ZIP final legível.
4. Para cada destino e cenário do catálogo, o Navegador QA abre o estado certo
   com seed e parâmetros registráveis; repetir a mesma requisição produz a mesma
   configuração inicial normalizada.
5. Todos os cenários QA rodam sob sandbox: hash/presença de `user://profile.json`
   é idêntico antes e depois; moedas, desbloqueios, conquistas e Códex reais não
   mudam.
6. Os testes existentes de dados, batalha e perfil continuam verdes; os novos
   testes cobrem cada perfil, o catálogo de cenários, fluxo de ZIP e as falhas
   de armazenamento. O smoke abre menu e as oito fases com o kit inerte onde
   não se aplica.
7. Os controles continuam usáveis em 1280×720 e em viewport reduzido; a
   sobreposição bloqueia somente a entrada que ela cobre e restaura pausa/foco
   corretamente ao fechar.

## Plano de voo

1. Confirmar esta spec e converter seu status para aprovada; registrar eventuais
   decisões de UX que alterem o contrato de atalhos ou privacidade.
2. Introduzir o resolvedor de perfis de build e testes de seleção exclusiva,
   mantendo produção como padrão seguro.
3. Extrair a persistência de perfil para um destino injetável, implementar
   sandbox QA e os testes de hash do save real antes de expor o navegador.
4. Reestruturar o kit de evidências em armazenamento atômico, manifesto,
   higienização, limites e recuperação de disco; testar com um backend de disco
   que simula erro.
5. Implementar F5/F6/F7/F11/F12 por perfil e validar captura, pausa, foco e
   acessibilidade da UI.
6. Implementar `QaLaunchRequest`, catálogo, Navegador QA e adaptadores de menu/
   run; adicionar os cenários declarados sem alterar dados de design.
7. Rodar suíte, smoke e cada cenário; montar evidência local em
   `.atena/evidence/` com versão, comandos, resultados, arquivos tocados e hash
   de save antes/depois.
8. Fazer revisão independente contra critérios de aceite, reconciliar SPEC-006
   e atualizar esta spec para executada somente se todos os critérios tiverem
   evidência ou exceção aprovada.

## Evidência e reconciliação previstas

Após aprovação e execução, registrar em `.atena/evidence/`:

- `EVID-039-modal-atalhos-e-reconciliacao.md` registra o alinhamento do acorde
  QA e a validação automatizada deste lote; a spec permanece em execução até a
  validação integrada de ZIP, sandbox e cenários QA.

- matriz de atalhos por perfil e resultado de cada teste;
- inventário de um ZIP público e um ZIP QA, com inspeção de privacidade;
- teste de limite, rascunho reiniciado e simulação de falha de disco;
- catálogo QA executado com seed/requisição e resultado;
- hashes do save real antes/depois de cada cenário;
- suíte e smoke, incluindo exceções aprovadas se houver.

Implementação iniciada após aprovação em 2026-09-23. A evidência disponível está
em `EVID-SPEC-020-implementation-2026-09-23.md`; a spec só será marcada como
executada após suíte Godot, smoke e cenários QA serem validados.
