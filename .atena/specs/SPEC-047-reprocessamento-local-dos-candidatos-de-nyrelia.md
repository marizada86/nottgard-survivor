# SPEC-047 — Reprocessamento local dos candidatos de Nyrelia

Status: **concluída — candidatos rejeitados para admissão** (2026-09-27).

## Intenção

Testar se as nove folhas-fonte de Nyrelia já preservadas no projeto poderiam
recuperar a legibilidade em runtime por meio de recorte por quadro, escala
uniforme e alinhamento da base, sem gerar arte, transferir dados ou modificar
um asset oficial.

## Escopo

- Ler exclusivamente as nove folhas `*_v01_alpha.png` existentes.
- Produzir strips candidatos em `.atena/generated/nyrelia-reprocess/v01/strips/`.
- Usar células finais de 256×384, quatro frames em `idle`/`attack`, seis nos
  demais strips, margem inferior de 16 px e último pixel visível em y=367.
- Renderizar somente a prancha QA dos pilotos `idle`, `move_se` e `attack`.

## Não objetivos

- Gerar ou editar a arte-fonte; chamar serviço externo; gastar créditos.
- Copiar, sobrescrever ou admitir arquivos sob `assets/`.
- Atualizar locks ou registros canônicos.

## Critérios de aceite

1. Os candidatos permanecem fora de `assets/`.
2. Cada strip tem dimensão e contagem de células contratadas.
3. A prancha em escala de jogo permite avaliar corpo, máscara, manto, VFX e
   contato com o chão.
4. Promoção ocorre somente se os candidatos forem visualmente legíveis.

## Resultado e reconciliação

- Os nove strips foram produzidos e a prancha QA foi renderizada.
- Os arquivos oficiais mantiveram os hashes do lock verificado.
- A recropagem corrigiu a ocupação e a base técnica, mas não recuperou corpo
  preenchido, máscara ou manto nos pilotos; `attack` continua dominado por
  partículas. Portanto, nenhum candidato é elegível para admissão.
- A continuação apropriada é uma nova fonte artística ou retoque dirigido, não
  promover estes derivados.

Evidência: `EVID-077-reprocessamento-local-de-nyrelia-2026-09-27.md`.
