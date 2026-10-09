const fs=require("fs");
const a=JSON.parse(fs.readFileSync("agg-agora.json")), b=JSON.parse(fs.readFileSync("agg-base-evid208.json")), c=JSON.parse(fs.readFileSync("agg-evid217.json"));
const H=["durvall","brook","maelor","sylas","kayron","korrak","leoric","nyrelia","zynara","bromnor","arlindo","erik"];
const f=(x)=>x?`${x.fases.toFixed(2)} · nv ${x.nv.toFixed(1)} · ${x.min.toFixed(1)} min`:"—";
for(const m of [0,1]){console.log("META",m);for(const h of H){const k=h+"|"+m;console.log(h.padEnd(8),"| base EVID-208:",f(b[k]).padEnd(26),"| EVID-217:",f(c[k]).padEnd(26),"| agora:",f(a[k]))}
 const avg=(o,hs)=>{let s=0,n=0;for(const h of hs){const x=o[h+"|"+m];if(x){s+=x.fases;n++}}return n?(s/n).toFixed(2):"—"};
 const ten=H.slice(0,10);console.log("media 10 herois: base",avg(b,ten),"EVID-217",avg(c,ten),"agora",avg(a,ten),"| agora 12:",avg(a,H))}
