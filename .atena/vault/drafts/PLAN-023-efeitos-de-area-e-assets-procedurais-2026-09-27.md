---
id: "PLAN-023"
type: "plano-de-voo"
title: "Efeitos de área de terreno — clareza de runtime e VFX procedural"
status: "executado — exceção de validação aceita"
created: "2026-09-27"
approved: "2026-09-27"
relations:
  - "[[PLAN-001-nottgard-survivors]]"
  - "[[ART-SPEC-001-vfx-e-ui-procedural]]"
  - "[[SPEC-040-estige-gelatinoso-e-elites-de-juiblex]]"
---

# PLAN-023 — Efeitos de área de terreno e assets procedurais

## Contexto descoberto

O runtime possui áreas persistentes de poça, selo ritual, telégrafo de impacto,
bolha, santuário e Estige gelatinoso; os Pilares ainda alternam entre poças,
corrente, raios e ilusões. Há também zonas de jogador de cera em chamas e
tentáculos.

O visual dessas áreas é hoje desenhado em `ui/overlay.gd` com elipses e cores
planas. A diretriz aprovada `ART-SPEC-001-vfx-e-ui-procedural.md` determina que
poças, corrente, raios, névoa e efeitos de fase sejam procedurais, sem PNG
gerado para cada efeito ou nível.

Foi detectada uma divergência de dados: `data/stages.json` expõe a lista
`ambient` no catálogo, mas `core/battle.gd` resolve a simulação a partir de uma
única regra em `data/stage_rules.json` (ou uma regra por vez na rotação dos
Pilares). Em particular, Goranthis declara ilusões e poças no catálogo, mas a
regra em execução é `sanctuary`; Molor declara poças no catálogo e executa
`bubbles`. Este plano não assume que a lista exibida deva virar comportamento
simultâneo.

## Direção recomendada

Criar uma biblioteca pequena de VFX procedurais reutilizáveis, em camadas sob
os atores, com partículas e shaders simples onde contribuírem para a leitura.
Não criar sprites PNG específicos de área. A identidade vem de forma, ritmo,
cor e resposta ao estado, não de arte raster única.

### Linguagem por efeito

| Efeito | Linguagem visual recomendada | Informação que precisa permanecer inequívoca |
|---|---|---|
| Poça corrosiva/esporos | mancha orgânica irregular, verde-negro contido, borda pulsante lenta e poucas bolhas | área perigosa, crescimento e permanência |
| Selo ritual | aro magenta segmentado, marcas geométricas sem texto e arco de progresso verde-água | local para interromper e progresso da interrupção |
| Telégrafo | preenchimento leve âmbar/vermelho, contorno segmentado com pulso acelerado; impacto em anel curto | dano futuro, raio e instante de impacto distintos |
| Bolha de Molor | esfera azul-esverdeada que infla, anel de pressão e estilhaços curtos na explosão | contagem regressiva, área e empurrão |
| Santuário | halo dourado calmo e pulso de cura; falso santuário revela fissura violeta somente ao ativar | zona benéfica aparente e revelação da fraude sem entregar a ilusão antes |
| Estige gelatinoso | material de chão denso e imóvel, com almas e bolhas presas; raro imbuído recebe aura verde-amarela discreta | água perigosa, ausência de corrente e buff temporário do raro |
| Corrente dos Pilares | linhas de fluxo espectral e deslocamento suave de partículas, sem parecer Estige gelatinoso | direção da força enquanto esta regra estiver ativa |
| Cera/tentáculos do jogador | cera: núcleo âmbar com três línguas de fogo; tentáculos: anel violeta e braços que emergem no limite | autoria do jogador, duração e dano contínuo |

Todos os efeitos devem respeitar o máximo de três efeitos grandes por
quadrante, preservar silhuetas de herói/chefe/interações e funcionar a
1280×720 com 30–60 inimigos.

## Escopo proposto

1. Confirmar uma matriz de verdade para cada fase: efeito exibido no catálogo,
   efeito realmente simulado e efeito que recebe VFX dedicado.
2. Reconciliar a divergência entre `ambient` e `stage_rules` sem alterar o
   comportamento por acidente: a decisão pode ser alinhar a descrição ao
   runtime atual ou ampliar a simulação, mas precisa de escolha explícita.
3. Substituir os preenchimentos genéricos das zonas por componentes
   procedurais parametrizados por `kind`, equipe, perigo, raio, atraso e
   progresso.
4. Criar as respostas breves de impacto (explosão, onda, cura e empurrão) e
   conectar som existente, sem criar dependências novas.
5. Validar legibilidade, desempenho, ordem de camadas e determinismo; registrar
   a evidência ADD.

## Fora de escopo

- Não mudar dano, raio, duração, cadência, IA, loot, chefes ou progressão.
- Não mudar lore do Estige nem criar água funcional em outras fases.
- Não gerar ou promover PNGs de VFX; assets de piso existentes não são parte
  deste lote.
- Não alterar o cânone, publicar, fazer commit, enviar ou implantar nada.

## Plano de voo

1. **Especificar a matriz de efeitos.** Registrar, por fase, fonte de dados,
   comportamento em runtime, VFX, cores, forma e regra de sobreposição.
2. **Gate de intenção.** Submeter a matriz e decidir o tratamento da divergência
   `ambient`/`stage_rules`, especialmente em Molor, Goranthis e Pilares.
3. **Construir a base.** Extrair o desenho de zonas para componentes
   parametrizados e implementar poça, telégrafo e ritual — os três efeitos de
   maior frequência e maior valor de leitura.
4. **Construir identidades.** Implementar bolha, santuário, Estige/imbuído,
   corrente e zonas do jogador reutilizando a mesma base.
5. **Verificar.** Executar testes existentes, adicionar cobertura apenas para a
   matriz decidida, fazer captura reproduzível a 1280×720 e testar estresse com
   30–60 inimigos.
6. **Revisar independentemente.** Conferir que todo dano continua precedido de
   telegráfo, que nenhuma silhueta é coberta e que não há inversão entre
   aparência benéfica/perigosa sem intenção de design.
7. **Reconciliar.** Criar SPEC, evidência de execução e atualização factual dos
   dados/documentos afetados somente após aprovação do plano de voo.

## Critérios de aceite propostos

1. Cada área ativa possui forma, ritmo e cor suficientes para diferenciar sua
   função sem depender somente de texto ou cor.
2. Telégrafos são visíveis antes do dano e têm aparência distinta do impacto.
3. O mesmo componente renderiza zonas de mesmo comportamento sem PNGs por
   fase, e cada identidade regional permanece reconhecível.
4. As áreas ficam abaixo de heróis, inimigos, itens, interações e HUD; impactos
   breves não ocultam essas silhuetas.
5. A matriz final não contém diferenças não intencionais entre catálogo,
   configuração e runtime.
6. Testes, smoke e capturas 1280×720 aprovam; o cenário de estresse respeita o
   orçamento visual aprovado.

## Aprovações necessárias

- **Intenção e matriz:** aprovar qual fonte descreve o comportamento definitivo
  em Molor, Goranthis e Pilares.
- **Plano de voo:** aprovar o escopo acima antes de criar SPEC ou alterar código,
  dados e materiais.
- **Execução:** executar apenas após a aprovação explícita da SPEC delimitada.

## Registro de aprovação

O dono aprovou este plano de voo em 2026-09-27. A aprovação autoriza a
elaboração da SPEC delimitada; não autoriza, por si só, mudanças de código,
dados, cânone, dependências, publicação ou promoção de assets.

O dono também aprovou a exceção de validação registrada em `EVID-084` em
2026-09-27. A pendência de captura gráfica e de resumo da suíte permanece
registrada, sem ser apresentada como teste concluído.
