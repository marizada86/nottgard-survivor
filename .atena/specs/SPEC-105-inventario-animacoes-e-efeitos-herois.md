---
id: "SPEC-105"
title: "Inventário das animações e efeitos visuais dos heróis"
status: "concluída — inventário estático reconciliado em 2026-09-30"
created: "2026-09-30"
relations:
  - "[[PLAN-049-animacoes-integrais-dos-herois-2026-09-30]]"
  - "[[PLAN-001-nottgard-survivors]]"
  - "[[SPEC-021-prompts-de-animacao-dos-herois]]"
  - "[[EVID-129-auditoria-piloto-movimento-herois-2026-09-30]]"
  - "[[EVID-132-piloto-runtime-escala-direcional-durvall-2026-09-30]]"
  - "[[EVID-133-inventario-visual-herois-2026-09-30]]"
  - "[[HERO-ANIMATION-INVENTORY-001]]"
---

# SPEC-105 — Inventário das animações e efeitos visuais dos heróis

## Intenção

Estabelecer uma linha de base verificável para o programa aprovado em PLAN-049:
mapear, sem modificar o jogo ou os PNGs oficiais, as animações, facings,
armas, habilidades e efeitos visuais ligados aos dez heróis jogáveis atuais.
Identificar cobertura, lacunas e dependências para redigir a SPEC completa do
pacote-piloto de Durvall.

## Escopo

- Auditar Durvall, Brook, Maelor, Sylas, Kayron, Korrak, Leoric, Nyrelia,
  Zynara e Bromnor.
- Conferir no código e nos dados os estados visuais atualmente executados,
  seus gatilhos, mira/facing, armas equipáveis e habilidades existentes.
- Catalogar os assets instalados e candidatos já existentes, distinguindo
  claramente oficial, legado, candidato, ausente e carregado pelo runtime.
- Comparar a cobertura existente com o contrato aprovado de oito fontes
  independentes de movimento e com o direcionamento de ataques/habilidades de
  PLAN-001, seção 26.
- Mapear efeitos por herói e ação: preparação/ativação, trilha/emissão,
  projétil, impacto e área persistente, incluindo se são exclusivos ou
  compartilháveis.
- Medir por quadro a largura/altura visíveis, base e recorte nas células das
  animações disponíveis. Separar corpo, arma e VFX quando tecnicamente possível;
  registrar quando a caixa alfa só permite uma estimativa agregada.
- Produzir uma matriz de cobertura e evidência local `.atena/` com contagens,
  paths de origem, lacunas, conflitos e recomendação de ordem/volume do pacote
  completo de Durvall.

## Não objetivos

- Gerar, editar, normalizar, recortar, converter ou substituir qualquer imagem,
  prompt, manifesto de produção ou asset oficial.
- Alterar `ui/hero_view.gd`, cenas, dados de personagens/armas/habilidades,
  estados de gameplay, efeitos runtime ou comportamento do combate.
- Transferir referências para serviço remoto, chamar ImageGen, acrescentar
  dependências, publicar, enviar ou mesclar mudanças.
- Decidir novos fatos de identidade/lore ou inventar ataques/efeitos que não
  estejam descritos nos dados e registros existentes.
- Tratar arquivos espelhados existentes como equivalentes a oito fontes
  independentes ou a simples presença de arquivo como prova de uso no runtime.

## Critérios de aceite

1. A matriz contém os dez heróis e cobre todos os estados encontrados no runtime,
   as oito direções de movimento do contrato vigente, facing de ações e efeitos
   ligados a cada arma/habilidade atual.
2. Cada item traz origem verificável, sequência/direção, quantidade e dimensões
   de quadros quando disponíveis, status do asset e consumidor runtime conhecido.
3. Lacunas entre o contrato atual, os dados da ação e os arquivos são explícitas;
   não se infere estado ou comportamento de jogo a partir apenas do nome de
   arquivo.
4. O relatório distingue VFX exclusivo e compartilhável, sincronização observada
   e detalhes ainda incertos que precisam de decisão do dono.
5. As métricas de silhueta incluem suas limitações; não é proposto fator de
   escala universal e não se usa somente a caixa alfa para decidir proporção.
6. A conclusão recomenda uma composição delimitada do pacote-piloto completo de
   Durvall, com estimativa de variantes/efeitos, critérios visuais e riscos para
   uma SPEC posterior.
7. Nenhum PNG oficial, código de jogo, dado ou comportamento runtime muda; os
   testes de integridade de trabalho confirmam esse limite.

## Impactos previstos

Somente relatório de inventário e evidência local em `.atena/generated/` e
`.atena/evidence/`. Os arquivos consultados em `assets/`, `data/`, `ui/` e nos
manifests permanecem somente leitura. Este voo não altera o status de nenhum
asset para aprovado.

## Plano de voo

1. Registrar o estado inicial do worktree e confirmar os dez IDs no manifesto e
   em `data/heroes.json`.
2. Ler os consumidores runtime, os dados de armas/habilidades e os registros de
   prompts/produção; construir uma tabela de estados, gatilhos, facing e dono de
   efeito por herói.
3. Enumerar os arquivos oficiais e candidatos de animação e VFX, seus quadros,
   dimensões e importabilidade, marcando quais o runtime realmente carrega.
4. Rodar a auditoria local de dimensões/bounds sobre as fontes disponíveis,
   cobrindo as oito direções e os estados de ação existentes. Separar corpo,
   arma e efeitos só onde a fonte possibilitar; anotar as ambiguidades.
5. Comparar cobertura contra PLAN-001, seção 26; registrar exceções históricas
   sem sobrescrever ou atualizar manifests de produção nesta SPEC.
6. Gerar a matriz e a evidência em caminhos `.atena/`, validar as referências e
   conferir que nenhum caminho oficial foi escrito.
7. Entregar a recomendação do pacote completo de Durvall e propor sua SPEC
   separada; encerrar este voo sem chamar geração de imagem ou alterar assets.

## Riscos e controles

| Risco | Controle |
|---|---|
| Manifests históricos discordam da regra direcional atual | Usar PLAN-001 §26 como contrato; registrar a divergência sem reescrever o manifest. |
| A caixa alfa mistura personagem, arma e VFX | Reportar medidas agregadas e não converter medidas automaticamente em escalas. |
| Um arquivo existente não corresponde ao efeito usado pela ação | Seguir o consumidor runtime e os dados de ação; nome de arquivo isolado não é evidência de uso. |
| Inventário sugere uma mecânica ausente | Registrar como lacuna e deixar a decisão para uma SPEC aprovada; não implementar. |
| Trabalho local em andamento coincide com um arquivo de saída | Inspecionar estado inicial e escolher caminhos novos em `.atena/`, sem sobrescrever evidência alheia. |

## Execução aprovada e reconciliação — 2026-09-30

O dono aprovou este voo. O inventário somente leitura foi executado e está
registrado em [[EVID-133-inventario-visual-herois-2026-09-30]], com a matriz
mensurável em [[HERO-ANIMATION-INVENTORY-001]]. Os dez heróis e 106 folhas
foram cobertos; as lacunas de direção, facing, reação a dano, efeitos
procedurais e combinações universais de armas estão explicitadas na evidência.

O resultado cumpre a finalidade desta SPEC como linha de base e recomendação
para o piloto. O inventário não fecha a escolha artística entre uma pose por
família de arma e variantes específicas, nem cria um catálogo de sprites VFX
inexistentes; essas decisões e a contagem final de variantes pertencem à SPEC
posterior do pacote Durvall. As caixas alfa são medidas agregadas de personagem,
arma e efeitos, não uma decisão automática de escala.

Nenhum arquivo em `assets/`, `data/`, `ui/` ou `core/`, nem manifesto de
produção, foi alterado. Não houve geração/admissão de candidatos, mudança de
gameplay, ou smoke de gameplay; testes de gameplay não se aplicam a este voo
estático. Próxima etapa: redigir a SPEC delimitada do pacote completo de
Durvall e submetê-la à aprovação per-SPEC antes de qualquer produção ou
integração.
