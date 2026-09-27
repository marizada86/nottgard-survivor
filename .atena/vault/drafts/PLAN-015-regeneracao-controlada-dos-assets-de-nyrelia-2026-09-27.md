# PLAN-015 — Regeneração controlada dos assets de Nyrelia

Status: **aprovado pelo dono — brief local em preparação** (2026-09-27).

## Objetivo

Regenerar as animações de Nyrelia para que silhueta, ações e VFX sejam
legíveis na escala real de jogo, preservando a identidade canônica e sem
substituir qualquer byte oficial antes de seleção humana e admissão rastreável.

A EVID-074 demonstrou que a falha não é de âncora: os strips atuais continuam
apoiados no chão, mas `idle`, `move_se` e `attack` não formam figura legível
em runtime. A regeneração é resposta de direção de arte, não recoloração ou
correção geométrica automática.

## Estado que deve ser preservado

- Nyrelia é a **Sacerdotisa de Mask · Greenholders**, desbloqueada por
  `pilares_ativos`, com arma `dominar_pessoa` e habilidade `dominacao`.
- A referência de identidade é o retrato atual: manto/capuz verde profundo,
  máscara escura e acentos dourados. Não mudar lore, arma, habilidade,
  atributos, passiva ou gameplay.
- Os nove strips atuais e cópias recuperáveis permanecem oficiais até que um
  candidato seja escolhido explicitamente e substituído em novo lock.
- A base continua no pixel local `y=367`; os movimentos `nw`, `w` e `sw`
  permanecem espelhamentos das direções-fonte atuais.

## Escopo

### Piloto obrigatório — 14 células

| Strip | Células | Validação |
| --- | ---: | --- |
| `idle` | 4 | Silhueta, máscara, manto e leitura parada. |
| `move_se` | 6 | Passada, contato e espelhamento `move_sw`. |
| `attack` | 4 | Corpo, gesto e efeito legíveis no mesmo quadro. |

### Lote de expansão — 36 células

Somente após o aceite do piloto: `move_n`, `move_ne`, `move_e`, `move_s`,
`active` e `death`. O conjunto completo terá 50 células em nove strips.

### Contrato visual e técnico

1. Célula de **256×384 px**, RGBA, fundo transparente, câmera isométrica 3/4
   de cima e composição compatível com o renderer atual.
2. Strip horizontal: 4 células em `idle`/`attack` (1024×384) e 6 nas demais
   ações (1536×384).
3. A base corporal visível toca `y=367`. Pé, máscara, arma e VFX essencial
   mantêm margem lateral mínima de 8 px e nunca cruzam para outra célula.
4. Em 72 px de altura, Nyrelia continua reconhecível por capuz verde, máscara,
   corpo preenchido e acentos dourados — nunca apenas por partículas ou
   contorno escuro.
5. `attack` mantém figura corporal clara nos quatro frames; o VFX de Dominação
   fica dentro da célula e não substitui a personagem.
6. Sem cenário, texto, moldura, marca d'água, sombra destacada ou pixels
   opacos fora da personagem.

## Brief de direção de arte proposto

**Prompt-base:** sprite 2D de fantasia sombria em pixel art nítida, visão
isométrica 3/4 de cima; Nyrelia, sacerdotisa mascarada de Mask, capuz e manto
verde-floresta profundo, máscara escura claramente definida, corpo e dobras
de tecido visíveis, acentos dourados discretos, silhueta forte e legível em
72 px, luz de recorte verde-ouro controlada, fundo transparente, célula única
256×384, pés firmemente apoiados na linha de chão.

**Negativo:** fundo de cenário, retrato, arte conceitual, texto, moldura,
marca d'água, personagem sem corpo, silhueta preta perdida, apenas partículas,
extremidades cortadas, arma cruzando borda, blur, gradiente suave, perspectiva
frontal, VFX fora da célula, múltiplos personagens.

Cada prompt por célula acrescentará somente pose, direção, fase e VFX. Prompt,
seed/job, licença e parâmetros serão recebidos no registro de proveniência;
nenhum prompt é enviado a fornecedor sem autorização específica.

## Plano de voo

### 1. Brief e referências locais

1. Criar uma SPEC de geração que congele o brief, os 14 IDs do piloto, as
   referências permitidas e os critérios de descarte.
2. Montar prancha local com retrato, hero asset, ícone `dominar_pessoa`,
   capturas da EVID-074 e limites de célula; registrar hash de cada referência.
3. Nenhuma referência local sai do workspace sem autorização explícita.

### 2. Escolha do caminho de geração

1. Confirmar método: geração local/hospedada, retoque manual ou provedor remoto.
   Não presumir conta, licença, disponibilidade ou custo.
2. Para provedor remoto, verificar capacidade e credencial já configurada sem
   expor segredo; apresentar jobs máximos, teto de gasto em centavos e licença.
3. Criar pedidos versionados em `.atena/generated/nyrelia-regeneration/v01/`,
   jamais com destino em `assets/` ou sobreposição de candidato existente.

### 3. Geração e seleção do piloto

1. Gerar células individuais do piloto, não uma tira final opaca; preservar
   ordem, prompt, seed/job, licença e hash de cada saída.
2. Inspecionar bytes, RGBA, dimensão, conteúdo útil, margens e ausência de
   fundo antes de montar strips candidatos.
3. Montar strips somente na pasta gerada e rodar as cenas QA para `idle`,
   `move_se`, `attack` e `move_sw` espelhado, em escala real e ampliada.
4. Apresentar ao dono candidatos por strip, comparação ao oficial e
   proveniência. O dono escolhe `aprovar piloto`, `rejeitar`, `refazer` ou
   `manter atual`.

### 4. Expansão, admissão e reconciliação

1. Após aprovação do piloto, repetir o processo para as 36 células restantes
   com a mesma bíblia visual e exceções registradas por célula.
2. Testar direções-fonte, espelhamentos, ataque, ativa e morte; rodar suíte,
   smoke e capturas de runtime.
3. Para cada strip aceito, apresentar SPEC de admissão com hash anterior/novo,
   caminho, backup, comparação e impacto. Só aprovação explícita atualiza
   `assets/`, manifesto e lock.
4. Reconciliar SPEC-043, SPEC-044 e SPEC-045 de forma aditiva; bytes anteriores
   seguem recuperáveis e registros canônicos não são apagados.

## Não objetivos

- Editar, excluir ou sobrescrever PNGs oficiais nesta etapa.
- Mudar runtime, âncora, colisão, y-sort, SFX, dados, placements, lore ou
  balanceamento para compensar a arte.
- Gerar outros heróis, props, ícones, cenários ou itens.
- Enviar referências, iniciar job remoto, gastar créditos, instalar
  dependências, publicar ou compartilhar externamente sem gate explícito.

## Critérios de aceite

1. Os 14 frames do piloto formam corpo, máscara e manto legíveis em escala
   real; `attack` preserva a figura em todos os frames.
2. Strips aceitos cumprem canvas, alfa, margens, base, contagem/ordem de frame
   e espelhamento.
3. Cada candidato tem referência, prompt, método/fornecedor, licença, data,
   hash e validação verificáveis.
4. Suíte, smoke e capturas passam sem serem usadas como prova de aceite
   artístico.
5. Nenhum byte oficial, lock ou registro canônico muda sem decisão humana de
   admissão.

## Gates de aprovação

1. **Aprovação deste plano:** cria somente a SPEC de geração e o pacote de
   brief/referência local; não gera imagens.
2. **Aprovação da SPEC de geração:** prepara pedidos e validações locais, sem
   executar geração remota ou sobrescrever assets.
3. **Autorização de geração:** confirma método, licença, referências que podem
   sair do workspace, máximo de jobs e teto de gasto. Credenciais ficam fora
   da conversa.
4. **Seleção do piloto:** escolhe a elegibilidade dos candidatos; nada entra
   em `assets/` automaticamente.
5. **Admissão por strip:** única autorização para substituir bytes e atualizar
   lock/registros canônicos.

## Recuperação

- PNGs oficiais, locks e backups são imutáveis durante a geração. Todo novo
  resultado fica em versão nova sob `.atena/generated/`.
- Resultados rejeitados permanecem auditáveis, porém fora de manifest e lock.
- Cada admissão conserva hash anterior e cópia recuperável para reversão.
