# EVID-106 — Playtest público, jogador T01 (Higor, dono/dev), 2026-09-29

Origem: três pacotes F7 do build **Playtest Público** (`v0.1.0`, Windows),
em [EVID-106-playtest-publico-t01-higor-2026-09-29/](EVID-106-playtest-publico-t01-higor-2026-09-29/).
Relacionado: [[PLAN-036-playtest-primeira-vez-guia-autossuficiente-2026-09-29]],
[[PLAN-037-organizacao-do-trabalho-em-tres-trilhas-2026-09-29]].

> **Atenção à amostra:** T01 é o dono/dev, não um jogador de primeira vez.
> Serve para achar bugs e alimentar o backlog, **não** para medir onboarding.
> As decisões de design devem esperar os outros testers (regra do PLAN-036).

## Pacotes

| Sessão | Pacote (cópia bruta) | Notas | Prints | Run |
|---|---|---:|---:|---|
| S1 | `S1-094349` (`NS-EV-public-20260929-094349.zip`) | 4 | 4 | Run A: Brook, Dagruve → Docas (nv 20–25, prof. 0–1) |
| S2 | `S2-114525` (`NS-EV-public-20260929-114525.zip`) | 9 | 9 | Run B: Brook, Shedaklah → Feng-tu (nv 36–55, prof. 2–5) |
| S3 | `S3-123817` (`NS-EV-public-20260929-123817.zip`) | 4 | 5 | Continuação da Run B: Shendilavri (nv 56–57, prof. 6) e menu |

Cada pasta contém `manifest.json`, `notas.md` (texto literal), `log.txt` e
`screenshots/`. Os `.zip` originais permanecem na `outbox` do jogo (não copiados).
S2 e S3 são a mesma run (armas idênticas, nv 55 → 56); a vitória rendeu cerca de
30 000 moedas (S3-N3).

**Logs:** sem linha de erro ou aviso nos três `log.txt` (só eventos de jogo).
Nenhum crash relatado.

**Validações positivas (sem bug):** loja, ferreiro e curandeiro "funcionando muito
bem" (S1-N3); quebrável destruído funciona (S2-N1). Cobre parcialmente BUG-005 e
BUG-006.

## Notas → triagem

Formato do ID: `T01-<sessão>-N<nota>`. Texto literal em cada `notas.md`.
"IN" é o registro no [INBOX](../backlog/INBOX.md).

| IN | Nota | Resumo fiel | Destino |
|---|---|---|---|
| IN-001 | S1-N1 | Concluir o ritual não dá recompensa; a "penalidade" (monstros que surgem) vira recompensa porque dá mais XP | BUG-014 |
| IN-002 | S1-N2 | Não há asset para a névoa; o dano da névoa está baixo | ART-008 + MEC-017 |
| IN-003 | S1-N3 | Curandeiro e ferreiro funcionam muito bem, falta o asset | ART-009 (+ verificação BUG-006) |
| IN-004 | S1-N4 | Nenhum quebrável visto no mapa; aumentar spawn e balancear recompensas | MEC-007 |
| IN-005 | S2-N1 | Quebrável funciona; deveria aparecer mais, ou conforme o atributo Carisma (Cha) | MEC-007 |
| IN-006 | S2-N2 | Destacar evoluções entre as opções; mais impacto ao subir de nível (efeitos visuais e sonoros, ref. Castlevania SOTN) | MEC-008 + ART-010 |
| IN-007 | S2-N3 | Reduzir o tempo entre mapas; evento que adianta o tempo, com punição de spawn acumulado de uma vez | MEC-010 |
| IN-008 | S2-N4 | Falta indicação de como evoluir a arma; ao evoluir, mini-cinemática pausando e mostrando as condições | MEC-008 + MEC-009 + ART-014 |
| IN-009 | S2-N5 | Inimigos travam ao encostar em objetos; deveriam deslizar. Sugere IA melhor: circular, flanquear, cercar | BUG-012 + MEC-011 |
| IN-010 | S2-N6 | Terreno simples, destoa da estética; assets "flutuando" no ar; nova camada de ambientação (casas, ruínas, grama, areia, caminhos), remetendo à lore; pede recomendações | BUG-013 + ART-012 |
| IN-011 | S2-N7 | Mapa apertado ("claustrofóbico"); ampliar ou fazer loop | MEC-012 |
| IN-012 | S2-N8 | Opção "2x" em mapas já vencidos; mais ideias de qualidade de vida na rejogabilidade | MEC-010 |
| IN-013 | S2-N9 | Baús do chefe iguais aos demais; recompensa melhor e asset de "Baú de Chefe" | MEC-013 + ART-011 |
| IN-014 | S3-N1 | Progressão estagna em Shendilavri; mais eventos e variáveis com RNG (ex.: doar item/arma/habilidade por bênção); refs Spell Brigade, Death Must Die, Vampire Survivors, eventos de Diablo IV | MEC-005 (reforço) + MEC-014 |
| IN-015 | S3-N2 | Espelho de Shendilavri fora do mapa, sem interação (print `002-print.png`) | BUG-011 |
| IN-016 | S3-N3 | ~30 000 moedas compraram a loja inteira; precisa de novos sumidouros de moeda, aprimoramentos, HQ estilo "Nottcard" como pequena cutscene | MEC-015 + ART-013 |
| IN-017 | S3-N4 | Mais conquistas com recompensas balanceadas (lojas, catálogo, biografias); travar mecânicas por conquista (ex.: melhoria "Mão cheia"); pede recomendações | MEC-016 |
| IN-018 | S2-N6 (parte) | Pedido de recomendações para o cenário, citando as referências do projeto | ART-012 |

## Pedidos de recomendação em aberto (a Atena deve responder)

- **IN-010/IN-018:** plano de ambientação por bioma (camada extra de cenário).
- **IN-012:** ideias de qualidade de vida para rejogabilidade.
- **IN-017:** conquistas que equilibrem o jogo e travem mecânicas.

Nenhum deles foi respondido nesta evidência; ficam para PLAN próprio.

## Sinais cruzados

- **Eventos aleatórios / mais coisas para gastar e fazer:** IN-014, IN-016 e a
  resposta 10 do [[EVID-091-playtest-higo-hiago-build-c-e-item-offer-2026-09-28]]
  (três relatos, agora de progressão tardia e não só de variedade).
- **Frequência de quebráveis:** IN-004 e IN-005 (dois relatos).
- **Mapa apertado ↔ espelho fora do mapa:** T01 sugere que ampliar o mapa pode
  resolver IN-015, mas o objeto fora da área jogável é um defeito próprio de
  posicionamento; corrigir independente de MEC-012.

## Limites

- Nada foi implementado nem aprovado; só arquivamento e triagem.
- Nenhum arquivo de jogo foi alterado.
