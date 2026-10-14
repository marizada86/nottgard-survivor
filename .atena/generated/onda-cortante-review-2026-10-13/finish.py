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
assert all((out/link).exists() for link in links)
gifs={}
for family in ['flight','impact']:
    with Image.open(out/'provenance'/f'onda-cortante-{family}-review-2026-10-09.gif') as im:gifs[family]={'frames':im.n_frames,'size':list(im.size),'historical_preview_only':True}
selected=[e['code']+e['version'] for e in recovery['sources']]
assert selected==['R01v02','R02v01','R03v01','R04v01','R05v02','R06v01','R07v01','R08v01']
verification={'status':'PASS','sources_verified':8,'selected':selected,'runtime_files_unchanged':len(protected),'gallery_links_verified':len(links),'preview_gifs':gifs,'model_inspection':'Eight native sources and historical sheet/96px thumbnails inspected. Right-facing crescent, leftward tapered tips and fine jagged lightning retained; compact impact R05v02, peak R06, fragmented annulus R07 and faint residues R08. No visible edge cuts. Animated closure R04->R01 remains human pending; browser playback not claimed.','pivot_note':'Historical hot-light centroid is a consistency proxy, not geometric crescent pivot. No source or frame-position edits.','human_acceptance':'R01v02_APPROVED_HISTORICALLY_SEVEN_OTHER_PHASES_PENDING','canonical_promotion':False,'runtime_admission':False,'new_generation':0}
(out/'verification.json').write_text(json.dumps(verification,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=root/'.atena/state/onda-cortante-review.yaml';s=p.read_text(encoding='utf-8').replace('status: IN_PROGRESS','status: TECHNICAL_REVIEW_DELIVERED_PENDING_OWNER_VISUAL_ACCEPTANCE').replace('checkpoint: S-003/VISUAL_REVIEW','checkpoint: S-004/OWNER_SEQUENCE_REVIEW').replace('current_step_position: 3','current_step_position: 4').replace('completed_steps: 2','completed_steps: 4').replace('remaining_steps_after_current: 1','remaining_steps_after_current: 0')
s+='''recovery: .atena/generated/onda-cortante-review-2026-10-13/recovery.json
audit: .atena/generated/onda-cortante-review-2026-10-13/audit.json
verification: .atena/generated/onda-cortante-review-2026-10-13/verification.json
gallery: .atena/generated/onda-cortante-review-2026-10-13/index.html
evidence: .atena/evidence/onda-cortante-review-2026-10-13.md
selected: [R01v02, R02v01, R03v01, R04v01, R05v02, R06v01, R07v01, R08v01]
pending_visual_acceptance: [R02v01, R03v01, R04v01, R05v02, R06v01, R07v01, R08v01]
next_objective: Dono avaliar as sete fases DRAFT; apos aceite preparar proposta de normalizacao/admissao.
next_inputs: Oito fontes/hashes, aceite visual, renderer e armas Lamina Trovejante/Tempestade.
next_output: Proposta de atlas/pivo/escala/cadencia e integracao limitada, sem gameplay novo.
next_checks: Crescente, raios, loop, impacto, fallbacks/reduzido e regressao das familias admitidas.
admission_execution_authorized: false
previous_human_playtests: PROCEDURE_NOT_REPORTED_PRESERVED
''';p.write_text(s,encoding='utf-8')
block='''onda_cortante_review_2026_10_13:
  plan: PLAN-053
  revision: onda-cortante-review/v01
  classification: IN_PLAN
  state_file: .atena/state/onda-cortante-review.yaml
  mode: per-plan
  status: TECHNICAL_REVIEW_DELIVERED_PENDING_OWNER_VISUAL_ACCEPTANCE
  checkpoint: S-004/OWNER_SEQUENCE_REVIEW
  completed_steps: 4
  total_steps: 4
  content_state: DRAFT_R01_V02_HISTORICAL_APPROVAL_PRESERVED
  runtime_admission: false
  canonical_promotion: false
  return_plan: PLAN-071
  return_checkpoint: B-006/S-011
'''
for name in ['plan.yaml','plan-053-imagens.yaml']:
    p=root/'.atena/state'/name;s=p.read_text(encoding='utf-8');assert 'onda_cortante_review_2026_10_13:' not in s
    if name=='plan-053-imagens.yaml':
        s=s.replace('S-007/VFX/ORBE_ARCANO/OWNER_RUNTIME_PLAYTEST','S-007/VFX/ONDA_CORTANTE/OWNER_SEQUENCE_REVIEW').replace('ORBE_ARCANO_ADMITTED_LOCAL_OWNER_PLAYTEST_PENDING','ONDA_CORTANTE_REVIEW_DELIVERED_OWNER_VISUAL_ACCEPTANCE_PENDING')
        s=s.replace('Orbe Arcano admitido localmente DRAFT; suite/smoke/capturas/regressao Radiante PASS; feedback humano runtime pendente.','Orbe Arcano entrega aceita; Onda Cortante oito fontes verificadas, sete fases DRAFT aguardam aceite visual.')
        s=s.replace('Playtest humano Orbe Arcano; depois retomar Onda Cortante existente, sem regeneracao automatica.','Aceite visual Onda Cortante R02/R03/R04/R05v02/R06/R07/R08; depois proposta de admissao.')
        s=s.replace("review: '.atena/generated/orbe-arcano-admission-2026-10-13/index.html'","review: '.atena/generated/onda-cortante-review-2026-10-13/index.html'").replace("evidence: '.atena/evidence/orbe-arcano-admission-2026-10-13.md'","evidence: '.atena/evidence/onda-cortante-review-2026-10-13.md'")
    p.write_text(s+block,encoding='utf-8')
targets=[root/'.atena/evidence/onda-cortante-review-2026-10-13.md',root/'.atena/specs/SPEC-121-retomada-fila-imagens/onda-cortante-review-v01.md']
for p in targets:
    for target in re.findall(r'\]\(([^)]+)\)',p.read_text(encoding='utf-8')):assert (p.parent/target).exists(),target
assert re.search(r'active_plan:\s+id: PLAN-071',(root/'.atena/state/plan.yaml').read_text(encoding='utf-8'))
print(json.dumps(verification,ensure_ascii=False))
