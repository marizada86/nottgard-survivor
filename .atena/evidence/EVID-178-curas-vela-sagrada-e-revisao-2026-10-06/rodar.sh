#!/bin/bash
# Revisao das curas: Vela Sagrada nivel 5 forcada em todos os herois, meta 0/1. Uso: bash rodar.sh <rotulo> <sementes>
cd "$(dirname "$0")/../../.." || exit 1
LABEL=${1:-depois}; SEEDS=${2:-6}
HEROES="durvall leoric nyrelia sylas zynara kayron brook bromnor korrak maelor"
OUT=.atena/evidence/EVID-178-curas-vela-sagrada-e-revisao-2026-10-06/parts_$LABEL
mkdir -p "$OUT"
for meta in 0 1; do for h in $HEROES; do echo "$h $meta"; done; done | \
xargs -P 6 -L 1 bash -c './Godot_v4.7.2-stable_win64.exe --headless --path . -s tools/bal_bencaos.gd -- $0 '"$SEEDS"' none 0.1 4 60 $1 ${WEAPON:-vela_sagrada:5} 2>/dev/null | grep -E "^(CSV|KIND);" | sed "s/^CSV;/CSV;m$1;/;s/^KIND;/KIND;m$1;/" > '"$OUT"'/$0_m$1.csv'
