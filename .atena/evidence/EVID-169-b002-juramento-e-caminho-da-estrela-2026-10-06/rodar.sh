#!/bin/bash
# SPEC-129 B-002: Juramento de Lliira e Caminho da Estrela x 10 herois x meta 0/1. Uso: bash rodar.sh <sementes>
cd "$(dirname "$0")/../../.." || exit 1
SEEDS=${1:-6}
HEROES="durvall leoric nyrelia sylas zynara kayron brook bromnor korrak maelor"
BOONS=${BOONS:-"lliira_juramento tou_um_caminho"}
OUT=.atena/evidence/EVID-169-b002-juramento-e-caminho-da-estrela-2026-10-06/parts
mkdir -p "$OUT"
for meta in ${METAS:-0 1}; do for b in $BOONS; do for h in $HEROES; do echo "$b $h $meta"; done; done; done | \
xargs -P 6 -L 1 bash -c './Godot_v4.7.2-stable_win64.exe --headless --path . -s tools/bal_bencaos.gd -- $1 '"$SEEDS"' $0 0.1 4 60 $2 2>/dev/null | grep -E "^(CSV|KIND);" | sed "s/^CSV;/CSV;m$2;/;s/^KIND;/KIND;m$2;/" > '"$OUT"'/$0_$1_m$2.csv'
