'use strict';
const fs=require('fs'),path=require('path'),vm=require('vm');
class Element {
 constructor(tag){this.tag=tag;this.children=[];this.events={};}
 append(...nodes){this.children.push(...nodes);}setAttribute(k,v){this[k]=v;}addEventListener(k,fn){this.events[k]=fn;}
 set value(v){this._value=v;}get value(){return this._value??this.children.find(c=>c.selected)?.value??this.children[0]?.value;}
 style={};dataset={};
}
const root=new Element('main'),callbacks=[];
const ctx={window:{},document:{getElementById:()=>root,createElement:t=>new Element(t),createTextNode:t=>t},performance:{now:()=>0},requestAnimationFrame:fn=>callbacks.push(fn)};
vm.createContext(ctx);
for(const f of ['sequences.js','player.js'])vm.runInContext(fs.readFileSync(path.join(__dirname,f),'utf8'),ctx);
const assert=(v,m)=>{if(!v)throw Error(m)};
const data=ctx.window.SEQUENCES,states=ctx.window.LOT15_PLAYERS;
assert(data.length===6&&states.length===6&&root.children.length===6,'six players');
assert(data.every(s=>s.frame_count===6&&s.loop)&&data.reduce((n,s)=>n+s.frames.length,0)===36,'six loop6');
for(const s of data)for(const f of s.frames){const p=path.join(__dirname,f.qa_frame);assert(fs.readFileSync(p).subarray(0,8).equals(Buffer.from([137,80,78,71,13,10,26,10])),'PNG');}
for(const card of root.children){
 assert(card.children[3].children[2].value===8,'default8FPS');
 assert(card.children[2].style.objectFit==='contain','aspect');
 assert(fs.existsSync(path.resolve(__dirname,card.children[7].href)),'source');
}
function step(t){for(const fn of callbacks.splice(0))fn(t);}
for(let t=125;t<=1000;t+=125)step(t);
assert(states.every(s=>s.index===2&&s.playing),'wrap after8ticks');
const card=root.children[0],s=states[0],controls=card.children[3];
controls.children[0].events.click();step(1125);assert(s.index===2&&!s.playing,'pause');
card.children[4].value=4;card.children[4].events.input();assert(s.index===4&&!s.playing,'scrub');
controls.children[1].events.click();assert(s.index===0&&s.playing,'replay');
controls.children[2].value=2;step(1250);assert(s.index===0,'2FPS early');step(1625);assert(s.index===1,'2FPS');
const c=root.children[2],cs=states[2],cc=c.children[3];
cc.children[3].children[0].checked=true;cc.children[1].events.click();
for(let t=1750;t<=2375;t+=125)step(t);
assert(cs.playing&&cs.index===0,'six frame repeat');
cc.children[3].children[0].checked=false;cc.children[1].events.click();
for(let t=2500;t<=3125;t+=125)step(t);
assert(!cs.playing&&cs.index===5,'hold last with repeat off');
const report={status:'PASS',scope:'Offline minimal DOM simulation, not browser render',players:6,animated_qa_frames:36,checks:['PNG paths','aspect ratio','8FPS default','sixframe wrap','pause','scrub','replay','2FPS timing','repeat on/off','source links']};
fs.writeFileSync(path.join(__dirname,'player-check.json'),JSON.stringify(report,null,2)+'\n');console.log(JSON.stringify(report));
