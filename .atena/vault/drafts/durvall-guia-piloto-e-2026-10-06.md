---
title: Guia de poses do piloto lateral de Durvall
created: 2026-10-06
plan: PLAN-066
checkpoint: B-001 / S-002
status: READY_FOR_B002_REVIEW
canonical: false
---

# Guia de poses: corrida lateral de Durvall

O piloto deve comunicar impulso, passada ampla e recuperação da perna sem perder a identidade da arte oficial. É uma candidata para comparação; este guia não aprova a futura imagem nem altera lore.

## Referência de comparação

Primeira versão: seis quadros, 10 fps, ciclo de 0,6 segundo, velocidade base de 190 px/s e escala única 60/231. Usar a direção E do runtime atual como baseline. O [diagnóstico B-001](../../evidence/EVID-169-durvall-corrida-b001-2026-10-06.md) contém a captura real do componente visual e a reprodução animada.

## Sequência de poses

| Quadro | Fase pretendida | O que precisa ficar legível |
|---|---|---|
| 1 | Contato da perna A à frente | Alcance claro à frente do quadril; perna B atrás, sem postura de repouso. |
| 2 | Compressão e apoio A | Peso sobre A, joelho flexionado; B recolhe e avança. O pé A recua relativamente ao corpo enquanto apoia. |
| 3 | Impulso A e recuperação B | A empurra atrás; joelho B sobe flexionado antes de abrir a passada. Evitar arrastar a ponta de B. |
| 4 | Contato da perna B à frente | Alternância verdadeira das pernas, com os mesmos volumes e enquadramento. |
| 5 | Compressão e apoio B | A recolhe e avança; B sustenta o peso. |
| 6 | Impulso B e recuperação A | Preparar o contato A do quadro 1; fechamento sem salto de origem, mão ou espada. |

A/B identificam pernas anatômicas durante a produção; não trocar a identidade das pernas só para repetir os três primeiros quadros. A duração uniforme de 100 ms por quadro é o primeiro controle de comparação, não uma garantia de corrida natural.

## Corpo e identidade

- Inclinação moderada à frente, coerente com a câmera isométrica existente. A corrida permanece firme e controlada.
- Maior extensão no quadril e joelho; abrir a passada por pose, sem esticar a anatomia ou aumentar Durvall.
- Preservar rosto, cabelo longo prateado, armadura escura, tecidos vermelhos e Espada Sombria. O braço livre acompanha o impulso; a espada mantém mão, lado e proporção, com inércia discreta.
- Cabelo e tecido acompanham o corpo, sem mascarar contato, recuperação do joelho ou troca das pernas.
- Origem da célula, referência de quadril e escala continuam comuns. Não centralizar nem igualar a caixa alfa de cada quadro automaticamente.

## Contato e enquadramento

Cada intervalo de 100 ms desloca o herói 19 px na tela. Durante um apoio que dure esse intervalo inteiro, compensar esse deslocamento exige cerca de 73 px-fonte de recuo do pé em relação ao corpo. Esta é uma relação cinemática para avaliar o apoio, não uma instrução de separar os pés em 73 px ou fabricar um apoio contínuo.

No piloto, identificar explicitamente quais quadros sustentam cada perna e testar o contato sobre o chão em movimento. Eventual fase aérea breve é intencional, precisa de revisão e não deve parecer quique procedural. A linha-base de triagem do apoio é y=376, com tolerância inicial da SPEC-106; as variações corporais intencionais são avaliadas visualmente.

Contrato inicial: tira horizontal 1536×384, seis células 256×384 com alfa real. Reservar margem para os extremos da espada, cabelo e botas. Amplitude maior não pode provocar corte nem reduzir a escala de todo o herói para caber. A mesma escala precisa funcionar na passagem idle → corrida → parada e corrida → ataque.

## Gate do piloto

Comparar atual e candidata no mesmo chão, velocidade, câmera, escala, duração e cadência; mostrar tamanho real e ampliação. O dono decide se lê como corrida e se preserva Durvall. Registrar defeitos por quadro e apoio; uma altura estável, isoladamente, não prova passada correta.

As oito direções só seguem depois do aceite E. Se seis quadros limitarem a leitura, apresentar a opção de oito com duração declarada; não aplicar cadência maior nem sincronização de velocidade automaticamente.

## Referências e autorização pendente

B-002 propõe usar somente os PNGs oficiais de Durvall `idle.png`, `move_e.png` e `move_se.png` como referências no ImageGen. O envio/geração depende de autorização específica. Nenhuma referência foi enviada no B-001.
