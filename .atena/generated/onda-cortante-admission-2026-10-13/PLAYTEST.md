# Playtest Onda Cortante — DRAFT v01

Build local `0.4.0/onda-cortante-admission-v01/a431fa9+local-7a192db2f9dc`, checkout d8a8/Godot 4.7.2, Dagruve/Maelor, sem exportação. Oito fontes aceitas, incluindo R01v02 e R05v02. Escopo: apresentação de Lâmina Trovejante/Tempestade. Objetivo: avaliar crescente/pontas/raios, alinhamento em movimento, leitura da perfuração, brilho e ritmo; gameplay preservado. Voo 12fps, impacto 0,24s, crescente principal 18px, pico principal 12px de raio; pivô fixo por animação.

1. Abrir [Lâmina Trovejante](Jogar-Lamina.cmd), jogar 30–60s; mover por pisos claros/escuros e usar o controle de Mira do jogo para apontar em oito direções. Observar se o crescente aponta para o deslocamento e se o loop parece estável.
2. Repetir com [Tempestade](Jogar-Tempestade.cmd): quatro projéteis, alvos em grupo, perfuração e impactos breves. Conferir se acertos e voo continuam distinguíveis.
3. Comparar [tinta Tou Um](Jogar-Tou-Um.cmd) e [impacto reduzido](Jogar-Reduzido.cmd). O reduzido mantém círculo/rastro procedural e ausência do novo flash.
4. Abrir [três famílias juntas](Jogar-Misto.cmd), comparando Onda Cortante, Orbe Arcano e Orbe Radiante no mesmo combate; avaliar clareza sob sobreposição.

Critérios técnicos: direção/alinhamento coerentes, sem cortes/fundo retangular, sem efeito preso e reduzido preservado. Critérios humanos: leitura do crescente/impacto, brilho confortável, ritmo e sensação aceitáveis. Atena verifica funcionamento e consistência; você avalia sensação, dificuldade e diversão. Feedback esperado: arma/modo/cor/direção, aceitável ou problema, fase/voo/impacto. Playtest humano PENDENTE, necessário ao aceite visual em runtime; smoke automático dos atalhos não o substitui.

Cada atalho isola APPDATA e perfil QA nesta pasta; não usa seu progresso real. [Galeria de 69 capturas](index.html), [verificação](verification.json), [paridade de simulação](parity.json).
