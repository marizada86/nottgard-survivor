#!/bin/bash
# Resume parts/*.csv por bencao e meta. Uso: bash resumo.sh > resumo.md
cd "$(dirname "$0")" || exit 1
cat parts/*.csv > curva_bencaos.csv
awk -F';' '
{ meta=$2; b=$3; run=meta SUBSEP b SUBSEP $4 SUBSEP $5; key[run]=meta SUBSEP b
  if ($12=="passou") pass[run]++
  if ($12=="morreu") died[run]=1
  if ($12=="morreu" && !($6 in dummy)) { dstage[run]=$6 }
  lv[run]=$8; dur[run]+=$9; dmg[run]+=$11; pv[run]=(run in pv && pv[run]<$10)?pv[run]:$10 }
END {
  for (r in key) { k=key[r]; n[k]++; sp[k]+=pass[r]+0; dd[k]+=died[r]+0; nl[k]+=lv[r]; dps[k]+=(dur[r]>0? dmg[r]/dur[r]:0); pvm[k]+=pv[r]; if (dstage[r]=="dagruve") d1[k]++ }
  for (k in n) { split(k,a,SUBSEP);
    printf "%s|%s|%d|%.2f|%.0f|%.1f|%.1f|%.0f|%.0f\n", a[1], a[2], n[k], sp[k]/n[k], 100*dd[k]/n[k], nl[k]/n[k], dps[k]/n[k], pvm[k]/n[k], 100*d1[k]/n[k] }
}' curva_bencaos.csv | sort -t'|' -k1,1 -k4,4nr
