from pathlib import Path
import json,hashlib,subprocess,sys
r=Path.cwd();b=r/'.atena/generated/continuous-draft-2026-10-09';a=json.loads((b/'completion-audit.json').read_text(encoding='utf-8'));paths=[]
for j in a['records']:
 p=r/j['destination'];assert p.exists();assert hashlib.sha256(p.read_bytes()).hexdigest()==j['sha256'];paths.append(j['destination'])
for who,files in [('erik',['er01-retrato-v01.png','er02-idle-v01.png','er02-idle-v02.png']),('arlindo',['ao01-retrato-v01.png','ao02-idle-v01.png'])]:
 for file in files:
  p='.atena/generated/art-candidates/heroes-novos/'+who+'/'+file;assert (r/p).exists();paths.append(p)
for p in ['.atena/generated/art-candidates/vfx/durvall_ruptura_sombria/durvall_ruptura_sombria_sweep_v01.png','.atena/generated/art-candidates/vfx/brook_guarda_de_lliira/brook_guarda_de_lliira_loop_00_v01.png','.atena/generated/art-candidates/vfx/sylas_passo_pelas_sombras/sylas_passo_pelas_sombras_peak_v01.png']:
 if (r/p).exists():paths.append(p)
paths=sorted(set(paths));payload=dict(action='LOCAL_COMMIT',authorization='atena, commit',classification='IN_PLAN',branch='codex/fila-imagens-continuacao-2026-10-09',scope='Current .atena image-session changes and explicit native candidate files',native_files=len(paths),native_bytes=sum((r/p).stat().st_size for p in paths),runtime_admission=False,push=False,paths=paths)
(b/'local-commit-scope.json').write_text(json.dumps(payload,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
if '--stage' in sys.argv:
 subprocess.run(['git','add','--','.atena'],check=True)
 subprocess.run(['git','add','-f','--',*paths],check=True)
else:print(json.dumps({k:v for k,v in payload.items() if k!='paths'}))
