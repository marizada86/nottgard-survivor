# EVID-084 — Estige universal por andar

Data: 2026-09-27  
Escopo: execução do PLAN-023 e da SPEC-054.

Status: supersedida pelo PLAN-027 e SPEC-055; preservada como registro da
universalização corrigida.

## Resultado

Os nove andares declaram `styx_gelatinous` como camada ambiental comum. A
mesma implementação compartilhada cobre Teste de Lucidez (INT/CAM),
Esquecimento ao sair, Chamado, derrota por exposição e imbuimento temporário
de raros; não há força de corrente. Cada mapa preserva sua regra principal.

## Validação automatizada

- `godot --headless --path . -s tests/run_all.gd`: `testes: 0 falha(s)`.
- `godot --headless --path . res://tools/smoke.tscn`: `smoke: ok`, com os nove
  andares em estado `running`.
- A matriz de `tests/test_battle.gd` cobre, para cada andar, entrada sem
  empurrão, raro imbuído, Esquecimento, Chamado e derrota.
- `tests/test_terrain.gd` confirma zona acessível, margem seca, ponto inicial
  fora do Estige e fluxo nulo nos nove andares.

Os avisos de certificado, log de `user://` e recursos de renderização emitidos
pelo Godot no modo headless são preexistentes/não fatais; os dois comandos
terminaram com sucesso.

## Capturas de exposição

As capturas foram feitas localmente com o herói na zona do Estige. Hashes
SHA-256:

| Andar | Evidência | SHA-256 |
| --- | --- | --- |
| Dagruve | `SPEC-054-estige-dagruve-exposicao-2026-09-27.png` | `E36E59A3FF8A69FD46C3582B334925AE1B28E6CC52D6C971C5C398B71AE4B4AC` |
| Docas | `SPEC-054-estige-docas-exposicao-2026-09-27.png` | `FDA8AB45AC5425DEF5BAD749C288A27B904898EFD42D137FE4D8B6E8405C807F` |
| Shedaklah | `SPEC-054-estige-shedaklah-exposicao-2026-09-27.png` | `C088F6D2DD7020D640F5E00A52EE2F338BA6E0BE68D00E0F992B11879DB16D64` |
| Molor | `SPEC-054-estige-molor-exposicao-2026-09-27.png` | `874CD44F50E30A2CA000BAA797B018C8B9F784D8BA9228FC8CE8AACEED44221F` |
| Durao | `SPEC-054-estige-durao-exposicao-2026-09-27.png` | `96E92C85D43FA29F4FA13180B297910E82D250C3C43ECC0C83CB0F507F256925` |
| Feng-tu | `SPEC-054-estige-feng_tu-exposicao-2026-09-27.png` | `3D95A8403C84B0B2B6B9286666890FFA3E211C66DE48DE734979A6E1CC72740D` |
| Shendilavri | `SPEC-054-estige-shendilavri-exposicao-2026-09-27.png` | `36CA8C14C4E239511310C1796FB3E3846CB019AAC689E092A9C797B0C5804667` |
| Goranthis | `SPEC-054-estige-goranthis-exposicao-2026-09-27.png` | `6F8224FB386EF33DFC8990AA5DF5EBF4AA8BFC54289F2C0D5EF85ED94580CD93` |
| Pilares | `SPEC-054-estige-pilares-exposicao-2026-09-27.png` | `A5F72FB544C80A82E02834AE3A507C414C73FB36DEE8CB9416C5F064871D1BD1` |

## Reconciliação

A seção 24 do `PLAN-001-nottgard-survivors.md` é o fato canônico vigente. Ela
substitui apenas as limitações de Estige visual/ausente das seções 21–23 e dos
registros de ativo 011–016; os atlas e sua aprovação visual permanecem
válidos. Não houve alteração de PNGs, dependências, permissões, publicação ou
serviço externo.
