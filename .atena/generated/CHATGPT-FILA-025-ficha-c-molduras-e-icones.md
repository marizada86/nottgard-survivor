---
id: "CHATGPT-FILA-025"
title: "Fila de geração: ficha C, molduras, slots, abas e textura (ART-035)"
status: "concluida: dez imagens aprovadas, normalizadas e integradas localmente; PLAN-070 geracao, PLAN-072 integracao"
priority: "concluida localmente; removida das filas abertas"
created: "2026-10-06"
relations: ["[[ART-PROMPTS-057-ficha-c-molduras-e-icones]]", "[[SPEC-130-ficha-c-em-abas-grade-e-detalhe]]"]
---

# CHATGPT-FILA-025: ficha C (ART-035)

Compilação operacional de [[ART-PROMPTS-057-ficha-c-molduras-e-icones]]; em caso de dúvida, o ART-PROMPTS prevalece (inclui o bloco comum, os tamanhos finais e os critérios de aceite).

## Ordem de envio

1. Uma peça por chamada. Anexar as referências do ART-PROMPTS-057 e dizer o papel de cada uma.
2. Destino dos candidatos: `.atena/generated/art-candidates/ficha-c/<id>_v01.png` (até 3 por peça). Nada entra em `assets/` sem passar na verificação em escala real no jogo.
3. Marque `[x]` ao gerar e `[a]` ao aprovar.


## Prioridade (decidida por Atena em 2026-10-06, a pedido do dono)

**Concluida localmente em 2026-10-06.** A prioridade abaixo registra a ordem antes da conclusao; FILA-025 sai das filas abertas:

1. **PLAN-053** (heróis, Shu: `attack_02`, `death_03`, `death_04`), já em andamento e ligado ao BUG-025.
2. **Esta fila (ficha C, 10 peças).** Motivos: o layout já foi validado e aceito pelo dono; são poucas imagens, sem animação nem auditoria de quadros; e a SPEC-131 (HUD da run no padrão da ficha C) segue o mesmo visual e pode reaproveitar estas molduras, então a arte pode destravar duas telas.
3. FILA-021 (E e F, golpes de exceção).
4. FILA-022 e FILA-023 (projéteis e habilidades), que só começam depois da aprovação do piloto da FILA-020.

Dentro desta fila, a ordem é a da lista da seção "Fila" abaixo: A01 define o tom e vai primeiro.

## Fila

- [x] gerada · [x] aprovada — A01 `ficha_moldura_painel` (v02 aprovada pelo dono em 2026-10-06, incluindo variacao do topo originalmente divulgada; v01–v03 preservadas; normalizada e admitida no PLAN-072)
- [x] gerada · [x] aprovada — A03 `ficha_slot_moldura` v01
- [x] gerada · [x] aprovada — A04 `ficha_slot_vazio` v01
- [x] gerada · [x] aprovada — A02 `ficha_moldura_detalhe` v01
- [x] gerada · [x] aprovada — A05 `ficha_aba_moldura` v01
- [x] gerada · [x] aprovada — A06 `ficha_aba_armas` v01
- [x] gerada · [x] aprovada — A07 `ficha_aba_equipamento` v01
- [x] gerada · [x] aprovada — A08 `ficha_aba_passivas` v01
- [x] gerada · [x] aprovada — A09 `ficha_aba_sinergias` v01
- [x] gerada · [x] aprovada — A10 `ficha_fundo_textura` v03 (contraste 4,594%; v01/v02 preservadas)

Aceite visual das dez candidatas: dono respondeu “aprovados” neste chat em 2026-10-06. Registro canônico: `.atena/vault/canon/ASSET-APPROVAL-REGISTER-021-ficha-c-2026-10-06.json`; evidência: `.atena/evidence/fila-025-visual-approval-2026-10-06.json`. Este aceite registra a etapa visual. A integracao foi autorizada em seguida com “vamos lá” e validada no PLAN-072; registro separado de admissao em `.atena/vault/canon/ASSET-ADMISSION-fila-025-ficha-c-2026-10-06.json`.

Registro: `.atena/evidence/fila-025-complete-generation-2026-10-06.json`. Candidatas, prompts, galeria e pacote em `.atena/generated/art-candidates/ficha-c/`. Dez arquivos inspecionados, transparência nas nove peças, textura opaca e nenhum contorno sólido cortado. Normalizacao e admissao local concluidas no PLAN-072, apos capturas reais e suite zero falhas. Evidencia: `.atena/evidence/fila-025-integracao-2026-10-06.json`. Aceite fisico permanece nos planos de controles/mobile.

## A01 — `ficha_moldura_painel` (mensagem completa)

Anexar: `assets/ui/evolucao_painel_moldura.png`, com o papel "material, cor e família de ornamento; **não** copiar a composição nem a espessura, a nova moldura é muito mais fina". Pedir imagem 16:9 (1536×864 ou o 16:9 mais próximo).

```text
Use case: stylized-concept
Asset type: moldura externa de painel de ficha de personagem para jogo
Primary request: moldura retangular fina de ferro escuro e ouro velho; faixa lateral e inferior com cerca de 36 pixels de espessura na imagem de 1280×720, lisa, com pequenos rebites discretos e um filete âmbar apagado na borda interna; ornamentos góticos pontiagudos apenas nos quatro cantos (até 96 pixels), e um pequeno ornamento central no meio da borda superior (até 56 pixels de altura); centro vazio
Style/medium: pixel art sombria coerente com a moldura de evolução de referência, porém muito mais fina e discreta
Composition/framing: vista frontal plana, proporção exata 16 para 9, moldura ocupando a imagem toda; ocupar menos de 7% da largura em cada lado, salvo os cantos
Constraints: fundo fora da moldura e centro lisos magenta #FF00FF; bordas duras sem anti-aliasing contra o magenta; ornamento somente nos cantos e no meio da borda superior; faixa lateral lisa e repetível; sem texto, números, runas legíveis, personagens, sombra projetada ou brilho fora do contorno
Avoid: ornamento no meio das laterais, relevo pesado que reduza a área útil, 3D, aparência de plástico, dourado saturado, vermelho vivo
```

Aceite: lateral e base ≤ 36 px; ornamentos de canto não invadem a coluna do herói nem o botão de fechar; o ornamento do topo não cobre o título à esquerda nem as abas à direita.
