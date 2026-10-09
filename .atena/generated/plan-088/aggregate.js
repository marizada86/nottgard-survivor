// Agrega os CSV do bot_curva: por heroi e meta, fases vencidas, nivel maximo e minutos por run (media das sementes).
const fs = require('fs');
const dir = process.argv[2];
const heroes = ['durvall','brook','maelor','sylas','kayron','korrak','leoric','nyrelia','zynara','bromnor','arlindo','erik'];
const res = {};
for (const h of heroes) for (const m of [0,1]) {
  const f = `${dir}/${h}-meta${m}.txt`;
  if (!fs.existsSync(f)) continue;
  const runs = {};
  for (const l of fs.readFileSync(f,'utf8').split('\n')) {
    if (!l.startsWith('CSV;')) continue;
    const p = l.split(';'); // CSV;heroi;seed;fase;nv_entrada;nv_saida;dur_s;...;resultado
    const seed = p[2], nvOut = +p[5], dur = +p[6], r = p[p.length-1];
    const o = runs[seed] ||= {fases:0, nv:0, seg:0, morte1:null};
    if (r === 'passou') o.fases++;
    o.nv = Math.max(o.nv, nvOut); o.seg += dur;
  }
  const rs = Object.values(runs); if (!rs.length) continue;
  const avg = k => rs.reduce((a,b)=>a+b[k],0)/rs.length;
  res[`${h}|${m}`] = {n: rs.length, fases: avg('fases'), nv: avg('nv'), min: avg('seg')/60};
}
console.log(JSON.stringify(res));
