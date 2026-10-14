from pathlib import Path
import hashlib,json,shutil,re
out=Path(__file__).resolve().parent
root=out.parents[2]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
assert not (out/'authorization.json').exists(), 'Already started; preserve existing backups and authorization.'
review=root/'.atena/generated/orbe-radiante-review-2026-10-13'
recovery=json.loads((review/'recovery.json').read_text(encoding='utf-8'))
acceptance=json.loads((review/'visual-acceptance.json').read_text(encoding='utf-8'))
assert len(acceptance['accepted'])==7
for e in recovery['sources']:assert sha(root/e['path'])==e['sha256']
protected={p.relative_to(root).as_posix():sha(p) for d in ['assets','core','ui','data','tests'] for p in (root/d).rglob('*') if p.is_file()}
(out/'protected.json').write_text(json.dumps(protected,indent=2)+'\n',encoding='utf-8')
backup={}
for rel in ['ui/run.gd','ui/overlay.gd','core/battle.gd','.atena/state/plan.yaml','.atena/state/plan-053-imagens.yaml','.atena/state/orbe-radiante-admission.yaml']:
    dst=out/'backup'/rel;dst.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(root/rel,dst);backup[rel]=sha(dst)
(out/'backup.json').write_text(json.dumps(backup,indent=2)+'\n',encoding='utf-8')
# A directly loadable pre-change Battle for deterministic parity verification.
baseline='extends Battle\n\n'+re.search(r'(?ms)^func _hero_hit\(.*?(?=^func |\Z)',(root/'core/battle.gd').read_text(encoding='utf-8')).group(0)
(out/'baseline_battle.gd').write_text(baseline,encoding='utf-8')
receipt={'revision':'orbe-radiante-admission/v01','mode':'per-plan','owner_reply':'1. Por plano — uma aprovação para todo o escopo planejado. (Recomendado)','sources':recovery['sources'],'visual_acceptance':str((review/'visual-acceptance.json').relative_to(root)).replace('\\','/'),'content_state':'DRAFT','canonical_promotion':False,'scope':'Approved admission proposal: 2 atlases, visual helper/layer, overlay/run routing, primary hit weapon/kind metadata only, validation and playtest preparation; no Git/export'}
(out/'authorization.json').write_text(json.dumps(receipt,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
for name in ['plan.yaml','plan-053-imagens.yaml','orbe-radiante-admission.yaml']:
    p=root/'.atena/state'/name;s=p.read_text(encoding='utf-8')
    if name!='orbe-radiante-admission.yaml':
        prefix,s=s.split('orbe_radiante_admission_2026_10_13:',1)
    s=s.replace('mode: unconfigured','mode: per-plan').replace('approval_status: PENDING_OWNER_CHOICE','approval_status: APPROVED_EXPLICITLY').replace('status: PROPOSED_NOT_EXECUTABLE','status: IN_PROGRESS').replace('checkpoint: PLAN_APPROVAL','checkpoint: S-001/DERIVATIVES')
    if name!='orbe-radiante-admission.yaml':s=prefix+'orbe_radiante_admission_2026_10_13:'+s
    p.write_text(s,encoding='utf-8')
spec=root/'.atena/specs/SPEC-121-retomada-fila-imagens/orbe-radiante-admission-v01.md'
with spec.open('a',encoding='utf-8') as f:f.write('\n## Autorização\n\nDono escolheu “1. Por plano — uma aprovação para todo o escopo planejado. (Recomendado)”. Escopo v01 integral aprovado, modo per-plan; os trechos de proposta/unconfigured acima descrevem o estado anterior. [Recibo](../../generated/orbe-radiante-admission-2026-10-13/authorization.json). Nenhum BLOCKING de aprovação permanece.\n')
print('PASS authorization, source hashes, protected runtime and backups recorded')
