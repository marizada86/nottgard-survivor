# PLAN-007 - Geracao controlada das animacoes de Bromnor

Status: executado e reconciliado em 2026-09-25; as nove folhas-fonte foram aprovadas, integradas e verificadas.

## Objetivo

Produzir e integrar as nove folhas-fonte que faltam para as animacoes de `bromnor`, de modo que o runtime complete as doze sequencias logicas sem redesenhar o personagem ou alterar fatos canonicos.

## Escopo

Gerar, apos aprovacao por lote, as fontes abaixo em PNG RGBA, com celulas de `256x384`:

| Lote | Prompt ID | Folha-fonte | Grade | Destino final |
|---|---|---|---|---|
| 1 | `HERO-bromnor-idle` | `idle` (4 quadros) | 2x2 | `assets/animations/heroes/bromnor/idle.png` |
| 2 | `HERO-bromnor-move_n` | `move_n` (6 quadros) | 3x2 | `assets/animations/heroes/bromnor/move_n.png` |
| 2 | `HERO-bromnor-move_ne` | `move_ne` (6 quadros) | 3x2 | `assets/animations/heroes/bromnor/move_ne.png` |
| 2 | `HERO-bromnor-move_e` | `move_e` (6 quadros) | 3x2 | `assets/animations/heroes/bromnor/move_e.png` |
| 2 | `HERO-bromnor-move_se` | `move_se` (6 quadros) | 3x2 | `assets/animations/heroes/bromnor/move_se.png` |
| 2 | `HERO-bromnor-move_s` | `move_s` (6 quadros) | 3x2 | `assets/animations/heroes/bromnor/move_s.png` |
| 3 | `HERO-bromnor-attack` | `attack` (4 quadros) | 2x2 | `assets/animations/heroes/bromnor/attack.png` |
| 3 | `HERO-bromnor-active` | `active` (6 quadros) | 3x2 | `assets/animations/heroes/bromnor/active.png` |
| 3 | `HERO-bromnor-death` | `death` (6 quadros) | 3x2 | `assets/animations/heroes/bromnor/death.png` |

O runtime deve derivar `move_nw`, `move_w` e `move_sw` ao espelhar, respectivamente, `move_ne`, `move_e` e `move_se`. Nao gerar essas tres folhas inversas.

## Fora de escopo

- Alterar o canon, atributos, arma, habilidade ou lore de Bromnor.
- Substituir o retrato ou o sprite estatico ja integrados.
- Gerar os tres movimentos espelhados, novas variantes de personagem, VFX isolados ou qualquer asset de outro heroi.
- Publicar, fazer commit ou enviar arquivos a servicos externos sem aprovacao explicita.

## Identidade e referencias

Usar somente apos aprovacao de transferencia remota:

1. `.atena/evidence/reference-staging/bromnor.png` como referencia de barba, armadura e proporcoes gerais;
2. `assets/portraits/bromnor.png` como ancora de rosto, paleta e Martelo da Gloria;
3. `assets/heroes/bromnor.png` como ancora de silhueta, escala e acabamento de sprite.

A referencia de staging tem orelhas pontudas. Esta e uma contradicao visual, nao uma caracteristica a preservar: cada prompt de execucao deve afirmar que Bromnor e um anao idoso, com orelhas curtas e arredondadas, nunca elficas ou pontudas. Manter cabelo e barba brancos longos, armadura de bronze e aco, couro e tecido azul profundo, e o Martelo da Gloria com luz dourada/prateada contida. Ele deve parecer vivo, corporeo e um lider justo; nao fantasma, cajado, halo estourado, anatomia extra ou arma duplicada.

## Criterios de aceite

- Cada fonte tem alfa real, fundo transparente, corpo inteiro e base dos pes consistente entre todas as celulas.
- Pixel art detalhada e sobria, camera tres-quartos isometrica e luz superior esquerda; sem cenario, piso, sombra projetada, borda, grade, texto, watermark ou motion blur.
- O personagem e inequivocamente o mesmo Bromnor a 48--80 px, inclusive a anatomia ana corrigida, a silhueta larga e o martelo (nunca cajado).
- `idle` e `attack` contem quatro quadros em grade 2x2; os demais sete assets contem seis quadros em grade 3x2, sem invasao entre celulas.
- As cinco direcoes fonte se leem na tela, e os espelhamentos produzem corretamente `move_nw`, `move_w` e `move_sw`.
- `attack` mostra arco forte de martelo com luz curta; `active` mostra Concordia como guarda firme e nova radial baixa, sem cobrir a silhueta; `death` cai de lado sem gore e apaga a luz sem tornar o martelo etereo.

## Plano de voo

1. Confirmar o manifesto, `ART-PROMPTS-001`, `ART-PROMPTS-016`, os dados de heroi/arma/habilidade e as tres referencias; criar um registro de execucao por fonte a partir de `PROMPT-EXECUTION-RECORD-TEMPLATE-001.json`.
2. Submeter o lote 1 (`idle`) com a clausula de anatomia ana e reter no maximo tres candidatas. Inspecionar identidade, silhueta, grade, alfa e linha de base; obter aprovacao humana da candidata escolhida.
3. Somente se o lote 1 for aceito, executar o lote 2 com as cinco direcoes fonte. Conferir a direcao visual de cada caminhada e os tres espelhamentos do runtime antes de avancar.
4. Somente se o lote 2 for aceito, executar o lote 3 (`attack`, `active`, `death`), aplicando os anti-requisitos de efeitos e arma em cada chamada.
5. Guardar candidatas aprovadas em `.atena/generated/asset-candidates/animations/heroes/bromnor/` e integrar somente as selecionadas nos destinos finais. Nao sobrescrever arquivos existentes sem uma decisao registrada.
6. Validar dimensoes, RGBA, grades, contagem de quadros, linha de base, identidade, direcoes e espelhamentos; rodar os gates de manifesto, execucao de prompts e assets de animacao.
7. Registrar decisoes, caminhos, versoes e QA em `.atena/generated/prompt-execution/HERO-bromnor-<sequencia>.json`; atualizar a cobertura de Bromnor no manifesto e acrescentar evidencia de validacao.

## Gates

1. Aprovacao explicita deste plano e da transferencia das tres referencias locais antes de qualquer chamada de geracao.
2. Aprovacao humana da candidata de `idle` antes do lote de movimento.
3. Aprovacao humana do lote de movimento antes do lote de acoes.
4. Aprovacao humana das candidatas finais antes de processamento e integracao.
5. Pausar se houver persistencia de orelhas pontudas, perda de martelo, inconsistencia de identidade, falha de alfa/grade/direcao ou conflito com o canon.

## Evidencia planejada

- Nove registros de execucao, um para cada folha-fonte.
- Caminhos de candidata, decisao e checklist de QA por lote.
- Resultado dos testes e do auditor de prompts apos a integracao.
- Atualizacao reconciliada do manifesto, sem declarar concluido um movimento derivado como se fosse uma nova geracao.

## Resultado da execucao

Os tres lotes foram aprovados pelo usuario. `idle`, as cinco fontes de
movimento, `attack`, `active` e `death` foram normalizados para as tiras de
runtime, importados e registrados no manifesto. A evidencia parcial do
movimento esta em `EVID-034-bromnor-idle-e-movimentos.md`; o fechamento do
lote de acoes e da cobertura total esta em
`EVID-035-acoes-e-cobertura-total-de-bromnor.md`.

## Referencias

- `SPEC-021-prompts-de-animacao-dos-herois.md`
- `ART-PROMPTS-001-direcao-e-piloto.md`
- `ART-PROMPTS-016-animacoes-dos-herois.md`
- `HERO-ANIMATION-PROMPT-MANIFEST-001.json`
- `PROMPT-EXECUTION-RECORD-TEMPLATE-001.json`
