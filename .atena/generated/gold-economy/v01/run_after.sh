#!/bin/bash
# BAL-023 B-003: mesma rodada da base, depois das correcoes. Uso: bash run_after.sh <pasta-de-saida> [marcas]
cd /f/dev/nottgard-survivor
out=.atena/generated/gold-economy/v01/$1; mkdir -p $out; marks=${2:-}
run() { ./Godot_v4.7.2-stable_win64.exe --headless --path . -s tools/bot_curva.gd -- $1 5 0.08 9 60 $2 $marks 2>&1 | grep -E "^CSV|^GOLD" > $out/$1-meta$2.txt; }
for meta in 1 0; do
  for h in durvall brook maelor sylas kayron korrak leoric nyrelia zynara bromnor; do
    run $h $meta &
    while [ $(jobs -r | wc -l) -ge 5 ]; do sleep 2; done
  done
  [ -n "$marks" ] && break
done
wait
echo done > $out/DONE
