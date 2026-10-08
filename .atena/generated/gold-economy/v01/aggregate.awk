# entrada: arquivos CSV;/GOLD; de um perfil. Saida: tabela por fase e resumo por run.
BEGIN{FS=";"; n=split("dagruve docas shedaklah molor durao feng_tu shendilavri goranthis pilares",O," "); for(i=1;i<=n;i++)T[O[i]]=i-1}
$1=="CSV"{k=$2" "$3; res[k" "$4]=$13; last[k]=$4; lastres[k]=$13; runs[k]=1}
$1=="GOLD"{k=$2" "$3; g[$4]+=$5; c[$4]++; for(j=6;j<=14;j++)s[$4,j]+=$j; tot[k]+=$5; if(res[k" "$4]~/passou|venceu|fim/)bonus[k]+=60*(1+T[$4])}
END{
 nm=split("abate elite chefe quebravel evento venda oferta arma outro",N," ");
 printf "fase;runs_na_fase;ouro_medio_fase;"; for(j=1;j<=nm;j++)printf "%s%%;",N[j]; print "";
 for(i=1;i<=n;i++){f=O[i]; if(!c[f])continue; printf "%s;%d;%.0f;",f,c[f],g[f]/c[f]; for(j=1;j<=nm;j++)printf "%.0f;",100*s[f,j+5]/(g[f]?g[f]:1); print ""}
 nr=0; for(k in runs){nr++; e=tot[k]+bonus[k]; if(lastres[k]~/morreu/)e*=0.5; E[nr]=e; sum+=e; raw+=tot[k]; if(lastres[k]~/morreu/)d++; if(lastres[k]~/venceu|fim/)w++; B+=bonus[k]}
 asort(E); printf "RESUMO runs=%d mortes=%d vitorias=%d bruto_medio=%.0f bonus_chefe_medio=%.0f quartel_medio=%.0f mediana=%.0f min=%.0f max=%.0f\n",nr,d,w,raw/nr,B/nr,sum/nr,E[int((nr+1)/2)],E[1],E[nr]
}
