# SFX-LISTA-001 — lista de SFX do Nottgard Survivors (2026-10-03)

> Candidato em `.atena/generated/` (ainda não admitido no backlog). Relaciona-se com **ART-006**.

## Situação atual

- **Todo evento de som já existe como placeholder sintético**, gerado por `tools/generate_audio.js`
  (WAV mono, 16 bit, 22 050 Hz) e registrado em `data/audio_manifest.json`. São **~280 eventos**.
- Substituir um som = trocar o `.wav` no mesmo caminho do manifesto (ou apontar `files` para um `.ogg`/`.wav` novo).
  O `node tools/generate_audio.js` agora **só preenche lacunas**: mantém os eventos, aliases e WAVs que já existem.
  `--force` refaz tudo e **apaga os sons reais**; não use depois de começar a substituir.
- O código cai num som genérico quando o específico não existe (`core/sfx.gd`):
  `weapon.X.fire` → `combat.swing/magic/nova/zone`, `hero.X.active` → `combat.magic`,
  `boss.X.*` → `boss.arrival`, `enemy.X.*` → `enemy.action/death`.
  Por isso a ordem certa é **genéricos primeiro, específicos depois**.

**Legenda de fontes:** **S** = Sonniss GDC Bundle · **F** = Freesound (filtro CC0) · **K** = Kenney audio packs ·
**J** = jsfxr/ChipTone · **A** = Audacity (camadas ou edição a partir de outro som da lista)

---

## P0 — eventos que o código chama e que estavam mudos (**concluída 2026-10-03, todos com som real do Ludo**)

> Desde o commit 32754f7, cada um tem um **alias provisório** para o placeholder mais próximo (veja `aliases` no
> manifesto). Ao criar o evento próprio com o mesmo nome, **remova o alias** do manifesto e do gerador:
> o alias é resolvido antes do evento e, se ficar, continua tocando o placeholder.

| Evento chamado | Onde | O que deveria soar | Fonte |
|---|---|---|---|
| ~~`progress.gold`~~ | coleta de ouro (`ui/run.gd:974`) | moeda tilintando, curta. Já existe `progress.coin` sem uso: **basta um alias** | **feito (Ludo)** |
| ~~`progress.potion`~~ | coleta de poção | rolha + gole/brilho (o `player.heal` toca junto) | **feito (Ludo)** |
| ~~`progress.magnet`~~ | coleta do ímã | "puxão" mágico subindo | **feito (Ludo)** |
| ~~`world.boss_chest`~~ | baú do chefe | baú pesado abrindo + coro/brilho, mais épico que `world.chest` | **feito (Ludo)** |
| ~~`world.loja`~~ | interação com loja | sino de porta + moedas | **feito (Ludo)** |
| ~~`world.ferreiro`~~ | interação com ferreiro | **feito 2026-10-03:** som real do Ludo.ai (`world.ferreiro_01.mp3`, 0,76 s) | Ludo |
| ~~`world.curandeiro`~~ | interação com curandeiro | sino suave + brilho sagrado | **feito (Ludo)** |
| ~~`world.ampulheta`~~ | interação com ampulheta | areia escorrendo + "tic" de vidro | **feito (Ludo)** |
| ~~`world.doacao`~~ | interação de doação | moedas caindo numa caixa | **feito (Ludo)** |
| ~~`world.aposta`~~ | interação de aposta | dados rolando em madeira | **feito (Ludo)** |

> Correção do que eu disse antes: o ART-006 falava só de `quebravel`, mas o manifesto já cobre os quebráveis.
> O que falta de verdade é o que está nesta tabela.

## P1 — núcleo do loop (toca o tempo todo; é o que mais pesa na sensação)

| Evento | Descrição | Fonte |
|---|---|---|
| `combat.impact` | golpe acertando carne/armadura, seco, **3 variações** | S |
| `combat.critical` | impacto + "crack" agudo/metálico por cima | S + A |
| `combat.miss` | whoosh vazio | S |
| `combat.swing` | whoosh de lâmina (fallback das armas físicas) | S |
| `combat.magic` | disparo arcano curto (fallback das magias e ativas) | S |
| `combat.nova` | onda que se expande | S |
| `combat.zone` | área no chão ativando (zumbido/crepitar) | S |
| `combat.explosion` | explosão média, sem grave exagerado (toca muito) | S |
| `combat.barrier` / `combat.dodge` | escudo de energia / passo rápido + whoosh | S |
| `player.hurt` | grunhido curto + impacto, **sem voz de herói específico** | S |
| `player.heal` | brilho ascendente suave | S |
| `player.guard` | lâmina/escudo bloqueando | S |
| `player.death` / `player.revive` | queda + respiração cortada / coro curto subindo | S |
| `progress.xp` | "plim" cristalino curto (o tom sobe na coleta encadeada) | J / K |
| `progress.levelup` | fanfarra curta + brilho, referência Symphony of the Night (ART-010) | S + A |
| `progress.item` | revelação de item (brilho + "tchan") | S |
| `ui.click` / `ui.hover` / `ui.confirm` | UI de madeira/pergaminho, discreta | K |
| `enemy.telegraph` / `enemy.charge` / `enemy.summon` | aviso de ataque / investida / portal de invocação | S |
| `boss.arrival` | sino grave + rugido distante (fallback de todos os chefes) | S |
| `result.victory` / `result.defeat` | estinger de vitória / de derrota (2–4 s) | S |
| `world.chest` · `world.fountain` · `world.altar` · `world.ritual` · `world.portal` | baú / água mágica / pedra + chama / cântico curto / portal abrindo | S / F |

## P2 — identidade (armas, ativas, chefes)

### Armas — `weapon.<id>.fire` (25)

| Grupo | Armas | Base sugerida |
|---|---|---|
| Lâminas | espada_sombria, espada_do_receptaculo, adaga_rapida, estocada_mistica, lamina_da_digestao | whoosh de lâmina; sombria/receptáculo com camada grave; digestão com camada úmida |
| Contusão | golpe_esmagador, golpe_atordoante, martelo_da_gloria, machado_de_xargath | whoosh pesado + impacto grave |
| Sagrado/luz | golpe_do_juizo, sentenca_de_lliira, julgamento_da_gloria, raio_de_luz, luz_mais_pura, marca_da_retidao | coro curto, sino, "shimmer" |
| Estelar | descarga_estelar, chuva_de_estrelas, sopro_de_estrela, rajada_infinita | sci-fantasy: brilho + zap |
| Cera/fogo | cera_fervente, inferno_de_cera, vela_sagrada | fogo crepitando + "chiado" de cera |
| Trovão | lamina_trovejante, tempestade | estalo elétrico + trovão curto |
| Sombrio/mente | dominar_pessoa, raio_enfraquecedor, colar_dos_tentaculos | sussurro invertido, tentáculo úmido |
| Únicas | chicote_avarento (chicote + moedas), cajado_dos_desejos (sino mágico), ampulheta (areia + tic) | A |

### Ativas dos heróis — `hero.<id>.active` (10)
durvall, brook, maelor, sylas, kayron, korrak, leoric, nyrelia, zynara, bromnor.
A ideia é um som marcante por herói, ligado ao efeito da ativa. Vale definir junto com a arte das ativas.

### Chefes — `boss.<id>.arrival / phase / defeat` (8 × 3 = 24)
sacerdote_mente_derretida, zuggtmoy, blogbog, molydeus_chefe, lu_yueh, malcanthet, socothbenoth, sintese_abissal.
- **arrival:** rugido ou cântico próprio + sino grave
- **phase:** rugido mais curto + grave subindo
- **defeat:** grito longo + desmoronamento

## P3 — inimigos e quebráveis (`enemy.<id>.action / death`)

São ~45 inimigos e 13 quebráveis, cada um com 2 sons. **Não precisa de som único para cada um:** dá para montar
por família e variar pitch e camadas no Audacity.

| Família | Inimigos | action / death |
|---|---|---|
| Mortos-vivos | zumbi, notivago, alma_penada, escravo_de_rivenheart | gemido / ossos caindo, lamento |
| Cultistas | cultista_adaga, _arqueiro, _cajado, _thullgrime, _de_feng_tu, _de_socothbenoth, _ghaunadaur, discipulo_pestilento | grito humano curto / queda + metal |
| Slimes | slime_corrosivo, bolha_de_slime, pudim_negro, slime_de_juiblex, receptaculo_de_juiblex | "squelch" / estouro úmido |
| Fungos | cogumelo_fungico, servo_de_zuggtmoy, esporo_voador | "puff" de esporos / murchar |
| Pedra/construtos | guardiao_copia, guardiao_verdadeiro, gargula, carcereiro_de_pedra, estatua_do_templo, guardiao_de_goranthis, guarda_do_castelo | raspar de pedra/armadura / desmoronar |
| Demônios | demonio_de_gehenna, molydeus_menor, sucubo, ilusao_de_sucubo, master_of_cruelties | rosnado / explosão de enxofre |
| Aberrações | criatura_corrompida, tentaculo_kraken, aberracao_shu, death_tyrant, larva_de_lu_yueh, mimico, ezro, arch_hag | chiado alienígena / implosão úmida |
| Ilusões | ilusao_de_socothbenoth (e ilusao_de_sucubo) | sussurro / vidro se desfazendo |

O nome do inimigo também aparece em `enemy.<chefe>.*` (blogbog, zuggtmoy etc.), que pode usar o mesmo som do chefe.

**Quebráveis, por material:**
- **madeira:** caixote, carroca, pilha_carga
- **cerâmica:** urna_funeraria
- **metal/vela:** candelabro
- **vegetal:** arbusto
- **papel:** lanterna_de_papel
- **vidro:** espelho_ilusorio
- **pedra:** estatua_rachada
- **orgânico:** saco_de_esporos, casulo_viscoso
- **mágico:** relicario_instavel

Fonte: K (impact packs) + F.

## Ganchos no manifesto **sem chamada no código** (não precisam de som agora)

`ui.cancel/open/close/invalid/pause/resume/tab`, `progress.coin/chest/fountain/altar/ritual/upgrade/evolution/achievement/reroll/unlock/portal`,
`world.descent/elite/warning`, `combat.block/fire/radiant/physical/stun/knockback/projectile/burn`, `player.dash/footstep/overdrive`.
Vale ligar alguns quando houver som real (ex.: `ui.cancel` no botão voltar, `progress.reroll` na rolagem, `world.elite` na chegada do elite).

## Fora do escopo desta lista
Música (`music.*`, 13 faixas) e ambiente (`ambience.*`, 9 biomas) também são placeholders sintéticos. Ficam para uma lista à parte.

## Formato de entrega
- SFX curtos em **WAV 44,1 kHz mono 16 bit** (o Godot aceita misturar com os de 22 kHz); loops e música em **OGG**.
- Normalizar em torno de **-1 dBFS de pico**, cortar o silêncio do início (latência) e aplicar fade-out de 5–10 ms.
- Manter a convenção de nome `evento_01.wav`, `evento_02.wav`… e o número de variações já previsto no manifesto.

## Ferramentas de IA testadas (2026-10-03)

| Ferramenta | Resultado | Observação |
|---|---|---|
| Seedance 2.5 | não deu certo | modelo de vídeo; o áudio vem como subproduto |
| Adobe Firefly (Generate Sound Effects) | gerou, mas não agradou | — |
| **Ludo.ai** | **aprovado** (ferreiro) | prompt com vocabulário de jogo: `Fantasy RPG game sound effect, ..., dry, close, clean, no music, no background` |

O MP3 do Ludo entra direto (o Godot importa MP3); `tools/validate_audio.js` aceita MP3/OGG. Conferir licença do plano usado antes do lançamento.

## Contagem para planejar
- **P0:** 10 sons
- **P1:** ~30 eventos (~70 arquivos com variações)
- **P2:** 25 armas + 10 ativas + 24 de chefes
- **P3:** ~16 famílias/materiais como base, depois variações
