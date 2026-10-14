# Playtest Orbe Radiante — DRAFT v01

Build local `0.4.0/orbe-radiante-admission-v01/a431fa9+local-c9693f3da2cc`, projeto no checkout d8a8, Godot4.7.2, Dagruve/Maelor. Sem exportação/release. Fontes P01–P08 aceitas; integração visual ainda precisa da avaliação humana. Este roteiro e seus atalhos foram preparados antes do playtest; execução automática do launcher não é playtest humano.

Objetivo: avaliar conforto, ritmo e leitura do voo12fps e impacto0,24s nas três armas, tamanho/orientação e cor. Núcleo5px e impacto principal≈12px; simulação/alcance/perfuração não foram alterados.

1. [Raio de Luz](Jogar-Raio.cmd): jogar30–60s. Caminhar por trechos claros/escuros; usar controle de Mira do jogo para apontar em oito direções. Observar se a cauda fica atrás, se o loop é contínuo e se o impacto parece ligado ao alvo.
2. [Luz Mais Pura](Jogar-Luz-Pura.cmd): repetir com três projéteis e perfuração; conferir leitura dos impactos sem confundir tiros que continuam viajando.
3. [Marca da Retidão](Jogar-Marca.cmd): conferir que voo e acerto têm a mesma família visual, preservando a aplicação da marca.
4. [Tinta Tou Um](Jogar-Tou-Um.cmd): repetir Luz Mais Pura com a tinta alternativa; [Impacto reduzido](Jogar-Reduzido.cmd): deve manter o círculo/rastro procedural anterior, sem o novo flash de impacto.

Critérios técnicos: direção correta, sem cortes/retângulo de fundo, sem efeitos presos, fallback reduzido e interface preservados. Critérios humanos: projétil e impacto legíveis, brilho confortável e ritmo aceitável. Atena verifica funcionamento e consistência; você avalia sensação/dificuldade/diversão. Feedback esperado: arma/modo/cor/direção, aceitável ou problema em voo/impacto/fase; screenshot quando útil. Nada aqui atesta playtest já realizado. Esse feedback é necessário ao aceite visual em runtime.

Cada atalho usa APPDATA/save QA descartável dentro desta pasta; não usa seu progresso real. [Galeria](index.html), [checks renderizados](runtime-checks.json), [comparação determinística](parity.json), [verificação final](verification.json).
