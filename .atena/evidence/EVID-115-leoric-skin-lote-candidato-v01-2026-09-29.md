# EVID-115 — Lote candidato da skin de Leoric v01

Data: 2026-09-29  
SPEC: `SPEC-082-skin-leoric-cartola-e-sobretudo`  
Estado: **candidato local validado; não oficial; aguardando decisão de admissão**.

## Escopo e método

O dono aprovou o piloto v01 e autorizou a expansão. O gerador integrado produziu
oito strips em área local a partir da identidade aprovada de Leoric e do
contrato de movimento dos strips existentes. Os arquivos brutos foram
preservados em `candidates/expansion/`. A normalização em
`normalized/expansion/` ajustou somente escala, margens e base, sem tocar nos
arquivos sob `assets/`.

O lote final contém os nove strips e 50 frames previstos: os quatro frames de
`idle` do piloto, mais 46 frames nesta expansão.

## Candidatos da expansão

| Strip | Frames | Path normalizado | SHA-256 |
| --- | ---: | --- | --- |
| `move_n` | 6 | `normalized/expansion/move_n_v02.png` | `fe4a7b4b293e9d953878a000a6dc60c225ba457570981a055a49161211cc4c89` |
| `move_ne` | 6 | `normalized/expansion/move_ne_v02.png` | `15aeffd6005676efa6ee218c758820d557b663dc860ea20c7f0e3e82e71d0b60` |
| `move_e` | 6 | `normalized/expansion/move_e_v02.png` | `855c15630b38341b379a07e89e315deb0c287dca6ec374b644cdfff27796341d` |
| `move_se` | 6 | `normalized/expansion/move_se_v02.png` | `4186e9d4f6b1da76b62081157e5d1fef5e476f1b100f4edd818c7f4603b04b47` |
| `move_s` | 6 | `normalized/expansion/move_s_v02.png` | `5919a70b97700c1798e69ed40e17a3f8051813a3ccf1c20552ac68ae32cc28fe` |
| `attack` | 4 | `normalized/expansion/attack_v02.png` | `cebc4537a915365ed1a256eadaf403eaec2a67606d540317c4fcb476948813ef` |
| `active` | 6 | `normalized/expansion/active_v02.png` | `3806607ef2b29148d2cd11007d3c335d47f5df76e0649e90b057204da17cf9b5` |
| `death` | 6 | `normalized/expansion/death_v02.png` | `bccf908adcbe5aefa75980a1c253817f96d05edf689d0cc91e8e5001b41114c7` |

Todos são PNG RGBA; `attack` mede 1024×384 e os demais medem 1536×384.

## Auditoria

| Checagem | Resultado |
| --- | --- |
| Strips revisados | 8 |
| Frames revisados | 46 |
| Alfa | Presente nos oito PNGs normalizados. |
| Base | Cada frame termina em y=367. |
| Margens laterais | Cada frame tem ao menos 8 px em ambos os lados. |
| Falhas técnicas | 0. |
| Assets oficiais, lock e cânone | Sem alteração. |

## Próximo gate

O dono deve revisar visualmente o lote e decidir se autoriza a admissão. Somente
depois da ordem explícita serão preservados os onze oficiais atuais, promovidos
os candidatos, reimportados os recursos e executada a validação runtime.
