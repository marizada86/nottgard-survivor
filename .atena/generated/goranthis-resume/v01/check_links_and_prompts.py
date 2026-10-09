from pathlib import Path
import json,re
root=Path(__file__).resolve().parents[4];out=Path(__file__).parent
receipt=json.loads((out/'identity-gate-receipt.json').read_text(encoding='utf-8'))
prompts=[]
for row in receipt['selected']:
 result=json.loads((out/f'result-{row["id"]}-v{row["version"]}.json').read_text(encoding='utf-8'))
 assert (root/row['path']).is_file()
 prompts.append(dict(id=row['id'],version=row['version'],path=row['path'],prompt=result['prompt'],source=result['source'],reference=result.get('reference'),tool='built-in image_gen'))
(out/'final-selected-prompts.json').write_text(json.dumps(prompts,indent=2,ensure_ascii=False)+'\n',encoding='utf-8')
files=[root/'.atena/evidence/shendilavri-complete-2026-10-07.md',root/'.atena/evidence/goranthis-identities-2026-10-07.md']
files += list((root/'.atena/evidence').glob('shendilavri-*-cycles-2026-10-07.md'))
checked=0
for p in files:
 for rel in re.findall(r'\]\(([^)]+)\)',p.read_text(encoding='utf-8')):
  if '://' in rel:continue
  assert (p.parent/rel).resolve().is_file(),(p,rel)
  checked+=1
manifest=json.loads((root/'.atena/generated/PRIORITY-IMAGES-2026-10-02.json').read_text(encoding='utf-8-sig'))
assert len(manifest['assets'])==180
assert not (root/'assets/animations/enemies/guardiao_de_goranthis').exists()
assert 'PENDING_OWNER_APPROVAL' in (root/'.atena/state/plan-053-imagens.yaml').read_text(encoding='utf-8')
assert 'GATE-IDENTITIES-V01' in (root/'.atena/state/plan.yaml').read_text(encoding='utf-8')
print(f'Validated {checked} evidence links and four exact selected prompts; pending gate preserved, manifest180, no Goranthis runtime assets.')
