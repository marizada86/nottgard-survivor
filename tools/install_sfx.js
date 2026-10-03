/*
 * Instala SFX reais (MP3/OGG/WAV) no manifesto de áudio.
 * Uso, da raiz do projeto:
 *   node tools/install_sfx.js ui.click=F:/audio-ui-click.mp3 combat.impact=F:/hit_a.mp3,F:/hit_b.mp3
 *
 * Para cada evento: copia os arquivos para assets/audio/sfx/<pasta>/<evento>_NN.<ext>, troca a lista
 * `files` do evento (ou cria o evento, se não existir) mantendo bus/volume/cooldown, e remove um
 * alias com o mesmo nome, que senão continuaria desviando o evento para o placeholder.
 * `--manifest <arquivo>` edita outro JSON; `--no-copy` só edita o manifesto.
 * Depois rode o import do Godot para gerar os .import dos arquivos novos.
 */

"use strict";

const fs = require("fs");
const path = require("path");

const ROOT = path.resolve(__dirname, "..");
// Mesmas pastas e buses de tools/generate_audio.js.
const FOLDER = { ui: "ui", progress: "progress", world: "progress", result: "progress", combat: "combat", player: "player", weapon: "weapon", hero: "hero", enemy: "enemy", boss: "boss" };
const BUS = { ui: "UI", progress: "UI", world: "UI", result: "UI", combat: "Impacts", player: "Player", weapon: "Player", hero: "Player", enemy: "Enemies", boss: "Enemies" };

const args = process.argv.slice(2);
let manifestPath = path.join(ROOT, "data", "audio_manifest.json");
let copy = true;
const jobs = [];
for (let i = 0; i < args.length; i++) {
  if (args[i] === "--manifest") manifestPath = path.resolve(args[++i]);
  else if (args[i] === "--no-copy") copy = false;
  else {
    const eq = args[i].indexOf("=");
    if (eq < 1) throw new Error(`argumento inválido (esperado evento=arquivo[,arquivo]): ${args[i]}`);
    jobs.push({ key: args[i].slice(0, eq), sources: args[i].slice(eq + 1).split(",") });
  }
}
if (!jobs.length) throw new Error("nenhum evento informado");

const raw = fs.readFileSync(manifestPath, "utf8");
const manifest = JSON.parse(raw);
for (const { key, sources } of jobs) {
  const prefix = key.split(".")[0];
  const folder = FOLDER[prefix];
  if (!folder) throw new Error(`prefixo desconhecido: ${key}`);
  const files = sources.map((src, i) => {
    const ext = path.extname(src).toLowerCase();
    if (![".mp3", ".ogg", ".wav"].includes(ext)) throw new Error(`formato não suportado: ${src}`);
    const rel = `assets/audio/sfx/${folder}/${key}_${String(i + 1).padStart(2, "0")}${ext}`;
    if (copy) fs.copyFileSync(src, path.join(ROOT, rel));
    return `res://${rel}`;
  });
  const existing = manifest.events[key];
  manifest.events[key] = existing
    ? { ...existing, files }
    : { files, bus: BUS[prefix], volume_db: -7, pitch_jitter: 0.035, cooldown_ms: 35, priority: 2 };
  if (manifest.aliases && manifest.aliases[key]) delete manifest.aliases[key];
  process.stdout.write(`${key}: ${files.length} arquivo(s)${existing ? "" : " (evento novo)"}\n`);
}
const eol = raw.includes("\r\n") ? "\r\n" : "\n";
fs.writeFileSync(manifestPath, JSON.stringify(manifest, null, 2).replace(/\n/g, eol) + eol);
