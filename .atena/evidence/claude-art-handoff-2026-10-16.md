# Entrega das artes ao Claude — v01 / 2026-10-16

Pedido do dono: reunir as artes que precisam de implementação em `.atena/generated/art-candidates`, com commit/push se necessários. Aprovação por plano: resposta `1`. Desvio aprovado com execução agora e retorno ao PLAN-103; checkpoints B-002/S-008 e B-004/R3 preservados. Conteúdo de entrega DRAFT; estados visuais individuais preservados.

## Resultado local

- 34 preparações aceitas da FILA-028 ainda sem admissão runtime, incluindo altar corrigido AL01-CORR/v01 (900 ms).
- Quatro tiras Durvall v03 DRAFT aceitas provisoriamente no laboratório; migração completa depende dos cinco retornos e do gate M1.
- Dez imagens de apoio: quatro fontes em grade e seis quadros do altar.
- Manifesto, instruções ao Claude, pendências, classificação por família, inventário das 2.371 imagens locais e índice de 55 candidatas históricas retidas já versionadas.
- Artes ainda não geradas listadas sem fingir entrega: logotipo, botão JOGAR, pilar corrigido, 24 retratos ficha/HUD e direções pendentes.
- Imagens originais preservadas, sem modificações de raster. Nenhum arquivo de runtime alterado. Nenhuma promoção canônica, sessão externa, mensagem ao Claude ou playtest humano realizado.

Entrada do pacote: `.atena/generated/art-candidates/README-CLAUDE.md`; seleção em `claude-handoff-v01/manifest.json`. A pasta ignorada será versionada apenas para os arquivos específicos desta entrega, conforme autorização do dono; a regra geral do .gitignore permanece.

## Verificação

`tools/prepare_claude_art_handoff.ps1 -VerifyOnly`: PASS para 38 artes e dez apoios, hashes das cópias e fontes, recibos/links do manifesto e hashes atuais dos destinos existentes. Recibos da FILA-028 conferidos por SHA-256 antes de copiar. Auditoria local cobre PNG/WebP/JPEG, incluindo ignorados, e confronta hashes com `assets/`; igualdade de arquivo não prova wiring, aprovação ou diversão.

Backlog: 0 P0, quatro P1 abertos (BUG-025/027/028/029), 18 P1 implementados aguardando playtest, 0 alertas de organização. Testes de gameplay não foram repetidos: o escopo contém só pacote de entrega, documentação e ferramenta de preparação/verificação. Validação complementar de links, dimensões e diff registrada no relatório do pacote.

## Publicação

Branch dedicada: `codex/claude-art-handoff-2026-10-16`, base `806a7429`. Main preservada. O workflow de release só dispara por push em main; este push de branch não publica uma build. Commit/push autorizados condicionalmente no pedido e necessários para disponibilizar os arquivos ignorados ao Claude em outro checkout. O recibo de publicação será anexado após confirmação do SHA remoto.

Próximo objetivo após entrega: retornar ao PLAN-103, preservando espera das imagens Durvall e da decisão G-M3-3. Implementação futura exige seu checkpoint e conserva os gates visuais/playtests individuais.
