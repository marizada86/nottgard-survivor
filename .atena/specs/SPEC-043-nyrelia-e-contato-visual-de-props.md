# SPEC-043 — Nyrelia e contato visual de props

Status: **implementada e verificada por testes; inspeção visual interativa pendente** (2026-09-27).

## Intenção

Eliminar a flutuação, o recorte entre células e a instabilidade de base das animações de Nyrelia, e garantir que props apoiados aparentem tocar o piso isométrico. A mudança é exclusivamente visual e preserva fatos canônicos, gameplay e transformações lógicas.

## Fontes e precedência

1. Captura e relato do dono em 2026-09-27;
2. PLAN-012 aprovado pelo dono em 2026-09-27;
3. `data/heroes.json`, vault canônico e SPEC-021 para a identidade imutável de Nyrelia;
4. `ui/hero_view.gd`, `ui/sprite_strip_frames.gd`, `ui/prop.gd`, `data/prop_visuals.json`, SPEC-041 e SPEC-042 para o comportamento atual.

## Escopo

- Produzir baseline e cenários QA locais de Nyrelia e de props em Dagruve, Docas e Durao.
- Normalizar somente as nove folhas-fonte de Nyrelia para célula 256×384, linha de base comum e margens seguras de VFX.
- Ajustar por asset os metadados de âncora e sombra dos props que comprovadamente falharem na captura, começando por rochas e pilares.
- Acrescentar testes de runtime/limites de Nyrelia e verificações de contato visual de props.
- Registrar evidência de baseline, piloto e resultado final em `.atena/evidence/`.

## Não objetivos

- Mudar máscara, espécie, arma, habilidade, lore, balanceamento ou controles de Nyrelia.
- Gerar ou redesenhar assets remotamente, nem transmitir referências locais.
- Mover nós de cenas, posições, colisores, `block_radius`, y-sort, seed, ondas, terreno ou navegação.
- Fazer offset global de props, esconder sombras por conveniência ou alterar assets que não falharem na validação.
- Publicar, fazer commit, push, merge ou instalar dependências.

## Contratos técnicos

1. Cada folha de Nyrelia contém quatro (`idle`, `attack`) ou seis (demais) células horizontais de 256×384 com alfa real. A base artística de cada quadro coincide com uma mesma linha de base, dentro de dois pixels de tela após a escala do runtime.
2. Personagem, arma e VFX essenciais permanecem dentro da própria célula. VFX que exija ultrapassar a célula será separado em nó visual próprio, apenas se a normalização dos strips não resolver o defeito.
3. Os cinco movimentos-fonte são `n`, `ne`, `e`, `se` e `s`; `nw`, `w` e `sw` usam o espelhamento existente. A ordem de frames e as ações permanecem inalteradas.
4. A origem lógica de cada `Prop` continua sendo seu ponto de gameplay no solo. `contact_anchor` mapeia o pé estrutural percebido, não o último pixel de alfa nem brilho, detrito ou sombra embutida.
5. Uma sombra dinâmica deve encontrar ou sobrepor a base em até dois pixels de tela. `embedded` não recebe segunda elipse; `none` não cria sombra artificial.
6. O QA pode desenhar guias de âncora, mas eles não alteram colisão, ordenação ou a imagem de uma run normal.

## Plano de voo

1. Executar e registrar a suíte/smoke como baseline, preservando toda falha preexistente e trabalho não relacionado.
2. Capturar Nyrelia e os props-alvo em QA, com e sem guias; inventariar as discrepâncias por arquivo e variante.
3. Criar candidatos recuperáveis para `idle` e `move_se` de Nyrelia, medir base e limites por quadro, e validar também o espelhamento de `move_sw`.
4. Criar perfis candidatos para as três rochas e os três pilares, comparando sombra `dynamic`/`none` em escala de jogo; expandir apenas a props que ainda falharem.
5. Apresentar ao dono o piloto visual e os arquivos afetados. Somente após sua aprovação, integrar strips, perfis e qualquer ajuste mínimo de renderer.
6. Adicionar testes, recapturar Dagruve, Docas e Durao, rodar suíte/smoke e reconciliar especificação, evidência e fatos operacionais.

## Critérios de aceite

1. Nyrelia não aparenta flutuar ou oscilar em `idle`, cinco direções-fonte e três direções espelhadas; nenhuma parte essencial é cortada entre células.
2. Identidade, paleta, escala, ordem de animação e alfa dos assets de Nyrelia são preservados.
3. Rochas, pilares e todo prop corrigido não mostram faixa de piso entre base estrutural e sombra, nem sombra dupla ou elipse isolada.
4. O QA confirma a coincidência entre contato lógico, âncora artística e sombra, enquanto a run normal permanece sem guias.
5. Posições lógicas, colisões, `block_radius`, y-sort, resultados de batalha e layouts permanecem inalterados.
6. Testes, smoke e capturas fornecem evidência proporcional; qualquer exceção permanece explícita e impede a marcação como verificada.

## Impactos

- Possíveis arquivos: `assets/animations/heroes/nyrelia/`, `ui/hero_view.gd`, `ui/prop.gd`, `data/prop_visuals.json`, fluxos QA, testes de animação/props e `.atena/evidence/`.
- Não há novas dependências, permissões, serviços remotos, alteração canônica ou migração de dados prevista.

## Evidência planejada

- Captura do dono como referência de falha.
- Resultados de baseline da suíte e smoke.
- Relatório por quadro dos pilotos de Nyrelia.
- Capturas normais e de QA em Dagruve, Docas e Durao.
- Resultados finais de testes e reconciliação.
- `EVID-052-spec-043-baseline-2026-09-27.md` para a suíte e smoke iniciais.

## Gate de execução

O dono aprovou a execução da SPEC-043 em 2026-09-27. A autorização cobriu os
PNGs de Nyrelia, `ui/prop.gd`, `ui/hero_view.gd` e testes locais previstos.
Uma necessidade de geração remota, redesign, mudança de lore, colisão ou regras
de jogo continuaria exigindo nova decisão.

## Reconciliação da execução

- As nove folhas-fonte de Nyrelia foram alinhadas por célula para a linha de
  base visível `y = 368`; `HeroView` usa essa linha somente para Nyrelia e
  mantém a âncora legada dos demais heróis.
- O renderer de props passou a limitar a borda inferior da sombra dinâmica ao
  contato visual, sem mudar `position`, `block_radius`, colisão ou y-sort.
- A suíte completa terminou com zero falhas e o smoke percorreu as nove fases.
- `EVID-053-spec-043-execucao-2026-09-27.md` registra os candidatos, backup,
  verificações e a exceção de captura gráfica.
- O aceite perceptivo em viewport 1280×720 continua pendente; esta SPEC não
  deve ser promovida a “verificada visualmente” sem essa inspeção.
