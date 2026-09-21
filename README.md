# Nottgard Survivors

Survivor-like lento e legível, ambientado em Nottgard, com foco no **Plano Abissal**. Sem história: a lore aparece só como sabor (nomes, bestiário, itens). Feito em Godot 4.7 com [Atena Driven Development](https://github.com/guimariz/atena-driven-development) (ADD) — specs, plano e evidências em [`.atena/`](.atena/).

## Jogar (playtesters)

1. Baixe o `NottgardSurvivors-windows.zip` do [release **latest**](../../releases/tag/latest), extraia e abra o `.exe`.
2. Na primeira vez, digite seu nome (vai no `.zip` de evidência).
3. Escolha herói e fase no Quartel e jogue. Todas as armas atacam sozinhas.

| Tecla | Faz |
|---|---|
| WASD / setas | mover |
| Tab | alterna mira automática ↔ mouse |
| E | altar, ritual, portal |
| X | extrair depois do chefe |
| 1–5 / R | escolher no level-up / rerrolar |
| Esc | pausa |
| **F5** | bloco de notas (guarda a nota + o print do instante) |
| **F6** | print da tela |
| **F7** | gera **um** `.zip` de evidência ao lado do executável — envie ao responsável |
| F1 / F11 | guia / tela cheia |

## Desenvolver

- Godot 4.7.2. Abra `project.godot`; a cena principal é `ui/menu.tscn` e as fases são cenas editáveis em `ui/stages/*.tscn` (props, spawns e posição do herói são nós na cena).
- Conteúdo em JSON em `data/` (heróis, armas, passivas, inimigos, fases, itens, bênçãos, conquistas, melhorias).
- Testes: `godot --headless --path . -s tests/run_all.gd` · Fumaça: `godot --headless --path . res://tools/smoke.tscn`
- Bot de balanceamento: `godot --headless --path . -s tools/bot.gd -- durvall 5 dagruve 0.08 8`
- Regerar cenas (sobrescreve edições manuais!): `godot --headless --path . res://tools/build_scenes.tscn`
- Exportar: `godot --headless --path . --export-release "Windows Desktop" build/NottgardSurvivors.exe` (precisa dos export templates 4.7.2).

O push na `main` roda testes, exporta o `.exe` e publica o release `latest` (ver `.github/workflows/build-release.yml`). Segredo opcional `DISCORD_WEBHOOK_DOWNLOADS` anuncia a build no Discord.
