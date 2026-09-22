# Evidência — SPEC-018 direções de movimento de Durvall

Data: 2026-09-22
Resultado: **aprovado tecnicamente**

## Entregas

- Oito tiras RGBA: `move_n`, `move_ne`, `move_e`, `move_se`, `move_s`, `move_sw`, `move_w` e `move_nw`.
- Seis quadros por direção, em `1536×384`, células normalizadas de `256×384`.
- Referências de origem e caminhos finais registrados em `.atena/generated/ANIMATION-PRODUCTION-MANIFEST-002.json`.
- Captura local de runtime: `SPEC-018-durvall-directions.png`.

## Verificações

1. Inspeção visual de norte, leste, sul e oeste depois do recorte e reenquadramento.
2. `tests/run_all.gd`: `testes: 0 falha(s)`; cobre existência, dimensão, alfa e os oito vetores de seleção.
3. `tools/smoke.tscn`: todas as oito fases carregadas; `smoke: ok`.

## Nota de produção

As folhas que vieram com fundo em gradiente foram reprocessadas com limiar conservador para não remover detalhes escuros da armadura. As variantes descartadas continuam apenas como candidatas locais, fora do versionamento.
