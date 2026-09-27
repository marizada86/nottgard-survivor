# EVID-077 — Reprocessamento local de Nyrelia

Data: 2026-09-27  
SPEC: `SPEC-047-reprocessamento-local-dos-candidatos-de-nyrelia.md`

## Entradas e transformação

Foram usados apenas os nove PNGs `*_v01_alpha.png` existentes em
`.atena/generated/asset-candidates/animations/heroes/nyrelia/`. Cada célula
foi recortada pelo alfa visível, dimensionada proporcionalmente em 256×384 e
posicionada com margem inferior de 16 px. Os resultados ficaram somente em
`.atena/generated/nyrelia-reprocess/v01/strips/`.

## Saídas verificadas

| Strip | SHA-256 |
| --- | --- |
| idle | `ee8efd0a3418e11c56b69fb4184ea8077e35ba5221b69f72cad147d4f931d064` |
| move_n | `caa44efdabdf8b5ca7d70d15c467de8ef7780c1367ecb41b6a200c8a34d06073` |
| move_ne | `e4d777f32c53d9a864c0c24236e79d3d7c8febbbe9f3aeb5d40dd30d80860c23` |
| move_e | `b7bed5d816958f9db17ee0ef8bf939fcdcfa2635f6952ddf65c6a21293454429` |
| move_se | `5e63ee6c1fc77607ae0dc78f2663e307ea6b13e9f73213aa87317bd7dd765ec5` |
| move_s | `b0ef143d37afc0b342ab43608101bb62642543c050c28cf96c3730d8842a7f94` |
| attack | `1d80397578674644392437f51b61360b6a3e15040321dc4774783110cbf93090` |
| active | `072440874aa70549a3f43df74a0bbfb60f88723fab2adbc46ab54352f1247e5b` |
| death | `e8739a7aec82afc5251d3d187e5e7a5f2397aaa82ed346431a31d5d44bb47955` |

## QA e resultado

- A captura `.atena/evidence/SPEC-047-nyrelia-reprocess-pilot.png` foi gerada
  em 1280×720 pela prancha runtime independente.
- Em escala real, `idle` e `move_se` permanecem contornos/partículas sem
  massa corporal inequívoca; `attack` não preserva a personagem nos quatro
  frames. Falha o contrato visual de legibilidade.
- A verificação dos nove hashes oficiais contra `ASSET-OFFICIAL-LOCK-001.json`
  passou: nenhum PNG oficial foi alterado.
- A suíte `tests/run_all.gd` terminou com `testes: 0 falha(s)`.

Conclusão: os derivados são recuperáveis e tecnicamente alinhados, mas
**rejeitados para admissão artística**. Nenhum lock ou arquivo oficial mudou.
