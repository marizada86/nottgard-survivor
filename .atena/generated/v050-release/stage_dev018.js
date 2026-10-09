// Stageia no índice só a entrada DEV-018 do plan.yaml (as DEV-019/020 são de outra sessão e ficam fora).
const { execSync } = require("child_process");
const fs = require("fs");
const file = ".atena/state/plan.yaml";
const work = fs.readFileSync(file, "utf8");
const a = work.indexOf("  - id: DEV-018");
const b = work.indexOf("  - id: DEV-019");
if (a < 0 || b < a) throw new Error("DEV-018 nao encontrada");
const entry = work.slice(a, b);
let head = execSync(`git show HEAD:${file}`, { encoding: "utf8", maxBuffer: 64 * 1024 * 1024 });
const k = "deferred_requests:\n";
if (!head.includes(k)) throw new Error("ancora");
head = head.replace(k, k + entry);
const tmp = process.env.TEMP + "/plan_head_dev018.yaml";
fs.writeFileSync(tmp, head);
const sha = execSync(`git hash-object -w "${tmp}"`, { encoding: "utf8" }).trim();
execSync(`git update-index --cacheinfo 100644,${sha},${file}`);
console.log("ok", sha);
