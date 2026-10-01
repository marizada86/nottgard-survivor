---
id: "SPEC-109"
title: "Preparo local e integração das animações de guardiao_copia"
status: "subsumida por SPEC-111; admissão integrada e verificada em 2026-09-30"
created: "2026-09-30"
relations:
  - "[[SPEC-108-ciclo-guardiao-copia]]"
  - "[[EVID-104-zumbi-admissao-2026-09-29]]"
  - "[[EVID-126-integracao-animacoes-cultista-adaga-2026-09-30]]"
  - "[[EVID-136-ciclo-guardiao-copia-2026-09-30]]"
  - "[[CANDIDATES-MANIFEST-003]]"
---

# SPEC-109 — Preparo local e integração das animações de `guardiao_copia`

## Intenção

Definir um fluxo local, reproduzível e sem `game-dev` para preparar as cinco
tiras derivadas do ciclo visualmente aprovado de 26 quadros de
`guardiao_copia`. O preparo fica primeiro em `.atena/generated/`; sua aprovação
visual não autoriza, por si só, admissão em `assets/` nem alterações de runtime.

## Descobertas e decisões de método

- A aprovação visual dos 26 quadros está registrada em
  [[EVID-136-ciclo-guardiao-copia-2026-09-30]]. Eles são PNG RGBA em células
  `320×480`; a imagem estática oficial continua intacta.
- O responsável instruiu que `game-dev` não seja usado. Esta SPEC não depende
  dele, não pede sua instalação e não usa comandos de catálogo, pacote ou vendor.
- O projeto registra composição local com PowerShell/.NET em
  [[EVID-104-zumbi-admissao-2026-09-29]] e integração validada diretamente no
  Godot em [[EVID-126-integracao-animacoes-cultista-adaga-2026-09-30]]. O script
  legado do zumbi não deve ser reaproveitado diretamente: ele recorta e
  redimensiona os quadros, transformações desnecessárias e proibidas para estas
  células já normalizadas.
- Para este ciclo, o método proposto é uma composição determinística usando
  PowerShell e o `System.Drawing` disponível no Windows, sem instalar
  dependências. Cada fonte deve ser copiada sem escala, recorte, reposição ou
  alteração de pixels para sua célula de origem na tira horizontal.
- Os registros atuais comprovam a proveniência e a aprovação visual, mas não
  declaram uma licença/termos de uso para admissão no jogo. Não inferir nem
  inventar uma licença; esse gate continua obrigatório antes de copiar assets
  para `assets/`.
- `ui/enemy_view.gd` aceita tiras por estado e fornece `play_action`. Não foi
  encontrada chamada de inimigo para `play_action("special")`; esta SPEC pode
  validar a reprodução explícita, mas não altera IA nem cria gatilho automático.

## Escopo proposto

### Etapa A — tiras candidatas isoladas

- Usar somente os 26 PNGs finais selecionados por
  `CANDIDATES-MANIFEST-003`/EVID-136. Registrar no relatório o caminho e SHA-256
  de cada fonte antes da composição.
- Produzir um compositor local específico e revisável em
  `tools/build_guardiao_copia_candidate_strips.ps1`. Ele deve falhar se faltar
  uma fonte, se as dimensões não forem `320×480`, se a contagem divergir ou se
  houver colisão com um arquivo de saída preexistente.
- Gravar somente as cinco saídas candidatas em
  `.atena/generated/art-candidates/enemies-wave-1/guardiao_copia/strips/`:
  `idle` (4), `move` (6), `attack` (4), `death` (6), `special` (6). Dimensões:
  `1280×480` para `idle`/`attack` e `1920×480` para os demais.
- O compositor não deve aparar transparência, redimensionar, espelhar, colorir,
  redesenhar nem alterar a posição de nenhum pixel. A ordem dos quadros é a do
  manifesto e da aprovação EVID-136.
- Produzir relatório de QA e prancha de inspeção na mesma área de candidatas;
  manter PNGs originais, imagens brutas e registros existentes sem alteração.

### Etapa B — admissão no runtime, ainda sujeita a outro gate

- Só após aprovação visual das tiras, resolução documentada da licença e
  autorização específica do responsável, copiar as cinco tiras para
  `assets/animations/enemies/guardiao_copia/`.
- Registrar `guardiao_copia` em `ui/enemy_view.gd` com célula `320×480` e as
  cinco contagens; espelhar horizontalmente somente `move`, mantendo o PNG
  estático como fallback.
- Acrescentar o ID a `ANIMATED_ENEMY_IDS` e testar assets, dimensões, alfa,
  quantidade e ordem dos quadros, fallback, orientação de movimento e
  reprodução explícita de `special`.
- Executar validação com a instalação local do Godot diretamente, sem
  `game-dev`; registrar separadamente reimportação, testes headless e limites
  de qualquer captura visual automatizada.

## Não objetivos

- Não usar ou instalar `game-dev`, nem instalar dependências ou ferramentas.
- Não regenerar, editar, recortar, redimensionar, espelhar ou substituir os 26
  quadros aprovados; não alterar `assets/enemies/guardiao_copia.png`.
- Não copiar as tiras para `assets/`, modificar runtime ou abrir o jogo durante
  a Etapa A. Aprovação desta SPEC ou dos quadros não substitui a autorização
  explícita para a Etapa B.
- Não aceitar silenciosamente licença desconhecida, nem publicar, fazer push,
  criar commit ou incluir outros inimigos.
- Não alterar stats, cenas, IA, regras de combate ou disparo automático de
  `special`.

## Critérios de aceite propostos

### Etapa A

1. O roster contém exatamente os 26 quadros selecionados pelo manifesto e
   EVID-136; caminhos e hashes SHA-256 de entrada ficam no relatório.
2. As cinco tiras candidatas têm a contagem e as dimensões declaradas, perfil
   RGBA e alfa preservado.
3. Cada célula extraída de volta da tira é pixel a pixel idêntica à respectiva
   fonte decodificada; nenhuma fonte foi recortada, escalada ou reposicionada.
4. Relatório e prancha permitem verificar ordem, transparência, continuidade
   visual e ausência de corte. As tiras aguardam aprovação visual do
   responsável antes de qualquer admissão.

### Etapa B — somente após nova autorização

5. A licença/termos aplicáveis estão identificados e aceitos para o uso
   pretendido; a aprovação cobre o destino literal
   `assets/animations/enemies/guardiao_copia/` e as alterações mínimas de
   runtime/testes.
6. O Godot reimporta as cinco tiras; testes verificam dimensões, alfa, quadros,
   fallback estático, orientação e chamada explícita de `special`.
7. A evidência final discrimina claramente composição candidata, aprovação
   visual e admissão/runtime. Nenhum outro inimigo ou gameplay foi alterado.

## Impactos e limites

Na Etapa A, as únicas escritas são o compositor declarado, as cinco tiras
candidatas, o relatório de QA e a prancha sob os caminhos `.atena` especificados.
Na Etapa B, se autorizada depois, as escritas ficam limitadas às cinco tiras
oficiais, ao registro de `guardiao_copia`, aos testes de animação e à evidência.
Arte estática, outros inimigos, IA, balanceamento, cenas, lore e gameplay ficam
preservados.

## Plano de voo proposto

1. Conferir, sem escrita, que os 26 caminhos selecionados e suas dimensões
   correspondem ao manifesto/EVID-136; registrar hashes. Se roster ou dimensões
   divergirem, parar para revisão.
2. Confirmar o estado da licença/termos sem inferir uma resposta. A ausência
   dessa resposta bloqueia a futura Etapa B, mas não transforma aprovação visual
   em licença.
3. Após aprovação específica da execução da Etapa A, criar o compositor local,
   gerar saídas apenas no novo diretório `.atena/.../strips/` e produzir o
   relatório e a prancha. Não sobrescrever saídas existentes.
4. Verificar pixel a pixel as 26 células, hashes de entrada, ordem, dimensões,
   transparência e alfa; apresentar a prancha para aprovação visual das tiras.
5. Parar e apresentar um plano literal separado para a Etapa B. Só prosseguir
   com licença resolvida e autorização explícita para assets, runtime e testes.
6. Se autorizada, admitir as tiras, atualizar minimamente `EnemyView`, executar
   a suíte Godot e validar o fallback e o `special` explícito; reconciliar
   evidência e registrar exceções sem alegar validação que não ocorreu.

## Decisões pendentes

- Identificar a licença/termos aplicáveis e registrar a decisão para o uso
  pretendido; não há rótulo de licença inferido nesta SPEC.
- Aprovar separadamente a execução da Etapa A quando o compositor e os
  destinos locais forem apresentados.
- Após revisar e aprovar visualmente as tiras, aprovar separadamente (ou não) a
  admissão em runtime, seu destino e suas alterações de código/testes.
