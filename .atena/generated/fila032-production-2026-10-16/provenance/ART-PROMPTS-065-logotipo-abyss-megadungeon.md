---
id: "ART-PROMPTS-065"
type: "prompts-de-arte"
title: "Logotipo do título com o nome novo: Nottgard - Abyss Megadungeon"
status: "ready-for-generation, G-1 resolvida (geração só com aprovação do dono); PRIORIDADE ALTA por pedido do dono em 2026-10-15"
state: "DRAFT"
revision: "r1"
created: "2026-10-15"
relations: ["[[SPEC-181-renomeacao-nottgard-abyss-megadungeon]]", "[[PLAN-106]]", "[[ART-PROMPTS-058-lettering-placas-e-cursor]]", "[[CHATGPT-FILA-032-logotipo-abyss-megadungeon]]", "[[PLAN-001-nottgard-survivors]]"]
sources: ["backlog ART-049", "assets/ui/title/logo.png (L01 de ART-PROMPTS-058)", "ui/title.gd (_build_logo, faixa 1280×176)", "assets/ui/title/title_background.png", "assets/ui/evolucao_painel_moldura.png"]
---

# Logotipo do título com o nome novo (ART-049)

> Derivado. Não autoriza geração por si; o dono aprova o início do lote. Fila operacional: [[CHATGPT-FILA-032-logotipo-abyss-megadungeon]].

## Inventário: o que carrega o nome em arte

Conferido em 2026-10-15 no código e nos assets:

| Item | Carrega o nome? | Decisão |
|---|---|---|
| `assets/ui/title/logo.png` (L01) | **sim**, "NOTTGARD" e "SURVIVORS" na própria arte | **refazer** (esta peça, LN01) |
| `assets/ui/title/title_background.png` | não (sem texto, sem logo) | fica |
| `icon.svg` (ícone do app) | não (sem `<text>`) | fica |
| Cabeçalho do Quartel (`ui/menu.tscn`, `Title`) | não é arte: `Label` em Cinzel, já atualizado (SPEC-181) | fica |
| `Clique para jogar` (L02), banners, placas | não citam o nome | ficam |
| Capas, HQs, miniaturas, imagens de release | nenhuma com o nome | nada a fazer |

**Resultado: uma peça só (LN01).** O logo aparece apenas na tela de título; o Quartel usa fonte, então a exigência antiga de "ler a um terço do tamanho" deixa de valer.

## Prontidão visual (AGENTS.md)

| Item | Estado |
|---|---|
| Bíblia visual aplicável | quadro de estilo S-002 de [[ART-PROMPTS-058-lettering-placas-e-cursor]] (família, letras, sem lore inventada); DRAFT, sem mudança |
| Identidade de personagem/entidade | **N/A**: peça de lettering, sem entidade |
| Contexto de cena | textual: logotipo centralizado no alto da tela de título, sobre `title_background.png` (abismo roxo escuro, ruínas, brasas) |
| Referências e revisão | `logo.png` atual (aprovado como L01 em 2026-10-06), `title_background.png`, `evolucao_painel_moldura.png`; todas CANON no jogo |
| Lacunas BLOCKING | nenhuma. G-1 resolvida pelo dono (lockup sem hífen escrito) |

## Decisão do dono (G-1, resolvida: lockup recomendado, sem hífen escrito)

O nome oficial é **Nottgard - Abyss Megadungeon**. Como lockup em duas linhas, o traço fica implícito na diagramação:

- **Recomendado:** linha de cima `NOTTGARD`, linha de baixo `ABYSS MEGADUNGEON` (sem o hífen escrito).
- **Alternativa:** mesma coisa com um losango ou espinho pequeno centralizado entre as duas linhas no lugar do hífen (ainda sem símbolo escrito).
- Se preferir o hífen literal na arte, dizer; o prompt muda uma linha.

## Convenção (a de ART-PROMPTS-058)

- Fundo e vazios internos lisos **ciano #00FFFF** (a peça leva roxo; avisar na mensagem). Uma imagem por mensagem. O ciano é removido na admissão.
- Bordas duras contra a chave, sem sombra projetada, sem brilho que vaze do contorno.
- Até **3 candidatas**; cada nova tentativa corrige um defeito objetivo. Salvar em `.atena/generated/art-candidates/lettering/LN01_v01.png`. Nada entra em `assets/` antes da prévia em escala real.
- **Conferência de grafia:** ler letra a letra `NOTTGARD` e `ABYSS MEGADUNGEON` (17 letras, uma palavra de 7 e uma de 10). **Duas candidatas com erro = a peça cai para texto em fonte** (`Version.GAME_NAME` já alimenta o fallback do título).
- Marque `[x]` ao gerar e `[a]` ao aprovar.

## LN01 — `logo` v2

Destino: `assets/ui/title/logo.png` (substitui o atual; manter o mesmo nome para o `title.gd` não mudar). **Final até 1100×176 RGBA.** Pedir 3:2 (1536×1024) e cortar rente ao conteúdo.

- [ ] gerada · [ ] aprovada · chave **ciano #00FFFF**

Anexar, nesta ordem, dizendo o papel de cada uma:

1. `assets/ui/title/logo.png` — o logotipo atual: **a palavra NOTTGARD, o material, o bisel, as pontas góticas e a rachadura roxa são para manter**; só a linha de baixo muda.
2. `assets/ui/title/title_background.png` — clima e paleta (o logo vai por cima).
3. `assets/ui/evolucao_painel_moldura.png` — material e cor; não copiar a composição.

```text
Use case: stylized-concept
Asset type: logotipo do jogo "Nottgard - Abyss Megadungeon" para tela de título
Primary request: lockup em duas linhas centralizado, na mesma família do logotipo de referência: linha de cima "NOTTGARD" em capitais grandes idênticas em estilo e material às da referência; linha de baixo "ABYSS MEGADUNGEON" em capitais menores (cerca de 40% da altura da linha de cima), com espaço entre letras generoso para ler as dezessete letras; ouro velho forjado com bisel, contorno quase preto, rachadura fina de luz roxa abissal passando por trás das letras (dentro do contorno), pequenos espinhos e arcos góticos só nas duas pontas laterais, em simetria; proporção do conjunto entre 6:1 e 4:1
Style/medium: pixel art sombria densa, mesma família do logotipo de referência e do clima do fundo do título
Constraints: fundo e vazios lisos ciano #00FFFF; bordas duras sem anti-aliasing contra a chave; texto EXATAMENTE "NOTTGARD" e "ABYSS MEGADUNGEON", sem hífen, sem outras letras, números ou símbolos; a segunda linha com largura de cerca de 85% da primeira; sem sombra projetada nem brilho fora do contorno
Avoid: letras fundidas, "SURVIVORS" em qualquer lugar, ornamento cobrindo as letras, cursivo, 3D plástico, roxo saturado em excesso, runas, brasões
```

**Aceite (em escala real, na tela de título a 1280×720 e no celular):**

1. Texto lido letra a letra: `NOTTGARD` / `ABYSS MEGADUNGEON`; sem `SURVIVORS` nem letra extra.
2. A segunda linha lê a 1280×720 sem esforço (altura de letra ≥ 14 px na tela).
3. O ornamento lateral não invade o texto; o ouro lê sobre o fundo roxo escuro.
4. Coerente com os banners L03 a L05 e com o `title_background.png` ao lado.
5. Sem halo ciano (`tools/audit_candidate_alpha.gd`).

## Integração (fora deste documento)

Copiar a candidata aprovada para `assets/ui/title/logo.png` e rodar a importação do Godot. `ui/title.gd` já carrega `logo.png`; sem mudança de código. Verificar a faixa 1280×176 e a captura do título. Pede SPEC e aprovação do dono, como toda admissão de arte.