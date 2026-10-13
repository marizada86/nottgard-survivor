from pathlib import Path
import json, hashlib, shutil
root=Path(__file__).resolve().parents[3];out=Path(__file__).resolve().parent
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
manifest=json.loads((root/'.atena/generated/hero-admission-preparation-2026-10-13/admission-manifest.json').read_text(encoding='utf-8'))
for p in manifest['portraits']:
 assert sha(root/p['candidate'])==p['sha256']==sha(root/p['destination'])
receipt={'date':'2026-10-13','revision':'hero-admission/v01','approval_mode':'per-plan','scope_reply':'1. Por plano — uma aprovação para todo o escopo planejado.','portrait_reply':'Aprovo os dois retratos v01','portraits':manifest['portraits'],'content_state':'DRAFT','canonical_promotion':False,'commit_push_merge_export':False}
(out/'authorization.json').write_text(json.dumps(receipt,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
paths=[e['proposed_destination'] for e in manifest['animations']]+[f'assets/heroes/{h}.png' for h in ['arlindo','erik']]+['ui/hero_view.gd','tests/test_animation_assets.gd','tests/test_hero_own_art.gd','.atena/state/plan.yaml','.atena/state/hero-admission-preparation.yaml']
backup={}
for rel in paths:
 p=root/rel;dst=out/'backup'/rel;dst.parent.mkdir(parents=True,exist_ok=True)
 if dst.exists():assert sha(dst)==sha(p)
 else:shutil.copy2(p,dst)
 backup[rel]=sha(dst)
(out/'backup-manifest.json').write_text(json.dumps(backup,indent=2)+'\n',encoding='utf-8')
state='''version: 1
plan: PLAN-053
revision: hero-admission/v01
request_classification: IN_PLAN
content_state: DRAFT
mode: per-plan
approval_status: APPROVED_EXPLICITLY
authorization_receipt: .atena/generated/hero-admission-2026-10-13/authorization.json
status: EXECUTING
checkpoint: S-001/DERIVATIVES_AND_BACKUP
ordered_steps: [S-001, S-002, S-003, S-004]
current_step_position: 1
completed_steps: 0
total_steps: 4
remaining_steps_after_current: 3
steps: {S-001: IN_PROGRESS, S-002: NOT_STARTED, S-003: NOT_STARTED, S-004: NOT_STARTED}
spec: .atena/specs/SPEC-121-retomada-fila-imagens/hero-admission-v01.md
portrait_visual_acceptance: AO01_ER01_V01_APPROVED
canonical_promotion: false
human_runtime_playtest: PENDING
backup_manifest: .atena/generated/hero-admission-2026-10-13/backup-manifest.json
next_objective: Preparar 18 atlas e dois estaticos 512x512 por padding sem reamostragem.
return_plan: {id: PLAN-071, checkpoint: B-006/S-011, preserved: true}
'''
(root/'.atena/state/hero-admission.yaml').write_text(state,encoding='utf-8')
p=root/'.atena/state/hero-admission-preparation.yaml';s=p.read_text(encoding='utf-8').replace('portrait_human_acceptance: PENDING_THIS_CHECKPOINT','portrait_human_acceptance: AO01_ER01_V01_APPROVED').replace('  mode: unconfigured','  mode: per-plan').replace('  status: PENDING_APPROVAL','  status: APPROVED_EXPLICITLY').replace('  executable: false','  executable: true');p.write_text(s,encoding='utf-8')
p=root/'.atena/state/plan.yaml';s=p.read_text(encoding='utf-8');s=s.replace('  admission_mode: unconfigured','  admission_mode: per-plan').replace('  admission_execution_authorized: false','  admission_execution_authorized: true');s+='''hero_admission_2026_10_13:
  plan: PLAN-053
  revision: hero-admission/v01
  state_file: .atena/state/hero-admission.yaml
  mode: per-plan
  status: EXECUTING
  checkpoint: S-001/DERIVATIVES_AND_BACKUP
  approval_receipt: .atena/generated/hero-admission-2026-10-13/authorization.json
  portrait_acceptance: AO01_ER01_V01_APPROVED
  canonical_promotion: false
  return_plan: PLAN-071
  return_checkpoint: B-006/S-011
''';p.write_text(s,encoding='utf-8')
spec=root/'.atena/specs/SPEC-121-retomada-fila-imagens/hero-admission-v01.md';s=spec.read_text(encoding='utf-8');s+='\n## Autorização de execução — 2026-10-13\n\nDono: “Aprovo os dois retratos v01” e “1. Por plano — uma aprovação para todo o escopo planejado.” Modo per-plan aprovado para todo o escopo acima. Gates de escopo/modo e retratos resolvidos; os estados de pendência na proposta original são histórico anterior ao aceite. Nenhum BLOCKING de aprovação permanece. [Recibo](../../generated/hero-admission-2026-10-13/authorization.json). Conteúdo permanece DRAFT, sem promoção CANON.\n';spec.write_text(s,encoding='utf-8')
print('APPROVED per-plan; portraits accepted; backups verified:',len(backup))
