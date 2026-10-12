"""Audit native bytes read-only and prepare the comparison gallery; no pixel edits."""
from pathlib import Path
from html.parser import HTMLParser
import hashlib
import html
import json
import os
import numpy as np
from PIL import Image
OUT=Path(__file__).resolve().parent
ROOT=OUT.parents[2]
assert not (OUT/'visual-acceptance.json').exists()
data=json.loads((OUT/'jobs.json').read_text(encoding='utf-8'))
assert data['approval']=='APPROVED_PER_PLAN' and data['generated']==1
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def metrics(p):
    with Image.open(p) as im:
        assert im.format=='PNG' and im.mode=='RGBA'
        w,h=im.size;rgba=np.array(im)
    alpha=rgba[:,:,3];ys,xs=np.where(alpha>8)
    box=[int(xs.min()),int(ys.min()),int(xs.max())+1,int(ys.max())+1]
    margins=[box[0],box[1],w-box[2],h-box[3]]
    border=np.concatenate([alpha[0],alpha[-1],alpha[:,0],alpha[:,-1]])
    return {'size':[w,h],'bbox_alpha_above8':box,'margins_px':margins,'minimum_margin_percent':round(100*min(margins)/max(w,h),2),'visible_extent_percent':[round(100*(box[2]-box[0])/w,2),round(100*(box[3]-box[1])/h,2)],'border_max_alpha':int(border.max()),'border_exactly_empty':int(border.max())==0,'transparent_fraction':float(np.mean(alpha==0))}
for r in data['sources']+data['style_references']+data['comparison_references']:
    p=Path(r['path']);p=p if p.is_absolute() else ROOT/p
    assert sha(p)==r['sha256'],str(p)
for p,expected in json.loads((OUT/'protected-snapshot.json').read_text(encoding='utf-8')).items():
    actual=hashlib.sha256((ROOT/'.atena/state/plan.yaml').read_text(encoding='utf-8').split('active_plan:',1)[1].encode()).hexdigest() if '#active_plan_tail' in p else sha(ROOT/p)
    assert actual==expected,p
records=[]
for j in data['jobs']+data.get('previous_native_versions',[]):
    p=ROOT/j['destination']
    assert sha(p)==j['sha256']==sha(Path(j['original_path']))
    m=metrics(p);w,h=m['size'];box=m['bbox_alpha_above8']
    checks={'png_rgba':True,'square':w==h,'native_copy_hash':True,'transparent_alpha':m['transparent_fraction']>.1,'margin_10_percent_met':min(m['margins_px'])>=.1*w,'extent_at_most_70_percent':max((box[2]-box[0])/w,(box[3]-box[1])/h)<=.7,'no_border_clipping_alpha_above8':m['border_max_alpha']<=8}
    selected=j in data['jobs']
    if selected:assert all(checks.values()),checks
    record={'code':j['code'],'title':j['title'],'revision':j['revision'],'path':j['destination'],'sha256':j['sha256'],**m,'checks':checks,'recommended_for_owner_review':selected,'content_state':'DRAFT','human_visual_acceptance':'PENDING','runtime_admission':False}
    records.append(record);j['audit']=record
    j['status']='TECHNICALLY_INSPECTED_DRAFT_OWNER_REVIEW_PENDING' if selected else 'PRESERVED_NOT_SELECTED_FRAMING_CORRECTION'
candidate=data['jobs'][0]
cards=[]
for title,path,role in [('MJ01 '+candidate['revision'],candidate['destination'],'Candidata DRAFT — aceite pendente'),('Receptáculo de Juiblex','assets/enemies/receptaculo_de_juiblex.png','Referência runtime existente — sem alteração'),('PT04 massa v02',data['comparison_references'][0]['path'],'DRAFT visualmente aceita — estado dormente')]:
    p=ROOT/path
    cards.append({'title':title,'path':path,'gallery_path':Path(os.path.relpath(p,OUT)).as_posix(),'role':role,'sha256':sha(p),'preview_heights':[80,128],**metrics(p)})
data.update({'comparison_cards':cards,'native_outputs':len(records),'technical_status':'PASS','completed_steps':3,'current_step':'S-004/GALLERY','owner_visual_acceptance':'PENDING'})
(OUT/'jobs.json').write_text(json.dumps(data,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
audit={'plan':data['plan'],'revision':'v01','status':'PASS','content_state':'DRAFT','owner_reply':data['owner_reply'],'approval_mode':'per-plan','candidate':'MJ01_v03','native_outputs':3,'requested_canvas':[1024,1024],'actual_canvas':[1254,1254],'records':records,'comparison_cards':cards,'source_and_reference_hashes':'PASS','runtime_prior_sixteen_accepted_sources_receipts_plan071':'UNCHANGED_HASH_VERIFIED','native_resizing_cleaning':'NOT_PERFORMED','human_visual_acceptance':'PENDING','notes':['MJ01 v01 preserved, not selected: margin 4.23%; v02 preserved, not selected: visible width 72.09% exceeds contract; v03 fits 60.53% width and 18.26% margin','Selected v03 has exactly empty native border; v01/v02 residual alpha 1/255 preserved','Geometry remains an authorized DRAFT hypothesis; lobes/vesicles are not asserted as canonical eyes/anatomy','No humanoid legs or exposed central luminous nucleus; three cohesive asymmetric extensions retained; owner assesses proposed silhouette','Reading comparison uses equal visible height in memory only, not world scale or final normalized PNGs','No gameplay/playtest/runtime integration, CANON promotion, commit, push or build']}
(OUT/'audit.json').write_text(json.dumps(audit,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
articles=[]
for c in cards:
    previews=''.join('<div><canvas data-source="%s" data-box=\'%s\' data-height="%d"></canvas><small>%d px de altura visível</small></div>'%(c['gallery_path'],json.dumps(c['bbox_alpha_above8']),height,height) for height in c['preview_heights'])
    articles.append('<article><h2>%s</h2><a class="native" href="%s"><img src="%s" alt="%s"></a><p>%s</p><div class="samples">%s</div><p class="metrics">Fonte %d×%d RGBA</p></article>'%(html.escape(c['title']),c['gallery_path'],c['gallery_path'],html.escape(c['title']),html.escape(c['role']),previews,*c['size']))
history=' · '.join('<a href="sources/%s">MJ01 %s preservada</a>'%(Path(r['path']).name,r['revision']) for r in records[1:])
page='''<!doctype html><html lang="pt-BR"><meta charset="utf-8"><meta name="viewport" content="width=device-width"><title>MJ01 Juiblex DRAFT</title><style>body{background:#11121b;color:#e4e0d4;font:16px system-ui;max-width:1450px;margin:28px auto;padding:0 22px}h1,h2{color:#d9bd78}p{line-height:1.5}a{color:#a4c9ff}.grid{display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:20px}article{border:1px solid #675842;border-radius:8px;padding:16px;background:#1b1c27}.native{display:flex;height:300px;background:#292b33;background-image:conic-gradient(#383a44 25%,transparent 0 50%,#383a44 0 75%,transparent 0);background-size:20px 20px}.native img{width:100%;height:100%;object-fit:contain}.samples{display:flex;flex-direction:column;align-items:center;gap:24px;padding:20px;background:#191c28}.samples div{display:flex;flex-direction:column;align-items:center;gap:12px}small,.metrics{color:#b5b5be;font-size:13px}.banner{padding:15px;background:#252231;border-left:4px solid #c3a76f}@media(max-width:1000px){.grid{grid-template-columns:1fr}}</style><h1>ART-032 / JUIBLEX / v01</h1><div class="banner"><strong>MJ01 v03 DRAFT — revisão visual S-005 pendente.</strong> Produção aprovada com “Aprovo MJ01 DRAFT”, por plano. Sem CANON, normalização/admissão, integração, commit, push ou build.</div><p>Fonte nativa 1254×1254 (pedido 1024×1024), intacta. Margem mínima 18,26%, motivo 60,53% da largura e 48,09% da altura; borda exatamente transparente. Três versões preservadas, correções apenas de enquadramento.</p><p>Comparação a 80/128px de altura visível: MJ01 candidata ativa, receptáculo humanoide existente e massa dormente PT04 v02 já aceita. Não são tamanhos runtime relativos. Geometria proposta é DRAFT, não anatomia canônica. Avalie filamentos, silhueta, material e distinção dos três estados. A prancha Godot é a referência de leitura; HTML conferido por links/metadados, sem alegar renderização no navegador ou contornar bloqueio conhecido de file://.</p><a href="review-reading.png"><img src="review-reading.png" style="width:100%;height:auto" alt="Comparação das três silhuetas a 80/128px"></a><p><a href="jobs.json">Origem/hashes</a> · <a href="audit.json">Auditoria</a> · <a href="prompts.md">Prompts efetivos</a></p><p id="readiness">Carregando seis prévias…</p><div class="grid">'''+''.join(articles)+'''</div><h2>Histórico preservado</h2><p>'''+history+'''</p><p>v01: margem insuficiente. v02: largura visível acima de 70%. Ambas preservadas, não selecionadas. Contraste sobre mapas, animações/pivô e admissão dependem de planos futuros. Aceite visual por revisão tem gate próprio.</p><script>const previews=[...document.querySelectorAll('canvas')].map(c=>new Promise((resolve,reject)=>{const im=new Image();im.onload=()=>{const[x,y,x2,y2]=JSON.parse(c.dataset.box),h=+c.dataset.height,w=Math.round((x2-x)/(y2-y)*h);c.width=w;c.height=h;c.style.width=w+'px';c.style.height=h+'px';const ctx=c.getContext('2d');ctx.imageSmoothingEnabled=true;ctx.imageSmoothingQuality='high';ctx.drawImage(im,x,y,x2-x,y2-y,0,0,w,h);c.dataset.ready='true';resolve();};im.onerror=reject;im.src=c.dataset.source;}));Promise.all(previews).then(()=>document.getElementById('readiness').textContent='Seis prévias comparativas carregadas.').catch(()=>document.getElementById('readiness').textContent='Falha ao carregar prévias.');</script></html>\n'''
(OUT/'index.html').write_text(page,encoding='utf-8')
class Links(HTMLParser):
    def __init__(self):super().__init__();self.links=[];self.previews=[]
    def handle_starttag(self,tag,attrs):
        attrs=dict(attrs)
        for key in ['src','href','data-source']:
            if key in attrs:self.links.append(attrs[key])
        if tag=='canvas':self.previews.append(attrs)
p=Links();p.feed(page)
assert len(p.previews)==6
for target in p.links:
    if target!='review-reading.png':assert (OUT/target).resolve().is_file(),target
print('S-003 PASS: MJ01 v03 native alpha/hash/margin/extent; two historical versions preserved; refs/runtime/previous accepted/PLAN071 unchanged. Six comparison records and HTML links verified.')
