from pathlib import Path
import json,hashlib,re,os,html
from PIL import Image
import numpy as np
root=Path(__file__).resolve().parents[3];out=Path(__file__).resolve().parent
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
r=json.loads((out/'recovery.json').read_text(encoding='utf-8'))
rows=[]
for e in r['sources']:
 p=root/e['path'];assert sha(p)==e['sha256']
 a=np.array(Image.open(p).convert('RGB')); lum=a.max(axis=2);mask=lum>12;yy,xx=np.where(mask)
 box=[int(xx.min()),int(yy.min()),int(xx.max()+1),int(yy.max()+1)]
 edge=max(int(lum[0,:].max()),int(lum[-1,:].max()),int(lum[:,0].max()),int(lum[:,-1].max()))
 rows.append({'code':e['code'],'version':e['version'],'path':e['path'],'sha256':e['sha256'],'dimensions':[a.shape[1],a.shape[0]],'mode':Image.open(p).mode,'bbox_max_channel_above12':box,'historical_luminance_bbox_above12':e['visible_bbox_above12'],'edge_max_channel':edge,'max_channel_difference':int((a.max(axis=2).astype(int)-a.min(axis=2).astype(int)).max()),'mean_max_channel':float(lum.mean()),'significant_border_clear':edge<=12,'native_bytes_preserved':True})
 assert rows[-1]['dimensions']==[1254,1254] and edge<=12
audit={'result':'PASS_NATIVE_RECOVERY','revision':'pulso-resume/v01','rows':rows,'native_normalized':False,'rgba_editing':False,'black_rgb_exact':'NOT_CLAIMED','pure_grayscale_exact':'NOT_CLAIMED','human_sequence_acceptance':'PENDING','gameplay_tests':'NOT_RUN_RUNTIME_UNCHANGED','visual_inspected_all_six':True}
(out/'audit.json').write_text(json.dumps(audit,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
urls=[os.path.relpath(root/e['path'],out).replace('\\','/') for e in r['sources']]
header='''<!doctype html><html lang="pt-BR"><meta charset="utf-8"><title>Pulso Radiante — seis fases DRAFT</title><style>body{background:#17191f;color:#eee;font:16px system-ui;max-width:1150px;margin:32px auto}h1,h2{color:#e5c178}.grid{display:grid;grid-template-columns:repeat(3,1fr);gap:20px}img.native{width:100%;background:#000}.small{width:96px;height:96px}button,select,input{margin:6px;padding:8px}.player{display:flex;gap:30px;align-items:center}figure{margin:0}small{overflow-wrap:anywhere}</style><h1>Pulso Radiante · retomada v01</h1><p>Seis fontes nativas recuperadas por hash. N03 v01 já aprovado; aceite das demais fases pendente. Sem normalização, integração ou promoção CANON.</p><div class="player"><img id="preview" width="240" height="240"><img id="small" width="96" height="96"><span id="phase"></span></div><button id="play">Pausar / retomar</button><button id="next">Avançar quadro</button><label>Cadência ilustrativa <select id="fps"><option>6</option><option selected>10</option><option>12</option></select> fps</label><p>Prévia one-shot com pausa após os resíduos. Cadência final de jogo ainda não definida/testada. Observe crescimento, centralização aparente, afinamento e dissipação, também a96px.</p><div class="grid">'''
cards=[]
for e,url in zip(r['sources'],urls):
 cards.append(f'<figure><h2>{e["code"]} {e["version"]}</h2><a href="{html.escape(url)}"><img class="native" src="{html.escape(url)}"></a><img class="small" src="{html.escape(url)}"><p>{e["human_acceptance"]}</p><small>{e["sha256"]}</small></figure>')
js='''let running=true,i=0,last=0,hold=0;const frames=FRAMES,codes=CODES;function paint(){document.getElementById('preview').src=frames[i];document.getElementById('small').src=frames[i];document.getElementById('phase').textContent=codes[i]}paint();document.getElementById('play').onclick=()=>running=!running;document.getElementById('next').onclick=()=>{running=false;i=(i+1)%6;paint()};function tick(now){let delay=1000/+document.getElementById('fps').value;if(running&&now-last>=delay){last=now;if(i===5&&hold<8)hold++;else{i=(i+1)%6;hold=0;paint()}}requestAnimationFrame(tick)}requestAnimationFrame(tick);'''.replace('FRAMES',json.dumps(urls)).replace('CODES',json.dumps([e['code']+' '+e['version'] for e in r['sources']]))
(out/'gallery.js').write_text(js,encoding='utf-8')
(out/'index.html').write_text(header+'\n'.join(cards)+'</div><script src="gallery.js"></script></html>',encoding='utf-8')
snap=json.loads((out/'protected.json').read_text(encoding='utf-8'));assert all(sha(root/p)==h for p,h in snap.items())
for path,status in [('.atena/generated/CHATGPT-FILA-022-vfx-projeteis-e-explosoes.md','Reconciliação 2026-10-13: 36/36 geradas segundo registros de 10bd31c; Pulso seis fontes recuperadas por hash neste workspace, N03 aprovado; revisão/admissão pendentes.'),('.atena/generated/CHATGPT-FILA-023-vfx-habilidades-dos-herois.md','Reconciliação 2026-10-13: 60/60 fontes geradas segundo registros de 10bd31c; revisão/normalização/admissão pendentes; recuperação integral das fontes fora desta retomada.')]:
 p=root/path;s=p.read_text(encoding='utf-8');s=re.sub(r'^status:.*$', 'status: '+json.dumps(status,ensure_ascii=False),s,count=1,flags=re.M)
 if 'FILA-022' in path:
  for code,phase,version in [('N01','spark','v03'),('N02','grow','v02'),('N04','hold','v01'),('N05','fade','v01'),('N06','dissipate','v01')]:
   pattern=rf'(#### {code}[^\n]*\n\n)- \[ \] gerada[^\n]*'
   replacement=rf'\1- [x] gerada · [ ] aprovada · candidata: `.atena/generated/art-candidates/vfx/pulso_radiante/pulso_radiante_{phase}_{version}.png` — recuperada por hash em 2026-10-13; aceite visual da sequência pendente.'
   s,n=re.subn(pattern,replacement,s);assert n==1,code
 p.write_text(s,encoding='utf-8')
p=root/'.atena/state/plan-053-imagens.yaml';s=p.read_text(encoding='utf-8');s=s.replace('  checkpoint: DEV-006/S-002','  checkpoint: S-007/VFX/PULSO/OWNER_SEQUENCE_REVIEW',1).replace('  status: SUSPENDED_FOR_GIT_PUBLICATION','  status: PULSO_RECOVERED_PENDING_OWNER_SEQUENCE_REVIEW',1);s=re.sub(r"^  current:.*$", "  current: 'Pulso seis fontes recuperadas; recibo N03 publicado em881f133 confirmado historicamente; revisao humana da sequencia pendente.'",s,count=1,flags=re.M);s=re.sub(r"^  next:.*$", "  next: 'Dono avaliar N01v03,N02v02,N04v01,N05v01,N06v01 com N03v01 aprovado; depois propor admissao. FILA02236/36 e FILA02360/60 geradas no historico, nao regenerar a partir dos contadores antigos.'",s,count=1,flags=re.M);s+='\npulso_resume_2026_10_13:\n  state_file: .atena/state/pulso-resume.yaml\n  recovery: .atena/generated/pulso-resume-2026-10-13/recovery.json\n  historical_generation_counts: {FILA022: 36, FILA023: 60}\n  native_sources_verified_in_this_resume: 6\n  obsolete_counters: Historical blocks below describe previous checkpoints, not current remaining work.\n';p.write_text(s,encoding='utf-8')
for rel in ['.atena/state/pulso-resume.yaml','.atena/state/plan.yaml']:
 p=root/rel;s=p.read_text(encoding='utf-8')
 if rel.endswith('plan.yaml'):
  prefix,tail=s.split('pulso_resume_2026_10_13:',1);tail=tail.replace('status: IN_PROGRESS_REVIEW_RECOVERED_SOURCES','status: REVIEW_DELIVERED_PENDING_OWNER_SEQUENCE_ACCEPTANCE').replace('checkpoint: S-003/REVIEW_SIX_PHASES','checkpoint: S-004/OWNER_SEQUENCE_REVIEW');s=prefix+'pulso_resume_2026_10_13:'+tail
 else:
  s=s.replace('status: IN_PROGRESS_REVIEW_RECOVERED_SOURCES','status: REVIEW_DELIVERED_PENDING_OWNER_SEQUENCE_ACCEPTANCE').replace('checkpoint: S-003/REVIEW_SIX_PHASES','checkpoint: S-004/OWNER_SEQUENCE_REVIEW').replace('current_step_position: 3','current_step_position: 4').replace('completed_steps: 2','completed_steps: 4').replace('remaining_steps_after_current: 1','remaining_steps_after_current: 0').replace('next_objective: Conferir seis fases e preparar galeria e evidencia para revisao humana.','next_objective: Dono avaliar as cinco fases adicionais nas revisoes exatas recuperadas.');s+='gallery: .atena/generated/pulso-resume-2026-10-13/index.html\naudit: .atena/generated/pulso-resume-2026-10-13/audit.json\nnext_execution_authorized: false\n'
 p.write_text(s,encoding='utf-8')
print(json.dumps({'result':'PASS','sources':6,'protected_runtime_files':len(snap),'steps':'4/4','new_generation':0,'owner_review':'PENDING','metrics':rows},ensure_ascii=False,indent=2))
