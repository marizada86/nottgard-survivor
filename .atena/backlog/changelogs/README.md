# Changelogs para os playtesters

Um changelog em **PDF** acompanha cada **Major-update** (definição em [RELEASES](../RELEASES.md)).
Minor-update **não** tem PDF: só notas curtas no aviso do Discord.

| Arquivo | O que é |
|---|---|
| `CHANGELOG-X.Y.0.html` | Fonte editável |
| `CHANGELOG X.Y.0 - Nottgard Survivors.pdf` | O que se entrega |
| [CHANGELOG-0.2.0](CHANGELOG-0.2.0.html) | Primeiro (0.1.0 → 0.2.0); serve de **modelo** (copie e troque o texto) |
| [CHANGELOG-0.2.3](CHANGELOG-0.2.3.html) | 0.1.0 → 0.2.3 (junta 0.2.0 e 0.2.1, que ninguém jogou) |

## Regra de ouro: escrever para quem não sabe nada

O tester não leu spec, não conhece o backlog e não sabe o que "hover" ou "P1" significam. Cada linha
tem de fazer sentido para **alguém que nunca viu o projeto**.

1. **Frase curta, verbo de ação.** "Segure Shift" e não "o modo de detalhe é ativado por modificador".
2. **Sem jargão interno:** nada de SPEC, MEC, BUG, EVID, "tooltip", "hover", "spawn", "diretor de ondas". Diga
   "passe o mouse por cima", "aparecem inimigos".
3. **Antes → Agora → Como ver** em cada grande mudança. O "Como ver" diz **onde** clicar ou **o que** olhar.
4. **Teclas e botões exatos**, conferidos em `core/game.gd` e `core/playtest.gd`. Nunca de memória.
5. **Números só quando ajudam** ("20 segundos", "45% de chance"). O número vem do JSON ou da spec, nunca de cabeça.
6. **Seja honesto sobre o que é provisório** (caixa amarela "Isto é provisório"). Testers não devem gastar
   relato em coisa que já sabemos.
7. **Diga como atualizar** (3 passos) e **como conferir a versão** (rodapé do jogo). Sempre.
8. **Termine com "O que testar"** (caixinhas para marcar) e "Como nos contar o que achou".

## Estrutura fixa (nesta ordem)

1. Título, versão de → para, tempo de leitura.
2. **Resumo em 30 segundos** (caixa roxa).
3. **Como atualizar** (3 passos) e nota sobre o progresso salvo.
4. **As grandes mudanças**: no máximo ~8 cartões, cada um com etiqueta (MAPA, RITMO, ESCOLHAS...).
   Só entra aqui o que o tester **percebe ou precisa aprender**.
5. **Problemas consertados** (tabela Antes → Agora). Só os que os testers relataram; diga "avise se sobrou algum".
6. **Pequenos ajustes** (lista curta, uma linha cada). Menção leve, sem detalhes.
7. **Isto é provisório** (caixa amarela).
8. **O que testar** (caixinhas) e **Como nos contar** (F5, F6, questionário, Discord).

Meta: **3 a 4 páginas A4.**

## Como montar um novo changelog (major)

1. Levante o que mudou desde o último major: [RELEASES](../RELEASES.md) (tabela e "O que testar"), `git log <tag ou commit do último major>..HEAD`
   e as specs citadas. A build `latest` é republicada a cada push, então confira também o que entrou **depois** do fechamento.
2. Confira cada tecla, botão e número no código ou na spec.
3. Copie o HTML anterior, troque o texto e revise pelo checklist abaixo.
4. Gere o PDF (mesmo método dos questionários):

```bash
"/c/Program Files/Google/Chrome/Application/chrome.exe" --headless --disable-gpu --no-pdf-header-footer \
  --print-to-pdf="F:\dev\nottgard-survivor\.atena\backlog\changelogs\CHANGELOG X.Y.0 - Nottgard Survivors.pdf" \
  "file:///F:/dev/nottgard-survivor/.atena/backlog/changelogs/CHANGELOG-X.Y.0.html"
```

5. Abra o PDF e confira as páginas (cartões não cortados, sem página quase vazia).
6. Registre em [RELEASES](../RELEASES.md) (linha do changelog e checklist de fechamento) e envie aos testers junto do questionário.

## Checklist antes de enviar

- [ ] Um leigo entende cada linha sem perguntar nada?
- [ ] Nenhuma sigla interna (SPEC, MEC, BUG, EVID, P1)?
- [ ] Teclas e números conferidos no código?
- [ ] Versão bate com `core/version.gd` e `export_presets.cfg`?
- [ ] Tudo que é provisório está na caixa amarela?
- [ ] O que testar cobre cada grande mudança?
- [ ] PDF de 3 a 4 páginas, aberto e olhado?
