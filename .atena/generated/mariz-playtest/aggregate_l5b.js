// CSV;heroi;seed;fase;nv_entrada;nv_saida;dur_s;pv_min_pct;s_abaixo_50;s_abaixo_25;dano_recebido;chefe_s;resultado
const fs=require('fs'),path=require('path');
const dir=path.join(__dirname,'bot-l5b');
const rows=[];
for(const f of fs.readdirSync(dir)){ const m=f.match(/^l5-(\d)_meta(\d)_(\w+)\.csv$/); if(!m) continue;
  for(const line of fs.readFileSync(path.join(dir,f),'utf8').split(/\r?\n/)){ if(!line.startsWith('CSV;')) continue;
    const p=line.split(';'); rows.push({l2:+m[1],meta:+m[2],hero:p[1],seed:+p[2],stage:p[3],lvIn:+p[4],lvOut:+p[5],dur:+p[6],pvmin:+p[7],b50:+p[8],b25:+p[9],dmg:+p[10],boss:+p[11],res:p[12]}); } }
const stages=['dagruve','docas','shedaklah','molor','durao','feng_tu','shendilavri','goranthis','pilares'];
const avg=a=>a.length?a.reduce((x,y)=>x+y,0)/a.length:NaN;
const f=(x,d=1)=>Number.isNaN(x)?'-':x.toFixed(d);
for(const meta of [0,1]){
  console.log(`\n### meta ${meta} (${meta?'veterano':'novato'})`);
  console.log('| fase | execuções (antes/depois) | passou % (antes → depois) | morreu % | duração s | PV mín % | dano recebido | chefe caiu em s (n) |');
  console.log('|---|---|---|---|---|---|---|---|');
  for(const s of stages){
    const A=rows.filter(r=>r.meta===meta&&r.stage===s&&r.l2===0), B=rows.filter(r=>r.meta===meta&&r.stage===s&&r.l2===1);
    if(!A.length&&!B.length) continue;
    const pass=a=>a.length?100*a.filter(r=>r.res==='passou'||r.res==='fim'||r.res==='venceu').length/a.length:NaN;
    const die=a=>a.length?100*a.filter(r=>r.res.startsWith('morreu')).length/a.length:NaN;
    const bossA=A.filter(r=>r.boss>=0).map(r=>r.boss), bossB=B.filter(r=>r.boss>=0).map(r=>r.boss);
    console.log(`| ${s} | ${A.length}/${B.length} | ${f(pass(A),0)} → ${f(pass(B),0)} | ${f(die(A),0)} → ${f(die(B),0)} | ${f(avg(A.map(r=>r.dur)),0)} → ${f(avg(B.map(r=>r.dur)),0)} | ${f(avg(A.map(r=>r.pvmin)),0)} → ${f(avg(B.map(r=>r.pvmin)),0)} | ${f(avg(A.map(r=>r.dmg)),0)} → ${f(avg(B.map(r=>r.dmg)),0)} | ${f(avg(bossA),0)} (${bossA.length}) → ${f(avg(bossB),0)} (${bossB.length}) |`);
  }
  const reach=l2=>{const a=rows.filter(r=>r.meta===meta&&r.l2===l2);const by={};for(const r of a){const k=r.hero+':'+r.seed;by[k]=Math.max(by[k]||0,stages.indexOf(r.stage)+1);}const v=Object.values(by);return {n:v.length,mean:avg(v)};};
  const ra=reach(0), rb=reach(1);
  console.log(`\nFases alcançadas por execução (média): antes ${f(ra.mean,2)} (n=${ra.n}) → depois ${f(rb.mean,2)} (n=${rb.n})`);
}
