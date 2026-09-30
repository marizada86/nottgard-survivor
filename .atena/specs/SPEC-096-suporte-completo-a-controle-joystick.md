# SPEC-096 — Suporte completo a controle joystick

**Status:** implementação concluída; validação manual pendente  
**Aprovação:** 2026-09-29  
**Intenção canônica:** `[[INPUT-CONTROL-001-joystick-2026-09-29]]`  
**Plano de origem:** `[[PLAN-044-suporte-completo-a-controle-joystick-2026-09-29]]`

## Escopo

Implementar ações semânticas de entrada, movimento e mira por analógico,
comandos contextuais da run e navegação completa por foco para que uma partida
seja jogável apenas com controle. Teclado e mouse permanecem funcionais.

## Não objetivos

Remapeamento, vibração, multiplayer local, perfil por controle, prompts
dinâmicos por dispositivo, preferências expostas de zona morta/sensibilidade e
digitação no bloco de notas de QA.

## Critérios de aceite

1. Um jogador chega do título a uma run, navega ofertas e encerra a tentativa
   sem teclado ou mouse.
2. Analógico esquerdo move sem deriva; analógico direito controla apenas a mira
   manual e preserva a última direção válida dentro da zona morta.
3. Cada comando é válido somente no mesmo estado do equivalente de teclado.
4. Modais abrem e devolvem foco de forma previsível; confirmar e voltar não
   disparam ações inseguras.
5. Teclado/mouse não regridem; testes, smoke e uma checagem manual documentada
   passam.

## Impactos

- `core/game.gd`: ações e convenções de joystick.
- `ui/run.gd`, `ui/hud.gd`, `ui/title.gd`, `ui/menu.gd`: comandos e foco.
- `core/playtest.gd`: guia de controles.
- `tests/`: contratos de entrada e de telas.

## Plano de voo aprovado

1. Centralizar as ações e seus eventos de teclado, mouse e joystick.
2. Integrar movimento e mira ao loop de run com zona morta e prioridade segura.
3. Migrar comandos da run para ações contextuais.
4. Completar foco e navegação nas telas e modais.
5. Atualizar ajuda, testes, smoke e evidência ADD; reconciliar fatos afetados.

## Evidência e reconciliação

Implementação registrada em
`[[EVID-120-suporte-controle-joystick-2026-09-29]]`. A suíte e a fumaça estão
verdes. A validação com um controle físico permanece pendente e é o último
portão antes de declarar todos os critérios de aceite concluídos.
