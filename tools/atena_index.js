// Gera .atena/specs/INDEX.md a partir do cabeçalho de cada spec (id, título e status).
//   node tools/atena_index.js
// Só leitura dos arquivos de spec; escreve apenas o INDEX.md. Rode de novo quando os status mudarem.
const fs = require('fs');
const path = require('path');
const dir = path.join(__dirname, '..', '.atena', 'specs');
const files = fs.readdirSync(dir).filter(f => /^SPEC-\d+.*\.md$/.test(f)).sort();

function field(text, key) {
  const m = text.match(new RegExp('^' + key + ':\s*(.*)$', 'm'));
  if (!m) return '';
  return m[1].trim().replace(/^"(.*)"$/, '$1').replace(/^'(.*)'$/, '$1');
}

function bucket(status) {
  const s = status.toLowerCase();
  if (/substitu[ií]da|subsumida/.test(s)) return 'substituída';
  if (/paus/.test(s)) return 'pausada';
  if (/rascunho|proposta|planejada|preparada|draft|propos/.test(s) && !/implement|executada|conclu/.test(s)) return 'aberta (rascunho ou planejada)';
  if (/aprovada|em execu/.test(s) && !/implement|executada|conclu|publicada/.test(s)) return 'aprovada, sem fechar';
  return 'entregue';
}

const rows = files.map(f => {
  const t = fs.readFileSync(path.join(dir, f), 'utf8').split(/\r?\n/).slice(0, 40).join('\n');
  const id = (f.match(/^SPEC-(\d+)/) || [])[1];
  return {id, file: f, title: field(t, 'title') || f.replace(/^SPEC-\d+-/, '').replace(/\.md$/, ''), status: field(t, 'status')};
});

const groups = {};
for (const r of rows) (groups[bucket(r.status)] ||= []).push(r);
const order = ['aberta (rascunho ou planejada)', 'aprovada, sem fechar', 'pausada', 'entregue', 'substituída'];
const dup = {};
for (const r of rows) (dup[r.id] ||= []).push(r.file);

let out = '# Índice de specs\n\n';
out += 'Gerado por `node tools/atena_index.js` (não editar à mão). Agrupa pelo **status do cabeçalho** de cada spec; o estado vivo dos planos está em `.atena/state/INDEX.md`.\n\n';
out += '| Grupo | Specs |\n|---|--:|\n';
for (const g of order) out += `| ${g} | ${(groups[g] || []).length} |\n`;
out += `| **total** | **${rows.length}** |\n\n`;
const repeated = Object.entries(dup).filter(([, v]) => v.length > 1);
if (repeated.length) {
  out += '## Números repetidos\n\n';
  for (const [id, v] of repeated) out += `- SPEC-${id}: ${v.map(x => '`' + x + '`').join(' e ')}\n`;
  out += '\n';
}
for (const g of order) {
  const list = groups[g] || [];
  if (!list.length) continue;
  out += `## ${g[0].toUpperCase() + g.slice(1)} (${list.length})\n\n| Spec | Título | Status |\n|---|---|---|\n`;
  for (const r of list) {
    const status = r.status.replace(/\|/g, '/').slice(0, 150);
    out += `| [SPEC-${r.id}](${r.file}) | ${r.title.replace(/\|/g, '/').slice(0, 90)} | ${status} |\n`;
  }
  out += '\n';
}
fs.writeFileSync(path.join(dir, 'INDEX.md'), out);
console.log('INDEX.md: ' + rows.length + ' specs; ' + order.map(g => g + '=' + (groups[g] || []).length).join('; '));
