# EVID-233 — HUD: CA e CAM sem balão ao passar o mouse (2026-10-10)

**Origem:** dono, com print do balão longo sobre a HUD ("Classe de Armadura (CA) — Quanto maior, menos ataques físicos acertam o herói…"): "pode remover esse balão […] o próprio menu C já está cumprindo esse papel".
**Desvio:** DEV-030 (PLAN_DEVIATION do PLAN-071). Autorização: pedido explícito de remover; rota "fazer agora e voltar".

## Mudança
- `ui/hero_panel.gd`: os chips CA e CAM da HUD deixam de receber o texto de `CharacterSheet.defense_tip`; sem dica própria. Removidos o `_defense_key` e a recomposição do texto a cada mudança.
- A ficha C não mudou: o texto de CA/CAM segue no painel de detalhe dela (`defense_tip`, testes de `test_character_sheet` intactos).
- Não mexi nos outros balões da HUD (Moedas, Abates, Marcas do Abismo, bênçãos, atributos, selo C).
- `tests/test_hero_panel.gd`: o chip de CA e o de CAM não têm dica (dez heróis).

## Verificação
Suite 0 falhas; smoke ok; mutação (dica de volta no chip CA) → falhas no teste novo; valores restaurados.

## Pendências
- Aguarda playtest do dono. Os botões CA/CAM **dentro da ficha C** (`_ca_btn`, `_cam_btn`) ainda têm tooltip; não foram tocados porque o pedido citava a HUD. Decisão do dono se saem também.
- Não capturei o balão em execução (o tooltip nativo não aparece em captura); a verificação é por valor da propriedade.
