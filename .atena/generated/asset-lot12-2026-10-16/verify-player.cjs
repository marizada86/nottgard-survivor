'use strict';
// Offline control smoke-check: executes the actual player with a minimal DOM;
// does not claim browser rendering or subjective motion verification.
const fs = require('fs');
const path = require('path');
const vm = require('vm');
class Element {
  constructor(tag) { this.tag=tag; this.children=[]; this.events={}; this._value=undefined; }
  append(...nodes) { this.children.push(...nodes); }
  setAttribute(k,v) { this[k]=v; }
  addEventListener(k,fn) { this.events[k]=fn; }
  set value(v) { this._value=v; }
  get value() { return this._value ?? this.children.find(c => c.selected)?.value ?? this.children[0]?.value; }
  style={}; dataset={};
}
const root=new Element('main'), callbacks=[];
const ctx={window:{}, document:{getElementById:()=>root,createElement:t=>new Element(t),createTextNode:t=>t}, performance:{now:()=>0}, requestAnimationFrame:fn=>callbacks.push(fn)};
vm.createContext(ctx);
vm.runInContext(fs.readFileSync(path.join(__dirname,'sequences.js'),'utf8'),ctx);
vm.runInContext(fs.readFileSync(path.join(__dirname,'player.js'),'utf8'),ctx);
function assert(value,message) { if(!value) throw Error(message); }
const data=ctx.window.SEQUENCES.filter(s=>s.frame_count>1), states=ctx.window.LOT12_PLAYERS;
assert(root.children.length===3 && states.length===3,'Expected three players');
assert(data.reduce((n,s)=>n+s.frame_count,0)===12,'Expected 12 animated frames');
for(const s of data) for(const f of s.frames.filter(f=>!f.expected_empty)) {
  const file=path.join(__dirname,f.qa_frame); assert(fs.existsSync(file),`Missing ${file}`);
  assert(fs.readFileSync(file).subarray(0,8).equals(Buffer.from([137,80,78,71,13,10,26,10])),'Invalid PNG');
}
for(const card of root.children) {
  assert(card.children[3].children[2].value===8,'Expected default 8 FPS'); assert(card.children[2].style.objectFit==='contain','Aspect-ratio preservation missing');
  assert(fs.existsSync(path.resolve(__dirname,card.children[7].href)),'Missing source link');
}
function step(time) { const pending=callbacks.splice(0); for(const fn of pending)fn(time); }
for(let time=125;time<=1000;time+=125)step(time);
for(let i=0;i<states.length;i++) if(!data[i].loop) assert(!states[i].playing && states[i].index===data[i].frame_count-1,`Transition ${data[i].code} must hold last frame`);
for(let i=0;i<states.length;i++) if(data[i].loop) assert(states[i].playing && states[i].index===0,`Idle ${data[i].code} must wrap and keep playing`);
const merchantCard=root.children[0], merchant=states[0];
merchantCard.children[3].children[1].events.click(); merchantCard.children[3].children[0].events.click(); const paused=merchant.index; step(1125); assert(merchant.index===paused && !merchant.playing,'Pause failed');
const healerCard=root.children[1], healer=states[1]; healerCard.children[4].value=2; healerCard.children[4].events.input(); assert(healer.index===2 && !healer.playing,'Frame scrub failed');
const chestCard=root.children[0], chest=states[0]; chestCard.children[3].children[1].events.click(); assert(chest.index===0 && chest.playing,'Replay failed');
chestCard.children[3].children[2].value=2; step(1250); assert(chest.index===0,'2 FPS advanced too early'); step(1625); assert(chest.index===1,'2 FPS did not advance');
const loopCard=root.children[1], loopState=states[1];
loopCard.children[3].children[3].children[0].checked=true;
loopCard.children[3].children[1].events.click();
for(let time=1750;time<=2125;time+=125)step(time);
assert(loopState.playing && loopState.index===0,'Optional repeat failed');
loopCard.children[3].children[3].children[0].checked=false;
loopCard.children[3].children[1].events.click();
for(let time=2250;time<=2750;time+=125)step(time);
assert(!loopState.playing && loopState.index===3,'Hold with repeat disabled failed');
assert(ctx.window.SEQUENCES.length===3,'Expected three cycles');
const report={status:'PASS',scope:'Offline DOM simulation, not browser render',players:states.length,animated_qa_frames:12,checks:['local PNG paths','default FPS','transition hold','pause','frame scrub','replay','FPS timing','source links','optional repeat']};
fs.writeFileSync(path.join(__dirname,'player-check.json'),JSON.stringify(report,null,2)+'\n');
console.log(JSON.stringify(report));
