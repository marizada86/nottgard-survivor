#!/bin/bash
# BAL-022: Korrak com roubo de vida do Impacto de Xar'gath (data/abilities.json) variado. Uso: bash rodar.sh <sementes> (restaura o arquivo no fim)
cd "$(dirname "$0")/../../.." || exit 1
SEEDS=${1:-10}; E=.atena/evidence/EVID-190-korrak-cura-do-impacto-2026-10-07
cp data/abilities.json "$E/abilities_original.json"
for v in "0.1 D" "0.05 E"; do set -- $v
  sed "s/\"lifesteal\": 0.2,/\"lifesteal\": $1,/" "$E/abilities_original.json" > data/abilities.json
  for meta in 0 1; do
    ./Godot_v4.7.2-stable_win64.exe --headless --path . -s tools/bal_bencaos.gd -- korrak $SEEDS none 0.1 4 60 $meta 2>/dev/null | grep -E "^CSV;" | sed "s/^CSV;/CSV;m$meta;$2;/" > "$E/korrak_${2}_m$meta.csv" &
  done
  wait
done
cp "$E/abilities_original.json" data/abilities.json
rm -f "$E/abilities_original.json"
