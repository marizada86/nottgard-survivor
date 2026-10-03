const fs=require('fs');
const rows=fs.readFileSync(process.argv[2],'utf8').trim().split('\n').map(l=>l.split(';'));
const order=['dagruve','docas','shedaklah','molor','durao','feng_tu','shendilavri','goranthis','pilares'];
const metaN=['novato','veterano','loja cheia'];
const avg=a=>a.length?a.reduce((x,y)=>x+y,0)/a.length:NaN;
const med=a=>{if(!a.length)return NaN;const s=[...a].sort((x,y)=>x-y);return s[Math.floor(s.length/2)]};
for(const m of ['0','1','2']){
  const R=rows.filter(r=>r[0]===m); if(!R.length)continue;
  const runs=new Set(R.map(r=>r[1]+r[2])).size;
  console.log(`\n### Meta ${metaN[m]} (${runs} runs)`);
  console.log('| Fase | Chegaram | Morreram nela | PV mín. médio | s abaixo de 50 % (média) | Nível entrada→saída | Chefe (s, mediana) |');
  console.log('|---|---:|---:|---:|---:|---|---:|');
  for(const st of order){
    const S=R.filter(r=>r[3]===st); if(!S.length)continue;
    const died=S.filter(r=>r[12].startsWith('morreu')).length;
    const boss=S.map(r=>+r[11]).filter(x=>x>=0);
    console.log(`| ${st} | ${S.length} | ${died} (${Math.round(100*died/S.length)} %) | ${Math.round(avg(S.map(r=>+r[7])))} % | ${Math.round(avg(S.map(r=>+r[8])))} | ${avg(S.map(r=>+r[4])).toFixed(0)}→${avg(S.map(r=>+r[5])).toFixed(0)} | ${boss.length?Math.round(med(boss)):'—'} |`);
  }
}
// por herói: onde morre
console.log('\n### Por herói (todas as metas): fase de morte');
const heroes=[...new Set(rows.map(r=>r[1]))];
for(const h of heroes){const H=rows.filter(r=>r[1]===h&&r[12].startsWith('morreu'));const c={};H.forEach(r=>c[r[0]+':'+r[3]]=(c[r[0]+':'+r[3]]||0)+1);console.log(h,JSON.stringify(c))}
