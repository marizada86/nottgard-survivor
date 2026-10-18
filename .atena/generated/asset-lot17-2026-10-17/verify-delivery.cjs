'use strict';
const fs=require('fs'),path=require('path'),crypto=require('crypto'),root=process.cwd(),dir=__dirname,read=p=>JSON.parse(fs.readFileSync(p,'utf8').replace(/^\uFEFF/,'')),hash=p=>crypto.createHash('sha256').update(fs.readFileSync(p)).digest('hex').toUpperCase(),assert=(v,m)=>{if(!v)throw Error(m)};
const qa=read(path.join(dir,'inspection.json')),refs=read(path.join(dir,'references.json'));
assert(qa.assets.length===6&&qa.sequences.length===1&&qa.sequences[0].frame_count===6&&qa.sequences[0].loop,'scope');
for(const a of qa.assets){
 assert(a.revision===(a.code==='SW04'?'v03':'v02'),'revision');
 assert(hash(path.join(root,a.source))===a.source_sha256&&hash(path.resolve(dir,a.source_link))===a.source_sha256,'source '+a.code);
 assert(hash(path.join(dir,a.qa_frame))===a.qa_sha256,'QA '+a.code);
 assert(a.width===1254&&a.height===1254&&a.edge_band4_alpha_ge16_pixels===0&&a.alpha_zero_pixels>0,'canvas/edge/alpha');
 assert(a.margin_min_px>=64&&a.human_visual_acceptance==='PENDING'&&!a.runtime_admission,'margin/admission');
 for(const size of [48,80,128])assert(fs.existsSync(path.join(dir,a.code+'-reading-'+size+'.png')),'reading');
}
assert(refs.length===3,'refs');for(const r of refs)assert(hash(path.join(root,r.path))===r.sha256,'reference');
const nativeDir='C:/Users/Higor Rossini/.codex/generated_images/01a13fe9-1c9e-7d32-9ccb-d1a37a3f79ec',counts={};let prompts='# LOT17/v01 —13prompts exatos\n\nBuilt-in imagegen, uma imagem individual por chamada. DRAFT;6fontes selecionadas.\n',inputs=0;
const attempts=fs.readdirSync(path.join(dir,'records')).filter(f=>f.endsWith('.json')).sort().map(f=>{
 const r=read(path.join(dir,'records',f)),source='.atena/generated/art-candidates/asset-lot17/'+r.id+'.png',sha256=hash(path.join(root,source)),prompt=fs.readFileSync(path.join(dir,'prompts',r.id+'.txt'),'utf8').trimEnd(),code=r.id.split('_')[0];
 counts[code]=(counts[code]||0)+1;assert(counts[code]<=3,'budget');assert(hash(path.join(nativeDir,r.native))===sha256,'native '+r.id);assert(prompt===r.prompt&&prompt.length>100&&!prompt.includes('undefined'),'prompt');prompts+='\n## '+r.id+'\n\n'+prompt+'\n';
 return {id:r.id,source,sha256,native_origin:path.join(nativeDir,r.native),byte_exact_copy:true,prompt:'prompts/'+r.id+'.txt',input_references:r.input_references.map(p=>{inputs++;assert(!p.includes('asset-lot16/P9'),'badhand reference must be diagnostic only');return {path:p,sha256:hash(path.join(root,p))};}),selected:qa.assets.some(a=>a.source===source)};
});
assert(attempts.length===13&&attempts.length<=18&&attempts.filter(a=>a.selected).length===6&&new Set(attempts.map(a=>a.sha256)).size===13,'attempts');
assert(Object.keys(counts).length===6&&counts.SW04===3&&Object.entries(counts).every(([k,v])=>v===(k==='SW04'?3:2)),'attemptprofile');
const s=qa.sequences[0];assert(s.core_base_spread_px===60&&s.core_bbox_center_x_spread_px===48&&s.core_width_spread_px===114,'metricsdisclosure');
const holds=['LOT17_ALPHA_PREPARATION','LOT17_REGISTRATION_SCALE_CADENCE_REVIEW','LOT17_SW04_REGISTRATION_AFTER_THREE_ATTEMPTS'];
const manifest={id:'ASSET-LOT17',revision:'v01',content_state:'DRAFT',status:'PRODUCTION_COMPLETE_AWAITING_VISUAL_REVIEW_WITH_TECHNICAL_HOLDS',date:'2026-10-17',selected_sources:6,selected_poses:6,generation_attempts:13,max_generation_calls:18,max_attempts_per_source:3,assets:qa.assets,sequences:qa.sequences,attempts,technical_holds:holds,legacy_holds_preserved:['LOT16_P9_LEFT_HAND_DIRECTION_CONFLICT'],source_repair_candidate_for:'LOT16_P9',historical_hold_released:false,human_visual_acceptance:'PENDING',implementation_owner:'Claude',runtime_admission:false,canonical_promotion:false};
const receipt=read(path.join(dir,'visual-acceptance.json'));assert(receipt.status==='APPROVED_EXPLICITLY_SOURCE_DIRECTION'&&receipt.assets.length===6,'receipt');for(const a of manifest.assets){assert(receipt.assets.some(r=>r.code===a.code&&r.revision===a.revision&&r.source_sha256===a.source_sha256),'accepted revision '+a.code);a.human_visual_acceptance=receipt.status;}for(const s of manifest.sequences)s.human_visual_acceptance=receipt.status;manifest.status='VISUALLY_ACCEPTED_DRAFT_WITH_TECHNICAL_HOLDS';manifest.human_visual_acceptance=receipt.status;manifest.visual_acceptance_receipt='visual-acceptance.json';fs.writeFileSync(path.join(dir,'manifest.json'),JSON.stringify(manifest,null,2)+'\n');fs.writeFileSync(path.join(dir,'generation-origins.json'),JSON.stringify(attempts,null,2)+'\n');fs.writeFileSync(path.join(dir,'prompts.md'),prompts);
if(!fs.existsSync(path.join(dir,'delivery-check.json')))fs.writeFileSync(path.join(dir,'delivery-check.json'),'{}');
let links=0;for(const f of ['index.html','ENTREGA-PARA-IMPLEMENTACAO.md','attempt-review.md']){
 const text=fs.readFileSync(path.join(dir,f),'utf8'),ms=f.endsWith('.html')?[...text.matchAll(/(?:href|src)=["']([^"']+)["']/g)]:[...text.matchAll(/\]\(([^)]+)\)/g)];
 for(const m of ms){assert(fs.existsSync(path.resolve(dir,m[1])),'link '+m[1]);links++;}
}
assert(read(path.join(dir,'player-check.json')).status==='PASS','player');
const state=fs.readFileSync(path.join(root,'.atena/state/asset-lot17-durvall-sw-source-repair.yaml'),'utf8').trimEnd().replace(/\r\n/g,'\n'),central=fs.readFileSync(path.join(root,'.atena/state/plan.yaml'),'utf8'),key='asset_lot17_durvall_sw_source_repair_2026_10_17:';
assert(central.slice(central.indexOf(key)+key.length).replace(/^\r?\n/,'').split(/\r?\n(?=[a-zA-Z_])/)[0].trimEnd().split(/\r?\n/).map(s=>s.replace(/^  /,'')).join('\n')===state,'state replicas');
for(const field of ['mode: per-plan','approval_status: APPROVED_EXPLICITLY','completed_steps: 4','generated: 6','generation_attempts: 13','next_execution_authorized: false','human_visual_acceptance: APPROVED_EXPLICITLY_SOURCE_DIRECTION'])assert(state.includes(field),'state '+field);
for(const rel of ['.atena/specs/SPEC-121-retomada-fila-imagens/asset-lot17-durvall-sw-source-repair-v01.md','.atena/evidence/asset-lot17-durvall-sw-source-repair-2026-10-17.md']){
 const p=path.join(root,rel);for(const m of fs.readFileSync(p,'utf8').matchAll(/\]\(([^)]+)\)/g)){assert(fs.existsSync(path.resolve(path.dirname(p),m[1])),'contract link '+m[1]);links++;}
}
const report={status:'PASS_DELIVERY_INTEGRITY_AND_STATE_ONLY',selected_source_hashes:6,attempt_hashes:13,qa_frame_hashes:6,reading_previews:18,reference_hashes:3,generation_input_hashes:inputs,prompt_records:13,local_links:links,state_replicas_match:true,technical_holds:holds,human_visual_acceptance:'PENDING',historical_p9_hold_released:false,runtime_admission:false,browser_render_verified:false};
report.human_visual_acceptance=receipt.status;fs.writeFileSync(path.join(dir,'delivery-check.json'),JSON.stringify(report,null,2)+'\n');console.log(JSON.stringify(report));
