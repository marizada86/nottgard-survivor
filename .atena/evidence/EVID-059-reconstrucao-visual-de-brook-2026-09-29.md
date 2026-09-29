# EVID-059 — Reconstrução visual de Brook

Data: 2026-09-29.

## Entregue localmente

- A referência do dono foi preservada como
  `reference-staging/brook-canonical-2026-09-29.png`.
- `assets/portraits/brook.png` e `assets/heroes/brook.png` foram substituídos
  pela nova identidade branca, compacta e blindada de Brook.
- As nove tiras em `assets/animations/heroes/brook/` foram reconstruídas para
  `idle`, cinco direções, `attack`, `active` e `death`.
- As fontes, versões e decisão pendente estão em
  `prompt-execution/HERO-brook-rebuild-v01.json`.

## Verificação

- As tiras atendem aos contratos de 1024×384 ou 1536×384, com alfa e quadros
  legíveis.
- `godot --headless --path . -s tests/run_all.gd` concluiu com **0 falhas**.
- A auditoria regenerada registra os hashes atuais em
  `generated/asset-audit/HERO-ANIMATION-AUDIT-001.json`.
- A prancha de revisão humana está em
  `asset-review-boards/SPEC-076-brook-final-review.png`.

## Exceção tratada

O primeiro tratamento automático de fundo removeu detalhes escuros da
armadura. A inspeção alfa mostrou que as fontes já possuíam transparência
verdadeira; a entrega final foi normalizada diretamente dessas fontes, sem o
tratamento destrutivo. A prancha e a bateria de testes referem-se somente a
essa versão corrigida.

## Gate restante

A aprovação de `brook_identity_v01` já foi registrada. A prancha desta
evidência ainda requer aprovação artística final antes de criar um novo lock
canônico dos assets de Brook.
