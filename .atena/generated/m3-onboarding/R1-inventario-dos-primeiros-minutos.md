# R1: inventário dos primeiros minutos (SPEC-179, B-004/M3)

Gerado em 2026-10-15 por `tools/audit_first_encounters.tscn` (tempos), `tools/capture_first_ui.tscn` (telas) e leitura de `ui/hud.gd`, `core/battle.gd` e `core/playtest.gd`. Tempos são **indicativos**: o bot só desvia e não caça inimigos, então sobe de nível mais devagar que um jogador.

## Quando cada sistema aparece (Dagruve | Docas, em segundos de jogo)
| Sistema | Dagruve | Docas | Observação |
|---|---|---|---|
| Regra ambiental da fase (ritual de fundo, poças) | 8 | 9 | só visual |
| Primeiro aviso (toast/epígrafe) | 0 a 8 | 23 | |
| Telégrafo de ataque inimigo | 24 | 87 | |
| Primeiro interativo (sempre baú) | 45 | 45 | piso de 45 s (SPEC-147) |
| Subir de nível | 97 (jogador: bem antes) | 323 | oferta com rerrolagem |
| Evento de fase (aviso e início) | 110 / 115 | 85 / 90 | |
| Loja / Altar | n/d | 148 / 260 | varia por semente |
| Maré do Abismo (sequência de abates) | 144 | 331 | |
| Chefe | 300 | 300 | com introdução em cartão cheio |
| Segundo baú e item para trocar | 365 | 487 | decisão equipar/vender |
| Fase do chefe | 565 | 498 | |
| **Portal: Extrair ou Descer** | só após vencer o chefe | idem | primeira vez entre 6 e 10 min |

## O que a tela diz em cada um (capturas em `ui-primeiros-encontros/`)
| Sistema | O que o jogo mostra hoje | Lacuna | Nível |
|---|---|---|---|
| Level-up | Painel "Nível 2 — escolha (1-3)", comparação, "Rerrolar (R) — 2 restantes" e a linha de teclas | nenhuma relevante | ok |
| Altar | Painel explícito: bênção e maldição por opção, "Recusar a bênção" | os contadores ▲2 ▼1 não são explicados | baixo |
| Baú e fonte | Só o nome pequeno ("fonte") sobre o objeto; abrem ao encostar | não diz o que dão nem que é de encostar | médio |
| Ritual | Pergunta "[E] iniciar o ritual"; depois "O ritual atrai algo..." | não diz que invoca um elite e 6 inimigos, nem que o elite solta um baú | médio |
| Troca de item | Painel de comparação (SPEC-060, SPEC-081) | só aparece na 1ª troca, às vezes depois de 6 min | baixo |
| Maré do Abismo | Aviso "Maré Cinzenta: 10 abates (+2% XP por 5 s)" | nunca diz que 3 s sem matar zera | médio |
| Questlog "Missões" | Painel à direita com a missão e a condição ("Abre com «Ritual da Névoa» aos 1:55") | aparece sem introdução; não diz que é opcional | médio |
| **Extrair ou Descer** | Uma linha pequena no rodapé: "[Esc] Pausa → Extrair ×1.00   [E] Descer ×1.25" | **não diz o que é o ×**, que extrair encerra a run, nem o risco de descer; "Extrair" fica atrás do menu de pausa | **alto** |
| Habilidade (Q/botão direito) | Slot com o rótulo "Q/RMB" e recarga | rótulo some em piso claro | baixo |
| Ficha (C) | Botão "C Ficha" que pulsa até abrir | ok | ok |
| "Como jogar" (?) | 5 blocos de texto corrido, fora do momento de uso | ninguém lê no meio da fase | médio |

## Dicas candidatas para a R2 (texto até 90 caracteres, com a tecla ou botão do controle em uso)
Todos os textos foram conferidos contra o código. **Texto e escolha são seus** (gate G-M3-2).

| # | Gatilho (1ª vez no perfil) | Texto proposto | Por quê |
|---|---|---|---|
| D1 | Vencer o chefe e o portal abrir | "Extrair [Esc] encerra e leva a recompensa. Descer [E] segue: ×1,25 e mais risco." | lacuna alta |
| D2 | Perto do ritual | "O ritual invoca um elite e 6 inimigos; o elite solta um baú." | o texto atual não diz |
| D3 | Primeiro baú ou fonte à vista | "Baús e fontes abrem ao encostar." | o objeto só tem o nome |
| D4 | Primeiro marco da Maré | "Maré: abates seguidos dão XP extra. 3 s sem matar zera a sequência." | não está dito em lugar nenhum |
| D5 | Primeira missão no Questlog | "Missões opcionais: cumpra a condição para abrir câmaras e recompensas." | painel sem contexto |
| D6 | Primeiro altar aberto | "▲ são bênçãos, ▼ são maldições. Recusar apaga o altar." | contadores sem legenda |
| D7 | Primeiro item novo caindo | "Item novo: compare com o equipado antes de trocar (segure Shift)." | troca é decisão permanente |

Teto: 1 dica a cada 90 s, no máximo 7 no total, nunca em luta de chefe nem com vida abaixo de 30%.

## Achados de legibilidade fora do escopo de dicas
- O texto "Q/RMB" do slot de habilidade some em piso claro (mesma classe do F-13; correção barata).
- A linha de Extrair/Descer não tem destaque nenhum quando o portal abre.
