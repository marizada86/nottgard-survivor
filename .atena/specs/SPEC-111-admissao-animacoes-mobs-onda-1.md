---
id: "SPEC-111"
title: "Admissão das animações aprovadas dos mobs da Onda 1"
status: "implementada e verificada; pronta para push"
created: "2026-09-30"
relations:
  - "[[PLAN-048-geracao-animacoes-mobs-onda-1-2026-09-30]]"
  - "[[SPEC-109-admissao-animacoes-guardiao-copia]]"
  - "[[EVID-128-lote-a-animacoes-mobs-2026-09-30]]"
  - "[[EVID-133-lote-b-mobs-2026-09-30]]"
  - "[[EVID-134-lote-c-mobs-2026-09-30]]"
  - "[[EVID-136-ciclo-guardiao-copia-2026-09-30]]"
---

# SPEC-111 — Admissão das animações aprovadas dos mobs da Onda 1

## Intenção e aprovação

O dono solicitou consolidar o trabalho de todos os prompts, implementar o que
ainda não estava no jogo e fazer push. Esta solicitação aprova a admissão no
projeto dos ciclos visualmente aprovados da Onda 1 e o uso dos seus candidatos
no jogo. Ela não afirma nem cria termos de terceiros; registra a decisão do
dono sobre o uso pretendido neste repositório.

## Escopo

- Compor e admitir tiras dos ciclos aprovados de `slime_corrosivo`,
  `cultista_arqueiro`, `cultista_cajado`, `notivago`, `criatura_corrompida`,
  `arch_hag`, `tentaculo_kraken`, `guardiao_verdadeiro` e `guardiao_copia`.
- Usar somente os arquivos selecionados por `CANDIDATES-MANIFEST-003`, inclusive
  os overrides v02 e as três poses de piloto de `guardiao_copia`.
- Produzir tiras horizontais sem recorte, escala, espelhamento ou redesenho das
  células: 256×384 para perfis A/C e 320×480 para os dois guardiões.
- Registrar os inimigos no runtime visual, manter fallback estático e permitir
  flip horizontal apenas durante movimento para os perfis móveis.
- Atualizar testes, executar a suíte, registrar evidência e enviar o conjunto
  consolidado à branch remota atual.

## Não objetivos

- Admitir as pranchas de prova de Durvall ou Leoric, que não são tiras aprovadas.
- Alterar arte estática, IA, stats, combate, gatilhos de habilidade ou balanceamento.
- Gerar ou substituir candidatos novos, publicar release, abrir PR ou mesclar.

## Critérios de aceite

1. Cada tira tem a largura, altura, ordem e contagem previstas pelo manifesto;
   as células de origem são preservadas sem transformação.
2. Os nove inimigos carregam os estados aprovados no runtime; `special` dos
   guardiões é reproduzível explicitamente, sem criar gatilho de IA.
3. A suíte verifica arquivo, importação, dimensão, alfa, contagem, fallback,
   flip de movimento, ataque, morte e `special` quando aplicável.
4. O diff se limita a assets de animação, integração visual, testes, ferramentas
   e registros ADD associados. Durvall e Leoric permanecem candidatos isolados.
5. O commit local e o push são concluídos somente após os testes passarem.

## Plano de voo

1. Conferir o manifesto e os quadros selecionados.
2. Compor primeiro tiras candidatas locais e validar sua estrutura.
3. Promover as tiras validadas para `assets/animations/enemies/` e registrar o
   runtime/testes mínimos necessários.
4. Executar a suíte e a validação de diff; registrar evidência e reconciliação.
5. Criar um commit consolidado e fazer push da branch atual.

## Reconciliação — 2026-09-30

Foram compostas e admitidas 37 tiras para os nove inimigos do escopo. As
fontes vieram exclusivamente dos quadros selecionados em
`CANDIDATES-MANIFEST-003`; o compositor preserva células, ordem e overrides
v02. `ui/enemy_view.gd` agora carrega os estados aprovados, e
`tests/test_animation_assets.gd` verifica assets e comportamento runtime.

O Godot 4.7.2 reimportou os 37 PNGs. A suíte
`godot --headless --path . -s tests/run_all.gd` terminou com `testes: 0
falha(s)`. Os avisos de log, certificados e limpeza ao encerrar são limitações
do ambiente Windows e não produziram falha de teste. EVID-138 registra o lote.

Durvall e Leoric continuam fora do runtime: os seus resultados são pranchas de
prova sem normalização nem aprovação de admissão.
