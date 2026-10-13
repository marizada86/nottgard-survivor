# FILA-026 — nove peças DRAFT preparadas para G2

Atualização posterior: admissão e validação S013 autorizadas com **“Autorizo a admissão e validação”** e concluídas, [evidência específica](fila026-admission-2026-10-11.md). Os estados sem runtime/pending-admission abaixo são históricos; agora dez PNGs aceitos foram admitidos e o commit de arte é o checkpoint pendente.

## Aceite posterior do dono — 2026-10-11

Pedido IN_PLAN: **“Aprovo as nove revisões v01”**, resposta à pergunta que nomeou individualmente todas as nove revisões e preservou os gates de integração/Git. G2 concluído; fontes e preparados L03–L05, P01–P03, C01–C03 v01 promovidos a **CANON_VISUAL_G2**. [Registro canônico](../vault/canon/ASSET-APPROVAL-FILA026-G2-v01.md) e [recibo com hashes](../generated/fila026-remaining-2026-10-11/owner-approval.json). Grafia estilizada de L03/L04, contraste e cursores em 32/40 px aceitos visualmente pelo dono. Funcionamento do cursor do SO e playtest continuam sem evidência humana de runtime.

S012 encerrada com aceite e auditoria técnica PASS. Posição atual 13/16: doze passos concluídos, três após S013. Próximo objetivo S013: admissão dos dez PNGs aceitos e hotspots reais. Entradas: L01 G1 e nove G2 com hashes, tabelas de lettering/cursor existentes; saída preparada: [proposta de admissão](../generated/fila026-remaining-2026-10-11/admission-proposal.json). Dez destinos livres, nenhuma cópia runtime. A admissão pode ativar logo e cursores através do código existente, por isso não se presume autorização de integração a partir do aceite visual. Commit, push, build e publicação também não autorizados pela resposta G2. Backlog: quatro P1 abertos (BUG-025/027/028/029), zero P0; PLAN-071 e retornos preservados.

Histórico abaixo registra a preparação e o checkpoint anterior; o aceite acima substitui apenas o estado visual pendente.

Verificação após o aceite: auditoria pixel a pixel repetida com PASS; reconciliação preserva o G2 após regenerar os metadados técnicos e a galeria. Contrato atualizado verificou 91 links locais, hashes de todas as revisões aceitas, dez destinos propostos livres e a cadeia de retornos inalterada. `git diff --check` sem erros. PNGs e runtime preservados, zero commits/push neste checkpoint.

PLAN-065/SPEC-132, aprovação existente por plano. Continuação IN_PLAN após a resposta explícita **“Aprovo L01 v01”** ao G1. A escolha da v01 prevalece sobre a recomendação histórica da v02. [Registro CANON visual G1](../vault/canon/ASSET-APPROVAL-FILA026-L01-v01.md); nenhum runtime admitido. PLAN-071, retorno dos heróis e demais cursores preservados.

S-009 concluído com G1; S-010 gerou nove fontes, uma por chamada da ferramenta integrada imagegen, na ordem L03, L04, L05, P01, P02, P03, C01, C02, C03. S-011 produziu derivados separados; S-012 tem prévia técnica pronta e aguarda G2. Posição atual 12/16: onze passos concluídos, quatro após o atual. L02 é opcional e permaneceu deferida, sem presumir pedido de geração.

Entradas visuais estruturadas em [jobs e prompts](../generated/fila026-remaining-2026-10-11/jobs.json). L01 v01 CANON visual define família; fundo vitória/derrota define contraste; moldura evolução e ficha C aprovada definem acabamento. Referências inspecionadas antes de gerar e verificadas por SHA256 após o lote. Identidade N/A: peças de UI, sem personagem/entidade; contexto frontal de lettering, placas de nove fatias e cursor de mouse. Sem lore nova; lacunas BLOCKING de produção: nenhuma. Conteúdo das nove peças DRAFT v01.

Textos: sequências Vitória! (ó), Você caiu... (ê e três pontos) e EVOLUÇÃO (Ç/Ã) conferidas visualmente. L03/L04 têm renderização em capitulares góticas estilizadas, explicitada na galeria para o dono avaliar; não se registrou aceite humano automaticamente. O gosto visual, intensidade do ouro/roxo e legibilidade final dependem de G2.

Processamento nativo Godot 4.7.2, separado das fontes: chave magenta com tolerância (r,b>210, g<80, r-g/b-g>130), erosão de um pixel nativo em quatro vizinhos, recorte; lettering reduzido proporcionalmente, sem ampliação. Placas: pontas em escala proporcional à altura, nas margens finais; uma coluna central do material de origem é repetida para eliminar variação horizontal do miolo. Essa operação prepara nove fatias e é declarada como derivação, não como propriedade da fonte bruta. Mira: rotações dos quatro quadrantes a partir do superior esquerdo normalizam a simetria do derivado; fonte histórica e intermediário preservados. Não há pintura ou mistura de cores novas nesse processamento.

Python só leu matrizes/hashes e escreveu JSON/HTML. A [auditoria](../generated/fila026-remaining-2026-10-11/audit.json) compara a máscara de chave/erosão/corte pixel a pixel, verifica que as cores finais vêm das fontes, os nove SHA256 de origem, referências, limites, proporção do lettering, uniformidade por linha das placas e hotspots. Resultado técnico PASS; todas as nove saídas RGBA têm alfa transparente e sólido. `tools/audit_candidate_alpha.gd` confirma transparência e ausência de alfa parcial. Relatório em [alpha-audit.txt](../generated/fila026-remaining-2026-10-11/alpha-audit.txt); `clipped=true` dos recortes rente ao conteúdo é indicador de contato com a borda do derivado, não corte na fonte: folga nas fontes foi conferida separadamente. Uma chamada inicial com caminhos relativos falhou; a repetição com caminhos absolutos concluiu a auditoria. Avisos de certificado/preferências do Godot fora do workspace não impedem os outputs verificados.

| Peça | Final | Fatias ou hotspot |
|---|---|---|
| L03 v01 | 551×160 | Vitória! |
| L04 v01 | 720×135 | Você caiu... |
| L05 v01 | 537×110 | EVOLUÇÃO |
| P01 v01 | 640×96 | 56/56/28/28 |
| P02 v01 | 320×48 | 32/32/16/16 |
| P03 v01 | 720×112 | 80/80/36/36 |
| C01 v01 | 32×32 | (1,1), ponta |
| C02 v01 | 32×32 | (4,1), indicador |
| C03 v01 | 40×40 | (20,20), centro |

Mira: RGBA com simetria rotacional de quatro lados e região central 12×12 transparente. Cursores mantêm o canvas quadrado, têm intermediários 4× e prévias reais 32/40 px. Hotspots em [cursor-candidates.json](../generated/fila026-remaining-2026-10-11/cursor-candidates.json), fora de `data/cursor.json`.

[Galeria G2](../generated/fila026-remaining-2026-10-11/index.html): nove peças nos tamanhos finais, texto de exemplo em fonte separado dos PNGs das placas, fontes/prompts e contextos. Banners sobre os fundos reais; placas/cursores sobre a captura existente `ficha-c-integration/v01/desktop_heroi_durvall.png`. Comparação adicional de cursores sobre fundos lisos claro e escuro. São composições ilustrativas, não capturas de integração, nem prova de funcionamento do cursor no sistema ou de playtest. Fontes, PNGs finais, cursores claro/escuro e três composições de banners foram inspecionados.

Próximo objetivo: decisões G2 por revisão. Entradas: galeria, auditoria, cada fonte e derivado; saída: registro apenas das revisões aceitas. Após G2, S-013/S-014 dependem dos gates correspondentes; nenhum aceite do G1 autoriza integração, commit, push ou exportação. Backlog verificado: P0=0, quatro P1 abertos (BUG-025/027/028/029), 14 implementados aguardando playtest, zero alertas de organização.

Verificação final do [contrato](../generated/fila026-remaining-2026-10-11/contract-check.json): 80 links locais válidos, derivados aceitos de L01 v01 preservados, nove revisões DRAFT, PLAN-071 e cadeia de retornos intactos, arquivos de runtime sem alterações. `git diff --check` concluiu sem erros; nenhum commit ou push realizado. G2 permanece pendente.
