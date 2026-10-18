'use strict';
const fs=require('fs'),path=require('path'),crypto=require('crypto'),root=process.cwd(),dir=__dirname;
const read=p=>JSON.parse(fs.readFileSync(p,'utf8').replace(/^\uFEFF/,'')),hash=p=>crypto.createHash('sha256').update(fs.readFileSync(p)).digest('hex').toUpperCase(),assert=(v,m)=>{if(!v)throw Error(m)};
const qa=read(path.join(dir,'inspection.json')),refs=read(path.join(dir,'references.json'));
const receipt=read(path.join(dir,'visual-acceptance.json'));
assert(receipt.status==='APPROVED_EXPLICITLY_SOURCE_DIRECTION'&&receipt.assets.length===36&&receipt.first_frames_accepted.length===6,'visual receipt');
const v3=['YN03','YN04','YE03','YE04'],v2=['ZN00','ZE03','ZE04','LE03','LE04','YE01','YE02','YE05'];
assert(qa.assets.length===36&&qa.sequences.length===6&&qa.sequences.every(s=>s.frame_count===6&&s.loop),'scope');
for(const a of qa.assets){
 assert(a.revision===(v3.includes(a.code)?'v03':v2.includes(a.code)?'v02':'v01'),'revision '+a.code);
 assert(hash(path.join(root,a.source))===a.source_sha256&&hash(path.resolve(dir,a.source_link))===a.source_sha256,'source '+a.code);
 assert(hash(path.join(dir,a.qa_frame))===a.qa_sha256,'QA '+a.code);
 assert(a.width===1254&&a.height===1254&&a.edge_band4_alpha_ge16_pixels===0,'canvas/edge '+a.code);
 assert(a.runtime_admission===false&&a.human_visual_acceptance==='PENDING','admission');
 for(const size of [48,80,128])assert(fs.existsSync(path.join(dir,a.code+'-reading-'+size+'.png')),'reading');
}
assert(refs.length===9,'nine references');for(const r of refs)assert(hash(path.join(root,r.path))===r.sha256,'ref '+r.path);
const nativeDir='C:/Users/Higor Rossini/.codex/generated_images/01a13fe9-1c9e-7d32-9ccb-d1a37a3f79ec';
const records=fs.readdirSync(path.join(dir,'records')).filter(f=>f.endsWith('.json')).sort().map(f=>read(path.join(dir,'records',f))),counts={};
let prompts='# LOT15/v01 — prompts exatos\n\nDRAFT; built-in imagegen, um PNG por chamada. 52tentativas/36selecionadas; entradas e hashes em generation-origins.json.\n',inputCount=0;
const origins=records.map(r=>{
 const source='.atena/generated/art-candidates/asset-lot15/'+r.id+'.png',sha256=hash(path.join(root,source)),prompt=fs.readFileSync(path.join(dir,'prompts',r.id+'.txt'),'utf8').trimEnd();
 assert(hash(path.join(nativeDir,r.native))===sha256,'native '+r.id);assert(prompt===r.prompt&&prompt.length>100&&!prompt.includes('undefined'),'prompt '+r.id);
 const code=r.id.slice(0,4);counts[code]=(counts[code]||0)+1;assert(counts[code]<=3,'perfile budget');
 prompts+='\n## '+r.id+'\n\n'+prompt+'\n';
 const input_references=r.input_references.map(p=>{inputCount++;return {path:p,sha256:hash(path.join(root,p))};});
 return {id:r.id,source,sha256,native_origin:path.join(nativeDir,r.native),byte_exact_copy:true,prompt:'prompts/'+r.id+'.txt',input_references,selected:qa.assets.some(a=>a.source===source)};
});
assert(records.length===52&&records.length<=108&&Object.keys(counts).length===36,'generation budget');
assert(origins.filter(o=>o.selected).length===36&&new Set(origins.map(o=>o.sha256)).size===52,'selection/duplicates');
for(const code of v3)assert(counts[code]===3,'limit disclosure');
const holds=['LOT15_ALPHA_PREPARATION','LOT15_MARGIN_TARGET','LOT15_REGISTRATION_SCALE_REVIEW','LOT15_WALK_CADENCE_REVIEW','LOT15_NYRELIA_REGISTRATION_AFTER_THREE_ATTEMPTS'];
const marginMisses=qa.assets.filter(a=>a.margin_min_px<a.width*.12).map(a=>a.code);assert(marginMisses.length===11,'margin disclosure');
const manifest={id:'ASSET-LOT15',revision:'v01',content_state:'DRAFT',status:'PRODUCTION_COMPLETE_AWAITING_VISUAL_REVIEW_WITH_TECHNICAL_HOLDS',date:'2026-10-17',generation_attempts:52,max_generation_calls:108,max_attempts_per_file:3,selected_sources:36,review_entries:6,assets:qa.assets,sequences:qa.sequences,attempts:origins,technical_holds:holds,legacy_holds_preserved:['LOT11_RU05_RU07_RU08','LOT13_ALPHA_REGISTRATION_MARGIN','LOT14_ALPHA_MARGIN_REGISTRATION_TD_BASE_GROWTH'],margin_target_misses:marginMisses,human_visual_acceptance:'PENDING',implementation_owner:'Claude',runtime_admission:false,canonical_promotion:false};
for(const a of qa.assets){assert(receipt.assets.some(r=>r.code===a.code&&r.revision===a.revision&&r.source_sha256===a.source_sha256),'accepted revision '+a.code);a.human_visual_acceptance=receipt.status;}
for(const s of qa.sequences)s.human_visual_acceptance=receipt.status;
manifest.status='VISUALLY_ACCEPTED_DRAFT_WITH_TECHNICAL_HOLDS';manifest.human_visual_acceptance=receipt.status;manifest.visual_acceptance_receipt='visual-acceptance.json';
fs.writeFileSync(path.join(dir,'manifest.json'),JSON.stringify(manifest,null,2)+'\n');
fs.writeFileSync(path.join(dir,'generation-origins.json'),JSON.stringify(origins,null,2)+'\n');fs.writeFileSync(path.join(dir,'prompts.md'),prompts);
for(const p of ['delivery-check.json','contract-check.json'])if(!fs.existsSync(path.join(dir,p)))fs.writeFileSync(path.join(dir,p),'{}');
let links=0;for(const file of ['index.html','ENTREGA-PARA-IMPLEMENTACAO.md','attempt-review.md']){
 const s=fs.readFileSync(path.join(dir,file),'utf8'),matches=file.endsWith('.html')?[...s.matchAll(/(?:src|href)=["']([^"']+)["']/g)]:[...s.matchAll(/\]\(([^)]+)\)/g)];
 for(const m of matches){assert(fs.existsSync(path.resolve(dir,m[1])),'link '+m[1]);links++;}
}
assert(read(path.join(dir,'player-check.json')).status==='PASS','player');
const report={status:'PASS_DELIVERY_INTEGRITY_ONLY',selected_source_hashes:36,attempt_hashes:52,qa_frame_hashes:36,reference_hashes:9,generation_reference_hashes:inputCount,prompt_records:52,reading_previews:108,local_links:links,technical_holds:holds,human_visual_acceptance:'PENDING',runtime_admission:false,browser_render_verified:false};
report.human_visual_acceptance=receipt.status;
fs.writeFileSync(path.join(dir,'delivery-check.json'),JSON.stringify(report,null,2)+'\n');console.log(JSON.stringify(report));
