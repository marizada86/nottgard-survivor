# SPEC-036 — Dagruve, Docas e Navegador de Cenários QA

Status: **implementada e verificada em testes headless; inspeção visual manual pendente** (2026-09-27).

## Intenção

Transformar a antiga fase conjunta Dagruve/Docas em duas fases sequenciais,
mantendo a experiência legível, os fatos canônicos e o progresso existente. Dar
à build de desenvolvimento um Navegador de Cenários capaz de preparar, alguns
segundos antes, eventos e chefes reais com uma build escolhida pelo testador.

## Fontes e precedência

1. `.atena/vault/canon/PLAN-001-nottgard-survivors.md`, seção 20;
2. `D:\dev\nottgard\vault\04_Locais\Dagruve.md` e `Docas.md`;
3. a missão M1 e as salas da referência Nottcard, especialmente `rooms_m1()`;
4. dados, cenas, testes e consumidores atuais deste projeto;
5. esta especificação, apenas para decisões de implementação que não alterem
   os fatos acima.

## Escopo

- Criar a fase `docas`, preservando o ID `dagruve` para a primeira fase.
- Reordenar a progressão para `dagruve -> docas -> shedaklah` e migrar saves
  que já tenham Dagruve concluída para que Docas não fique bloqueada.
- Destinar o Sacerdote da Mente Derretida a Dagruve e o Guardião Alado
  Verdadeiro a Docas, incluindo dados de chefe, apresentação e fases.
- Separar cenas, ondas, elites, interações, ambiente, áudio e miniatura por
  fase, sem reexecutar o gerador global de cenas.
- Declarar eventos por fase com aviso, telegráfo, execução e resultado.
- Expandir o Navegador QA da build de desenvolvimento para compor a build de
  teste e iniciar cenários alguns segundos antes do gatilho.
- Cobrir a entrega com testes de dados, migração, simulação, sandbox e
  evidência visual.

## Não objetivos

- Criar ou aprovar arte final nova, reabrir seleção de assets ou gerar imagens.
- Alterar lore, narrar a campanha, adicionar Willie como chefe ou mudar a
  identidade das fases posteriores.
- Expor o Navegador QA a builds de jogador, saves reais ou versões publicadas.
- Adicionar dependências, publicar, criar build distribuível ou fazer commit.

## Design das fases e eventos

### Dagruve — 8 minutos

- Base: distrito negligenciado sob névoa, culto e rituais.
- Chefe: Sacerdote da Mente Derretida.
- Evento principal: Ritual da Névoa. Sinais de cultistas, velas e névoa levam
  ao selo telegráfado; interrompê-lo impede reforços, falhar os libera.
- Evento de pressão: pulso da fratura, comunicado por vento, distorção e
  espessamento da névoa antes da zona hostil.

### Docas — 10 minutos

- Base: cais atacado, fenda, porão, livros e ritual de M1.
- Chefe: Guardião Alado Verdadeiro.
- Eventos: chegada no cais, pulso da fenda, corrosão no armazém e encontro de
  cópias do Guardião antes do ritual final.
- O Guardião preserva a investida e o grito abissal já definidos; as viradas
  de 70% e 35% devem ser telegráfadas e testáveis.

Todo evento novo terá uma entrada em dados contendo identificador, fase,
momento ou condição, duração de preaviso, telegráfo, efeito, condição de
sucesso/falha e recompensa ou consequência. A interface não calcula regras de
jogo; ela só apresenta os eventos emitidos pela simulação.

## Navegador de Cenários QA

Mantém o acesso já restrito a `Version.qa_enabled()` e ao sandbox. Antes de
iniciar, o testador escolhe herói, fase, seed, nível, armas, itens/passivas e
cenário. A validação recusa IDs desconhecidos e combinações impossíveis.

O catálogo inicial deve conter, quando aplicável:

- aviso, execução, sucesso e falha de cada evento ambiental;
- chegada, habilidades principais, 70%, 35% e derrota de cada chefe;
- elite e composição de onda;
- altar, baú, mímico, fonte, ritual e portal;
- estado pós-chefe e Maré de Névoa quando configurada.

O padrão é cinco segundos de antecedência. A preparação chama os caminhos
normais de simulação: a entrada de chefe, por exemplo, emite apresentação,
áudio e telegráfo em vez de somente instanciar o inimigo.

## Impactos previstos

- `data/stages.json`, regras e novos dados de eventos;
- `data/enemies.json`, apresentações de chefe e manifestos de áudio/arte
  apenas quando o consumidor correspondente já existir;
- `ui/stages/dagruve.tscn`, nova `ui/stages/docas.tscn`, menu, run e HUD;
- perfil/migração de progresso; batalha, QA e seus testes;
- `SPEC-007` e `SPEC-034`: permanecem como histórico, mas suas afirmações de
  fase única e Sacerdote nas Docas são substituídas por esta spec e pelo cânone.

## Plano de voo

1. Inventariar consumidores de `dagruve` e o formato de progresso; estabelecer
   a migração idempotente e testes antes de mudar dados.
2. Criar `docas` e dividir cenas/dados sem apagar assets nem mudanças locais.
3. Ajustar ordem, desbloqueios, portal e save; verificar que uma campanha nova
   e uma já concluída seguem rotas corretas.
4. Declarar e implementar os eventos de Dagruve e Docas pela simulação, com
   sinais e telegráfos apresentados pela UI.
5. Configurar Guardião Verdadeiro como chefe de Docas e corrigir a apresentação
   do Sacerdote para Dagruve; verificar entrada, fases e término.
6. Ampliar o Navegador QA e o contrato de lançamento para build configurável e
   pré-evento determinístico.
7. Executar testes, cenários QA e capturas; registrar evidências e reconciliar
   consumidores, specs históricas e fatos operacionais.

## Critérios de aceite

1. Menu e dados apresentam Dagruve e Docas como fases distintas e sequenciais.
2. Dagruve dura 8 minutos e Docas 10 minutos em condições normais; nenhuma
   fase regular nova supera 15 minutos.
3. O Sacerdote só é chefe de Dagruve e o Guardião Verdadeiro só é chefe de
   Docas.
4. Save com Dagruve concluída libera Docas; a migração é segura e idempotente.
5. Cada evento tem aviso, telegráfo, janela de resposta e resultado observável.
6. O QA inicia cinco segundos antes do gatilho escolhido, usa a build definida
   pelo testador, é determinístico por seed e não altera o save real.
7. A suíte planejada passa e as capturas demonstram ambos os mapas, um evento
   de cada fase e ambos os chefes.

## Evidência e reconciliação

- Testes de estrutura, cena, progressão, migração e catálogo QA.
- Testes de batalha para uma execução e uma falha de cada evento, além de
  entrada/fases/morte dos chefes.
- Capturas de pré-evento, evento ativo e resultado para cada fase.
- Registro em `.atena/evidence/` que relacione cenários, seed, build e captura.
- Revisão final contra cada critério de aceite e contra as mudanças locais
  preexistentes antes de qualquer conclusão.
