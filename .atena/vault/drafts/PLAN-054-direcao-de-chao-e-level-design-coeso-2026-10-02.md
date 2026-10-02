---
id: PLAN-054
title: Direção de chão e level design coeso dos nove mapas
created: 2026-10-02
status: aprovado pelo dono 2026-10-02 (Dagruve, híbrido); F0–F2 parcial em Dagruve, ver SPEC-116
relations: ["[[SPEC-115-riqueza-de-cenario-piloto-dagruve-docas]]", "[[PLAN-016-terreno-de-shedaklah-e-estige-2026-09-27]]", "[[PLAN-053-fila-de-imagens-2026-10-02]]"]
---

# PLAN-054 — Direção de chão e level design coeso

## Origem
Relato do dono (2026-10-02): o chão está feio, sem estilo nem variação; props foram somados por cima, mas falta estilo e organização.
Pede um level design mais coeso e consistente em todos os mapas.

## O que já existe (não havia plano de chão)
- **SPEC-115** organiza props, destrutíveis, armadilhas e estradas por zonas — só em Dagruve e Docas, e só **acima** do chão.
- **PLAN-016 a 022** deram um macroterreno (materiais por célula) aos biomas Shedaklah, Molor, Durão, Feng-tu, Shendilavri, Goranthis e Pilares.
- **ART-012** (camada de ambientação por bioma) está aberto sem plano.
- Nenhum documento define uma direção visual do chão nem uma regra comum de composição de mapa.

## Diagnóstico
1. **Textura:** o piso é ruído fino e uniforme (a captura anexada). Sem forma, sem valor claro/escuro, lê como tapete. O losango 64×32 repete com
   4 variantes, então a repetição aparece e nada diz "que lugar é este".
2. **Dagruve e Docas** (os pilotos de cenário) são os únicos sem `terrain_layout_id`: chão = atlas de 4 variantes, sem macroterreno. Durão tem layout, mas sem atlas (cores chapadas).
3. **Manutenção:** em `ui/ground.gd` a cor de cada material é uma cadeia de `elif` (~20 materiais) e os detalhes por célula são círculos/linhas soltos. Cada bioma foi feito por uma regra própria; por isso não há coesão.
4. **Estrada:** os decais de trilha não seguem o eixo isométrico; as estradas ficam como manchas.
5. **Contraste:** nada garante que o chão fique abaixo de herói, inimigos e projéteis em saturação e contraste.

## Proposta (cada fase fecha com gate do dono)

### F0 — Direção visual do chão (documento, sem código)
Uma ficha por bioma: paleta de **3 valores** (base, escuro, claro), **3 a 4 materiais** nomeados, o que o jogador deve ler (caminho, borda, perigo, landmark)
e a regra de contraste: o chão nunca supera entidades. Refs: paleta das deidades (RESEARCH-003) e a lore do Vault. Saída: `SPEC` + tabela de materiais.

### F1 — Gramática de level design (comum aos nove mapas)
Todo mapa 60×60 segue o mesmo esqueleto, parametrizado em dados:
- **Clareira de início** neutra (raio ~6), sem armadilha nem destrutível.
- **Um eixo** de caminho/estrada alinhado ao eixo isométrico, ligando 2 a 3 **landmarks** (estrutura, praça, cais, altar).
- **Zonas temáticas** que mudam material e densidade de props (anéis ou faixas, não ruído aleatório).
- **Bordas** legíveis (parede, água, vazio) com tile de transição.
- Densidade de props decrescente da zona temática para o aberto (respiro para combate).
Técnico: mover as cores/tints de material para `data/ground_materials.json` (some o `elif`), estender `terrain_layout` com zonas e transição e
ligar Dagruve e Docas ao mesmo mecanismo. Layout continua **sem consumir a RNG da batalha**.

### F2 — Piloto: Dagruve e Docas
- Novo atlas por bioma com **forma**, não ruído: 8 variantes por material, mais tiles de transição (rua↔terra, cais↔água, laje ritual↔chão).
- Estrada/cais **alinhados ao eixo** (usa a infraestrutura dormente de `road_placements`).
- Reorganizar props e decais nas zonas da F1 (reaproveita `data/scenery.json`).
- Capturas antes/depois em 1280×720 (início, landmark, borda) e teste de contraste com herói, inimigos e projéteis.
- Origem da arte: ver Decisões.

### F3 — Rollout nos sete biomas restantes
Um bioma por vez com o mesmo checklist (ficha F0, zonas F1, atlas, captura). Ordem sugerida: Shedaklah, Molor, Durão (falta atlas), Feng-tu, Shendilavri, Goranthis, Pilares.

### F4 — Validação
Testes: mesma semente gera os mesmos spawns (RNG intacta); nenhum prop sobre destrutível, armadilha ou clareira; todo material do layout existe em `ground_materials.json`.
Rodada do bot por mapa e um questionário de playtest sobre o chão ("lê bem?", "sei onde estou?").

## Não objetivos
Novos mapas, novas regras de fase, mudar ondas ou dificuldade (BAL), nova mecânica de terreno.

## Cartões sugeridos
ART (atlas de chão por bioma), MEC-035 (estende o layout por dados), ART-012 (passa a ter este plano como dono).

## Decisões
1. **Qual mapa aparece na captura?** (parece Dagruve ou Docas) — é o primeiro alvo do piloto.
2. **Origem do chão:** (a) imagegen, como no PLAN-053; (b) procedural no Godot (ruído por camada, formas e transições geradas por código, zero arte nova);
   (c) **híbrido (recomendado)**: procedural para a base e as transições e imagegen só para peças de assinatura (laje ritual, tábuas de cais, estrada).
3. Aprovar começar pelo piloto Dagruve + Docas (F0 a F2) antes de tocar nos outros sete.

## Decisões do dono (2026-10-02)
- Mapa da captura: Dagruve. Origem: híbrido. Começar pelo piloto.

## Progresso
- Dagruve e Docas: aprovados. Sete biomas restantes: chão assado implementado (SPEC-116), aguardando aprovação visual. Próximo: F1 (zonas, eixo de caminho, landmarks, materiais em dados) e F4 (bot e questionário).
