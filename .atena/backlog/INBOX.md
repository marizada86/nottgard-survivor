# INBOX — entrada não classificada

Tudo que chega (pacote F7, nota F5, resposta de questionário, ideia solta)
entra aqui primeiro e sai na triagem para ARTE, MECANICAS ou BUGS. Procedimento
completo em [INTAKE.md](INTAKE.md).

## Abertos (aguardando triagem)

| ID | Chegou | Origem | Resumo | Destino sugerido |
|---|---|---|---|---|
| IN-032 | 2026-09-29 | [EVID-107](../evidence/EVID-107-playtest-publico-t02-hiago-2026-09-29.md) S2 | Print de Bromnor sem nota (PV 10/60, 00:48). Perguntar a Hiago o que mostrava | Aguardando resposta (ver a seção abaixo) |
| IN-059 | 2026-10-07 | [EVID-199](../evidence/EVID-199-relato-t04-manzi-v032-2026-10-07.md) #1 | Manzi (T04, v0.3.2): mostrar evoluções de arma/skill com mais detalhe e os próximos níveis | MEC-053 (PLAN-080, implementado local) |
| IN-060 | 2026-10-07 | EVID-199 #2 | Manzi: Ctrl deveria mostrar as melhorias dos próximos níveis (Shift já faz isso nas ofertas, MEC-027) | MEC-053 (sem Ctrl, decisão do dono); confirmar com Manzi se era Shift |
| IN-061 | 2026-10-07 | EVID-199 #3 | Manzi: na aba Sinergias/bônus, nome antes do valor ("Dano - 28%") | MEC-054 (implementado local) |
| IN-062 | 2026-10-07 | EVID-199 #4 | Manzi: C não abre durante escolha de magia/item/loja (`ui/run.gd:299-310` corta, mas a HUD abre desde `14633e2`, posterior à v0.3.2) | Já corrigido no HEAD (`14633e2`); verificado e coberto por teste em PLAN-080 S-002; confirmar em run real |
| IN-063 | 2026-10-07 | EVID-199 #5 | Manzi: arma base reaparece como "NOVA" depois de evoluir (`core/battle.gd:2294`) | BUG-037 (implementado local) |
| IN-064 | 2026-10-07 | EVID-199 #6 | Manzi: mostrar na HUD o debuff do lago (Estige hoje só tem texto, `ui/hud.gd:376`) | MEC-056 (implementado local); perguntar a fase ao Manzi |
| IN-065 | 2026-10-07 | EVID-199 #7 | Manzi: baú cai logo ao trocar de mapa (`_inter_t = 4.0`, primeiro interativo sempre baú) | BAL-024 (atrasado para 45 s; implementado local) |
| IN-066 | 2026-10-07 | [EVID-200](../evidence/EVID-200-relato-t03-daniel-v033-2026-10-07.md) #1 | Daniel (T03, v0.3.3): com o bloco de notas (F5) aberto o resto do jogo continua interativo (HUD clicável, atalhos sem foco no campo) | BUG-035 (implementado local) |
| IN-067 | 2026-10-07 | EVID-200 #2 | Daniel: C (Fechar) não fecha a ficha; `ui/hud.gd:335` e `has_modal` cortam antes. Soma-se a BUG-003 e ao IN-062 do Manzi | BUG-034 (implementado local; BUG-003) |
| IN-068 | 2026-10-07 | EVID-200 #3 | Daniel: ranking da tela inicial não atualiza; verificar se só ocorre ao zerar a campanha (lista só carrega no botão Atualizar; Windows não envia ao site) | MEC-057 (carregar ao abrir a aba, implementado local); o resto aguarda o Daniel e o PLAN-071 |
| IN-069 | 2026-10-07 | EVID-200 #4 | Daniel: textos sobrepostos no meio da tela, mais com quest (`ObjectiveLabel` y=74, `BossPanel` y=74, `ToastBox` y=130) | BUG-036 (implementado local) |
| IN-070 | 2026-10-07 | EVID-200 #5 | Daniel: quests com destaque visual maior (hoje 1 linha de texto) | MEC-055 (implementado local) |
| IN-071 | 2026-10-07 | EVID-200 #6 | Daniel: itens/alvos ligados à quest com destaque (seta só fora da tela) | MEC-055 (implementado local) |
| IN-072 | 2026-10-07 | EVID-200 #7 | Daniel: revisar posição e espaçamento dos textos da HUD | BUG-036 (implementado local) |
| IN-073 | 2026-10-10 | Relato do dono (Hiago, T02) | Hiago: ao comprar um upgrade em melhorias no controle o input some e não dá para comprar mais nada até apertar R1/RB ou L1/LB | BUG-043 (implementado local) |
| IN-074 | 2026-10-13 | Relato do dono (jogando) | A "câmara selada" é vaga: não dá para saber o que fazer para abri-la. Causa verificada: a câmara não aparece no questlog; 3 dos 8 acontecimentos-chave (Ritual da Névoa, Cais atacado, Do trono ao lodo) não têm `objective_text` e nem entram no questlog; a única pista é o rótulo "câmara selada" e o aviso "Algo da fase a abrirá" | MEC-068 (SPEC-175, PLAN-102; opção B escolhida pelo dono em 2026-10-13) |
| IN-075 | 2026-10-14 | Relato do dono (jogando) | O questlog mostra a linha da câmara solta: faltava um cabeçalho dizendo o que é (sugestão: "Missões" ou "Quadro de missões") | MEC-064 (adendo; cabeçalho "Missões" implementado local, EVID-244 adendo) |
| IN-076 | 2026-10-14 | Relato do dono (jogando) | Nas ofertas de nível, os rótulos SINERGIA, DEFESA e NOVA DIREÇÃO vinham antes do nome do item e ninguém explicava o que eram; o nome deveria vir primeiro (remover ou simplificar) | Rótulo removido das ofertas (cartão e botão simples); o papel segue só como regra interna de montagem da oferta; implementado local |

## Perguntas para o próximo playtest

Decisão do dono (2026-09-29): dúvidas sobre relatos **não bloqueiam** o trabalho;
entram no próximo questionário e na conversa com o tester. Fonte:
[EVID-107](../evidence/EVID-107-playtest-publico-t02-hiago-2026-09-29.md) (perguntas para Hiago).

| Para | Pergunta | Cartão que destrava |
|---|---|---|
| T02 Hiago | O herói mais jogado foi Leoric? Os pacotes só mostram Brook e Bromnor | — (dado de amostra) |
| T02 Hiago | O print de Bromnor (PV 10/60, 00:48) queria mostrar o quê? | IN-032 |
| T02 Hiago | "Manter um item 3 vezes consecutivas" = recusar a troca 3 vezes seguidas, ou é sobre a tela de oferta? | MEC-021 |
| T02 Hiago | "Durar apenas 5 min" é o tempo da perda de INT do Estige (hoje permanente na run)? | MEC-022 |
| T02 Hiago | "Fontes menos frequentes" eram as fontes de "+% PV"? | MEC-020 |
| T04 Manzi | Em qual fase estava o lago? A linha "Estige" apareceu na HUD? O pedido do Ctrl era na verdade o Shift? | IN-064, IN-060 |
| T03 Daniel | No ranking: a lista ficou vazia, desatualizada ou só faltou a sua partida? Foi depois de morrer, extrair ou zerar? Clicou em "Atualizar"? "Quest" são os objetivos de fase (coletar, escoltar, resgatar)? | IN-068, IN-070 |
| Todos | Perguntas novas da versão 0.2.0 (lista "O que testar" em [RELEASES.md](RELEASES.md)) | verificação dos cartões implementados |

## Classificados

Origem: [EVID-106](../evidence/EVID-106-playtest-publico-t01-higor-2026-09-29.md)
(tester **T01**, sessões S1, S2, S3). Resumo fiel de cada nota está no EVID.

| ID | Nota | Tema | Destino |
|---|---|---|---|
| IN-001 | T01-S1-N1 | Ritual sem recompensa; penalidade vira XP | BUG-014 |
| IN-002 | T01-S1-N2 | Névoa sem asset; dano baixo | ART-008, MEC-017 |
| IN-003 | T01-S1-N3 | Curandeiro/ferreiro OK, falta asset | ART-009 |
| IN-004 | T01-S1-N4 | Quebráveis raros | MEC-007 |
| IN-005 | T01-S2-N1 | Quebráveis: mais, escalando com Cha | MEC-007 |
| IN-006 | T01-S2-N2 | Destacar evolução; impacto do level-up | MEC-008, ART-010 |
| IN-007 | T01-S2-N3 | Menos tempo entre mapas / adiantar tempo | MEC-010 |
| IN-008 | T01-S2-N4 | Como evoluir arma; mini-cinemática | MEC-008, MEC-009, ART-014 |
| IN-009 | T01-S2-N5 | Inimigos travam em objetos; IA | BUG-012, MEC-011 |
| IN-010 | T01-S2-N6 | Cenário simples; assets flutuando | BUG-013, ART-012 |
| IN-011 | T01-S2-N7 | Mapa apertado | MEC-012 |
| IN-012 | T01-S2-N8 | Opção 2x; QoL de rejogabilidade | MEC-010 |
| IN-013 | T01-S2-N9 | Baú de chefe | MEC-013, ART-011 |
| IN-014 | T01-S3-N1 | Progressão tardia; eventos com RNG | MEC-005, MEC-014 |
| IN-015 | T01-S3-N2 | Espelho fora do mapa | BUG-011 |
| IN-016 | T01-S3-N3 | Moedas sobrando; HQ | MEC-015, ART-013 |
| IN-017 | T01-S3-N4 | Conquistas e travas por conquista | MEC-016 |
| IN-018 | T01-S2-N6 | Recomendações de ambientação | ART-012 |

Origem: [EVID-107](../evidence/EVID-107-playtest-publico-t02-hiago-2026-09-29.md) (tester **T02**, Hiago; S1 = 13 notas, S2 = 1 print; mais o Questionário rápido 002).

| ID | Nota | Tema | Destino |
|---|---|---|---|
| IN-019 | T02-S1-N1 | Recompensa ao interromper ritual | BUG-014 (2º relato) |
| IN-020 | T02-S1-N2 | Evidenciar escala físico/mágico (INT/FOR) | MEC-018 |
| IN-021 | T02-S1-N3 | Loja: mostrar slot já equipado | MEC-019 |
| IN-022 | T02-S1-N4 | Eventos aleatórios sem asset distinto | ART-009 (2º relato) |
| IN-023 | T02-S1-N5 | Mostrar o item que será trocado | MEC-019 |
| IN-024 | T02-S1-N6 | Fontes menos frequentes | MEC-020 |
| IN-025 | T02-S1-N7 | Manter item 3x sobe nível (ambíguo) | MEC-021 (confirmar) |
| IN-026 | T02-S1-N8 | Ímã de XP mais evidente | ART-015 |
| IN-027 | T02-S1-N9 | Comparação loja/forja ao passar o mouse | MEC-019 |
| IN-028 | T02-S1-N10 | Nv 2 de equipamento sem melhoria | BUG-015 |
| IN-029 | T02-S1-N11 | Dano mín./máx. da arma com atributos | MEC-018 |
| IN-030 | T02-S1-N12 | Mobs presos em obstáculos (Durao) | BUG-012 (2º relato, confirmado) |
| IN-031 | T02-S1-N13 | Perda de INT do Estige dura 5 min | MEC-022 |
| — | Questionário 002 | 14 respostas + prioridades 4, 8, 9 + nota 10 | contadores nos cartões; tabela no EVID-107 |

Origem: [EVID-108](../evidence/EVID-108-playtest-publico-t03-dna-2026-09-29.md) (tester **T03**, DNA; S1 = 6 notas, 5 prints; mais o Questionário rápido 002).

| ID | Nota | Tema | Destino |
|---|---|---|---|
| IN-033 | T03-S1-N1 | Ferreiro só mostra "Sair"; jogador não sabe por quê | MEC-023 |
| IN-034 | T03-S1-N2 | Objetos flutuando | BUG-013 (confirmado) |
| IN-035 | T03-S1-N3 | Mais mobs no mapa | MEC-024 |
| IN-036 | T03-S1-N4 | Cores de raridade; destaque verde do item novo | ART-016 |
| IN-037 | T03-S1-N5 | Mais dificuldade no início | MEC-024 |
| IN-038 | T03-S1-N6 | "+1 redução": redução do quê? | ART-017 |
| IN-039 | T03 texto livre | Mais dificuldade e mobs no início | MEC-024 (mesmo relato) |
| — | Questionário 002 | 14 respostas + prioridades 2, 9, 6 + nota 10 | contadores nos cartões; tabela no EVID-108 |

## Classificados — playtest Higor 2026-10-01

Origem: [EVID-139](../evidence/EVID-139-playtest-higor-qa-14b15e4-2026-10-01.md) (build qa, commit 14b15e4).

| ID | Tema | Destino |
|---|---|---|
| IN-041 | F5 sobre HQ: espaço passa a HQ | BUG-020 |
| IN-042 | HQ Peregrinação, quadro 2: braço de Korrak fundido ao machado | BUG-022 |
| IN-043 | Passo pelas Sombras fraco; quer cópia que atrai inimigos | MEC-029, ART-027 |
| IN-044 | Deformação de sprites ao andar | BUG-021 |
| IN-045 | Imagem das Docas e mapas 1-2 em 5 min | ART-024, BAL-011 |
| IN-046 | Movimento dos inimigos aprovado; seguir com novos inimigos | sem ação (registro) |
| IN-047 | Cenário sem sentido; estradas, carroças, destrutíveis, armadilhas | MEC-030, ART-025, ART-026 |
| IN-048 | Jogo "cru, sem alma"; dopamina, história, fundos | MEC-031, MEC-032, ART-025 |

## Classificados — relato de T03 (Daniel) via dono, 2026-10-03

Origem: relato verbal passado pelo dono (sem pacote de evidência; build não
informada). Plano: [PLAN-055](../vault/drafts/PLAN-055-mapas-vivos-segredos-e-dificuldade-2026-10-03.md).

| ID | Tema | Destino |
|---|---|---|
| IN-049 | Jogo fácil demais | BAL-001 (+1 relato T03), BAL-016, MEC-040 |
| IN-050 | Falta coisa para fazer no mapa; mapa maior com coisas escondidas | MEC-012 (reabre com outro escopo), MEC-039 |
| IN-051 | Referências à história de Nottgard (Vault) no mapa | MEC-032, MEC-039 |
| IN-052 | Dono: enjoa depois do 3º ou 4º mapa; eventos exclusivos por mapa | MEC-005 (+1 relato), MEC-038 |
| IN-053 | Manzi (T04, Sylas): usar habilidade (Q/RMB) sem ícone nem indicação de recarga; hoje só há o texto `[Q/RMB/RB] nome — Ns` | MEC-043, ART-034 |
| IN-054 | Manzi: tecla C devia mostrar o que a habilidade (Q/RMB) faz | MEC-044 |
| IN-055 | Manzi: ficha C com informação demais; espaçar, distribuir e agrupar itens, equipamentos e magias em categorias; criar prompts para embelezar | MEC-045, ART-035 |
| IN-056 | Manzi: bênção sem opção de não escolher nenhuma; balancear e adicionar bênçãos novas e entidades que concedem | MEC-046, MEC-047, BAL-019 |
| IN-057 | Manzi: v0.3.0 muito fácil (já em andamento) | BAL-001 (+1 relato), BAL-018 |
| IN-058 | Manzi (T04, observação final, repassada pelo dono em 2026-10-06): CA e CAM não são claros; algo deve explicar (tooltip: Classe de Armadura e Classe de Armadura Mágica) | MEC-045 (SPEC-130, D8) |

## Classificados — relatório de T05 (Mariz) via dono, 2026-10-14

Origem: [EVID-250](../evidence/EVID-250-relato-t05-mariz-v040-2026-10-14.md) (relatório escrito sobre a v0.4.0; sem log nem hash; o Print 1 não chegou). Verificação só por leitura de código.

| ID | Tema | Já feito? | Destino |
|---|---|---|---|
| IN-077 | Volume (menu e opções): bug ao aumentar ou diminuir | NOVO; implementado local (EVID-251) | BUG-044 |
| IN-078 | 1º slot da ficha: lado esquerdo some ao passar o mouse (Print 1) | 0.4.0, suspeita de reincidência do BUG-041 | BUG-046 (confirmar com o print) |
| IN-079 | Monstros presos em objetos do cenário | 0.4.0 | BUG-012 (+1 relato; pedir o mapa) |
| IN-080 | Tela de resultado após a morte estoura a tela (Print 2) | banner HEAD ajuda, não resolve | BUG-045 |
| IN-081 | Durvall anda com uma perna só (horizontal e para cima) | EM CURSO (M1) | BUG-028, BUG-027, SPEC-176 |
| IN-082 | Esperava menu principal antes da seleção de herói | NOVO | M3, sem cartão |
| IN-083 | Mensagem ao coletar item parece esperar interação | 0.4.0 | M3 (confirmar o objeto) |
| IN-084 | Item novo na 1ª posição induz a equipar | NOVO | MEC-070 (a propor) |
| IN-085 | Avisos de missão no topo central tapam o jogo | 0.4.0 + HEAD (questlog à direita) | MEC-064, M3 |
| IN-086 | Iluminação uniforme, pouca profundidade | EM CURSO (névoa do mundo) | M5/ART |
| IN-087 | Dano da borda baixo; névoa como pressão ativa | 0.4.0 | BAL-004, BAL-028, M4d |
| IN-088 | Números de dano ilegíveis; ataques sem impacto | EM CURSO (M2 R5) | SPEC-177, MEC-031 |
| IN-089 | Inimigos parecidos; tentáculo parado sem ataque perceptível | parcial | M4 e telégrafo no M2 |
| IN-090 | Poças deixam de ameaçar | 0.4.0 | BALANCEAMENTO (+1) |
| IN-091 | 1º chefe muito fácil | 0.4.0 | BALANCEAMENTO (+1) |
| IN-092 | Guardião Alado maior | NOVO | ART (escala), M5 |
| IN-093 | Chefes são só versões maiores | planejado | M4a |
| IN-094 | Elites sem comportamento próprio | planejado | M4a |
| IN-095 | Habilidade principal não evolui; falta ultimate | NOVO | MEC-070 (a propor) |
| IN-096 | Sons cômicos em vez de pesados | parcial; F-4/F-5 recusadas em 2026-10-14 | SPEC-177 (decisão do dono) |

Avaliação medida do relatório acima: [EVID-252](../evidence/EVID-252-avaliacao-medida-do-relatorio-t05-mariz-2026-10-14.md) e proposta em [AVALIACAO-playtest-t05-mariz-v040-2026-10-14](../vault/drafts/AVALIACAO-playtest-t05-mariz-v040-2026-10-14.md). Achados que mudam o destino: IN-095 é bloqueio de regra (evolução da arma inicial depende de 1 entre 14 passivas e há 5 espaços; MEC-070 reservado); IN-079 são atiradores `keep`, nenhum perseguidor preso; IN-091 e IN-093 vêm do diretor (as ondas acabam quando o chefe nasce).

L1 implementado local em 2026-10-14 ([EVID-253](../evidence/EVID-253-l1-evolucao-troca-de-item-e-guardiao-2026-10-14.md)): IN-095 (evolução fora do teto de passivas e aviso na HUD, MEC-070), IN-084 (troca de item em ordem fixa com foco no melhor) e IN-092 (Guardião Alado maior; a imagem da abertura segue pendente, ART-049 a abrir). Aguardam playtest.

L2 implementado local em 2026-10-14 ([EVID-254](../evidence/EVID-254-l2-campo-vivo-pv-do-chefe-poca-e-nevoa-2026-10-14.md)), atrás de `l2.enabled` em `data/difficulty.json`: IN-091/IN-093 (campo vivo com o chefe e PV do chefe com o poder do herói), IN-090 (poça de % do PV máximo, sem regeneração) e IN-087 (borda a 12% e sem regeneração). Aguardam playtest e a rodada de 12 heróis.

L3 implementado local em 2026-10-14 ([EVID-255](../evidence/EVID-255-l3-impacto-numeros-pausa-e-som-2026-10-14.md)): IN-088 (número de dano em 4 faixas, pausa de acerto em elite e chefe) e IN-096 (dinâmica e tom do som do acerto e da queda, sem arquivo novo). Aguardam o ouvido e o olho do dono.

L4 implementado em 2026-10-14 (commit `ff6bb4b1`, [EVID-256](../evidence/EVID-256-l4-inimigos-legiveis-e-movimentos-novos-2026-10-14.md)), atrás de `l4.enabled`: IN-079 e IN-089 (Tentáculo ao alcance e com linha do golpe, atiradores com mira e passo lateral) e IN-094 (bote e bando). Aguardam playtest e a rodada de 12 heróis.
