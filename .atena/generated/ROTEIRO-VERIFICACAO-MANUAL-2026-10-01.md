---
id: "ROTEIRO-VERIFICACAO-001"
type: "roteiro-de-playtest"
title: "Roteiro de verificação manual (≈ 20 min)"
status: "pronto para uso"
created: "2026-10-01"
relations: ["[[BUGS]]", "[[RELEASES]]"]
---

# Roteiro de verificação manual (≈ 20 min)

Objetivo: fechar as **8 verificações manuais pendentes** (BUG-003 a BUG-010) e conferir as novidades de hoje.
Como registrar: **F5** abre o bloco de notas (escreva o ID, ex.: `BUG-004 ok` ou `BUG-004 falhou: ...`); **F6** tira um print.
Jogue uma partida normal em **Dagruve com Sylas**; troque de herói só onde o roteiro pedir. Marque `[x]` ao conferir.

## A. Verificações pendentes (BUG-003 a BUG-010)

- [ ] **BUG-003 · Painel `C`.** Abra com `C`: aparece a ficha do herói e a lista de itens e feitiços. Role a lista (roda do mouse). Feche com `C` e abra de novo; feche com `Esc`.
- [ ] **BUG-004 · Equipar ou vender.** Abra um baú até aparecer um item para um espaço já ocupado. Escolha **vender**: as moedas sobem e a arma antiga some. Em outro item, escolha **equipar**: a troca acontece sem perder moeda.
- [ ] **BUG-005 · Quebráveis.** Quebre caixotes, candelabros e arbustos. Confira: às vezes **não cai nada** (regra nova, ~55%), às vezes ouro, poção, ímã ou item. Espere 30 a 60 s: **novos quebráveis aparecem** perto de você. Poção não cai de inimigo comum.
- [ ] **BUG-006 · Loja, ferreiro, curandeiro.** Na **loja**: o preço mostrado é o cobrado e **Sair** não custa nada. No **ferreiro** e no **curandeiro**: idem. As moedas finais da run no menu batem com o que você coletou.
- [ ] **BUG-007 · Clique para andar.** Segure o botão esquerdo longe do herói: ele anda até o mouse. Clique num painel (`C`, oferta): o herói **não** anda.
- [ ] **BUG-008 · Nível de equipamento.** Pegue o mesmo item duas vezes (duplicata): o nível sobe. No **ferreiro**, a prévia Nv+1 mostra os atributos novos e a forja funciona.
- [ ] **BUG-010 · Sinergias.** Monte arma + acessório + magia do mesmo tema (ex.: fogo) e veja se o cartão ou o texto cita a sinergia e se o dano muda.
- [ ] **BUG-009 · QA (opcional, só desenvolvimento).** `F4` abre o Navegador QA; o botão de menu do HUD encerra o sandbox sem vazar para a run normal.

## B. Novidades de hoje

**Proporção dos sprites (BUG-021).** Jogue 1 minuto com cada um destes e ande em círculo e ataque:
- [ ] **Kayron, Sylas, Korrak, Maelor, Leoric, Durvall, Bromnor, Brook**: o tamanho não deve mudar ao andar para baixo, para os lados ou ao atacar.
- [ ] **Nyrelia**: ao andar para a direita (`move_e`) ela deve parecer um pouco menor (limitação conhecida); anote se incomodar.
- [ ] **Maelor**: a caminhada pode parecer mais fina que o idle (pose de conjuração); anote se incomodar.

**Sylas · Passo pelas Sombras (`Q`/botão direito, MEC-029).**
- [ ] Deixa uma cópia roxa onde ele estava, os inimigos vão atrás dela, e ela **explode** ao fim de ~4 s ou quando destruída.

**Cenário de Dagruve e Docas (MEC-030 a 035).**
- [ ] **Armadilha** (selo roxo em Dagruve, anel âmbar nas Docas): aviso vermelho antes do dano; **fere você e os inimigos**.
- [ ] **Poço de oferendas** (Dagruve) e **oficina do cais** (Docas) aparecem com nome e funcionam (fonte cura; ferreiro forja).
- [ ] Props agrupados por zona (praça com braseiros, armazéns), sem nada em cima de você ao começar.

**Texto e história (MEC-032).**
- [ ] Ao entrar numa fase aparece a **epígrafe** (2 linhas). Em Dagruve ela cita **Adam**.
- [ ] Ao chefe aparecer, o título traz uma linha de contexto; **falas do herói** na entrada, no chefe e com pouca vida (desligável em Opções).

**Dopamina (MEC-031).**
- [ ] Estouro ao matar; **pausa curta** em crítico e em abate de elite ou chefe; tom da coleta subindo em sequência; números de dano coloridos e somados.
- [ ] Marque **Opções → Reduzir efeitos de impacto**: a pausa some e há menos partículas.
- [ ] **Maré do Abismo:** 10 abates seguidos mostram um aviso e +2% de XP por 5 s.

**Conquista e loja do Leoric (MEC-036).**
- [ ] Em **Conquistas** aparece **Leoric, o Infeliz** (morrer 3 vezes com o Leoric). A recompensa libera **Teimosia do Infeliz** em Melhorias.

**Duração e balanceamento (BAL-011/013/014).**
- [ ] Dagruve e Docas duram **5 min**, com o chefe aos 5:00.
- [ ] **Nyrelia, Zynara e Kayron** parecem competitivos (não morrem nos primeiros minutos). Anote a sensação e o herói.

## C. Ao terminar
Pressione **F5** e escreva um resumo de 3 linhas: o que falhou, o que estranhou e o que gostou. O arquivo `evidencias/relato.txt` é lido na próxima sessão.
