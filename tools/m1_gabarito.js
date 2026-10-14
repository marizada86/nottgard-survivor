#!/usr/bin/env node
// SPEC-176 (M1): gera o gabarito (guia de posição) de uma tira para o prompt do gerador de imagem. Só node, sem dependências.
//
// node tools/m1_gabarito.js --hero durvall --out saida.png --cells 4 --cellw 512 --cellh 512 --base 440 --height 231 \
//      [--gutter 0] [--step 127] [--marks 1,4] [--idle-feet 376]
//
// Cada célula traz: chão (verde), topo da cabeça (azul), margem proibida de 10 px (vermelho), eixo central, número do quadro
// e a silhueta do idle (cinza) como escala. `--gutter` deixa uma faixa vazia entre as células (separa quadros que se tocam).
// `--cols` organiza as células em grade (linha por linha, como o gerador devolve): ex. 6 quadros em 3 colunas x 2 linhas.
// `--idle-scale` amplia a silhueta (e `--height`/`--step` valem na mesma escala); a normalização reduz depois para a altura do jogo.
// `--marks` põe cruzes rosa nos pés do contato (quadros indicados) afastadas por `--step` px.
const fs = require("fs"), zlib = require("zlib");

function arg(name, def) {
  const i = process.argv.indexOf("--" + name);
  return i >= 0 ? process.argv[i + 1] : def;
}
const hero = arg("hero", "durvall");
const out = arg("out", "gabarito.png");
const N = parseInt(arg("cells", "6"), 10);
const CW = parseInt(arg("cellw", "256"), 10), CH = parseInt(arg("cellh", "384"), 10);
const BASE = parseInt(arg("base", "376"), 10), HEIGHT = parseInt(arg("height", "231"), 10);
const GUT = parseInt(arg("gutter", "0"), 10), STEP = parseInt(arg("step", "0"), 10);
const MARKS = arg("marks", "").split(",").filter(Boolean).map(Number);
const IDLE_FEET = parseInt(arg("idle-feet", "376"), 10);
const COLS = parseInt(arg("cols", String(N)), 10);
const ROWS = Math.ceil(N / COLS);
const ISCALE = parseFloat(arg("idle-scale", "1"));

function decode(path) {
  const b = fs.readFileSync(path); let o = 8, w, h, ct, idat = [];
  while (o < b.length) {
    const len = b.readUInt32BE(o), type = b.toString("ascii", o + 4, o + 8), d = b.slice(o + 8, o + 8 + len);
    if (type === "IHDR") { w = d.readUInt32BE(0); h = d.readUInt32BE(4); ct = d[9]; }
    if (type === "IDAT") idat.push(d);
    o += 12 + len;
  }
  if (ct !== 6) throw new Error("idle precisa ser RGBA8");
  const raw = zlib.inflateSync(Buffer.concat(idat)), bpp = 4, stride = w * bpp, px = Buffer.alloc(h * stride);
  for (let y = 0; y < h; y++) {
    const f = raw[y * (stride + 1)], row = raw.slice(y * (stride + 1) + 1, (y + 1) * (stride + 1));
    for (let x = 0; x < stride; x++) {
      const a = x >= bpp ? px[y * stride + x - bpp] : 0, up = y > 0 ? px[(y - 1) * stride + x] : 0, ul = (y > 0 && x >= bpp) ? px[(y - 1) * stride + x - bpp] : 0;
      let v = row[x];
      if (f === 1) v += a; else if (f === 2) v += up; else if (f === 3) v += (a + up) >> 1;
      else if (f === 4) { const p = a + up - ul, pa = Math.abs(p - a), pb = Math.abs(p - up), pc = Math.abs(p - ul); v += (pa <= pb && pa <= pc) ? a : (pb <= pc ? up : ul); }
      px[y * stride + x] = v & 255;
    }
  }
  return { w, h, px };
}
const T = new Uint32Array(256).map((_, n) => { let c = n; for (let k = 0; k < 8; k++) c = c & 1 ? 0xEDB88320 ^ (c >>> 1) : c >>> 1; return c >>> 0; });
const crc = b => { let c = 0xFFFFFFFF; for (const x of b) c = T[(c ^ x) & 255] ^ (c >>> 8); return (c ^ 0xFFFFFFFF) >>> 0; };
const chunk = (t, d) => { const l = Buffer.alloc(4); l.writeUInt32BE(d.length); const td = Buffer.concat([Buffer.from(t), d]); const c = Buffer.alloc(4); c.writeUInt32BE(crc(td)); return Buffer.concat([l, td, c]); };
function encode(w, h, px) {
  const raw = Buffer.alloc(h * (w * 4 + 1));
  for (let y = 0; y < h; y++) px.copy(raw, y * (w * 4 + 1) + 1, y * w * 4, (y + 1) * w * 4);
  const ih = Buffer.alloc(13); ih.writeUInt32BE(w, 0); ih.writeUInt32BE(h, 4); ih[8] = 8; ih[9] = 6;
  return Buffer.concat([Buffer.from([137, 80, 78, 71, 13, 10, 26, 10]), chunk("IHDR", ih), chunk("IDAT", zlib.deflateSync(raw, { level: 9 })), chunk("IEND", Buffer.alloc(0))]);
}
const DIG = { "0": ["111", "101", "101", "101", "111"], "1": ["010", "110", "010", "010", "111"], "2": ["111", "001", "111", "100", "111"], "3": ["111", "001", "111", "001", "111"], "4": ["101", "101", "111", "001", "001"], "5": ["111", "100", "111", "001", "111"], "6": ["111", "100", "111", "101", "111"], "7": ["111", "001", "001", "010", "010"], "8": ["111", "101", "111", "101", "111"], "9": ["111", "101", "111", "001", "111"] };

const idle = decode(`assets/animations/heroes/${hero}/idle.png`);
const idleCell = Math.round(idle.w / 4);           // idle tem 4 quadros
const W = COLS * CW + (COLS - 1) * GUT, H = ROWS * CH + (ROWS - 1) * GUT;
const px = Buffer.alloc(W * H * 4);
const set = (x, y, r, g, b) => { if (x < 0 || y < 0 || x >= W || y >= H) return; const i = (y * W + x) * 4; px[i] = r; px[i + 1] = g; px[i + 2] = b; px[i + 3] = 255; };
for (let y = 0; y < H; y++) for (let x = 0; x < W; x++) set(x, y, GUT > 0 ? 210 : 236, GUT > 0 ? 210 : 236, GUT > 0 ? 210 : 236);
const TOP = BASE - HEIGHT;
for (let c = 0; c < N; c++) {
  const x0 = (c % COLS) * (CW + GUT), y0 = Math.floor(c / COLS) * (CH + GUT);
  for (let y = 0; y < CH; y++) for (let x = 0; x < CW; x++) set(x0 + x, y0 + y, 236, 236, 236);
  // silhueta do idle, ampliada por ISCALE em torno dos pés (centro do idle no centro da célula, pés em BASE)
  for (let dy = 0; dy < CH; dy++) for (let dx = 0; dx < CW; dx++) {
    const sx = Math.round(idleCell / 2 + (dx - CW / 2) / ISCALE), sy = Math.round(IDLE_FEET + (dy - BASE) / ISCALE);
    if (sx < 0 || sy < 0 || sx >= idleCell || sy >= idle.h) continue;
    if (idle.px[(sy * idle.w + sx) * 4 + 3] > 40) set(x0 + dx, y0 + dy, 170, 170, 176);
  }
  for (let x = 0; x < CW; x++) { set(x0 + x, y0 + BASE, 0, 160, 60); set(x0 + x, y0 + BASE + 1, 0, 160, 60); set(x0 + x, y0 + TOP, 30, 90, 220); set(x0 + x, y0 + TOP + 1, 30, 90, 220); }
  for (let y = 0; y < CH; y++) { if (y % 8 < 4) set(x0 + Math.floor(CW / 2), y0 + y, 120, 120, 120); }
  for (let x = 10; x < CW - 10; x++) { set(x0 + x, y0 + 10, 220, 40, 40); set(x0 + x, y0 + CH - 11, 220, 40, 40); }
  for (let y = 10; y < CH - 10; y++) { set(x0 + 10, y0 + y, 220, 40, 40); set(x0 + CW - 11, y0 + y, 220, 40, 40); }
  for (let y = 0; y < CH; y++) { set(x0, y0 + y, 60, 60, 60); set(x0 + CW - 1, y0 + y, 60, 60, 60); }
  const label = String(c + 1);
  for (let k = 0; k < label.length; k++) {
    const d = DIG[label[k]];
    for (let r = 0; r < 5; r++) for (let q = 0; q < 3; q++) if (d[r][q] === "1") for (let yy = 0; yy < 5; yy++) for (let xx = 0; xx < 5; xx++) set(x0 + 16 + k * 20 + q * 5 + xx, y0 + 16 + r * 5 + yy, 40, 40, 40);
  }
  if (STEP > 0 && MARKS.includes(c + 1)) {
    for (const fx of [Math.floor(CW / 2) - Math.round(STEP / 2), Math.floor(CW / 2) + Math.round(STEP / 2)]) {
      for (let k = -9; k <= 9; k++) { set(x0 + fx + k, y0 + BASE - 1, 230, 0, 200); set(x0 + fx, y0 + BASE - 1 + k, 230, 0, 200); }
    }
  }
}
fs.writeFileSync(out, encode(W, H, px));
console.log(`${out}: ${W}x${H}, ${N} células de ${CW}x${CH} em ${COLS}x${ROWS}, base ${BASE}, altura ${HEIGHT}, gutter ${GUT}`);
