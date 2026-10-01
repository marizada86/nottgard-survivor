---
id: "SPEC-107"
title: "Piloto visual de animação para guardiao_copia"
status: "piloto executado e aprovado em 2026-09-30; ciclo completo aguarda autorização separada"
created: "2026-09-30"
relations:
  - "[[PLAN-048-geracao-animacoes-mobs-onda-1-2026-09-30]]"
  - "[[EVID-134-lote-c-mobs-2026-09-30]]"
  - "[[ART-PROMPTS-036-piloto-visual-guardiao-copia]]"
  - "[[EVID-135-piloto-guardiao-copia-2026-09-30]]"
---

# SPEC-107 — Piloto visual de animação para `guardiao_copia`

## Intenção

Testar se as poses aprovadas de `guardiao_verdadeiro` podem ser reinterpretadas
como quadros de `guardiao_copia` sem perder a identidade própria da cópia.
Esta SPEC concretiza a recomendação aprovada pelo dono: reaproveitar poses, não
os PNGs finalizados do verdadeiro. O piloto não aprova automaticamente o ciclo
completo nem a admissão de qualquer imagem no jogo.

## Escopo

- Produzir exatamente três quadros candidatos independentes para
  `guardiao_copia`: `idle_00`, o ápice `attack_02` e a pose final `death_05`.
- Usar a arte estática de `guardiao_copia` como referência de identidade e os
  quadros aprovados correspondentes de `guardiao_verdadeiro` apenas como
  referência de pose, enquadramento e ação.
- Preservar a aparência cinza/dourada da cópia, armadura e insígnias próprias,
  asas cinza-escuras e sua lança curta inclinada. Não transferir runas ou brilho
  violeta, veios violetas nas penas, nem a lança cristalina longa do verdadeiro.
- Destinar os resultados a
  `.atena/generated/art-candidates/enemies-wave-1/guardiao_copia/pilot/`.
- Usar célula final 320×480, PNG RGBA transparente, figura inteira, vista
  frontal 3/4 voltada à direita, contorno pixelado nítido e ancoragem inferior
  compatível com as células aprovadas do verdadeiro.

## Não objetivos

- Gerar o ciclo completo de 26 quadros ou criar poses novas além das três
  referências selecionadas.
- Reutilizar literalmente os PNGs do verdadeiro, mudar a arte estática oficial,
  substituir qualquer asset em `assets/` ou editar runtime, cenas, dados,
  gameplay ou balanceamento.
- Integrar, empacotar como asset canônico, versionar/stagear, publicar ou
  compartilhar os candidatos.
- Instalar dependências ou usar provedor pago externo.

## Referências locais e autorização

O método proposto usa a ferramenta ImageGen com estes quatro PNGs locais: a
estática `assets/enemies/guardiao_copia.png` e os candidatos aprovados
`guardiao_verdadeiro_idle_00_v01.png`,
`guardiao_verdadeiro_attack_02_v01.png` e
`guardiao_verdadeiro_death_05_v02.png` sob
`.atena/generated/art-candidates/enemies-wave-1/guardiao_verdadeiro/frames/`.
Em cada chamada, a estática da cópia será identidade e somente o quadro
correspondente do verdadeiro será referência de pose. Esses PNGs serão enviados
ao serviço ImageGen apenas para este piloto; não usar outras referências locais.

O dono aprovou esta SPEC e autorizou em 2026-09-30 a transferência dos quatro
PNGs nomeados para o ImageGen, somente para este piloto. Nenhuma outra referência
local foi enviada.

## Critérios de aceite

1. Existem exatamente três arquivos finais novos, nomeados
   `guardiao_copia_idle_00_pilot_v01.png`,
   `guardiao_copia_attack_02_pilot_v01.png` e
   `guardiao_copia_death_05_pilot_v01.png`; fontes nunca são sobrescritas.
2. Cada final mede 320×480, tem canal alfa real, cantos transparentes, silhueta
   conectada com solidez mínima de 0,90 e margem lateral mínima de 8 px quando
   a pose permitir, sem cortar asas, corpo ou lança.
3. Os três quadros preservam a leitura de armadura cinza/prata e ouro, asas
   cinza-escuras e lança curta inclinada da cópia; não exibem o brilho/runa
   violeta nem a lança cristalina longa do verdadeiro.
4. `idle_00` é neutro, `attack_02` comunica investida com a arma da cópia e
   `death_05` é uma pose final compacta e inequivocamente caída. A escala e a
   base permanecem visualmente compatíveis entre os quadros e com a referência.
5. Evidência compara cada candidato à estática da cópia e à pose de origem em
   escala nativa e ampliada; QA lista dimensões, alfa, solidez, margens e IDs.
6. As três imagens seguem isoladas como candidatas e fora do runtime. A
   aprovação visual do piloto não autoriza gerar as outras 23 poses; o ciclo
   completo requer autorização separada.
7. Nenhum asset oficial ou arquivo de runtime muda; a conferência de diff
   confirma esse limite.

## Impactos

Escritas autorizadas por esta SPEC aprovada: apenas três PNGs novos no diretório
de piloto isolado, uma prancha local, o registro ART-PROMPTS-036, a atualização
do manifesto de candidatos e a evidência sob `.atena/evidence/`. As quatro
referências permanecem somente leitura. Não se altera a regra atual do
`.gitignore`; candidatas continuam locais e sem staging.

## Plano de voo

1. Após aprovação, conferir que as quatro referências existem e que o destino
   de saída está livre; se houver colisão, pausar e propor nomes novos.
2. Enviar ao ImageGen somente as referências autorizadas, seguindo os prompts
   exatos de ART-PROMPTS-036, e guardar cada resultado em um caminho novo.
3. Inspecionar bytes e alpha. Se necessário, derivar a célula 320×480 por
   nearest-neighbor, preservando alpha, sem modificar fontes nem sobrescrever
   resultados brutos; registrar origem e destino exatos na evidência.
4. Auditar os três arquivos contra os critérios, gerar prancha lado a lado com
   os quadros de origem e a estática da cópia, e fazer revisão visual humana.
5. Registrar aprovado, regenerar com motivo ou rejeitado para cada ID; atualizar
   o manifesto e reconciliar ART-021, PLAN-048 e a evidência.
6. Parar após o piloto e pedir uma decisão separada antes de expandir o conjunto
   para 26 quadros ou propor qualquer admissão no runtime.

## Riscos e controles

| Risco | Controle |
|---|---|
| O modelo copia a identidade violeta do verdadeiro | Separar explicitamente referência de identidade da referência de pose; rejeitar sinais violeta e arma incorreta. |
| A lança curta não se adapta à pose de ataque | Avaliar o ápice antes de expandir; se não ficar legível, revisar a pose na SPEC posterior em vez de trocar a identidade da arma. |
| Três amostras não provam consistência de um ciclo inteiro | Tratar o piloto como teste de viabilidade apenas; exigir nova decisão para 26 quadros. |
| Referências locais saem do ambiente do projeto | Transferir somente os quatro PNGs nomeados, e somente após autorização explícita. |
| Saídas colidem com trabalho existente | Confirmar destino livre antes de gerar; nunca sobrescrever fontes ou candidatos alheios. |

## Execução — 2026-09-30

A transferência autorizada e a geração foram concluídas. Os três quadros foram
reduzidos a 320×480, auditados e organizados no diretório isolado do piloto.
QA, hashes, originais do ImageGen e prancha estão em
[[EVID-135-piloto-guardiao-copia-2026-09-30]]. Em 2026-09-30, o dono aprovou
os três quadros do piloto. Não gerar os 23 quadros restantes nem integrar ao
jogo sem as decisões separadas previstas nesta SPEC.
