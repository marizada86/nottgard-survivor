#!/bin/bash
# SPEC-129 B-003: blessings rebalanced and new, x 10 heroes x meta 0/1. Uso: bash rodar.sh <sementes>
cd "$(dirname "$0")/../../.." || exit 1
SEEDS=${1:-6}
HEROES="durvall leoric nyrelia sylas zynara kayron brook bromnor korrak maelor"
BOONS=${BOONS:-"sendrinah_cura helion_tarn"}
OUT=.atena/evidence/EVID-178-curas-vela-sagrada-e-revisao-2026-10-06/parts_barreira
mkdir -p "$OUT"
for meta in ${METAS:-0 1}; do for b in $BOONS; do for h in $HEROES; do echo "$b $h $meta"; done; done; done | \
xargs -P 6 -L 1 bash -c './Godot_v4.7.2-stable_win64.exe --headless --path . -s tools/bal_bencaos.gd -- $1 '"$SEEDS"' $0 0.1 4 60 $2 2>/dev/null | grep -E "^(CSV|KIND);" | sed "s/^CSV;/CSV;m$2;/;s/^KIND;/KIND;m$2;/" > '"$OUT"'/$0_$1_m$2.csv'
