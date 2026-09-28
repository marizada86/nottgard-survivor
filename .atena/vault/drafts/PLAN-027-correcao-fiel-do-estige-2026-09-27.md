---
id: "PLAN-027"
type: "plano-de-voo"
title: "Correção fiel do Rio Estige"
status: "executado e verificado; evidência EVID-085"
created: "2026-09-27"
relations:
  - "[[SPEC-055-estige-fiel-a-lore]]"
  - "[[PLAN-023-estige-universal-2026-09-27]]"
  - "[[PLAN-001-nottgard-survivors]]"
---

# PLAN-027 — Correção fiel do Rio Estige

## Descoberta validada

O PLAN-023 universalizou indevidamente o Estige. A fonte de camadas usada pelo
projeto é D&D 3.5, em especial *Fiendish Codex I: Hordes of the Abyss*. Dentro
dos mapas de Nottgard, há quatro presenças nomeadas do rio:

| Andar | Presença fiel | Leitura de jogo proposta |
| --- | --- | --- |
| Shedaklah | dois braços lentos que separam Zuggtmoy e Juiblex | dois canais de memória, fronteira territorial |
| Durão | águas lentas, cais, quartéis e barcaças da Guerra de Sangue | canal navegável junto a cais, sem gelatina |
| Shendilavri | ramificação vinda de Pazunia | um braço marginal de memória |
| Goranthis | chegada por cachoeira colossal | queda e bacia acessível de memória |

Dagruve/Docas são material local; Molor não tem trecho estabelecido; Feng-tu
não contém o Estige no cânone local; Pilares é autoral e não tem equivalente
publicado. O curso do Estige no Abismo é irregular; a ausência de uma menção
não prova impossibilidade cosmológica, mas não autoriza sua inclusão no jogo.

## Correção de intenção proposta

1. Remover rio, zona, HUD, QA e efeito do Estige de Dagruve, Docas, Molor,
   Feng-tu e Pilares.
2. Manter rio somente em Shedaklah, Durão, Shendilavri e Goranthis, com a forma
   específica da tabela acima.
3. Substituir `styx_gelatinous` por `styx_memory`, preservando a tradução
   jogável já aprovada na SPEC-039: ao entrar e a cada segundo, Teste de
   Lucidez `d20 + modificador de INT + max(0, CAM - 10)`, com CDs 11–16.
   Cada falha perde um ponto de lucidez efetiva da run, com piso em INT 1;
   nunca altera a ficha persistente.
4. Preservar o Esquecimento do Estige já estruturado: após ao menos dois
   segundos de contato, ao sair o herói não pode se aproximar da água por
   `min(segundos completos de exposição, 6)` segundos. Esta é a tradução local
   da perda de memória recente; não exige uma nova estatística de Fortitude.
5. Remover como não canônicos: gelatina de Juiblex, Chamado por exposição,
   derrota por cronômetro, imbuimento de raros e qualquer empurrão atribuídos
   ao Estige. A corrente rotativa dos Pilares continua uma regra separada.

## Tradução de gameplay já aprovada

O jogo já possui a interpretação local necessária para a amnésia do Estige:
perda de lucidez efetiva em cada falha e Esquecimento temporário ao sair. Ela
é restrita à run, tem feedback no HUD e nunca altera perfil, desbloqueios ou
itens persistentes. PLAN-027 não cria uma segunda falha nem substitui esse
contrato por Constituição/Fortitude.

## Plano de voo

1. Adicionar decisão canônica que substitua a seção 24 do PLAN-001 e as partes
   incompatíveis das seções 21–23; marcar PLAN-023/SPEC-054/EVID-084 como
   histórico supersedido, sem apagar seus registros.
2. Retirar `styx_gelatinous` e suas zonas de todos os nove layouts; remover os
   canais não autorizados e a sobreposição do piso legado de Dagruve/Docas.
3. Reintroduzir `styx_memory` apenas nos quatro mapas documentados, usando a
   implementação aprovada de Lucidez/Esquecimento e suas topologias.
4. Ajustar arte procedural e textos: Durão passa a água lenta com cais; os
   dois braços de Shedaklah, o afluente de Shendilavri e a bacia de Goranthis
   exibem água do Estige sem sugerir gelatina ou corrente física não documentada.
5. Reduzir QA à matriz correta: ausência nos cinco mapas, contato/memória nos
   quatro, e coexistência com poças, raios, ilusões, santuários e rotação.
6. Rodar testes, smoke, capturas dos quatro mapas e revisão independente;
   registrar nova evidência e a reconciliação final.

## Não objetivos

- Não alterar ondas, chefes, recompensas, itens, progresso ou dependências.
- Não transformar a corrente da rotação dos Pilares em Estige.
- Não inferir novos trechos do rio apenas porque o curso abissal é variável.
- Não apagar evidência prévia; ela será preservada e marcada como supersedida.

## Critérios de aceite

1. Só Shedaklah, Durão, Shendilavri e Goranthis possuem Estige funcional.
2. Cada um reproduz sua topologia publicada sem efeitos inventados de Juiblex.
3. O núcleo mecânico é o teste de memória do Estige; não há Chamado, dano por
   exposição, derrota temporal, buff de raro ou empurrão associado ao rio.
4. Os outros cinco mapas não têm material, zona, HUD, QA nem dado ambiental do
   Estige.
5. A tradução de amnésia é temporária, explícita e nunca altera o perfil.
6. Testes, smoke e evidência visual passam, e o cânone aponta corretamente
   para a decisão vigente.

## Fontes externas consultadas

- *Fiendish Codex I: Hordes of the Abyss*, pp. 111 e 144–146.
- Dragon #358, “Savage Tidings: The River Styx”.
- Referências de localização do Estige em Forgotten Realms Wiki / Planescape
  Wiki, usadas somente para indexar as fontes publicadas.
