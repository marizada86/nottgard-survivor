---
id: "SPEC-077"
title: "Opções de áudio, vídeo e jogabilidade"
status: "implementada; verificação visual bloqueada por erro externo"
created: "2026-09-29"
relations:
  - "[[MENU-OPTIONS-001-acessibilidade-audio-video-2026-09-29]]"
---

# SPEC-077 — Opções de áudio, vídeo e jogabilidade

## Escopo

Organizar a aba Opções do Quartel em Áudio, Vídeo, Jogabilidade e Ações;
preservar volumes ao silenciar Música, Efeitos ou Ambiência; e persistir modo
de janela e uma resolução escolhida de uma lista segura.

## Critérios de aceite

1. Os controles de áudio aplicam a alteração imediatamente e a salvam.
2. Silenciar um canal não altera seu slider; ao reativá-lo, o mesmo nível volta
   a ser usado.
3. O jogador escolhe Janela, Sem borda ou Tela cheia, e uma das resoluções
   1280×720, 1600×900 ou 1920×1080.
4. Perfis anteriores, que só tinham `fullscreen`, carregam sem perda de
   preferência: `true` migra para Tela cheia e `false` para Janela.
5. F11 continua alternando Tela cheia e os testes de perfil passam.

## Não objetivos

Não inclui troca de idioma, remapeamento de teclas, VSync, seletor de monitor,
taxa de atualização, escala de interface, novo tema visual ou alteração de
regras/balanceamento.

## Plano de voo aprovado

1. Estender o esquema de perfil com migração compatível e aplicar as opções
   através de `Game` e dos buses de áudio existentes.
2. Reorganizar a cena do menu e seu gerador para apresentar os novos controles.
3. Cobrir a migração e os valores seguros em testes, executar a suíte e
   registrar evidência e reconciliação.

## Impactos

- `core/profile.gd`: defaults e migração de preferências.
- `core/game.gd` e `core/sfx.gd`: aplicação de janela/resolução e mute por bus.
- `ui/menu.*` e `tools/build_scenes.gd`: controles e manutenção da cena.
- `tests/`: contrato de perfil e valores de vídeo.

## Evidência e reconciliação

Implementação concluída em 2026-09-29 e registrada em
`[[EVID-060-opcoes-audio-video-2026-09-29]]`. Os controles, persistência,
migração e gerador de cena foram reconciliados. A certificação visual da run
permanece pendente: o checkout possui um erro de parse preexistente em
`core/playtest.gd`, fora do escopo desta SPEC.

