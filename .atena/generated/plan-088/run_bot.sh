#!/bin/bash
# PLAN-088 B-002: bot por heroi na arvore atual (bot que recua da faixa de borda), 12 herois, metas 0 e 1,
# 15 sementes, dt 0,08, 9 fases, lado 60. Mesma tabela do EVID-208/217.
cd /f/dev/nottgard-survivor
out=.atena/generated/plan-088/bot; mkdir -p $out; rm -f $out/DONE
git rev-parse HEAD > $out/HEAD.txt
for meta in 1 0; do
  for h in durvall brook maelor sylas kayron korrak leoric nyrelia zynara bromnor arlindo erik; do
    ./Godot_v4.7.2-stable_win64.exe --headless --path . -s tools/bot_curva.gd -- $h 15 0.08 9 60 $meta 2>&1 | grep -E "^CSV|^GOLD" > $out/$h-meta$meta.txt &
    while [ $(jobs -r | wc -l) -ge 5 ]; do wait -n; done
  done
done
wait
echo done > $out/DONE
