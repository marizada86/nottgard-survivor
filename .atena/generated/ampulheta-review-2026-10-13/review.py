from pathlib import Path
import subprocess,json,hashlib,shutil,re,os,html
from PIL import Image
import numpy as np
root=Path(__file__).resolve().parents[3];out=Path(__file__).resolve().parent
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
def blob(rel):return subprocess.check_output(['git','show','10bd31c:'+rel],cwd=root)
def load(rel):return json.loads(blob(rel).decode('utf-8-sig'))
protected={p.relative_to(root).as_posix():sha(p) for d in ['assets','core','ui','data','tests'] for p in (root/d).rglob('*') if p.is_file()}
(out/'protected.json').write_text(json.dumps(protected,indent=2)+'\n',encoding='utf-8')
for rel in ['.atena/state/plan.yaml','.atena/state/plan-053-imagens.yaml','.atena/state/pulso-admission.yaml']:
 dst=out/'before'/Path(rel).name;dst.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(root/rel,dst)
base='.atena/generated/s007-reconciliation/v01/'
history=['ampulheta-silencio-sequence-audit-2026-10-09.json','m03-owner-approval-2026-10-09.json','m01-scale-owner-approval-2026-10-09.json','mh-generation-jobs-2026-10-09.json','ampulheta-silencio-six-frame-review-2026-10-09.png','ampulheta-silencio-sequence-review-2026-10-09.gif']
for name in history:
 dst=out/'provenance'/name;dst.parent.mkdir(parents=True,exist_ok=True);dst.write_bytes(blob(base+name))
jobs=[]
for name in ['nm-generation-jobs-2026-10-09.json','mh-generation-jobs-2026-10-09.json']:jobs+=load(base+name)['jobs']
audit=load(base+history[0]);selected=[];metrics=[]
for e in audit['sources']:
 j=next(j for j in jobs if j.get('sha256')==e['sha256']);original=Path(j['original_path']);assert original.is_file() and sha(original)==e['sha256']
 dst=root/e['path'];dst.parent.mkdir(parents=True,exist_ok=True)
 if dst.exists():assert sha(dst)==e['sha256']
 else:shutil.copy2(original,dst)
 assert sha(dst)==e['sha256']
 accepted='HISTORICAL_PEAK_APPROVED' if e['code']=='M03' else 'HISTORICAL_SCALE_EXCEPTION_ACCEPTED' if e['code']=='M01' else 'PENDING_VISUAL_SEQUENCE_REVIEW'
 selected.append(dict(e,archived_original=str(original),prompt=j['prompt'],human_acceptance=accepted))
 im=Image.open(dst);a=np.array(im.convert('RGB'));lum=a.max(axis=2);yy,xx=np.where(lum>12);edge=int(max(lum[0,:].max(),lum[-1,:].max(),lum[:,0].max(),lum[:,-1].max()))
 assert im.size==(1254,1254) and edge<=12
 metrics.append({'code':e['code'],'version':e['version'],'sha256':e['sha256'],'size':list(im.size),'mode':im.mode,'bbox_max_channel_gt12':[int(xx.min()),int(yy.min()),int(xx.max()+1),int(yy.max()+1)],'edge_max_channel':edge,'max_channel_difference':int((a.max(axis=2).astype(int)-a.min(axis=2).astype(int)).max()),'native_bytes_preserved':True})
receipt={'date':'2026-10-13','revision':'ampulheta-review/v01','mode':'per-plan','owner_reply':'atena, aprovado continuar fila de assets','classification':'IN_PLAN','source_record_ref':'10bd31c','sources':selected,'historical_m03_approval':load(base+history[1]),'historical_m01_exception':load(base+history[2]),'new_generation':0,'runtime_admission':False,'canonical_promotion':False}
(out/'recovery.json').write_text(json.dumps(receipt,ensure_ascii=False,indent=2)+'\n',encoding='utf-8');(out/'audit.json').write_text(json.dumps({'result':'PASS_NATIVE_RECOVERY','rows':metrics,'black_rgb_exact':'NOT_CLAIMED','grayscale_exact':'NOT_CLAIMED','normalized':False},indent=2)+'\n',encoding='utf-8')
urls=[os.path.relpath(root/e['path'],out).replace('\\','/') for e in selected]
gallery='''<!doctype html><html lang="pt-BR"><meta charset="utf-8"><title>Ampulheta — revisão DRAFT v01</title><style>body{background:#171c24;color:#eee;font:16px system-ui;max-width:1150px;margin:32px auto}.grid{display:grid;grid-template-columns:repeat(3,1fr);gap:18px}img.native{width:100%}.small{width:96px;height:96px}h1,h2{color:#e5c178}small{overflow-wrap:anywhere}figure{margin:0}</style><h1>Ampulheta do Silêncio · seis fases</h1><p>DRAFT v01. M03v01 aprovado; M01v02 aceito com exceção≈14%do raio inicial. Quatro demais fases aguardam aceite; sem runtime/CANON.</p><img src="provenance/ampulheta-silencio-sequence-review-2026-10-09.gif" width="360" height="360"><p>Prévia histórica; cadência final/persistência da zona ainda não definidas. Observar a96px: círculo calmo, ampulhetas/grãos, expansão, afinamento e resíduos.</p><div class="grid">'''
for e,url in zip(selected,urls):gallery+=f'<figure><h2>{e["code"]} {e["version"]}</h2><a href="{html.escape(url)}"><img class="native" src="{html.escape(url)}"></a><img class="small" src="{html.escape(url)}"><p>{e["human_acceptance"]}</p><small>{e["sha256"]}</small></figure>'
(out/'index.html').write_text(gallery+'</div></html>',encoding='utf-8')
p=root/'.atena/state/pulso-admission.yaml';s=p.read_text(encoding='utf-8').replace('status: LOCAL_TECHNICAL_DELIVERED_AWAITING_OWNER_PLAYTEST','status: OWNER_ACCEPTED_LOCAL_DELIVERY').replace('checkpoint: S-004/OWNER_RUNTIME_PLAYTEST','checkpoint: S-004/OWNER_DELIVERY_ACCEPTANCE_RECORDED').replace('human_runtime_playtest: PENDING_NOT_PERFORMED','human_runtime_playtest: PROCEDURE_NOT_REPORTED').replace('next_objective: Dono avaliar intensidade, legibilidade e ritmo do pulso no playtest.','next_objective: Continuar fila pela revisao da Ampulheta; playtest nao relatado permanece distinguido.');s+='owner_delivery_reply: "atena, aprovado continuar fila de assets"\nowner_acceptance_date: "2026-10-13"\n';p.write_text(s,encoding='utf-8')
(out/'pulse-delivery-acceptance.json').write_text(json.dumps({'date':'2026-10-13','reply':'atena, aprovado continuar fila de assets','scope':'Previous local pulso-admission/v01 delivery accepted and asset queue continuation authorized','human_playtest_procedure':'NOT_REPORTED','subjective_specific_criteria':'NOT_INDEPENDENTLY_VERIFIED','content_state':'DRAFT','canonical_promotion':False,'accepted_build_id':'0.4.0/pulso-admission-v01/2ae8c48+local-fc366e643f4d'},ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
state='''version: 1
plan: PLAN-053
revision: ampulheta-review/v01
classification: IN_PLAN
mode: per-plan
status: TECHNICAL_REVIEW_DELIVERED_PENDING_OWNER_VISUAL_INSPECTION
checkpoint: S-004/OWNER_SEQUENCE_REVIEW
ordered_steps: [S-001, S-002, S-003, S-004]
current_step_position: 4
completed_steps: 4
total_steps: 4
remaining_steps_after_current: 0
spec: .atena/specs/SPEC-121-retomada-fila-imagens/ampulheta-review-v01.md
owner_reply: 'atena, aprovado continuar fila de assets'
recovery: .atena/generated/ampulheta-review-2026-10-13/recovery.json
audit: .atena/generated/ampulheta-review-2026-10-13/audit.json
gallery: .atena/generated/ampulheta-review-2026-10-13/index.html
selected: [M01v02, M02v03, M03v01, M04v01, M05v01, M06v01]
historical_approvals: {M03v01: PEAK_APPROVED, M01v02: SCALE_14_PERCENT_EXCEPTION_ACCEPTED}
pending_visual_acceptance: [M02v03, M04v01, M05v01, M06v01]
content_state: DRAFT_SEQUENCE_HISTORICAL_PEAK_AND_EXCEPTION_PRESERVED
runtime_changed: false
canonical_promotion: false
new_generation: 0
next_objective: Dono avaliar quatro fases adicionais; depois propor normalizacao e admissao do efeito existente.
next_execution_authorized: false
return_plan: {id: PLAN-071, checkpoint: B-006/S-011, preserved: true}
hero_playtest: PENDING_PRESERVED
''';(root/'.atena/state/ampulheta-review.yaml').write_text(state,encoding='utf-8')
p=root/'.atena/state/plan-053-imagens.yaml';s=p.read_text(encoding='utf-8').replace('status: PULSO_ADMITTED_LOCAL_OWNER_PLAYTEST_PENDING','status: AMPULHETA_REVIEW_PENDING_OWNER_SEQUENCE_ACCEPTANCE').replace('checkpoint: S-007/VFX/PULSO/OWNER_RUNTIME_PLAYTEST','checkpoint: S-007/VFX/AMPULHETA/OWNER_SEQUENCE_REVIEW');s=re.sub(r'^  current:.*$',"  current: 'Pulso entrega local aceita; Ampulheta seis fontes recuperadas por hash, M03/M01historicos preservados, revisao das quatro fases pendente.'",s,count=1,flags=re.M);s=re.sub(r'^  next:.*$',"  next: 'Dono avaliar M02v03,M04v01,M05v01,M06v01; depois propor admissao da Ampulheta. Nenhuma fonte nova necessaria.'",s,count=1,flags=re.M);p.write_text(s,encoding='utf-8')
p=root/'.atena/state/plan.yaml';s=p.read_text(encoding='utf-8');prefix,tail=s.split('pulso_admission_2026_10_13:',1);tail=tail.replace('status: LOCAL_TECHNICAL_DELIVERED_AWAITING_OWNER_PLAYTEST','status: OWNER_ACCEPTED_LOCAL_DELIVERY').replace('checkpoint: S-004/OWNER_RUNTIME_PLAYTEST','checkpoint: S-004/OWNER_DELIVERY_ACCEPTANCE_RECORDED');s=prefix+'pulso_admission_2026_10_13:'+tail;s+='''ampulheta_review_2026_10_13:
  plan: PLAN-053
  revision: ampulheta-review/v01
  classification: IN_PLAN
  state_file: .atena/state/ampulheta-review.yaml
  mode: per-plan
  status: TECHNICAL_REVIEW_DELIVERED_PENDING_OWNER_VISUAL_INSPECTION
  checkpoint: S-004/OWNER_SEQUENCE_REVIEW
  total_steps: 4
  completed_steps: 4
  content_state: DRAFT
  runtime_admission: false
  canonical_promotion: false
  return_plan: PLAN-071
  return_checkpoint: B-006/S-011
''';p.write_text(s,encoding='utf-8')
assert all(sha(root/p)==h for p,h in protected.items())
print(json.dumps({'result':'PASS','six_sources':True,'native_hashes':'PASS','new_generation':0,'protected_runtime_files':len(protected),'pending_visual_acceptance':['M02v03','M04v01','M05v01','M06v01']},indent=2))
