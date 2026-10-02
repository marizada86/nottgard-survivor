# PLAN-012 — Correção visual de Nyrelia e contato dos props

Status: **executado pela SPEC-043; inspeção visual interativa pendente** (2026-09-27).

## Objetivo

Eliminar duas regressões visuais visíveis na captura fornecida pelo dono:

1. as animações de Nyrelia parecem flutuar, oscilar ou recortar efeitos entre
   células; e
2. rochas, pilares e demais props parecem suspensos por uma separação entre a
   base artística e a sombra no piso isométrico.

O trabalho corrige apresentação e validação. Não altera lore, regras de
combate, posições lógicas, colisões, `block_radius`, y-sort nem a geometria do
terreno.

## Diagnóstico e evidência inicial

- A captura do dono de 2026-09-27 mostra rochas e pilares com elipse de sombra
  separada da base estrutural. Portanto, a afirmação de aceite visual nas
  SPEC-041 e SPEC-042 deve ser revalidada; ela não é evidência suficiente para
  esta cena observada.
- `ui/hero_view.gd` ancora a borda inferior da célula inteira de 256×384 no
  ponto lógico de chão. As folhas de Nyrelia têm transparência inferior e
  variação perceptível de pés entre quadros, portanto a base artística não
  coincide necessariamente com essa borda.
- As folhas de movimento de Nyrelia também mostram efeitos luminosos chegando
  às divisões laterais das células; ao recortar a tira, o efeito pode aparecer
  partido entre quadros.
- Os testes atuais verificam dimensões e alguns fluxos de Bromnor/Zynara, mas
  não exercitam o runtime, a linha de base ou a leitura visual de Nyrelia. Os
  testes de props verificam a matemática de âncora, não a sobreposição
  percebida entre base e sombra em uma captura real.

## Fontes e precedência

1. Declaração e captura do dono em 2026-09-27;
2. fatos de identidade de Nyrelia em `data/heroes.json`, no vault canônico e
   em SPEC-021 — máscara, espécie indeterminada, arma e habilidade permanecem
   imutáveis;
3. contrato técnico atual em `ui/hero_view.gd`, `ui/sprite_strip_frames.gd`,
   `ui/prop.gd` e `data/prop_visuals.json`;
4. SPEC-041 e SPEC-042, tratadas como implementação anterior a ser auditada,
   não como confirmação do resultado atual.

## Escopo

### Trilha A — Nyrelia

- Inventariar as nove folhas-fonte de Nyrelia e medir, por quadro, base visível,
  caixa útil e extensão lateral de VFX.
- Definir uma linha de base única para a animação e normalizar os nove strips
  para que pés/base artística coincidam nela, preservando transparência RGBA e
  o canvas de 256×384 por célula.
- Garantir margem horizontal segura: nenhum personagem, arma ou VFX essencial
  atravessa uma divisão de 256 px. Um efeito que dependa de cruzar células será
  extraído para VFX de runtime somente se a normalização do asset não for
  suficiente.
- Validar as cinco direções-fonte e os três espelhamentos do runtime, além de
  `idle`, `attack`, `active` e `death`.

### Trilha B — Props apoiados

- Auditar os perfis de rocha e pilar primeiro, no tamanho realmente usado em
  jogo; em seguida, somente os props que ainda falharem nas cenas de validação.
- Medir a base estrutural percebida de cada variante e ajustar
  `contact_anchor`/política de sombra por caminho de asset, sem alterar a
  posição do `Node2D`.
- Fazer uma sombra dinâmica tocar ou sobrepor discretamente a base; remover a
  elipse quando ela gerar uma segunda sombra ou uma leitura de suspensão.
- Preservar o fallback de perfil ausente apenas como alerta de QA, não como
  aprovação visual.

## Não objetivos

- Não redesenhar Nyrelia, mudar máscara, espécie, arma, habilidade, lore ou
  balanceamento.
- Não gerar novo lote de arte, enviar referências locais a serviço remoto nem
  substituir PNGs por geração automática.
- Não mover props nas cenas, mudar seed/layout, colisores, `block_radius`,
  layers, máscaras, y-sort ou navegação.
- Não aplicar um `visual_ground_offset` global, nem esconder o defeito movendo
  todas as sombras para baixo.
- Não publicar, fazer commit, push, merge ou compartilhar externamente.

## Plano de voo

### 1. Baseline e isolamento

1. Rodar a suíte atual e registrar falhas preexistentes sem corrigi-las fora do
   escopo.
2. Criar cenários QA reproduzíveis: Nyrelia parada/em movimento e props em
   Dagruve, Docas e Durao, em 1280×720.
3. Capturar o baseline com o guia de ancoragem ativado apenas no QA; manter uma
   captura normal equivalente para inspeção estética.
4. Registrar a discrepância de aceite das SPEC-041/042 como evidência de
   regressão, sem reescrever retrospectivamente seus registros.

### 2. Piloto de Nyrelia

1. Extrair e comparar as nove folhas em células individuais, medindo a base e
   a caixa alfa de cada quadro.
2. Normalizar uma cópia candidata de `idle` e uma de `move_se`, preservando
   identidade, escala, paleta e ordem dos quadros; não tocar nos finais ainda.
3. Inspecionar o piloto em jogo nas direções-fonte e em `move_sw` espelhado.
4. Aceitar o piloto somente se o pé não oscilar, efeitos não forem recortados e
   a personagem não parecer flutuar. Caso contrário, parar e decidir entre
   correção manual do strip ou VFX separado.
5. Após aceite do piloto, aplicar a mesma normalização aos sete strips
   restantes, mantendo backup local recuperável dos originais.

### 3. Piloto de props

1. No modo QA, medir rocha e pilar das três variantes contra o ponto lógico,
   sua base estrutural e a sombra efetiva, na escala de cena.
2. Ajustar perfis candidatos por asset: âncora, presença de sombra, deslocamento
   e tamanho; a sombra deve encontrar a base com sobreposição sutil de até dois
   pixels de tela, nunca deixar faixa de piso entre ambas.
3. Comparar imagem com e sem sombra dinâmica. Preferir `none` quando a sombra
   não acrescentar contato claro; nunca manter uma elipse decorativa isolada.
4. Expandir somente para as famílias que falharem: caixote, carga, barril,
   braseiro, velas, livros, rede, ossos, doca e margem.

### 4. Integração limitada

1. Substituir os strips de Nyrelia somente após aprovação visual do piloto e
   verificar importação/dimensões/canal alfa.
2. Integrar perfis de props aprovados em `data/prop_visuals.json` e a lógica
   mínima em `ui/prop.gd`, se indispensável para fazer sombra e base coincidir.
3. Não modificar transformações de cena nem os dados de combate.
4. Manter os guias de QA desligados por padrão e inacessíveis na run normal.

### 5. Verificação e reconciliação

1. Acrescentar teste de runtime para Nyrelia: nove animações, número de frames,
   cinco direções-fonte, três espelhamentos, ações e morte.
2. Acrescentar auditoria de linha de base/limites de célula para as folhas de
   Nyrelia, com tolerância documentada apenas para VFX deliberado.
3. Estender os testes de props para conferir política de sombra e a ausência de
   lacuna base–sombra nos perfis aprovados; complementar com capturas em escala
   real, pois a fórmula isolada não é suficiente.
4. Rodar `tests/run_all.gd` e smoke dos cenários afetados; comparar as capturas
   final/baseline em Dagruve, Docas e Durao.
5. Registrar evidências em `.atena/evidence/`, comparar o resultado aos
   critérios abaixo e reconciliar as specs somente quando todos forem provados.

## Critérios de aceite

1. Nyrelia mantém sua identidade aprovada e suas nove folhas-fonte possuem
   dimensões corretas, alfa real, ordem de frames preservada e linha de base
   visual consistente — sem flutuação perceptível em `idle` ou caminhada.
2. Nenhum elemento essencial de Nyrelia é cortado por uma borda de célula; os
   espelhamentos `move_nw`, `move_w` e `move_sw` mantêm leitura correta.
3. Rochas e pilares não mostram faixa de piso entre base estrutural e sombra;
   a tolerância é de no máximo dois pixels de tela, salvo exceção artística
   registrada por asset.
4. Baús e demais props afetados parecem apoiados no chão nas três cenas de
   validação, sem sombra dupla ou elipse isolada.
5. Posições lógicas, colisões, `block_radius`, y-sort, ondas e resultados de
   batalha permanecem idênticos ao baseline.
6. Testes automatizados, QA e evidências visuais passam; qualquer exceção fica
   explicitamente registrada, sem ser marcada como verificada.

## Impactos previstos

- Possíveis alterações: `assets/animations/heroes/nyrelia/`,
  `ui/hero_view.gd`, `ui/prop.gd`, `data/prop_visuals.json`, cenas/fluxos QA,
  testes de animação e grounding, e evidências ADD.
- Nenhuma nova dependência, permissão, serviço remoto, mudança canônica ou
  alteração de dados de gameplay é prevista.

## Gates de aprovação

1. **Este plano:** a aprovação autoriza somente a criação de uma SPEC limitada
   e do baseline local.
2. **Plano de voo da SPEC:** antes de editar PNGs finais, metadados de props ou
   código de renderização, apresentar a SPEC com o piloto e pedir aprovação de
   execução, conforme `guarded-autopilot`/`per-spec`.
3. **Exceções:** qualquer necessidade de redesenho, geração remota, mudança de
   identidade, cenário, colisão ou regra de jogo pausa o trabalho e exige nova
   decisão do dono.

## Recuperação

- Preservar os strips originais antes de qualquer normalização; candidatos
  ficam em `.atena/generated/` até aceite explícito.
- Cada alteração de perfil visual é reversível por asset e não altera a posição
  lógica do prop.
- O modo QA e quaisquer flags de diagnóstico permanecem exclusivos de teste e
  podem ser desligados sem afetar uma run salva.
