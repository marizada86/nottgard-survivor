# EVID-031 — Idle de Nyrelia

Data: 2026-09-25  
Especificação: `SPEC-021-prompts-de-animacao-dos-herois`

## Resultado integrado

O dono aprovou a primeira folha de Nyrelia. A grade-fonte 2x2 foi normalizada
para quatro quadros horizontais de 256×384, com alfa real, em
`assets/animations/heroes/nyrelia/idle.png` (1024×384).

A identidade canônica foi preservada: sacerdotisa mascarada de Mask, capuz e
robes verde-escuros com detalhes dourados, brilho dourado discreto e espécie
visualmente indeterminada. Não há rosto exposto, orelhas élficas, chifres, asas
ou outros traços raciais acrescentados.

## Movimento norte integrado

A folha `move_n` aprovada foi normalizada de uma grade 3x2 para seis quadros horizontais de 256×384, com alfa real, em `assets/animations/heroes/nyrelia/move_n.png` (1536×384).

## Diagonal nordeste integrada

A folha `move_ne` aprovada foi normalizada de uma grade 3x2 para seis quadros horizontais de 256×384, com alfa real, em `assets/animations/heroes/nyrelia/move_ne.png` (1536×384).
O runtime também a utiliza espelhada para `move_nw`.

## Movimento leste integrado

A folha `move_e` aprovada foi normalizada de uma grade 3x2 para seis quadros horizontais de 256×384, com alfa real, em `assets/animations/heroes/nyrelia/move_e.png` (1536×384).
O runtime também a utiliza espelhada para `move_w`, sem arquivo inverso adicional.

## Movimento sudeste integrado

A folha `move_se` foi normalizada de uma grade 3x2 para seis quadros horizontais de 256×384, com alfa real, em `assets/animations/heroes/nyrelia/move_se.png` (1536×384).
Ela também atende `move_sw` pelo espelhamento horizontal aprovado.

## Movimento sul integrado

A folha `move_s` aprovada foi normalizada de uma grade 3x2 para seis quadros horizontais de 256x384, com alfa real, em `assets/animations/heroes/nyrelia/move_s.png` (1536x384).

## Ataque integrado

A folha `attack` aprovada foi normalizada de uma grade 2x2 para quatro quadros horizontais de 256x384, com alfa real, em `assets/animations/heroes/nyrelia/attack.png` (1024x384). A sequencia representa a conjuracao e o disparo dourado de Nyrelia.

## Habilidade ativa integrada

A folha `active` aprovada foi normalizada de uma grade 3x2 para seis quadros horizontais de 256x384, com alfa real, em `assets/animations/heroes/nyrelia/active.png` (1536x384). A sequencia representa a Dominação, de um foco ritual ao gesto de comando.

## Morte integrada e ciclo concluido

A folha `death` aprovada foi normalizada de uma grade 3x2 para seis quadros horizontais de 256x384, com alfa real, em `assets/animations/heroes/nyrelia/death.png` (1536x384). A sequencia representa a queda nao grafica de Nyrelia e conclui as nove sequencias-fonte do contrato de animacao.
