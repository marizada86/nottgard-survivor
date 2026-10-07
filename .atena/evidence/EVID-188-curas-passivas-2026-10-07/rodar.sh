#!/bin/bash
# BAL-022: passivas forcadas em todos os herois, meta 0/1. Uso: bash rodar.sh <sementes>   (PASSIVAS="regeneracao:3 ..." para trocar)
cd "$(dirname "$0")/../../.." || exit 1
SEEDS=${1:-6}
HEROES="durvall leoric nyrelia sylas zynara kayron brook bromnor korrak maelor"
PASSIVAS=${PASSIVAS:-"regeneracao:3 regeneracao:5 cota_de_malha:5 forca:5"}
OUT=.atena/evidence/EVID-188-curas-passivas-2026-10-07/parts
mkdir -p "$OUT"
for meta in ${METAS:-0 1}; do for p in $PASSIVAS; do for h in $HEROES; do echo "$p $h $meta"; done; done; done | \
xargs -P 6 -L 1 bash -c './Godot_v4.7.2-stable_win64.exe --headless --path . -s tools/bal_bencaos.gd -- $1 '"$SEEDS"' none 0.1 4 60 $2 - $0 2>/dev/null | grep -E "^CSV;" | sed "s/^CSV;/CSV;m$2;/;s/^CSV;m$2;none/CSV;m$2;$0/" > '"$OUT"'/$(echo $0 | tr : _)_$1_m$2.csv'
