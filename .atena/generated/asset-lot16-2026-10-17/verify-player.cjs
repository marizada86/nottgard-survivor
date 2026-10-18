'use strict';
const fs=require('fs'),path=require('path'),vm=require('vm'),assert=(v,m)=>{if(!v)throw Error(m)};
class E{constructor(tag){this.tag=tag;this.children=[];this.events={};}append(...n){this.children.push(...n);}setAttribute(k,v){this[k]=v;}addEventListener(k,v){this.events[k]=v;}set value(v){this._value=v;}get value(){return this._value??this.children.find(c=>c.selected)?.value??this.children[0]?.value;}style={};dataset={};}
const root=new E('main'),callbacks=[],ctx={window:{},document:{getElementById:()=>root,createElement:t=>new E(t),createTextNode:t=>t},performance:{now:()=>0},requestAnimationFrame:f=>callbacks.push(f)};
vm.createContext(ctx);for(const f of ['sequences.js','player.js'])vm.runInContext(fs.readFileSync(path.join(__dirname,f),'utf8'),ctx);
const data=ctx.window.SEQUENCES,states=ctx.window.LOT16_PLAYERS;
assert(data.length===5&&states.length===5&&root.children.length===5,'five players');assert(data.every(s=>s.loop&&s.frame_count===6)&&data.reduce((n,s)=>n+s.frames.length,0)===30,'loop6/30');
for(const s of data)for(const f of s.frames)assert(fs.readFileSync(path.join(__dirname,f.qa_frame)).subarray(0,8).equals(Buffer.from([137,80,78,71,13,10,26,10])),'PNG');
for(const c of root.children){assert(c.children[3].children[2].value===5,'default5FPS');assert(c.children[2].style.objectFit==='contain','aspect');assert(fs.existsSync(path.resolve(__dirname,c.children[7].href)),'source link');}
function step(t){for(const f of callbacks.splice(0))f(t);}
for(let t=200;t<=1600;t+=200)step(t);assert(states.every(s=>s.playing&&s.index===2),'wrap8ticks');
const c=root.children[0],s=states[0],cc=c.children[3];cc.children[0].events.click();step(1800);assert(s.index===2&&!s.playing,'pause');
c.children[4].value=4;c.children[4].events.input();assert(s.index===4&&!s.playing,'scrub');
cc.children[1].events.click();assert(s.index===0&&s.playing,'replay');cc.children[2].value=10;step(1850);assert(s.index===0,'10FPS early');step(1900);assert(s.index===1,'10FPS');
const rc=root.children[2].children[3],rs=states[2];rc.children[3].children[0].checked=true;rc.children[1].events.click();for(let t=2000;t<=3000;t+=200)step(t);assert(rs.index===0&&rs.playing,'sixframe repeat');
rc.children[3].children[0].checked=false;rc.children[1].events.click();for(let t=3200;t<=4200;t+=200)step(t);assert(rs.index===5&&!rs.playing,'holdlast');
const report={status:'PASS',scope:'Offline minimal DOM simulation; not browser render',players:5,animated_qa_frames:30,checks:['localPNG','5FPSdefault','10FPStiming','loop6','pause','scrub','replay','repeatonoff','source links','aspectpreservation']};
fs.writeFileSync(path.join(__dirname,'player-check.json'),JSON.stringify(report,null,2)+'\n');console.log(JSON.stringify(report));
