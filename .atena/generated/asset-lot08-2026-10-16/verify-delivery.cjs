const fs=require('fs'),path=require('path'),crypto=require('crypto');
const root=process.cwd(),dir=__dirname,read=p=>JSON.parse(fs.readFileSync(p,'utf8').replace(/^\uFEFF/,''));
const hash=p=>crypto.createHash('sha256').update(fs.readFileSync(p)).digest('hex').toUpperCase();
const assert=(v,m)=>{if(!v)throw Error(m)},m=read(path.join(dir,'manifest.json')),refs=read(path.join(dir,'references.json'));
assert(m.assets.length===11&&m.attempts.length===12&&m.sequences.length===2,'counts');
for(const a of m.assets){assert(hash(path.join(root,a.source))===a.source_sha256,'source '+a.code);assert(hash(path.join(dir,a.qa_frame))===a.qa_sha256,'QA '+a.code);assert(a.width===1254&&a.height===1254,'size');assert(a.edge_band4_alpha_ge16_pixels===0,'edge');}
for(const a of m.attempts)assert(hash(path.join(root,a.file))===a.sha256,'attempt '+a.file);
for(const r of refs)assert(hash(path.join(root,r.path))===r.sha256,'reference '+r.path);
const prompts=fs.readFileSync(path.join(dir,'prompts.md'),'utf8');
assert((prompts.match(/^## /gm)||[]).length===12,'prompt count');
let links=0;const files=[path.join(dir,'index.html'),path.join(dir,'ENTREGA-PARA-IMPLEMENTACAO.md'),path.join(root,'.atena/evidence/asset-lot08-props-and-source-repairs-2026-10-16.md'),path.join(root,'.atena/specs/SPEC-121-retomada-fila-imagens/asset-lot08-props-and-source-repairs-v01.md')];
// This report is the final link target written below.
fs.writeFileSync(path.join(dir,'delivery-check.json'),'{}');
for(const file of files){const s=fs.readFileSync(file,'utf8'),matches=file.endsWith('.html')?[...s.matchAll(/(?:src|href)=["']([^"']+)["']/g)]:[...s.matchAll(/\]\(([^)]+)\)/g)];for(const match of matches){const target=match[1].split('#')[0];if(!target||/^(https?:|data:)/.test(target))continue;assert(fs.existsSync(path.resolve(path.dirname(file),target)),'broken link '+file+' '+target);links++;}}
assert(read(path.join(dir,'player-check.json')).status==='PASS','player');
const result={status:'PASS_DELIVERY_INTEGRITY_ONLY',selected_source_hashes:11,attempt_hashes:12,qa_frame_hashes:11,reference_hashes:refs.length,prompt_records:12,local_links_checked:links,human_visual_acceptance:m.human_visual_acceptance,runtime_admission:false,browser_render_verified:false};fs.writeFileSync(path.join(dir,'delivery-check.json'),JSON.stringify(result,null,2)+'\n');console.log(JSON.stringify(result));
