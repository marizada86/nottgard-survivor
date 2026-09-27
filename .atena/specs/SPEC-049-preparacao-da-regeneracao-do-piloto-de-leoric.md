# SPEC-049 — Preparação da regeneração do piloto de Leoric

Status: **concluída — lote admitido como oficial** (2026-09-27).

## Intenção

Preparar de forma local, rastreável e reversível o piloto do PLAN-016: quatro
frames de `idle`, seis de `move_se` e quatro de `attack`. Esta SPEC não gera
imagens, não transfere referências e não altera assets oficiais.

## Escopo

- Congelar as quatro referências, seus hashes, prompts e negativos no brief.
- Preparar 14 IDs de célula, ordem, pose, formato e critérios de descarte.
- Definir inspeção, montagem dos candidatos, QA runtime, seleção e admissão.

## Não objetivos

- Chamar serviço de geração, configurar credencial, aceitar licença, enviar
  arquivos, gastar créditos ou criar um job.
- Montar strips, copiar PNGs ou alterar arquivos sob `assets/`.
- Alterar dados, lore, Sopro de Estrela, Constelação, SFX, cenas ou gameplay.

## Contratos

1. Cada célula é RGBA 256×384, sem fundo, com pé em y=367 e margem lateral
   mínima de 8 px; os frames de `idle`/`attack` são quatro, os de `move_se`,
   seis.
2. Leoric permanece adulto e reconhecível: chapéu largo, barba grisalha,
   manto verde-musgo, detalhes dourados e foco azul. Nenhum frame pode ser só
   traço ou VFX.
3. Candidatos ficam somente em `.atena/generated/leoric-regeneration/v01/`.
4. Seleção artística e admissão nos paths oficiais são gates independentes.

## Critérios de aceite

1. O brief identifica as 14 células, referências, dimensões, poses, negativos
   e condições de descarte sem ambiguidade.
2. Não há fornecedor, licença, custo ou job inferidos.
3. A preparação não modifica os nove PNGs, lock ou registros oficiais.

## Gates

- Aprovar esta SPEC prepara somente artefatos locais.
- Autorização posterior de geração define método, licença, referências que
  podem sair do workspace, máximo de jobs e teto de gasto quando aplicável.
- Só uma admissão explícita pode substituir os arquivos oficiais.

## Reconciliação

- O dono aprovou a SPEC-049 em 2026-09-27.
- `PILOT-REQUEST-TEMPLATES-001.json` lista os 14 frames do piloto, ainda sem
  fornecedor, licença, custo ou autorização de geração.
- Após autorização do dono, o piloto foi gerado localmente pelo ImageGen
  integrado, normalizado em candidatos e passou nos contratos técnicos. A
  admissão nos arquivos oficiais continua bloqueada até seleção artística.
- O dono aprovou o piloto em 2026-09-27. Foram então gerados, normalizados e
  validados os seis strips restantes (`move_n`, `move_ne`, `move_e`, `move_s`,
  `active` e `death`) somente em `.atena/generated/`. O lote de nove strips
  candidatos soma 50 frames, todos com margem lateral de 8 px e base y=367.
- A evidência EVID-080 registra os hashes do lote e a captura runtime. Nenhum
  PNG oficial, lock ou registro canônico de Leoric foi alterado.
- O dono aprovou a admissão explícita em 2026-09-27. Os nove PNGs anteriores
  foram preservados, o lote v01 foi promovido, o Godot reimportou as texturas e
  `ASSET-OFFICIAL-LOCK-011.json`/registro canônico 011 documentam o resultado.
