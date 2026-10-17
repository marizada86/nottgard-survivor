'use strict';
const fs=require('fs'),path=require('path'),crypto=require('crypto');
const root=process.cwd(),dir=__dirname;
const read=p=>JSON.parse(fs.readFileSync(p,'utf8').replace(/^\uFEFF/,''));
const hash=p=>crypto.createHash('sha256').update(fs.readFileSync(p)).digest('hex').toUpperCase();
const assert=(v,m)=>{if(!v)throw Error(m)};
const qa=read(path.join(dir,'inspection.json')),refs=read(path.join(dir,'references.json')),map=read(path.join(dir,'origins.json'));
assert(qa.assets.length===26&&qa.sequences.length===5,'counts');
assert(qa.sequences.map(s=>s.frame_count).join(',')==='4,6,4,6,6','profile B');
const holds=['LOT13_ALPHA_PREPARATION','LOT13_REGISTRATION_REVIEW','LOT13_JD04_JD05_MARGIN_TARGET'];
for(const a of qa.assets){
 assert(hash(path.join(root,a.source))===a.source_sha256,'source '+a.code);
 assert(hash(path.join(dir,a.qa_frame))===a.qa_sha256,'QA '+a.code);
 assert(a.edge_band4_alpha_ge16_pixels===0,'edge '+a.code);
 assert(a.width===1254&&a.height===1254,'size');
 assert(hash(path.resolve(dir,a.source_link))===a.source_sha256,'source link '+a.code);
 for(const size of [48,80,128])assert(fs.existsSync(path.join(dir,a.code+'-reading-'+size+'.png')),'reading');
}
for(const r of refs)assert(hash(path.join(root,r.path))===r.sha256,'reference');
const nativeDir='C:/Users/Higor Rossini/.codex/generated_images/01a13fe9-1c9e-7d32-9ccb-d1a37a3f79ec';
const origins=Object.entries(map).map(([id,native])=>{
 const source='.atena/generated/art-candidates/asset-lot13/'+id+'.png',sha256=hash(path.join(root,source));
 assert(hash(path.join(nativeDir,native))===sha256,'native copy '+id);
 return {id,source,native_origin:path.join(nativeDir,native),sha256,byte_exact_copy:true,selected:qa.assets.some(a=>a.source===source)};
});
assert(origins.length===27&&origins.filter(o=>o.selected).length===26,'attempt count');
assert(new Set(origins.map(o=>o.sha256)).size===27,'duplicate attempt');
const prompts=['prompts.md','special-prompts.md'].map(f=>fs.readFileSync(path.join(dir,f),'utf8')).join('\n');
assert((prompts.match(/^## /gm)||[]).length===27,'prompt records');
for(const o of origins)assert(prompts.includes('## '+o.id)||prompts.includes('## '+o.id.replace('_',' ')),'prompt '+o.id);
const death=qa.assets.filter(a=>a.code.startsWith('JD')).map(a=>a.core_bbox_xyxy[3]-a.core_bbox_xyxy[1]+1);
assert(death.every((h,i)=>i===0||h<=death[i-1]),'death height');
const legacy=['RU05_HORIZONTAL_DRIFT','RU07_HORIZONTAL_DRIFT','RU08_COLUMN_CONTACT_AND_DRIFT'];
const receipt=read(path.join(dir,'visual-acceptance.json'));
assert(receipt.status==='APPROVED_EXPLICITLY_SOURCE_DIRECTION'&&receipt.assets.length===26,'visual receipt');
for(const a of qa.assets)assert(receipt.assets.some(r=>r.code===a.code&&r.revision===a.revision&&r.source_sha256===a.source_sha256),'accepted revision '+a.code);
const visual=receipt.status;
for(const a of qa.assets)a.human_visual_acceptance=visual;
for(const s of qa.sequences)s.human_visual_acceptance=visual;
fs.writeFileSync(path.join(dir,'generation-origins.json'),JSON.stringify(origins,null,2)+'\n');
const manifest={id:'ASSET-LOT13',revision:'v01',content_state:'DRAFT',status:'PRODUCTION_COMPLETE_AWAITING_VISUAL_REVIEW_WITH_TECHNICAL_HOLDS',approval_date:'2026-10-16',completed_date:'2026-10-17',generation_attempts:27,selected_sources:26,review_entries:5,assets:qa.assets,sequences:qa.sequences,attempts:origins,reference_snapshot:'references.json',origins:'generation-origins.json',anchor_sources:{identity:'MJ01/v03',geometry:'JI00/v02'},technical_holds:holds,legacy_holds_preserved:legacy,human_visual_acceptance:'PENDING',runtime_admission:false,canonical_promotion:false,implementation_owner:'Claude'};
manifest.status='VISUALLY_ACCEPTED_DRAFT_WITH_TECHNICAL_HOLDS';
manifest.human_visual_acceptance=visual;
manifest.visual_acceptance_receipt='visual-acceptance.json';
fs.writeFileSync(path.join(dir,'manifest.json'),JSON.stringify(manifest,null,2)+'\n');
fs.writeFileSync(path.join(dir,'delivery-check.json'),'{}');
let links=0;
for(const file of ['index.html','ENTREGA-PARA-IMPLEMENTACAO.md']){
 const s=fs.readFileSync(path.join(dir,file),'utf8');
 const matches=file.endsWith('.html')?[...s.matchAll(/(?:src|href)=["']([^"']+)["']/g)]:[...s.matchAll(/\]\(([^)]+)\)/g)];
 for(const m of matches){assert(fs.existsSync(path.resolve(dir,m[1])),'link '+m[1]);links++;}
}
assert(read(path.join(dir,'player-check.json')).status==='PASS','player');
const report={status:'PASS_DELIVERY_INTEGRITY_ONLY',selected_source_hashes:26,attempt_hashes:27,qa_frame_hashes:26,reference_hashes:refs.length,origin_records:27,prompt_records:27,reading_previews:78,local_links:links,death_core_heights_px:death,technical_holds:holds,legacy_holds_preserved:legacy,human_visual_acceptance:'PENDING',runtime_admission:false,browser_render_verified:false};
report.human_visual_acceptance=visual;
fs.writeFileSync(path.join(dir,'delivery-check.json'),JSON.stringify(report,null,2)+'\n');console.log(JSON.stringify(report));
