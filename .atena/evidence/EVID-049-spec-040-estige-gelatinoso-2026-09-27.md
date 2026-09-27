# EVID-049 — SPEC-040: Estige gelatinoso e Imbuído por Juiblex

Data: 2026-09-27  
SPEC: `SPEC-040-estige-gelatinoso-e-elites-de-juiblex.md`

## Resultado

- Durao usa a regra `styx_gelatinous`; não há vetor de corrente para herói,
  inimigos, itens ou projéteis.
- A água permanece atravessável e conserva Teste de Lucidez, Esquecimento,
  aviso aos sete segundos, Chamado aos dez e derrota aos doze.
- Elites/raros não-chefes dentro da água ganham **Imbuído por Juiblex**:
  +20% de dano e 15% de redução de dano. O estado é removido ao sair ou morrer.
- Chefes e inimigos comuns não recebem o buff.
- O desenho da água não tem animação direcional: usa bolhas e almas estáticas
  para comunicar gelatina espessa e parada.

## Validação

- `godot --headless --path . -s tests/run_all.gd` — `testes: 0 falha(s)`.
- `godot --headless --path . res://tools/smoke.tscn` — `smoke: ok` nas nove
  fases, incluindo Durao.
- Captura 1280×720: `SPEC-040-durao-estige-gelatinoso-2026-09-27.png`.
  A revisão visual confirma água imóvel e legibilidade de herói, inimigos,
  terreno e interface.

## Exceções

Os avisos de certificado e os vazamentos no encerramento do smoke pertencem
ao ambiente já existente; não houve falhas de teste ou de carregamento.
