---
id: "ART-PROMPTS-062"
type: "prompts-de-arte"
title: "Botão de ação principal (JOGAR): moldura de nove fatias"
status: "ready-for-generation (geração só com aprovação do dono; cota de imagens)"
state: "DRAFT"
revision: "r1"
created: "2026-10-10"
relations: ["[[ART-PROMPTS-057-ficha-c-molduras-e-icones]]", "[[ART-PROMPTS-058-lettering-placas-e-cursor]]", "[[SPEC-165-sistema-de-ui-e-menu-de-pausa-mec-003]]", "[[SPEC-166-nova-ui-lote-2-quartel-selecao-e-titulo-mec-003]]", "[[CHATGPT-FILA-029-botao-de-acao-jogar]]"]
sources: ["backlog ART-047, MEC-003", "ui/menu.tscn (PlayBtn 320×58, fonte 28)", "ui/menu.gd (rótulo JOGAR / Bloqueado, glifo de controle)", "ui/ui_kit.gd", "ui/sheet_art.gd", "assets/ui/ficha/ficha_aba_moldura.png"]
---

# Botão de ação principal: JOGAR (ART-047)

> Derivado. Não autoriza geração por si; o dono aprova o início do lote. Fila operacional: [[CHATGPT-FILA-029-botao-de-acao-jogar]].

## Por que existe

O botão **JOGAR** do Quartel (`PlayBtn`) é hoje um `StyleBoxFlat` desenhado por código: fundo escuro e filete dourado fino. Funciona, mas é o único elemento de ação do Quartel sem moldura de arte, e as abas ao lado já usam `ficha_aba_moldura` (A05). A peça abaixo dá ao botão uma moldura própria, **mais encorpada que a aba**, para ele ler como ação principal.

**Uma peça só (B01).** O mesmo recorte serve para JOGAR, `HqPlayBtn` (Diário), Continuar e Fechar; tamanhos diferentes saem do esticamento de nove fatias. Botão secundário menor fica **fora** deste lote (decidir depois de ver B01 no jogo).

## O que o código faz com a peça (para o gerador não resolver o que é do código)

- **Texto**: o rótulo (`JOGAR`, `Bloqueado`) e o glifo do controle (32 px, à esquerda) são escritos pelo jogo. **A imagem não tem texto nem ícone.**
- **Estados** por tingimento (`modulate_color`) da mesma imagem: ouro velho (normal), mais claro (foco/hover), apagado (desabilitado). Por isso a moldura é **neutra, clara, sem cor própria**.
- **Interior**: preenchido na própria imagem com pedra escura lisa, para o rótulo claro ler bem em qualquer fundo do Quartel.

## Convenção (a de ART-PROMPTS-057)

- Fundo **fora da moldura** liso **magenta #FF00FF**; o magenta é removido na admissão. Uma imagem por mensagem. Sem texto, números, runas legíveis ou personagens.
- **Bordas duras contra o magenta**, sem sombra projetada, sem brilho que vaze do contorno (recorte limpo).
- Até **3 candidatas**; cada nova tentativa corrige **um defeito objetivo**. Salvar em `.atena/generated/art-candidates/botao-acao/B01_v01.png`; aprovada vai para `assets/ui/ficha/botao_acao_moldura.png` (junto das outras molduras que o `SheetArt` já carrega).
- Aprovar **em escala real no jogo** (Quartel a 1280×720 e no celular), nunca só no PNG isolado.
- Marque `[x]` ao gerar e `[a]` ao aprovar.

## Referências a anexar (papel de cada uma)

| Arquivo | Papel |
|---|---|
| `assets/ui/ficha/ficha_aba_moldura.png` | **Família da peça**: aço claro dessaturado, cantos chanfrados, filete interno escuro, rebites. O botão é o "irmão mais encorpado" desta aba; **não** copiar a espessura nem a proporção. |
| `assets/ui/ficha/ficha_moldura_detalhe.png` | Cantos em colchete pontiagudo e filete fino na borda interna; nível de ornamento aceito. |
| `assets/ui/evolucao_painel_moldura.png` | Material e cor (metal escuro, ouro velho, brilho âmbar nas bordas internas). **Não** copiar a composição. |

Opcional: uma captura do Quartel com o JOGAR atual, só como **contexto de uso** (posição e tamanho do botão); não copiar o visual.

---

## B01 — `botao_acao_moldura`

Destino: `assets/ui/ficha/botao_acao_moldura.png`, final **320×64 RGBA**, margens de recorte **28 (esq) / 28 (dir) / 20 (topo) / 20 (base)**. Gerar com cerca de **1536 px de largura** (proporção 5 para 1, aproximadamente 1536×307), recortar rente ao contorno e reduzir.

- [ ] gerada · [ ] aprovada

```text
Use case: stylized-concept
Asset type: moldura de botão de ação principal de interface de jogo, recortável em nove partes
Primary request: faixa retangular baixa e larga, mais encorpada que um botão de aba, de aço claro dessaturado com cantos chanfrados e filete interno escuro; dois pequenos rebites discretos perto de cada extremidade; em cada extremidade uma ponta gótica curta e simétrica (até 28 pixels em uma imagem de 320 de largura, sem passar da altura da faixa); trecho central da moldura completamente liso e uniforme; interior preenchido com pedra escura quase preta, lisa, com grão muito fino
Style/medium: pixel art sombria densa, mesma família do botão de aba de referência, porém mais robusta e de acabamento mais nobre; tom NEUTRO claro (cinza-aço, sem cor própria) para tingimento por código
Composition/framing: vista frontal plana, proporção 5 para 1, moldura ocupando a largura toda da imagem
Constraints: fundo fora da moldura liso magenta #FF00FF; bordas duras sem anti-aliasing contra o magenta; topo, base e trecho central uniformes e esticáveis na horizontal; ornamento somente nas duas extremidades; interior com variação de luminosidade de no máximo 6%; sem texto, números, runas legíveis, ícones, personagens, sombra projetada ou brilho fora do contorno
Avoid: ornamento no meio da faixa, relevo pesado que reduza a área interna, 3D, aparência de plástico, dourado saturado, vermelho vivo, qualquer cor própria na moldura (precisa ser neutra para ser tingida)
```

**Aceite (todos medidos em escala real):**

1. Esticada de **280 a 420 px** de largura e de **56 a 72 px** de altura, cantos e pontas nítidos, trecho central sem emenda nem deformação.
2. `JOGAR` a **28 px** e `Bloqueado` cabem com folga de pelo menos 10 px da borda interna; o glifo de controle (32 px) à esquerda não encosta na ponta.
3. Tingida em ouro, em tom claro e em tom apagado, a moldura continua legível e o rótulo mantém contraste.
4. Ao lado das abas (A05), o botão lê como **ação principal** e as abas continuam lendo como abas.
5. Sem halo magenta (`tools/audit_candidate_alpha.gd`) e sem contorno sólido cortado.

---

## Integração (fora deste documento)

Trocar o `StyleBoxFlat` do `PlayBtn` por `SheetArt.frame(...)` com a nova peça (e um auxiliar `UiKit.action_button` para os demais botões) é etapa **à parte** e precisa de spec e aprovação: o SPEC-166 definiu "nada em `assets/`" para o lote 2. Enquanto não houver arte aprovada, o botão continua como está. As verificações de celular (146) e de controle (90) precisam seguir sem falhas, porque nomes de nós, foco e área de toque do `PlayBtn` não mudam.

## Normalização na admissão (resumo)

1. Remover o magenta com tolerância e erosão de 1 px; auditar o alfa.
2. Cortar rente ao contorno, reduzir para **320×64** (não ampliar), validar as margens 28/28/20/20.
3. Prévia sobre capturas do Quartel (desktop e celular); aprovação do dono; só então `assets/`.

Total: **1 geração** (mais até 2 candidatas extras).
