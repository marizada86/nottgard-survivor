---
id: EVID-169
created: 2026-10-06
plan: PLAN-066
spec: SPEC-133
batch: B-001
status: COMPLETE_LOCAL_DIAGNOSIS
implementation_changed: false
---

# Diagnóstico da corrida de Durvall — B-001

O dono respondeu “aprovado” à proposta de iniciar o diagnóstico no modo por lote. Classificação: IN_PLAN. S-001 e S-002 foram executados localmente. B-002, geração de imagem, transferência de referências e admissão de arte continuam pendentes.

## Entregas

- [Comparação animada e quadros da baseline](../generated/durvall-run-refinement/v01/baseline.html): direção selecionável, chão em movimento, pausa e inspeção por quadro; escala real e ampliação 3×.
- [Captura do componente visual oficial em Godot](../generated/durvall-run-refinement/v01/runtime-baseline.png): oito direções efetivamente exibidas, seis quadros congelados por direção, escala real e ampliação 1,5×.
- [Medições e seleções reais do componente visual](../generated/durvall-run-refinement/v01/runtime-report.json).
- [Hashes da baseline](../generated/durvall-run-refinement/v01/baseline-hashes.json).
- [Guia de poses para o piloto E](../vault/drafts/durvall-guia-piloto-e-2026-10-06.md).

## Método e limites

O diagnóstico usa uma cópia byte a byte de HeroView, sua cena, SpriteStripFrames, Iso, Data, dados dos heróis e PNGs de Durvall em um projeto mínimo separado. Não carrega Game, Playtest, saves, combate, outros heróis ou a run completa. O cache e os dados de editor do projeto mínimo ficam em `.atena/generated/durvall-run-refinement/v01/`.

O componente oficial recebeu deslocamentos sintéticos de 19 px por intervalo de 100 ms para selecionar as direções. A captura congela cada quadro deliberadamente. Os arquivos trace-* descrevem essa entrada controlada; não são telemetria de física nem tempos medidos de uma partida. A página HTML reproduz o contrato visual observado e move o chão à velocidade oposta, sem alterar os PNGs. Não representa câmera, obstáculos ou efeitos de combate da run.

As transições idle → movimento → parada, ataque e retorno ao movimento foram exercitadas no componente. O fim do ataque foi sinalizado pelo harness, não aguardado como animação natural; seu registro comprova desbloqueio e roteamento, não valida timing de combate. A suíte de gameplay e o playtest completo pertencem ao B-004.

Geometria: alfa ≥0,10, limites inclusivos dos pixels visíveis e faixa inferior de 12 px-fonte. Essa faixa é um proxy de geometria, não identifica a perna anatômica ou prova que um pé está apoiado. O diagnóstico visual continua necessário. Nenhum rastreamento automático de apoio foi anunciado como medida exata de patinação.

## Resultado observado

Escala observada: 0,25974026; âncora: y=376 na célula, offset=-184; seis quadros e 10 fps em todas as direções de locomoção usadas. Velocidade base de referência: 190 px/s. Duração de ciclo: 0,6 s; distância do corpo em um ciclo uniforme: 114 px de tela. Isso não é a largura da passada da arte.

| Direção exibida | Fonte selecionada | Espelhamento | Altura alfa em tela |
|---|---|---|---|
| E | move_e | não | 60,0 px |
| SE | move_se | não | 60,0–60,5 px |
| S | move_s | não | 58,7–60,5 px |
| N | move_n | não | 60,0 px |
| NE | move_ne | não | 60,0 px |
| W | move_e | sim | 60,0 px |
| SW | move_se | sim | 60,0–60,5 px |
| NW | move_ne | sim | 60,0 px |

Nas cinco fontes usadas, o pixel alfa mais baixo permanece em y=375 (borda inferior exclusiva 376). Nenhuma célula dessas tiras está vazia, fora da dimensão prevista ou tocando a margem de triagem ≤1 / ≥254 horizontal, ≤1 / ≥382 vertical.

O idle mede 226–235 px-fonte, mediana 231. As tiras usadas não têm o salto grande de altura que uma alteração por quadro precisaria compensar. A inspeção visual E mostra tronco bastante ereto e diferenciação pequena de impulso/recuperação; SE tem tecido e cabelo mais ativos que a extensão das pernas. O julgamento “parece caminhada” é compatível com essas poses, mas o diagnóstico não atribui todos os problemas de locomoção exclusivamente à arte.

Na faixa inferior de E, a extremidade esquerda varia 15 px-fonte e a direita 19 px-fonte no ciclo — aproximadamente 3,9 e 4,9 px de tela. Essa amplitude pequena contrasta com o deslocamento de 19 px do corpo por intervalo. Como há dois pés e possível troca de apoio, esses números são proxies e não uma medida do escorregamento de um pé específico. O piloto deve tornar a fase de apoio identificável antes de medir seu movimento contra o chão.

## Fontes independentes existentes não devem ser ativadas automaticamente

Os arquivos abaixo existem, mas não são carregados pelo roteamento atual:

| Fonte | Altura alfa-fonte | Altura em tela na escala atual | Mediana vs idle |
|---|---|---|---|
| move_w | 205–221 px | 53,2–57,4 px | 211/231 ≈ −8,7% |
| move_sw | 250–259 px | 64,9–67,3 px | 258/231 ≈ +11,7% |
| move_nw | 257–307 px | 66,8–79,7 px | 297/231 ≈ +28,6% |

Eles não substituem candidatos aprovados. A fase de produção deve alcançar oito fontes independentes coerentes, conforme o contrato existente, sem simplesmente ligar essas três tiras nem introduzir compensação automática de tamanho por quadro.

## Guia e recomendação resultante

Priorizar um piloto E de seis poses que diferencie contato, compressão e impulso/recuperação e alterne verdadeiramente as pernas. Manter velocidade, escala e 10 fps no primeiro confronto. Avaliar apoio contra o chão, loop e transições em tamanho real. Preservar espada, mão e volumes; deixar cabelo/roupa como movimento secundário.

A relação de apoio esperado é 190 px/s ×0,1 s ÷(60/231) ≈73,15 px-fonte por intervalo inteiro de apoio. Serve para verificar movimento relativo de um pé identificado, sem inferir passada a partir de largura de silhueta. Uma fase aérea curta pode reduzir a duração do apoio, mas precisa de revisão e não pode virar saltitar.

O aumento de cadência rejeitado em [EVID-158](EVID-158-velocidade-de-movimento-x-passo-da-arte-2026-10-05.md) não foi reaplicado. A melhora proposta é testável, não declarada como correção pronta.

## Verificação e recuperação

- Godot 4.7.2: importação isolada e execução headless concluídas; captura Windows/OpenGL concluída, sem erro no log final.
- Roteamento real confirma cinco fontes + três espelhamentos; escala e fps concordam com a reprodução HTML.
- Sintaxe do JavaScript da página verificada; captura PNG inspecionada visualmente. A revisão interativa no navegador integrado foi impedida pela política que bloqueia URLs file:. Não houve tentativa de contornar a política. A interação da página permanece sem teste visual no navegador; a captura Godot e a verificação da sintaxe são as validações realizadas.
- 23 arquivos de baseline têm hashes registrados; conferência final: zero arquivos originais alterados.
- Links e contrato ADD conferidos antes da entrega; o estado central registra o checkpoint B-002 pendente após este lote.
- O primeiro import apresentou erros de permissões por um caminho customizado inadequado. O harness foi corrigido para nome relativo e APPDATA/LOCALAPPDATA locais; o import seguinte e as duas execuções finalizaram sem esses erros. Não foi necessário ampliar permissões.
- Backlog: P0=0; quatro P1 abertos (BUG-025/027/028/029); nenhum bug fechado neste diagnóstico. Os dois UID preexistentes das ferramentas de captura foram preservados.

Os originais continuam intactos. Remover o harness não é necessário para rollback; B-002 preservará a mesma baseline e terá seus próprios candidatos.

## Reconciliação

B-001 concluído: baseline revisável, medidas com limites declarados e guia E entregues. Escopo, intenção canônica e gameplay preservados. B-002 depende de aprovação do lote e autorização específica de uso dos três PNGs no ImageGen, exigida pela [SPEC-106](../specs/SPEC-106-pacote-integral-animacoes-durvall.md). A aceitação visual do futuro piloto permanece pendente.

Nota de publicação (2026-10-07): fontes, imagens e projetos de teste dos pilotos Durvall permanecem locais, aguardando decisão do dono após bloqueio da revisão automática. As referências históricas a `.atena/generated/durvall-*` registram trabalho local; não indicam assets admitidos ou publicados. Os registros e o mapa das referências pendentes estão na evidência de consolidação.
