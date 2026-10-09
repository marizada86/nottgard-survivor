from pathlib import Path
import json,hashlib,re
root=Path(__file__).resolve().parents[4];out=Path(__file__).parent;base=root/'.atena/generated/art-candidates/enemies-pilares/sintese_abissal'
read=lambda p:json.loads(p.read_text(encoding='utf-8-sig'))
gate_path=out/'attack03-pendant-owner-gate-2026-10-08.json';gate=read(gate_path)
assert gate['status']=='PENDING_OWNER_DECISION'
source=base/'sintese_abissal_attack_03_v03.png';assert hashlib.sha256(source.read_bytes()).hexdigest()=='9832f2355974c1e34ed629189ff6cb3f61548f4b0958a136711977b2c8fca20e'
(out/'attack03-pendant-gate-before-approval-2026-10-08.json').write_text(json.dumps(gate,indent=2)+'\n')
approval=dict(date='2026-10-08',plan='PLAN-053',spec='SPEC-121',request_classification='IN_PLAN',gate=gate['id'],status='ACCEPTED_OWNER_EXCEPTION',owner_reply='aprovado, continue',interpretation='Approval of presented attack03v03 candidate and bounded green pendant exception, not authorization for fourth correction.',exception_scope=['attack_03'],version=3,source=source.relative_to(root).as_posix(),sha256=hashlib.sha256(source.read_bytes()).hexdigest(),exception='Small intermediate gold pendant retains one green drop. Exactly three original arms and two main original lamps remain.',preview=gate['preview'],approval_context='Owner replied to final question about accepting the small green pendant in attack03 or authorizing another native correction. Presented candidate approved with continue; no further native generation of attack03.')
approval_path=out/'attack03-pendant-owner-approval-2026-10-08.json';approval_path.write_text(json.dumps(approval,indent=2)+'\n')
gate.update(status='ACCEPTED_OWNER_EXCEPTION',owner_reply=approval['owner_reply'],approval_receipt=approval_path.relative_to(root).as_posix());gate_path.write_text(json.dumps(gate,indent=2)+'\n')
p=base/'frame-selection.json';selection=read(p);selection['attack_03'].update(approval_status='ACCEPTED_OWNER_EXCEPTION',owner_reply=approval['owner_reply'],approval_receipt=approval_path.relative_to(root).as_posix());p.write_text(json.dumps(selection,indent=2)+'\n')
for rel in ['.atena/state/plan.yaml','.atena/state/plan-053-imagens.yaml']:
 p=root/rel;t=p.read_text(encoding='utf-8-sig');t=t.replace('  status: AWAITING_OWNER_DECISION','  status: EXECUTING_CYCLES',1)
 if rel.endswith('/plan.yaml'): t=t.replace('  checkpoint: S-006/PILARES/ATTACK03-DECISION','  checkpoint: S-006/PILARES/INTEGRATION',1)
 else:
  head,block=t.split('pilares_recovery_decision:\n',1)
  block=block.replace('  status: PENDING_OWNER_DECISION','  status: ACCEPTED_OWNER_EXCEPTION',1)
  block+='  owner_reply: aprovado, continue\n  approval_receipt: .atena/generated/pilares-resume/v01/attack03-pendant-owner-approval-2026-10-08.json\n'
  t=head+'pilares_recovery_decision:\n'+block
 t=re.sub(r"  current: '[^\n]+","  current: 'S-006 Pilares: excecao do pequeno pingente attack03v03 aprovada; integrar 26 fontes/5 tiras revisadas.'",t,count=1)
 t=re.sub(r"  next: '[^\n]+","  next: 'Validar runtime/captura/gatilho real e build Pilares; depois reconciliar S-007. Retorno PLAN-071 preservado.'",t,count=1)
 p.write_text(t,encoding='utf-8')
p=root/'.atena/vault/canon/ASSET-APPROVAL-REGISTER-024-pilares-identidade-2026-10-08.md'
p.write_text(p.read_text(encoding='utf-8')+'\n2026-10-08 — Após apresentação da recuperação attack03v03 e pergunta sobre aceitar a pequena gota verde num pingente ou autorizar nova correção, o dono respondeu “aprovado, continue”. Aceite da candidata apresentada, com exceção limitada a attack03v03, SHA2569832f2355974c1e34ed629189ff6cb3f61548f4b0958a136711977b2c8fca20e. Não autoriza quarta versão nem estende a exceção aos outros estados. Três braços originais e dois lampiões principais preservados; sem alegar aprovação humana individual de todos os ciclos. [Recibo da aprovação](../../generated/pilares-resume/v01/attack03-pendant-owner-approval-2026-10-08.json).\n',encoding='utf-8')
p=root/'.atena/evidence/pilares-sintese-abissal-candidate-gate-2026-10-08.md'
p.write_text(p.read_text(encoding='utf-8')+'\n2026-10-08 — Gate resolvido após o registro acima: dono respondeu “aprovado, continue”, aprovando a candidata attack03v03 com exceção limitada ao pequeno pingente verde. [Aprovação contextual](../generated/pilares-resume/v01/attack03-pendant-owner-approval-2026-10-08.json). Integração/validação autorizadas sob PLAN-053 per-plan; status anterior preservado como histórico.\n',encoding='utf-8')
print('Bounded attack03v03 exception accepted by owner; pending gate cleared; per-plan scope and return chain preserved.')

