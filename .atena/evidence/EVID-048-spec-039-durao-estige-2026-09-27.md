# EVID-048 — SPEC-039: macroterreno de Durao e Rio Estige

Data: 2026-09-27  
SPEC: `SPEC-039-macroterreno-abissal-montanhas-e-rio-estige.md`

## Resultado

- Durao usa `TerrainLayout` determinístico para planalto de basalto, cinza,
  encosta, margem, água rasa e corrente do Estige.
- O rio é uma faixa contínua e atravessável; o empurrão só é aplicado dentro
  de sua água. Pilares preserva a regra de corrente que já possuía.
- Penhascos são módulos no grupo y-sorted e suas quatro âncoras usam a mesma
  geometria lógica que bloqueia o herói.
- Estige usa uma RNG separada da batalha para os Testes de Lucidez. Falhas
  reduzem somente a Inteligência efetiva da run, com piso em 1.
- Após dois segundos na água, sair aplica Esquecimento por até seis segundos;
  há aviso aos sete segundos, Chamado aos dez e derrota aos doze.
- O Navegador QA oferece cenário para margem, corrente, penhasco, telégrafo,
  item, portal, chefe, entrada, Esquecimento, Chamado e derrota do Estige.

## Validação

- `godot --headless --path . -s tests/run_all.gd` — `testes: 0 falha(s)`.
- `godot --headless --path . res://tools/smoke.tscn` — todas as nove fases
  abriram; `smoke: ok`.
- Captura 1280×720: `SPEC-039-durao-piloto-2026-09-27.png`. A revisão mostra
  o rio, a margem, os planaltos/cinzas e os penhascos legíveis com herói,
  inimigos, UI e telégrafos preservados.

## Exceções

Os avisos de certificado do ambiente e os vazamentos já reportados ao encerrar
o smoke não foram introduzidos por esta SPEC. Não houve falha de teste ou
smoke.
