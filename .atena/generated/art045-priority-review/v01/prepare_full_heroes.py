from pathlib import Path
import json,re,hashlib,shutil
r=Path.cwd();source=r/'.atena/generated/art045-priority-review/v01/ART-PROMPTS-060-erik-e-arlindo-jogaveis.md';txt=source.read_text(encoding='utf-8');b=r/'.atena/generated/erik-arlindo-complete-2026-10-09';b.mkdir(exist_ok=True)
shutil.copyfile(r/'.atena/state/dev-024-art045-pilots.yaml',b/'before-scope-extension.yaml')
jobs=[]
for line in txt.splitlines():
 m=re.match(r'\| ((?:ER|AO)\d\d) \| (.*?) \| `([^`]+)` \| (.*?) \|',line)
 if not m:continue
 code,piece,file,request=m.groups()
 if int(code[2:])<3:continue
 hero='erik' if code.startswith('ER') else 'arlindo';frames=4 if code.endswith('08') else 6
 idle='.atena/generated/art-candidates/heroes-novos/'+hero+'/'+('er02-idle-v02.png' if hero=='erik' else 'ao02-idle-v01.png');portrait='.atena/generated/art-candidates/heroes-novos/'+hero+'/'+('er01-retrato-v01.png' if hero=='erik' else 'ao01-retrato-v01.png')
 jobs.append(dict(code=code,hero=hero,piece=piece,request=request,frames=frames,destination='.atena/generated/art-candidates/heroes-novos/'+hero+'/'+file.replace('.png','-v01.png'),references=[str(r/idle),str(r/portrait)],status='PLANNED_DRAFT'))
assert len(jobs)==16
decision=dict(id='DEV-024',revision='v03',classification='PLAN_CHANGE_REQUEST',owner_request='atena, vamos continuar a produção de assets e finalizar erik e arlindo se tiver algo faltando',approval_mode='per-plan',scope='Extend four pilot pieces to all20 FILA027pieces; generate16 missing strips and validate/present as DRAFT',impact={'scope':'16 additional strips, no gameplay changes','decisions':'Keep identities/palette/camera and native references; no canon promotion of unapproved idle','acceptance':'20 native assets present; exact grid/alpha/height/baseline and human review before admission','evidence':'Preserve originals, hashes, prompts, native metrics and previews','recovery':'Previous side-plan state saved; PLAN053 review60 return preserved','checkpoints':'Continuous DRAFT production as requested earlier; no lot/step pauses; runtime gate independent'},runtime_admission=False,dependency_changes=False,reference_authority={'erik':'Approved ER01v01 and ER02v02','arlindo':'Approved AO01v01; AO02v01 DRAFT consistency anchor authorized for experimental production'},sources=[str(source)])
(b/'scope-extension-v03.json').write_text(json.dumps(decision,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
(b/'jobs.json').write_text(json.dumps(dict(plan='DEV-024/v03',state='DRAFT',jobs=jobs,generated=0,remaining=16),ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
state=r/'.atena/state/dev-024-art045-pilots.yaml';t=state.read_text(encoding='utf-8').replace('revision: v01','revision: v03').replace('status: GENERATED_SCOPE_COMPLETE_REVIEW_PENDING','status: EXECUTING_FULL_HERO_DRAFT_SCOPE').replace('checkpoint: S-005/AO02','checkpoint: S-006/ER03');t+='\nfull_scope_extension:\n  approval_mode: per-plan\n  owner_request: "Continuar a produção e finalizar Erik e Arlindo se faltar algo"\n  impact: .atena/generated/erik-arlindo-complete-2026-10-09/scope-extension-v03.json\n  jobs: .atena/generated/erik-arlindo-complete-2026-10-09/jobs.json\n  total_pieces: 20\n  remaining_pieces: 16\n  return_checkpoint: S-007/VFX/FILA-023/REVIEW-60\n';state.write_text(t,encoding='utf-8')
for p in [r/'.atena/state/plan.yaml',r/'.atena/state/plan-053-imagens.yaml']:
 t=p.read_text(encoding='utf-8').replace('checkpoint: S-007/VFX/FILA-023/REVIEW-60','checkpoint: DEV-024/S-006/ER03',1)
 t+='\nhero_full_production_2026_10_09:\n  deviation: DEV-024\n  revision: v03\n  status: EXECUTING\n  mode: per-plan\n  state_file: .atena/state/dev-024-art045-pilots.yaml\n  return_checkpoint: S-007/VFX/FILA-023/REVIEW-60\n  remaining_pieces: 16\n'
 p.write_text(t,encoding='utf-8')
readiness=dict(revision='v03',state='DRAFT',identity='Visible costumes and faces from approved portraits; Erik pre-shaving, no new lore. Arlindo idle remains DRAFT.',scene='Isolated2D isometric hero; five screen directions; attack/active/death faceSE; realalpha no floor or castshadow',authority='ART-PROMPTS060 snapshot; owner request to finishmissingassets; prior continuousdraftmode',references=[dict(path=ref,sha256=hashlib.sha256(Path(ref).read_bytes()).hexdigest()) for ref in dict.fromkeys(ref for j in jobs for ref in j['references'])],blocking_gaps=[],deferred=['Arlindo idle human visual approval','Exact dimension/height/pivot validation','Runtime admission'],audit_limitation='Referenced audit_strip_edges.gd absent in this checkout; use local read-only candidate audit and equivalent alpha edge inspection; do not claim missing check passed')
(b/'visual-readiness-v03.json').write_text(json.dumps(readiness,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
print('16 jobs prepared; scope impact and persistent checkpoint recorded; references hashed.')
