# Durvall — G-D2, P3–P5 e GIF de avaliação, 2026-10-14

PLAN-103 / SPEC-176 / B-002, classificação IN_PLAN, aprovação per-batch existente e pedido explícito: "cheque as atualizações dos prompts até o P5 na G-D2 e execute os promts e faça um gif para avaliação". Revisão operacional G-D2-P3-P5/v01; conteúdo DRAFT, sem promoção CANON, sem admissão runtime ou publicação.

## Atualização recebida e autoridade

Checkout principal local F:/dev/nottgard-survivor: PLAN-103 owner_decisions D19 registra G-D2 decidido após teste humano da candidata: manter **10 fps**, descartar 17 fps, seguir P2–P4 e comparar P5 de oito quadros. Alguns campos antigos ainda dizem "17 fps" e "aguardando G-D2"; a decisão explícita D19 e o adendo datado do PROMPTS.md prevalecem nesta avaliação. Não houve reescrita do checkout principal.

PROMPTS.md atualizado copiado para ../generated/m1-movimento/piloto-durvall/PROMPTS.md, junto de gabarito_move_e_8.png. P1–P4 permanecem com o mesmo texto; novidade P5: oito quadros, corrida natural de guerreiro, tronco levemente inclinado, braços contidos, transições graduais e sem pulinhos. P1/P2 já gerados foram preservados e reutilizados; P3/P4/P5 foram executados integralmente, sem acréscimos ao prompt, com image_gen integrada e transparent_background=true.

## Prontidão visual

Identidade: Durvall, ficha DRAFT r1 aprovada no G-D1; durvall_idle.png é autoridade visual obrigatória. Contexto: pintura de pixel detalhada, jogo 2D isométrico, câmera três-quartos e luz superior esquerda; P3 frente, P4 ataque em três-quartos à direita, P5 corrida de perfil à direita. Anexo independente por chamada: idle mais gabarito_move_s.png, gabarito_attack.png ou gabarito_move_e_8.png. Referências defeituosas e retornos anteriores não foram anexados. Nenhuma lacuna BLOCKING para as tentativas experimentais.

## Entrega e verificações

- P3: ../generated/m1-movimento/piloto-durvall/retorno/durvall_move_s_v01.png — seis poses, 1774 × 887.
- P4: ../generated/m1-movimento/piloto-durvall/retorno/durvall_attack_v01.png — quatro poses, 2048 × 768.
- P5: ../generated/m1-movimento/piloto-durvall/retorno/durvall_move_e8_v01.png — oito poses, 2048 × 768.
- GIF: ../generated/m1-movimento/piloto-durvall/avaliacao/durvall_p1_p5_10fps.gif — cinco colunas, 24 quadros, 100 ms por quadro, loop infinito. Ciclos: seis quadros 600 ms, oito quadros 800 ms, ataque 400 ms.
- GIFs individuais p1_10fps.gif até p5_10fps.gif na mesma pasta.
- Relatório: ../generated/m1-movimento/piloto-durvall/avaliacao/report.json — dimensões, alfa, hashes, método de recorte e critérios de formato por fonte.
- Script reproduzível: ../generated/m1-movimento/piloto-durvall/build_review.py.

Pillow do runtime já existente foi usado, sem instalação. PNGs nativos intactos. O GIF usa escala fixa por tira, sem interpolação temporal; não é teste de runtime nem comprova diversão. Quando possível, quadros separados por componentes alfa >=128 e âncora horizontal do topo; coordenada vertical comum preserva o sobe/desce. P3/P5 têm componentes unidos e usam divisão uniforme pela grade solicitada, portanto cortes/contaminação entre células podem aparecer. O GIF é uma prévia derivada; as bordas de baixa opacidade são filtradas na extração por componentes. A coluna P4 é menor porque a extensão da lâmina determina a escala necessária para caber na prévia.

Nas células de fallback P3/P5, mantém-se o componente alfa dominante de cada célula para evitar fragmentos soltos de vizinhos. Isso não recupera partes cortadas ou unidas; o relatório registra o fallback. Não altera as fontes nativas.

Todas as fontes falham na dimensão exata do contrato. Existem cortes de espada e poses muito próximas; não se declara aprovação técnica de base, passo, margem ou identidade. Alfa nativo possui valores transparentes e opacos (P5 máximo 254); o gabarito não aparece nas tiras. Validação automática do GIF: 24 quadros, duração 100 ms, loop 0; inspeção do primeiro quadro e amostragem dos quadros 0,5,12,23. Links de entrega locais verificados.

## Avaliação humana e próximo checkpoint

Pedido entregue em quatro etapas ordenadas: P3, P4, P5, GIF_VERIFY (4/4). Checkpoint B-002/S-008/GIF_OWNER_REVIEW. Avaliação visual G-D3 pendente. Comparar P1/P5 por alguns ciclos: fluidez e naturalidade, pulinhos do tronco, passagem do último quadro ao primeiro; nas demais colunas, direção, leitura do golpe e identidade. Feedback esperado: preferir seis ou oito quadros, indicar quais movimentos ficaram abruptos/estranhos e aceitar ou pedir revisão por ação. Não foi realizado novo playtest em jogo.

Backlog no início: P0=0, quatro P1 abertos, 16 implementados aguardando playtest, um alerta de organização. Sem commit, push, integração, exportação ou alteração do código do jogo.

## Continuação: 5 fps e autorização de commit local

Dono: "ainda está estranho vamos tentar um gif a 5fps". Derivado durvall_p1_p5_5fps.gif dos mesmos 24 quadros, 200 ms por quadro, loop infinito; cabeçalho atualizado para 5 fps, sem alteração dos PNGs. Avaliação segue pendente; comentário de estranheza não equivale a aceite. Próxima decisão: revisão das animações após avaliar em 5 fps.

Dono: "commit". Autorização explícita de commit local dos insumos, retornos, GIFs, script de revisão, relatório, evidências e estado desta conversa. Sem push ou merge autorizados. Verificação antes de commitar: cinco PNGs de retorno presentes; sete GIFs abrem, contagem e duração coerentes (comparativos 24 quadros a 100/200 ms); git diff --check sem erro; backlog P0=0, quatro P1 abertos e 16 aguardando playtest. Nenhum código do jogo alterado; não se aplica suíte de runtime a esta entrega de arte DRAFT.
