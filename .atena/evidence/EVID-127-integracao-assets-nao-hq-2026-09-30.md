# EVID-127 - Integracao dos assets nao-HQ do Lote 2

Data: 2026-09-30
Spec: `[[SPEC-100-integracao-estruturas-e-decais-docas]]`
Plano: `[[PLAN-047-integrar-assets-nao-hq-restantes]]`

## Resultado

- Admitidas nove estruturas, uma por bioma, em `assets/props/`.
- Admitidos `docas_remendo_01.png` e `docas_trilha_01.png` em
  `assets/decals/`; Docas continua desabilitada no renderer ate haver ancora
  seca validada.
- Estruturas usam a camada y-sorted e nunca entram nos blockers. A busca de
  posicao rejeita agua, terreno bloqueado, proximidade do ponto inicial e
  proximidade dos blockers existentes; se nao encontrar tile, nao cria o prop.
- Os 16 decais previamente admitidos e a integracao da animacao da cultista
  foram preservados. Todas as HQs/candidatas de quadrinhos ficaram fora do
  escopo e nao foram incluidas no conjunto de arquivos.

## Integridade e ancora

- O builder le os PNGs normalizados em `.atena/generated/` e nao altera os
  candidatos brutos ou normalizados.
- Nove estruturas: PNG RGBA 256x256. Dois decais de Docas: PNG RGBA 256x128.
- Os cantos externos dos onze arquivos oficiais foram verificados com alfa 0;
  as bordas transparentes passaram tambem na validacao da suite.
- As nove âncoras de contato em `data/prop_visuals.json` foram medidas pela
  ultima linha de alfa com cobertura de pelo menos 0.30 e estao cobertas pelo
  teste de tolerancia de contato.

## Verificacao

- `godot --headless --path . -s tests/run_all.gd` - 0 falhas.
- `godot --headless --path . tools/smoke.tscn` - `smoke: ok` em todos os nove
  biomas; cada cena iniciou em estado `running`.
- Inspecao visual das nove estruturas confirmou silhuetas isoladas, paleta e
  bases legiveis em 256 px.
- Godot retornou avisos ambientais de permissao para `user://logs/godot.log`
  e leitura do certificado raiz; ambos os comandos terminaram com codigo 0.

## Git e reconciliacao

HQs excluidas conforme o escopo aprovado. O commit anterior
`20ba29c feat(assets): integrate cultista adaga animations` permanece na
branch. O commit `8c1e497 feat(assets): integrate lote 2 structures` foi
enviado para `origin/codex/cultista-adaga-animation`; o branch local agora
acompanha o branch remoto.

O servidor aceitou o push pelo remote configurado, mas informou que o
repositorio mudou de endereco e recomendou
`https://github.com/marizada86/nottgard-survivor.git` para operacoes futuras.
O remote local nao foi alterado nesta entrega.
