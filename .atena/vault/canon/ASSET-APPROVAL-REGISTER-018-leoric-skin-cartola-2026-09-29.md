# ASSET-APPROVAL-REGISTER-018 — Skin de Leoric: cartola e sobretudo

Data: 2026-09-29  
Decisão do dono: **“APROVADO”**

## Decisão canônica

O dono aprovou a admissão da skin de Leoric. A identidade visual oficial de
Leoric passa a incluir cartola preta com faixa marrom e sobretudo marrom, com
silhueta de gnomo adulto baixa e compacta. Esta decisão substitui, para esses
assets, a direção visual de chapéu de mago e manto verde-musgo registrada no
registro 011.

## Escopo admitido

- `assets/heroes/leoric.png` — SHA-256
  `3fab61eb0cac451d71161d64f99b48033765739701a738b1a08a141e3774b4b9`.
- `assets/portraits/leoric.png` — SHA-256
  `3f6a0dffa75f9bde211bc0b5da71e29212eec4b4c8b65cb943be171ea752b5dc`.
- Nove strips em `assets/animations/heroes/leoric/`: `idle`, `move_n`,
  `move_ne`, `move_e`, `move_se`, `move_s`, `attack`, `active` e `death`.
  Os hashes oficiais desses strips estão fixados em
  `ASSET-OFFICIAL-LOCK-013.json`.

## Salvaguardas e evidência

- O sprite, retrato e os nove strips anteriores foram preservados em
  `.atena/generated/leoric-skin-cartola/v01/previous-official/`.
- A geração bruta, candidatas e versões normalizadas continuam recuperáveis em
  `.atena/generated/leoric-skin-cartola/v01/`.
- `EVID-114` documenta o piloto; `EVID-115` registra a auditoria dos 46 frames
  da expansão; `EVID-116` documenta a admissão, reimportação e exceção.
- `ASSET-OFFICIAL-LOCK-013.json` mantém as 126 entradas cumulativas do lock e
  substitui somente os nove hashes de animação de Leoric.

## Verificação e correção de validação

- A bateria `godot --headless --path . -s tests/run_all.gd` passou com
  `testes: 0 falha(s)` após a promoção.
- O smoke inicialmente revelou que `ui/run.gd` chamava `_texture()` sem
  defini-la. Após o dono apresentar o erro, foi acrescentado o helper local com
  cache de textura; não houve mudança de gameplay. O smoke percorreu as nove
  fases com `smoke: ok`, e a suíte completa voltou a passar com zero falhas.

## Limites

Esta decisão altera a apresentação visual de Leoric e inclui somente o helper
local necessário para carregar a textura da névoa já referenciada por `run.gd`.
Não muda lore, classe, habilidades, SFX, cenas, dados, hitbox, colisão,
balanceamento ou gameplay; não publica, comita nem compartilha o projeto.
