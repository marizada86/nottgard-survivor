---
id: "ART-PROMPTS-027"
type: "prompts-de-arte"
title: "HQs novas — guia de estilo e piloto 'Uma Noite Sem Fim'"
status: "candidatas aprovadas pelo dono — piloto hq_n01 pendente de integração; ondas de HQ seguem em ART-PROMPTS-028 e 029"
created: "2026-09-29"
relations: ["[[PLAN-040-hqs-novas-highlights-do-vault-2026-09-29]]", "[[SPEC-080-hqs-de-transicao-do-nottcard]]", "[[SPEC-062-fila-de-geracao-externa-de-assets]]"]
sources: ["nottgard-vault (github.com/marizada86/nottgard-vault): 01_Campanha, 16_Histórias, 10_Sessões", "Nottcard HQ-000 (guia de produção)", "Nottcard assets/hq/ (hq_001 a hq_003)", "assets/portraits/*.png"]
---

# HQs novas — guia de estilo e piloto

## O que este documento é

O guia visual comum a todas as HQs novas e os prompts do **piloto**, a HQ
"Uma Noite Sem Fim" (4 quadros). As demais HQs só ganham prompts depois que o
dono escolher o catálogo (PLAN-040). Fonte da narrativa: o vault de Nottgard
(`16_Histórias/Histórias de Nottgard - Aluris.md`, Prólogo e Capítulo 1, e a
Sessão 01). Nenhum fato novo foi inventado.

## Guia de estilo (derivado das HQs do Nottcard e do HQ-000)

Lido nas imagens `hq_001_q1`, `hq_002_q1` e `hq_003_q3` do Nottcard:

| Traço | Regra |
|---|---|
| Formato | 16:9 paisagem, tela cheia, **sem texto, balão, moldura, logo ou marca-d'água** (a interface compõe legenda e fala) |
| Técnica | ilustração sombria com acabamento de pixel art denso e dithering; sem suavização de pintura digital |
| Grupo | quase sempre **visto de costas**, em silhueta contra o cenário; reconhecível pela silhueta antes do detalhe |
| Câmera | alternar plano aberto (mundo), médio (grupo) e fechado (detalhe). Nunca quatro quadros com o mesmo enquadramento |
| Tarn | **barreira de energia azul**, nunca vidro, cristal ou céu solar (cortina de luz azul vertical) |
| Névoa | **verde-acinzentada** (corrupção comum); efeitos arcanos de corrupção em **roxo** |
| Luz | fogo âmbar discreto (tochas, lanternas); vermelho seco só como acento de perigo |
| Cenário | gótico, pedra molhada e reflexos, bandeiras vermelhas rasgadas |
| Respiro para a UI | terço inferior do quadro com pouca informação (a faixa de texto entra ali) |
| Conteúdo | sem gore explícito; violência sugerida por sombra, silhueta ou consequência |

### Regra de personagens (obrigatória)

O ChatGPT muda o rosto e a roupa entre mensagens. Para manter a identidade:

1. **Anexar o retrato de cada personagem do quadro** como imagem de referência:
   `assets/portraits/<herói>.png` (kayron, durvall, sylas, maelor, brook,
   korrak, leoric, zynara, bromnor, nyrelia).
2. Colar o quadro **na mesma conversa** dos demais quadros da HQ, em ordem.
3. Descrever no prompt só a **função** de cada figura, e nunca cabelo, pele ou
   roupa de memória: quem manda é a referência anexada.
4. Cabelo, pele, roupa e arma que aparecerem diferentes da referência
   reprovam o quadro (checklist HQ-000).

## Estrutura de cada prompt (parágrafo único, em inglês)

`[o que se vê e a ação]` + `[enquadramento e câmera]` + `[luz e cores da
regra acima]` + `[bloco de estilo fixo]` + `[restrições fixas]`.

**Bloco de estilo fixo:** *Dark-fantasy illustration with dense pixel-art finish
and controlled dithering, crisp pixel edges, no smooth painterly blur, wide
16:9 landscape composition.*

**Restrições fixas:** *No text, no letters, no speech bubbles, no captions, no
logo, no watermark, no frame or border, no UI. Keep the bottom third of the
image visually calm and uncluttered. Nothing important is cropped by the
edges. Characters must match the attached reference portraits exactly.*

---

## Piloto — `hq_n01` "Uma Noite Sem Fim"

- **Fecha:** nada (é a abertura).
- **Abre:** algo está errado nas Docas, e a Tarn tem uma rachadura.
- **Fonte:** Prólogo e Capítulo 1 de "Histórias de Nottgard — Aluris"; Sessão 01.
- **Elenco:** Kayron, Durvall, Sylas, Maelor (anexar os quatro retratos nos
  quadros 2, 3 e 4).
- **Spoilers proibidos:** identidade real de Adam, Astherion, o fato de
  Durvall ser receptáculo, qualquer coisa após a Sessão 01.

| Quadro | Função | Texto sugerido na UI (paráfrase do vault) |
|---|---|---|
| 1 | Recapitular | "Não é noite. É a ausência do dia, desde que a Finbulnott engoliu o sol." |
| 2 | Virar | Zynara: "Há algo errado nas Docas." |
| 3 | Apresentar | "Runas entalhadas na Tarn. Um ritual para enfraquecê-la." |
| 4 | Dar gancho | "Alguma coisa nos viu primeiro." |

### Quadro 1 — plano aberto, o mundo

> A vast wide shot of a city under an endless sunless night: a sky like a gray-green cloth stretched over rooftops, docks and temples, with no sun and no moon, only a pale sickly green glow leaking through the fog. In the far distance an enormous curtain of blue energy, the Tarn barrier, rises like a wall of light around the city and keeps the fog back. Tiny amber lanterns dot the streets far below. Camera high and wide, the city small, the sky heavy. Cold gray-green fog, a single blue barrier glow, small warm amber points. Dark-fantasy illustration with dense pixel-art finish and controlled dithering, crisp pixel edges, no smooth painterly blur, wide 16:9 landscape composition. No text, no letters, no speech bubbles, no captions, no logo, no watermark, no frame or border, no UI. Keep the bottom third of the image visually calm and uncluttered. Nothing important is cropped by the edges. No characters in this image.

### Quadro 2 — plano médio, o grupo nas Docas

> Four adventurers seen from behind, standing side by side on a quiet stone quay at the docks, looking out at rows of shuttered warehouses, stacked crates and empty piers beneath a low green-gray fog. The docks are strangely empty and silent, with a few hooded figures barely visible very far away and dark water at the edge of the frame. A cold wind lifts their cloaks. Camera at shoulder height behind the group, medium-wide shot, the group in dark silhouette against the pale fog, a faint blue glow of the Tarn on the horizon, small amber lanterns on the piers. Dark-fantasy illustration with dense pixel-art finish and controlled dithering, crisp pixel edges, no smooth painterly blur, wide 16:9 landscape composition. No text, no letters, no speech bubbles, no captions, no logo, no watermark, no frame or border, no UI. Keep the bottom third of the image visually calm and uncluttered. Nothing important is cropped by the edges. The four characters must match the attached reference portraits exactly.

### Quadro 3 — plano fechado, a rachadura na Tarn

> A close, low-angle shot of a jagged crack running through a wall of blue energy barrier where it meets the stone of the harbor, with carefully carved ritual runes glowing faintly around the crack and thin green fog seeping through it like smoke. In the foreground, a hand reaches out toward the crack and stops just short of touching it, while three other silhouettes behind lean forward. One silhouette stands slightly apart, unaffected and still, while the others stagger back as if struck by an unseen presence. The fog carries a faint hint of purple where it touches the runes. Camera close and low, the crack at the center, blue barrier light against dark stone, green fog, a hint of purple. Dark-fantasy illustration with dense pixel-art finish and controlled dithering, crisp pixel edges, no smooth painterly blur, wide 16:9 landscape composition. No text, no letters, no speech bubbles, no captions, no logo, no watermark, no frame or border, no UI. Keep the bottom third of the image visually calm and uncluttered. Nothing important is cropped by the edges. Characters must match the attached reference portraits exactly.

### Quadro 4 — gancho, a porta escondida

> A dark warehouse ruin beside the glowing blue barrier, with a hidden door half buried in stone at the base of the wall and a narrow stairway leading down into blackness. One dark-armored figure with long white hair stands at the entrance, seen from behind and slightly from the side, resting a hand on the cold stone as if listening to what waits below. Three other silhouettes wait a few steps behind, holding back. A single amber lantern on the ground lights the first steps and nothing beyond them. Camera medium-wide from behind and above, the doorway as the visual destination, deep shadow below, amber light on the stairs, blue barrier glow from the side, green fog at the floor. Dark-fantasy illustration with dense pixel-art finish and controlled dithering, crisp pixel edges, no smooth painterly blur, wide 16:9 landscape composition. No text, no letters, no speech bubbles, no captions, no logo, no watermark, no frame or border, no UI. Keep the bottom third of the image visually calm and uncluttered. Nothing important is cropped by the edges. Characters must match the attached reference portraits exactly.

## Critérios de aceite do piloto

1. Os quatro quadros leem como uma sequência: mundo, grupo, detalhe, gancho.
2. Tarn azul, névoa verde-acinzentada, luz âmbar, roxo só como acento.
3. Kayron, Durvall, Sylas e Maelor batem com os retratos anexados.
4. Sem texto, balão, moldura ou marca-d'água; terço inferior calmo.
5. Sem gore e sem nada posterior à Sessão 01.
6. Entrega: 4 PNGs 16:9 em `.atena/generated/art-candidates/hq/hq_n01_q1..q4.png`.
   Redimensionamento para 1280×720 e admissão só após aprovação do dono.

## Gate

As quatro candidatas do piloto `hq_n01` foram geradas e aprovadas pelo dono em
2026-09-29 e estão em `.atena/generated/art-candidates/hq/`. A integração
continua pendente da implementação da HQ e da validação de fidelidade aos
retratos.
