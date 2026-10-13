#!/bin/bash
# PLAN-084 S-009: mesma rodada do EVID-208 (5 sementes, dt 0,08, 9 fases, lado 60, metas 1 e 0), com a nevoa de borda e a Mare em todas as fases.
# Uso: NOTT_SEM_NEVOA=1 bash run_s009.sh controle   (sem a mecanica)  |  bash run_s009.sh com-nevoa   (so meta 1, veterano)
cd /f/dev/nottgard-survivor
out=.atena/generated/nevoa-borda/bot/$1; mkdir -p $out
run() { ./Godot_v4.7.2-stable_win64.exe --headless --path . -s tools/bot_curva.gd -- $1 5 0.08 9 60 $2 2>&1 | grep -E "^CSV|^GOLD" > $out/$1-meta$2.txt; }
for meta in 1; do
  for h in durvall brook maelor sylas kayron korrak leoric nyrelia zynara bromnor; do
    run $h $meta &
    while [ $(jobs -r | wc -l) -ge 5 ]; do sleep 2; done
  done
done
wait
echo done > $out/DONE
