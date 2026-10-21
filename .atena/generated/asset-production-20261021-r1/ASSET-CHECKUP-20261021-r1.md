# Checkup de assets — 2026-10-21 (r1)

Status: DRAFT, somente diagnóstico. Evidências (capturas do jogo rodando em janela real, contact sheets, scripts): `.atena/generated/asset-checkup-20261021/`.
Método: inventário por pasta; cruzamento de ids de `data/*.json` com os arquivos; capturas de 20 telas (título, Quartel e abas, level-up, altar, ficha, combate, vitória, mapas novos); comparação de heróis, inimigos e ícones com as referências CANON do Vault (`output/referencias-personagens`, HEAD `50008c9`).

## 1. Inventário

| Pasta | PNG | Peso | Observação |
|---|---:|---:|---|
| `assets/animations` | 391 | 164 MB | 60 inimigos + 12 heróis + interações; quadros 256×384 (320×480 nos 2 Guardiões e no Sacerdote) |
| `assets/hq` | 126 | 359 MB | capítulo 1 (66) e capítulo 2 (64); HQ05–HQ10 ainda sem arte |
| `assets/tiles` | 49 | 119 MB | inclui `domwieck_r1`, `reino_abissal_roots_r1`, `yggdrasil_r1` |
| `assets/portraits` | 12 | 13 MB | 12 heróis, 1536×1024 (Kayron 640×427) |
| `assets/ui` | 31 | 14 MB | molduras da ficha, banners, fundos, logo |
| `assets/enemies` | 65 | 12 MB | estáticos (todos os ids de `enemies.json`, incluído `nidhogg`) |
| `assets/props` / `interactions` / `icons` | 85 / 54 / 132 | 12 MB | ícones 128×128 |
| `assets/stages` | 11 | 9 MB | 2 fundos 1536×1024 e 9 miniaturas 480×320 |
| `assets/vfx` / `decals` / `fx` / `pickups` | 22 / 20 / 4 / 4 | 30 MB | |
| `assets/audio` | — | 29 MB | fora do escopo da lista de geração |

## 2. Cobertura (ids do jogo × arquivos)

- Inimigos: 64 de 64 com arte estática; faltam pasta de animação só em `nidhogg`, `molydeus_menor`, `ilusao_de_sucubo` e `ilusao_de_socothbenoth` (os três últimos reaproveitam o `source_id`).
- Armas: 7 sem ícone próprio (usam o de outra arma): `maca_demolidora`, `raio_da_ruina`, `dominio_coletivo`, `martelo_da_luz`, `constelacao_de_silva`, `memoria_alterada`, `tocha_do_incendiario`.
- Itens únicos: 1 sem ícone, `espelho_das_almas_desejantes`. O `olho_de_ghaunadaur.png` ficou órfão desde o lote 1.
- Bênçãos: 13 de 29 sem ícone próprio (usam o de outra bênção do mesmo deus): Mask ×2, Lliira, Shar ×2, Selûne, Ghaunadaur, Helion, Lu Yueh, Zuggtmoy ×2, Juiblex ×2.
- VFX de habilidade de herói: faltam `habilidade_arlindo` e `habilidade_erik` (os outros 10 existem).
- Miniaturas de fase: faltam `reino_abissal` e `domwieck` (a lista do Quartel mostra a linha sem imagem).
- Introduções de chefe (`assets/ui/boss-intros`): só 1 de 9 (Sacerdote da Mente Derretida). O Guardião Alado tem `image: ""`. O audit já avisa 7 chefes sem entrada.
- Reino Abissal e Domwieck não têm decais, Ecos, ruína de POI nem estruturas de relíquia; Pilares não tem Eco nem relíquia.
- Crônicas de Reino Abissal e Domwieck: só o rascunho `CHRONICLES-NEW-MAPS-DRAFT-r1.md`.

## 3. Aderência ao Vault (arte)

Referência: PNGs CANON do Vault. Heróis e inimigos do capítulo do Abismo foram, em boa parte, a origem dessas referências, então a maioria bate.

| Item | Veredito | Detalhe |
|---|---|---|
| Heróis (12 retratos e sprites) | OK | Estilo e identidade consistentes. Brook halfling segue a decisão do jogo. Kayron: olhos vermelhos com pupila escura visível; `DEC-AASIMAR-EYES-001` pede uma cor só em toda a superfície do olho. Conferir e, se preciso, reeditar. |
| Zuggtmoy, Blogbog, Socothbenoth, Malcanthet, Arch-hag, Lu Yueh, Molydeus | OK | A segunda cabeça do Molydeus é verde no canon e vermelha no jogo (detalhe). |
| **Síntese Abissal** | Resolvido provisoriamente | Placeholder derivado do canon roxo (lote 2). Falta a arte final e a animação desenhada. |
| **Death Tyrant** | Diverge | Jogo: beholder de olho azul. Canon: criatura escura de espinhos e crânio com olhos vermelhos. |
| **Receptáculo de Juiblex** | Diverge | Jogo: limo humanoide verde. Canon: monte de carne com um grande ovo/núcleo. |
| **Manifestação de Juiblex** | Diverge | Jogo: limo verde-amarelado com olhos. Canon (`JTJJ-COMPLETE-CANON`): massa negra de tentáculos com olhos vermelhos. |
| **Gárgula** | Diverge | Jogo: fera de pedra cinza. Canon: figura alada, armadura prateada com veios lilás (família de gárgulas). |
| **Crueldades (Master of Cruelties)** | Diverge | Jogo: demônio alado esguio. Canon: demônio encouraçado de chifres e rosto de caveira, com lança. |
| Ezro, Shu | Parcial | Mesma ideia, acabamento e paleta diferentes (Ezro marrom-ocre no canon). |
| Introdução do Sacerdote da Mente Derretida | Diverge | A cena é um cais com mar e lua; o chefe é de Dagruve (cemitério/capela). |
| Nidhogg | Provisório | Estático, recortado da referência DRAFT cabeça-pescoço. Corpo completo e animação não existem. |

Canon sem presença no jogo: Reaper do Estige (há evento e NPC, falta inimigo), Beholder, Astherion, Kūkan Shito, Taverneiro metamorfo, Atendente, Willie e Wonka, Thalion, Marciela, Kein, Hrothgar, Aranel, Corvus, Illithar, Temenus.

## 4. UI e estilo (telas capturadas)

1. **Oferta de level-up, altar, baú, loja** (`ui/offer_card.gd`, painel de 680×64 por opção): painel preto liso, ícone 44 px, título e uma linha de texto. É o contraste mais forte com a **ficha do herói**, que usa moldura ornamentada. Não há distinção visual de tipo (arma, passiva, bênção, item), de raridade (comum, mágico, incomum, raro, único), nem destaque para "NOVA", evolução ou sinergia. As setas ▲▼ do altar são texto.
2. **Quartel**: abas Marcas, Melhorias e Conquistas são listas de texto; Melhorias tem 18 itens sem ícone nem indicador de nível; Marcas tem 9 marcas com −/+; Conquistas tem 64 itens com "☆" em texto. A lista de heróis não mostra retrato e a lista de fases tem miniaturas só em parte.
3. **Códex**: lista de "???" sem silhuetas e painel direito vazio.
4. **HUD**: moldura do herói boa, mas barra de PV lisa, medidores de CA/CAM sem moldura, e o botão "?" e a dica "Q/RMB" usam outra fonte (sans) que destoa da fonte serifada do resto. No mapa das Docas, o aviso laranja de interação encosta no canto e fica cortado ("oficina d…").
5. **Reino Abissal** (fundo vazio com raízes) e **Domwieck** (piso quase liso na entrada, uma casa) estão sem a densidade de props e decais dos mapas antigos.
6. **Texto**: o toast da rotação dos Pilares mostrava ids crus ("puddles"). Corrigido neste lote em `core/battle.gd` (`PILLAR_RULE_LABELS`).
7. Pontos fortes: título, logo, ficha, vitória/derrota, retratos, inimigos e ícones têm direção coesa. Os ícones são consistentes em estilo (128×128), mas não têm moldura de raridade.

## 5. Correções feitas durante o checkup

- Durvall: "Receptáculo" ocultado (título agora "Drow · Armadura Negra"; bio sem o termo; armas de evolução renomeadas só no nome de exibição: "Espada da Armadura Negra" e "Muralha Negra"; ids técnicos preservados). `tests/test_playtest_fixes.gd` ajustado.
- Toast dos Pilares com rótulos em português.

## 6. Próximo passo

A lista de geração/regeneração para o ChatGPT está em `ASSET-GENERATION-LIST-20261021-r1.md`.
