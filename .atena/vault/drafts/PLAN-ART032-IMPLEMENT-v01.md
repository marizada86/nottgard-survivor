---
id: PLAN-ART032-IMPLEMENT
revision: v01
card: ART-032
status: COMPLETED_TECHNICAL_DRAFT
content_state: DRAFT_AUTHORIZED_RUNTIME_USE
approval_mode: per-plan
---

# Implementação das dezessete fontes ART-032

O dono respondeu **“pode implementar”** à pergunta que identificava as dezessete peças ART-032 e oferecia implementá-las agora. Escopo de preparação/admissão/integração local confirmado; não gerar outra imagem. Modalidade per-plan preservada. Classificação PLAN_CHANGE_REQUEST, novo plano lateral aprovado sobre o [préflight](../../generated/art032-implementation-preflight-2026-10-12/preflight.md), sem substituir planos fechados ou a cadeia PLAN-071/revisão de heróis. O contrato precede a implementação. Não há nova promoção de intenção/aparência a CANON; uso runtime DRAFT expressamente autorizado.

## Contrato

Entradas: NP01 v02; NP02/NP03/PT01 v01; NP04/NP06 v02; NP05/NP07/NP08/NP09 v01; PT02/PT03/PT04/PT06/PT07 v02; PT05 v01; MJ01 v03. Quatro recibos/hashes e vinte e sete originais preservados. Destinos exatos no [manifesto de préflight](../../generated/art032-implementation-preflight-2026-10-12/manifest.json): dezesseis `assets/interactions/*.png` e `assets/enemies/manifestacao_de_juiblex.png`. Guardar backup byte a byte do provisório do chefe e dos três arquivos de código/dados antes de substituir.

Derivados determinísticos em Godot 4.7.2, runtime já disponível: converter RGBA8, descartar somente alfa <=8/255 no derivado para evitar bordas residuais; recortar bbox visível, preservar proporção, reduzir com Lanczos, limpar resíduos <=8/255 pós-interpolação, adicionar quatro pixels transparentes por lado. Altura visível do derivado: 240px NPCs/props/chefe, 96px estrela e três coletáveis. Canvas variável conforme proporção, não esticar silhuetas. PNGs de fonte jamais editados. Render dos eventos usa bbox visível para altura/base corretas; coletáveis/estrela 48px, NPCs/props 80px. Aliados de Graz'zt/João/Irmãs 80px, corpos sem tinta verde extra; demais sprites legados preservam 64px/tinta atual. Juiblex continua renderer estático e parâmetros existentes (H_BASE/scale), sem novas animações.

Conectar por campos de arte nos dados: trono/arco/alvo massa; itens esporo/limo/coração inclusive drop do elite; estrela; desertores/vítimas; pactos Reaper/Vhaerith/mercador/Graz'zt; João aliado; Nyxara/Vaelis como duas artes em recompensa de dois aliados; Graz'zt como aliado. Regras/contagens/horários/custos/recompensas e consumo de RNG preservados. Rótulos, anéis, barras de vida e setas permanecem. Fallbacks sem PNG funcionam; nenhum losango de evento sem fonte é convertido numa figura errada.

## Prontidão visual

Referências de identidade/contexto/bíblia: quatro planos DRAFT de produção aceitos (PLAN-ART032-NPCS-PILOTO, NPCS-LOTE02, PONTOS e JUIBLEX), PLAN-001 CANON para estilo/câmera; lore e Nottcard somente leitura, sem novas inferências. Dezessete revisões identificadas e aceitas por humanos, estilos/materiais/câmera e leitura já auditados. Identidade de personagens e da criatura aplicável; identidade pessoal N/A nos objetos, com afiliação/contexto preservados. Cena runtime: eventos SPEC-118 nos seis biomas envolvidos; captura local avalia integração/contraste, não diversão. Revisões e autoridade serão registradas no novo manifesto.

BLOCKING: nenhuma após a confirmação de implementação. RESOLVABLE: contorno/escala/base/labels dos derivados e contraste nas capturas; ajustar parâmetros técnicos mantendo a arte. DEFERRED: aparência/lore CANON, animações, templo-alvo/jaula/canoa, outros assets FILA-028/VFX/heróis, aceites de aparelho e playtest. Não declarar cobertura de pontos sem fonte entre as dezessete. Atena prepara, implementa e integra; não há necessidade demonstrada de agente delegado.

## Plano e aceitação

| Posição | Passo | Saída, checks e autorização |
|---:|---|---|
| 1/6 | S-001 contrato/prontidão | Escopo/mode/aceite persistidos, entradas/hashes/refs/contexto e backups. Concluído após verificação; implementação confirmada. |
| 2/6 | S-002 derivados | Dezessete PNGs preparados no pacote, hashes/margens/alfa/proporção, originais iguais. Godot determinístico; autorizado. |
| 3/6 | S-003 admissão/ligação | Copiar somente destinos do manifesto, metadados e propagação de arte em Happenings/Overlay, helper de bbox; imports e fallback. Autorizado. |
| 4/6 | S-004 testes | Eventos preservam mecânicas/RNG; itens/drop, escolta, pactos/resgate, duas Irmãs/Graz'zt, estrela e chefe; PNGs/anchors/refs e suíte existente sem falhas. |
| 5/6 | S-005 captura/QA | Capturas controladas dos seis biomas cobrindo as dezessete peças, galeria e auditoria; fontes/imports/labels legíveis, sem alegar playtest. |
| 6/6 | S-006 fechamento | Evidência, plano/estado/backlog e registro operacional de admissão DRAFT. Zero checks técnicos pendentes; roteiro de playtest e feedback humano pendente registrados. |

Recuperação: snapshots locais de todos os caminhos substituídos, hash dos originais/recibos/outros ativos/cauda `active_plan:`; sem reset/checkout/limpeza de outras alterações. Alterações permitidas somente arquivos de destino, core/happenings.gd, ui/overlay.gd, ui/happening_art.gd, data/stage_events.json, testes focados, pacote/docs/estado/backlog. Não mudar estatísticas, dependências, arquitetura material ou políticas; nenhuma publicação, build/exportação, commit ou push autorizados.

S-001–S-006 concluídos, 6/6; zero passos técnicos restantes. Dezessete derivados admitidos e conectados, suíte final zero falhas, sete capturas revisadas em seis biomas. [Resultados/evidência](../../evidence/art032-implementation-2026-10-12.md) e [verificação final](../../generated/art032-implementation-2026-10-12/delivery-verification.json). Pendência não bloqueante: playtest humano; duas ausências anteriores de idle dos heróis registradas, sem nova falha ART-032. Próximo objetivo: executar o roteiro local e recolher feedback humano quando solicitado, sem novo commit/push/exportação autorizado. Conteúdo continua DRAFT com uso runtime autorizado.
