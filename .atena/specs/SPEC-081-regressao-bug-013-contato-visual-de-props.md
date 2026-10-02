# SPEC-081 — Regressão BUG-013: contato visual de props

Status: **concluída — validação visual manual aprovada** (2026-09-29).

## Intenção

Resolver a regressão de leitura visual em que props parecem flutuar em
Dagruve, Docas e Durao, confirmada por três playtesters após a reconciliação
das SPEC-041 e SPEC-042.

## Escopo

- Auditar a distância entre a base opaca e `contact_anchor` de cada textura
  usada nos três biomas.
- Capturar os três cenários QA com os guias de contato e sombra ativados.
- Corrigir apenas os metadados de `data/prop_visuals.json` e, se a evidência
  demonstrar um defeito comum, o cálculo visual em `ui/prop.gd`.
- Acrescentar testes determinísticos e evidência de regressão.

## Não objetivos

- Não mover props nas cenas, nem alterar colisões, `block_radius`, y-sort,
  seeds, ondas ou dados de combate.
- Não editar PNGs de origem e não admitir assets do Lote 2.

## Plano de voo

1. Gerar relatório numérico por asset e capturas QA de Dagruve, Docas e Durao.
2. Comparar cada falha com a regra de tolerância de dois pixels de tela.
3. Aplicar a menor correção possível aos perfis ou ao renderer visual.
4. Executar testes, smoke e a mesma auditoria; registrar a comparação antes/depois.
5. Reconciliar SPEC-062 somente se BUG-013 passar nos três cenários.

## Critérios de aceite

1. Nenhum prop catalogado nos três cenários mantém lacuna perceptível entre
   a base estrutural e o chão/sombra; tolerância máxima de dois pixels.
2. Guias QA confirmam a coincidência entre contato lógico, âncora artística e
   sombra aplicável.
3. Posição lógica, colisões e `block_radius` permanecem inalterados.
4. Suíte e smoke passam; a evidência inclui capturas antes/depois.

## Evidência prevista

- `EVID-112-bug-013-regressao-2026-09-29.md`
- capturas `EVID-112-bug-013-<bioma>-qa.png`

## Reconciliação provisória

- A auditoria inicial identificou 13 âncoras fora da tolerância, todas em
  props de Dagruve/Docas ou na variante `rocha_03` de Durao.
- As âncoras foram ajustadas ao limite opaco medido e o teste passou a cobrir
  também `shadow_mode: none`, que antes ficava fora da proteção de regressão.
- A auditoria final encontrou zero perfis fora da tolerância e a suíte
  determinística encerrou com código 0.
- A inspeção manual dos cenários QA foi aprovada pelo responsável após a
  correção de transparência e exclusão de água nos decais. BUG-013 está
  fechado; a integração de cada novo asset continua exigindo seu próprio
  gate de composição.
