'use strict';
const fs=require('fs'),path=require('path'),crypto=require('crypto');
const root=process.cwd(),dir=__dirname,read=p=>JSON.parse(fs.readFileSync(p,'utf8').replace(/^\uFEFF/,'')),hash=p=>crypto.createHash('sha256').update(fs.readFileSync(p)).digest('hex').toUpperCase();
const assert=(v,m)=>{if(!v)throw Error(m)};
const qa=read(path.join(dir,'inspection.json')),refs=read(path.join(dir,'references.json')),map=read(path.join(dir,'origins.json')),refmap=read(path.join(dir,'generation-reference-paths.json'));
assert(qa.assets.length===29&&qa.sequences.length===6,'counts');
assert(qa.sequences.map(s=>s.frame_count).join(',')==='4,6,4,6,4,5','profile');
const holds=['LOT14_ALPHA_PREPARATION','LOT14_MARGIN_TARGET','LOT14_REGISTRATION_SCALE_REVIEW','LOT14_TD_BASE_GROWTH_AFTER_THREE_ATTEMPTS'];
for(const a of qa.assets){
 assert(hash(path.join(root,a.source))===a.source_sha256,'source '+a.code);
 assert(hash(path.join(dir,a.qa_frame))===a.qa_sha256,'QA '+a.code);
 assert(hash(path.resolve(dir,a.source_link))===a.source_sha256,'source link '+a.code);
 assert(a.width===1254&&a.height===1254&&a.edge_band4_alpha_ge16_pixels===0,'size/edge '+a.code);
 assert(a.revision===(['MM01','MM05','MD03','TD03','TD04'].includes(a.code)?'v02':'v01'),'selected revision');
 for(const size of [48,80,128])assert(fs.existsSync(path.join(dir,a.code+'-reading-'+size+'.png')),'reading');
}
for(const r of refs)assert(hash(path.join(root,r.path))===r.sha256,'reference');
const nativeDir='C:/Users/Higor Rossini/.codex/generated_images/01a13fe9-1c9e-7d32-9ccb-d1a37a3f79ec';
let prompts='# LOT14/v01 — prompts exatos\n\nBuilt-in imagegen. Uma imagem individual por chamada. Entradas e hashes por chamada em generation-origins.json.36tentativas preservadas;29selecionadas. DRAFT.\n';
let generationReferences=0;
const origins=Object.entries(map).map(([id,native])=>{
 const source='.atena/generated/art-candidates/asset-lot14/'+id+'.png',sha256=hash(path.join(root,source));
 assert(hash(path.join(nativeDir,native))===sha256,'native '+id);
 const promptPath=path.join(dir,'prompts',id+'.txt'),prompt=fs.readFileSync(promptPath,'utf8').trimEnd();
 assert(prompt.length>100&&!prompt.includes('undefined'),'prompt '+id);
 prompts+='\n## '+id+'\n\n'+prompt+'\n';
 const input_references=refmap[id].map(p=>{generationReferences++;return {path:p,sha256:hash(path.join(root,p))};});
 return {id,source,sha256,native_origin:path.join(nativeDir,native),byte_exact_copy:true,prompt:'prompts/'+id+'.txt',input_references,selected:qa.assets.some(a=>a.source===source)};
});
assert(origins.length===36&&origins.filter(o=>o.selected).length===29,'attempts');
assert(new Set(origins.map(o=>o.sha256)).size===36,'duplicate attempts');
const counts={};for(const o of origins){const code=o.id.slice(0,4);counts[code]=(counts[code]||0)+1;assert(counts[code]<=3,'attempt budget '+code);}
assert(counts.TD03===3,'TD03 limit evidence');
const marginMisses=qa.assets.filter(a=>a.margin_min_px<a.width*0.12).map(a=>a.code);
assert(marginMisses.length===28,'margin disclosure');
const heights=prefix=>qa.assets.filter(a=>a.code.startsWith(prefix)).map(a=>a.core_bbox_xyxy[3]-a.core_bbox_xyxy[1]+1);
const md=heights('MD'),td=heights('TD');
assert(md.every((h,i)=>i===0||h<=md[i-1]),'mimic death progression');
assert(td.slice(2).some((h,i)=>h>td[i+1]),'TD hold evidence');
const legacy=['RU05_HORIZONTAL_DRIFT','RU07_HORIZONTAL_DRIFT','RU08_COLUMN_CONTACT_AND_DRIFT','LOT13_ALPHA_PREPARATION','LOT13_REGISTRATION_REVIEW','LOT13_JD04_JD05_MARGIN_TARGET'];
const receipt=read(path.join(dir,'visual-acceptance.json'));
assert(receipt.status==='APPROVED_EXPLICITLY_SOURCE_DIRECTION'&&receipt.assets.length===29,'receipt');
for(const a of qa.assets)assert(receipt.assets.some(r=>r.code===a.code&&r.revision===a.revision&&r.source_sha256===a.source_sha256),'accepted revision '+a.code);
for(const a of qa.assets)a.human_visual_acceptance=receipt.status;
for(const s of qa.sequences)s.human_visual_acceptance=receipt.status;
const manifest={id:'ASSET-LOT14',revision:'v01',content_state:'DRAFT',status:'PRODUCTION_COMPLETE_AWAITING_VISUAL_REVIEW_WITH_TECHNICAL_HOLDS',date:'2026-10-17',generation_attempts:36,max_generation_calls:87,selected_sources:29,review_entries:6,assets:qa.assets,sequences:qa.sequences,attempts:origins,technical_holds:holds,legacy_holds_preserved:legacy,margin_target_misses:marginMisses,death_core_heights_px:{MD:md,TD:td},human_visual_acceptance:'PENDING',implementation_owner:'Claude',runtime_admission:false,canonical_promotion:false};
manifest.status='VISUALLY_ACCEPTED_DRAFT_WITH_TECHNICAL_HOLDS';
manifest.human_visual_acceptance=receipt.status;
manifest.visual_acceptance_receipt='visual-acceptance.json';
fs.writeFileSync(path.join(dir,'manifest.json'),JSON.stringify(manifest,null,2)+'\n');
fs.writeFileSync(path.join(dir,'generation-origins.json'),JSON.stringify(origins,null,2)+'\n');
fs.writeFileSync(path.join(dir,'prompts.md'),prompts);
fs.writeFileSync(path.join(dir,'delivery-check.json'),'{}');
let links=0;for(const file of ['index.html','ENTREGA-PARA-IMPLEMENTACAO.md','attempt-review.md']){
 const s=fs.readFileSync(path.join(dir,file),'utf8');
 const matches=file.endsWith('.html')?[...s.matchAll(/(?:src|href)=["']([^"']+)["']/g)]:[...s.matchAll(/\]\(([^)]+)\)/g)];
 for(const m of matches){assert(fs.existsSync(path.resolve(dir,m[1])),'link '+m[1]);links++;}
}
assert(read(path.join(dir,'player-check.json')).status==='PASS','player');
const report={status:'PASS_DELIVERY_INTEGRITY_ONLY',selected_source_hashes:29,attempt_hashes:36,qa_frame_hashes:29,reference_hashes:refs.length,generation_reference_hashes:generationReferences,prompt_records:36,reading_previews:87,local_links:links,technical_holds:holds,human_visual_acceptance:'PENDING',runtime_admission:false,browser_render_verified:false};
report.human_visual_acceptance=receipt.status;
fs.writeFileSync(path.join(dir,'delivery-check.json'),JSON.stringify(report,null,2)+'\n');console.log(JSON.stringify(report));
