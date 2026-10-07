#!/bin/bash
# Resume parts/*.csv (CSV = fases; KIND = juramentos cumpridos/quebrados e exaustoes). Uso: bash resumo.sh
cd "$(dirname "$0")" || exit 1
cat parts/*.csv > curva_passivas.csv
awk -F';' '
$1=="CSV" { meta=$2; b=$3; run=meta SUBSEP b SUBSEP $4 SUBSEP $5; key[run]=meta SUBSEP b
  if ($12=="passou") pass[run]++
  lv[run]=$8; if ($6=="dagruve" && $12=="morreu") d1[run]=1 }
$1=="KIND" { run=$2 SUBSEP $3 SUBSEP $4 SUBSEP $5; kept[run]=$6; broken[run]=$7; exh[run]=$8; kk[run]=$2 SUBSEP $3 }
END {
  for (r in key) { k=key[r]; n[k]++; sp[k]+=pass[r]+0; nl[k]+=lv[r]; dd[k]+=d1[r]+0; K[k]+=kept[r]+0; B[k]+=broken[r]+0; X[k]+=exh[r]+0
    s=pass[r]+0; q[k]+=s*s }
  for (k in n) { split(k,a,SUBSEP); m=sp[k]/n[k]; v=q[k]/n[k]-m*m; se=sqrt((v>0?v:0)/n[k]); tot=K[k]+B[k]
    printf "%s|%s|%d|%.2f|%.2f|%.1f|%.0f|%d|%d|%.0f|%d\n", a[1], a[2], n[k], m, se, nl[k]/n[k], 100*dd[k]/n[k], K[k], B[k], (tot>0?100*K[k]/tot:0), X[k] }
}' curva_passivas.csv | sort
