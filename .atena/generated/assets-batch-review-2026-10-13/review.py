from pathlib import Path
import hashlib,html,json,os,re,shutil,subprocess
from PIL import Image
import numpy as np
out=Path(__file__).resolve().parent
root=out.parents[2]
ref='10bd31c';base='.atena/generated/s007-reconciliation/v01/'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
def blob(path):return subprocess.check_output(['git','show',ref+':'+path],cwd=root)
def save(name,value):(out/name).write_text(json.dumps(value,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
def history(name):
 data=blob(base+name);p=out/'provenance'/name;p.parent.mkdir(parents=True,exist_ok=True);p.write_bytes(data)
 return json.loads(data.decode('utf-8-sig')) if name.endswith('.json') else data
def walk(x):
 if isinstance(x,dict):
  yield x
  for v in x.values():yield from walk(v)
 elif isinstance(x,list):
  for v in x:yield from walk(v)
protected={p.relative_to(root).as_posix():sha(p) for d in ['assets','core','ui','data','tests'] for p in (root/d).rglob('*') if p.is_file()}
save('protected.json',protected)
families=[('Arco Radiante','arco-radiante','arco-radiante-sequence-audit-2026-10-09.json','E03'),('Arco de Fogo','arco-fogo','arco-fogo-sequence-audit-2026-10-09.json','F03'),('Durvall · Ruptura Sombria','durvall','durvall-sequence-native-audit-2026-10-09.json','H103'),('Brook · Guarda de Lliira','brook','brook-sequence-native-audit-2026-10-09.json','H201'),('Maelor · Comunhão','maelor','maelor-sequence-native-audit-2026-10-09.json','H301')]
records=[]
for short in ['ef','fp','mh','hb','bm','ms']:records+=list(walk(history(short+'-generation-jobs-2026-10-09.json')))
native=history('e03-native-result-2026-10-09.json');native['sha256']=sha(Path(native['original_path']));records.append(native)
for name in ['hb-visual-readiness-2026-10-09.md','bm-visual-readiness-2026-10-09.md']:history(name)
for n in ['025-vfx-arco-radiante','026-vfx-arco-fogo','032-vfx-durvall','033-vfx-brook','034-vfx-maelor']:
 path='.atena/vault/canon/ASSET-APPROVAL-REGISTER-'+n+'-2026-10-09.md'
 (out/'provenance'/Path(path).name).write_bytes(blob(path))
all_entries=[];groups=[];issues=[]
for title,key,audit_name,gate in families:
 a=history(audit_name);entries=a.get('sources',a.get('frames'));assert len(entries)==6
 preview=(key+'-review-2026-10-09.gif') if key.startswith('arco') else (key+'-sequence-review-2026-10-09.gif')
 montage=key+'-six-frame-review-2026-10-09.png'
 history(preview);history(montage);approval=history(gate.lower()+'-owner-approval-2026-10-09.json')
 group=[]
 for e in entries:
  dest=root/e['path'];original=next((Path(j['original_path']) for j in records if j.get('sha256')==e['sha256'] and j.get('original_path')),None)
  source=dest if dest.exists() else original
  assert source and source.is_file() and sha(source)==e['sha256'],(e['code'],source)
  dest.parent.mkdir(parents=True,exist_ok=True)
  if not dest.exists():shutil.copy2(source,dest)
  assert sha(dest)==e['sha256']
  with Image.open(dest) as im:
   rgb=np.array(im.convert('RGB'));lum=rgb.max(axis=2);ys,xs=np.where(lum>12)
   edge=int(max(lum[0].max(),lum[-1].max(),lum[:,0].max(),lum[:,-1].max()))
   metric={'native_dimensions':list(im.size),'mode':im.mode,'edge_max_channel':edge,'bbox_gt12':[int(xs.min()),int(ys.min()),int(xs.max()+1),int(ys.max()+1)],'max_channel_difference':int((rgb.max(axis=2).astype(int)-rgb.min(axis=2).astype(int)).max())}
   if edge>12:issues.append({'code':e['code'],'type':'BRIGHT_EDGE_REQUIRES_REVIEW','edge':edge})
  version=re.search(r'_(v\d+)\.png$',e['path']).group(1)
  entry=dict(e,version=version,**metric,archived_original=str(original),native_bytes_preserved=True,acceptance='HISTORICAL_GATE_ACCEPTED' if e['code']==gate else 'PENDING_VISUAL_ACCEPTANCE')
  group.append(entry);all_entries.append(entry)
 groups.append({'title':title,'key':key,'gate':gate,'sources':group,'preview':'provenance/'+preview,'montage':'provenance/'+montage})
assert len(all_entries)==30 and len({e['code'] for e in all_entries})==30
save('manifest.json',{'revision':'assets-batch-review/v01','batch':'L-001','source_record_ref':ref,'families':groups,'sources':all_entries,'new_generation':0,'runtime_admission':False,'canonical_promotion':False})
save('audit.json',{'status':'PASS_EXACT_NATIVE_RECOVERY','hashes_verified':30,'issues':issues,'sources_unchanged':True,'runtime_unchanged':all(sha(root/p)==h for p,h in protected.items()),'metrics':'Read-only RGB max-channel measurements; native black/grayscale not presumed exact. Geometry and runtime pivots deferred.'})
page='''<!doctype html><html lang="pt-BR"><meta charset="utf-8"><title>Lote L-001 · 30 imagens DRAFT</title><style>body{background:#171c24;color:#eee;font:16px system-ui;margin:24px auto;max-width:1400px;padding:12px}a{color:#acd4ff}h1,h2{color:#edcc8a}.grid{display:grid;grid-template-columns:repeat(6,minmax(100px,1fr));gap:12px}.frame{width:100%}.small{width:96px;height:96px}figure{margin:0}small{overflow-wrap:anywhere;font-size:10px}.motion{width:320px;height:320px}nav{position:sticky;top:0;background:#171c24;padding:12px}section{scroll-margin-top:60px;border-top:1px solid #697283;margin-top:24px;padding-top:12px}@media(max-width:900px){.grid{grid-template-columns:repeat(3,1fr)}}</style><h1>L-001 · cinco sequências / 30 imagens</h1><p>Revisão ampliada DRAFT. Cinco gates históricos preservados; 25 fases adicionais aguardam aceite. Nenhuma geração nova, normalização ou admissão. As prévias históricas usam escala/cadência ilustrativas; os links abrem as fontes exatas do manifesto.</p><nav>'''
for g in groups:page+=f'<a href="#{g["key"]}">{html.escape(g["title"])}</a> · '
page+='</nav><p>Revisar expansão, espessura, afinamento/dissipação e leitura96px; Brook/Maelor também fechamento do ciclo. Reprovar somente exceções por código/versão se necessário.</p>'
for g in groups:
 page+=f'<section id="{g["key"]}"><h2>{html.escape(g["title"])}</h2><img class="motion" src="{g["preview"]}"><p>Prévia histórica, não é runtime. Gate preservado: {g["gate"]}. <a href="{g["montage"]}">Prancha histórica</a></p><div class="grid">'
 for e in g['sources']:
  url=html.escape(os.path.relpath(root/e['path'],out).replace('\\','/'))
  page+=f'<figure><h3>{e["code"]} {e["version"]}</h3><a href="{url}"><img loading="lazy" class="frame" src="{url}"></a><img loading="lazy" class="small" src="{url}"><p>{e["acceptance"]}</p><small>{e["sha256"]}</small></figure>'
 page+='</div></section>'
(out/'index.html').write_text(page,encoding='utf-8')
assert all(sha(root/p)==h for p,h in protected.items())
links=re.findall(r'(?:href|src)="([^"]+)"',page)
assert all(link.startswith('#') or (out/link).exists() for link in links)
save('verification.json',{'status':'PASS','hashes_verified':30,'families':5,'historical_gate_acceptances':5,'additional_phases_pending_owner_acceptance':25,'runtime_files_unchanged':len(protected),'gallery_links_verified':len(links),'issues':issues,'native_pixel_edits':0,'new_generation':0,'canonical_promotion':False,'git_operations':'NONE'})
print(json.dumps({'status':'PASS','recovered':30,'groups':5,'runtime_unchanged':len(protected),'issues':issues}))
