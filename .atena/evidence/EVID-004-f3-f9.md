# EVID-004 — F3 a F9 (2026-09-21)

## Verificações automáticas
- `tests/run_all.gd`: **0 falhas** (Battle, integridade cruzada dos dados, perfil/conquistas/melhorias, iso/herói).
- `tools/smoke.tscn`: menu + as 8 fases instanciam e simulam 90 quadros sem erro.
- `tools/kit_test.tscn` (com janela): print + nota + F7 geram o `.zip` com `info.json`, `log.txt`, `notas.md`, `prints/`; o usuário do Windows não vaza; o pacote esvazia.
- Exportação Windows (`--export-release "Windows Desktop"`): `build/NottgardSurvivors.exe` (~113 MB, exe único) inicia sem erros (`--headless --quit-after`).
- Achado dos testes de dados: o herói Bromnor apontava para uma conquista inexistente (`ç` no id); corrigido.

## Balanceamento (bot `tools/bot.gd`, kite ingênuo)
- Fase 1 (Dagruve): 4 de 5 seeds do Durvall vencem (após i-frames de 0,4 s, ondas ×1,35 mais lentas e XP mais rápido).
- Descida completa: Durvall chegou a Os Pilares (nv 74) e caiu para A Síntese Abissal; Sylas chegou a Durao (nv 30); Brook/Kayron caem em Shedaklah. Humanos com kite melhor devem ir mais longe; ajustes finos ficam para o feedback dos playtesters.

## Capturas
`EVID-004-menu.png`, `EVID-004-levelup.png`, `EVID-004-chefe.png`.

## Pendente (humano)
Playtest manual: sensação de combate, ritmo, legibilidade dos telégrafos, F5/F6/F7 em jogo real, arte definitiva dos sprites (placeholders para os inimigos que não existem no Nottcard).
