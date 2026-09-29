# INTAKE — como assimilar evidência de um novo jogador

Cada pacote `NS-EV-public-AAAAMMDD-HHMMSS.zip` (F7) chega por Discord. Siga
estes passos, um jogador por vez.

> Questionário de validação em PDF (14 frases + 3 prioridades) e o mapa
> pergunta → cartão: [questionarios/](questionarios/QUESTIONARIO-002-validacao-EVID-106.md).

## 1. Registrar o jogador

Atribua o próximo código livre na tabela abaixo. O jogo **não** grava o nome do
jogador no pacote; quem mandou vem do Discord.

| Código | Jogador | Perfil | Pacotes | EVID |
|---|---|---|---|---|
| T01 | Higor (dono/dev) | Conhece o jogo; joga de Brook. **Não** é de primeira vez | 3 | [EVID-106](../evidence/EVID-106-playtest-publico-t01-higor-2026-09-29.md) |
| T02 | — | — | — | — |

## 2. Arquivar o bruto (não editar)

1. Extrair cada zip em uma pasta temporária e ler `manifest.json`, `notas.md`,
   `log.txt` e as capturas.
2. Copiar as pastas para
   `.atena/evidence/EVID-NNN-playtest-publico-tXX-<jogador>-<data>/` como
   `S1-HHMMSS`, `S2-HHMMSS`… (ordem cronológica). Sem os `.zip`.
3. Verificar o `log.txt`: procurar `erro`, `warn`, `fail`, crash e comportamento
   estranho, mesmo que o jogador não tenha citado.
4. Olhar os prints das notas que citam bug para confirmar (ex.: objeto fora do mapa).

## 3. Escrever o EVID-NNN

Copiar a estrutura do EVID-106: tabela de pacotes, validações positivas, tabela
**nota → resumo fiel → destino**, pedidos de recomendação em aberto, sinais
cruzados e limites. Registrar o perfil do jogador (primeira vez ou não) porque
muda o peso da opinião.

## 4. Triar

1. Cada nota vira uma linha `IN-nnn` em [INBOX.md](INBOX.md) (seção Classificados).
2. O destino é **BUGS**, **MECANICAS** ou **ARTE** (regra de fronteira no
   [README](README.md)); uma nota pode gerar mais de um cartão.
3. **Duplicata:** se já existe cartão para o mesmo pedido, **não criar outro**:
   acrescentar a origem e somar ao contador de relatos (`N relatos`). Vários
   jogadores independentes pedindo a mesma coisa é o principal sinal de prioridade.
4. Comentário de quem não é de primeira vez pesa menos em onboarding;
   comentário de primeira vez sobre "não entendi" é dado de UX, não bug.
5. Bug confirmado por print ou log ganha severidade; suspeita sem prova entra
   como "confirmar".

## 5. Fechar a rodada

- Atualizar os "próximos livres" no [README](README.md) (EVID, IN, BUG, MEC, ART).
- Conferir os gatilhos de bugs (5 ou mais P1 abertos, ou export próximo).
- Responder aos pedidos de recomendação abertos em um PLAN.
- Só decidir design com mais de um jogador: amostra única é indício, não veredito.
- Sem commit sem aprovação do dono.
