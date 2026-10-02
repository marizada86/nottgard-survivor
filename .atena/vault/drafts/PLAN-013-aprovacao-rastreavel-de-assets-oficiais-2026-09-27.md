# PLAN-013 — Aprovação rastreável dos assets oficiais

Status: **rascunho — aguardando aprovação do dono** (2026-09-27).

## Objetivo

Transformar os registros atualmente marcados como `integrated` em decisões
auditáveis de asset oficial. Cada arquivo aprovado terá, no mínimo, uma versão
exata, caminho final, hash, uso em runtime, evidência visual, decisão humana e
referência de aprovação. O trabalho começa pela arte que está visível no jogo e
termina cobrindo todos os registros do manifesto de produção.

O plano não presume que `integrated`, um prompt executado ou um arquivo em
`assets/` signifiquem aprovação artística.

## Diagnóstico de partida

- `ASSET-PRODUCTION-MANIFEST-001.json` registra 267 entradas, embora declare
  expectativa de 266 PNGs. Esse desvio deve ser explicado antes de qualquer
  fechamento global.
- Diversas entradas apontam para caminhos simbólicos como `*_vNN.png`, e
  históricos de execução usam estados inconsistentes. Portanto, a seleção
  anterior não pode ser reconstituída apenas pelo campo `selected_version`.
- Os candidatos de Nyrelia agora estão preservados em
  `.atena/generated/asset-candidates/animations/heroes/nyrelia/`, mas as
  ações `attack`, `active` e `death` não são visualmente aceitáveis; seus
  arquivos finais não serão promovidos por inércia.
- `rocha_01` e `rocha_03` são monólitos/ruínas, não rochas. Só `rocha_02`
  pode concorrer como a variante oficial da família `rocha` sem uma mudança de
  classificação previamente aprovada.
- A captura mais recente é uma run de Durao, não uma evidência visual de
  Nyrelia. A aprovação de Nyrelia exigirá sua própria revisão em viewport.

## Escopo

1. Auditar todos os registros do manifesto de produção e dos manifestos de
   animação/prompt, sem substituir arquivos nesta fase.
2. Montar lotes de revisão visual com os arquivos finais reais e, quando
   houver, suas candidatas recuperáveis.
3. Registrar uma decisão explícita por asset: `approved`, `rejected`,
   `hold` ou `regenerate`.
4. Criar um lock de assets oficiais derivado, com hashes fechados e ligação à
   decisão humana; criar um recibo de admissão para cada grupo já usado pelo
   jogo.
5. Corrigir somente metadados de proveniência, registros e referências de
   seleção que sejam necessários para refletir as decisões aprovadas.

## Não objetivos

- Não gerar arte nova, chamar serviços remotos, gastar créditos ou transmitir
  referências locais.
- Não aceitar automaticamente todos os arquivos já integrados.
- Não redesenhar, substituir ou mover PNGs finais durante a auditoria e a
  seleção; um asset rejeitado continua no projeto até uma SPEC de substituição
  ser aprovada.
- Não mudar lore, gameplay, colisões, cenas, layout do Estige ou a lógica de
  renderização nesta iniciativa.
- Não publicar, fazer commit, push, merge ou compartilhar material externo.

## Fonte de verdade e regra de precedência

1. Decisão explícita do dono, por lote e por `asset_id`;
2. Registro canônico de aprovação criado a partir dessa decisão;
3. Lock derivado com hash SHA-256 e caminho oficial;
4. Arquivo final realmente presente no projeto;
5. Manifestos de produção, candidatos, prompts e históricos, usados apenas
   como evidência de origem — nunca como aceite artístico implícito.

## Plano de voo

### 1. Inventário e saneamento de evidências

1. Ler o manifesto de produção, os dois manifestos de animação e os registros
   de execução de prompts; enumerar cada `asset_id`, família, caminho final,
   versão declarada, hash registrado, prompt e estado de QA.
2. Calcular o hash do arquivo final presente e classificá-lo: `verificável`,
   `candidato ausente`, `caminho simbólico`, `hash divergente`, `final ausente`
   ou `QA bloqueado`.
3. Conferir a diferença entre 267 registros e 266 PNGs esperados, incluindo
   duplicatas e itens não-PNG. Nenhuma entrada ambígua seguirá para aprovação
   até receber uma explicação registrada.
4. Produzir um relatório somente de leitura, com um identificador estável por
   asset e sem alterar o manifesto histórico.

### 2. Lotes de curadoria humana

1. Construir pranchas de revisão em lotes de no máximo 20 assets, cada cartão
   exibindo arquivo final, candidata disponível, dimensões, alfa, hash curto,
   uso no jogo e estado de rastreabilidade.
2. Revisar primeiro o lote crítico de jogo: nove strips de Nyrelia, três
   `rocha_*`, três `pilar_abissal_*` e seus placements ativos em Durao.
3. Revisar depois os demais heróis e animações de inimigos, props por estágio,
   ícones de combate/itens, retratos, telas e backgrounds.
4. Para animações, revisar a tira, os frames individuais e uma captura em
   viewport. Para props, revisar a silhueta no cartão e em cena, inclusive a
   condição de estar fora da água do Estige.
5. Apresentar cada lote ao dono com uma lista curta de decisões possíveis:
   aprovar o arquivo final, selecionar uma candidata nominada, manter em espera
   ou abrir uma futura solicitação de regeneração. Nenhuma decisão será
   inferida a partir de metadados.

### 3. Registro de aprovação e lock

1. Após a decisão explícita do dono para um lote, criar ou atualizar o
   registro canônico de aprovação com `asset_id`, decisão, motivo, arquivo
   escolhido, SHA-256, dimensões, alfa, destino de runtime, data e referência
   da conversa.
2. Gerar um lock derivado somente com os itens `approved`, de hash fechado e
   sem caminho simbólico; itens `hold`, `rejected` e `regenerate` ficam fora
   desse lock.
3. Se uma candidata escolhida não for idêntica ao final, preparar uma admissão
   em modo de simulação, mostrando origem, destino, licença/proveniência,
   diferença de hash e bloqueios. A cópia para `assets/` só ocorrerá mediante
   confirmação explícita adicional do dono.
4. Manter os manifestos históricos imutáveis; discrepâncias serão registradas
   em recibos de reconciliação, não apagadas.

### 4. Validação por família

1. **Nyrelia:** `idle` pode ser aceito apenas como referência de identidade;
   os cinco movimentos exigem revisão em movimento; `attack`, `active` e
   `death` permanecem rejeitados até que uma nova arte seja fornecida. Não há
   promoção automática de nenhum dos nove strips.
2. **Props abissais:** `rocha_02` é a única candidata à aprovação na família
   `rocha`; `rocha_01` e `rocha_03` devem ser mantidas em espera para eventual
   reclassificação. Os três pilares podem ser avaliados como `pilar_abissal`,
   mas exigem confirmação de contato com o chão.
3. **Placements do Estige:** qualquer prop sobre célula de água corrente ou
   rasa é reprovado para aquele placement, independentemente da aprovação de
   seu PNG. A remoção/realocação será escopo de uma SPEC própria.
4. **Demais famílias:** validar identidade, dimensão, transparência, leitura
   no contexto, associação semântica e hash. A ausência de candidata não
   impede a aprovação do arquivo final, mas exige que a decisão seja marcada
   como aprovação do final atual sem proveniência de seleção recuperada.

### 5. Verificação e reconciliação

1. Validar que todo item `approved` possui arquivo existente, hash igual ao
   lock, dimensões/alpha compatíveis e uma decisão humana referenciada.
2. Validar que nenhum item não aprovado aparece no lock oficial e que nenhuma
   decisão aponta para caminho simbólico ou arquivo ausente.
3. Rodar os testes de integridade de assets e os smokes de runtime pertinentes
   aos lotes aprovados, sem alegar que esses testes substituem revisão artística.
4. Gerar evidência de cobertura: total de registros, aprovados, rejeitados,
   em espera, a regenerar, ambíguos e não auditáveis.
5. Atualizar o estado operacional da SPEC somente após comparar todos os
   critérios e revisar independentemente os links, hashes e exceções.

## Critérios de aceite

1. Todos os 267 registros receberam classificação de rastreabilidade e a
   diferença declarada de contagem foi resolvida ou registrada como exceção.
2. Cada arquivo aprovado tem um único caminho oficial, hash SHA-256, dimensões,
   informação de alfa, uso em runtime e decisão humana rastreável.
3. Nenhum status histórico `integrated`, `accepted` ou `compiled` promove um
   arquivo sem decisão explícita do dono.
4. Nyrelia não tem ações vazias promovidas; suas ações rejeitadas e seus
   movimentos pendentes ficam claramente fora do lock oficial até novo aceite.
5. `rocha_01` e `rocha_03` não são aprovadas como rochas; nenhum prop é
   aprovado para placement dentro do Estige.
6. O lock contém apenas bytes existentes e verificados; todos os bloqueios de
   proveniência, licença ou QA permanecem explícitos.
7. A suíte/smoke aplicável passa, e as capturas em viewport comprovam apenas os
   assets cuja revisão visual foi de fato concluída.

## Impactos previstos

- Novos relatórios, pranchas de revisão, recibos e lock em `.atena/generated/`
  e `.atena/evidence/`.
- Um registro canônico de decisões em `.atena/vault/canon/`, criado somente
  após a primeira aprovação explícita de lote.
- Ajustes de metadados de seleção poderão ser necessários após uma decisão;
  qualquer substituição de byte em `assets/` exigirá confirmação específica.
- Sem dependências, permissões, serviços externos ou alterações de gameplay.

## Gates de aprovação

1. **Aprovação deste plano:** autoriza a criação de uma SPEC de auditoria e de
   pranchas locais, sem alterar PNGs finais, manifestos históricos ou fatos
   canônicos.
2. **Aprovação da SPEC:** autoriza inventário, hashes, relatórios e material
   visual local; não autoriza escolher assets em nome do dono.
3. **Decisão por lote:** somente a escolha explícita do dono autoriza registrar
   itens como oficiais no vault canônico e no lock derivado.
4. **Admissão/substituição:** se a escolha usar uma candidata diferente do
   final atual, apresentar a simulação e pedir confirmação antes de qualquer
   cópia/sobrescrita.
5. **Exceções:** ausência de fonte, licença desconhecida, hash divergente, QA
   falho, necessidade de geração ou reclassificação semântica interrompem o
   lote afetado e pedem uma decisão específica.

## Recuperação

- A auditoria é aditiva: manifestos e evidências históricas não serão
  sobrescritos.
- O lock pode ser regenerado a partir do registro canônico e dos hashes.
- Arquivos selecionados para futura substituição permanecem em candidatos até
  a admissão confirmada; os finais atuais continuam recuperáveis por backup e
  pelo hash registrado.
