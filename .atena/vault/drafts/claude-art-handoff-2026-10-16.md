---
id: CLAUDE-ART-HANDOFF-2026-10-16
revision: v01
content_state: DRAFT
origin: guided
implementation_preceded_spec: false
classification: PLAN_DEVIATION
approval_mode: per-plan
status: LOCAL_DELIVERED_PUSH_BLOCKED_APPROVAL_REQUIRED
---

# Entrega das artes pendentes ao Claude

Pedido: reunir em `.atena/generated/art-candidates` todas as artes existentes que ainda precisam de implementação, com commit e push se necessários para disponibilizá-las ao Claude.

Plano de origem preservado: PLAN-103, B-002/S-008_AWAITING_RETURN, per-batch; o estado nativo registra também B-004/R3_PROPOSAL_AWAITING_G-M3-3. Rota aprovada: fazer esta entrega agora e retornar aos checkpoints preservados. Dono respondeu `1` em 2026-10-16 à proposta de execução por plano.

## Escopo proposto

- Auditar backlog, fontes geradas, recibos de aceite/admissão e referências reais de `assets/`, `data/` e código. Os registros históricos divergem em alguns pontos; o inventário precisa reconciliar evidências antes de declarar uma arte pendente.
- Copiar, preservando originais, apenas as revisões selecionadas que precisam de implementação. Preservar arquivos já existentes no destino; candidatas rejeitadas, substituídas ou sem aceite ficam identificadas como retidas, sem recomendação de admissão automática.
- Entregar README para Claude e manifesto com origem, destino, hash SHA-256, revisão, DRAFT/CANON conforme recibo, aceite, estado de integração, especificação, dependências e verificações necessárias por item. Listar à parte arte ainda não gerada ou ausente, sem inventar arquivos nem gerar novas imagens.
- Não confundir arte já integrada e aguardando playtest humano com arte pendente de implementação. Não promover conteúdo a CANON nesta entrega.
- Verificar arquivos e links, hashes e tamanho do pacote. Registrar evidência e retornar ao PLAN-103.
- Se necessário para acesso pelo Claude, commitar somente o pacote e seus registros e publicar em branch `codex/claude-art-handoff-2026-10-16`, derivada do HEAD local. Não avançar main nem mesclar. A autorização condicional de commit/push consta do pedido atual; o escopo e a rota ainda aguardam aprovação.

## Etapas e lotes estáveis

| Lote | Etapa | Objetivo / saída | Verificação |
|---|---|---|---|
| B-001 | S-001 | Inventário de arte pendente e retida, fontes e gates | Confrontar recibos com uso atual; registrar ausências |
| B-002 | S-002 | Cópias no destino, manifesto e instruções para Claude | Existência, hashes, links, revisões, preservação dos originais |
| B-003 | S-003 | Evidência, commit/push se necessários e retorno | Backlog, diff restrito, tamanho e identidade Git, SHA remoto quando publicado |

Nenhum especialista produzirá ou adaptará arte neste escopo. O Claude receberá instruções no pacote; esta entrega não envia mensagens nem inicia uma sessão externa. A implementação futura respeita os gates de cada arte, inclusive aceite visual e playtest humano.

## Pendências

- BLOCKING da entrega: nenhuma após aprovação por plano do dono. Gates de runtime permanecem documentados por peça.
- RESOLVABLE: destino ignorado pelo Git; incluir explicitamente apenas arquivos do pacote caso seja necessário publicar. A regra local de não versionar brutos terá exceção limitada ao material necessário à entrega autorizada.
- RESOLVABLE: checkout está em detached HEAD (`806a7429`); criar branch própria antes de commit/push, dentro do escopo aprovado.
- RESOLVABLE: arte já implementada, candidatas e pendências de geração devem ser distinguidas pela auditoria.
- DEFERRED: aceitação subjetiva e playtests existentes, implementação pelo Claude, novas gerações e promoção canônica.

RTK: decisão já registrada como enabled em `.atena/add.yaml`; nenhuma instalação/configuração proposta.
Backlog em 2026-10-16: 0 P0, 4 P1 abertos (BUG-025/027/028/029), 18 P1 implementados aguardando playtest; 0 alertas de organização.

Recuperação: originais preservados; pacote aditivo, sem alterações de runtime. Qualquer publicação deverá limitar-se à branch da entrega.
