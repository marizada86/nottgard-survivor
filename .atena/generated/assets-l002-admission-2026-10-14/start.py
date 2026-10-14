from pathlib import Path
import hashlib,json,shutil
out=Path(__file__).resolve().parent;root=out.parents[2];sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
assert not (out/'authorization.json').exists(),'Pre-execution snapshot already exists'
m=json.loads((out/'selected-sources.json').read_text(encoding='utf-8'));assert len(m['sources'])==42
for e in m['sources']:assert sha(root/e['path'])==e['sha256']
for path in ['.atena/generated/assets-l002-review-2026-10-13/visual-acceptance.json','.atena/generated/sylas-two-frame-correction-2026-10-13/visual-acceptance.json']:assert json.loads((root/path).read_text(encoding='utf-8'))['accepted']
protected={p.relative_to(root).as_posix():sha(p) for d in ['assets','core','ui','data','tests'] for p in (root/d).rglob('*') if p.is_file()};(out/'protected.json').write_text(json.dumps(protected,indent=2)+'\n',encoding='utf-8')
backup={}
for rel in ['core/battle.gd','core/hero_active_vfx.gd','ui/hero_active_vfx.gd','ui/run.gd','.atena/state/plan.yaml','.atena/state/plan-053-imagens.yaml','.atena/state/assets-l002-admission.yaml']:
 p=out/'backup'/rel;p.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(root/rel,p);backup[rel]=sha(p)
(out/'backup.json').write_text(json.dumps(backup,indent=2)+'\n',encoding='utf-8')
s=(out/'backup/core/battle.gd').read_text(encoding='utf-8');method=s[s.index('func use_active('):s.index('func minute()',s.index('func use_active('))]
(out/'baseline_battle.gd').write_text('extends Battle\n\n'+method.rstrip()+'\n',encoding='utf-8')
families=[dict(f,name=Path(f['sources'][0]['path']).parent.name,content_side=248 if f['hero']=='korrak' else 256) for f in m['families']]
(out/'authorization.json').write_text(json.dumps({'revision':'assets-l002-admission/v01','mode':'per-plan','owner_reply':'1. Por plano — uma aprovação para todo o escopo planejado. (Recomendado)','sources':m['sources'],'families':families,'canonical_promotion':False,'git_authorized':False},ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
(out/'.gitignore').write_text('qa-*/\n',encoding='utf-8')
for n in ['assets-l002-admission.yaml','plan.yaml','plan-053-imagens.yaml']:
 p=root/'.atena/state'/n;s=p.read_text(encoding='utf-8')
 if n!='assets-l002-admission.yaml':prefix,s=s.split('assets_l002_admission_2026_10_14:',1)
 s=s.replace('classification: PLAN_CHANGE_REQUEST','classification: IN_PLAN_APPROVED_ADMISSION').replace('mode: unconfigured','mode: per-plan').replace('status: PROPOSED_AWAITING_SCOPE_AND_MODE','status: IN_PROGRESS').replace('approval_status: PENDING','approval_status: APPROVED_EXPLICITLY').replace('checkpoint: PLAN_APPROVAL','checkpoint: S-001/DERIVATIVES')
 if n!='assets-l002-admission.yaml':s=prefix+'assets_l002_admission_2026_10_14:'+s
 p.write_text(s,encoding='utf-8')
p=root/'.atena/specs/SPEC-121-retomada-fila-imagens/assets-l002-admission-v01.md'
with p.open('a',encoding='utf-8') as f:f.write('\n## Autorização\n\nDono selecionou1Porplano para escopo integralv01. Modo per-plan aprovado; menções anteriores a unconfigured são histórico da proposta. [Recibo](../../generated/assets-l002-admission-2026-10-14/authorization.json). BLOCKING de aprovação resolvido.\n')
old=root/'.atena/generated/assets-l001-admission-2026-10-13';s=(old/'prepare.gd').read_text(encoding='utf-8').replace('assets-l001-admission-2026-10-13','assets-l002-admission-2026-10-14').replace('assets-l001-admission/v01','assets-l002-admission/v01').replace('30 normalized sources, five','42 normalized sources, seven')
s=s.replace('small.resize(256,256,Image.INTERPOLATE_LANCZOS)','var side := int(family.content_side)\n\t\t\tvar pad := (256-side)/2\n\t\t\tsmall.resize(side,side,Image.INTERPOLATE_LANCZOS)').replace('for y in 256:','for y in side:').replace('for x in 256:','for x in side:').replace('index*256+x,y,Color','index*256+x+pad,y+pad,Color')
(out/'prepare.gd').write_text(s,encoding='utf-8')
(out/'preview.gd').write_text((old/'preview.gd').read_text(encoding='utf-8').replace('assets-l001-admission-2026-10-13','assets-l002-admission-2026-10-14'),encoding='utf-8')
print('PASS42source hashes, backups, baseline method, authorization and technical Korrak248/256 common inset.')
