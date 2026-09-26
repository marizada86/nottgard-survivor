# PLAN-005 — Execução controlada dos prompts de animação

Status: **atualizado e aprovado em 2026-09-24; revisão visual passa a ocorrer por personagem.**

## Objetivo

Executar os 108 prompts de `ART-PROMPTS-016` de forma rastreável e consistente,
sem depender de memória do operador. Antes de **cada chamada** de geração, o
operador deve reler as instruções gerais de arte e registrar que essa leitura
ocorreu para aquela chamada específica.

## Ciclo de revisão por personagem

As candidatas deixam de ser apresentadas individualmente. Cada personagem é uma
unidade de revisão: as doze sequências são geradas e registradas como candidatas,
agrupadas em uma prévia comparativa e apresentadas em conjunto para seleção. O
usuário escolhe as versões corretas daquele personagem de uma só vez; somente
depois ocorrem recorte, normalização, integração e validação no Godot.

O limite técnico de quatro chamadas por lote permanece. Assim, um ciclo de
personagem contém três lotes técnicos, mas não interrompe a revisão visual entre
eles. Cada chamada continua a reler e registrar as fontes obrigatórias; nenhuma
candidata é integrada por ter sido gerada ou exibida isoladamente.

## Fontes obrigatórias e precedência

Para cada asset, a leitura ocorre nesta ordem:

1. `ART-PROMPTS-001-direcao-e-piloto.md` — direção geral, transparência,
   iluminação, câmera, referências, candidatos e gate visual;
2. `ART-PROMPTS-016-animacoes-dos-herois.md` — identidade do herói, ação,
   direção e anti-requisitos da sequência;
3. `HERO-ANIMATION-PROMPT-MANIFEST-001.json` — ID, quadros, grade-fonte e
   destinos de candidata/final;
4. `data/heroes.json`, `data/weapons.json` e `data/abilities.json` — conferência
   final de identidade, arma e habilidade;
5. vault canônico somente se houver conflito ou ambiguidade.

As regras gerais são obrigatórias, mas são aplicadas pela classe do asset. A
proibição de grade em `ART-PROMPTS-001` vale para figura estática; para uma
animação, `ART-PROMPTS-016` e o manifesto a substituem explicitamente por
grade-fonte limpa 2×2 ou 3×2. Todo outro requisito geral permanece válido.

## Registro por chamada

Nenhuma chamada é enviada sem criar ou atualizar um registro em
`.atena/generated/prompt-execution/HERO-<id>-<sequencia>.json` com:

```text
prompt_id
batch_id
estado: queued | general_read | compiled | generated | qa_failed | accepted | blocked
general_instructions: ART-PROMPTS-001 + data/hora da leitura
specific_prompt: ART-PROMPTS-016 + data/hora da leitura
manifest_checked: true/false
sources_checked: lista de arquivos e hashes/versões disponíveis
references: arquivos autorizados e papel de cada um
conflict_resolution: vazio ou exceção documentada
candidate_path, candidate_version, generation_time
qa: identidade, direção, quadros, base, alfa, câmera, luz, texto/watermark
decision e motivo objetivo
```

O estado `compiled` só é válido se os três primeiros documentos foram relidos
naquela chamada. Uma retomada após pausa retorna a `queued`; reler é obrigatório
mesmo que o lote, herói ou sequência sejam os mesmos.

## Fluxo por asset

1. Selecionar um único `prompt_id` ainda `queued` no manifesto.
2. Reler as quatro fontes obrigatórias, comparar fatos e registrar a leitura.
3. Resolver conflito: interromper se mudar lore, espécie, máscara de Nyrelia,
   asas, arma, símbolo ou função; não improvisar.
4. Montar a chamada final com o bloco geral aplicável, o bloco da sequência e
   somente as referências locais autorizadas para o lote.
5. Obter a aprovação de envio remoto do lote e gerar uma única candidata `v01`.
6. Salvar fora de `assets/`, inspecionar isoladamente e no tamanho de jogo.
7. Marcar `accepted` ou `qa_failed` com motivo objetivo. Uma nova candidata
   (`v02` ou `v03`) só corrige esse motivo; nunca é uma tentativa estética vaga.
8. Após aceite do lote, normalizar, integrar, testar no Godot e reconciliar o
   manifesto. A geração não autoriza automaticamente essa integração.

## Lotes e gates

Cada lote contém no máximo quatro chamadas independentes. A ordem reduz o risco
de espalhar uma identidade errada:

1. **Lote piloto por herói:** `idle`, `move_e`, `move_sw` e `active`. O
   `move_sw` torna a direção relatada pelo usuário um gate explícito.
2. **Movimento complementar:** `move_n`, `move_ne`, `move_se`, `move_s`.
3. **Movimento e estados restantes:** `move_w`, `move_nw`, `attack`, `death`.
4. Repetir os três lotes para Brook, Maelor, Sylas, Kayron, Korrak, Leoric,
   Nyrelia, Zynara e Bromnor, somente após o lote anterior daquele herói passar.

O `move_sw` já existente de Durvall não é parte dos 108 prompts novos. Uma
eventual regeneração dele será um lote de correção separado, com aprovação
específica e referência à evidência de regressão de movimento.

Antes de cada lote, é necessária aprovação explícita que identifique os quatro
`prompt_id`s e as referências locais que podem ser enviadas. Antes de integrar
qualquer PNG, é necessária aprovação do lote aceito ou uma autorização de
integração já registrada na spec correspondente.

## Checklist de qualidade

Para cada candidata:

- personagem, espécie, máscara, cabelo, arma e habilidade correspondem aos
  dados e ao prompt; nenhum fato novo foi introduzido;
- a direção declarada é a direção visual em tela; em especial, `move_sw` lê
  baixo e esquerda a 48–80 px;
- o número de quadros, a grade, a base dos pés, a escala, a câmera e a luz
  coincidem com o manifesto e com os frames do mesmo herói;
- há alfa verdadeiro, sem halo, cenário, sombra projetada, texto, marca-d'água,
  figuras duplicadas, armas duplicadas ou anatomia extra;
- a candidata não substitui um asset final antes de aprovação e backup local.

## Critérios de pronto

1. Os 108 registros de chamada têm leitura geral e específica registrada.
2. Cada prompt possui no máximo três candidatas e toda repetição tem motivo
   objetivo documentado.
3. Nenhuma referência local foi enviada fora de um lote autorizado.
4. Cada sequência aceita passa inspeção isolada, no tamanho de jogo e na run
   relevante antes da integração.
5. O manifesto, os registros por chamada, os assets finais e as evidências
   concordam em ID, versão, caminho e decisão.

## Plano de voo

1. Criar o modelo de registro e uma auditoria que bloqueie `generated` sem
   `general_read`, fontes e checklist completos.
2. Executar um único lote piloto de quatro chamadas, sem integração automática.
3. Inspecionar, registrar as correções objetivas e obter o gate para o próximo
   lote do mesmo herói.
4. Repetir por herói, mantendo lotes de no máximo quatro chamadas.
5. Depois dos 108 assets aceitos, solicitar aprovação separada para a
   normalização, integração no Godot e validação completa.

## Evidência da fundação

- Modelo: `PROMPT-EXECUTION-RECORD-TEMPLATE-001.json`.
- Gate executável: `tools/audit_prompt_execution.gd`.
- Teste de contrato: `tests/test_prompt_execution_contract.gd`.
- Resultado e limitações: `../../evidence/EVID-013-gate-de-execucao-de-prompts.md`.

## Execução do primeiro lote

`BATCH-brook-pilot-01` foi iniciado com os quatro IDs aprovados e as referências
locais autorizadas. `HERO-brook-idle` atingiu o limite de três candidatas sem
alfa real e está em `qa_failed`; as outras três chamadas ficaram em `compiled`
e não foram enviadas, para não replicar o defeito. Evidência:
`../../evidence/EVID-014-brook-pilot-alpha-block.md`.

Atualizacao 2026-09-24: com aprovacao explicita, a v02 foi reprocessada com
limiar 6, normalizada e integrada como
`assets/animations/heroes/brook/idle.png`. O registro `HERO-brook-idle` esta
em `accepted`; as tres chamadas restantes continuam em `compiled` e nao foram
enviadas.
