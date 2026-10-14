from pathlib import Path
import hashlib,json,re
from PIL import Image
out=Path(__file__).resolve().parent
root=out.parents[2]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
protected=json.loads((out/'protected.json').read_text(encoding='utf-8'))
assert all(sha(root/p)==h for p,h in protected.items())
recovery=json.loads((out/'recovery.json').read_text(encoding='utf-8'))
for e in recovery['sources']:assert sha(root/e['path'])==e['sha256']
links=re.findall(r'(?:src|href)="([^"]+)"',(out/'index.html').read_text(encoding='utf-8'))
assert all((out/p).exists() for p in links)
gifs={}
for family in ['flight','impact']:
    with Image.open(out/'provenance'/f'orbe-arcano-{family}-review-2026-10-09.gif') as im:gifs[family]={'frames':im.n_frames,'size':list(im.size),'historical_preview_only':True}
verification={'status':'PASS','native_sources_verified':8,'runtime_files_unchanged':len(protected),'gallery_links_verified':len(links),'preview_gifs':gifs,'model_inspection':'Eight native sources and historical sheet/96px thumbnails inspected. Ring/glyph positions appear stable, smoky tail faces left, impact peaks Q06, fades to fragmented ring Q07 and dim remnants Q08. No visible cuts. Animated perception/loop closure remains human pending; no browser playback claimed.','photometric_note':'Historical x centroid spread ~2.84% is not proof of geometric ring motion. Approved Q01 framing preserved; exact runtime pivot is deferred.','content_state':'DRAFT_SEQUENCE_Q01_V03_HISTORICAL_APPROVAL_PRESERVED','human_acceptance':'Q02_TO_Q08_V01_PENDING','runtime_admission':False,'canonical_promotion':False,'new_generation':0}
(out/'verification.json').write_text(json.dumps(verification,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
state=root/'.atena/state/orbe-arcano-review.yaml'
s=state.read_text(encoding='utf-8').replace('status: IN_PROGRESS','status: TECHNICAL_REVIEW_DELIVERED_PENDING_OWNER_VISUAL_ACCEPTANCE').replace('checkpoint: S-003/VISUAL_REVIEW','checkpoint: S-004/OWNER_SEQUENCE_REVIEW').replace('current_step_position: 3','current_step_position: 4').replace('completed_steps: 2','completed_steps: 4').replace('remaining_steps_after_current: 1','remaining_steps_after_current: 0')
s+='''recovery: .atena/generated/orbe-arcano-review-2026-10-13/recovery.json
audit: .atena/generated/orbe-arcano-review-2026-10-13/audit.json
verification: .atena/generated/orbe-arcano-review-2026-10-13/verification.json
evidence: .atena/evidence/orbe-arcano-review-2026-10-13.md
gallery: .atena/generated/orbe-arcano-review-2026-10-13/index.html
selected: [Q01v03, Q02v01, Q03v01, Q04v01, Q05v01, Q06v01, Q07v01, Q08v01]
pending_visual_acceptance: [Q02v01, Q03v01, Q04v01, Q05v01, Q06v01, Q07v01, Q08v01]
next_objective: Dono avaliar as sete fases DRAFT; apos aceite preparar proposta de normalizacao/admissao.
next_inputs: Fontes/hashes, aceite visual, renderer e allowlist das tres armas magicas.
next_output: Proposta limitada de atlas/pivos/escala/cadencia e integracao, sem alterar gameplay.
next_checks: Legibilidade, loop, glifos, fallbacks, reduzido, regressao Radiante/Pulso/Ampulheta.
admission_execution_authorized: false
previous_human_playtests: PROCEDURE_NOT_REPORTED_PRESERVED
'''
state.write_text(s,encoding='utf-8')
block='''orbe_arcano_review_2026_10_13:
  plan: PLAN-053
  revision: orbe-arcano-review/v01
  classification: IN_PLAN
  state_file: .atena/state/orbe-arcano-review.yaml
  mode: per-plan
  status: TECHNICAL_REVIEW_DELIVERED_PENDING_OWNER_VISUAL_ACCEPTANCE
  checkpoint: S-004/OWNER_SEQUENCE_REVIEW
  completed_steps: 4
  total_steps: 4
  content_state: DRAFT_Q01_V03_HISTORICAL_APPROVAL_PRESERVED
  runtime_admission: false
  canonical_promotion: false
  return_plan: PLAN-071
  return_checkpoint: B-006/S-011
'''
for name in ['plan.yaml','plan-053-imagens.yaml']:
    p=root/'.atena/state'/name;s=p.read_text(encoding='utf-8')
    assert 'orbe_arcano_review_2026_10_13:' not in s
    if name=='plan-053-imagens.yaml':
        s=s.replace('S-007/VFX/ORBE_RADIANTE/OWNER_RUNTIME_PLAYTEST','S-007/VFX/ORBE_ARCANO/OWNER_SEQUENCE_REVIEW').replace('ORBE_RADIANTE_ADMITTED_LOCAL_OWNER_PLAYTEST_PENDING','ORBE_ARCANO_REVIEW_DELIVERED_OWNER_VISUAL_ACCEPTANCE_PENDING')
        s=s.replace('Orbe Radiante admitido localmente DRAFT; suite/smoke/paridade/capturas PASS, feedback humano runtime pendente.','Orbe Radiante entrega aceita; Orbe Arcano oito fontes verificadas, Q02-Q08 aguardam aceite visual DRAFT.')
        s=s.replace('Playtest humano Orbe Radiante; depois retomar Orbe Arcano existente, sem regeneracao automatica.','Aceite visual Orbe Arcano Q02-Q08; depois proposta de admissao, sem regeneracao automatica.')
        s=s.replace("review: '.atena/generated/orbe-radiante-admission-2026-10-13/index.html'","review: '.atena/generated/orbe-arcano-review-2026-10-13/index.html'").replace("evidence: '.atena/evidence/orbe-radiante-admission-2026-10-13.md'","evidence: '.atena/evidence/orbe-arcano-review-2026-10-13.md'")
    p.write_text(s+block,encoding='utf-8')
print(json.dumps(verification,ensure_ascii=False))
