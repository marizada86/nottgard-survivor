#!/bin/bash
# PLAN-098 S-008: repeticao apos as otimizacoes, uma por log; exit code e duracao registrados.
cd /f/dev/nottgard-survivor
G=./Godot_v4.7.2-stable_win64.exe
O=.atena/generated/plan-098
run() { # nome, tempo_max, comando...
  local n=$1 t=$2; shift 2
  local s=$(date +%s)
  timeout $t "$@" > $O/s008-$n.log 2>&1
  local rc=$?
  echo "$n rc=$rc dur=$(( $(date +%s) - s ))s" | tee -a $O/s008-resumo.txt
}
: > $O/s008-resumo.txt
run suite 900 $G --headless --path . --script res://tests/run_all.gd
run smoke 400 $G --headless --path . res://tools/smoke.tscn
run controller_check 400 $G --headless --path . res://tools/controller_check.tscn
run mobile_buttons_check 400 $G --headless --path . res://tools/mobile_buttons_check.tscn
run kit_test 200 $G --path . res://tools/kit_test.tscn
run audit_projeto 400 $G --headless --path . -s tools/audit_projeto.gd
run backlog_check 200 powershell -NoProfile -ExecutionPolicy Bypass -File tools/backlog_check.ps1
run perf_probe_sim 900 $G --headless --path . res://tools/perf_probe.tscn -- sim 300 7 durvall todas
run perf_probe_funcoes 900 $G --headless --path . res://tools/perf_probe.tscn -- funcoes 300 7 durvall dagruve,shedaklah,molor
echo FIM >> $O/s008-resumo.txt
