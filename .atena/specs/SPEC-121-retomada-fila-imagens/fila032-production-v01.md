# FILA032-PRODUCTION/v01 — LN01

Estado DRAFT. Origin planned; implementation_preceded_spec false. Pedido explícito em 2026-10-16: "atena aprovado agora vamos para o item CHATGPT-FILA-032". Escopo definido pela fila nomeada; modo per-plan mantido nesta frente. Classificação PLAN_CHANGE_REQUEST da produção; PLAN-103 e implementação por Claude preservados. Pedido atual autoriza iniciar a fila LN01, sem executar renomeação do runtime.

## Origem, autoridade e prontidão

Fila ausente neste worktree e localizada no checkout principal `F:/dev/nottgard-survivor`, por leitura local sem rede/merge. Snapshots: [FILA-032](../../generated/fila032-production-2026-10-16/provenance/CHATGPT-FILA-032-logotipo-abyss-megadungeon.md), [ART-PROMPTS-065 r1](../../generated/fila032-production-2026-10-16/provenance/ART-PROMPTS-065-logotipo-abyss-megadungeon.md), [SPEC-181](../../generated/fila032-production-2026-10-16/provenance/SPEC-181-renomeacao-nottgard-abyss-megadungeon.md) e [PLAN-106](../../generated/fila032-production-2026-10-16/provenance/plan-106-renomeacao-abyss-megadungeon.yaml).
Nome CANON r2 aprovado no principal (PLAN-001 §16): Nottgard - Abyss Megadungeon. Não reescrever o cânone antigo deste worktree. Arte produzida permanece DRAFT. G-1 resolvida em 2026-10-16: NOTTGARD / ABYSS MEGADUNGEON, sem hífen escrito. Grafia exata prevalece sobre erro numérico do prompt: ABYSS tem 5 letras, MEGADUNGEON 11, total 16 sem espaço.

Mini bíblia DRAFT r1: pixel art sombria, ouro velho forjado com bisel e contorno escuro, rachadura roxa contida, ornamento apenas nas laterais. Duas linhas centralizadas; inferior ~40% da altura/~85% da largura da superior. Fundo e vazios ciano #00FFFF, bordas duras sem halo/sombra externa. Contexto textual: logo no alto da tela de título sobre abismo roxo/ruínas. Identidade de entidade N/A: lettering sem personagem. Sem lore nova.
Três referências do principal copiadas como snapshots em generated/fila032-production-2026-10-16/references e inspecionadas: logo atual (identidade NOTTGARD/material/bisel/pontas/rachadura), fundo de título (somente clima/paleta, não compor cenário), painel de evolução (somente material/cor). ART-PROMPTS-065 registra essas referências como aprovadas no jogo; origem/hashes em references.json. Nenhuma substituição em assets.
BLOCKING: nenhuma; G-1 resolvida, pedido atual e referências disponíveis. RESOLVABLE: proporção nativa, margem e grafia no resultado. DEFERRED: alfa definitivo, admissão e aceite real desktop/mobile.

## Etapas e limites

1. S-001: contrato/origem/referências — concluído; snapshots e hashes locais, sem modificar main.
2. S-002: gerar LN01 v01 com imagegen e três referências na ordem declarada; texto EXATO NOTTGARD / ABYSS MEGADUNGEON. Pedir fonte 3:2, conteúdo 4:1..6:1, futuro teto 1100×176. Até três candidatas, uma correção objetiva por tentativa. Duas candidatas com erro ortográfico encerram geração e recomendam fallback tipográfico ao implementador, conforme contrato; não alterar código aqui.
3. S-003: inspecionar grafia letra a letra, materiais, bordas e margem; separar tamanho nativo de alvo; criar prévias de QA e registrar limitações. Originais versionados em `.atena/generated/art-candidates/lettering/LN01_vNN.png`; não declarar PNG normalizado por mera prévia.
4. S-004: entregar galeria local, manifesto, prompts, evidência e orientação para Claude; parar no gate da direção visual. Gate posterior exige título 1280×720/mobile, linha inferior ≥14 px em tela e auditoria de halo após preparação. Prévia não é teste em runtime.

Saídas restritas aos registros/gerados desta frente; nenhum asset oficial, código, dados, configuração ou cânone alterado. Sem commit/push/exportação ou envio automático a outro chat. Recuperação com versões preservadas/retidas. Lote anterior ASSET-LOT02 aceito separadamente. Checkpoints PLAN-103 preservados; pedido específico de LN01 não cria variações artificiais para completar seis peças.
