'use strict';
const fs=require('fs'),path=require('path'),crypto=require('crypto');
const root=process.cwd(),dir=__dirname,read=p=>JSON.parse(fs.readFileSync(p,'utf8').replace(/^\uFEFF/,'')),hash=b=>crypto.createHash('sha256').update(b).digest('hex').toUpperCase();
const inventory=read(path.join(dir,'inventory.json')),packages=[],errors=[];
for(const pkg of inventory.packages){
 const base=path.dirname(pkg.files['manifest.json'].path),selected=new Map(),qa=new Map();
 const record=(map,p,h)=>{
  if(typeof p!=='string'||! /\.png$/i.test(p)||typeof h!=='string'||! /^[a-f0-9]{64}$/i.test(h))return;
  const abs=path.resolve(root,p),expected=h.toUpperCase();
  if(map.has(abs)&&map.get(abs)!==expected)throw Error('Conflicting recorded hash: '+p);
  map.set(abs,expected);
 };
 function walk(o){
  if(!o||typeof o!=='object')return;
  if(Array.isArray(o)){o.forEach(walk);return;}
  if(o.source)record(selected,o.source,o.source_sha256||o.sha256);
  if(o.path)record(selected,o.path,o.sha256);
  if(o.file)record(selected,path.join(base,o.file),o.sha256);
  if(o.qa_frame)record(qa,path.join(base,o.qa_frame),o.qa_sha256);
  for(const [k,v]of Object.entries(o))if(!['attempts','reference_hashes','references','reference_snapshot','input_references','anchor_sources'].includes(k))walk(v);
 }
 const receipt=read(path.join(root,pkg.files['visual-acceptance.json'].path));
 if(!receipt.status.startsWith('APPROVED_'))throw Error('Unaccepted package '+pkg.id);
 walk(read(path.join(root,pkg.files['manifest.json'].path)));walk(receipt);
 const files=[];
 for(const [role,map]of [['SOURCE_OR_DELIVERY',selected],['QA_FRAME',qa]])for(const [abs,expected]of map){
  const file={role,path:path.relative(root,abs).replaceAll('\\','/'),expected_sha256:expected};
  if(!fs.existsSync(abs)){file.status='MISSING';errors.push(file.path);}
  else{
   const b=fs.readFileSync(abs);file.actual_sha256=hash(b);
   const png=b.length>=24&&b.subarray(0,8).equals(Buffer.from([137,80,78,71,13,10,26,10]))&&b.toString('ascii',12,16)==='IHDR';
   if(png){file.width=b.readUInt32BE(16);file.height=b.readUInt32BE(20);}
   file.status=file.actual_sha256!==expected?'HASH_MISMATCH':!png||!file.width||!file.height?'INVALID_PNG_HEADER':'PASS';
   if(file.status!=='PASS')errors.push(file.path);
  }files.push(file);
 }
 if(selected.size===0)errors.push(pkg.id+': no selected PNG records');
 packages.push({id:pkg.id,source_or_delivery_pngs:selected.size,qa_frames:qa.size,files});
}
const selected=packages.reduce((n,p)=>n+p.source_or_delivery_pngs,0),qa=packages.reduce((n,p)=>n+p.qa_frames,0);
if(packages.length!==19||selected!==193||qa!==392)errors.push('Unexpected inventory coverage; review parser and scope');
const report={status:errors.length?'FAIL':'PASS_SELECTED_FILES_INTEGRITY',date:'2026-10-17',packages_checked:packages.length,source_or_delivery_pngs:selected,qa_frame_pngs:qa,missing_or_invalid:errors.length,errors,scope:'19 recent accepted packages; file existence, recorded SHA256 and PNG IHDR only. Includes two prepared fog outputs as well as their two native sources. Excludes rejected attempts and historical packages outside this handoff.',technical_holds_preserved:true,pixel_or_animation_quality_verified:false,runtime_verified:false,packages};
fs.writeFileSync(path.join(dir,'source-files-check.json'),JSON.stringify(report,null,2)+'\n');
console.log(JSON.stringify({...report,packages:undefined}));if(errors.length)process.exitCode=1;
