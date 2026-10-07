#!/bin/bash
# SPEC-129 B-001: matriz bencao x heroi x meta (novato 0 / veterano 1). Uso: bash rodar.sh <sementes>
cd "$(dirname "$0")/../../.." || exit 1
SEEDS=${1:-6}
HEROES="durvall leoric nyrelia sylas zynara kayron brook bromnor korrak maelor"
BOONS="none sendrinah_cura sendrinah_vida mask_sombras mask_ladrao lliira_alegria lliira_sorte shar_noite shar_perda selune_luar selune_guia ghaunadaur_fome ghaunadaur_olho tou_um_estrela helion_saber"
OUT=.atena/evidence/EVID-166-b001-medicao-das-bencaos-2026-10-06/parts; mkdir -p "$OUT"
for meta in 0 1; do for b in $BOONS; do for h in $HEROES; do echo "$b $h $meta"; done; done; done | \
xargs -P 6 -L 1 bash -c './Godot_v4.7.2-stable_win64.exe --headless --path . -s tools/bal_bencaos.gd -- $1 '"$SEEDS"' $0 0.1 4 60 $2 2>/dev/null | grep "^CSV;" | sed "s/^CSV;/CSV;m$2;/" > '"$OUT"'/$0_$1_m$2.csv'
