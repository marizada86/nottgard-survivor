// Régua do rascunho PROPOSTA-evolucoes-armas-sem-evolucao (2026-10-13). Só lê data/weapons.json; não altera nada.
//   node .atena/generated/evolucoes-armas-2026-10-13/regua.js
// ST   = DPS esperado em alvo único (mod de atributo +2, sem crítico, sem erro), mesma conta de tools/bal_conteudo_novo.gd.
// MULTI(rho) = ST x alvos atingidos; rho = inimigos por unidade² (0,2 = grupo médio; 0,4 = horda). Projéteis: 1 + pierce (máx. 4).
// Zona: dano por tick x (duração/tick) / recarga. Hipótese de densidade: NÃO medida em campo.
const fs = require("fs");
const w = JSON.parse(fs.readFileSync("data/weapons.json", "utf8"));
const avg = s => { const m = /^(\d+)d(\d+)$/.exec(s); return (+m[1]) * ((+m[2] + 1) / 2); };
function params(def, lv) { const p = { ...def }; (def.levels || []).slice(0, lv - 1).forEach(l => { for (const k in l) { if (k === "dice") p.dice = l[k]; else p[k] = (+p[k] || 0) + l[k]; } }); return p; }
function m(p, rho) {
  const per = avg(p.dice) + 2 + (+p.dmg || 0), n = Math.max(1, +p.count || 1); let st, t;
  if (p.kind === "zone") { st = per * ((+p.duration || 3) / (+p.tick || 0.5)) / p.cd; t = Math.max(1, rho * Math.PI * p.radius ** 2); }
  else if (p.kind === "nova") { st = per / p.cd; t = Math.max(1, rho * Math.PI * p.radius ** 2); }
  else if (p.kind === "melee") { st = per / p.cd; t = Math.max(1, rho * (p.cone / 360) * Math.PI * p.range ** 2); }
  else { st = per * n / p.cd; t = 1 + Math.min(+p.pierce || 0, 4); }
  return [st, st * t];
}
const f = x => x.toFixed(1);
const PROP = {
  dominar_pessoa:     { id: "dominio_coletivo",   kind: "bolt",  dice: "2d8",  cd: 2.6, count: 3, pierce: 1, stun: 3 },
  golpe_esmagador:    { id: "maca_demolidora",    kind: "melee", dice: "3d10", cd: 1.3, range: 2.2, cone: 80, stun: 1.5 },
  martelo_da_gloria:  { id: "martelo_do_alvorecer", kind: "melee", dice: "4d10", cd: 1.8, range: 2.3, cone: 130, knock: 2.0, stun: 1 },
  raio_enfraquecedor: { id: "raio_da_ruina",      kind: "bolt",  dice: "2d6",  cd: 1.2, count: 3, pierce: 2, weaken: 4 },
  sopro_de_estrela:   { id: "mare_da_concha",     kind: "nova",  dice: "5d8",  cd: 4.6, radius: 4.8, slow: 3, weaken: 2 },
  ampulheta:          { id: "silencio_absoluto",  kind: "nova",  dice: "4d8",  cd: 4.0, radius: 5.0, stun: 3 },
  vela_sagrada:       { id: "cirio_eterno",       kind: "nova",  dice: "3d8",  cd: 2.8, radius: 3.2, heal: 1.5 },
  machado_de_xargath: { id: "machado_do_abismo",  kind: "melee", dice: "3d10", cd: 1.2, range: 2.4, cone: 120, burn: 4, lifesteal: 0.03 },
};
console.log("| Base (nv5) | ST | MULTI 0,2 | MULTI 0,4 | Evolução proposta | ST | MULTI 0,2 | MULTI 0,4 | x ST | x MULTI 0,2 |");
console.log("|---|--:|--:|--:|---|--:|--:|--:|--:|--:|");
for (const [bid, e] of Object.entries(PROP)) {
  const b = params(w[bid], 5), a = m(b, 0.2), a4 = m(b, 0.4), c = m(e, 0.2), c4 = m(e, 0.4);
  console.log(`| ${w[bid].name} | ${f(a[0])} | ${f(a[1])} | ${f(a4[1])} | ${e.id} | ${f(c[0])} | ${f(c[1])} | ${f(c4[1])} | ${(c[0] / a[0]).toFixed(1)}x | ${(c[1] / a[1]).toFixed(1)}x |`);
}
console.log("\nReferência: evoluções existentes (ST | MULTI 0,2 | MULTI 0,4)");
for (const id of Object.keys(w).filter(i => w[i].src === "Evolução")) { const a = m(params(w[id], 1), 0.2), b = m(params(w[id], 1), 0.4); console.log(`${id}: ${f(a[0])} | ${f(a[1])} | ${f(b[1])}`); }
