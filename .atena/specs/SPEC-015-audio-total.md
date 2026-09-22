# SPEC-015 — Produção e integração total de áudio

Status: aprovado pelo usuário em 2026-09-22  
Autonomia: guarded-autopilot  
Escopo: áudio local do jogo, geração procedural original e integração Godot

## Objetivo

Substituir a síntese provisória em tempo de execução por uma biblioteca de áudio original,
reproduzível e organizada, cobrindo interface, progressão, combate, heróis, armas,
inimigos, chefes, ambientes, música e estados de resultado.

## Escopo

- Gerador determinístico sem dependências externas para WAV PCM 16-bit/22.05 kHz.
- Manifesto de áudio com variantes, buses, ganho, prioridade e cooldown.
- Buses separados para música, ambiência, interface, jogador, inimigos e impactos.
- Pool de vozes com limite de simultaneidade e roubo por prioridade.
- Música e ambiência específicas para as oito fases, menu, chefe e resultados.
- Assinatura sonora para todas as armas, poderes de herói e inimigos cadastrados.
- Controles persistentes de volume mestre, música, efeitos e ambiência.
- Compatibilidade com as chamadas legadas de `Sfx.play` durante a migração.

## Não objetivos

- Dublagem ou falas inteligíveis.
- Uso de material de terceiros, serviços remotos ou modelos pagos.
- Mixagem final de estúdio para publicação; esta entrega é uma biblioteca completa
  e funcional de produção independente, pronta para playtest e refinamento.

## Critérios de aceite

1. Todo evento jogável crítico possui retorno sonoro e fallback seguro.
2. Cada fase possui música e ambiência distintas, com loops contínuos.
3. Cada arma, poder de herói, inimigo e chefe cadastrado possui chave própria.
4. Sons críticos permanecem priorizados sob alta simultaneidade.
5. Os quatro controles de volume persistem em perfis novos e existentes.
6. O manifesto referencia apenas arquivos existentes e o gerador é reprodutível.
7. Testes existentes continuam válidos e há validação específica do catálogo de áudio.

## Impactos

- `core/sfx.gd`: passa a ser o orquestrador do manifesto e dos buses.
- `core/game.gd`, `core/profile.gd`: mixagem e persistência.
- `ui/menu.gd`, `ui/menu.tscn`: controles independentes.
- `ui/run.gd`, `core/battle.gd`: eventos contextuais de arma, herói e inimigo.
- `data/audio_manifest.json` e `assets/audio/`: catálogo gerado.

## Plano de voo

1. Criar gerador e catálogo.
2. Gerar e validar todos os arquivos.
3. Integrar orquestrador, buses e contexto.
4. Integrar eventos da run e controles do menu.
5. Adicionar validação automatizada.
6. Executar verificações, revisar drift e reconciliar evidências.

## Evidência esperada

- Relatório de geração com contagem, tamanho e hashes de catálogo.
- Validação estrutural do manifesto e dos arquivos.
- Resultado dos testes disponíveis no ambiente.

## Reconciliação

Esta especificação não altera o cânone narrativo. Ela materializa a decisão do usuário
de executar o plano de áudio aprovado e registra somente fatos operacionais da entrega.
