# SPEC-046 — Preparação da regeneração do piloto de Nyrelia

Status: **preparação local concluída — geração bloqueada por gate** (2026-09-27).

## Intenção

Preparar de forma local, rastreável e reversível a regeneração do piloto de Nyrelia definido no PLAN-015: quatro frames de `idle`, seis de `move_se` e quatro de `attack`. Esta SPEC prepara brief, referências e formatos de pedido; não gera imagens, não transfere arquivos, não consome orçamento e não altera assets oficiais.

## Escopo

- Congelar `BRIEF-NYRELIA-REGEN-V01.md` e os hashes de cinco referências.
- Preparar IDs, dimensões, ordem de frames, prompts, negativos e critérios de descarte para 14 células individuais.
- Criar estrutura local para resultados e recibos futuros.
- Definir inspeção, montagem de candidatos, QA runtime, seleção e admissão posterior.

## Não objetivos

- Executar geração local, hospedada ou remota; configurar credencial; escolher fornecedor; aceitar licença; enviar referência; criar job ou gastar créditos.
- Normalizar, montar, copiar ou sobrescrever PNGs.
- Alterar identidade, runtime, SFX, dados, cenas, gameplay, lock ou registros canônicos atuais.

## Contratos

1. A entrada do piloto são 14 células RGBA 256×384; saída de fornecedor nunca é candidata até passar pela inspeção local.
2. O brief e cada pedido têm versão, referência por SHA-256, prompt/negativo e ID de célula. Seed/job, método e licença serão obrigatórios quando existirem, não valores inventados agora.
3. Somente arquivos sob `.atena/generated/nyrelia-regeneration/v01/` podem ser criados neste ciclo antes da admissão humana.
4. A montagem em strips ocorre somente após inspeção de células individuais e nunca substitui `assets/`.
5. Hash, imagem, testes ou QA aprovados não equivalem a aceite artístico.

## Plano de voo

1. Conferir referências, hashes e contratos do brief local.
2. Criar template de pedido por célula e política de validação, sem registrar fornecedor, licença ou custo fictícios.
3. Após autorização de geração, descobrir a capacidade do método escolhido, confirmar referências transmissíveis, licença, máximo de jobs e teto de gasto; só então criar ou submeter jobs.
4. Inspecionar cada PNG recebido e montar apenas candidatos recuperáveis.
5. Renderizar cenas QA, apresentar o piloto para escolha humana e, se aceito, iniciar SPEC distinta de admissão.

## Critérios de aceite

1. O brief identifica as 14 células sem ambiguidade sobre frame, pose, dimensão, fundo, base ou margem.
2. Cada referência possui caminho, finalidade e SHA-256 verificável.
3. Não há fornecedor, credencial, custo, licença ou job inferidos.
4. O fluxo impede escrita em `assets/` antes de decisão de admissão.
5. PLAN-015, SPEC-045 e EVID-074 sustentam o piloto sem reclassificar fatos canônicos.

## Gates

- Aprovar esta SPEC autoriza somente criar templates locais e verificar artefatos do brief.
- Uma autorização posterior de geração deve nomear método/fornecedor, licença, referências que podem sair do workspace, máximo de jobs e teto de gasto quando houver custo.
- Aprovar candidato e admitir strip são gates independentes e exigem decisão humana explícita.

## Reconciliação da preparação

- O dono aprovou a SPEC-046 em 2026-09-27.
- `PILOT-REQUEST-TEMPLATES-001.json` define os 14 IDs de célula, poses,
  prompts e destinos locais ainda vazios; seu campo `generation_authorized` é
  `false` e não há fornecedor, licença ou orçamento preenchidos.
- `PILOT-VALIDATION-POLICY-001.json` fixa os contratos de células, montagem e
  descarte antes de qualquer recebimento de imagem.
- Os hashes das cinco referências do brief foram revalidados. `EVID-076`
  registra a conclusão; não houve job, transferência, gasto ou troca de bytes.
