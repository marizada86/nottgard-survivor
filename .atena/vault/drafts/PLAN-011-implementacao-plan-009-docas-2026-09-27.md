# PLAN-011 — Implementação do PLAN-009: Docas, chefe e Maré de Névoa

Status: implementado com validação automatizada; inspeção visual por captura de framebuffer pendente de viewport gráfico (2026-09-27).

## Objetivo

Concluir o PLAN-009 com um ambiente de Docas jogável, visualmente coerente com o vault, uma introdução de chefe reutilizável e a Maré de Névoa pós-chefe. A primeira integração é Dagruve/Docas e o Sacerdote da Mente Derretida; Willie continua candidato narrativo futuro e não substitui o chefe atual.

## Fontes e precedência

1. `D:\dev\nottgard\vault\04_Locais\Docas.md` e `03_NPCs\Willie.md`;
2. `SPEC-034`, `ART-PROMPTS-017` e `EVID-042`;
3. consumidores atuais: `ui/stages/dagruve.tscn`, `ui/prop.gd`, `core/battle.gd`, `ui/run.gd` e `data/stages.json`;
4. o estado atual da árvore de trabalho, que contém mudanças não relacionadas a preservar.

## Escopo

- Refazer e integrar o atlas de piso das Docas;
- selecionar, normalizar e integrar props aprovados por família;
- implementar overlay genérico de introdução de chefe, começando pelo Sacerdote;
- implementar Maré de Névoa pós-chefe na Dagruve, com os parâmetros aprovados;
- criar testes, screenshots e evidências para os assets e os dois fluxos de jogo.

## Não objetivos

- trocar o chefe da Dagruve por Willie ou reescrever a lore;
- produzir todos os biomas ou todas as introduções de chefe nesta entrega;
- tornar a Maré de Névoa evitável por CA, CAM ou esquiva;
- alterar a integração preexistente de `DivineVisuals` sem decisão específica;
- publicar, empacotar, fazer commit ou push.

## Contrato de experiência

### Terreno

- Chão modular e sem costura; props em PNG RGBA, com silhueta legível no viewport 1280×720;
- porto noturno decadente: madeira úmida, pedra, sal, ferrugem, carga e sinais rituais abstratos;
- névoa mantém inimigos, projéteis, recompensas e rotas visíveis.

### Chefe

1. A aproximação do chefe pausa a simulação por 0,8–1,2 s.
2. O overlay mostra a splash 16:9 por 1,5–2 s; nome e título são UI, nunca texto gerado na imagem.
3. A imagem se dissolve; o primeiro telegráfo do chefe aparece antes de o combate aceitar dano/movimento novamente.
4. O fluxo é dirigido por dados para permitir novos chefes sem duplicar UI.

### Maré de Névoa

1. Após o chefe, recompensa, `X` para extrair e `E` para portal permanecem sem dano por 8 s.
2. Um aviso visual/sonoro claro antecede o avanço a partir das bordas.
3. A névoa aplica perigo ambiental direto: 1% da vida máxima por segundo no início, com rampa até 3% após 20 s.
4. CA, CAM e esquiva não evitam o dano; uma resistência específica futura pode apenas mitigá-lo e nunca anulá-lo.
5. Extração preserva recompensas; portal continua a run com o risco/recompensa existente.

## Plano de voo

### 1. Preparação e baseline

1. Confirmar que `ART-PROMPTS-017` é a fonte de cada asset e atualizar o manifesto com cada novo consumer.
2. Manter candidatas em `.atena/generated/art-candidates/`; não sobrescrever arquivos em `assets/` até seleção e backup local.
3. Repetir a suíte headless antes de alterações; registrar o smoke test como bloqueado enquanto `DivineVisuals` estiver ausente, sem tentar corrigir esse trabalho externo.

### 2. Piloto de arte

1. Refazer `docas_ground_atlas` como arquivo opaco, sem checkerboard, margens ou espaçamento de apresentação; testar repetição 8×8.
2. Normalizar a splash do Sacerdote para 640×360 e o braseiro para 256×256 com alfa preservado.
3. Criar um sandbox visual da Dagruve e comparar props existentes, candidata e escala de combate em 1280×720.
4. Aceitar ou rejeitar o piloto por: pixel art real, transparência correta, silhueta, paleta, ausência de texto/watermark e compatibilidade com a câmera 2:1.

### 3. Lote de assets das Docas

1. Produzir no máximo três candidatas por asset, somente para correção objetiva.
2. Integrar por famílias reutilizando os consumers existentes: `braseiro`, `caixote`, `barril`, `rede`, `doca`, `carga`, `margem`, `velas` e `livros`.
3. Adicionar apenas os novos consumers indispensáveis: vestígio ritual, metal corroído, margem marítima e camada VFX de névoa.
4. Atualizar `ui/stages/dagruve.tscn` sem reexecutar o gerador global de cenas; esse gerador sobrescreve ajustes manuais.

### 4. Introdução de chefe

1. Criar uma configuração de apresentação por boss: caminho da splash, nome/título de UI, duração e cor de transição.
2. Emitir um evento de chegada uma única vez quando o boss é criado; pausar apenas a simulação, não destruir o estado da run.
3. Exibir o overlay no `ui/run.gd` ou componente dedicado, com fade e fallback limpo se a imagem não existir.
4. Ligar o áudio de chegada já presente; testar que fase, barra de chefe e telegráfos continuam corretos depois do retorno.

### 5. Maré de Névoa

1. Criar estado pós-chefe separado do combate regular: `grace`, `warning`, `advancing`.
2. Durante `grace`, manter portal/extração utilizáveis e não causar dano.
3. Durante `advancing`, calcular proximidade às bordas e aplicar dano ambiental direto pela rampa aprovada; emitir VFX da camada de névoa sem reduzir a legibilidade.
4. Expor temporizadores e intensidade apenas para testes/QA, sem UI técnica para jogadores.
5. Garantir que morte, extração, portal e transição de fase encerrem a Maré e limpem seus VFX.

### 6. Verificação e reconciliação

1. Testes de arquivo: dimensões, alfa, nomes, manifesto e inexistência de watermark/texto.
2. Testes de batalha: chegada ocorre uma vez; pausa não duplica spawns; graça dura 8 s; a rampa é 1%→3%; CA/CAM/esquiva não evitam a Maré; extração/portal vencem o fluxo.
3. Capturas da Dagruve em escala real: antes do chefe, overlay, pós-chefe em graça e névoa avançando.
4. Rodar `tests/run_all.gd` e smoke test. Se o smoke permanecer bloqueado exclusivamente por `DivineVisuals`, documentar como exceção e não alterá-lo.
5. Registrar evidência, reconciliar manifesto e atualizar o PLAN-009 para concluído somente quando todos os critérios de aceite forem demonstrados.

## Critérios de aceite

1. O terreno das Docas é modular, legível e consistente com a lore aprovada.
2. Todo prop final possui candidato, versão, prompt, manifesto e inspeção registrada.
3. A introdução do Sacerdote preserva sua identidade, tem UI sem texto embutido e não quebra o combate.
4. A Maré de Névoa força uma decisão pós-chefe justa, tem rota visível e não pode ser anulada por defesas genéricas.
5. Nenhuma mudança sobrescreve trabalho local não relacionado.
6. Testes automatizados passam; a exceção de smoke, se persistir, está registrada com causa externa demonstrada.

## Recuperação

- Cada substituição de asset faz backup local antes da cópia final.
- Dados de apresentação e Maré ficam isolados por fase/boss, permitindo desligamento seletivo.
- A remoção de um consumer novo restaura o fallback procedural/asset legado sem afetar a run.
