# EVID-076 — Preparação local concluída da SPEC-046

Data: 2026-09-27.

## Verificação

- `PILOT-REQUEST-TEMPLATES-001.json` foi lido como JSON válido e contém 14
  células: quatro de `idle`, seis de `move_se` e quatro de `attack`.
- `generation_authorized` é `false`; o campo de fornecedor permanece nulo e
  não há licença ou teto de gasto declarado.
- `PILOT-VALIDATION-POLICY-001.json` foi lido como JSON válido e fixa o
  contrato de célula RGBA 256×384, linha de base, margens, montagem e descarte.
- Os SHA-256 das cinco referências do `BRIEF-NYRELIA-REGEN-V01.md` foram
  recalculados contra os bytes atuais: zero divergências.

## Limites preservados

Não foi criado job, não foi acessada credencial, não houve transmissão de
referência, geração de imagem, gasto, aceite de licença, montagem de strip ou
alteração sob `assets/`. O próximo passo ainda exige autorização explícita do
dono que nomeie método/fornecedor, licença, referências transmissíveis,
quantidade máxima de jobs e teto de gasto quando aplicável.
