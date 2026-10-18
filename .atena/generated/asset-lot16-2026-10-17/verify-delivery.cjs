'use strict';
const fs=require('fs'),path=require('path'),crypto=require('crypto'),root=process.cwd(),dir=__dirname,read=p=>JSON.parse(fs.readFileSync(p,'utf8').replace(/^\uFEFF/,'')),hash=p=>crypto.createHash('sha256').update(fs.readFileSync(p)).digest('hex').toUpperCase(),assert=(v,m)=>{if(!v)throw Error(m)};
const qa=read(path.join(dir,'inspection.json')),refs=read(path.join(dir,'references.json'));
assert(qa.sequences.length===5&&qa.sequences.every(s=>s.frame_count===6&&s.loop),'scope');
let frameCount=0;
for(const s of qa.sequences){
 assert(hash(path.join(root,s.source))===s.source_sha256&&hash(path.resolve(dir,s.source_link))===s.source_sha256,'source '+s.code);
 assert(s.revision===(s.code==='P9'?'v02':'v01'),'selection');
 assert(s.width===(s.code==='P8'?1545:1536)&&s.height===(s.code==='P8'?1018:1024),'dimensions');
 for(const f of s.frames){frameCount++;assert(hash(path.join(dir,f.qa_frame))===f.qa_sha256,'QA '+f.code);assert(f.edge_band4_alpha_ge16_pixels===0&&f.alpha_zero_pixels>0,'alpha/border');for(const size of [48,80,128])assert(fs.existsSync(path.join(dir,s.code+'_'+String(f.index).padStart(2,'0')+'-reading-'+size+'.png')),'reading');}
}
assert(frameCount===30&&refs.length===3,'counts');for(const r of refs)assert(hash(path.join(root,r.path))===r.sha256,'reference');
const nativeDir='C:/Users/Higor Rossini/.codex/generated_images/01a13fe9-1c9e-7d32-9ccb-d1a37a3f79ec',counts={};
let prompts='# LOT16/v01 —13prompts exatos\n\nBuilt-in imagegen, uma folha por chamada. DRAFT;5fontes/30poses selecionadas.\n',inputs=0;
const attempts=fs.readdirSync(path.join(dir,'records')).filter(f=>f.endsWith('.json')).sort().map(f=>{
 const r=read(path.join(dir,'records',f)),source='.atena/generated/art-candidates/asset-lot16/'+r.id+'.png',sha256=hash(path.join(root,source)),prompt=fs.readFileSync(path.join(dir,'prompts',r.id+'.txt'),'utf8').trimEnd(),code=r.id.split('_')[0];
 counts[code]=(counts[code]||0)+1;assert(counts[code]<=3,'budget '+code);assert(hash(path.join(nativeDir,r.native))===sha256,'native '+r.id);assert(prompt===r.prompt&&prompt.length>100&&!prompt.includes('undefined'),'prompt '+r.id);prompts+='\n## '+r.id+'\n\n'+prompt+'\n';
 return {id:r.id,source,sha256,native_origin:path.join(nativeDir,r.native),byte_exact_copy:true,prompt:'prompts/'+r.id+'.txt',input_references:r.input_references.map(p=>{inputs++;return {path:p,sha256:hash(path.join(root,p))};}),selected:qa.sequences.some(s=>s.source===source)};
});
assert(attempts.length===13&&attempts.length<=15&&attempts.filter(a=>a.selected).length===5&&new Set(attempts.map(a=>a.sha256)).size===13,'attempts');
assert(counts.P6===3&&counts.P7===3&&counts.P8===1&&counts.P9===3&&counts.P10===3,'attempt profile');
const holds=['LOT16_ALPHA_PREPARATION','LOT16_REGISTRATION_SCALE_CADENCE','LOT16_P8_NON_SQUARE_NATIVE_CELLS','LOT16_P9_LEFT_HAND_DIRECTION_CONFLICT'];
const manifest={id:'ASSET-LOT16',revision:'v01',content_state:'DRAFT',status:'PRODUCTION_COMPLETE_AWAITING_VISUAL_REVIEW_WITH_TECHNICAL_HOLDS',date:'2026-10-17',selected_sources:5,selected_poses:30,generation_attempts:13,max_generation_calls:15,max_attempts_per_source:3,sequences:qa.sequences,attempts,technical_holds:holds,retained_directions:['P9'],human_visual_acceptance:'PENDING',implementation_owner:'Claude',runtime_admission:false,canonical_promotion:false,scope_authority:'PLAN-103/B-002/D22 existing five remaining directions; current continuation request'};
const receipt=read(path.join(dir,'visual-acceptance.json'));assert(receipt.status==='APPROVED_EXPLICITLY_SOURCE_DIRECTION'&&receipt.sources.length===5,'visual receipt');for(const s of manifest.sequences){assert(receipt.sources.some(r=>r.code===s.code&&r.revision===s.revision&&r.source_sha256===s.source_sha256),'accepted source '+s.code);s.human_visual_acceptance=receipt.status;}manifest.status='VISUALLY_ACCEPTED_DRAFT_WITH_TECHNICAL_HOLDS';manifest.human_visual_acceptance=receipt.status;manifest.visual_acceptance_receipt='visual-acceptance.json';fs.writeFileSync(path.join(dir,'manifest.json'),JSON.stringify(manifest,null,2)+'\n');fs.writeFileSync(path.join(dir,'generation-origins.json'),JSON.stringify(attempts,null,2)+'\n');fs.writeFileSync(path.join(dir,'prompts.md'),prompts);
if(!fs.existsSync(path.join(dir,'delivery-check.json')))fs.writeFileSync(path.join(dir,'delivery-check.json'),'{}');
let links=0;for(const f of ['index.html','ENTREGA-PARA-IMPLEMENTACAO.md','attempt-review.md']){
 const text=fs.readFileSync(path.join(dir,f),'utf8'),ms=f.endsWith('.html')?[...text.matchAll(/(?:href|src)=["']([^"']+)["']/g)]:[...text.matchAll(/\]\(([^)]+)\)/g)];
 for(const m of ms){assert(fs.existsSync(path.resolve(dir,m[1])),'link '+m[1]);links++;}
}
assert(read(path.join(dir,'player-check.json')).status==='PASS','player');
const statePath='.atena/state/asset-lot16-durvall-directions.yaml',state=fs.readFileSync(path.join(root,statePath),'utf8').trimEnd().replace(/\r\n/g,'\n'),central=fs.readFileSync(path.join(root,'.atena/state/plan.yaml'),'utf8'),key='asset_lot16_durvall_directions_2026_10_17:';
assert(central.slice(central.indexOf(key)+key.length).replace(/^\r?\n/,'').split(/\r?\n(?=[a-zA-Z_])/)[0].trimEnd().split(/\r?\n/).map(s=>s.replace(/^  /,'')).join('\n')===state,'state replicas');
for(const text of ['mode: per-batch','completed_steps: 4','generated: 5','generation_attempts: 13','next_execution_authorized: false','human_visual_acceptance: APPROVED_EXPLICITLY_SOURCE_DIRECTION'])assert(state.includes(text),'state '+text);
for(const rel of ['.atena/specs/SPEC-121-retomada-fila-imagens/asset-lot16-durvall-directions-v01.md','.atena/evidence/asset-lot16-durvall-directions-2026-10-17.md']){
 const p=path.join(root,rel);for(const m of fs.readFileSync(p,'utf8').matchAll(/\]\(([^)]+)\)/g)){assert(fs.existsSync(path.resolve(path.dirname(p),m[1])),'contract link '+m[1]);links++;}
}
const report={status:'PASS_DELIVERY_INTEGRITY_AND_STATE_ONLY',selected_source_hashes:5,attempt_hashes:13,qa_frame_hashes:30,reading_previews:90,reference_hashes:3,generation_input_hashes:inputs,prompt_records:13,local_links:links,state_replicas_match:true,technical_holds:holds,human_visual_acceptance:'PENDING',runtime_admission:false,browser_render_verified:false};
report.human_visual_acceptance=receipt.status;fs.writeFileSync(path.join(dir,'delivery-check.json'),JSON.stringify(report,null,2)+'\n');console.log(JSON.stringify(report));
