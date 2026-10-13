from pathlib import Path
import subprocess,json,hashlib,shutil
root=Path(__file__).resolve().parents[3];out=Path(__file__).resolve().parent
ref='10bd31c'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
def blob(rel):return subprocess.check_output(['git','show',ref+':'+rel],cwd=root)
def load(rel):return json.loads(blob(rel).decode('utf-8-sig'))
snap={p.relative_to(root).as_posix():sha(p) for d in ['assets','core','ui','data','tests'] for p in (root/d).rglob('*') if p.is_file()}
(out/'protected.json').write_text(json.dumps(snap,indent=2)+'\n',encoding='utf-8')
for rel in ['.atena/state/plan.yaml','.atena/state/plan-053-imagens.yaml','.atena/state/hero-admission.yaml']:
 dst=out/'before'/Path(rel).name;dst.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(root/rel,dst)
history=['.atena/generated/n03-publication-2026-10-09/receipt.json','.atena/generated/s007-reconciliation/v01/pulso-radiante-sequence-audit-2026-10-09.json','.atena/generated/s007-reconciliation/v01/nm-generation-jobs-2026-10-09.json','.atena/generated/s007-reconciliation/v01/pulse-phase-radius-audit-2026-10-09.json','.atena/generated/s007-reconciliation/v01/pulso-radiante-six-frame-review-2026-10-09.png','.atena/generated/s007-reconciliation/v01/pulso-radiante-sequence-review-2026-10-09.gif','.atena/generated/s007-reconciliation/v01/h103-owner-gate-2026-10-09.json','.atena/evidence/continuous-draft-generation-2026-10-09.md','.atena/generated/CHATGPT-FILA-022-vfx-projeteis-e-explosoes.md','.atena/generated/CHATGPT-FILA-023-vfx-habilidades-dos-herois.md','.atena/state/plan-053-imagens.yaml']
provenance=[]
for rel in history:
 dst=out/'provenance'/Path(rel).name;dst.parent.mkdir(parents=True,exist_ok=True);data=blob(rel);dst.write_bytes(data);provenance.append({'git_ref':ref,'repository_path':rel,'local':dst.relative_to(root).as_posix(),'sha256':sha(dst)})
audit=load(history[1]);jobs=[]
for f in ['rn-generation-jobs-2026-10-09.json','nm-generation-jobs-2026-10-09.json']:
 jobs+=load('.atena/generated/s007-reconciliation/v01/'+f)['jobs']
selected=[]
for e in audit['sources']:
 j=next(j for j in jobs if j.get('sha256')==e['sha256']);src=Path(j['original_path']);assert src.is_file() and sha(src)==e['sha256']
 dst=root/e['path'];dst.parent.mkdir(parents=True,exist_ok=True)
 if dst.exists():assert sha(dst)==e['sha256']
 else:shutil.copy2(src,dst)
 assert sha(dst)==e['sha256']
 selected.append(dict(e,archived_original=str(src),prompt=j['prompt'],human_acceptance='APPROVED_N03_GATE' if e['code']=='N03' else 'PENDING_SEQUENCE_REVIEW'))
receipt={'date':'2026-10-13','revision':'pulso-resume/v01','request':'atena, seguir recomendação retomando o Pulso Radiante','mode':'per-plan','request_classification':'IN_PLAN','scope':'Restore existing six radiant-pulse native sources and review; no new generation or runtime admission','sources':selected,'provenance':provenance,'historical_n03_publication':load(history[0]),'remote_rechecked_today':False,'git_operations':'READ_ONLY_NO_MERGE_COMMIT_PUSH','content_state':'DRAFT_SEQUENCE_N03_HISTORIC_APPROVED_GATE','runtime_changed':False,'new_imagegen_calls':0,'fila022_generation':'36/36 historical records','fila023_generation':'60/60 historical records','hero_playtest_return':'.atena/state/hero-admission.yaml','ranking_return':'PLAN-071/B-006/S-011'}
(out/'recovery.json').write_text(json.dumps(receipt,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
state='''version: 1
plan: PLAN-053
revision: pulso-resume/v01
classification: IN_PLAN
mode: per-plan
status: IN_PROGRESS_REVIEW_RECOVERED_SOURCES
checkpoint: S-003/REVIEW_SIX_PHASES
ordered_steps: [S-001, S-002, S-003, S-004]
current_step_position: 3
completed_steps: 2
total_steps: 4
remaining_steps_after_current: 1
scope_authorization: 'atena, seguir recomendação retomando o Pulso Radiante'
spec: .atena/specs/SPEC-121-retomada-fila-imagens/pulso-resume-v01.md
recovery: .atena/generated/pulso-resume-2026-10-13/recovery.json
selected: [N01v03, N02v02, N03v01, N04v01, N05v01, N06v01]
content_state: DRAFT_SEQUENCE_HISTORIC_N03_GATE_APPROVED
native_sources: 6
generation_this_resume: 0
runtime_admission: false
canonical_promotion: false
human_sequence_acceptance: PENDING
hero_runtime_playtest: PENDING_PRESERVED
return_plan: {id: PLAN-071, checkpoint: B-006/S-011, preserved: true}
next_objective: Conferir seis fases e preparar galeria e evidencia para revisao humana.
'''
(root/'.atena/state/pulso-resume.yaml').write_text(state,encoding='utf-8')
p=root/'.atena/state/plan.yaml';s=p.read_text(encoding='utf-8');s+='''pulso_resume_2026_10_13:
  plan: PLAN-053
  revision: pulso-resume/v01
  classification: IN_PLAN
  route: RESUME_VFX_QUEUE_PRESERVE_HERO_PLAYTEST_AND_RANKING_RETURN
  state_file: .atena/state/pulso-resume.yaml
  mode: per-plan
  status: IN_PROGRESS_REVIEW_RECOVERED_SOURCES
  checkpoint: S-003/REVIEW_SIX_PHASES
  authority: LOCAL_RECOVERY_WITH_HASHES_FROM_HISTORICAL_REPLICA
  hero_playtest: PENDING_PRESERVED
  return_plan: PLAN-071
  return_checkpoint: B-006/S-011
''';p.write_text(s,encoding='utf-8')
assert all(sha(root/p)==h for p,h in snap.items())
print('PASS recovered six native sources exactly; N03 publication receipt recovered; S001/S002 done; runtime unchanged')
