# PLAN-023 — Estige universal por andar

Status: supersedido pelo PLAN-027 e SPEC-055 em 2026-09-27; histórico preservado  
Data: 2026-09-27  
Escopo: comportamento ambiental do rio Estige nos nove andares jogáveis.

## Decisão proposta

O comportamento implementado em Durão torna-se o contrato comum do Estige em
todos os andares: Dagruve, Docas de Nottgard, Shedaklah, Molor, Durão,
Feng-tu, Shendilavri, Goranthis e Pilares.

Em cada andar haverá uma manifestação acessível, determinística e legível do
rio. Ao atravessá-la, ela terá exatamente o contrato de Durão:

- superfície gelatinosa, imóvel e atravessável;
- Teste de Lucidez baseado em INT/CAM;
- Esquecimento temporário ao deixar a água;
- Chamado após exposição prolongada;
- derrota ao atingir o limiar de exposição;
- raros imbuídos pelo Estige;
- nenhuma mecânica de empurrão.

O Estige será uma regra compartilhada, não uma segunda implementação por mapa:
temporizadores, sorteios determinísticos, efeitos, derrota, telemetria e
mensagens terão uma única origem.

## Topologia inicial por andar

| Andar | Manifestação acessível proposta |
| --- | --- |
| Dagruve | canal enevoado na borda do distrito |
| Docas de Nottgard | braço entre os píeres |
| Shedaklah | os dois braços existentes, agora atravessáveis e perigosos |
| Molor | canal de detritos na borda, separado das poças de lodo |
| Durão | referência já existente |
| Feng-tu | canal ritual marginal |
| Shendilavri | braço marginal já representado |
| Goranthis | base acessível da cachoeira já representada |
| Pilares | fenda-canal permanente, sem anunciar a rotação seguinte |

## Conciliação de cânone necessária

Caso aprovado, este plano substitui somente as limitações anteriores que
definiram o Estige como visual ou ausente em Shedaklah, Molor, Feng-tu,
Shendilavri, Goranthis e Pilares. As demais identidades de terreno e efeitos
ambientais permanecem: lodo de Molor, supressão de voo em Feng-tu, paredes de
escrita em Shendilavri, catarata de Goranthis e rotação dos Pilares.

Essa alteração é intencionalmente pendente de aprovação: os registros canônicos
afetados só serão reconciliados durante a execução aprovada.

## Plano de voo

1. Aprovar esta mudança de intenção e registrar uma cláusula canônica que
   substitua as limitações incompatíveis.
2. Extrair o contrato `styx_gelatinous` de Durão para uma regra ambiental
   compartilhada, sem duplicar estado, RNG, dano, buffs ou condições de derrota.
3. Definir, para cada layout, uma zona de Estige acessível, determinística e
   compatível com sua rota, spawns, portal, telegráficos e arena de chefe.
4. Ligar todos os andares ao mesmo contrato, preservando suas demais regras
   ambientais.
5. Tornar a presença e os efeitos do Estige claros no HUD, na descrição do mapa
   e na telemetria de QA.
6. Validar uma matriz de paridade por andar: entrada, margem, exposição,
   Esquecimento, Chamado, raro imbuído, item, portal, telegráfico e chefe.
7. Registrar capturas, testes e reconciliação dos fatos operacionais afetados.

## Limites

Não altera inimigos, chefes, ondas, durações, recompensas, colisões fora das
zonas do Estige, pisos artísticos nem as regras ambientais que não sejam do rio.

## Riscos a verificar

- A mudança substitui decisões canônicas aprovadas anteriormente sobre a
  ausência ou papel exclusivamente visual do Estige.
- Cada novo canal precisa preservar rotas viáveis e não cobrir spawn, portal,
  telegráficos ou arena de chefe.
- A paridade precisa demonstrar o mesmo contrato de Durão, sem regressões nas
  regras próprias dos demais andares.
