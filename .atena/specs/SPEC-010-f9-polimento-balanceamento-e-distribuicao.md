# SPEC-010 — F9: polimento, balanceamento e distribuição

Status: aprovada (2026-09-21). Executada.

## Escopo
- Áudio sintetizado em código (`Sfx`), drone ambiente, VFX contidos.
- Bot de balanceamento headless (`tools/bot.gd`) e ajustes de ritmo.
- Exportação Windows (`export_presets.cfg`, exe único) e GitHub Action (`.github/workflows/build-release.yml`): testes → fumaça → export → release `latest` para os playtesters → anúncio opcional no Discord (segredo `DISCORD_WEBHOOK_DOWNLOADS`).
