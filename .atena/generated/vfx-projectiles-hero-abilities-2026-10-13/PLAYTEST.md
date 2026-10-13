# Playtest local: projéteis e habilidades dos heróis (DRAFT)

Build local: `0.4.0/vfx-projectiles-hero-abilities-v01/a431fa9+local-a359abcdde16`. Não é build publicada; roda do projeto, em perfil QA isolado (não toca no seu save).

## O que testar
- **Projéteis (3 famílias):** Raio de Luz, Luz Mais Pura, Marca da Retidão e a Constelação do Leoric usam o orbe radiante; Raio Enfraquecedor, Dominar Pessoa e Cajado dos Desejos usam o orbe arcano; Lâmina Trovejante e Tempestade usam a onda cortante. Voo em ciclo; impacto ao acertar ou ao fim do alcance.
- **Habilidade ativa (10 heróis):** Durvall (corte), Brook (guarda, anel que segue o herói enquanto a guarda dura), Maelor (aura), Sylas (rastro do dash), Kayron (sobrecarga, anel enquanto durar), Korrak (impacto), Leoric (constelação), Nyrelia (sigilo no alvo dominado), Zynara (tempo parado), Bromnor (concórdia).

## Como abrir
- Projéteis: duplo clique em `Jogar-Projeteis.cmd` (Leoric com as cinco armas de projétil).
- Habilidade: `Jogar-Habilidade.cmd durvall` (ou outro herói). Tecla Q ou botão direito do mouse usa a habilidade. Acrescente `--reduced` para ver o modo de impacto reduzido.

## O que observar
Tamanho no jogo (a escala dos projéteis e dos anéis é calibração inicial), brilho em chão claro e escuro, se o impacto está no ponto certo, se a direção do corte e do rastro acompanha a mira, e a duração dos anéis de Brook e Kayron.

## Critério
- Técnico (Atena): sem erro de script, 9 fases abrem, testes e capturas passam, impacto reduzido volta ao visual antigo.
- Humano (você): legibilidade, tamanho, ritmo e se o efeito combina com a habilidade. Diga o herói/arma, o que incomodou e, se der, um print.

## Pontos de atenção herdados da revisão
Korrak (chamas verticais), Sylas (alcance e cauda), Kayron e Nyrelia (variação sutil entre fases), Durvall (primeiro quadro pequeno). Sem playtest humano ainda.
