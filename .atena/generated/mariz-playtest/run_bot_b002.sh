#!/bin/bash
# PLAN-105 B-002 (EVID-260): antes (Zuggtmoy e Molydeus sem mecanica) e depois; comeca em shedaklah e em durao; meta 1; 4 herois x 8 sementes.
cd /f/dev/nottgard-survivor
OUT=.atena/generated/mariz-playtest/bot-b002
for variant in antes depois; do
  off=""; [ "$variant" = "antes" ] && off="zuggtmoy,molydeus_chefe"
  for start in shedaklah durao; do
    for hero in durvall brook maelor kayron; do
      ( ./Godot_v4.7.2-stable_win64.exe --headless --path . -s tools/bot_curva.gd -- $hero 8 0.08 4 60 1 "" 1 1 1 $start "$off" 2>&1 | grep -E "^CSV;" > $OUT/${variant}_${start}_${hero}.csv ) &
    done
    wait
  done
done
echo feito > $OUT/FEITO
