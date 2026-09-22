# RESEARCH-002 — Biblioteca visual local de Nottgard

Status: **pesquisa derivada; não canônica**  
Data: 2026-09-21  
Fonte visual inspecionada: `C:\Users\gui-m\Desktop\nottgard`  
Fonte semântica: `D:\dev\nottgard\vault`

## Objetivo

Catalogar as 27 imagens da pasta indicada pelo dono, definir o papel seguro de cada uma na produção de `nottgard-survivors` e impedir que uma referência visual contradiga o vault ou seja confundida com asset final.

Prancha de inspeção: `D:\dev\nottgard\games\godot\nottgard-survivors\.atena\evidence\EVID-006-reference-board.png`.

## Conclusão visual

O conjunto é valioso como **referência de identidade** e **referência de composição**, mas não como style guide único. Há retratos pintados, realismo, anime, 3D/cartoon, ilustração em papel e cenas em pixel art. A produção final deve:

1. extrair rosto, espécie, cabelo, roupa, arma e símbolos das referências de personagem;
2. validar essas características no vault antes de fixá-las no prompt;
3. reinterpretar tudo na direção comum de `Nottgard Survivors`, sem copiar o acabamento inconsistente;
4. tratar `menu.png`, `vitoria.png` e `game_over.png` como referências principais de atmosfera e enquadramento;
5. nunca promover diretamente as imagens com selo visível `Made with AI` a assets finais.

## Mapeamento direto para o elenco atual

| Arquivo local | Consumer/ID | Uso permitido | Observação |
|---|---|---|---|
| `Durvall_Gellad.png` | `durvall` | identidade de retrato e sprite | Drow, cabelo branco, armadura e energia da arma; o vault prevalece sobre detalhes inventados. |
| `brook.png` | `brook` | identidade de retrato e sprite | Anão guerreiro, barba branca e armadura; harmonizar o acabamento realista. |
| `Maelor.png` | `maelor` | identidade, traje e magia | A figura de corpo inteiro ajuda o sprite; não reutilizar o fundo. |
| `sylas_malafa.png` | `sylas` | identidade, paleta e máscara/armadura | O acabamento anime não é direção final. |
| `kayron.png` | `kayron` | identidade e contraste claro/escuro | Validar asas e estado visual no vault antes de torná-los permanentes. |
| `korrak.png` | `korrak` | identidade-base, proporção e Machado de Xar'gath | A ilustração em papel é âncora semântica, não style guide. |
| `korrak-gigante.png` | `korrak` | variação de escala/provação | Não criar um segundo herói; usar somente para entender a forma ampliada. |
| `leoric.png` | `leoric` | chapéu, barba, espécie e traje | O aspecto chibi/3D deve ser removido na harmonização. |
| `Zynara.png` | `zynara` | identidade élfica, cabelo e traje | Reduzir aparência régia se o vault definir função de conselheira. |
| `Bromnor.png` | `bromnor` | identidade, barba, armadura e martelo | Referência forte; converter para a câmera e o acabamento comuns. |
| — | `nyrelia` | somente vault | Não existe imagem correspondente nesta pasta; a primeira candidata exige revisão específica de identidade. |

## Referências de telas e linguagem visual

| Arquivo | Dimensão | Papel no plano | Restrição |
|---|---:|---|---|
| `menu.png` | 1536×1024 | composição e atmosfera do Quartel/menu | Possui selo visível; regenerar limpa, sem texto. |
| `vitoria.png` | 1536×1024 | composição da tela de vitória | Possui selo visível; regenerar limpa e reservar área para UI. |
| `game_over.png` | 1536×1024 | composição da tela de derrota | Possui selo visível; regenerar limpa e reservar área para UI. |
| `d4.png`, `d6.png`, `d8.png` | 1024×1024 cada | metáfora visual de dado e material abissal | Fundo verde e selo visível; não há consumer atual que exija esses PNGs. |

## Referências sem consumer no escopo atual

| Arquivo | Relação com o vault | Decisão |
|---|---|---|
| `Astherion.png` | NPC/antagonista existente | backlog de expansão; não gerar enquanto não houver `asset_id`. |
| `bela.png` | provável Bella | confirmar grafia e identidade antes de qualquer mapeamento. |
| `Erik.png` | Erik Blackthorn | backlog de expansão. |
| `Eroth.png` | há conflito de atribuição no vault | não usar até resolução canônica; o vault adverte para não atribuir Eroth ao sacerdote do ritual sem validação. |
| `Gilly.png` | NPC existente | backlog de expansão. |
| `Helion.png` | Mago Helion | backlog de expansão. |
| `Hrothgar.png` | NPC existente | backlog de expansão. |
| `kein.png` | Kein/Elias | backlog de expansão. |
| `Martim Mandela.png` | NPC existente | backlog de expansão. |
| `thalion.jpg` | Thalion Aetherion | backlog de expansão. |
| `Willie.png` | NPC/criatura ligado às Docas | backlog; caso vire inimigo, criar spec e `asset_id` primeiro. |

## Regras de uso das referências

- Prioridade de verdade: vault canônico → dados e mecânica do jogo → referência visual aprovada → prompt derivado.
- A pasta do Desktop não será copiada em massa para o projeto.
- Antes de uma geração que anexe referência local, registrar no manifesto: arquivo, personagem/asset, papel da referência e características autorizadas.
- Como `add.yaml` define `remote_context: review-before-remote`, anexar qualquer imagem local a um serviço de geração exige gate explícito do dono por lote.
- A imagem anexada deve ser a menor seleção necessária; nunca enviar a pasta completa.
- Se a referência contradizer o vault, pausar o asset e registrar a divergência; não resolver por estética.
- Selos, fundos verdes, texto e marcas não podem sobreviver ao asset final.

## Impacto nos prompts existentes

- `ART-PROMPTS-002` precisa passar de “cinco retratos faltantes” para **dez retratos harmonizados**, usando nove identidades locais e Nyrelia derivada do vault.
- Deve ser criado um pacote específico para os dez sprites de run.
- Os dez sprites legados de inimigo devem receber prompts de remaster condicional, pois a câmera frontal pode destoar do novo conjunto isométrico.
- As três cenas de tela devem ganhar prompts próprios.
- Ícones de habilidades ativas e regras de camada surgiram depois de `SPEC-011` e precisam entrar no catálogo.

