from pathlib import Path
import json,hashlib,shutil
root=Path(__file__).resolve().parents[3];out=Path(__file__).resolve().parent
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
accept=json.loads((root/'.atena/generated/pulso-resume-2026-10-13/visual-acceptance.json').read_text(encoding='utf-8'))
for e in accept['entries']:assert sha(root/e['path'])==e['sha256']
snapshot={p.relative_to(root).as_posix():sha(p) for d in ['assets','core','ui','data','tests'] for p in (root/d).rglob('*') if p.is_file()}
(out/'protected.json').write_text(json.dumps(snapshot,indent=2)+'\n',encoding='utf-8')
backup={}
for rel in ['ui/run.gd','.atena/state/plan.yaml','.atena/state/plan-053-imagens.yaml','.atena/state/pulso-admission.yaml']:
 dst=out/'backup'/rel;dst.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(root/rel,dst);backup[rel]=sha(dst)
assert not (root/'assets/vfx/pulso_radiante.png').exists() and not (root/'core/radiant_pulse_vfx.gd').exists()
(out/'backup.json').write_text(json.dumps({'existing':backup,'new_paths':['assets/vfx/pulso_radiante.png','core/radiant_pulse_vfx.gd','tests/test_radiant_pulse_vfx.gd']},indent=2)+'\n',encoding='utf-8')
(out/'authorization.json').write_text(json.dumps({'date':'2026-10-13','revision':'pulso-admission/v01','owner_reply':'1. Por plano — uma aprovação para todo o escopo planejado.','scope':'Full pulso-admission/v01 local normalization/admission/verification/playtest preparation','mode':'per-plan','sources':accept['entries'],'canonical_promotion':False,'git_export_publish':False},ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=root/'.atena/state/pulso-admission.yaml';s=p.read_text(encoding='utf-8').replace('status: PROPOSED_PENDING_SCOPE_AND_MODE_APPROVAL','status: EXECUTING_APPROVED').replace('mode: unconfigured','mode: per-plan').replace('checkpoint: GATE/ADMISSION_SCOPE_AND_MODE','checkpoint: S-001/DERIVATIVES_AND_CALIBRATION').replace('executable: false','executable: true').replace('next_objective: Aprovar modo e escopo antes da primeira normalizacao ou escrita de runtime.','next_objective: Preparar atlas, medir raio e conferir luz/pivo/residuos.');s+='authorization: .atena/generated/pulso-admission-2026-10-13/authorization.json\ncurrent_step_position: 1\nremaining_steps_after_current: 3\n';p.write_text(s,encoding='utf-8')
p=root/'.atena/state/plan.yaml';s=p.read_text(encoding='utf-8');s+='''pulso_admission_2026_10_13:
  plan: PLAN-053
  revision: pulso-admission/v01
  classification: IN_PLAN
  state_file: .atena/state/pulso-admission.yaml
  mode: per-plan
  approval_status: APPROVED_EXPLICITLY
  status: EXECUTING
  checkpoint: S-001/DERIVATIVES_AND_CALIBRATION
  content_state: DRAFT
  canonical_promotion: false
  hero_playtest: PENDING_PRESERVED
  return_plan: PLAN-071
  return_checkpoint: B-006/S-011
''';p.write_text(s,encoding='utf-8')
p=root/'.atena/specs/SPEC-121-retomada-fila-imagens/pulso-admission-v01.md';s=p.read_text(encoding='utf-8');s+='\n## Autorização — 2026-10-13\n\nDono escolheu **“1. Por plano — uma aprovação para todo o escopo planejado.”** Modo per-plan e escopo integral aprovados. Pendências de aprovação acima descrevem a proposta anterior; nenhum BLOCKING de aprovação permanece. [Recibo](../../generated/pulso-admission-2026-10-13/authorization.json).\n';p.write_text(s,encoding='utf-8')
print('APPROVED per-plan; sources/backups PASS; S001 active')
