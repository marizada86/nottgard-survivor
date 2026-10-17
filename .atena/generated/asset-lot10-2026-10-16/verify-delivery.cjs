const fs=require('fs'),path=require('path'),crypto=require('crypto');
const root=process.cwd(),dir=__dirname,read=p=>JSON.parse(fs.readFileSync(p,'utf8').replace(/^\uFEFF/,''));
const hash=p=>crypto.createHash('sha256').update(fs.readFileSync(p)).digest('hex').toUpperCase();
const assert=(v,m)=>{if(!v)throw Error(m)},sequences=read(path.join(dir,'inspection.json')),refs=read(path.join(dir,'references.json'));
assert(sequences.length===7&&sequences.reduce((n,s)=>n+s.frame_count,0)===28,'count');
for(const s of sequences){assert(hash(path.join(root,s.source))===s.source_sha256,'source');for(const f of s.frames){assert(hash(path.join(dir,f.qa_frame))===f.qa_sha256,'QA');assert(f.edge_band4_alpha_ge16_pixels===0,'edge');}}
for(const r of refs)assert(hash(path.join(root,r.path))===r.sha256,'reference');
const sourceDir=path.join(root,'.atena/generated/animation-candidates/asset-lot10');
const attempts=fs.readdirSync(sourceDir).filter(f=>f.endsWith('.png')).sort().map(f=>({source:'.atena/generated/animation-candidates/asset-lot10/'+f,sha256:hash(path.join(sourceDir,f)),selected:sequences.some(s=>path.basename(s.source)===f)}));
assert(attempts.length===13,'attempt count');assert((fs.readFileSync(path.join(dir,'prompts.md'),'utf8').match(/^## /gm)||[]).length===13,'prompts');
const manifest={id:'ASSET-LOT10',revision:'v01',content_state:'DRAFT',status:'VISUALLY_ACCEPTED_DRAFT_WITH_PREPARATION_NOTES',generation_attempts:13,selected_sources:7,qa_drawings:28,sequences,attempts,references:'references.json',prompts:'prompts.md',handoff:'ENTREGA-PARA-IMPLEMENTACAO.md',human_visual_acceptance:'APPROVED_EXPLICITLY_SOURCE_DIRECTION',runtime_admission:false,canonical_promotion:false,implementation_owner:'Claude'};
fs.writeFileSync(path.join(dir,'manifest.json'),JSON.stringify(manifest,null,2)+'\n');fs.writeFileSync(path.join(dir,'delivery-check.json'),'{}');
let links=0;for(const file of ['index.html','ENTREGA-PARA-IMPLEMENTACAO.md']){const s=fs.readFileSync(path.join(dir,file),'utf8'),matches=file.endsWith('.html')?[...s.matchAll(/(?:src|href)=["']([^"']+)["']/g)]:[...s.matchAll(/\]\(([^)]+)\)/g)];for(const match of matches){assert(fs.existsSync(path.resolve(dir,match[1])),'broken link '+match[1]);links++;}}
assert(read(path.join(dir,'player-check.json')).status==='PASS','player');
const report={status:'PASS_DELIVERY_INTEGRITY_ONLY',selected_sources:7,source_attempt_hashes:13,qa_frame_hashes:28,reference_hashes:7,prompt_records:13,local_links:links,human_visual_acceptance:'APPROVED_EXPLICITLY_SOURCE_DIRECTION',runtime_admission:false,browser_render_verified:false};fs.writeFileSync(path.join(dir,'delivery-check.json'),JSON.stringify(report,null,2)+'\n');console.log(JSON.stringify(report));
