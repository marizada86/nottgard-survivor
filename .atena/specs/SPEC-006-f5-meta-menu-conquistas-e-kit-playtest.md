# SPEC-006 — F5: menu, progressão permanente, conquistas e kit de playtest

Status: aprovada (2026-09-21). Executada.

## Escopo
- Quartel (`ui/menu.tscn`): jogar (herói + fase), melhorias (custos do Nottcard), conquistas (com benefício), códex (inimigos, armas, itens), opções (mira, volume, tela cheia, Maldição).
- Perfil em `user://profile.json` (moedas, melhorias, conquistas, fases cumpridas, códex, estatísticas). Derrota mantém 50% das moedas.
- **Kit de playtest** (mesmo modelo do nottcard-ai, SPEC-051 de lá): boas-vindas com nome; **F5** bloco de notas (pausa; fechar guarda nota + print do instante); **F6** print sem pausar; **F7** gera UM `.zip` ao lado do executável com `info.json`, `log.txt` (últimas 200 linhas), `notas.md` e `prints/`; rascunho persistido em `user://evidencias/rascunho`; limites de 20 prints e 8 MB; privacidade (usuário do Windows removido de notas e log); F1 guia; F11 tela cheia. `PLAYTEST_BUILD` liga/desliga tudo.

## Critérios
`tools/kit_test.tscn`: print + nota + F7 geram o `.zip` correto, esvaziam o pacote e não vazam o usuário.
