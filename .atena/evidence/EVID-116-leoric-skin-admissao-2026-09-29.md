# EVID-116 — Admissão da skin de Leoric

Data: 2026-09-29  
SPEC: `SPEC-082-skin-leoric-cartola-e-sobretudo`  
Estado: **admitida localmente; sem commit, publicação ou envio remoto**.

## Decisão e promoção

O dono aprovou explicitamente a admissão do lote. Foram promovidos o sprite de
seleção, retrato e os nove strips normalizados de
`.atena/generated/leoric-skin-cartola/v01/` para os paths oficiais de Leoric.
Os onze PNGs anteriores foram preservados em
`.atena/generated/leoric-skin-cartola/v01/previous-official/`.

Durante a preparação do backup, o curinga de animações não expandiu. Nenhum
backup ou arquivo oficial foi apagado: os nove strips anteriores foram
recuperados do lote oficial regenerado de Leoric, cujos tamanhos coincidem com
os assets que estavam nos paths oficiais antes da promoção. O backup final
contém os onze arquivos esperados.

## Verificação

- Reimportação: o Godot carregou as novas texturas durante a execução headless.
- Auditoria das candidatas: 50 frames, RGBA, dimensões contratadas, base y=367
  e margens laterais mínimas de 8 px; EVID-114 e EVID-115 trazem o detalhe.
- `godot --headless --path . -s tests/run_all.gd`: **`testes: 0 falha(s)`**.
- Lock cumulativo: `ASSET-OFFICIAL-LOCK-013.json`, com 126 entradas e os nove
  hashes de animação de Leoric atualizados.

## Correção e smoke/runtime

O primeiro smoke revelou que `ui/run.gd:111` referenciava `_texture()` sem um
helper local. Após o dono apresentar esse erro, foi incluído em `ui/run.gd` um
cache local de `Texture2D`, sem mudança de gameplay. A validação posterior
concluiu: `smoke: ok` nas nove fases e `testes: 0 falha(s)` na suíte completa.
