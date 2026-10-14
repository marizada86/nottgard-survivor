from pathlib import Path
import hashlib,json,shutil
out=Path(__file__).resolve().parent
root=out.parents[2]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
assert not (out/'authorization.json').exists(), 'Already started; do not overwrite backups.'
review=root/'.atena/generated/onda-cortante-review-2026-10-13'
recovery=json.loads((review/'recovery.json').read_text(encoding='utf-8'))
accepted=json.loads((review/'visual-acceptance.json').read_text(encoding='utf-8'))
assert len(accepted['accepted'])==7
for e in recovery['sources']:assert sha(root/e['path'])==e['sha256']
protected={p.relative_to(root).as_posix():sha(p) for d in ['assets','core','ui','data','tests'] for p in (root/d).rglob('*') if p.is_file()}
(out/'protected.json').write_text(json.dumps(protected,indent=2)+'\n',encoding='utf-8')
backup={}
for rel in ['ui/radiant_orb_layer.gd','.atena/state/plan.yaml','.atena/state/plan-053-imagens.yaml','.atena/state/onda-cortante-admission.yaml']:
    dst=out/'backup'/rel;dst.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(root/rel,dst);backup[rel]=sha(dst)
(out/'backup.json').write_text(json.dumps(backup,indent=2)+'\n',encoding='utf-8')
receipt={'revision':'onda-cortante-admission/v01','mode':'per-plan','owner_reply':'1. Por plano — uma aprovação para todo o escopo planejado. (Recomendado)','sources':recovery['sources'],'content_state':'DRAFT','canonical_promotion':False,'scope':'Approved cutting-wave admission: two atlases, own helper, family dispatch in existing layer, calibration, validation/playtest preparation. Battle/data/run/overlay and Both orb helpers/atlases protected; no Git/export.'}
(out/'authorization.json').write_text(json.dumps(receipt,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
for name in ['plan.yaml','plan-053-imagens.yaml','onda-cortante-admission.yaml']:
    p=root/'.atena/state'/name;s=p.read_text(encoding='utf-8')
    if name!='onda-cortante-admission.yaml':prefix,s=s.split('onda_cortante_admission_2026_10_13:',1)
    s=s.replace('mode: unconfigured','mode: per-plan').replace('approval_status: PENDING_OWNER_CHOICE','approval_status: APPROVED_EXPLICITLY').replace('status: PROPOSED_NOT_EXECUTABLE','status: IN_PROGRESS').replace('checkpoint: PLAN_APPROVAL','checkpoint: S-001/DERIVATIVES')
    if name!='onda-cortante-admission.yaml':s=prefix+'onda_cortante_admission_2026_10_13:'+s
    p.write_text(s,encoding='utf-8')
spec=root/'.atena/specs/SPEC-121-retomada-fila-imagens/onda-cortante-admission-v01.md'
with spec.open('a',encoding='utf-8') as f:f.write('\n## Autorização\n\nDono escolheu “1. Por plano — uma aprovação para todo o escopo planejado. (Recomendado)”. Escopo v01 integral aprovado, modo per-plan; trechos anteriores de proposta/unconfigured são históricos. [Recibo](../../generated/onda-cortante-admission-2026-10-13/authorization.json). Sem BLOCKING de aprovação.\n')
prepare=(root/'.atena/generated/orbe-radiante-admission-2026-10-13/prepare.gd').read_text(encoding='utf-8').replace('orbe-radiante','onda-cortante').replace('orbe_radiante','onda_cortante')
(out/'prepare.gd').write_text(prepare,encoding='utf-8')
print('PASS authorization, eight source hashes and backups/protection recorded')
