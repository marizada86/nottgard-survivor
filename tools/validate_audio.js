"use strict";

const fs = require("fs");
const path = require("path");

const root = path.resolve(__dirname, "..");
const manifest = JSON.parse(fs.readFileSync(path.join(root, "data", "audio_manifest.json"), "utf8"));
const weapons = JSON.parse(fs.readFileSync(path.join(root, "data", "weapons.json"), "utf8"));
const heroes = JSON.parse(fs.readFileSync(path.join(root, "data", "heroes.json"), "utf8"));
const enemies = JSON.parse(fs.readFileSync(path.join(root, "data", "enemies.json"), "utf8"));
const stages = JSON.parse(fs.readFileSync(path.join(root, "data", "stages.json"), "utf8"));
const failures = [];
let checkedFiles = 0;

function checkWav(resPath) {
  const rel = resPath.replace(/^res:\/\//, "");
  const abs = path.join(root, rel);
  if (!fs.existsSync(abs)) {
    failures.push(`arquivo ausente: ${resPath}`);
    return;
  }
  const header = fs.readFileSync(abs, { encoding: null, flag: "r" }).subarray(0, 12);
  if (header.toString("ascii", 0, 4) !== "RIFF" || header.toString("ascii", 8, 12) !== "WAVE") failures.push(`WAV inválido: ${resPath}`);
  const wav = fs.readFileSync(abs);
  let peak = 0;
  for (let i = 44; i + 1 < wav.length; i += 2) peak = Math.max(peak, Math.abs(wav.readInt16LE(i)));
  if (peak < 256) failures.push(`WAV silencioso ou quase silencioso: ${resPath}`);
  if (peak >= 32767) failures.push(`WAV com clipping: ${resPath}`);
  checkedFiles++;
}

function requireEvent(key) {
  if (!manifest.events[key]) failures.push(`evento ausente: ${key}`);
}

for (const [key, definition] of Object.entries(manifest.events)) {
  if (!Array.isArray(definition.files) || definition.files.length === 0) failures.push(`sem variantes: ${key}`);
  for (const resPath of definition.files || []) {
    checkWav(resPath);
  }
}

for (const id of Object.keys(weapons)) requireEvent(`weapon.${id}.fire`);
for (const id of Object.keys(heroes)) requireEvent(`hero.${id}.active`);
for (const id of Object.keys(enemies)) {
  requireEvent(`enemy.${id}.action`);
  requireEvent(`enemy.${id}.death`);
}
for (const [id, stage] of Object.entries(stages)) {
  if (!manifest.music[id]) failures.push(`música de fase ausente: ${id}`);
  else checkWav(manifest.music[id]);
  if (!manifest.ambience[id]) failures.push(`ambiência de fase ausente: ${id}`);
  else checkWav(manifest.ambience[id]);
  for (const cue of ["arrival", "phase", "defeat"]) requireEvent(`boss.${stage.boss}.${cue}`);
}
for (const key of ["menu", "boss", "victory", "defeat"]) {
  if (!manifest.music[key]) failures.push(`música ausente: ${key}`);
  else checkWav(manifest.music[key]);
}
for (const [alias, target] of Object.entries(manifest.aliases)) {
  if (!manifest.events[target]) failures.push(`alias inválido: ${alias} -> ${target}`);
}

const summary = { events: Object.keys(manifest.events).length, checked_files: checkedFiles, failures: failures.length };
process.stdout.write(JSON.stringify(summary, null, 2) + "\n");
if (failures.length) {
  process.stderr.write(failures.join("\n") + "\n");
  process.exitCode = 1;
}
