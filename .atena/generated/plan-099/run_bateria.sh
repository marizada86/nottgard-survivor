#!/bin/bash
# PLAN-098 S-002: verificacoes existentes, uma por log; exit code e duracao registrados.
cd /f/dev/nottgard-survivor
G=./Godot_v4.7.2-stable_win64.exe
O=.atena/generated/plan-099
run() { # nome, tempo_max, comando...
  local n=$1 t=$2; shift 2
  local s=$(date +%s)
  timeout $t "$@" > $O/bat-$n.log 2>&1
  local rc=$?
  echo "$n rc=$rc dur=$(( $(date +%s) - s ))s" | tee -a $O/bat-resumo.txt
}
: > $O/bat-resumo.txt
run suite 900 $G --headless --path . --script res://tests/run_all.gd
run smoke 400 $G --headless --path . res://tools/smoke.tscn
run controller_check 400 $G --headless --path . res://tools/controller_check.tscn
run mobile_buttons_check 400 $G --headless --path . res://tools/mobile_buttons_check.tscn
run kit_test 200 $G --path . res://tools/kit_test.tscn
run audit_projeto 400 $G --headless --path . -s tools/audit_projeto.gd
run backlog_check 200 powershell -NoProfile -ExecutionPolicy Bypass -File tools/backlog_check.ps1
echo FIM >> $O/bat-resumo.txt
