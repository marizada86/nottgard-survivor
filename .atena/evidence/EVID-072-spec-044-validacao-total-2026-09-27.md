# EVID-072 — Validação integral dos registros da SPEC-044

Data: 2026-09-27.

Esta evidência encerra a validação técnica e visual de todos os registros
cobertos pela SPEC-044. Ela não constitui aprovação artística e não promove
nenhum PNG pendente a oficial.

## Cobertura e integridade

- `ASSET-AUDIT-001.json` foi regenerado: 267 registros de produção, todos
  verificáveis por arquivo final e SHA-256. A diferença histórica entre os
  267 registros e os 266 PNGs esperados continua documentada e não foi
  ocultada.
- `HERO-ANIMATION-AUDIT-001.json` foi regenerado: 90 sequências-fonte de
  heróis, todas com arquivo final, candidata recuperável e contrato de frames
  compatível.
- `ASSET-OFFICIAL-LOCK-009.json` foi conferido de forma independente: 126
  entradas oficiais e zero divergências de SHA-256 contra os bytes atuais.

## Metadados e revisão visual

Oito registros de produção não declaram dimensões e alfa no manifesto:
`martelo_da_gloria`, `machado_de_xargath`, `lamina_da_digestao`,
`colar_dos_tentaculos`, `cajado_dos_desejos`, `chicote_avarento`,
`sopro_de_estrela` e `ampulheta`. Os respectivos PNGs presentes são
128x128 com alfa; trata-se de lacuna de metadado histórico, não de divergência
do arquivo. A correção do manifesto fica fora desta validação e exige decisão
específica.

Foram inspecionadas as 21 pranchas de revisão que cobrem os 231 PNGs de
produção ainda não oficiais. Não foi observado PNG vazio, corrompido ou com
corte evidente. A inspeção visual confirma apresentabilidade técnica dos
cartões, não adequação estética, lore, runtime ou placement.

Os assets já oficiais continuam sujeitos às ressalvas canônicas de Nyrelia,
Leoric e rochas. A regra de placement permanece inalterada: nenhum prop é
aprovado para água corrente ou rasa do rio Estige, mesmo quando seu PNG for
oficial.

## Verificações de runtime

- `tests/run_all.gd`: 0 falhas.
- `tools/smoke.tscn`: as nove fases concluíram com `smoke: ok`.

As duas execuções headless registraram indisponibilidade do arquivo de log e
da store de certificados do ambiente. O smoke também encerrou com quatro
instâncias ObjectDB e dois recursos ainda em uso. Esses avisos não impediram
os resultados acima, mas devem ser tratados separadamente se passarem a afetar
execuções de jogo ou a política de limpeza de recursos.

## Estado após a validação

Há 126 entradas oficialmente travadas e 231 registros de produção tecnicamente
validados, porém ainda pendentes de decisão humana por lote. Nenhum arquivo,
cena, placement, código ou manifesto histórico foi alterado nesta etapa.
