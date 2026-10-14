# Playtest L002 — sete habilidades / DRAFT v01

Build local `0.4.0/assets-l002-admission-v01/2b96638+local-0c664cdc0023`, checkout d8a8/Godot4.7.2, Dagruve, perfilQA isolado, sem exportação. Escopo42fontes/seteatlas: sete habilidades. Objetivo: avaliar leitura, tamanho/brilho, continuidade, orientação e efeitos que acompanham estados reais. Gameplay preservado; técnico não comprova sensação ou diversão. Roteiro preparado antes do playtest humano; smoke15quadros dos atalhos não é jogar.

Use **Q ou botão direito** para habilidade, cooldown normal; jogar30–60s por herói e repetir situações em pisos claros/escuros.

1. [Sylas](Jogar-Sylas.cmd): dash em oito direções, depois perto de parede/obstáculo para encurtar ou impedir. Rastro0,30s parte da origem real até destino, não continua seguindo o herói; conferir crescimento/fumaça/máscaras/fim em resíduos. Isca e explosão existentes permanecem.
2. [Kayron](Jogar-Kayron.cmd): ativar e mover; ciclo elétrico acompanha pés enquanto bônus ativo, até7s atuais, sem reaplicar buff. Conferir conforto, centro vazio e fim sem efeito preso.
3. [Korrak](Jogar-Korrak.cmd): perto de grupos, observar pulso0,35s, rachaduras/chamas e ausência de cortes nas bordas. [Bromnor](Jogar-Bromnor.cmd): escudo/onda0,35s; guarda lógica5s/carga e repulsão continuam. Cada um tem um atlas por nova; ring genérico de ativação anterior permanece.
4. [Leoric](Jogar-Leoric.cmd): constelação0,35s de raio visual2tiles, junto a oito projéteis existentes. Alcance11dos projéteis preservado; flash não usa esse alcance para cobrir a tela. Conferir leitura entre pulso e projéteis.
5. [Nyrelia](Jogar-Nyrelia.cmd): dominar inimigo comum; mover herói e alvo, aproximar outro inimigo. Sigilo acompanha exclusivamente o alvo escolhido, até7s ou morte/remoção, sem saltar ao mais próximo. Chefe/ausência de alvo não deve criar atlas.
6. [Zynara](Jogar-Zynara.cmd): relógio0,35s/raio visual7tiles, lento lógico4s preservado. Avaliar tamanho/brilho do pulso breve, não esperar anel durante toda lentidão.
7. [Reduzido com Kayron](Jogar-Reduzido.cmd) e [tinta Tou Um com Korrak](Jogar-Tou-Um.cmd): comparar. Nas Opções, alternar reduzir efeitos durante aura/ciclo; atlas deve sair e próximas ativações usam feedback simples anterior. Pausar/retomar: efeitos não avançam durante pausa nem reiniciam indevidamente.

Critérios técnicos: orientação/âncora/alvo corretos, sem fundo retangular/corte, sem efeito preso, fallback/reduzido preservados. Critérios humanos: motivos legíveis, brilho confortável e ritmo aceitável sob combate/sobreposição. Atena verifica consistência; você avalia sensação/dificuldade/diversão. Feedback esperado: herói/modo/cor/direção, aceitável ou problema, fase/ciclo/pulso. Playtest humano **PENDENTE**, necessário ao aceite visual em runtime.

Nove atalhos isolam APPDATA/saveQA nesta pasta, equipamento inicial e cooldowns normais; seu progresso real não é usado. [Galeria221capturas](index.html), [verificação](verification.json), [paridade140cenários](parity.json), [checksL002](runtime-checks.json), [regressãoL001](l001-regression/runtime-checks.json), [projéteis/Pulso/Ampulheta](vfx-regression/runtime-checks.json).
