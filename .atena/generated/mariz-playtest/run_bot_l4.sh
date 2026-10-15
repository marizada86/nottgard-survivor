#!/bin/bash
# Antes e depois do L4 (EVID-256): bot_curva com L2 ligado; l4 0 e 1; 4 heróis x 6 sementes; metas 0 e 1.
cd /f/dev/nottgard-survivor
OUT=.atena/generated/mariz-playtest/bot-l4
for l4 in 0 1; do
  for meta in 0 1; do
    for hero in durvall brook maelor kayron; do
      ( ./Godot_v4.7.2-stable_win64.exe --headless --path . -s tools/bot_curva.gd -- $hero 6 0.08 9 60 $meta "" 1 $l4 2>&1 | grep -E "^CSV;|^GOLD;" > $OUT/l4-${l4}_meta${meta}_${hero}.csv ) &
    done
    wait
  done
done
echo feito > $OUT/FEITO
