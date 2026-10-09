// Uso: node stage_hunks.js <arquivo> <regex>  -> stageia no índice só os hunks (diff -U0) cujas linhas +/- casam com a regex.
// Ferramenta de registro do PLAN-083: separa as mudanças desta sessão das de outras sessões na mesma árvore.
const { execSync } = require("child_process");
const fs = require("fs");
const [file, rx] = process.argv.slice(2);
const re = new RegExp(rx);
const diff = execSync(`git diff -U0 -- "${file}"`, { encoding: "utf8", maxBuffer: 64 * 1024 * 1024 });
const parts = diff.split(/^(?=@@ )/m);
const header = parts.shift();
const picked = parts.filter(h => h.split("\n").slice(1).some(l => (l.startsWith("+") || l.startsWith("-")) && re.test(l)));
console.log(`${file}: ${picked.length} de ${parts.length} hunks`);
if (!picked.length) process.exit(0);
const patch = header + picked.join("");
const tmp = process.env.TEMP + "/stage_hunks.patch";
fs.writeFileSync(tmp, patch);
execSync(`git apply --cached --unidiff-zero "${tmp}"`, { stdio: "inherit" });
