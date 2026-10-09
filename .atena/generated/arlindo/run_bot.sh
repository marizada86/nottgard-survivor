#!/bin/bash
# PLAN-086 S-012: bot por heroi (Arlindo e Erik) com e sem a faixa de borda (SPEC-158), 15 sementes, dt 0,08, 9 fases, lado 60, metas 0 e 1.
cd /f/dev/nottgard-survivor
out=.atena/generated/arlindo/bot; mkdir -p $out
run() { ./Godot_v4.7.2-stable_win64.exe --headless --path . -s $3 -- $1 15 0.08 9 60 $2 2>&1 | grep -E "^CSV|^GOLD" > $out/$1-meta$2-$4.txt; }
for meta in 1 0; do
  for h in arlindo erik; do
    run $h $meta tools/bot_curva.gd borda &
    run $h $meta .atena/generated/arlindo/bot_noedge.gd semborda &
    while [ $(jobs -r | wc -l) -ge 5 ]; do wait -n; done
  done
done
wait
echo done > $out/DONE
