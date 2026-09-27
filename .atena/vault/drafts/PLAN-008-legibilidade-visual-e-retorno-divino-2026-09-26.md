# PLAN-008 — Legibilidade visual, retorno divino e enquadramento

Status: aprovado e implementado localmente; aguardando execução do Godot para verificação final (2026-09-26).

Atualização: aprovado pelo responsável em 2026-09-26, com a inclusão de Selûne.

## Objetivo

Corrigir o corte do bloco de notas F5 e melhorar a legibilidade da run com
menos poluição de cenário, aparições de objetos com causa visual, números de
dano que reflitam a última escolha divina e um enquadramento que valorize os
personagens e inimigos sem alterar o combate por acidente.

## Descoberta registrada

- O painel F5 é criado em `core/playtest.gd` com tamanho fixo de 760×470 e
  centralizado sem reagir a mudanças de viewport. Em telas com altura útil
  menor, ele pode sair da área visível.
- Há 64 props em Dagruve e 30–42 nas outras fases. Todos os props entram no
  grupo `blockers`; logo, reduzir ou mover um deles pode mudar navegação e
  colisão.
- Os números de dano são `Label`s simples em `ui/run.gd`: dano comum neutro,
  crítico amarelo. Eles não conhecem herói nem divindade.
- A seleção de bênção no altar já passa por `Battle.choose`; a bênção guarda
  `god`, mas o estado não mantém a última origem divina. Hoje bênçãos existem
  apenas no altar; o modelo deve aceitar futuras escolhas divinas de level-up.
- A câmera não define `zoom`; heróis são mostrados a 72 px de altura e
  inimigos normais a 62 px antes da escala de cada inimigo.

## Escopo

1. Tornar o bloco F5 responsivo e sempre fechável em qualquer resolução
   suportada.
2. Aplicar orçamento de densidade aos props estáticos e criar um contrato
   visual reutilizável para props que entram por mecânica.
3. Criar um estado visual de afinidade divina: cor inicial por herói, última
   escolha divina como substituta, números de dano estilizados e uma aura
   puramente informativa que só começa após o primeiro altar.
4. Ensaiar e escolher um zoom de câmera, depois ajustar somente escalas de
   apresentação que ainda estejam desproporcionais.

## Fora de escopo

- Mudar dano, atributos, hitboxes, alcance, IA, frequência de ondas ou o
  balanceamento das bênçãos.
- Criar arte final nova, dependências, shaders ou publicar/alterar repositório
  remoto.
- Reescrever a lore canônica das divindades; a paleta abaixo é uma proposta de
  apresentação até aprovação.
- Converter props estáticos já posicionados em objetos dinâmicos sem uma
  mecânica declarada.

## Proposta de linguagem visual divina

Cada cor terá uma versão clara para o número e uma escura para contorno/sombra;
o contraste será validado sobre cada terreno. A primeira cor vem do patrono
inicial do herói; a aura permanece ausente até a primeira bênção de altar.
Depois, a última escolha divina substitui tanto a cor dos números como a aura.

| Divindade | Cor principal proposta | Contorno/acento | Base da recomendação |
| --- | --- | --- | --- |
| Shar | vermelho abissal `#D13E54` | ameixa quase preta `#260D2B` | O requisito do jogo fixa Kayron em vermelho; a tradição de D&D associa Shar a roxo/preto, preservados no contorno e nas partículas. |
| Sendrinah | dourado solar `#F4C542` | âmbar `#8C5B12` | Divindade própria do projeto; amarelo foi explicitamente requisitado para Maelor. |
| Mask | prata fria `#AAB4C8` | carvão `#202532` | Associação visual recomendada para furtividade, máscara e sombra; confirmar a intenção local. |
| Lliira | laranja vivo `#FF8A2A` | vermelho coral `#C6373D` | Cores e símbolo de Lliira no cânone de Forgotten Realms: laranja, amarelo e vermelho. |
| Ghaunadaur | verde ácido `#8AD14B` | violeta profundo `#44205E` | Cores favorecidas no cânone: verde, roxo e preto; usar o verde para distinguir de Shar. |
| Tou Um | azul-estelar `#65C8FF` | índigo `#273C8F` | Divindade própria; proposta baseada em “Guia da Estrela”. |
| Helion | azul de tinta `#5D8CFF` | pergaminho `#E6D3A1` | Divindade própria; proposta baseada em cadernos e saber. |
| Selûne | azul-luar `#8CCBFF` | prata `#EAF4FF` | Cânone de Forgotten Realms: lua, estrelas, guia e cores azul/prata. |

Referências de pesquisa: Shar é apresentada com roxo/preto e aura violeta;
Lliira, com laranja/amarelo/vermelho; Ghaunadaur, com verde/roxo/preto.
Sendrinah, Tou Um e Helion não foram localizadas como divindades oficiais de
D&D/ Forgotten Realms e, portanto, permanecem decisões de lore local.

## Plano de voo

1. **Especificar e proteger a intenção.** Aprovar esta paleta e declarar, nos
   dados do herói, o patrono inicial de cada jogável (Kayron → Shar; Maelor →
   Sendrinah). Centralizar uma tabela de paleta por divindade, em vez de
   espalhar hexadecimais em scripts. Escolhas futuras de level-up que sejam
   divinas deverão usar o mesmo campo `god`/evento que as bênçãos do altar.

2. **Corrigir F5 responsivamente.** Extrair a regra já usada no guia:
   painel = viewport menos margens seguras, limitado a tamanho máximo.
   Substituir o tamanho fixo por layout recalculado em `size_changed`; colocar
   o conteúdo central em `ScrollContainer`, manter título e ação de fechar
   acessíveis e dar foco ao editor. Validar em 1280×720, 1024×768, 800×600 e
   uma janela baixa/larga.

3. **Reduzir props sem alterar o mapa às cegas.** Fazer uma grade visual e de
   navegação por fase. Meta inicial: 30–36 props de leitura por tela/área
   ativa; Dagruve é a prioridade, reduzindo primeiro repetições de mesma
   categoria e conservando silhuetas que orientam o jogador. Para cada prop
   removido ou deslocado, revisar rota do herói, raio de bloqueio e legibilidade
   dos itens/interações. Props decorativos não devem bloquear movimento.

4. **Contrato para prop que surge.** Criar um componente/efeito local para
   eventos de cenário: (a) marcador/sombra de destino de 0,35 s, (b) queda ou
   emergência de 0,35–0,50 s com escala e aceleração, (c) impacto com poeira,
   breve tremor e som, (d) assentamento de 0,15 s. A colisão só é ativada no
   impacto; se a área estiver ocupada, cancelar ou escolher posição livre.
   Aplicar somente quando uma mecânica pedir um objeto novo — por exemplo,
   rocha, livro gigante ou pilar — e manter os props de ambientação existentes
   estáticos.

5. **Retorno divino de dano e aura.** Guardar em `Battle` a afinidade visual
   atual, inicializada pelo patrono do herói. Ao escolher uma oferta divina,
   atualizar a afinidade e emitir um evento de mudança; ofertas comuns não a
   alteram. Em `Run`, substituir o rótulo simples por um número com entrada
   elástica curta, subida, leve dispersão horizontal, contorno escuro e pulso
   extra para crítico. A cor principal será a da afinidade atual; cura e dano
   sofrido conservam suas cores semânticas próprias. Criar uma única aura
   `Node2D` embaixo do herói: invisível antes de altar, transição de cor ao
   escolher bênção e substituição — nunca acumulação — na próxima escolha.
   A aura não terá dano, colisão, buffs nem leitura de alcance.

6. **Enquadrar antes de redimensionar arte.** Criar uma sequência de capturas
   QA da mesma situação com zoom 1,15 e 1,20 (1,00 como controle) e escolher a
   menor ampliação que dê presença sem esconder telegráficos, inimigos de
   flanco ou interações. A recomendação inicial é 1,15. Só após essa decisão,
   comparar a razão herói:inimigo (hoje 72:62 para unidade base) e ajustar
   constantes de exibição, por classe de inimigo, em incrementos de no máximo
   10%. Não ampliar arquivos raster nem alterar as escalas lógicas do combate.
   Acrescentar limites de câmera derivados do chão caso o zoom revele bordas
   vazias.

7. **Verificar e reconciliar.** Executar testes automatizados existentes,
   adicionar testes para a resolução do F5, seleção/substituição da afinidade
   e ausência de aura pré-altar; fazer passagem QA manual de todas as fases,
   das escolhas de altar e dos tamanhos de janela definidos. Registrar
   capturas comparativas, contagem final de props e decisão de zoom em
   `.atena/evidence/`; atualizar a spec e fatos operacionais apenas depois de
   aprovação e execução.

## Critérios de aceite

1. F5 permanece completamente dentro da área visível e oferece fechamento por
   F5, Esc e botão em todas as resoluções de teste.
2. Cada fase respeita o orçamento aprovado, preserva rotas funcionais e não
   tem prop decorativo inesperadamente bloqueando o jogador.
3. Nenhum objeto introduzido por mecânica aparece instantaneamente; ele mostra
   telegráfico, animação de entrada, impacto e ativação de colisão segura.
4. Antes do primeiro altar, não há aura; após uma escolha divina, há exatamente
   uma aura e ela e os números de dano usam a cor da última divindade escolhida.
5. Kayron inicia em Shar/vermelho abissal e Maelor em Sendrinah/dourado,
   conforme a decisão solicitada; críticos continuam reconhecíveis sem perder
   a cor divina.
6. O zoom aprovado melhora a leitura de escala, sem recortar HUD, telegráficos,
   interações ou limites de fase, e nenhuma escala lógica de combate muda.
7. Testes planejados passam; evidências e links da spec ficam reconciliados.

## Impactos e gates de aprovação

- A associação de patrono e a paleta são intenção/lore operacional e exigem
  aprovação explícita antes de entrarem no vault canônico ou nos dados finais.
- A remoção/reposicionamento de blockers pode mudar o desenho jogável: aprovar
  a grade de cada fase antes da edição das cenas.
- O plano não requer dependências, permissões, geração de arte, publicação nem
  alteração remota.
- Após aprovação deste plano de voo, a execução local pode seguir em
  `guarded-autopilot`; qualquer descoberta que altere colisão, lore ou escopo
  interrompe a execução para nova decisão.
