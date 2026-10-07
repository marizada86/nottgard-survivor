#!/bin/bash
# BAL-022: Korrak (Machado de Xar'gath) com roubo de vida variado. Uso: bash rodar.sh <sementes> (restaura data/weapons.json no fim)
cd "$(dirname "$0")/../../.." || exit 1
SEEDS=${1:-10}; E=.atena/evidence/EVID-189-xargath-roubo-de-vida-2026-10-07
cp data/weapons.json "$E/weapons_original.json"
for v in "0.10 0.05 A" "0.05 0.025 B" "0.0 0.0 C"; do set -- $v
  sed "s/\"lifesteal\": 0.10,/\"lifesteal\": $1,/; s/{\"lifesteal\": 0.05}/{\"lifesteal\": $2}/" "$E/weapons_original.json" > data/weapons.json
  for meta in 0 1; do
    ./Godot_v4.7.2-stable_win64.exe --headless --path . -s tools/bal_bencaos.gd -- korrak $SEEDS none 0.1 4 60 $meta 2>/dev/null | grep -E "^CSV;" | sed "s/^CSV;/CSV;m$meta;$3;/" > "$E/korrak_${3}_m$meta.csv" &
  done
  wait
done
cp "$E/weapons_original.json" data/weapons.json
