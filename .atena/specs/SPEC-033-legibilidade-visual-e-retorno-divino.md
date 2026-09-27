# SPEC-033 — Legibilidade visual e retorno divino

Status: aprovada para execução local em 2026-09-26.

## Escopo

- Tornar o bloco de notas F5 responsivo.
- Diminuir a densidade visual de Dagruve sem deixar blockers invisíveis.
- Animar a entrada de interações criadas durante a run.
- Exibir afinidade divina em danos e aura visual; incluir Selûne nas ofertas.
- Ajustar o enquadramento da câmera e a apresentação de heróis/inimigos.

## Não objetivos

Não alterar dano, alcance, hitbox, IA, cadência de ondas, dependências ou
publicação. A aura não concede efeito de jogo.

## Critérios de aceite

1. O F5 cabe e pode ser fechado em 1280×720, 1024×768, 800×600 e 320×480.
2. Interações novas têm telegráfico, entrada e impacto antes de leitura plena.
3. Aura só surge após bênção; a última divindade escolhida substitui a anterior
   e colore os números de dano.
4. Selûne aparece como opção de altar com azul-luar/prata.
5. Zoom 1,15 melhora a presença sem alterar escalas lógicas de combate.
6. Testes automatizados e smoke test passam; evidências são registradas.

## Plano de voo aprovado

Implementar primeiro o modelo de dados e a simulação, depois UI/efeitos,
responsividade, cenário e câmera; testar cada camada e reconciliar o plano
canônico e a evidência ao final.

## Evidência

- Saída de `tests/run_all.gd`.
- Capturas QA de F5, altar e enquadramento.
- Registro de contagem de props em Dagruve.
