#!/bin/bash
# Antes e depois do L2 (EVID-254): bot_curva, lado 60, dt 0,08, 9 fases, metas 0 e 1, 4 heróis x 6 sementes, em paralelo.
cd /f/dev/nottgard-survivor
OUT=.atena/generated/mariz-playtest/bot
for l2 in 0 1; do
  for meta in 0 1; do
    for hero in durvall brook maelor kayron; do
      ( ./Godot_v4.7.2-stable_win64.exe --headless --path . -s tools/bot_curva.gd -- $hero 6 0.08 9 60 $meta "" $l2 2>&1 | grep -E "^CSV;|^GOLD;" > $OUT/l2-${l2}_meta${meta}_${hero}.csv ) &
    done
    wait
  done
done
echo feito > $OUT/FEITO
