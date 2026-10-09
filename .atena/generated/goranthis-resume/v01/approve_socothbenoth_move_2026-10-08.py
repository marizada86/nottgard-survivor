from pathlib import Path
import json, hashlib, re
root=Path(__file__).resolve().parents[4];out=Path(__file__).parent
base=root/'.atena/generated/art-candidates/enemies-goranthis/socothbenoth'
gate=json.loads((out/'socothbenoth-move-owner-gate-2026-10-08.json').read_text(encoding='utf-8'))
selection=json.loads((base/'frame-selection.json').read_text(encoding='utf-8'))
frames=[]
for index in [3,4]:
    key=f'move_{index:02}';assert selection[key]['approval_status']=='PENDING_OWNER_DECISION'
    source=base/f'socothbenoth_{key}_v03.png'
    digest=hashlib.sha256(source.read_bytes()).hexdigest()
    assert next(f for f in gate['frames'] if f['index']==index)['sha256']==digest
    frames.append(dict(frame=key,version=3,path=source.relative_to(root).as_posix(),sha256=digest))
    selection[key].update(approval_status='ACCEPTED_OWNER_EXCEPTION',approval_receipt='.atena/generated/goranthis-resume/v01/socothbenoth-move-approval-2026-10-08.json',reason='Owner approved displayed sliding gait with same foreground leg leading; opposite contact not claimed.')
receipt=dict(date='2026-10-08',plan='PLAN-053',spec='SPEC-121',request_classification='IN_PLAN',status='ACCEPTED_OWNER_EXCEPTION',owner_reply='atena, aprovado, continue',question='Aceita esta marcha deslizante como exceção?',scope=['move_03','move_04'],frames=frames,extra_attempts_authorized=False,exception='Sliding gait with same foreground leg leading in move03/04; no claim of clear opposite contact.',preview='.atena/generated/goranthis-resume/v01/socothbenoth_move_owner_preview.gif',gate=gate['gate'])
(out/'socothbenoth-move-approval-2026-10-08.json').write_text(json.dumps(receipt,indent=2)+'\n',encoding='utf-8')
(base/'frame-selection.json').write_text(json.dumps(selection,indent=2)+'\n',encoding='utf-8')
path=root/'.atena/vault/canon/ASSET-APPROVAL-REGISTER-023-goranthis-identidades-2026-10-07.md'
path.write_text(path.read_text(encoding='utf-8')+'\n## Exceção de marcha — Socothbenoth, 2026-10-08\n\nApós a prévia completa e a pergunta “Aceita esta marcha deslizante como exceção?”, o dono respondeu “atena, aprovado, continue”. Exceção aceita somente para move03/04v03: a mesma perna permanece à frente, sem alegar contato oposto claro. Os demais ciclos seguem o escopo per-plan aprovado. Nenhuma quarta tentativa ou extensão a outro ator. [Recibo e hashes](../../generated/goranthis-resume/v01/socothbenoth-move-approval-2026-10-08.json).\n',encoding='utf-8')
for rel in ['.atena/state/plan.yaml','.atena/state/plan-053-imagens.yaml']:
    path=root/rel;t=path.read_text(encoding='utf-8-sig')
    t=t.replace('  status: AWAITING_OWNER_CYCLE_DECISION','  status: EXECUTING_CYCLES',1)
    t=re.sub(r"  current: '[^\n]+","  current: 'S-006 Goranthis: marcha Socothbenoth03-04 aprovada como excecao; integrar cinco ciclos e validar especial real.'",t,count=1)
    t=re.sub(r"  next: '[^\n]+","  next: 'Validar runtime, suite, captura e build Goranthis; depois piloto Pilares com gate de identidade. Retorno PLAN-071 preservado.'",t,count=1)
    if rel.endswith('/plan.yaml'):
        t=t.replace('S-006/GORANTHIS/SOCOTHBENOTH/BEFORE-INTEGRATION','S-006/GORANTHIS/SOCOTHBENOTH/INTEGRATION')
    else:
        old='pending_cycle_decision:\n  id: GATE-SOCOTHBENOTH-MOVE-2026-10-08\n  status: PENDING'
        assert old in t
        t=t.replace(old,'pending_cycle_decision:\n  id: GATE-SOCOTHBENOTH-MOVE-2026-10-08\n  status: ACCEPTED_OWNER_EXCEPTION\n  owner_reply: atena, aprovado, continue\n  approval_receipt: .atena/generated/goranthis-resume/v01/socothbenoth-move-approval-2026-10-08.json')
    path.write_text(t,encoding='utf-8')
print('Owner approval recorded for Socothbenoth move03/04v03 only; checkpoint integration executable.')
