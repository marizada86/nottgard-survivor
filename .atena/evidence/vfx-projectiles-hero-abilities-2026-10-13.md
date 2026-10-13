# Projéteis (ART-029) e habilidades dos heróis (ART-030) — S-001, 2026-10-13

PLAN-053/SPEC-121, IN_PLAN, per-plan. [Spec](../specs/SPEC-121-retomada-fila-imagens/vfx-projectiles-and-hero-abilities-v01.md); [estado](../state/vfx-projectiles-and-hero-abilities.yaml). Pedido do dono: “atena, implemente os assets gerados recentes pelo chatgpt”; escolhas **Grupos A e B** e **Por plano**. Conteúdo **DRAFT**, nenhuma promoção CANON.

## S-001 — recuperação e preparo da revisão (concluída)

- **Grupo A (24 quadros):** os três projéteis foram recuperados do arquivo do Codex (`.codex/generated_images`) por **SHA-256** igual ao dos [audits](../generated/s007-reconciliation/v01/) de 2026-10-09; 24/24 encontrados e copiados byte a byte para `a-sources/`. Versões: R01 v02 e R05 v02, demais v01 (Q01 v03 é o gate aprovado e entra como v03).
- **Grupo B (60 quadros):** extraídos somente leitura do commit `10bd31c` (branch `codex/fila-imagens-continuacao-2026-10-09`, não mesclada na main) para `b-sources/`. Há três substituições v02 conforme os arquivos do commit: Durvall H102, Brook H201, Sylas H403. A versão mais nova de cada quadro é a candidata; o dono confirma no gate.
- **Auditoria técnica** ([audit.json](../generated/vfx-projectiles-hero-abilities-2026-10-13/audit.json), [prepare.gd](../generated/vfx-projectiles-hero-abilities-2026-10-13/prepare.gd)): 84/84 carregam, SHA confere, todos **1254×1254**, borda máxima de canal ≤ 4/255 (sem fundo vazando). Único alerta automático: quadros finais de dissipação mais escuros por desenho (P08, Q08, R08, H106); não é defeito.
- **Revisão do modelo (não é aceite humano):** vi as 13 pranchas. Projéteis: cauda à esquerda no voo, impactos centrados e sem cauda, quatro quadros de voo fecham o ciclo. Habilidades: motivos coerentes com as descrições do ART-PROMPTS-054. Pontos de atenção a seu critério: Korrak (chamas verticais contra o contrato de vista de cima), Sylas (alcance/cauda, H402 e H406), Kayron e Nyrelia (variação sutil entre fases), Durvall (H101 muito pequeno em relação ao pico).
- **Entregue para o dono:** [galeria](../generated/vfx-projectiles-hero-abilities-2026-10-13/review/index.html) com animação por efeito e seletor de tinta; [13 pranchas](../generated/vfx-projectiles-hero-abilities-2026-10-13/review/sheets/); [manifesto com hashes](../generated/vfx-projectiles-hero-abilities-2026-10-13/manifest.json). Os controles da galeria não foram testados no navegador do Codex (o painel abre HTML como instantâneo estático); a sintaxe do JavaScript foi validada por `node --check` e as 85 imagens referenciadas existem.

## Estado dos protegidos

Nada foi escrito em `assets/`, `core/`, `ui/`, `data/` ou `tests/`. Só `.atena/` mudou. Runtime inalterado; sem suíte nova porque não há código novo.

## Próximo (gate humano — para aqui)

**S-002 / GATE-A.** Para cada projétil (Orbe radiante, Orbe arcano, Onda cortante), diga: **aceito**, **corrigir quadro(s) X** ou **rejeitado**. Aceite parcial vale. Depois disso: S-003 (normalização, atlas, helper e roteamento; sem mudar dano/colisão/alcance) e S-004 (verificação). O GATE-B (heróis) pode ser respondido já, junto, para eu seguir direto às admissões sem nova pausa.
