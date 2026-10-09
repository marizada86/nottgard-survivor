#!/bin/bash
# PLAN-088 B-002 (confirmacao): 45 sementes para Kayron e Sylas (metas 0 e 1), onde a rodada de 15 sementes ficou perto de 2 erros-padrao.
cd /f/dev/nottgard-survivor
out=.atena/generated/plan-088/bot45; rm -f $out/DONE
for meta in 1 0; do
  for h in kayron sylas; do
    ./Godot_v4.7.2-stable_win64.exe --headless --path . -s tools/bot_curva.gd -- $h 45 0.08 9 60 $meta 2>&1 | grep -E "^CSV|^GOLD" > $out/$h-meta$meta.txt &
  done
done
wait
echo done > $out/DONE
