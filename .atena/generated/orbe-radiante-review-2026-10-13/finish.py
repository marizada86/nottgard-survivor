from pathlib import Path
import hashlib, json, re
from PIL import Image

out = Path(__file__).resolve().parent
root = out.parents[2]
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
protected = json.loads((out/'protected.json').read_text(encoding='utf-8'))
assert all(sha(root/p) == h for p,h in protected.items())
recovery = json.loads((out/'recovery.json').read_text(encoding='utf-8'))
for e in recovery['sources']:
    assert sha(root/e['path']) == e['sha256']
links = re.findall(r'(?:src|href)="([^"]+)"', (out/'index.html').read_text(encoding='utf-8'))
assert all((out/link).is_file() for link in links)
gifs = {}
for name in ['flight','impact']:
    p = out/'provenance'/f'orbe-radiante-{name}-review-2026-10-09.gif'
    with Image.open(p) as im:
        gifs[name] = {'frames':im.n_frames, 'size':list(im.size), 'historical_preview_only':True}
verification = {'status':'PASS', 'sources_verified':8, 'runtime_files_unchanged':len(protected), 'gallery_links_verified':len(links), 'preview_gifs':gifs, 'new_generation':0, 'native_pixel_edits':0, 'canonical_promotion':False, 'runtime_admission':False, 'visual_inspection':'Eight native sources and historical sheet with 96px thumbnails inspected; no visible cuts, right-facing flight/left tail, peak P06, fragments P07 and faint remnants P08. Animated loop acceptance remains human pending; browser playback not claimed.', 'human_acceptance':'P01_HISTORICAL_APPROVED_P02_TO_P08_PENDING'}
(out/'verification.json').write_text(json.dumps(verification, ensure_ascii=False, indent=2)+'\n',encoding='utf-8')
state = root/'.atena/state/orbe-radiante-review.yaml'
s = state.read_text(encoding='utf-8').replace('status: IN_PROGRESS','status: TECHNICAL_REVIEW_DELIVERED_PENDING_OWNER_VISUAL_ACCEPTANCE').replace('checkpoint: S-003/VISUAL_REVIEW','checkpoint: S-004/OWNER_SEQUENCE_REVIEW').replace('current_step_position: 3','current_step_position: 4').replace('completed_steps: 2','completed_steps: 4').replace('remaining_steps_after_current: 1','remaining_steps_after_current: 0')
s += '''recovery: .atena/generated/orbe-radiante-review-2026-10-13/recovery.json
audit: .atena/generated/orbe-radiante-review-2026-10-13/audit.json
verification: .atena/generated/orbe-radiante-review-2026-10-13/verification.json
gallery: .atena/generated/orbe-radiante-review-2026-10-13/index.html
evidence: .atena/evidence/orbe-radiante-review-2026-10-13.md
selected: [P01v01, P02v01, P03v01, P04v01, P05v01, P06v01, P07v01, P08v01]
pending_visual_acceptance: [P02v01, P03v01, P04v01, P05v01, P06v01, P07v01, P08v01]
next_objective: Dono revisar voo e impacto; apos aceite preparar proposta de normalizacao/admissao.
next_inputs: Oito fontes e hashes, aceite visual, roteamento atual de projeteis radiantes.
next_output: Proposta de atlas de voo/impacto, pivô, escala, cadencia, allowlist e checks.
next_checks: Preservar gameplay e fallbacks, cores, impacto reduzido, loop e cleanup.
admission_execution_authorized: false
human_runtime_playtests: PREVIOUS_PENDING_PRESERVED
'''
state.write_text(s,encoding='utf-8')
block = '''orbe_radiante_review_2026_10_13:
  plan: PLAN-053
  revision: orbe-radiante-review/v01
  classification: IN_PLAN
  state_file: .atena/state/orbe-radiante-review.yaml
  mode: per-plan
  status: TECHNICAL_REVIEW_DELIVERED_PENDING_OWNER_VISUAL_ACCEPTANCE
  checkpoint: S-004/OWNER_SEQUENCE_REVIEW
  completed_steps: 4
  total_steps: 4
  content_state: DRAFT_P01_HISTORICAL_APPROVAL_PRESERVED
  runtime_admission: false
  canonical_promotion: false
  return_plan: PLAN-071
  return_checkpoint: B-006/S-011
'''
central = root/'.atena/state/plan.yaml'
text = central.read_text(encoding='utf-8')
assert 'orbe_radiante_review_2026_10_13:' not in text
central.write_text(text+block,encoding='utf-8')
cursor = root/'.atena/state/plan-053-imagens.yaml'
s = cursor.read_text(encoding='utf-8').replace('checkpoint: S-007/VFX/AMPULHETA/OWNER_RUNTIME_PLAYTEST','checkpoint: S-007/VFX/ORBE_RADIANTE/OWNER_SEQUENCE_REVIEW').replace('status: AMPULHETA_ADMITTED_LOCAL_OWNER_PLAYTEST_PENDING','status: ORBE_RADIANTE_REVIEW_DELIVERED_OWNER_VISUAL_ACCEPTANCE_PENDING').replace('Ampulheta seis fases admitidas localmente DRAFT; suite/smoke/capturas PASS, feedback humano runtime pendente.','Orbe Radiante oito fontes verificadas; revisao DRAFT entregue, aceite visual P02-P08 pendente; Ampulheta/Pulso/herois preservados.').replace('Playtest humano Ampulheta; depois decidir proxima familia de VFX existente, sem regeneracao automatica.','Aceite visual Orbe Radiante P02-P08; depois proposta de admissao. Playtests humanos anteriores preservados.')
cursor.write_text(s+'\n'+block,encoding='utf-8')
print(json.dumps(verification,ensure_ascii=False))
