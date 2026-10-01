# Rascunho H4 — crônicas de campanha (SPEC-117) — para aprovação do dono

Status: **rascunho, não implementado.** Uma crônica curta (3 a 4 frases) por fase, liberada ao **vencer o chefe da fase**, lida no Diário
(mesma aba das HQs e biografias). Só entra o que o Vault registra como **consolidação aprovada** ou base canônica; nada de lore nova.
Fontes: `04_Locais/*` (Dagruve, Docas, Camadas do Plano Abissal, Castelo da Fome), `data/stage_story.json`.

**Segredos preservados (nada disto aparece):** a ligação colar/amuleto → Adam → Síntese, a fusão de Durvall com Astherion e a revelação
que o dono manteve em segredo. Fases do Abismo têm pouco registro no Vault (as páginas de Durao, Feng-tu, Shendilavri, Goranthis e Molor
são só a fonte da sessão); as crônicas delas ficam curtas de propósito e usam a página "Camadas do Plano Abissal (Arco 01)".

**Formato proposto:** `data/chronicles.json` { fase: { titulo, texto, fonte_vault } }; ao vencer a fase o perfil marca a crônica como
vista (como as HQs); no Diário, uma seção "Crônicas" listando as 9 (bloqueadas mostram "Vença esta fase para ler"). Teste: toda fase tem crônica,
com fonte e até 420 caracteres.

---

## 1. Dagruve — "A fratura no cemitério"
O distrito que Nottgard esqueceu guardava uma fratura entre as lápides, com quatro a cinco metros de altura. Por um portal próximo, a névoa vinha de
outra dimensão, onde Astherion se dizia "o cão de caça" e chamava aquela névoa de "seu pulmão". Quando a dimensão caiu, Sylas realizou o ritual
que fechou a Tarn, e a névoa acabou em Dagruve.
*Fonte:* 04_Locais/Dagruve (S7-19, S7-26, S8-07).

## 2. Docas — "O ritual do porão"
Num galpão do porto, o grupo desceu a um porão de rituais, criaturas e um slime que corroía metal. Junto a uma porta, Kayron leu a inscrição
abissal: "Seremos um só". Mais tarde, num navio abandonado, outro ritual de invocação trouxe uma Arch-hag e um Kraken; ambos foram mortos.
*Fonte:* 04_Locais/Docas (Sessões 02 e 13). *Atenção:* o chefe das Docas no jogo (Guardião Alado) não está no Vault; a crônica cita só o que o Vault registra.

## 3. Shedaklah — "O equilíbrio quebrado"
No andar 222, Zuggtmoy e Juiblex dividiam o domínio num equilíbrio entre fungo e limo, quebrado pela passagem de Juiblex. O grupo negociou
no palácio de Zuggtmoy e abriu o portal antigo unindo os dois opostos, com o colar de retorno.
*Fonte:* 04_Locais/Camadas do Plano Abissal (Sessões 15 e 16).

## 4. Molor — "O núcleo verde"
Caverna de bolhas de slime, outro domínio de Juiblex, no andar 528. O grupo matou um chefe fúngico, Blogbog, e recolheu o núcleo verde de Juiblex para usá-lo como
essência do portal. Com isso, o Rio Estige voltou a correr ali.
*Fonte:* 04_Locais/Camadas do Plano Abissal (Sessões 16 e 17).

## 5. Durao — "A jaula e os carcereiros"
O andar 274 é árido, com um rio de almas e uma jaula gigante, na fronteira com Gehenna. A guerra do andar terminou e ele ficou deserto, restando três Molydeus carcereiros;
o grupo enfrentou um. Ali Korrak recebeu o Machado de Xar'gath, e o portal da jaula abre com sangue de Molydeus e de elfo verdadeiro.
*Fonte:* 04_Locais/Camadas do Plano Abissal (Sessões 16 e 17). *Nota:* mantive "Vhaerith Aetherion preso ali" de fora; se você quiser citá-lo, é só dizer.

## 6. Feng-tu — "A peregrinação da estrela"
O andar 300, de estética oriental, era dominado por Tou Um e Lu Yueh; Lu Yueh tomou o andar depois da passagem de Juiblex. O grupo limpou o templo de Tou Um e
fez a peregrinação da estrela.
*Fonte:* 04_Locais/Camadas do Plano Abissal (Sessões 17 e 18).

## 7. Shendilavri — "Rivenheart"
Na camada 570, reino de Malcanthet, a Rainha das Súcubos, a única cidade é Rivenheart: murada, com comércio de escravos e quase toda feita de ilusão
de súcubos. Uma passagem pela masmorra leva ao Castelo Argento de Graz'zt.
*Fonte:* 04_Locais/Camadas do Plano Abissal (Sessões 18 a 20).

## 8. Goranthis — "O verdadeiro Paraíso"
Na camada 597, chamada de "o verdadeiro Paraíso", o Rio Estige corre normal, ao lado de uma cachoeira altíssima. O castelo de Socothbenoth é todo ilusão, sustentada
por Juiblex, e foi o palco da batalha final do Abismo.
*Fonte:* 04_Locais/Camadas do Plano Abissal (Sessões 19 e 20).

## 9. Pilares — "A parede do mundo abissal"
De volta ao plano material, o Castelo da Fome (antes Castelo Dourado) foi erguido à superfície quando a Síntese Abissal surgiu, e foi esmagado na subida; seus escombros
ficam no pé do Morro Zapomoni. Adam caiu no Castelo da Fome; depois dele veio uma monstruosidade abissal, e só então surgiram os pilares.
*Fonte:* 04_Locais/Castelo da Fome (Sessão 24); 12_Lore/Pilares Ativos e Plano Abissal; frase de Adam já aprovada em `stage_story.json`.
*Cuidado:* não explico quem ou o quê é a Síntese; só repito o que o jogo já diz.

---

## Perguntas
1. O texto está no tom certo (narrador sóbrio)? Quer uma voz de personagem (o diário de um herói)?
2. As 9 crônicas liberam ao vencer o **chefe** da fase, ou ao **alcançar** a fase?
3. Pilares: mantenho só o que o jogo já diz, ou prefere adiar essa crônica até a decisão sobre o segredo da Síntese?
4. Duas lacunas no Vault: o chefe das Docas (Guardião Alado) e as páginas curtas de Durao, Feng-tu, Shendilavri, Goranthis e Molor. Aceita crônicas curtas, ou prefere que fiquem para depois?
