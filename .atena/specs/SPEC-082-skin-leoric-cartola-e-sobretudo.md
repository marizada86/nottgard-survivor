# SPEC-082 — Skin de Leoric: cartola preta e sobretudo marrom

Status: **concluída e reconciliada**
(2026-09-29).

## Intenção aprovada

Substituir a leitura de mago de Leoric por uma skin de cartola preta e
sobretudo marrom, orientada pela referência anexada pelo dono nesta conversa.
A alteração permanece estritamente visual: Leoric conserva barba grisalha,
proporção adulta, visão isométrica 3/4 e identidade jogável.

## Escopo

- Preparar um brief local e uma matriz de validação para o sprite de seleção,
  retrato e nove strips de animação de Leoric.
- Definir um piloto reversível composto por sprite de seleção, retrato e
  `idle` com quatro frames.
- Fixar os contratos de formato, leitura, transparência e animação que os
  candidatos deverão cumprir.
- Preservar `ASSET-OFFICIAL-LOCK-011` como baseline dos oficiais atuais.

## Não objetivos

- Gerar, editar, normalizar, copiar ou promover qualquer PNG.
- Enviar a referência anexada ou outro arquivo do workspace a serviço externo.
- Contratar fornecedor, aceitar licença, gastar créditos ou iniciar job.
- Alterar lore, dados, habilidades, SFX, cenas, UI, colisão ou gameplay.
- Criar sistema de seleção de skins, cosméticos ou variantes de Leoric.

## Contratos

1. A cartola é preta, com copa e aba reconhecíveis, sem encobrir rosto, barba,
   orelhas ou ultrapassar a célula.
2. O sobretudo é marrom, com volume e contraste suficientes para leitura em
   72 px; o verde-musgo e o chapéu de mago deixam de ser traços ativos.
3. Os candidatos de runtime devem ser PNG RGBA, visão isométrica 3/4,
   célula 256×384, pés na base y=367 e margem lateral mínima de 8 px.
4. `idle` e `attack` têm quatro frames; `move_n`, `move_ne`, `move_e`,
   `move_se`, `move_s`, `active` e `death` têm seis. Ordem, direções e
   espelhamentos atuais não mudam.
5. Foco azul e constelações douradas são detalhes opcionais e discretos: só
   entram se não reduzirem a leitura da cartola e do sobretudo no piloto.
6. Todo candidato fica em `.atena/generated/leoric-skin-cartola/v01/`; nada
   sob `assets/` é modificado antes da admissão explícita.

## Critérios de aceite desta preparação

1. O brief identifica a referência, limites de transferência, traços a manter,
   traços a remover, negativos, formato e a matriz de onze artefatos.
2. A matriz explicita que o piloto contém somente sprite de seleção, retrato e
   os quatro frames de `idle`.
3. A SPEC e o brief não criam imagens, não modificam `assets/`, nem atualizam
   locks, registros canônicos ou evidências de admissão.
4. Os próximos gates distinguem geração local, aceite do piloto, expansão e
   admissão oficial.

## Plano de voo aprovado

1. Criar esta SPEC e o brief local — **concluído neste gate**.
2. Com autorização separada, definir método, licença, limite de custo e se a
   referência anexada pode sair do workspace; então gerar somente o piloto.
3. Submeter o piloto ao dono. Sem aceite, revisar o brief e não expandir.
4. Após aceite, gerar e validar as oito animações restantes fora de `assets/`.
5. Após admissão explícita, preservar os oficiais, promover os candidatos,
   reimportar, testar e reconciliar hashes, registro e evidência.

## Impactos previstos

| Área | Paths/registro | Estado neste gate |
| --- | --- | --- |
| Preparação | `.atena/generated/leoric-skin-cartola/v01/` | Brief local criado; sem imagens. |
| Seleção | `assets/heroes/leoric.png` | Preservado, sem alteração. |
| Retrato | `assets/portraits/leoric.png` | Preservado, sem alteração. |
| Animações | `assets/animations/heroes/leoric/*.png` | Preservados, sem alteração. |
| Baseline oficial | `ASSET-OFFICIAL-LOCK-011` | Preservado, sem alteração. |
| Cânone | registro de aprovação de Leoric | Preservado, sem alteração. |

## Evidência e reconciliação previstas

- Antes de admissão: ficha de piloto, hashes dos candidatos e prancha de
  revisão em `.atena/evidence/`.
- Na admissão: backup verificável dos oficiais atuais, captura runtime e lock
  sucessor contendo os hashes aprovados.
- Ao encerrar: registro canônico atualizado somente após ordem explícita do
  dono e após os critérios técnicos demonstrarem aceite.

## Estado de execução

- O dono reenviou a referência e autorizou seu uso no gerador integrado.
- Foram produzidos, fora de `assets/`, o sprite de seleção, o retrato e o strip
  de quatro frames `idle`.
- O primeiro sprite foi rejeitado durante a geração por parecer alto demais. A
  candidata v01 corrigida foi gerada como gnomo adulto baixo e compacto.
- Os candidatos normalizados preservam RGBA; seleção e os quatro frames de
  `idle` passaram nas margens laterais mínimas de 8 px e na base y=367.
- Nenhum asset oficial, lock, registro canônico, cena ou dado foi alterado.
- O dono aprovou artisticamente o piloto; foram então gerados os oito strips
  restantes em área local. Os 46 frames da expansão, após normalização,
  passaram em base y=367 e margem lateral mínima de 8 px.
- Com o `idle` aprovado, o lote candidato soma os nove strips e 50 frames;
  sprite de seleção e retrato continuam no mesmo diretório de candidatos.
- O dono autorizou a admissão explícita. Os onze candidatos foram promovidos
  aos paths oficiais após backup; `ASSET-OFFICIAL-LOCK-013` e o registro
  canônico 018 documentam a decisão.
- O smoke inicialmente revelou que `ui/run.gd` chamava `_texture()` sem defini-la.
  A pedido do dono, foi acrescentado o helper local com cache, sem alterar
  gameplay. O smoke percorreu as nove fases com `smoke: ok` e a suíte completa
  voltou a passar com zero falhas.

## Gate seguinte

A admissão e a validação runtime estão reconciliadas. Não há pendências nesta
SPEC; a mudança não foi commitada, publicada nem enviada remotamente.
