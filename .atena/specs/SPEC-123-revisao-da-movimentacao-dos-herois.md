---
id: "SPEC-123"
title: "Revisão da movimentação dos heróis jogáveis"
status: "APROVADA por lote em 2026-10-04 (dono); B-001 concluído (EVID-153); B-002 parcial: prompts prontos (ART-PROMPTS-056), geração pendente"
created: "2026-10-04"
relations: ["[[PLAN-057-varredura-e-movimentacao-dos-herois-2026-10-04]]", "[[SPEC-112-normalizacao-base-e-bordas-dos-herois]]", "[[PLAN-053-fila-de-imagens-2026-10-02]]"]
cards: ["BUG-021", "BUG-025", "ART-033"]
---

# SPEC-123 — Revisão da movimentação dos heróis jogáveis

Origem (dono, 2026-10-04): "Zynara, ao andar pra trás, não vira de costas;
vamos revisar a movimentação deles, somente a dos personagens jogáveis."
Complemento (dono): "Zumbi e o bandido do mapa de Dagruve estão ótimos; se
baseie na movimentação deles."

## Escopo

Só os 10 heróis jogáveis (`assets/animations/heroes/*`, `ui/hero_view.gd`).
Inimigos não mudam; servem de referência.

## Leitura da referência (a confirmar com o dono)

Zumbi e Bandido (`cultista_adaga`) têm uma tira `move`, espelhada pelo movimento
horizontal (`flip_h_for_move` em `ui/enemy_view.gd`), com altura, base e silhueta
estáveis entre quadros. Hipótese: "ótimos" = fluidez e estabilidade. O requisito
do dono sobre as costas é separado e vale para os heróis.

## Achado (confirmado em EVID-153)

- `move_n` e `move_ne` de frente: Zynara, Leoric e Nyrelia (Sylas está correto).
- Sem `move_w`, `move_sw`, `move_nw` (espelhadas das de leste): Bromnor, Brook,
  Leoric, Nyrelia, Zynara.

## Critérios de aceitação

1. Tabela herói × direção (frente/costas/perfil) revisada olho a olho para os 10
   heróis, com o resultado registrado em evidência.
2. Medição de estabilidade (altura, largura, base entre quadros) dos heróis
   comparada com Zumbi e Bandido; heróis fora da faixa listados.
3. Andar para o norte e nordeste mostra as costas (ou 3/4 de costas) em todos os
   heróis que passarem pela correção.
4. Nenhuma arte nova entra sem aprovação do dono (gate visual).
5. Suíte com 0 falhas; `edge_frames` = 0; `HERO_IDLE_ART_HEIGHT` atualizada se
   a arte mudar.

## Lotes

- **B-001** Varredura sem risco: suíte, auditorias, tabela herói × direção,
  linha de base dos inimigos de referência, conferência do que está sem commit,
  backlog. Não altera arquivos do jogo nem gasta cota de imagem.
- **B-002** Decisão e correção da movimentação: por herói, regerar `move_n` e
  `move_ne` (arte, cota livre só após 2026-10-04 10:28 BRT) ou ajuste de código.
  Aprovação do dono antes de gerar ou integrar.
- **B-003** Retomada do PLAN-053 (Shu, Ezro, Molydeus).
- **B-004** Preparar o próximo playtest: BUG-025, SPEC-120 parte B, exportar
  build (commit e push só com aprovação).
