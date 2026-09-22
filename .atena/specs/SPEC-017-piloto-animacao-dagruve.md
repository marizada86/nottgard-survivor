# SPEC-017 — Piloto de animação de Dagruve

Status: **concluída e reconciliada em 2026-09-22**

## Intenção aprovada

Preparar o pipeline de animação, tornar Dagruve editável e visualmente inspecionável no editor, produzir o piloto com Durvall, Zumbi, Sacerdote da Mente Derretida e interações, integrar as sequências ao gameplay e validar antes de escalar para os demais atores.

## Escopo

- `Durvall`: `idle`, `move`, `attack`, `active`, `death`.
- `Zumbi`: `idle`, `move`, `attack`, `death`.
- `Sacerdote da Mente Derretida`: `idle`, `move`, `attack`, `special_a`, `special_b`, `phase`, `death`.
- Interações de Dagruve: `chest_open`, `fountain_active`, `altar_active`, `ritual` e `portal`.
- Cenas reutilizáveis com `AnimatedSprite2D`/`SpriteFrames`, preview no editor e direção visual controlada.
- Morte visível antes da remoção do inimigo.
- Metadados, auditoria, screenshots e reconciliação ADD.

## Não objetivos

- animar os outros heróis ou todos os inimigos de Dagruve nesta spec;
- transformar efeitos, telégrafos, projéteis, névoa, sombras ou cooldowns em PNG;
- alterar lore, balanceamento, áudio ou regras da fase;
- publicar, fazer commit ou push.

## Contrato técnico

- Uma chamada de ImageGen por sequência distinta, sempre anexando o PNG estático aprovado.
- Candidatas em `.atena/generated/animation-candidates/<family>/<id>/`.
- Finais em `assets/animations/<family>/<id>/`.
- Tiras horizontais RGBA, células fixas, sem sombra embutida e com base alinhada.
- Herói/inimigo comum: célula `256×384`; chefe: célula `320×480`; interações: célula `192×192`.
- Estados de dano, stun, slow, brilho, ilusão e telegráfo continuam procedurais.

## Plano de voo aprovado

1. Registrar prompts, manifesto e processador determinístico de folhas.
2. Validar a sequência `idle` de Durvall como prova técnica de grade, alfa e âncora.
3. Adaptar as cenas para preview e `SpriteFrames` sem quebrar o fallback estático.
4. Produzir e integrar as sequências restantes do piloto.
5. Ligar movimento, ataque, habilidade, fase e morte aos eventos do jogo.
6. Popular o editor com previews de herói, props e pontos de spawn.
7. Rodar importação, auditoria, testes, smoke e capturas de Dagruve.
8. Reconciliar spec, manifesto e evidências.

## Critérios de aceite

1. Dagruve pode ser aberta e inspecionada no editor com chão, props, herói e previews dos spawns.
2. Durvall, Zumbi e Sacerdote alternam entre seus estados sem salto de âncora.
3. Inimigos mortos concluem a animação antes de desaparecer.
4. Interações animadas preservam seus estados finais existentes.
5. Nenhum PNG procedural desnecessário é criado.
6. Testes e smoke continuam verdes.
7. Sequências, prompts, versões e resultados ficam rastreáveis.

## Reconciliação — 2026-09-22

Status operacional: **concluída**.

- 21/21 sequências produzidas e integradas: 5 de Durvall, 4 do Zumbi, 7 do Sacerdote da Mente Derretida e 5 interações.
- Folhas-fonte preservadas localmente em `.atena/generated/animation-candidates/`; tiras finais RGBA em `assets/animations/`.
- `HeroView` e `EnemyView` usam `AnimatedSprite2D` e `SpriteFrames` construídos das tiras; personagens sem animação mantêm fallback estático.
- Ataque, habilidade ativa, habilidades do Sacerdote, mudança de fase e morte foram ligados aos eventos da batalha.
- Interações ativas animam em loop; a ativação toca uma sequência independente antes de desaparecer.
- Pontos de spawn mostram preview estático no editor. Nenhuma cena de fase foi povoada ou reposicionada automaticamente; a composição manual permanece sob controle do autor.
- Evidência visual: `.atena/evidence/SPEC-017-dagruve-animated.png`.
- Evidência automatizada: suíte com `0 falha(s)` e smoke das 8 fases com `smoke: ok`.
