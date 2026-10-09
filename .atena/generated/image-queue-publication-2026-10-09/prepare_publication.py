from pathlib import Path
import json,re,hashlib,subprocess
from datetime import datetime,timezone
root=Path.cwd();out=Path(__file__).parent
read=lambda p:p.read_text(encoding='utf-8-sig')
save=lambda p,d:p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
authorization='atena, commit push e continue'
assert not (out/'publication-plan.json').exists()
for name in ['plan.yaml','plan-053-imagens.yaml']:
 (out/('before-'+name)).write_bytes((root/'.atena/state'/name).read_bytes())
gatep=root/'.atena/generated/s007-reconciliation/v01/r01-owner-gate-2026-10-09.json';gate=json.loads(read(gatep))
assert gate['status']=='PENDING_OWNER_APPROVAL' and gate['version']=='v02' and sha(root/gate['candidate'])==gate['sha256']
approval=root/'.atena/generated/s007-reconciliation/v01/r01-owner-approval-2026-10-09.json'
save(approval,dict(timestamp=datetime.now(timezone.utc).isoformat(),status='APPROVED_CONTEXTUAL_OWNER_REPLY',plan='PLAN-053',spec='SPEC-121',classification='IN_PLAN',frame='R01',version='v02',sha256=gate['sha256'],owner_reply=authorization,context='Reply immediately after question approving R01 v02 to generate remaining seven frames. Continue is interpreted as contextual acceptance of the presented gate, with commit/push first.',scope='R01 v02 visual acceptance and generation R02-R08, then N03 mandatory gate. Publication authorized separately by explicit commit/push request.',runtime_admission=False))
gate.update(status='APPROVED',owner_reply=authorization,approval_receipt=approval.relative_to(root).as_posix());save(gatep,gate)
canon=root/'.atena/vault/canon/ASSET-APPROVAL-REGISTER-029-vfx-onda-cortante-2026-10-09.md';assert not canon.exists()
canon.write_text('# ASSET-APPROVAL-REGISTER-029 — Primeiro voo da onda cortante\n\nEm resposta à pergunta “Aprova R01 v02 para gerar os outros sete quadros?”, o dono pediu “atena, commit push e continue”. O comando de continuação aceita contextualmente R01 v02 apresentada e solicita publicação Git antes da retomada. [Recibo](../../generated/s007-reconciliation/v01/r01-owner-approval-2026-10-09.json), [fonte](../../generated/art-candidates/vfx/onda_cortante/onda_cortante_fly_00_v02.png), SHA256 '+gate['sha256']+'.\n\nPLAN-053/SPEC-121, modo per-plan preservado. Gerar R02–R08 após commit/push; depois devolver N03 pico do pulso radiante ao dono antes dos demais N. Sem aceite fictício de quadros futuros ou admissão runtime dos VFX.\n',encoding='utf-8')
queue=root/'.atena/generated/CHATGPT-FILA-022-vfx-projeteis-e-explosoes.md';t=read(queue)
old='- [x] gerada · [ ] aprovada · candidata: `'+gate['candidate']+'` — gate humano pendente; fonte nativa preservada.';assert old in t
t=t.replace(old,old.replace('[ ] aprovada','[a] aprovada').replace('gate humano pendente','aprovada contextualmente pelo dono em 2026-10-09'));queue.write_text(t,encoding='utf-8')
plan=dict(id='DEV-006-GIT-PUBLICATION-2026-10-09',classification='PLAN_DEVIATION',authorization_verbatim=authorization,route='commit/push now, then return to PLAN-053 images',approval_mode='per-plan',approval_basis='Existing per-plan preference plus explicit commit/push instruction; no new approval request needed.',status='PREPARED',checkpoint='DEV-006/S-001',branch='codex/fila-imagens-2026-10-09',remote='origin',base_commit=subprocess.check_output(['git','rev-parse','HEAD'],text=True).strip(),scope='Runtime art and queue records created since ac14526; existing missing cursor support in separate commit. Sources ignored by .gitignore remain local. No main merge or changes in other worktrees.',acceptance=['manifest202 source hashes valid','Godot import/suite/smoke pass','review staged scope, size and whitespace','create local commits and push named branch without force','verify remote ref equals published commit','resume R02-R08 then N03 gate'],recovery='Local originals preserved; do not reset, clean, force-push or modify another worktree.',return_checkpoint='S-007/VFX/FILA-022/R-REMAINING',ranking_return='PLAN-071 B-006/S-011 preserved')
save(out/'publication-plan.json',plan)
spec=root/'.atena/specs/SPEC-121-retomada-fila-imagens/publication-checkpoint-2026-10-09.md'
spec.write_text('# Checkpoint Git solicitado pelo dono\n\nDEV-006, PLAN_DEVIATION: “'+authorization+'”. Executar commit/push agora e voltar à fila; autorização e preferência per-plan existentes. [Escopo e aceite](../../generated/image-queue-publication-2026-10-09/publication-plan.json). O plano original fica suspenso durante este checkpoint e o retorno ao ranking permanece preservado. Publicar em branch codex/fila-imagens-2026-10-09, sem merge na main. Arte runtime e evidências; fontes ignoradas ficam locais. CursorSkin existente já exigido pelo código recebe commit separado. Checks: manifesto202, import/suite/smoke, escopo staged, hashes/ref remota, retomada R02–R08 e próximo gate N03. Originais não são removidos.\n',encoding='utf-8')
for rel in ['.atena/state/plan.yaml','.atena/state/plan-053-imagens.yaml']:
 p=root/rel;t=read(p)
 t=t.replace('status: AWAITING_OWNER_APPROVAL','status: SUSPENDED_FOR_GIT_PUBLICATION',1)
 t=t.replace('checkpoint: S-007/VFX/FILA-022/R01-APPROVAL','checkpoint: DEV-006/S-001',1)
 t=t.replace('S-007 orbe arcano oito candidatas revisadas; R01 v02 gerada, gate humano pendente. Manifesto202 preservado.','DEV-006 commit/push autorizado; R01 v02 aceita contextualmente; fila suspensa durante publicacao.')
 t=t.replace('Aguardar aprovacao R01 antes dos sete demais R; 79 fontes VFX restantes. Retorno PLAN-071 preservado.','Apos push verificado, retomar R02-R08 e gate N03. Retorno PLAN-071 preservado.')
 if rel.endswith('plan-053-imagens.yaml'):
  t=t.replace('  id: GATE-FILA-022-R01-2026-10-09\n  status: PENDING_OWNER_APPROVAL','  id: GATE-FILA-022-R01-2026-10-09\n  status: APPROVED')
  t=t.replace('  receipt: .atena/generated/s007-reconciliation/v01/r01-owner-gate-2026-10-09.json\n','  receipt: .atena/generated/s007-reconciliation/v01/r01-owner-gate-2026-10-09.json\n  owner_reply: "'+authorization+'"\n  approval_receipt: .atena/generated/s007-reconciliation/v01/r01-owner-approval-2026-10-09.json\n')
 t+='\nimage_git_publication:\n  id: DEV-006\n  status: EXECUTING\n  mode: per-plan\n  checkpoint: DEV-006/S-001\n  authorization: "'+authorization+'"\n  route: publish-now-then-return\n  receipt: .atena/generated/image-queue-publication-2026-10-09/publication-plan.json\n  return_checkpoint: S-007/VFX/FILA-022/R-REMAINING\n'
 p.write_text(t,encoding='utf-8')
m=json.loads(read(root/'.atena/generated/PRIORITY-IMAGES-2026-10-02.json'));assert m['count']==len(m['assets'])==202
for row in m['assets']:assert sha(root/row['path'])==row['sha256'],row['path']
source_checks=0
for directory in ['shendilavri-resume','goranthis-resume','pilares-resume']:
 for p in (root/'.atena/generated'/directory/'v01').glob('*-completion-receipt.json'):
  record=json.loads(read(p))
  for row in record.get('sources',[])+record.get('assets',[]):
   assert sha(root/row['path'])==row['sha256'],row['path'];source_checks+=1
save(out/'source-validation.json',dict(status='PASSED',manifest_assets=202,manifest_sha256=sha(root/'.atena/generated/PRIORITY-IMAGES-2026-10-02.json'),actor_sources_and_assets_verified=source_checks,native_sources_policy='Ignored native candidates remain local according to existing .gitignore. Git replicates runtime art, previews and receipts.'))
print(json.dumps(dict(status='PUBLICATION_PREPARED_R01_CONTEXTUAL_ACCEPTANCE_RECORDED',manifest_assets=202,actor_sources_and_assets_verified=source_checks,return_to='R02-R08 then N03 gate')))
