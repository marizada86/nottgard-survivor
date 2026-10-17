'use strict';
const fs=require('fs'),path=require('path');
const root=process.cwd(),dir=__dirname;
const assert=(v,m)=>{if(!v)throw Error(m)};
const statePath='.atena/state/asset-lot14-mimic-totem.yaml';
const state=fs.readFileSync(path.join(root,statePath),'utf8').trimEnd().replace(/\r\n/g,'\n');
const central=fs.readFileSync(path.join(root,'.atena/state/plan.yaml'),'utf8');
const key='asset_lot14_mimic_totem_2026_10_17:';
assert(central.slice(central.indexOf(key)+key.length).replace(/^\r?\n/,'').split(/\r?\n(?=[a-zA-Z_])/)[0].trimEnd().split(/\r?\n/).map(s=>s.replace(/^  /,'')).join('\n')===state,'state replicas');
for(const field of ['mode: per-plan','approval_status: APPROVED_CONTEXTUAL_CONTINUATION','completed_steps: 4','generated: 29','generation_attempts: 36','human_visual_acceptance: APPROVED_EXPLICITLY_SOURCE_DIRECTION','next_execution_authorized: false','runtime_admission: false','canonical_promotion: false'])assert(state.includes(field),'state '+field);
let paths=0;
for(const m of state.matchAll(/^(?:specification|references|gallery|evidence|manifest): (.+)$/gm)){assert(fs.existsSync(path.join(root,m[1].trim())),'state path');paths++;}
let links=0;
for(const rel of ['.atena/specs/SPEC-121-retomada-fila-imagens/asset-lot14-mimic-totem-v01.md','.atena/evidence/asset-lot14-mimic-totem-2026-10-17.md']){
 const file=path.join(root,rel),s=fs.readFileSync(file,'utf8');
 for(const m of s.matchAll(/\]\(([^)]+)\)/g)){assert(fs.existsSync(path.resolve(path.dirname(file),m[1])),'link '+m[1]);links++;}
}
const prompts=fs.readFileSync(path.join(dir,'prompts.md'),'utf8');
assert(!prompts.includes('undefined'),'missing prompt content');
const report={status:'PASS_LOCAL_CONTRACT',state_replicas_match:true,ordered_steps:4,completed_steps:4,state_paths:paths,spec_evidence_links:links,scope:'LOT14 visually accepted; technical holds preserved'};
fs.writeFileSync(path.join(dir,'contract-check.json'),JSON.stringify(report,null,2)+'\n');console.log(JSON.stringify(report));
