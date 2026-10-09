const fs=require("fs");
function load(dir,h,m){const f=`${dir}/${h}-meta${m}.txt`;if(!fs.existsSync(f))return null;const runs={};for(const l of fs.readFileSync(f,"utf8").split("\n")){if(!l.startsWith("CSV;"))continue;const p=l.split(";");const o=runs[p[2]]||={fases:0};if(p[p.length-1]==="passou")o.fases++}return Object.values(runs).map(r=>r.fases)}
const st=a=>{const n=a.length,m=a.reduce((x,y)=>x+y,0)/n,v=a.reduce((x,y)=>x+(y-m)**2,0)/(n-1);return {m,se:Math.sqrt(v/n),n}};
const H=["durvall","brook","maelor","sylas","kayron","korrak","leoric","nyrelia","zynara","bromnor","arlindo","erik"];
console.log("heroi meta | base (m±se) | agora (m±se) | diff | z");
for(const m of [0,1])for(const h of H){const A=load("bot",h,m),B=load("../v040-release/bot/after-b007-n15",h,m);if(!A||!B)continue;const a=st(A),b=st(B);const d=a.m-b.m,z=d/Math.sqrt(a.se**2+b.se**2);console.log(h.padEnd(8),m,`| ${b.m.toFixed(2)}±${b.se.toFixed(2)} | ${a.m.toFixed(2)}±${a.se.toFixed(2)} | ${d>=0?"+":""}${d.toFixed(2)} | ${z.toFixed(1)}${Math.abs(z)>=2?"  <==":""}`)}
