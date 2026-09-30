# BRIEF-LEORIC-SKIN-CARTOLA-V01

Status: **lote completo v01 pronto para revisão; admissão bloqueada**.

## Referência e privacidade

| Papel | Origem | Uso autorizado agora |
| --- | --- | --- |
| Direção da skin | Imagem anexada pelo dono nesta conversa | Consulta local pela equipe; sem cópia, hash ou transferência. |
| Baseline oficial | `ASSET-OFFICIAL-LOCK-011` e registro 011 de Leoric | Consulta local. |
| Sprite atual | `assets/heroes/leoric.png` | Consulta local. |
| Retrato atual | `assets/portraits/leoric.png` | Consulta local. |
| Animações atuais | `assets/animations/heroes/leoric/` | Consulta local. |

Não há arquivo local da imagem anexada neste workspace. Se um método de geração
precisar recebê-la, o dono deverá autorizar essa transferência de modo explícito
antes de qualquer job.

Em 2026-09-29, o dono reenviou a referência e autorizou sua transferência ao
gerador integrado. O input usado é registrado por hash na EVID-114. A imagem
não foi copiada para o workspace.

## Direção visual

Pixel art 2D de fantasia sombria, câmera isométrica 3/4, com fundo RGBA
transparente. Leoric é um gnomo adulto de barba grisalha nítida. Usa **cartola
preta** de copa e aba bem definidas e **sobretudo marrom** com leitura clara.
A roupa deve formar uma massa corporal preenchida, coerente em todas as
direções, sem tornar o personagem chibi nem alterar sua postura jogável.

## Âncoras que permanecem

- Barba grisalha, rosto e orelhas legíveis.
- Proporção adulta, postura aventureira e arma/foco já associados a Leoric.
- Câmera isométrica 3/4, pés apoiados e silhueta legível em 72 px.
- Foco azul e constelações douradas, somente como acentos pequenos se o piloto
  demonstrar que não conflitam com a nova roupa.

## Traços removidos

- Chapéu de mago pontudo ou de aba larga.
- Manto verde-musgo como peça dominante.
- Qualquer leitura em que o VFX, a cartola ou a gola esconda rosto, barba ou
  contorno corporal.

## Contrato técnico

- Sprite de seleção: manter o formato contratado pelo asset atual.
- Retrato: manter o formato contratado pelo asset atual e a mesma identidade
  da animação.
- Animações: células RGBA 256×384, pé em y=367, margem lateral mínima de 8 px.
- `idle`/`attack`: 4 frames. Demais strips: 6 frames. Sem cruzar células.
- Sem fundo, cenário, texto, moldura, watermark, blur ou gradiente suave.

## Piloto autorizado para planejamento (não para geração)

| Artefato | Conteúdo a validar | Gate posterior |
| --- | --- | --- |
| Sprite de seleção | Cartola, sobretudo, barba e silhueta em escala de jogo | Aceite visual do dono. |
| Retrato | Mesmo rosto, cartola e sobretudo do sprite | Aceite visual do dono. |
| `idle`, frames 0–3 | Leitura da roupa durante respiração e mudança de peso | Aceite visual e técnico do dono. |

## Matriz de expansão após aceite do piloto

| Artefatos | Quantidade | Validação central |
| --- | ---: | --- |
| `move_n`, `move_ne`, `move_e`, `move_se`, `move_s` | 5 strips × 6 frames | Cartola não vaza; sobretudo acompanha o passo; base estável. |
| `attack` | 4 frames | Foco/VFX não encobre cartola, barba ou sobretudo. |
| `active`, `death` | 2 strips × 6 frames | Identidade continua legível em ação e queda. |

## Negativo

Chapéu de mago, chapéu pontudo, aba larga de mago, manto verde-musgo dominante,
fundo, cenário, texto, moldura, watermark, chibi, personagem extra, corpo
fragmentado, apenas traços, VFX cobrindo o personagem, rosto/barba ocultos,
membros cortados, cartola fora da célula, blur, gradiente suave, célula invadida.

## Lote preparado

Após o aceite artístico do piloto, foram produzidos e normalizados os strips
`move_n`, `move_ne`, `move_e`, `move_se`, `move_s`, `attack`, `active` e
`death`. Os candidatos finais estão em `normalized/expansion/`; os brutos
permanecem em `candidates/expansion/`. A EVID-115 registra hashes, formato e
resultado da auditoria de 46 frames.

## Próxima autorização necessária

Autorizar ou rejeitar a admissão do lote aos assets oficiais. A promoção exige
backup verificável, reimportação no Godot, testes, captura runtime e atualização
posterior de locks/registro; nada disso foi feito ainda.
