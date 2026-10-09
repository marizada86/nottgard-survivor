#!/bin/bash
# PLAN-083 B-005 S-017: mesma rodada do EVID-208 (15 sementes, dt 0,08, 9 fases, lado 60, metas 1 e 0), agora com os segredos das outras fases.
# Uso: bash run_b005.sh <pasta-de-saida>
cd /f/dev/nottgard-survivor
out=.atena/generated/v050-release/bot/$1; mkdir -p $out
run() { ./Godot_v4.7.2-stable_win64.exe --headless --path . -s tools/bot_curva.gd -- $1 15 0.08 9 60 $2 2>&1 | grep -E "^CSV|^GOLD" > $out/$1-meta$2.txt; }
for meta in 1 0; do
  for h in durvall brook maelor sylas kayron korrak leoric nyrelia zynara bromnor; do
    run $h $meta &
    while [ $(jobs -r | wc -l) -ge 5 ]; do wait -n; done
  done
done
wait
echo done > $out/DONE
