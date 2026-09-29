# BRIEF-ZUMBI-REGEN-V01

Status: **local e não executado**.
SPEC: `SPEC-061-preparacao-da-regeneracao-do-piloto-de-zumbi.md` (aprovada
2026-09-28; esta preparação, não a geração).

## Referências bloqueadas

| Papel | Arquivo | Dimensão | SHA-256 |
| --- | --- | --- | --- |
| Silhueta estática (fallback) | `assets/enemies/zumbi.png` | 320×480 | `ca7a2a7e829de5a64f12d023934500222c85badc90c09b42eafd4b89e8524f39` |
| Folha `idle` oficial | `assets/animations/enemies/zumbi/idle.png` | 1024×384 | `6c484000ba2c539a3ba048d8aec4cb8494e91fefb1a6d33d772b90f49b482f9d` |
| Folha `move` oficial | `assets/animations/enemies/zumbi/move.png` | 1536×384 | `9423ee11f5d5af0a547520eba3a0eda50d62c5d1adfe0b91ff4294837284366a` |
| Folha `attack` oficial | `assets/animations/enemies/zumbi/attack.png` | 1024×384 | `e431e367a72eb12f892198cc1e1f2d7f755806e9ca7fedd6553bd70e62e7c789` |
| Folha `death` oficial | `assets/animations/enemies/zumbi/death.png` | 1536×384 | `42293346044e451436e65ed5ae68f0cec26619fa2759f36e89199306c33b269e` |

Sem captura de falha em anexo desta vez: o relato veio por texto no
questionário de playtest ([[EVID-091-playtest-higo-hiago-build-c-e-item-offer-2026-09-28]]),
não por screenshot do kit de evidências. A auditoria de código (mesma
evidência) confirma dimensão/grade corretas e que
[[SPEC-038-integridade-visual-dos-inimigos]] já passa no teste automatizado de
alfa/conteúdo visível para os quatro arquivos acima — o defeito relatado é de
cobertura de opacidade dentro da arte, não de integridade de arquivo.

## Contrato visual

Pixel art 2D de fantasia sombria, câmera isométrica 3/4, célula RGBA
256×384 sem cenário, texto, moldura, sombra ou watermark. Zumbi é um cadáver
humano comum movido pela névoa: roupas portuárias rasgadas, pele cinza,
postura curvada; sem gore excessivo (brief de
`ART-PROMPTS-011-herois-run-e-inimigos-legado.md`). Corpo preenchido e legível
em 62 px de altura de exibição (`H_BASE` de `ui/enemy_view.gd`); pés na base
da célula (sem margem extra de rodapé — Zumbi não usa a âncora especial de
Nyrelia).

## Piloto (20 células — idle, move, attack, death completos)

| Strip | Frames | Direção/ação |
| --- | ---: | --- |
| `idle` | 0–3 | Postura parada, leve balanço da névoa/roupas, respiração morta contida. |
| `move` | 0–5 | Caminhada arrastada, postura curvada, passos assimétricos característicos de zumbi. |
| `attack` | 0–3 | Aproximação, investida/golpe curto, recuperação. |
| `death` | 0–5 | Colapso progressivo até o corpo cair; sem desmembramento. |

## Negativo

Fundo, cenário, texto, moldura, watermark, arte conceitual, chibi, corpo
fragmentado, apenas traços, apenas partículas, roupa ou pele ausente/incolor,
efeito/névoa cobrindo o corpo inteiro, membros cortados, blur, gradiente
suave, personagem extra, arma/VFX cruzando borda de célula, silhueta translúcida
ou com cobertura de opacidade esparsa (o defeito relatado a evitar).

## Condições de descarte

- Frame com cobertura de opacidade abaixo do que é visualmente sólido a olho
  nu em escala de jogo (não só "tem algum pixel não-transparente").
- Frame fora da célula 256×384, com pé fora da base ou margem lateral menor
  que 8 px.
- Frame que perca a identidade de cadáver portuário cinza (cor, roupas ou
  postura) descrita no contrato visual.
- Qualquer frame com pessoa/personagem extra, cenário ou texto.
