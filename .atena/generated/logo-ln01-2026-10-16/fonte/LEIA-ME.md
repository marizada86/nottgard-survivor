# Complemento da logo LN01 para Claude — v01

PLAN-108 / SPEC-183 r1, 2026-10-16. Conteúdo **DRAFT com preparação visual v02 aceita explicitamente pelo dono** ("atena aprovado"). Entrega escolhida: ZIP para o dono anexar ao Claude. Nenhum envio direto ao Claude foi realizado. G-L1 concluído; autorização de integração no runtime continua própria. Aceite visual não promove CANON.

O pacote histórico claude-handoff-v01 marcou ART-049 como sem imagem. Este complemento fornece a fonte recebida em 2026-10-16 e uma nova candidata preparada. Não reescrever a história do pacote anterior.

## Arquivos

- [Fonte original](LN01_source_v01.png), inalterada, com fundo ciano.
- [Candidata transparente em resolução de trabalho](LN01_transparent_v02.png).
- [Candidata de exportação](LN01_runtime_candidate_v02.png), 699×176 RGBA.
- [Prévia sobre o fundo real](preview_title_1280x720_v02.png), 1280×720.
- [Manifesto e verificações](manifest.json), com SHA-256 de todos os PNGs e hash anterior do destino.
- [Último prompt usado](imagegen-final-prompt.txt).

Método: imagegen integrado, duas tentativas de extração do fundo; exportação proporcional via System.Drawing com nearest-neighbor. A extração generativa produziu pequenas diferenças em contornos, material e espaçamento: não é uma remoção de chave pixel a pixel. O dono aceitou visualmente a v02 após a prévia. O recorte segue os limites sólidos mais margem; resíduos de alpha baixo na resolução de trabalho estão documentados no manifesto.

## Instruções de futura integração

Destino previsto: `assets/ui/title/logo.png`. Conferir o SHA-256 atual contra `runtime_before_sha256` e preservar backup antes de substituir. Diferença de hash exige reavaliar o estado local, nunca sobrescrever silenciosamente.

`ui/title.gd` procura sequências `logo_00.png` etc. antes de `logo.png`: conferir que nenhuma sequência mascara esta peça. A faixa da logo tem y24..200 e usa KEEP_ASPECT_CENTERED. Não deformar nem ampliar a altura além de 176 px. A largura de 699 px resulta da proporção da arte; preencher 1100 px deformaria a composição.

Após autorização de admissão: copiar a revisão aceita, importar no Godot, capturar o título real a 1280×720 e conferir console/recursos, grafia, pontas, contraste e subtítulo. A prévia deste pacote é composição estática, sem o restante da interface; não é captura de runtime nem playtest. O dono avalia a legibilidade, inclusive no dispositivo móvel previsto no contrato. Não declarar esse critério verificado apenas pela prévia.

Sem promoção CANON, commit, push, merge, build ou exportação autorizados por este pacote. Respeitar AGENTS.md e estado persistente do checkout receptor. Integração e playtests pertencem a checkpoints próprios.
