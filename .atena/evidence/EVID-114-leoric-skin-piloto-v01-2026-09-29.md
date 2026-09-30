# EVID-114 — Piloto da skin de Leoric v01

Data: 2026-09-29  
SPEC: `SPEC-082-skin-leoric-cartola-e-sobretudo`  
Estado: **candidato local; aguardando aceite artístico; não oficial**.

## Origem e método

- Referência do dono reenviada nesta conversa, SHA-256:
  `a92fcffc92a57583c338e160a33bc3c417b087efc52d49bccfbbe33edbeba750`.
- Método: gerador de imagens integrado, com a referência como guia de roupa e
  os assets atuais de Leoric como preservação de identidade/contrato.
- O primeiro sprite gerado tinha proporção excessivamente humana. Por pedido do
  dono, foi substituído pelo candidato baixo e compacto de gnomo adulto. A
  versão anterior permanece apenas no histórico do gerador; não foi admitida
  nem copiada para `assets/`.
- A referência externa não foi copiada para o workspace.

## Candidatos revisáveis

| Artefato | Path local | Dimensão | SHA-256 |
| --- | --- | --- | --- |
| Seleção alinhada | `.atena/generated/leoric-skin-cartola/v01/normalized/leoric_selection_v01_aligned.png` | 256×384 RGBA | `3fab61eb0cac451d71161d64f99b48033765739701a738b1a08a141e3774b4b9` |
| Retrato horizontal | `.atena/generated/leoric-skin-cartola/v01/normalized/leoric_portrait_v02.png` | 640×427 RGBA | `3f6a0dffa75f9bde211bc0b5da71e29212eec4b4c8b65cb943be171ea752b5dc` |
| Idle alinhado | `.atena/generated/leoric-skin-cartola/v01/normalized/leoric_idle_v01_aligned.png` | 1024×384 RGBA, 4 células | `f88443f7c3a55e84a2f49da77d0fd36070d6ccc39e843b58c9bc80d160c05b7b` |

As fontes antes de normalização permanecem em
`.atena/generated/leoric-skin-cartola/v01/candidates/` para rastreabilidade.

## Verificação técnica

| Item | Resultado |
| --- | --- |
| Transparência | Os três candidatos foram produzidos em `Format32bppArgb`; o pixel de canto é alfa 0. |
| Seleção | Margem esquerda 16 px, direita 8 px, base opaca y=367 — passou. |
| `idle` quadro 0 | Margens 26/8 px, base y=367 — passou. |
| `idle` quadro 1 | Margens 11/20 px, base y=367 — passou. |
| `idle` quadro 2 | Margens 10/26 px, base y=367 — passou. |
| `idle` quadro 3 | Margens 8/23 px, base y=367 — passou. |
| Integridade oficial | Nenhum PNG sob `assets/`, lock ou registro canônico foi escrito. |

## Revisão artística pendente

O dono deve avaliar se o piloto comunica um **gnomo adulto baixo e compacto**,
com cartola preta de faixa marrom, sobretudo marrom e barba grisalha, em todos
os três artefatos. O aceite libera apenas as oito animações restantes; não
autoriza a promoção aos arquivos oficiais.
