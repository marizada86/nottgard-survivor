# Playtest Orbe Arcano — DRAFT v01

Build local `0.4.0/orbe-arcano-admission-v01/a431fa9+local-498dd8dce1bb`, checkout d8a8/Godot4.7.2, Dagruve/Maelor. Sem exportação/release. Oito fontes aceitas; integração visual ainda depende da avaliação humana. Este roteiro/atalhos foi preparado antes do playtest; smoke automático do launcher não é playtest humano.

Objetivo: avaliar estabilidade do anel, leitura de glifos/cauda, conforto do impacto e ritmo. Voo12fps, impacto0,24s; anel de voo5px e pico12px, cauda≈26px preserva a fonte. Pivô fixo por animação; nenhuma alteração de simulação.

1. [Raio Enfraquecedor](Jogar-Raio.cmd): jogar30–60s, mover por pisos claros/escuros e usar controle de Mira do jogo para apontar em oito direções. Observar se a cauda fica atrás e o anel parece estável no loop.
2. [Dominar Pessoa](Jogar-Dominar.cmd): repetir, conferindo leitura do acerto enquanto o alvo fica atordoado; [Cajado dos Desejos](Jogar-Cajado.cmd): observar os três tiros sem confundir voo e impacto.
3. [Tinta Tou Um](Jogar-Tou-Um.cmd): repetir Cajado com tinta alternativa. [Impacto reduzido](Jogar-Reduzido.cmd): deve manter círculo/rastro procedural anterior e ausência do novo flash.
4. [Arcano + Radiante](Jogar-Misto.cmd): comparar as duas famílias no mesmo combate, clareza de cada efeito e sobreposição em grupos.

Critérios técnicos: orientação e anel alinhados, sem cortes/retângulos de fundo, sem efeito preso, modo reduzido preservado. Critérios humanos: projétil/impacto legíveis, brilho confortável e ritmo aceitável. Atena verifica funcionamento/consistência; você avalia sensação/dificuldade/diversão. Feedback esperado: arma/modo/cor/direção, aceitável ou problema e fase/voo/impacto; screenshot se útil. Playtest humano ainda pendente, necessário ao aceite visual em runtime.

Cada atalho isola APPDATA/save QA nesta pasta e equipa arma(s) apenas no perfil descartável. Seu progresso real não é usado. [Galeria47capturas](index.html), [checks Arcano/misto](runtime-checks.json), [regressão Radiante](radiant-regression/runtime-checks.json), [verificação final](verification.json).
