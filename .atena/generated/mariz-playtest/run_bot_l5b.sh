#!/bin/bash
# L5 com piloto atento (desvia de varredura e quadrantes, guarda a ativa para interromper): boss_mech 1.
cd /f/dev/nottgard-survivor
OUT=.atena/generated/mariz-playtest/bot-l5b
for meta in 0 1; do
  for hero in durvall brook maelor kayron; do
    ( ./Godot_v4.7.2-stable_win64.exe --headless --path . -s tools/bot_curva.gd -- $hero 6 0.08 9 60 $meta "" 1 1 1 2>&1 | grep -E "^CSV;|^GOLD;" > $OUT/l5-1_meta${meta}_${hero}.csv ) &
  done
  wait
done
echo feito > $OUT/FEITO
