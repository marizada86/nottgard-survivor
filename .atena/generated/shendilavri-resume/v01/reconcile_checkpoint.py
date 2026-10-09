from pathlib import Path
import json,re,hashlib
root=Path(__file__).resolve().parents[4]
paths=['.atena/evidence/shendilavri-identities-resume-2026-10-07.md','.atena/evidence/shendilavri-escravo-cycles-2026-10-07.md','.atena/evidence/shendilavri-sucubo-preview-2026-10-07.md']
links=0
for rel in paths:
 p=root/rel
 for target in re.findall(r'\]\(([^)]+)\)',p.read_text(encoding='utf-8')):
  if '://' not in target:
   assert (p.parent/target).resolve().exists(),target
   links+=1
p=root/'.atena/generated/ART-PROMPTS-048-mobs-shendilavri.md';t=p.read_text(encoding='utf-8');t=re.sub(r'^status: .*$', 'status: "5 identidades aprovadas; Escravo integrado; Sucubo previa pronta aguardando decisao caminhada"',t,count=1,flags=re.M);p.write_text(t,encoding='utf-8')
p=root/'.atena/state/plan.yaml';t=p.read_text(encoding='utf-8');t=t.replace('Shendilavri cinco candidatas prontas aguardando gate visual.','Shendilavri identidades aprovadas; Escravo integrado; Sucubo previa pronta com decisao da caminhada pendente.');p.write_text(t,encoding='utf-8')
p=root/'.atena/generated/shendilavri-resume/v01/sucubo-preview-receipt.json';r=json.loads(p.read_text());r['record_links_verified']=links;r['admission_guard_checked']='Installer rejected PENDING_OWNER_DECISION sucubo/move04 before writes; official view/test/manifest hashes unchanged.';r['git_diff_check']='Passed, no whitespace errors; CRLF normalization warnings only.';p.write_text(json.dumps(r,indent=2)+'\n',encoding='utf-8')
print(f'{links} evidence links verified; guard and diff receipts recorded; state reconciled.')
