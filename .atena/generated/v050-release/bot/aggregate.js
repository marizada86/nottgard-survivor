// Uso: node aggregate.js <pasta-antes> <pasta-depois>  -> tabela por herói e meta (média de 5 sementes)
// Colunas do CSV: CSV;heroi;seed;fase;nv_entrada;nv_saida;dur_s;pv_min_pct;s_abaixo_50;s_abaixo_25;dano;chefe_s;resultado
const fs = require("fs");
const [A, B] = process.argv.slice(2);
const heroes = ["durvall", "brook", "maelor", "sylas", "kayron", "korrak", "leoric", "nyrelia", "zynara", "bromnor"];
function load(dir, hero, meta) {
  const f = `${dir}/${hero}-meta${meta}.txt`;
  if (!fs.existsSync(f)) return null;
  const rows = fs.readFileSync(f, "utf8").split("\n").filter(l => l.startsWith("CSV;")).map(l => l.split(";"));
  const seeds = {};
  for (const r of rows) (seeds[r[2]] ||= []).push(r);
  let n = 0, stages = 0, level = 0, time = 0, passed1 = 0;
  for (const s of Object.keys(seeds)) {
    const rs = seeds[s]; n++;
    const passed = rs.filter(r => r[12] === "passou").length;
    stages += passed;
    level += Number(rs[rs.length - 1][5]);
    time += rs.reduce((a, r) => a + Number(r[6]), 0);
    if (rs[0][12] === "passou") passed1++;
  }
  return {n, stages: stages / n, level: level / n, time: time / n, passed1: passed1 / n};
}
function fmt(x) { return x === null ? "—" : `${x.stages.toFixed(1)} fases vencidas · nv ${x.level.toFixed(1)} · ${(x.time / 60).toFixed(1)} min · Dagruve ${(x.passed1 * 100).toFixed(0)}%`; }
for (const meta of [0, 1]) {
  console.log(`\nMETA ${meta} (${meta === 0 ? "novato" : "veterano"})`);
  console.log("| Herói | Antes | Depois |\n|---|---|---|");
  let sa = 0, sb = 0, la = 0, lb = 0, ta = 0, tb = 0, k = 0;
  for (const h of heroes) {
    const a = load(A, h, meta), b = load(B, h, meta);
    console.log(`| ${h} | ${fmt(a)} | ${fmt(b)} |`);
    if (a && b) { sa += a.stages; sb += b.stages; la += a.level; lb += b.level; ta += a.time; tb += b.time; k++; }
  }
  console.log(`| **média** | ${(sa / k).toFixed(2)} fases · nv ${(la / k).toFixed(1)} · ${(ta / k / 60).toFixed(1)} min | ${(sb / k).toFixed(2)} fases · nv ${(lb / k).toFixed(1)} · ${(tb / k / 60).toFixed(1)} min |`);
}
