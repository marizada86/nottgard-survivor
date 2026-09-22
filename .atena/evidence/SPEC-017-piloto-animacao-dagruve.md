# Evidência — SPEC-017 piloto de animação de Dagruve

Data: 2026-09-22
Resultado: **aprovado tecnicamente**

## Inventário

- 21 tiras PNG RGBA em `assets/animations/`.
- 134 quadros totais.
- 5 estados de Durvall; 4 do Zumbi; 7 do Sacerdote da Mente Derretida; 5 interações.
- Manifesto: `.atena/generated/ANIMATION-PRODUCTION-MANIFEST-001.json`.
- Prompts: `.atena/generated/ART-PROMPTS-014-animacao-dagruve-piloto.md`.

## Validações executadas

1. Importação pelo Godot 4.7.2 concluída.
2. `tests/run_all.gd`: `testes: 0 falha(s)`.
3. O teste novo verifica presença, dimensões, canal alfa e os nós `AnimatedSprite2D` das cenas.
4. `tools/smoke.tscn`: Dagruve, Shedaklah, Molor, Durao, Feng Tu, Shendilavri, Goranthis e Pilares carregadas; `smoke: ok`.
5. Inspeção visual das tiras de ataque, morte, especial e portal em transparência.
6. Captura runtime: `SPEC-017-dagruve-animated.png`.

## Observações

- A cena de Dagruve não foi automaticamente povoada ou rearranjada. Os previews adicionados existem apenas para facilitar a edição manual.
- A geração por IA nem sempre entregou alfa real; as candidatas afetadas passaram por remoção determinística de fundo e reenquadramento antes da integração.
- As animações foram avaliadas também na escala real de jogo, onde mantêm silhueta e leitura.
