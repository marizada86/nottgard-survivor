'use strict';
const fs=require('fs'),path=require('path'),root=process.cwd(),dir=__dirname,assert=(v,m)=>{if(!v)throw Error(m)};
const statePath='.atena/state/asset-lot15-heroes-back-walk.yaml',state=fs.readFileSync(path.join(root,statePath),'utf8').trimEnd().replace(/\r\n/g,'\n'),central=fs.readFileSync(path.join(root,'.atena/state/plan.yaml'),'utf8'),key='asset_lot15_heroes_back_walk_2026_10_17:';
assert(central.slice(central.indexOf(key)+key.length).replace(/^\r?\n/,'').split(/\r?\n(?=[a-zA-Z_])/)[0].trimEnd().split(/\r?\n/).map(s=>s.replace(/^  /,'')).join('\n')===state,'state replicas');
for(const field of ['mode: per-plan','approval_status: APPROVED_EXPLICITLY','completed_steps: 4','generated: 36','generation_attempts: 52','human_visual_acceptance: APPROVED_EXPLICITLY_SOURCE_DIRECTION','next_execution_authorized: false','runtime_admission: false','canonical_promotion: false'])assert(state.includes(field),'state '+field);
let paths=0,links=0;
for(const m of state.matchAll(/^(?:specification|references|gallery|evidence|manifest): (.+)$/gm)){assert(fs.existsSync(path.join(root,m[1].trim())),'state path');paths++;}
for(const rel of ['.atena/specs/SPEC-121-retomada-fila-imagens/asset-lot15-heroes-back-walk-v01.md','.atena/evidence/asset-lot15-heroes-back-walk-2026-10-17.md']){
 const file=path.join(root,rel),s=fs.readFileSync(file,'utf8');for(const m of s.matchAll(/\]\(([^)]+)\)/g)){assert(fs.existsSync(path.resolve(path.dirname(file),m[1])),'link '+m[1]);links++;}
}
const manifest=JSON.parse(fs.readFileSync(path.join(dir,'manifest.json'),'utf8'));assert(manifest.selected_sources===36&&manifest.generation_attempts===52&&manifest.human_visual_acceptance==='APPROVED_EXPLICITLY_SOURCE_DIRECTION','manifest');
const report={status:'PASS_LOCAL_CONTRACT',state_replicas_match:true,ordered_steps:4,completed_steps:4,state_paths:paths,spec_evidence_links:links,scope:'LOT15 DRAFT visually accepted; technical holds preserved'};
fs.writeFileSync(path.join(dir,'contract-check.json'),JSON.stringify(report,null,2)+'\n');console.log(JSON.stringify(report));
