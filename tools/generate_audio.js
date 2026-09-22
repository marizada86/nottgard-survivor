/*
 * Nottgard Survivors audio forge.
 * Generates deterministic, original mono PCM WAV assets without dependencies.
 * Run from the project root: node tools/generate_audio.js
 */

"use strict";

const fs = require("fs");
const path = require("path");

const ROOT = path.resolve(__dirname, "..");
const AUDIO = path.join(ROOT, "assets", "audio");
const MANIFEST = path.join(ROOT, "data", "audio_manifest.json");
const RATE = 22050;

function hash32(text) {
  let h = 2166136261 >>> 0;
  for (const c of text) {
    h ^= c.charCodeAt(0);
    h = Math.imul(h, 16777619) >>> 0;
  }
  return h >>> 0;
}

function rngFor(seedText) {
  let state = hash32(seedText) || 1;
  return () => {
    state = (Math.imul(state, 1664525) + 1013904223) >>> 0;
    return state / 4294967296;
  };
}

function clamp(v, lo = -1, hi = 1) {
  return Math.max(lo, Math.min(hi, v));
}

function soft(v) {
  return Math.tanh(v * 1.15) * 0.78;
}

function writeWav(file, samples) {
  fs.mkdirSync(path.dirname(file), { recursive: true });
  const dataBytes = samples.length * 2;
  const buf = Buffer.allocUnsafe(44 + dataBytes);
  buf.write("RIFF", 0);
  buf.writeUInt32LE(36 + dataBytes, 4);
  buf.write("WAVE", 8);
  buf.write("fmt ", 12);
  buf.writeUInt32LE(16, 16);
  buf.writeUInt16LE(1, 20);
  buf.writeUInt16LE(1, 22);
  buf.writeUInt32LE(RATE, 24);
  buf.writeUInt32LE(RATE * 2, 28);
  buf.writeUInt16LE(2, 32);
  buf.writeUInt16LE(16, 34);
  buf.write("data", 36);
  buf.writeUInt32LE(dataBytes, 40);
  for (let i = 0; i < samples.length; i++) {
    buf.writeInt16LE(Math.round(clamp(samples[i]) * 32767), 44 + i * 2);
  }
  fs.writeFileSync(file, buf);
}

function env(t, duration, attack = 0.008, release = 0.16) {
  const a = Math.min(1, t / Math.max(attack, 0.001));
  const r = Math.min(1, (duration - t) / Math.max(release, 0.001));
  return Math.max(0, a * r);
}

function durationFor(kind, key) {
  if (kind === "ui") return key.includes("invalid") ? 0.16 : 0.085;
  if (kind === "progress") return key.includes("levelup") || key.includes("achievement") ? 0.68 : 0.28;
  if (kind === "combat") return key.includes("explosion") ? 0.72 : 0.22;
  if (kind === "player") return key.includes("death") || key.includes("revive") ? 0.8 : 0.34;
  if (kind === "weapon") return 0.34;
  if (kind === "hero") return 0.92;
  if (kind === "enemy") return key.includes("death") ? 0.62 : 0.42;
  if (kind === "boss") return 1.25;
  return 0.48;
}

function oneShot(kind, key, variant) {
  const random = rngFor(`${kind}:${key}:${variant}`);
  const duration = durationFor(kind, key);
  const n = Math.floor(duration * RATE);
  const out = new Float32Array(n);
  const seed = hash32(key) + variant * 97;
  let base = 90 + (seed % 420);
  if (kind === "ui") base = 520 + (seed % 900);
  if (kind === "progress") base = 420 + (seed % 520);
  if (kind === "boss") base = 38 + (seed % 55);
  if (kind === "enemy") base = 65 + (seed % 170);
  const bright = kind === "ui" || kind === "progress" || key.includes("radiant") || key.includes("heal");
  const dark = kind === "enemy" || kind === "boss" || key.includes("death") || key.includes("hurt");
  const noisy = kind === "combat" || kind === "weapon" || key.includes("fire") || key.includes("explosion");
  let filteredNoise = 0;

  for (let i = 0; i < n; i++) {
    const t = i / RATE;
    const u = t / duration;
    const step = kind === "progress" ? Math.min(3, Math.floor(u * 4)) : 0;
    const arp = kind === "progress" ? [1, 1.25, 1.5, 2][step] : 1;
    const slide = dark ? 1 - 0.58 * u : 1 + (bright ? 0.16 * u : -0.12 * u);
    const f = base * arp * slide;
    const phase = Math.PI * 2 * f * t;
    let v = Math.sin(phase);
    v += Math.sin(phase * 2.01 + 0.4) * (bright ? 0.32 : 0.18);
    v += Math.sin(phase * 0.503 + 1.7) * (dark ? 0.38 : 0.08);
    if (kind === "weapon") v += Math.sign(Math.sin(phase * 0.77)) * 0.22;
    if (kind === "hero") v += Math.sin(phase * 3.02 + Math.sin(t * 21)) * 0.2;
    if (kind === "boss") v += Math.sin(phase * 0.251) * 0.65;
    const white = random() * 2 - 1;
    filteredNoise = filteredNoise * 0.83 + white * 0.17;
    if (noisy) v += filteredNoise * (0.65 * (1 - u) + 0.12);
    if (key.includes("explosion") || key.includes("critical")) v += white * Math.exp(-u * 7) * 0.75;
    const decay = Math.exp(-u * (kind === "boss" || kind === "hero" ? 2.2 : 4.2));
    out[i] = soft(v * env(t, duration, 0.004, Math.min(0.2, duration * 0.45)) * decay);
  }
  return out;
}

function periodicNoise(t, duration, seed, color = 1) {
  let v = 0;
  for (let k = 1; k <= 9; k++) {
    const cycles = 2 + ((seed + k * 13) % 31);
    v += Math.sin(Math.PI * 2 * cycles * t / duration + k * seed * 0.013) / Math.pow(k, color);
  }
  return v * 0.22;
}

function ambience(stage, index) {
  const duration = 12;
  const n = duration * RATE;
  const out = new Float32Array(n);
  const seed = hash32(stage);
  const root = 32 + (seed % 31);
  for (let i = 0; i < n; i++) {
    const t = i / RATE;
    const slow = Math.sin(Math.PI * 2 * t / duration);
    let v = Math.sin(Math.PI * 2 * root * t) * 0.16;
    v += Math.sin(Math.PI * 2 * root * 1.498 * t + slow) * 0.11;
    v += periodicNoise(t, duration, seed, 1.18) * (0.5 + 0.25 * slow);
    if (["shedaklah", "molor", "goranthis", "pilares"].includes(stage)) {
      v += Math.sin(Math.PI * 2 * (7 + index) * t + 2 * Math.sin(t * 0.7)) * 0.07;
    }
    if (stage === "feng_tu") v += Math.sin(Math.PI * 2 * 41 * t) * Math.pow(Math.max(0, Math.sin(Math.PI * 2 * 3 * t / duration)), 12) * 0.18;
    out[i] = soft(v * 0.72);
  }
  return out;
}

function music(track, index) {
  const duration = 24;
  const n = duration * RATE;
  const out = new Float32Array(n);
  const seed = hash32(track);
  const roots = [43.65, 46.25, 49.0, 51.91, 55.0, 58.27, 61.74];
  const root = roots[(seed + index) % roots.length];
  const scale = track === "victory" ? [1, 1.25, 1.5, 2] : track === "defeat" ? [1, 1.189, 1.414, 1.682] : [1, 1.2, 1.5, 1.78];
  const intensity = track === "boss" ? 1.25 : track === "menu" ? 0.68 : 0.9;
  for (let i = 0; i < n; i++) {
    const t = i / RATE;
    const bar = Math.floor(t / 6) % 4;
    const beat = (t % 0.75) / 0.75;
    const chord = scale[bar];
    const drone = Math.sin(Math.PI * 2 * root * chord * t) * 0.24;
    const fifth = Math.sin(Math.PI * 2 * root * chord * 1.5 * t + 0.4) * 0.12;
    const upper = Math.sin(Math.PI * 2 * root * chord * (2 + ((bar + index) % 3) * 0.25) * t) * 0.07;
    const pulseEnv = Math.exp(-beat * (track === "boss" ? 9 : 5));
    const pulse = Math.sin(Math.PI * 2 * root * 0.5 * t) * pulseEnv * 0.14;
    const texture = periodicNoise(t, duration, seed, 1.45) * 0.16;
    const lfo = 0.75 + 0.25 * Math.sin(Math.PI * 2 * t / duration);
    out[i] = soft((drone + fifth + upper + pulse + texture) * lfo * intensity);
  }
  return out;
}

function readJson(rel) {
  return JSON.parse(fs.readFileSync(path.join(ROOT, rel), "utf8"));
}

function safeName(value) {
  return value.replace(/[^a-z0-9_.-]+/gi, "_").toLowerCase();
}

const manifest = {
  version: 1,
  generated_by: "tools/generate_audio.js",
  format: { codec: "PCM", bits: 16, sample_rate: RATE, channels: 1 },
  events: {},
  aliases: {
    hit: "combat.impact", crit: "combat.critical", swing: "combat.swing",
    cast: "combat.magic", nova: "combat.nova", hurt: "player.hurt",
    pickup: "progress.xp", gold: "progress.coin", levelup: "progress.levelup",
    item: "progress.item", boom: "combat.explosion", boss: "boss.arrival",
    click: "ui.click", win: "result.victory", dead: "result.defeat"
  },
  music: {},
  ambience: {}
};

let fileCount = 0;
let byteCount = 0;

function addEvent(key, kind, variants = 2, options = {}) {
  const files = [];
  for (let v = 0; v < variants; v++) {
    const rel = `assets/audio/sfx/${kind}/${safeName(key)}_${String(v + 1).padStart(2, "0")}.wav`;
    const abs = path.join(ROOT, rel);
    writeWav(abs, oneShot(kind, key, v));
    files.push(`res://${rel.replaceAll("\\", "/")}`);
    fileCount++;
    byteCount += fs.statSync(abs).size;
  }
  manifest.events[key] = {
    files,
    bus: options.bus || ({ ui: "UI", progress: "UI", combat: "Impacts", player: "Player", weapon: "Player", hero: "Player", enemy: "Enemies", boss: "Enemies" }[kind] || "SFX"),
    volume_db: options.volume_db ?? -8,
    pitch_jitter: options.pitch_jitter ?? 0.035,
    cooldown_ms: options.cooldown_ms ?? 35,
    priority: options.priority ?? 1
  };
}

const ui = ["hover", "click", "confirm", "cancel", "open", "close", "invalid", "pause", "resume", "tab"];
const progress = ["xp", "coin", "chest", "fountain", "altar", "ritual", "item", "upgrade", "levelup", "evolution", "achievement", "reroll", "unlock", "portal"];
const combat = ["impact", "critical", "miss", "swing", "magic", "nova", "zone", "explosion", "block", "dodge", "barrier", "fire", "radiant", "physical", "stun", "knockback", "projectile", "burn"];
const player = ["hurt", "heal", "death", "revive", "guard", "dash", "footstep", "overdrive"];
const world = ["chest", "fountain", "altar", "ritual", "portal", "descent", "elite", "warning"];

for (const k of ui) addEvent(`ui.${k}`, "ui", 2, { priority: 2, cooldown_ms: 20, volume_db: -10 });
for (const k of progress) addEvent(`progress.${k}`, "progress", 2, { priority: 2, cooldown_ms: 45, volume_db: -7 });
for (const k of combat) addEvent(`combat.${k}`, "combat", 3, { priority: k === "critical" || k === "explosion" ? 3 : 1, volume_db: -12 });
for (const k of player) addEvent(`player.${k}`, "player", 3, { priority: 4, volume_db: -7 });
for (const k of world) addEvent(`world.${k}`, "progress", 2, { priority: 3, volume_db: -7 });
addEvent("result.victory", "progress", 2, { priority: 5, volume_db: -4 });
addEvent("result.defeat", "boss", 2, { priority: 5, volume_db: -5 });
addEvent("boss.arrival", "boss", 3, { priority: 5, volume_db: -4, cooldown_ms: 500 });
addEvent("enemy.telegraph", "enemy", 2, { priority: 4, volume_db: -7 });
addEvent("enemy.charge", "enemy", 2, { priority: 4, volume_db: -7 });
addEvent("enemy.summon", "enemy", 2, { priority: 3, volume_db: -9 });

const weapons = readJson("data/weapons.json");
const heroes = readJson("data/heroes.json");
const enemies = readJson("data/enemies.json");
const stages = readJson("data/stages.json");

for (const id of Object.keys(weapons)) addEvent(`weapon.${id}.fire`, "weapon", 2, { priority: 2, volume_db: -12, cooldown_ms: 55 });
for (const id of Object.keys(heroes)) addEvent(`hero.${id}.active`, "hero", 2, { priority: 4, volume_db: -6, cooldown_ms: 250 });
for (const id of Object.keys(enemies)) {
  addEvent(`enemy.${id}.action`, "enemy", 1, { priority: 1, volume_db: -14, cooldown_ms: 180 });
  addEvent(`enemy.${id}.death`, "enemy", 2, { priority: 1, volume_db: -15, cooldown_ms: 65 });
}

const bossIds = new Set(Object.values(stages).map((s) => s.boss));
for (const id of bossIds) {
  addEvent(`boss.${id}.arrival`, "boss", 2, { priority: 5, volume_db: -3, cooldown_ms: 800 });
  addEvent(`boss.${id}.phase`, "boss", 2, { priority: 5, volume_db: -4, cooldown_ms: 500 });
  addEvent(`boss.${id}.defeat`, "boss", 2, { priority: 5, volume_db: -3, cooldown_ms: 800 });
}

const stageIds = Object.keys(stages);
stageIds.forEach((stage, index) => {
  const rel = `assets/audio/ambience/${stage}.wav`;
  const abs = path.join(ROOT, rel);
  writeWav(abs, ambience(stage, index));
  manifest.ambience[stage] = `res://${rel}`;
  fileCount++;
  byteCount += fs.statSync(abs).size;
});

const tracks = ["menu", ...stageIds, "boss", "victory", "defeat"];
tracks.forEach((track, index) => {
  const rel = `assets/audio/music/${track}.wav`;
  const abs = path.join(ROOT, rel);
  writeWav(abs, music(track, index));
  manifest.music[track] = `res://${rel}`;
  fileCount++;
  byteCount += fs.statSync(abs).size;
});

fs.writeFileSync(MANIFEST, JSON.stringify(manifest, null, 2) + "\n");
const report = {
  generated_at: new Date().toISOString(),
  events: Object.keys(manifest.events).length,
  files: fileCount,
  bytes: byteCount,
  sample_rate: RATE,
  manifest: path.relative(ROOT, MANIFEST).replaceAll("\\", "/")
};
fs.writeFileSync(path.join(AUDIO, "generation_report.json"), JSON.stringify(report, null, 2) + "\n");
process.stdout.write(JSON.stringify(report, null, 2) + "\n");
