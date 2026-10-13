from pathlib import Path
import json,hashlib,shutil,os,html
root=Path(__file__).resolve().parents[3];out=Path(__file__).resolve().parent
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
m=json.loads((out/'packing.json').read_text(encoding='utf-8'));backups=json.loads((out/'backup-manifest.json').read_text(encoding='utf-8'))
assert m['result']=='PASS' and len(m['records'])==18
for e in m['records']:
 assert sha(root/e['source'])==e['source_sha256'] and sha(root/e['path'])==e['sha256']
 assert sha(root/e['destination'])==backups[e['destination']],e['destination']
for e in m['records']:
 shutil.copy2(root/e['path'],root/e['destination']);assert sha(root/e['destination'])==e['sha256']
for hero in ['arlindo','erik']:
 dst=root/f'assets/heroes/{hero}.png';assert sha(dst)==backups[dst.relative_to(root).as_posix()]
 shutil.copy2(out/f'derivatives/{hero}-static.png',dst)
receipt={'revision':'hero-admission/v01','content_state':'DRAFT_ADMITTED_LOCAL','canonical_promotion':False,'records':m['records'],'stills':{hero:sha(root/f'assets/heroes/{hero}.png') for hero in ['arlindo','erik']},'portraits':'UNCHANGED_BYTES_VISUALLY_APPROVED_V01','result':'LOCAL_FILES_INSTALLED_PENDING_RUNTIME_CHECKS'}
(out/'admission-receipt.json').write_text(json.dumps(receipt,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
head='''<!doctype html><html lang="pt-BR"><meta charset="utf-8"><title>Admissão local dos heróis — DRAFT v01</title><style>body{background:#151a20;color:#eee;font:16px system-ui;max-width:1200px;margin:32px auto}h1,h2{color:#edc180}.grid{display:grid;grid-template-columns:repeat(3,1fr);gap:18px}.strip{width:100%;height:auto;background:#252b33}small{overflow-wrap:anywhere}.preview{height:140px;width:140px;background-repeat:no-repeat;image-rendering:pixelated;background-color:#252b33}article{padding:16px;border:1px solid #444}button{margin:8px;padding:8px}</style><h1>Admissão local — DRAFT v01</h1><p>18 tiras/101 quadros. Padding sem reamostragem; célula 512×512, base448, porte62/64px. Aceite subjetivo de movimento no runtime pendente. Sem CANON.</p><button onclick="running=!running">Pausar / retomar</button><div class="grid">'''
cards=[]
for r in m['records']:
 url=html.escape(os.path.relpath(root/r['path'],out).replace('\\','/'))
 fps=8 if r['animation']=='idle' else 10 if r['animation'].startswith('move') else 9 if r['animation']=='death' else 12
 cards.append(f'<article><h2>{r["code"]} · {r["animation"]}</h2><div class="preview" data-count="{r["count"]}" data-fps="{fps}" data-loop="{str(r["animation"] in ["idle","move_e","move_ne","move_se","move_s","move_n"]).lower()}" style="background-image:url(\'{url}\');background-size:{r["count"]*140}px 140px"></div><p>{r["count"]} quadros · fonte {r["source_sha256"][:12]}</p><img class="strip" src="{url}"><small>{r["destination"]}</small></article>')
tail='''</div><script>let running=true,t=0,last=performance.now();function tick(now){if(running)t+=(now-last)/1000;last=now;document.querySelectorAll('.preview').forEach(e=>{let c=+e.dataset.count,f=Math.floor(t*+e.dataset.fps);f=e.dataset.loop==='true'?f%c:Math.min(f%(c+12),c-1);e.style.backgroundPosition=`${-140*f}px 0`});requestAnimationFrame(tick)}requestAnimationFrame(tick)</script></html>'''
(out/'index.html').write_text(head+'\n'.join(cards)+tail,encoding='utf-8')
p=root/'.atena/state/hero-admission.yaml';s=p.read_text(encoding='utf-8').replace('checkpoint: S-001/DERIVATIVES_AND_BACKUP','checkpoint: S-003/RUNTIME_VERIFICATION').replace('current_step_position: 1','current_step_position: 3').replace('completed_steps: 0','completed_steps: 2').replace('remaining_steps_after_current: 3','remaining_steps_after_current: 1').replace('steps: {S-001: IN_PROGRESS, S-002: NOT_STARTED, S-003: NOT_STARTED, S-004: NOT_STARTED}','steps: {S-001: COMPLETED, S-002: COMPLETED, S-003: IN_PROGRESS, S-004: NOT_STARTED}').replace('next_objective: Preparar 18 atlas e dois estaticos 512x512 por padding sem reamostragem.','next_objective: Importar e validar suite, smoke, capturas e fallback em perfil QA isolado.');s+='packing: .atena/generated/hero-admission-2026-10-13/packing.json\nadmission_receipt: .atena/generated/hero-admission-2026-10-13/admission-receipt.json\n';p.write_text(s,encoding='utf-8')
p=root/'.atena/state/plan.yaml';s=p.read_text(encoding='utf-8');prefix,tail=s.split('hero_admission_2026_10_13:',1);tail=tail.replace('checkpoint: S-001/DERIVATIVES_AND_BACKUP','checkpoint: S-003/RUNTIME_VERIFICATION');p.write_text(prefix+'hero_admission_2026_10_13:'+tail,encoding='utf-8')
print('S001/S002 complete: admitted 18 strips + two stills; sources preserved; S003 active')
