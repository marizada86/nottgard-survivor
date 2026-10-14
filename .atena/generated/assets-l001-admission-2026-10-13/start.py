from pathlib import Path
import hashlib,json,shutil
out=Path(__file__).resolve().parent;root=out.parents[2]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
manifest=json.loads((root/'.atena/generated/assets-batch-review-2026-10-13/manifest.json').read_text(encoding='utf-8'))
assert not (out/'authorization.json').exists(),'Do not overwrite pre-execution snapshot'
accepted=json.loads((root/'.atena/generated/assets-batch-review-2026-10-13/visual-acceptance.json').read_text(encoding='utf-8'))
assert len(accepted['accepted'])==25
for e in manifest['sources']:assert sha(root/e['path'])==e['sha256']
protected={p.relative_to(root).as_posix():sha(p) for d in ['assets','core','ui','data','tests'] for p in (root/d).rglob('*') if p.is_file()}
(out/'protected.json').write_text(json.dumps(protected,indent=2)+'\n',encoding='utf-8')
backup={}
for rel in ['core/melee_vfx.gd','ui/run.gd','.atena/state/plan.yaml','.atena/state/plan-053-imagens.yaml','.atena/state/assets-l001-admission.yaml']:
 dst=out/'backup'/rel;dst.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(root/rel,dst);backup[rel]=sha(dst)
(out/'backup.json').write_text(json.dumps(backup,indent=2)+'\n',encoding='utf-8')
names=['melee_arco_radiante','melee_arco_fogo','durvall_ruptura_sombria','brook_guarda_de_lliira','maelor_comunhao']
receipt={'revision':'assets-l001-admission/v01','mode':'per-plan','owner_reply':'1. Por plano — uma aprovação para todo o escopo planejado. (Recomendado)','sources':manifest['sources'],'families':[dict(name=n,**g) for n,g in zip(names,manifest['families'])],'content_state':'DRAFT_WITH_HISTORICAL_GATES_PRESERVED','canonical_promotion':False,'git_authorized':False}
(out/'authorization.json').write_text(json.dumps(receipt,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
(out/'.gitignore').write_text('qa-*/\n',encoding='utf-8')
for name in ['assets-l001-admission.yaml','plan.yaml','plan-053-imagens.yaml']:
 p=root/'.atena/state'/name;s=p.read_text(encoding='utf-8')
 if name!='assets-l001-admission.yaml':prefix,s=s.split('assets_l001_admission_2026_10_13:',1)
 s=s.replace('classification: PLAN_CHANGE_REQUEST','classification: IN_PLAN_APPROVED_ADMISSION').replace('mode: unconfigured','mode: per-plan').replace('approval_status: PENDING','approval_status: APPROVED_EXPLICITLY').replace('status: PROPOSED_AWAITING_SCOPE_AND_MODE','status: IN_PROGRESS').replace('checkpoint: PLAN_APPROVAL','checkpoint: S-001/DERIVATIVES')
 if name!='assets-l001-admission.yaml':s=prefix+'assets_l001_admission_2026_10_13:'+s
 p.write_text(s,encoding='utf-8')
p=root/'.atena/specs/SPEC-121-retomada-fila-imagens/assets-l001-admission-v01.md'
with p.open('a',encoding='utf-8') as f:f.write('\n## Autorização\n\nDono selecionou1Porplano para o escopo integralv01. Modo per-plan aprovado; referências anteriores a unconfigured descrevem a proposta histórica. [Recibo](../../generated/assets-l001-admission-2026-10-13/authorization.json). BLOCKING de aprovação resolvido.\n')
print('PASS 30 source hashes; backups and protected runtime; approved per-plan recorded.')
