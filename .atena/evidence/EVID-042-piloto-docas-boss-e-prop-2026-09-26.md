# EVID-042 — Piloto de Docas: chefe e prop

Data: 2026-09-26  
Especificação: `SPEC-034`  
Plano: `PLAN-009`  
Prompts: `ART-PROMPTS-017`

## Resultado

Foram gerados três candidatos iniciais pelo fluxo embutido de geração de imagem.

| Asset | Resultado | Decisão |
|---|---|---|
| Splash do Sacerdote da Mente Derretida, v01 | Composição boa, mas acabamento pictórico/3D incompatível com o jogo. | Rejeitado; não persistido no projeto. |
| Splash do Sacerdote da Mente Derretida, v02 | Preserva a identidade do sprite: vestes roxas, cera pálida, olho laranja e turíbulo; pixel art e espaço de UI adequados. | Candidata, não integrada: `generated/art-candidates/boss-intros/sacerdote_mente_derretida_intro_v02.png`. |
| Braseiro das Docas, v01 | PNG RGBA, silhueta clara e luz quente localizada. | Candidata, não integrada: `generated/art-candidates/props/docas/braseiro_01_v01.png`. |

## Verificação técnica

- Splash v02: `1672×941`, imagem opaca; requer normalização para a resolução de uso antes de integração.
- Braseiro v01: `1254×1254`, `Format32bppArgb`; requer normalização para `256×256` e inspeção no mapa.
- Nenhum arquivo final em `assets/` foi substituído.

## Pendências

1. Refazer o atlas de piso com uma grade sem transparência nem espaçamento de apresentação.
2. Normalizar e verificar escala real das duas candidatas dentro de Dagruve/Docas.
3. Gerar as demais famílias previstas somente após o piloto passar na inspeção de integração.
