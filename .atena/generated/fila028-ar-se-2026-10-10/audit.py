from pathlib import Path
from PIL import Image
import numpy as np
import json,hashlib,html,re
base=Path(__file__).parent;root=base.parents[2]
jobs=json.loads((base/'jobs.json').read_text(encoding='utf-8'))
selected_versions={'AR01':'v02','SE01':'v03','SE02':'v03'}
reports=[];cards=[]
for receipt in sorted((base/'receipts').glob('*.json')):
    rec=json.loads(receipt.read_text(encoding='utf-8'));p=root/rec['destination'];im=Image.open(p);a=np.asarray(im.convert('RGB')).astype(int)
    digest=hashlib.sha256(p.read_bytes()).hexdigest()
    assert digest==hashlib.sha256(Path(rec['source']).read_bytes()).hexdigest()
    assert digest==hashlib.sha256((root/rec['native_destination']).read_bytes()).hexdigest()
    for ref in rec['references']:assert hashlib.sha256((root/ref['path']).read_bytes()).hexdigest()==ref['sha256']
    for ref in rec['actual_references']:assert Path(ref).is_file()
    border=np.concatenate([a[0],a[-1],a[:,0],a[:,-1]])
    colors,counts=np.unique(border,axis=0,return_counts=True);bg=colors[counts.argmax()]
    diff=np.max(np.abs(a-bg),axis=2);ys,xs=np.where(diff>35)
    bbox=[int(xs.min()),int(ys.min()),int(xs.max()+1),int(ys.max()+1)]
    height=(bbox[3]-bbox[1])/im.height
    margin=min(bbox[0]/im.width,bbox[1]/im.height,(im.width-bbox[2])/im.width,(im.height-bbox[3])/im.height)
    report=dict(code=rec['code'],version=rec['version'],size=list(im.size),mode=im.mode,sha256=digest,source_copy_hash_pass=True,reference_hash_pass=True,border_dominant_rgb=bg.tolist(),border_max_variation=int(np.max(np.abs(border-bg))),border_target_cyan_max_error=int(np.max(np.abs(border-[0,255,255]))),foreground_bbox_approx=bbox,foreground_height_fraction=round(height,4),margin_fraction_approx=round(margin,4),square=im.width==im.height,selected=rec['version']==selected_versions[rec['code']])
    reports.append(report)
    if report['selected']:
        e=html.escape;file=f'native-sources/{rec["code"]}_{rec["version"]}.png'
        cards.append(f'<article><h2>{rec["code"]} · {e(rec["item"])}</h2><p>DRAFT {rec["version"]} · {im.width}×{im.height} · altura aproximada {height*100:.1f}%</p><a href="{file}"><img class="large" src="{file}" alt="{e(rec["item"])}"></a><div class="sizes"><figure><img width="80" height="80" src="{file}" alt="80px"><figcaption>80 px</figcaption></figure><figure><img width="48" height="48" src="{file}" alt="48px"><figcaption>48 px</figcaption></figure></div><p><a href="receipts/{receipt.name}">Prompt exato e referências</a></p><details><summary>Histórico</summary>'+''.join(f'<a href="native-sources/{q.stem}.png">{q.stem}</a> ' for q in sorted((base/'receipts').glob(rec['code']+'_*.json')))+ '</details></article>')
audit=dict(revision='FILA-028-AR-SE/v01',content_state='DRAFT',tool='built-in imagegen',selection=selected_versions,reports=reports,visual_acceptance='PENDING_OWNER',runtime_admission=False,method='Read-only RGB analysis. Foreground bbox excludes colors within 35 levels of dominant border cyan; glow bounds approximate, not a final mask.',pending=['Owner artistic acceptance and 80/48px readability','Background removal and final export deferred','SE03 requires approved SE02 reference'])
(base/'audit.json').write_text(json.dumps(audit,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
for job in jobs['jobs']:job.update(state='GENERATED_AUDITED_PENDING_VISUAL_ACCEPTANCE',selected_version=selected_versions[job['code']])
jobs['status']='GENERATED_AUDITED_AWAITING_OWNER_REVIEW'
(base/'jobs.json').write_text(json.dumps(jobs,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
page='<!doctype html><html lang="pt-BR"><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>FILA-028 · AR e SE DRAFT</title><style>body{background:#11141c;color:#ebe7df;font:16px system-ui;margin:32px}a{color:#bcccff}main{display:grid;grid-template-columns:repeat(auto-fit,minmax(300px,1fr));gap:24px}article{padding:20px;background:#202431;border:1px solid #454959;border-radius:12px}h2{font-size:20px}img{object-fit:contain;image-rendering:pixelated}.large{width:100%;height:330px}.sizes{display:flex;gap:30px;align-items:center}figure{margin:10px 0}figcaption{font-size:13px}</style><header><h1>Arcanista, Eco e Câmara Selada</h1><p>FILA-028-AR-SE/v01 · DRAFT · aceite visual pendente.</p><p>Compare identidade e leitura a 80/48 px. Fontes inteiras com fundo ciano; sem recorte ou exportação final. Clique para abrir o PNG nativo.</p><p>AR01: estudioso de magia distinto do Curandeiro. SE01: fragmento colecionável sem pedestal. SE02: porta fechada com três selos. Seu aceite da SE02 será necessário para preparar a Câmara Aberta.</p><p><a href="audit.json">Auditoria</a> · <a href="jobs.json">Prompts originais</a></p></header><main>'+''.join(cards)+'</main></html>'
(base/'index.html').write_text(page,encoding='utf-8')
links=re.findall(r'(?:href|src)="([^"]+)"',page);assert all((base/p).is_file() for p in links)
assert len(cards)==3
print(json.dumps(dict(versions=len(reports),links_verified=len(links),selected=[r for r in reports if r['selected']]),ensure_ascii=False))
