# Nottgard Survivors

Survivor-like lento e legível, ambientado em Nottgard, com foco no **Plano Abissal**. Sem história: a lore aparece só como sabor (nomes, bestiário, itens). Feito em Godot 4.7 com [Atena Driven Development](https://github.com/guimariz/atena-driven-development) (ADD) — specs, plano e evidências em [`.atena/`](.atena/).

## Jogar (playtesters)

1. Baixe o `NottgardSurvivors-windows.zip` do [release **latest**](../../releases/tag/latest), extraia e abra o `.exe`.
2. Na primeira vez, digite seu nome para identificar o contexto do playtest.
3. Escolha herói e fase no Quartel e jogue. Todas as armas atacam sozinhas.

| Tecla | Faz |
|---|---|
| WASD / setas | mover |
| Tab | alterna mira automática ↔ mouse |
| Q / botão direito | habilidade ativa do herói |
| E | altar, ritual, portal, loja, ferreiro, curandeiro, ampulheta |
| T | velocidade 2x (só em mapa já vencido) |
| X | extrair depois do chefe |
| 1–5 / R | escolher no level-up / rerrolar |
| Esc | pausa |
| **F4** | abre o Navegador QA na build de playtest |
| **F5** | bloco de notas; grava relato textual com data, hora e contexto |
| **F6** | print da tela |
| F1 / F11 | guia / tela cheia |

Depois de cada chefe, **X** extrai e garante a recompensa atual; **E** entra no portal, mantém a build e aumenta o multiplicador de risco e recompensa. Cada camada possui uma regra ambiental própria, e os chefes mudam de fase em 70% e 35% de vida.

As evidências ficam ao lado do executável em `evidencias/`: `relato.txt`,
`logs/jogo.log` e os PNGs de `imagens/`. Envie os arquivos de texto e imagem
individualmente na task correspondente do Discord.

## Desenvolver

- Godot 4.7.2. Abra `project.godot`; a cena principal é `ui/menu.tscn` e as fases são cenas editáveis em `ui/stages/*.tscn` (props, spawns e posição do herói são nós na cena).
- Conteúdo em JSON em `data/` (heróis, armas, passivas, inimigos, fases, itens, bênçãos, conquistas, melhorias).
- Testes: `godot --headless --path . -s tests/run_all.gd` · Fumaça: `godot --headless --path . res://tools/smoke.tscn`
- Áudio: `node tools/generate_audio.js` regenera a biblioteca original; `node tools/validate_audio.js` confere cobertura, WAVs, silêncio e clipping; `node tools/install_sfx.js evento=arquivo.mp3` instala um som real no lugar do placeholder.
- Bot de balanceamento: `godot --headless --path . -s tools/bot.gd -- durvall 5 dagruve 0.08 8`
- Regerar cenas (sobrescreve edições manuais!): `godot --headless --path . res://tools/build_scenes.tscn`
- Exportar: `godot --headless --path . --export-release "Windows Desktop" build/NottgardSurvivors.exe` (precisa dos export templates 4.7.2).

O push na `main` roda testes, exporta o `.exe` e publica o release `latest` (ver `.github/workflows/build-release.yml`). Segredo opcional `DISCORD_WEBHOOK_DOWNLOADS` anuncia a build no Discord.
