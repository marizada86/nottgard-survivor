#!/bin/bash
S="C:/Users/HIGORR~1/AppData/Local/Temp/claude/F--dev-nottgard-survivor/126d09ba-1421-43e1-9a25-323db13912e9/scratchpad/sweep"
for c in base all1 all3 horda3 furia3 carapaca3 pressa3 fome3; do
  cat "$S"/${c}__*.csv | awk -F';' -v c=$c '
    { runs[$2";"$3]=1; stg[$4]++; if ($13=="passou") ok[$4]++; else if ($13 ~ /^morreu/) dead[$4]++; else other[$4]++;
      n++; if ($13=="passou") passed++;
      st=$4; if (st!="dagruve" && st!="docas") { late++; if ($13=="passou") latepass++; pvsum+=$8; pvn++ } }
    END { nr=0; for (r in runs) nr++;
      printf "%-10s runs=%d fases_vencidas/run=%.2f  taxa_passagem(fase3+)=%.0f%%  pv_min_medio(fase3+)=%.0f%%  passagens(fase3+)=%d\n", c, nr, passed/nr, (late>0? 100*latepass/late:0), (pvn>0? pvsum/pvn:0), late }'
done
