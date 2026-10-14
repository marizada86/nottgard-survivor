from pathlib import Path
import hashlib,html,json,os,re,shutil,subprocess
import numpy as np
from PIL import Image
out=Path(__file__).resolve().parent;root=out.parents[2];ref='10bd31c'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
def save(n,v):(out/n).write_text(json.dumps(v,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
def history(path):
 data=subprocess.check_output(['git','show',ref+':'+path],cwd=root);p=out/'provenance'/Path(path).name;p.parent.mkdir(parents=True,exist_ok=True);p.write_bytes(data)
 return json.loads(data.decode('utf-8-sig')) if path.endswith('.json') else data
base='.atena/generated/continuous-draft-2026-10-09/'
audit=history(base+'completion-audit.json');history(base+'jobs.json');history(base+'readiness.json');history(base+'build_review.py')
old='.atena/generated/s007-reconciliation/v01/'
approval=history(old+'h403-owner-approval-2026-10-09.json');history(old+'ms-generation-jobs-2026-10-09.json');history(old+'ms-visual-readiness-2026-10-09.md')
history('.atena/vault/canon/ASSET-APPROVAL-REGISTER-035-vfx-sylas-2026-10-09.md')
jobs=json.loads((out/'provenance/ms-generation-jobs-2026-10-09.json').read_text(encoding='utf-8-sig'))['jobs']
gate=next(j for j in jobs if j['code']=='H403')
entries=[e for e in audit['records'] if int(e['code'][1:-2])>=4];assert len(entries)==42
protected={p.relative_to(root).as_posix():sha(p) for d in ['assets','core','ui','data','tests'] for p in (root/d).rglob('*') if p.is_file()};save('protected.json',protected)
titles={4:'Sylas · Passo pelas Sombras',5:'Kayron · Sobrecarga Mística',6:"Korrak · Impacto de Xar'gath",7:'Leoric · Constelação',8:'Nyrelia · Dominação',9:'Zynara · Suspensão Temporal',10:'Bromnor · Concórdia'}
flags={4:'Histórico: conferir H402 (cauda/alcance) e H406 (resíduo final).',5:'Histórico: conferir fechamento do ciclo e continuidade dos arcos elétricos.',6:'Histórico: chamas com aparência vertical; avaliar contrato top-down.',7:'Conferir oito estrelas, linhas, expansão e dissipação.',8:'Histórico: conferir fechamento do ciclo, rotação e motivo olho/espiral.',9:'Histórico: H906 tem diferença entre canais; conferir resíduos/relógio.',10:'Conferir escudo central, chevrons, expansão e dissipação.'}
sources=[];metrics=[];issues=[]
for e in entries:
 original=Path(e.get('original',gate['original_path'] if e['code']=='H403' else e.get('absolute_path','')))
 dest=root/e['destination'];source=dest if dest.exists() else original
 assert source.is_file() and sha(source)==e['sha256'],(e['code'],source)
 dest.parent.mkdir(parents=True,exist_ok=True)
 if not dest.exists():shutil.copy2(source,dest)
 assert sha(dest)==e['sha256']
 with Image.open(dest) as im:
  rgb=np.array(im.convert('RGB'));lum=rgb.max(axis=2);y,x=np.where(lum>12)
  edge=int(max(lum[0].max(),lum[-1].max(),lum[:,0].max(),lum[:,-1].max()));diff=rgb.max(axis=2).astype(int)-rgb.min(axis=2).astype(int)
  row={'code':e['code'],'dimensions':list(im.size),'mode':im.mode,'edge_max_channel':edge,'channel_difference_max':int(diff.max()),'pixels_difference_gt12':int((diff>12).sum()),'visible_gt12':int(len(x)),'bbox_gt12':[int(x.min()),int(y.min()),int(x.max()+1),int(y.max()+1)]}
  if edge>12:issues.append({'code':e['code'],'kind':'BRIGHT_EDGE','value':edge})
  if diff.max()>12:issues.append({'code':e['code'],'kind':'CHANNEL_DIFFERENCE','max':int(diff.max()),'pixels':int((diff>12).sum())})
  metrics.append(row)
 version=re.search(r'_(v\d+)\.png$',e['destination']).group(1)
 sources.append(dict(code=e['code'],version=version,path=e['destination'],sha256=e['sha256'],archived_original=str(original),group=int(e['code'][1:-2]),acceptance='HISTORICAL_GATE_ACCEPTED' if e['code']=='H403' else 'PENDING_VISUAL_ACCEPTANCE'))
for n in range(4,11):
 history(base+f'H{n}-contact.png');history(base+f'H{n}-preview.gif')
assert sources[2]['sha256']=='d9b23e455cf3b7a83e8e6c10820227b2cb829cb09949ed2b1abeb16bb9aa9919'
save('manifest.json',{'revision':'assets-l002-review/v01','batch':'L-002','source_record_ref':ref,'sources':sources,'historical_gate_acceptance':approval,'new_generation':0,'runtime_admission':False,'canonical_promotion':False})
save('audit.json',{'status':'PASS_EXACT_NATIVE_RECOVERY_VISUAL_FLAGS_PENDING','hashes_verified':42,'rows':metrics,'pixel_flags':issues,'historical_visual_flags':audit['visual_pending'],'source_bytes_unchanged':True})
page='''<!doctype html><html lang="pt-BR"><meta charset="utf-8"><title>L002 · 42 imagens</title><style>body{background:#171c24;color:#eee;font:16px system-ui;margin:24px auto;max-width:1400px;padding:12px}a{color:#acd4ff}h1,h2{color:#edcc8a}.grid{display:grid;grid-template-columns:repeat(6,minmax(100px,1fr));gap:12px}.frame{width:100%}.small{width:96px;height:96px}figure{margin:0}small{overflow-wrap:anywhere;font-size:10px}.motion{width:320px;height:320px}nav{position:sticky;top:0;background:#171c24;padding:12px}section{scroll-margin-top:60px;border-top:1px solid #697283;margin-top:24px;padding-top:12px}.flag{background:#45351b;padding:12px}@media(max-width:900px){.grid{grid-template-columns:repeat(3,1fr)}}</style><h1>L002 · sete sequências / 42 imagens</h1><p>41 fontes DRAFT aguardam aceite; H403v02 possui aceite histórico preservado. Fontes exatas por hash, sem edição/normalização/admissão. Prévias históricas em cadência ilustrativa. As flags destacadas precisam de avaliação, não foram resolvidas por recuperar os arquivos.</p><nav>'''
for n in range(4,11):page+=f'<a href="#H{n}">{html.escape(titles[n])}</a> · '
page+='</nav>'
for n in range(4,11):
 page+=f'<section id="H{n}"><h2>{html.escape(titles[n])}</h2><p class="flag">{html.escape(flags[n])}</p><img class="motion" src="provenance/H{n}-preview.gif"><p><a href="provenance/H{n}-contact.png">Prancha histórica de seis fases</a></p><div class="grid">'
 for e in [e for e in sources if e['group']==n]:
  url=html.escape(os.path.relpath(root/e['path'],out).replace('\\','/'));m=next(m for m in metrics if m['code']==e['code'])
  page+=f'<figure><h3>{e["code"]} {e["version"]}</h3><a href="{url}"><img loading="lazy" class="frame" src="{url}"></a><img loading="lazy" class="small" src="{url}"><p>{e["acceptance"]}</p><small>{e["sha256"]}</small><p>Δ canais máx {m["channel_difference_max"]}; borda {m["edge_max_channel"]}</p></figure>'
 page+='</div></section>'
(out/'index.html').write_text(page,encoding='utf-8')
assert all(sha(root/p)==h for p,h in protected.items())
links=re.findall(r'(?:src|href)="([^"]+)"',page);assert all(link.startswith('#') or (out/link).exists() for link in links)
save('verification.json',{'status':'PASS_RECOVERY_AND_LINKS_VISUAL_REVIEW_PENDING','hashes_verified':42,'runtime_files_unchanged':len(protected),'gallery_links_verified':len(links),'historical_gates_preserved':1,'additional_frames_pending_acceptance':41,'pixel_flags':issues,'new_generation':0,'runtime_admission':False,'canonical_promotion':False,'git_operations':'NONE'})
head=subprocess.check_output(['git','rev-parse','HEAD'],cwd=root,text=True).strip()
save('l001-commit-receipt.json',{'commit':head,'subject':subprocess.check_output(['git','log','-1','--format=%s'],cwd=root,text=True).strip(),'owner_reply':'atena commit e proximo','scope':'L001 local commit and continue L002 review','pushed':False,'merged':False,'content_state':'DRAFT_WITH_HISTORICAL_GATES_PRESERVED','human_playtest_procedure':'NOT_REPORTED'})
print(json.dumps({'status':'PASS','sources':42,'runtime_unchanged':len(protected),'pixel_flags':issues}))
