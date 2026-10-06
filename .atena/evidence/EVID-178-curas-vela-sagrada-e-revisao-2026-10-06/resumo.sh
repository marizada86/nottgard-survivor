#!/bin/bash
# Uso: bash resumo.sh <rotulo>  (le curva_<rotulo>.csv). Colunas: meta|n|fases|ep|nivel|%morre_dagruve|pv_min_medio|dur_med_s
cd "$(dirname "$0")" || exit 1
awk -F';' '
$1=="CSV" { meta=$2; run=meta SUBSEP $4 SUBSEP $5; mk[run]=meta
  if ($12=="passou") pass[run]++
  lv[run]=$8; if ($6=="dagruve" && $12=="morreu") d1[run]=1
  dur[run]+=$9; pv[run]=(run in pv && pv[run]<$10)?pv[run]:$10 }
END { for (r in mk) { m=mk[r]; n[m]++; s=pass[r]+0; sp[m]+=s; q[m]+=s*s; nl[m]+=lv[r]; dd[m]+=d1[r]+0; pm[m]+=pv[r]; du[m]+=dur[r] }
  for (m in n) { mm=sp[m]/n[m]; v=q[m]/n[m]-mm*mm; printf "%s|%d|%.2f|%.2f|%.1f|%.0f|%.0f|%.0f\n", m, n[m], mm, sqrt((v>0?v:0)/n[m]), nl[m]/n[m], 100*dd[m]/n[m], pm[m]/n[m], du[m]/n[m] } }' curva_$1.csv | sort
