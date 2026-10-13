from pathlib import Path
import json,hashlib,shutil
root=Path(__file__).resolve().parents[3];out=Path(__file__).resolve().parent
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
accept=json.loads((root/'.atena/generated/ampulheta-review-2026-10-13/visual-acceptance.json').read_text(encoding='utf-8'))
for e in accept['entries']:assert sha(root/e['path'])==e['sha256']
snapshot={p.relative_to(root).as_posix():sha(p) for d in ['assets','core','ui','data','tests'] for p in (root/d).rglob('*') if p.is_file()}
(out/'protected.json').write_text(json.dumps(snapshot,indent=2)+'\n',encoding='utf-8')
backup={}
for rel in ['ui/run.gd','.atena/state/plan.yaml','.atena/state/plan-053-imagens.yaml','.atena/state/ampulheta-admission.yaml']:
 dst=out/'backup'/rel;dst.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(root/rel,dst);backup[rel]=sha(dst)
assert not (root/'assets/vfx/ampulheta_silencio.png').exists() and not (root/'core/hourglass_vfx.gd').exists()
(out/'backup.json').write_text(json.dumps({'existing':backup,'new_paths':['assets/vfx/ampulheta_silencio.png','core/hourglass_vfx.gd','tests/test_hourglass_vfx.gd']},indent=2)+'\n',encoding='utf-8')
(out/'authorization.json').write_text(json.dumps({'date':'2026-10-13','revision':'ampulheta-admission/v01','owner_reply':'1. Por plano — uma aprovação para todo o escopo planejado.','scope':'Full ampulheta-admission/v01 local normalization/admission/verification/playtest preparation','mode':'per-plan','sources':accept['entries'],'canonical_promotion':False,'git_export_publish':False},ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=root/'.atena/state/ampulheta-admission.yaml';s=p.read_text(encoding='utf-8').replace('status: PROPOSED_PENDING_SCOPE_AND_MODE_APPROVAL','status: EXECUTING_APPROVED').replace('mode: unconfigured','mode: per-plan').replace('checkpoint: GATE/ADMISSION_SCOPE_AND_MODE','checkpoint: S-001/DERIVATIVES_AND_CALIBRATION').replace('executable: false','executable: true');s+='authorization: .atena/generated/ampulheta-admission-2026-10-13/authorization.json\ncurrent_step_position: 1\nremaining_steps_after_current: 3\nnext_objective: Preparar atlas e medir raio/pivo/motivos/residuos.\n';p.write_text(s,encoding='utf-8')
p=root/'.atena/state/plan.yaml';s=p.read_text(encoding='utf-8');s+='''ampulheta_admission_2026_10_13:
  plan: PLAN-053
  revision: ampulheta-admission/v01
  classification: IN_PLAN
  state_file: .atena/state/ampulheta-admission.yaml
  mode: per-plan
  approval_status: APPROVED_EXPLICITLY
  status: EXECUTING
  checkpoint: S-001/DERIVATIVES_AND_CALIBRATION
  content_state: DRAFT
  canonical_promotion: false
  return_plan: PLAN-071
  return_checkpoint: B-006/S-011
''';p.write_text(s,encoding='utf-8')
p=root/'.atena/specs/SPEC-121-retomada-fila-imagens/ampulheta-admission-v01.md';s=p.read_text(encoding='utf-8');s+='\n## Autorização de execução — 2026-10-13\n\nDono: **“1. Por plano — uma aprovação para todo o escopo planejado.”** Modo per-plan e escopo integral aprovados. Pendências de aprovação na proposta acima são anteriores ao aceite; zero BLOCKING de aprovação agora. [Recibo](../../generated/ampulheta-admission-2026-10-13/authorization.json).\n';p.write_text(s,encoding='utf-8')
prep=(root/'.atena/generated/pulso-admission-2026-10-13/prepare.gd').read_text(encoding='utf-8').replace('pulso-admission-2026-10-13','ampulheta-admission-2026-10-13').replace('pulso_radiante.png','ampulheta_silencio.png').replace('pulso-admission/v01','ampulheta-admission/v01')
(out/'prepare.gd').write_text(prep,encoding='utf-8')
print('APPROVED per-plan; sources/backups PASS; same Godot normalization pipeline prepared; S001 active')
