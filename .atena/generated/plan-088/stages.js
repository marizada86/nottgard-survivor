const fs=require("fs");
const dir=process.argv[2];const stages={};
for(const f of fs.readdirSync(dir)){if(!/-meta\d\.txt$/.test(f)||(process.argv[3]==="10"&&/^(arlindo|erik)-/.test(f)))continue;for(const l of fs.readFileSync(dir+"/"+f,"utf8").split("\n")){if(!l.startsWith("CSV;"))continue;const p=l.split(";");const s=p[3],r=p[p.length-1].startsWith("passou")?"passou":p[p.length-1].startsWith("morreu")?"morreu":"outro";const o=stages[s]||={entrou:0,passou:0,morreu:0,outro:0};o.entrou++;o[r]++}}
console.log("fase | entraram | passaram | morreram | taxa de passagem");
for(const s of Object.keys(stages))console.log(s.padEnd(10),String(stages[s].entrou).padStart(4),String(stages[s].passou).padStart(4),String(stages[s].morreu).padStart(4),(100*stages[s].passou/stages[s].entrou).toFixed(0)+"%");
