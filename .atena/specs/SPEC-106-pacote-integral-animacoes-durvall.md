---
id: "SPEC-106"
title: "Pacote integral de animações e efeitos de Durvall"
status: "aprovada pelo dono em 2026-09-30; candidatos de movimento, melee, active e bolt gerados; revisão por sequência pendente"
created: "2026-09-30"
relations:
  - "[[PLAN-049-animacoes-integrais-dos-herois-2026-09-30]]"
  - "[[PLAN-001-nottgard-survivors]]"
  - "[[SPEC-105-inventario-animacoes-e-efeitos-herois]]"
  - "[[SPEC-021-prompts-de-animacao-dos-herois]]"
  - "[[SPEC-044-aprovacao-rastreavel-de-assets-oficiais]]"
  - "[[EVID-133-inventario-visual-herois-2026-09-30]]"
  - "[[HERO-ANIMATION-INVENTORY-001]]"
---

# SPEC-106 — Pacote integral de animações e efeitos de Durvall

## Intenção

Produzir e integrar, em um pacote revisável e restrito a Durvall, as animações
corporais e os efeitos visuais que dão suporte às ações já existentes do herói.
O primeiro objetivo visual é corrigir a silhueta lateral achatada e o salto de
leitura ao passar de movimento para ataque, sem fator universal de escala e
sem alterar combate.

Esta SPEC escolhe poses de ataque compartilhadas por família (`melee`, `bolt`,
`nova`, `zone`) em vez de 30 animações individuais por perfil de arma. O
manifesto de inventário identifica quais IDs usam cada família; exceções de
efeito serão nomeadas e revisadas, sem multiplicar por padrão as poses do
corpo. A arma inicial visual de Durvall permanece a Espada Sombria, e sua
habilidade permanece Ruptura Sombria (`cleave`).

## Escopo

- Cobrir somente Durvall, incluindo os estados existentes `idle`, movimento,
  ataque, habilidade ativa, dano e morte.
- Disponibilizar oito fontes visuais independentes de movimento:
  `move_n`, `move_ne`, `move_e`, `move_se`, `move_s`, `move_sw`, `move_w` e
  `move_nw`.
- Criar ações direcionais por família para as 30 armas catalogadas em
  EVID-133: `attack_melee`, `attack_bolt`, `cast_nova` e `cast_zone`. Cada
  ação orientada terá variantes nas oito direções visuais da tela; os efeitos
  radiais permanecem centrados no herói e a pose usa o último facing disponível.
- Criar oito variantes direcionais de `active` para Ruptura Sombria, além de
  uma sequência curta de `hurt` para o evento de dano já existente. `hurt`
  mantém o facing atual, pois o evento de dano não contém vetor de origem.
- Revisar `idle` e `death` existentes e reutilizá-los quando passarem pelos
  critérios; regenerá-los só se houver falha visual objetiva nesta SPEC.
- Fazer efeitos próprios de Durvall para o arco/trilha da Espada Sombria e
  para Ruptura Sombria. Reutilizar, sem redesenho global, os efeitos atuais de
  projétil, nova, zona persistente, impacto, estados tipados e efeitos divinos
  quando a revisão confirmar leitura compatível.
- Integrar o roteamento e facing apenas na camada visual. Se for necessário
  acrescentar campos de apresentação aos eventos de combate, esses campos não
  podem modificar cálculo, alvo, dano, tempo, alcance, colisão ou estado de
  jogo.

## Contrato inicial de sequências

Cada quadro de personagem usa célula transparente `256×384`, corpo inteiro,
câmera três-quartos isométrica, iluminação superior esquerda e linha de base
consistente. As direções nomeiam o lado visual na tela, não os eixos isométricos.
Tiras horizontais seguem os tamanhos abaixo; candidatos permanecem separados
dos caminhos oficiais até passarem pelo gate de arte.

Com essas células, sequências de quatro quadros medem `1024×384` e sequências
de seis quadros medem `1536×384`. Os nomes finais planejados são
`move_<direcao>.png`, `attack_<familia>_<direcao>.png`,
`cast_<familia>_<direcao>.png`, `active_<direcao>.png` e `hurt.png` sob
`assets/animations/heroes/durvall/`; os VFX de herói ficam sob
`assets/animations/heroes/durvall/vfx/`.

| Estado/família | Variantes | Quadros por variante | Cadência inicial | Loop |
|---|---:|---:|---:|---|
| `idle` | 1 existente | 4 | 8 fps | sim |
| `move` | 8 direções | 6 | 10 fps | sim |
| `attack_melee` | 8 direções | 4 | 12 fps | não |
| `attack_bolt` | 8 direções | 4 | 12 fps | não |
| `cast_nova` | 8 posturas/facings visuais | 4 | 12 fps | não |
| `cast_zone` | 8 direções visuais | 4 | 12 fps | não |
| `active` (Ruptura Sombria) | 8 direções | 6 | 12 fps | não |
| `hurt` | 1, facing atual | 4 | 10 fps | não |
| `death` | 1 existente | 6 | 9 fps | não |

`256×384` e as cadências atuais são o contrato inicial, sujeitos a uma prova
de leitura em escala de jogo. VFX independentes poderão usar dimensões por
quadro próprias, declaradas no manifesto candidato; não podem ser recortados
para caber nessa célula nem dimensionados automaticamente pela caixa alfa.

## Matriz de ação e efeitos

| Família/runtime | Ação visual de Durvall | Efeito de ataque | Limite desta SPEC |
|---|---|---|---|
| `melee` — 12 perfis | `attack_melee` e facing pelo vetor do evento | Trilha/arco da Espada Sombria; impacto reutiliza faísca atual | Uma pose genérica da família; sem 12 poses por arma |
| `bolt` — 8 perfis | `attack_bolt` e facing pelo vetor do evento | Reutiliza projétil direcional atual | Não redesenhar projéteis ou status por ID |
| `nova` — 7 perfis | `cast_nova`; radial, facing atual | Reutiliza anel procedural atual | Sem alterações no raio, cura, dano ou cadência |
| `zone` — 3 perfis | `cast_zone`; orienta para posição-alvo quando houver alcance | Reutiliza área persistente e acentos atuais de cera/tentáculo | Sem alterar duração, ticks, posição ou regras do efeito |
| `active` — `cleave` | `active` em oito direções | VFX próprio de Ruptura Sombria sincronizado com o quadro de impacto | Apenas identidade visual; lógica da habilidade não muda |
| `hurt` / dano recebido | `hurt` com facing atual | Reutiliza flash, tremor e feedback de impacto | Não altera invulnerabilidade, interrupção ou reação de combate |

Famílias e contagens vêm de `data/weapons.json`; IDs e habilidade inicial vêm
de `data/heroes.json` e `data/abilities.json`. EVID-133 lista os 30 perfis.
Quando um VFX compartilhado não representar corretamente a identidade ou a
arma de Durvall, registrar a exceção antes de gerar um efeito separado.

## Saídas e preservação

- Candidatos, folhas de comparação, prompts e manifesto desta SPEC ficam sob
  `.atena/generated/durvall-animation-package/v01/`.
- Os caminhos oficiais pretendidos permanecem em
  `assets/animations/heroes/durvall/`; nenhum arquivo oficial será sobrescrito
  durante geração, revisão ou normalização.
- Alterações visuais de runtime ficam limitadas a `ui/hero_view.gd` e
  `ui/run.gd`. `core/battle.gd` só poderá receber metadados exclusivamente
  visuais se a implementação provar que os eventos existentes não fornecem o
  necessário; nesse caso, manter intacta toda resolução mecânica e incluir
  teste explícito de equivalência antes/depois. Se for preciso outro arquivo
  de gameplay ou uma mudança de mecânica, interromper e criar nova SPEC.
- Somente candidatos aprovados por sequência poderão ser admitidos nos
  caminhos oficiais, seguindo SPEC-044 e com registro de decisão. Aprovação
  desta SPEC não aprova cada imagem candidata automaticamente.
- Não enviar PNG, retrato ou outra referência local a um gerador remoto sem
  autorização explícita para essa transferência. Se um método local aprovado
  não estiver disponível, pausar antes da geração e pedir decisão.

## Não objetivos

- Produzir ou editar animações dos outros nove heróis, inimigos, NPCs, retratos,
  skins, interface, cenários ou cutscenes.
- Criar habilidades, armas, eventos de jogo ou regras de combate novas.
- Alterar dano, alcance, alvo automático, cooldown, duração, ticks, projéteis,
  hitboxes, movimento, velocidade, colisões, efeitos tipados ou balanceamento.
- Fazer uma folha corporal exclusiva para cada um dos 30 perfis de arma.
- Mudar o contrato canônico aprovado em PLAN-001 §26, identidade/lore,
  dependências, publicar, enviar, mesclar ou admitir candidatos sem o gate
  aplicável.

## Critérios de aceite

1. Matriz candidata enumera todos os estados e oito direções definidos acima,
   as 30 armas por família, a arma/habilidade próprias de Durvall e o destino
   previsto de cada sequência/efeito.
2. Oito folhas de movimento são independentes e o runtime usa a folha
   correspondente; nenhuma direção-alvo de Durvall depende de espelhamento.
3. Toda tira de personagem respeita grade, quantidade de quadros, alfa real,
   células não vazias e importação Godot. VFX declaram dimensões, anchor,
   timing e origem antes da integração.
4. Identidade, espada, silhueta e poses preservam ART-PROMPTS-002/011/014/015;
   candidatos não redesenham espécie, rosto, armadura, símbolo ou arma.
5. Em inspeção visual, altura mediana de cada direção permanece inicialmente
   dentro de ±8% do `idle` de Durvall, e base/pés variam no máximo 2 px-fonte.
   São limites de triagem; revisão quadro a quadro prevalece, e exceção requer
   decisão do dono — nunca compensação automática por escala.
6. `attack_melee`, `attack_bolt`, `cast_zone` e `active` acompanham o vetor ou
   alvo da ação; `cast_nova` e `hurt` preservam o facing disponível. Não há
   espelhamento que inverta espada, gesto ou efeito.
7. Trilha e Ruptura Sombria sincronizam com ação/impacto, ficam legíveis em
   tamanho real e não encobrem personagem ou alvo; os VFX compartilhados
   preservam sua aparência e parâmetros para todos os outros heróis.
8. QA compara todos os quadros em tamanho de jogo e ampliado e cobre
   `idle→move`, `move_e/move_w→attack→idle`, as oito direções de active,
   `hurt→estado anterior` e `death`. Casos `nova`/`zone` usam eventos de
   demonstração determinísticos sem alterar suas regras.
9. Testes de assets, suíte do projeto e smoke passam; registro lista capturas,
   candidates aceitos/rejeitados, paths e alterações limitadas ao escopo.
10. Nenhum PNG oficial, retrato, dado ou manifest de produção muda antes da
    aprovação rastreável dos candidatos; antes/depois mecânico é equivalente.

## Plano de voo

1. Registrar baseline e todos os caminhos existentes de Durvall; ler os quatro
   prompts canônicos de arte e conferir a matriz EVID-133.
2. Elaborar o manifesto de candidatos e prompts por estado, facing e família,
   distinguindo reuso de regeneração e anotando dependências de VFX.
3. Confirmar método de produção, transparência e referência. Pausar se houver
   necessidade de transmitir referências locais sem aprovação explícita.
4. Gerar primeiro um lote pequeno de prova para `move_e`, `move_w`,
   `attack_melee` lateral e a trilha da espada, em diretório isolado. Inspecionar
   proporção, base e leitura em escala de jogo antes de ampliar o restante.
5. Produzir os candidatos restantes após a prova visual, validar estrutura,
   alpha, quadros, recortes, medidas e manifesto; corrigir candidatos no
   diretório isolado.
6. Apresentar prancha completa ao dono e registrar aprovação/rejeição por
   sequência e VFX. Manter assets oficiais intactos até essa decisão.
7. Admitir somente candidatos aprovados, atualizar o roteamento visual,
   preservar mecânica e executar testes de asset, suíte e smoke.
8. Reconciliar SPEC-044, manifesto/catálogo aplicável, capturas, métricas e
   estado final do worktree. Não fazer commit, push, publicação ou merge.

## Riscos e controles

| Risco | Controle |
|---|---|
| Uma pose genérica de família mostrar a espada em um ataque incompatível | Revisar o gesto de cada família; pausar variantes que exijam arma/equipamento não representado pelo sprite atual. |
| O vetor de mira não chegar à camada visual | Usar metadados já disponíveis; qualquer acréscimo é visual e coberto por teste de equivalência mecânica. |
| VFX anexado parecer outra unidade de escala | Medir corpo/arma/VFX separadamente quando possível e inspecionar a composição, sem escala automática. |
| Geração não preservar a identidade sem referência transferida | Não enviar referências sem permissão; se texto/local não bastar, pausar e pedir aprovação específica. |
| VFX compartilhado precisar mudar globalmente | Não alterar sua implementação para todo o elenco nesta SPEC; propor extensão isolada ou outra SPEC. |
| Referências/artes locais já alteradas por outro trabalho | Registrar baseline, usar paths de candidato novos e nunca sobrescrever trabalho existente. |

## Gate de execução

O dono aprovou esta SPEC em 2026-09-30. A geração de candidatos permanece
pausada, agora pelo gate de adequação do fluxo 2D. A busca inicial não encontrou
o executável. O README do repositório oficial documentava npm global, mas a
tentativa do dono retornou E404 no registro npm. Após aprovação explícita, o
código oficial v1.0.2 foi preparado em `C:\Users\gui-m\AppData\Local\Temp\gds-cli-check-20260930`:
`npm ci --ignore-scripts` instalou 158 pacotes, `npm run build` passou,
`node dist/cli.js --version` retornou `1.0.2`, `capabilities` concluiu com
`ok: true` e `doctor` com `healthy: true`. Node.js 24.21.0 atende ao requisito.

Na avaliação inicial das capacidades, não foi encontrada produção de sprites
2D, quadros de animação ou efeitos de ataque. `animate_asset` trata de retarget
de animação em modelo 3D rigado; as outras operações listadas cobrem malhas/GLB,
referências 3D, texturas e áudio. O CLI está compilado e verificável, mas não é
um fluxo adequado para entregar a SPEC-106. Blender e credenciais de provedores
estavam indisponíveis naquele fluxo local; nenhum provedor foi chamado durante
essa verificação. Até a atualização abaixo, nenhuma referência local havia
sido transmitida, e nenhum asset ou arquivo do jogo havia sido alterado. A SPEC
aprovada não autoriza automaticamente geração remota ou admissão de candidatos
em `assets/`.

Atualização de execução em 2026-09-30: o dono autorizou explicitamente o envio
das cinco referências listadas no manifesto de revisão v01 para gerar o lote
de prova remoto. Foram produzidas pranchas candidatas para `move_e`, `move_w`,
`attack_melee_e` e a trilha da Espada Sombria em
`.atena/generated/durvall-animation-package/v01/candidates/`. As pranchas
medem 1536×1024 e têm alfa nos quatro cantos, mas ainda não atendem ao formato
de tira/célula da SPEC nem foram aprovadas para integração. Nenhum arquivo
oficial ou runtime foi alterado. A execução aguarda revisão visual desses
candidatos antes de normalização ou ampliação do lote.

Após a aprovação conceitual desse primeiro lote, foram geradas as seis
direções restantes de movimento e os sete facings restantes de `attack_melee`.
As folhas de movimento medem 1536×1024; as novas folhas melee variam de
1222×1287 a 1536×1024, com disposição 2×2 apenas visual. Amostras de pixels
confirmam alfa zero em vãos/fundo e alfa alto nos personagens; a prévia pode
mostrar RGB oculto sob alfa zero. Esses candidatos aguardam revisão por
sequência. As referências enviadas continuam limitadas às cinco autorizadas.
Nenhum recorte, integração, alteração de runtime ou mudança mecânica foi feito.

Atualização de execução em 2026-09-30: foram geradas oito pranchas direcionais
de `active` (Ruptura Sombria) e oito de `attack_bolt`, também apenas como
candidatos em `.atena/generated/durvall-animation-package/v01/candidates/`.
As dimensões variam entre 1222×1287 e 1536×1024 para `active`, e entre
1223×1286 e 1536×1024 para `attack_bolt`. Amostras de alfa nos quatro cantos
confirmam transparência externa; uma grade de 25 amostras encontrou pixels do
personagem em todas as pranchas. Isso não substitui inspeção integral, revisão
quadro a quadro, recorte ou teste de escala. Os prompts exatos desta etapa
estão preservados em `generation-prompts-v01.md`. As novas variantes aguardam
aprovação por sequência; nada foi normalizado, admitido em `assets/` ou ligado
ao runtime. As referências continuam limitadas às cinco autorizadas.
