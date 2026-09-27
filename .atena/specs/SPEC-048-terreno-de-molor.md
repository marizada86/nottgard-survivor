# SPEC-048 — Terreno de Molor

Status: **implementada e verificada** (2026-09-27).

## Intenção

Dar a Molor uma identidade própria de caverna fétida de Juiblex: rocha,
detrito e lixo mineralizado como arena navegável; ooze em bolsões e depressões;
fungo reduzido a vestígio. A fase deve se distinguir de Shedaklah sem absorver
o Estige ou a composição de Durao.

## Fontes e precedência

1. `vault/canon/PLAN-001-nottgard-survivors.md`, seções 5, 7 e 21;
2. `vault/research/RESEARCH-001-abismo-bestiario-visual-2026-09-21.md`;
3. `data/stages.json`, estágio `molor`;
4. `SPEC-039-macroterreno-abissal-montanhas-e-rio-estige.md`;
5. `PLAN-017-terreno-de-molor-2026-09-27.md`.

## Escopo proposto

- Macroformas determinísticas de rocha, detrito, ooze e borda orgânica.
- Props de bolha preservados nas bordas e ilhas, sem colisão baseada na arte.
- Candidata de atlas opaco 128×64, quatro variantes 64×32, produzida e
  inspecionada antes de qualquer integração.
- Testes de determinismo, leitura e ausência das regras de Durao; captura de
  runtime em 1280×720.

## Não objetivos

- Alterar lore, inimigos, chefe Blogbog, duração, ondas, recompensas ou regra
  ambiental `puddles` já declarada.
- Decidir ou implementar Estige em Molor. A referência atual não confirma sua
  passagem pela camada; qualquer braço, água corrente, Teste de Lucidez ou
  Chamado exige decisão canônica específica. Os riscos de Durao seguem fora
  deste escopo.

## Critérios de aceite propostos

1. Molor é lido como caverna de detrito e slime, não como pântano de fungo.
2. Ooze ácido permanece localizado e os telegráfos, heróis, inimigos, itens e
   portal continuam legíveis.
3. A mesma seed reproduz o mesmo terreno sem consumir RNG de batalha.
4. Nenhuma mecânica de Durao é ativada na fase.
5. A candidata só chega a `assets/` após aprovação humana explícita; suíte,
   fumaça e captura passam antes da reconciliação.

## Plano de voo proposto

1. Aprovar esta direção e o plano delimitado.
2. Implementar o layout procedural e os testes com placeholders reversíveis.
3. Gerar e revisar a candidata de atlas.
4. Após aprovação, integrar o atlas, validar runtime e registrar evidência.

## Resultado parcial e reconciliação (2026-09-27)

- `TerrainLayout` agora compõe Molor por rocha de caverna, detrito, bolsões
  estáveis de ooze e parede orgânica periférica. O centro não é todo ooze e
  nenhuma consulta hídrica de Durao é ativada.
- `ui/stages/molor.tscn` usa o layout regional com seed visual 528. A captura
  de runtime confirma a arena ampla e os props de bolha preservados.
- O dono aprovou a candidata em 2026-09-27. O atlas derivado foi versionado
  como `assets/tiles/molor_ground_atlas_v1.png` e integrado somente aos
  materiais de rocha, detrito e ooze; paredes orgânicas continuam procedurais.
- A suíte (`testes: 0 falha(s)`), a fumaça (`smoke: ok`) e a captura final
  1280×720 passaram com o atlas ativo. A evidência está em
  `EVID-079-spec-048-molor-2026-09-27.md`; a aprovação canônica está no
  `ASSET-APPROVAL-REGISTER-012-terreno-de-molor-2026-09-27.md`.
