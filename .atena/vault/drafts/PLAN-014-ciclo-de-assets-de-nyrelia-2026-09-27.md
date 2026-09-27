# PLAN-014 — Ciclo de correção e curadoria dos assets de Nyrelia

Status: **aprovado pelo dono — diagnóstico limitado em execução** (2026-09-27).

## Objetivo

Restabelecer uma apresentação consistente e legível de Nyrelia no jogo, sem
confundir o status oficial atual dos seus bytes com aceite visual definitivo.
O plano cobre a coerência entre a arte estática, retrato, ícone de arma e as
nove animações de runtime, com prioridade para eliminar flutuação, cortes de
VFX, leitura ruim de ação e divergência perceptiva de identidade.

## Estado conhecido

- Os nove strips de Nyrelia foram normalizados na SPEC-043 e hoje são bytes
  oficiais, registrados no `ASSET-OFFICIAL-LOCK-009.json`.
- Essa oficialidade foi aceita com ressalvas: `attack`, `active` e `death`
  não foram afirmados como visualmente completos pelo registro canônico.
- A inspeção visual interativa em jogo, que seria a prova final da SPEC-043,
  não foi concluída. Assim, a causa residual pode estar nos pixels, na
  importação, no recorte/animação de runtime ou na relação entre essas camadas.
- Há uma base recuperável dos strips originais e candidatas anteriores; nada
  será sobrescrito durante o diagnóstico.

## Escopo

### Pacote visual a auditar

1. `assets/animations/heroes/nyrelia/`: `idle`, `move_n`, `move_ne`,
   `move_e`, `move_se`, `move_s`, `attack`, `active` e `death`.
2. `assets/heroes/nyrelia.png`, `assets/portraits/nyrelia.png` e
   `assets/icons/weapons/dominar_pessoa.png`, apenas para verificar coerência
   de identidade, escala e linguagem visual com o sprite de jogo.
3. Os SFX de Nyrelia e de `dominar_pessoa`, somente para conferir sincronismo
   com as ações após um candidato de animação ser mostrado em runtime.

### Perguntas que o diagnóstico deve responder

- O pé/base visível toca a mesma linha de chão em cada frame e nas direções
  espelhadas?
- Alguma figura, arma ou VFX essencial cruza a divisão de 256 px entre células?
- O importador e `SpriteFrames` estão usando o strip, o número de frames e a
  velocidade esperados?
- `idle`, caminhada, ataque, habilidade e morte continuam reconhecíveis em
  escala de jogo?
- A figura do runtime ainda comunica a mesma Nyrelia apresentada pelo retrato,
  asset de herói e ícone, sem alterar os fatos canônicos de personagem?

## Não objetivos

- Alterar lore, espécie, máscara, arma, habilidade, atributos, balanceamento,
  colisões, y-sort, posição lógica, placements ou regras de combate.
- Modificar os PNGs oficiais, arquivos `.import`, cenas, áudio ou código antes
  dos gates de aprovação abaixo.
- Gerar arte remotamente, contratar serviço, consumir créditos ou instalar
  dependências. Se regeneração for necessária, ela será uma decisão posterior
  do dono com fornecedor, orçamento e licença explícitos.
- Tratar uma correção de Nyrelia como autorização para alterar qualquer outro
  herói ou prop.

## Plano de voo

### 1. Inventário congelado e baseline reproduzível

1. Registrar SHA-256, dimensão, alfa, divisão em células, contagem/ordem de
   frames e configurações de importação das nove folhas atuais, das cópias
   originais e das candidatas existentes.
2. Criar uma matriz de divergência visual entre hero asset, retrato, ícone e
   cada strip, sem declarar como defeito uma diferença que seja intencional.
3. Montar uma cena QA isolada em resolução de jogo, com linha de chão e modo
   normal lado a lado; capturar cada direção, ação e espelhamento.
4. Classificar cada clip como `pass`, `reparável`, `regerar` ou `bloqueado`,
   sempre com evidência de frame e captura de runtime.

### 2. Piloto que cubra os três riscos principais

1. Escolher `idle`, `move_se` e `attack` como piloto: eles cobrem identidade
   parada, contato com o chão em locomoção e leitura/VFX de combate.
2. Para cada clip marcado `reparável`, criar candidatos somente em
   `.atena/generated/`, preservando canvas 256x384 por célula, RGBA, ordem de
   frames e cópias recuperáveis dos bytes de origem.
3. Corrigir apenas a causa comprovada: alinhamento de base, margem de célula,
   limpeza de quadro, recorte, cadência ou vínculo de runtime. Não usar
   deslocamento global para disfarçar um quadro ruim.
4. Comparar baseline e candidato em modo normal, nas direções fonte e na
   direção espelhada correspondente; sincronizar ataque/ativa com seus SFX.

### 3. Gate humano do piloto

1. Apresentar prancha de antes/depois, tira de frames, hashes e captura em
   jogo dos três clips piloto.
2. O dono escolhe, por clip: `manter oficial atual`, `admitir candidato`,
   `rejeitar`, `refazer manualmente` ou `propor regeneração`.
3. Sem escolha explícita, nenhum candidato sai de `.atena/generated/` e o
   lock oficial permanece inalterado.

### 4. Expansão limitada e admissão

1. Somente após o aceite do piloto, aplicar o mesmo método aos seis strips
   restantes, um por vez, começando por movimentos e terminando em `active` e
   `death`.
2. Reexecutar a matriz de runtime para as cinco direções fonte, três
   espelhamentos e todas as ações.
3. Para cada candidato aceito, preparar uma SPEC de admissão contendo caminho,
   hash, comparação, impacto e recuperação. A troca do PNG oficial exige a
   aprovação explícita dessa SPEC e um novo registro canônico que substitua a
   entrada correspondente no lock; oficialidade anterior não é apagada.

### 5. Verificação e reconciliação

1. Automatizar os contratos de canvas, alfa, divisão, frame, base e margem dos
   strips aprovados; preservar testes de importação e runtime.
2. Rodar a suíte, smoke e a cena QA de Nyrelia em modo normal. Resultado
   técnico nunca substitui a aprovação visual humana.
3. Registrar evidência, decisão, hashes e exceções; reconciliar a SPEC-043 e
   SPEC-044 somente depois que todos os clips tenham decisão explícita.

## Critérios de aceite

1. Cada um dos nove strips possui diagnóstico por frame e captura em runtime;
   nenhuma conclusão depende só de metadados ou de uma imagem estática.
2. O piloto comprova, na escala real, base estável, ausência de corte essencial
   e leitura clara em parada, caminhada e ataque — ou registra uma exceção
   humana por clip.
3. Retrato, hero asset, ícone e runtime têm uma matriz de coerência que torna
   qualquer divergência deliberada rastreável, sem modificar a identidade de
   Nyrelia por inferência.
4. Nenhum byte oficial é substituído sem decisão explícita do dono, registro
   canônico, hash verificado e rota de recuperação.
5. Suíte, smoke e QA visual passam para os clips admitidos; avisos ambientais
   ou de limpeza de recursos continuam separados de aceite artístico.

## Gates de aprovação

1. **Aprovação deste plano:** autoriza uma SPEC de diagnóstico, inventário
   somente leitura e baseline local.
2. **Aprovação da SPEC:** autoriza criar cenas QA, evidências e candidatos
   isolados em `.atena/generated/`; não autoriza editar arquivos oficiais.
3. **Seleção do piloto:** autoriza ou rejeita cada candidato apresentado, mas
   ainda não altera `assets/`.
4. **Admissão por clip:** autoriza a substituição de um byte oficial, a
   atualização do lock e a reconciliação canônica correspondente.

## Recuperação

- Preservar os bytes oficiais atuais e os backups de SPEC-043 intactos.
- Candidatos são descartáveis enquanto permanecerem em `.atena/generated/`.
- Toda admissão registra o hash anterior, o novo hash, a decisão humana e a
  localização da cópia recuperável para reversão controlada.
