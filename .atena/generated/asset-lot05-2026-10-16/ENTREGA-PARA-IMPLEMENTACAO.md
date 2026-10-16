# ASSET-LOT05/v01 — seis quebráveis / 30 poses

DRAFT. Escopo autorizado por plano com "aprovado, por plano" em 16/10/2026. Direção visual das seis revisões selecionadas aceita pelo dono com "aprovado, pode seguir para os proximos" em 16/10/2026. [Recibo](visual-acceptance.json). Implementação com Claude; entrega local, sem mensagem a outro chat, admissão ou integração.

| Código | Identidade | Fonte selecionada | Quadros |
|---|---|---|---:|
| QB07 | carroca_quebravel | [v01](../animation-candidates/asset-lot05/QB07_v01.png) | 5 |
| QB08 | pilha_carga_quebravel | [v02](../animation-candidates/asset-lot05/QB08_v02.png) | 5 |
| QB09 | lanterna_de_papel_quebravel | [v01](../animation-candidates/asset-lot05/QB09_v01.png) | 5 |
| QB10 | espelho_ilusorio_quebravel | [v01](../animation-candidates/asset-lot05/QB10_v01.png) | 5 |
| QB11 | estatua_rachada_quebravel | [v01](../animation-candidates/asset-lot05/QB11_v01.png) | 5 |
| QB12 | relicario_instavel_quebravel | [v02](../animation-candidates/asset-lot05/QB12_v02.png) | 5 |

Todas selecionadas:1536×1024, grade3×2, células512×512, cinco poses em leitura esquerda→direita e linha superior→inferior; excluir a sexta célula. `frames/` são recortes nativos de QA sem ajuste de pixels/pivô/escala, não tiras finais. [Galeria](index.html), [manifesto](manifest.json), [medições](inspection.json), [prompts exatos](prompts.md), [checagem dos controles](player-check.json). Oito tentativas nativas preservadas; não usar QB08/QB12 v01 como fontes finais por contato com grade.

## Preparação e revisão pendentes

- Alfa modal do corpo do primeiro quadro é253 em todas. Existem resíduos alfa1..15 fora do corpo. Auditar opacidade dos sólidos e limpar resíduos preservando vidro, bordas e luz existente; não remover cor de fundo inexistente nem aplicar limiar destrutivo global. Fontes não foram alteradas após geração.
- Margem mínima alfa≥16:QB07 18px;QB08 80px;QB09 27px;QB10 4px;QB11 13px;QB12 9px. Só carga atende alvo48px. Nenhum pixel alfa≥16 na faixa externa de4px das selecionadas; folga do espelho é curta, preparar canvas antes de redução se necessário.
- Sextas células têm zero alfa≥16, mas resíduos alfa1..15 de1586/29/402/1290/62/378 pixels em QB07..QB12. Não são completamente alfa0; excluir, sem quadro de desaparecimento inventado.
- Variação inferior do contorno alfa≥128:37/43/35/42/32/81px respectivamente. Não é anotação semântica de pivô: inclui destroços e queda. QB12 começa flutuante e termina assentado; não alinhar topo/fundo automaticamente nem recentralizar cada fragmento. Escolher contato/âncora e escala contra os estáticos na preparação.
- Conferir continuidade das peças e ligação estático→primeiro quadro. Carroça começa avariada, carga mantém recipientes/sacos/lona em vez de virar só tábuas. Lanterna termina caída com parte do poste em pé. Espelho conserva fragmentos do reflexo já existente. Estátua permanece escultura; fissura vermelha ainda aparece nos restos, avaliar se intensidade final precisa reduzir. Relicário conserva identidade da runa, fragmenta e reduz brilho. Direção das poses aceita; fluidez em jogo permanece pendente.

Destinos esperados a confirmar na frente de admissão:`assets/animations/enemies/<id>/death.png`, perfil D de cinco quadros do PLAN-041. Confirmar `ui/enemy_view.gd`, geometria final, importação, duração, pivô e estado terminal. Não substituir estáticos automaticamente. Carroça quebrável é distinta do evento Carroça Abandonada da FILA-028.

Player usa8FPS inicial e opções2/4/8/10/12 somente para inspeção, hold final e repetição opcional. Simulação DOM offline validou lógica/caminhos; não equivale a render real de navegador. Contatos PNG inspecionados. Preparação técnica, admissão e playtest humano futuros permanecem pendentes. Sem alteração de assets oficiais, código, dados, dependências ou cânone; sem commit/push nesta produção. Antes do playtest, explicar build/escopo/objetivo/procedimento/observações/critérios e feedback esperado ao dono.
