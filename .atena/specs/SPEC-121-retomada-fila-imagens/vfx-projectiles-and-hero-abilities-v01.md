# SPEC-121 — Admissão dos projéteis (ART-029) e das habilidades dos heróis (ART-030) / v01

Estado: **APROVADA por plano em 2026-10-13**; entrega técnica 8/8 em 2026-10-13, playtest humano pendente ([evidência](../../evidence/vfx-projectiles-hero-abilities-admission-2026-10-13.md)). PLAN-053/SPEC-121, classificação IN_PLAN, retorno ao PLAN-071 (B-006/S-011). Pedido do dono: “atena, implemente os assets gerados recentes pelo chatgpt”; escolhas: **“Grupos A e B”** e **“Por plano”**. Conteúdo **DRAFT**; nenhuma promoção CANON, commit, push, merge, exportação ou publicação está incluída.

## Origem e inventário

| Grupo | Efeito | Quadros | Onde estão as fontes | Aceite do dono hoje |
|---|---|---:|---|---|
| A1 | Orbe radiante (voo 4 + impacto 4) | 8 | arquivo do Codex (`.codex/generated_images`), recuperáveis por SHA-256 do [audit](../../generated/s007-reconciliation/v01/orbe-radiante-sequence-audit-2026-10-09.json) | só P01 v01 ([recibo](../../generated/s007-reconciliation/v01/p01-owner-approval-2026-10-09.json)) |
| A2 | Orbe arcano (voo 4 + impacto 4) | 8 | idem, [audit](../../generated/s007-reconciliation/v01/orbe-arcano-sequence-audit-2026-10-09.json) | só Q01 v03 ([recibo](../../generated/s007-reconciliation/v01/q01-owner-approval-2026-10-09.json)) |
| A3 | Onda cortante (voo 4 + impacto 4) | 8 | idem, [audit](../../generated/s007-reconciliation/v01/onda-cortante-sequence-audit-2026-10-09.json) | só R01 v02 ([recibo](../../generated/s007-reconciliation/v01/r01-owner-approval-2026-10-09.json)) |
| B (H1–H10) | Habilidade de cada um dos 10 heróis, 6 quadros | 60 | commit `10bd31c` da branch `codex/fila-imagens-continuacao-2026-10-09` (não mesclada na main) | nenhum |

Os outros quadros de A “não são individualmente aprovados”: revisão do modelo não é aceite humano. Erik/Arlindo, Pulso Radiante e Ampulheta do Silêncio já estão na main e **fora** deste escopo.

## Bíblia visual (resumo; vale ART-PROMPTS-053 e 054)

Efeito neutro branco/cinza, vista de cima achatada, fundo preto, 1254×1254 nativo, pivô no centro; cor vem da tinta em runtime (`DivineVisuals`). Projéteis apontam para a direita, cauda à esquerda; impactos centrados e sem cauda. Pulsos e ciclos simétricos, fecham sem salto. Identidade de personagem: N/A (efeito abstrato). Contexto de cena: combate isométrico 2:1 (`Iso.to_screen`), arena e UI atuais. Referências: quadros-gate aprovados (P01, Q01, R01 v02) e, em B, os previews/contatos de `10bd31c`. Hipóteses abertas: raio/pivô geométrico (o centro fotométrico é só proxy).

## Etapas e checkpoints (modo per-plan)

1. **S-001 / B-001 — Recuperar e preparar a revisão.** A: recuperar os 24 quadros por SHA e conferir hash/dimensão. B: extrair os 60+ de `10bd31c` somente leitura e conferir contra `jobs.json`/`completion-audit.json`. Auditoria técnica (dimensão, bordas, fundo, luminância, pivô proxy), pranchas por efeito, GIFs de voo/impacto e galeria local. Nada vai a `assets/`.
2. **S-002 / B-001 — Gate humano GATE-A.** Dono avalia a sequência de cada projétil (A1, A2, A3) por versão/hash: aceita, pede correção de quadro(s) ou rejeita. **Para aqui.**
3. **S-003 / B-002 — Admissão A.** Para cada efeito aceito: derivado 1024 (auditoria) e atlas runtime (8 células 256×256, RGB branco, alfa = luminância Rec.709, piso ≤2/255 só no derivado, pivô comum); helper visual limitado e roteamento por allowlist de armas; recurso ausente ou impacto reduzido mantêm o visual atual. Só o desenho: dano, colisão, alcance, RNG e cooldown intactos.
4. **S-004 / B-002 — Verificação A.** Teste focado, suíte completa, smoke de 9 fases, capturas de voo e impacto por arma, regressão de Pulso e Ampulheta.
5. **S-005 / B-003 — Gate humano GATE-B.** Dono aceita, herói por herói (H1–H10), as sequências de habilidade por versão/hash. Aceite parcial vale: herói não aceito fica fora do runtime. **Para aqui.**
6. **S-006 / B-003 — Admissão B.** Por herói aceito: atlas 6 células 256×256, helper e ligação ao evento da habilidade existente (`ui/run.gd`, evento `active`/da habilidade), duração e raio vindos de `data/abilities.json` sem alterá-los. Fallback preserva o visual atual.
7. **S-007 / B-003 — Verificação B.** Teste focado por herói, suíte, smoke, capturas por habilidade, regressão A/Pulso/Ampulheta.
8. **S-008 / B-004 — Entrega.** Evidência, hashes, backups, links, estado, roteiro de playtest e build id local. Entrega técnica pode fechar sem playtest humano; sensação e legibilidade em jogo ficam pendentes do dono.

## Arquivos permitidos e proteção

Permitidos: `assets/vfx/` (atlas novos), `core/*_vfx.gd` (helpers novos), `ui/run.gd` e, se for o único ponto de desenho dos projéteis, `ui/overlay.gd`; testes novos em `tests/`; ferramentas e saídas sob `.atena/generated/vfx-projectiles-hero-abilities-2026-10-13/`; registros operacionais. Protegidos por hash: `core/battle.gd`, `data/`, demais assets e heróis. Backup verificável de tudo que for substituído; rollback restaura os bytes sem reset Git. Sem dependência, geração remota ou áudio.

## Prontidão

**BLOCKING (humano, por etapa):** GATE-A antes de S-003; GATE-B antes de S-006. **RESOLVABLE:** como os projéteis são desenhados hoje (`ui/overlay.gd`, S-003); gancho de cada habilidade e quais já reaproveitam efeitos de A/Pulso (Brook, Leoric — S-006); escolha de versão onde há v02 (Brook loop_00, Durvall sweep, Sylas). **DEFERRED:** playtest humano, balanceamento visual fino, novas famílias VFX, Git/publicação, BUG-025/027/028/029.

## Aceite técnico

Fontes preservadas byte a byte; atlas com células válidas e sem cortes, retângulo de fundo ou deslocamento; projeção 2:1 correta; nenhum evento fora da allowlist; liberação ao fim; suíte/smoke sem regressão; protegidos intactos por hash. Aceite de beleza, fluidez e legibilidade é **só do dono**.

## Playtest (a informar antes de cada marco)

Build local com id próprio; objetivo: ver cada efeito no tamanho real, em chão claro e escuro, com e sem impacto reduzido. Atena verifica funcionamento; o dono julga sensação. Não realizado.

## Resultado

S-002 e S-005 aceitos pelo dono em 2026-10-13 (“atena está aprovado continue a implementação”, [recibo](../../generated/vfx-projectiles-hero-abilities-2026-10-13/authorization.json)). Ajuste registrado na S-003: o impacto dos projéteis toca no acerto que o consome **ou** no fim do alcance, porque o evento `hit` não identifica a arma e `core/battle.gd` é protegido. Entrega técnica 8/8; aceite de sensação em jogo pendente.
