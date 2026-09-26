# EVID-030 — Ataque de Leoric

Data: 2026-09-25  
Especificação: `SPEC-021-prompts-de-animacao-dos-herois`

## Resultado integrado

O dono aprovou a folha de ataque de Leoric, que representa o `Sopro de Estrela`.
Ela foi normalizada de uma grade 2x2 para quatro quadros horizontais de 256×384,
salva em `assets/animations/heroes/leoric/attack.png` (1024×384) e recebeu
remoção determinística do fundo, mantendo alfa real.

O herói permanece no fallback estático até que seu `idle` seja integrado. Assim,
uma única folha de ataque não pode ocultar a apresentação jogável de Leoric.

## Constelação integrada

A folha ativa aprovada foi normalizada de uma grade 3x2 para seis quadros horizontais de 256×384 e salva em `assets/animations/heroes/leoric/active.png` (1536×384).
A remoção determinística do fundo preservou os projéteis azul-pálidos e o alfa real.
A sequência reúne, forma e libera a constelação de Leoric.

## Morte integrada

A folha de morte aprovada foi normalizada de uma grade 3x2 para seis quadros horizontais de 256×384 e salva em `assets/animations/heroes/leoric/death.png` (1536×384).
A sequência não contém gore: Leoric perde o equilíbrio, se apoia no cajado e termina em uma pose derrotada com o cristal apagando.

## Idle integrado

A folha de idle aprovada foi normalizada de quatro quadros-fonte para `assets/animations/heroes/leoric/idle.png` (1024×384), com alfa real e linha de base comum.
Com esse idle presente, Leoric pode usar no runtime as folhas de ataque, habilidade e morte já integradas.

## Movimento norte integrado

A folha `move_n` aprovada foi normalizada de uma grade 3x2 para seis quadros horizontais de 256×384 e salva em `assets/animations/heroes/leoric/move_n.png` (1536×384), com alfa real.

## Movimento leste integrado

A folha `move_e` aprovada foi normalizada de uma grade 3x2 para seis quadros horizontais de 256×384 e salva em `assets/animations/heroes/leoric/move_e.png` (1536×384), com alfa real.
Ela também atende `move_w` pelo espelhamento horizontal do runtime.

## Diagonais espelhadas integradas

As folhas aprovadas `move_ne` e `move_se` foram normalizadas de grades 3x2 para seis quadros horizontais de 256×384, com alfa real.
Elas foram salvas respectivamente em `assets/animations/heroes/leoric/move_ne.png` e `assets/animations/heroes/leoric/move_se.png` (1536×384 cada).
No runtime, cobrem também `move_nw` e `move_sw` por espelhamento horizontal, sem folhas inversas extras.

## Movimento sul integrado e conjunto concluído

A folha `move_s` aprovada foi normalizada de uma grade 3x2 para seis quadros horizontais de 256×384 e salva em `assets/animations/heroes/leoric/move_s.png` (1536×384), com alfa real.
Leoric agora possui as nove sequências-fonte do contrato global: `idle`, cinco movimentos, `attack`, `active` e `death`.
