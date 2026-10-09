from pathlib import Path
import hashlib,json,re
root=Path(__file__).resolve().parents[4];out=Path(__file__).parent;base=root/'.atena/generated/art-candidates/enemies-pilares/sintese_abissal'
selection=json.loads((base/'frame-selection.json').read_text())
selection['attack_03']=dict(version=3,approval_status='PENDING_OWNER_DECISION',reason='Small intermediate gold pendant still has green drop after v01/v02/v03. Three original arms and two main lamps preserved; no fourth version without owner extension.')
(base/'frame-selection.json').write_text(json.dumps(selection,indent=2)+'\n')
gate=dict(id='GATE-PILARES-ATTACK03-PENDANT-2026-10-08',status='PENDING_OWNER_DECISION',frame='attack_03',max_versions=3,reason=selection['attack_03']['reason'],options=['Accept bounded green pendant exception in attack_03 only','Authorize one additional native correction'],preview='.atena/generated/pilares-resume/v01/attack_03_v03_lamp_detail.png',independent_work='Finish death05 and six special frames; no integration pending decision',sources=[])
for version in [1,2,3]:
 p=base/f'sintese_abissal_attack_03_v{version:02}.png'
 gate['sources'].append(dict(version=version,path=p.relative_to(root).as_posix(),sha256=hashlib.sha256(p.read_bytes()).hexdigest()))
(out/'attack03-pendant-owner-gate-2026-10-08.json').write_text(json.dumps(gate,indent=2)+'\n')
p=root/'.atena/state/plan-053-imagens.yaml';t=p.read_text(encoding='utf-8')
t += '\npilares_recovery_decision:\n  id: GATE-PILARES-ATTACK03-PENDANT-2026-10-08\n  status: PENDING_OWNER_DECISION\n  frame: attack_03\n  max_versions: 3\n  checkpoint: BEFORE_PILARES_INTEGRATION\n  reason: Small intermediate pendant retains green drop after three versions.\n  independent_work: Finish death05 and special00-05; no integration pending decision.\n  receipt: .atena/generated/pilares-resume/v01/attack03-pendant-owner-gate-2026-10-08.json\n'
p.write_text(t,encoding='utf-8')
print('Pilares attack03 pending decision persisted; independent cycle generation remains authorized; official admission blocked.')

