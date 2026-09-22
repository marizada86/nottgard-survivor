# SPEC-012 — Identidade e decisão

Status: aprovada pelo dono e verificada em 2026-09-22.

## Escopo
- Habilidade ativa própria para os dez heróis, orientada por `data/abilities.json`.
- Entrada por Q, botão direito e controle, recarga visível no HUD.
- Oferta de level-up estruturada em sinergia, defesa e nova direção.

## Plano de voo aprovado
- Arquivos permitidos: `core/`, `data/`, `ui/`, `tests/` e esta spec/evidência.
- Sem dependências, rede, publicação, commit ou alteração de assets.
- Até 3 ciclos de correção; recuperação por reversão seletiva dos patches desta spec.
- Validação: runner completo, smoke das oito fases e testes específicos de recarga/ofertas.

## Critérios de aceite
1. Cada herói usa uma habilidade distinta e respeita recarga.
2. O HUD comunica nome, tecla e recarga.
3. Ofertas não duplicam opções e, quando há candidatos, apresentam os três papéis.

## Resultado
Implementada e verificada. Evidência: `EVID-007-mecanicas-game-design.md`.
