# BRIEF-NYRELIA-REGEN-V01

Status: **local e não executado**. Este documento não é uma solicitação a fornecedor e nenhuma referência saiu do workspace.

## Referências bloqueadas

| Papel | Arquivo | Dimensão | SHA-256 |
| --- | --- | --- | --- |
| Identidade | `assets/portraits/nyrelia.png` | 640×427 | `94b0c29b3d1e6e04a561e97fcbb33f21acd52e01f75fbc37e7e0a4d2527495f7` |
| Silhueta estática | `assets/heroes/nyrelia.png` | 256×384 | `278a1e35ab4db1067c9a130f34e8ea7d720b32af7bfe780ebd8d6f73e22578f3` |
| Arma/poder | `assets/icons/weapons/dominar_pessoa.png` | 128×128 | `49935fbab37cacc7dafe92ce1c2ea991f2db6b85eadd027839d92db8524be316` |
| Falha em runtime | `.atena/evidence/SPEC-045-nyrelia-qa-baseline-v3.png` | 1280×720 | `d1167a81f684dbe707a914f43f206a7e495d009f6ed68e168c42c2b476550a58` |
| Frames do piloto | `.atena/evidence/SPEC-045-nyrelia-pilot-frames.png` | 1280×720 | `ab5eb299c476d8f9c90017afc6fd08d8480617a14c0bc97b7052452ceca1de10` |

## Contrato comum

- Pixel art 2D, câmera isométrica 3/4 de cima e fundo RGBA transparente.
- Célula 256×384 px; base corporal visível em `y=367`; margem lateral mínima de 8 px para corpo, máscara, mão, arma e VFX essencial.
- Nyrelia: sacerdotisa mascarada de Mask, capuz e manto verde-floresta, máscara escura distinta, corpo preenchido e legível, detalhes dourados controlados.
- A leitura deve sobreviver à escala de 72 px: manto e máscara reconhecíveis, sem personagem reduzida a pontos dourados sobre fundo escuro.
- Sem cenário, texto, borda, marca d'água, personagem extra ou preenchimento opaco fora da figura.

## Prompt-base

Sprite 2D de fantasia sombria em pixel art nítida, visão isométrica 3/4 de cima. Nyrelia, sacerdotisa mascarada de Mask, capuz e manto verde-floresta profundo, máscara escura claramente definida, rosto oculto, corpo e dobras de tecido visíveis, acentos dourados discretos, silhueta forte e legível em 72 pixels, luz de recorte verde-ouro controlada, fundo transparente, célula única 256 por 384 pixels, pés firmemente apoiados na linha de chão.

## Negativo comum

Fundo de cenário, retrato, concept art, texto, moldura, marca d'água, personagem sem corpo, silhueta preta perdida, apenas partículas, membros cortados, arma cruzando borda, blur, gradiente suave, perspectiva frontal, VFX fora da célula, múltiplos personagens.

## Piloto por célula

| Grupo | Frames | Complemento de pose |
| --- | ---: | --- |
| `idle` | 0–3 | Respiração contida; manto pesado e máscara reconhecível; brilho sutil sem apagar o corpo. |
| `move_se` | 0–5 | Caminhada diagonal para sudeste; passada clara, pés alternados apoiados e manto sem levitar. |
| `attack` | 0–3 | Preparar, estender a mão, liberar Dominação e recuperar; corpo e máscara claros; anel verde-amarelo/violeta curto junto à mão. |

## Entrega esperada

- 14 PNGs individuais, um por célula, antes de qualquer montagem de strip.
- Proveniência por saída: método/fornecedor, job ou seed quando existir, prompt final, parâmetros, licença, data e SHA-256.
- Candidatos ficam sob `.atena/generated/nyrelia-regeneration/v01/`; nenhum arquivo pode ter destino em `assets/` nesta fase.

## Decisões pendentes

- Método de produção e fornecedor, se houver.
- Licença da saída.
- Referências que podem ser transmitidas a serviço externo.
- Número máximo de jobs e teto de gasto, quando aplicável.
