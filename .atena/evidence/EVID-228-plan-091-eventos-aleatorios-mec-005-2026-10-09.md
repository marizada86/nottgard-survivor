---
id: "EVID-228"
title: "PLAN-091: seis eventos aleatórios novos (MEC-005, SPEC-164)"
created: "2026-10-09"
spec: "SPEC-164"
cards: ["MEC-005", "BAL-029", "ART-046"]
status: "implementado na branch atena/eventos-e-ui-fase1; aguarda a conferência e o merge do dono; aceite subjetivo pendente do playtest"
---

# EVID-228 — Seis eventos aleatórios

Spec: [SPEC-164](../specs/SPEC-164-eventos-aleatorios-novos-mec-005.md). Conteúdo: [proposta](../vault/drafts/PROPOSTA-eventos-aleatorios-mec-005-2026-10-09.md), **aprovada como está** pelo dono em 2026-10-09 (entrevista: 6 eventos genéricos, todas as fases, quatro tipos). Aprovação por plano. Feito **em branch local isolada** (`atena/eventos-e-ui-fase1`, worktree `F:\dev\_wt_work`) porque o dono estava ausente e quis conferir antes: nada na `main`.

## O que mudou

| Arquivo | Mudança |
|---|---|
| `data/random_events.json` (novo) | Os seis eventos: nome, rótulo, cor, texto de abertura e todos os números da proposta |
| `core/random_events.gd` (novo) | `RandomEvents`: contas puras (custo e teto do pacto, sangue do relicário, sorteio da carroça, multiplicadores do eclipse), `open` (monta a oferta) e `apply` (aplica a escolha) |
| `core/battle.gd` | `world_mod` (Eclipse) e `event_blood_lost`; `_open_random_event`, `spawn_ambush`, `_update_world_mod`; `interact()` e `choose()` (`ev_choice`); o Eclipse multiplica velocidade e dano dos inimigos comuns, XP e ouro dos abates (chefe fora); a pedra não reaparece com eclipse ativo |
| `core/hero.gd` | `run_mods`: bônus permanentes da run (Pacto de Sangue, Contador) |
| `data/stages.json` | Pesos dos seis em todas as nove fases (0,7 / 0,7 / 0,8 / 0,7 / 0,8 / 0,6) |
| `ui/hud.gd`, `ui/mobile_controls.gd`, `ui/overlay.gd` | Interação com E (inclusive toque), título da oferta, chip do Eclipse ao lado do nome da fase, losango colorido com rótulo (provisório) |
| `tools/audit_projeto.gd` | Reconhece os seis como interações válidas |
| `tests/test_random_events.gd` (novo) | Dados, "Sair", `interact()`, cada evento, o Eclipse e um teste de estresse (400 aberturas) |
| `tools/capture_random_events.{gd,tscn}` (novos) | Capturas |

Interpretações assumidas (a proposta dizia "XP igual a X% do nível atual"): XP = `xp_need` (o que falta para o nível) × a porcentagem, como já faz o passivo do Arlindo. Dinheiro de eventos (peregrino, carroça) entra no ouro da run mas **não** no ouro do Quartel (mesma regra da Aposta).

## Verificação

| Verificação | Resultado |
|---|---|
| `test_random_events` | 0 falhas (inclui 400 aberturas aleatórias em todas as fases, com herói de vida e ouro aleatórios: nenhuma trava, vida e ouro sempre válidos) |
| **Mutação** (12: pacto sem dano, sem teto; relicário sem custo, sem raridade mínima; roubar sem vingança; ajudar sem gratidão; contador sem bônus; carroça sempre recompensa; eclipse atinge chefe, empilha, nunca acaba; `interact()` ignora os novos) | 1 a 6 falhas cada; restaurado, 0 |
| `tests/run_all.gd` | `testes: 0 falha(s)` |
| `res://tools/smoke.tscn` | `smoke: ok` |
| `res://tools/kit_test.tscn` | `kit: OK` |
| `tools/audit_projeto.gd` | `erros=0; avisos=9` (os 9 de antes; sem a correção do audit eram 63) |
| Capturas 1280×720 (`.atena/generated/plan-091/capturas/`) | losangos dos seis, ofertas do Pacto de Sangue e do Contador, chip do Eclipse (a oferta da Pedra do Eclipse é gerada pela mesma ferramenta) |

Achados da captura, **corrigidos**: o cartão da oferta mostrava só a primeira linha (o jogador veria o custo e não o ganho); agora `brief` junta custo e ganho. Rótulos longos dos losangos eram cortados; ficaram curtos ("pacto", "relicário", "peregrino", "contador", "carroça", "eclipse").

## O que **não** foi medido

- **Bot:** ele só interage com altares, então não exercita os eventos novos. O estresse acima prova que não travam; **o equilíbrio (Pacto, Eclipse Rubro) só o playtest mede** (BAL-029). Ajuste é só no JSON.
- Arte: provisória (losango, texto); ART-046 registrada.
- Diversão e variedade percebida: só o dono.

## Para o dono conferir

Jogar uma run em Dagruve e esperar os interativos: os seis aparecem a cada 80 a 115 s junto dos atuais. Em `tools/capture_random_events.tscn` dá para ver as telas sem jogar. Merge: `git merge atena/eventos-e-ui-fase1` (ou cherry-pick dos commits do PLAN-091).
