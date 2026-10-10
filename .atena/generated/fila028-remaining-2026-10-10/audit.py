from pathlib import Path
from PIL import Image
import numpy as np
import json,hashlib,html,re
base=Path(__file__).parent;root=base.parents[2]
jobs=json.loads((base/'jobs.json').read_text(encoding='utf-8'));reports=[];cards=[]
order=[j['code'] for j in jobs['jobs']]
for receipt in sorted((base/'receipts').glob('*.json'),key=lambda p:(order.index(p.stem.split('_')[0]),p.stem)):
    rec=json.loads(receipt.read_text(encoding='utf-8'));p=root/rec['destination'];im=Image.open(p);digest=hashlib.sha256(p.read_bytes()).hexdigest()
    assert digest==hashlib.sha256(Path(rec['source']).read_bytes()).hexdigest()==hashlib.sha256((root/rec['native_destination']).read_bytes()).hexdigest()
    for ref in rec['references']:assert hashlib.sha256((root/ref['path']).read_bytes()).hexdigest()==ref['sha256']
    for ref in rec['actual_references']:assert Path(ref).is_file()
    icon=rec['code'].startswith('I');report=dict(code=rec['code'],version=rec['version'],size=list(im.size),mode=im.mode,sha256=digest,hashes_pass=True,square=im.width==im.height,selected=rec['version']==('v03' if rec['code']=='I01' else 'v02'))
    if icon:
        assert im.mode=='RGBA';alpha=im.getchannel('A');bbox=alpha.point(lambda x:255 if x>8 else 0).getbbox();report['alpha_extrema']=alpha.getextrema();report['native_alpha_pass']=alpha.getextrema()==(0,255)
    else:
        a=np.asarray(im.convert('RGB')).astype(int);border=np.concatenate([a[0],a[-1],a[:,0],a[:,-1]])
        colors,counts=np.unique(border,axis=0,return_counts=True);bg=colors[counts.argmax()];ys,xs=np.where(np.max(np.abs(a-bg),axis=2)>35);bbox=[int(xs.min()),int(ys.min()),int(xs.max()+1),int(ys.max()+1)]
        report.update(border_dominant_rgb=bg.tolist(),border_max_variation=int(np.max(np.abs(border-bg))),border_target_cyan_max_error=int(np.max(np.abs(border-[0,255,255]))))
    margin=min(bbox[0]/im.width,bbox[1]/im.height,(im.width-bbox[2])/im.width,(im.height-bbox[3])/im.height)
    report.update(bbox=bbox,margin_fraction=round(margin,4),foreground_height_fraction=round((bbox[3]-bbox[1])/im.height,4))
    if icon:report['margin_18_percent_pass']=margin>=.18
    reports.append(report)
    if report['selected']:
        e=html.escape;file=f'native-sources/{rec["code"]}_{rec["version"]}.png'
        extra='<p><a href="../fila028-ar-se-2026-10-10/native-sources/SE02_v03.png">Comparar com SE02 aprovada</a></p>' if rec['code']=='SE03' else ''
        cards.append(f'<article><h2>{rec["code"]} · {e(rec["item"])}</h2><p>DRAFT {rec["version"]} · {im.width}×{im.height} · altura aproximada {report["foreground_height_fraction"]*100:.1f}% · margem {margin*100:.1f}%</p><a href="{file}"><img class="large" src="{file}" alt="{e(rec["item"])}"></a><div class="sizes"><figure><img width="80" height="80" src="{file}" alt="80px"><figcaption>80 px</figcaption></figure><figure><img width="48" height="48" src="{file}" alt="48px"><figcaption>48 px</figcaption></figure></div>{extra}<p><a href="receipts/{receipt.name}">Prompt exato e referências</a></p><details><summary>Histórico</summary>'+''.join(f'<a href="native-sources/{q.stem}.png">{q.stem}</a> ' for q in sorted((base/'receipts').glob(rec['code']+'_*.json')))+ '</details></article>')
selected=[r for r in reports if r['selected']]
audit=dict(revision='FILA-028-REMAINING/v01',content_state='DRAFT',tool='built-in imagegen',reports=reports,selected_versions={r['code']:r['version'] for r in selected},visual_acceptance='PENDING_OWNER',runtime_admission=False,method='Icons alpha>8; props RGB difference>35 from dominant border. Prop bounds approximate, not a final mask.',pending=['Owner identity/readability review, chamber pair consistency','Cyan background exact uniformity not assumed; final keying deferred','Final sizes and runtime admission deferred'])
(base/'audit.json').write_text(json.dumps(audit,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
for job in jobs['jobs']:job.update(state='GENERATED_AUDITED_PENDING_VISUAL_ACCEPTANCE',selected_version=('v03' if job['code']=='I01' else 'v02'))
jobs['status']='GENERATED_AUDITED_AWAITING_OWNER_REVIEW';(base/'jobs.json').write_text(json.dumps(jobs,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
page='<!doctype html><html lang="pt-BR"><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>FILA-028 · peças restantes DRAFT</title><style>body{background:#10131b;color:#ece8de;font:16px system-ui;margin:32px}a{color:#bdceff}main{display:grid;grid-template-columns:repeat(auto-fit,minmax(300px,1fr));gap:24px}article{padding:18px;background:#202431;border:1px solid #454959;border-radius:12px}h2{font-size:19px}img{object-fit:contain;image-rendering:pixelated;background:repeating-conic-gradient(#343946 0% 25%,#252935 0% 50%) 50%/16px 16px}.large{width:100%;height:300px}.sizes{display:flex;gap:28px;align-items:center}figure{margin:10px 0}figcaption{font-size:13px}</style><header><h1>FILA-028 · onze peças restantes</h1><p>DRAFT FILA-028-REMAINING/v01 · SE03–SE11 v02, I01 v03 e I02 v02 selecionadas · aceite visual pendente.</p><p>Fontes inteiras com fundo ciano nos props e alfa nas bênçãos, sem exportação final. Compare as oito ruínas por bioma, a Câmara Aberta com SE02 e as bênçãos a 48 px. Clique na fonte para abrir o PNG nativo.</p><p>Fundo ciano pode ter pequenas variações; recorte e preparação ficam para plano próprio. Métricas não substituem sua avaliação visual.</p><p><a href="audit.json">Auditoria</a> · <a href="jobs.json">Prompts originais</a></p></header><main>'+''.join(cards)+'</main></html>'
(base/'index.html').write_text(page,encoding='utf-8');links=re.findall(r'(?:href|src)="([^"]+)"',page);assert all((base/p).is_file() for p in links);assert len(cards)==11
print(json.dumps(dict(versions=len(reports),links_verified=len(links),selected=[{k:r.get(k) for k in ['code','version','foreground_height_fraction','margin_fraction','margin_18_percent_pass','border_target_cyan_max_error']} for r in selected]),ensure_ascii=False))
