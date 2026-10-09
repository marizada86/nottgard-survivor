#!/bin/bash
# PLAN-088 B-002 (isolamento): Sylas, 45 sementes, metas 0 e 1.
#   (a) arvore atual SEM a faixa de borda (bot_curva_noedge.gd)
#   (b) commit da linha de base aa496f2 em worktree proprio (codigo antigo inteiro)
cd /f/dev/nottgard-survivor
out=.atena/generated/plan-088/iso; rm -f $out/DONE
G=./Godot_v4.7.2-stable_win64.exe
for meta in 0 1; do
  $G --headless --path . -s .atena/generated/plan-088/bot_curva_noedge.gd -- sylas 45 0.08 9 60 $meta 2>&1 | grep -E "^CSV|^GOLD" > $out/sylas-noedge-meta$meta.txt &
done
WT=/f/dev/_wt_base
rm -rf $WT; git worktree add -q --detach $WT aa496f2
cp -r .godot $WT/.godot
(cd $WT && $(pwd -W >/dev/null 2>&1; echo /f/dev/nottgard-survivor)/Godot_v4.7.2-stable_win64.exe --headless --path . --import >/dev/null 2>&1)
for meta in 0 1; do
  (cd $WT && /f/dev/nottgard-survivor/Godot_v4.7.2-stable_win64.exe --headless --path . -s tools/bot_curva.gd -- sylas 45 0.08 9 60 $meta 2>&1 | grep -E "^CSV|^GOLD" > /f/dev/nottgard-survivor/$out/sylas-aa496f2-meta$meta.txt) &
done
wait
echo done > $out/DONE
