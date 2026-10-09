#!/bin/bash
# PLAN-088 B-002 (isolamento 2): Kayron, 45 sementes, metas 0 e 1: arvore atual sem faixa e commit aa496f2.
cd /f/dev/nottgard-survivor
out=.atena/generated/plan-088/iso; rm -f $out/DONE2
G=/f/dev/nottgard-survivor/Godot_v4.7.2-stable_win64.exe
for meta in 0 1; do
  $G --headless --path . -s .atena/generated/plan-088/bot_curva_noedge.gd -- kayron 45 0.08 9 60 $meta 2>&1 | grep -E "^CSV|^GOLD" > $out/kayron-noedge-meta$meta.txt &
  (cd /f/dev/_wt_base && $G --headless --path . -s tools/bot_curva.gd -- kayron 45 0.08 9 60 $meta 2>&1 | grep -E "^CSV|^GOLD" > /f/dev/nottgard-survivor/$out/kayron-aa496f2-meta$meta.txt) &
done
wait
echo done > $out/DONE2
