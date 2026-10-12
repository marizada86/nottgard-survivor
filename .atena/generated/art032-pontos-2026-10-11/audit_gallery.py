"""Read-only image inspection; generate audit/HTML, never modify native pixels."""
from pathlib import Path
import hashlib
import html
from html.parser import HTMLParser
import json
import numpy as np
from PIL import Image
import subprocess

OUT = Path(__file__).resolve().parent
ROOT = OUT.parents[2]
data = json.loads((OUT/'jobs.json').read_text(encoding='utf-8'))
assert data['approval'] == 'APPROVED_PER_PLAN' and data['generated'] == 6
assert not (OUT/'visual-acceptance.json').exists(), 'Do not reopen an accepted lot'

def sha(p): return hashlib.sha256(p.read_bytes()).hexdigest()
for record in data['sources'] + data['style_references']:
    p = Path(record['path'])
    if not p.is_absolute(): p = ROOT/p
    assert sha(p) == record['sha256'], str(p)
for p, expected in json.loads((OUT/'protected-snapshot.json').read_text(encoding='utf-8')).items():
    if '#active_plan_tail' in p:
        actual = hashlib.sha256((ROOT/'.atena/state/plan.yaml').read_text(encoding='utf-8').split('active_plan:',1)[1].encode()).hexdigest()
    else: actual = sha(ROOT/p)
    assert actual == expected, p
records = []
for job in data['jobs'] + data.get('previous_native_versions', []):
    path = ROOT/job['destination']
    assert sha(path) == job['sha256'] == sha(Path(job['original_path']))
    with Image.open(path) as image:
        assert image.mode == 'RGBA' and image.format == 'PNG'
        w,h = image.size
        rgba = np.array(image)
    alpha = rgba[:,:,3]
    ys,xs = np.where(alpha > 8)
    box = [int(xs.min()), int(ys.min()), int(xs.max())+1, int(ys.max())+1]
    margins = [box[0], box[1], w-box[2], h-box[3]]
    border = np.concatenate([alpha[0],alpha[-1],alpha[:,0],alpha[:,-1]])
    checks = {'png_rgba':True, 'square_canvas':w==h, 'native_copy_hash':True, 'transparent_alpha':float(np.mean(alpha==0))>.1, 'margin_10_percent_met':min(margins)>=.1*w, 'no_visible_border_clipping_alpha_above8':int(border.max())<=8}
    selected = job in data['jobs']
    if selected: assert all(checks.values()), (job['code'],checks)
    record = {'code':job['code'],'title':job['title'],'revision':job['revision'],'path':job['destination'],'sha256':job['sha256'],'size':[w,h],'bbox_alpha_above8':box,'margins_px':margins,'minimum_margin_percent':round(100*min(margins)/w,2),'border_max_alpha':int(border.max()),'border_exactly_empty':int(border.max())==0,'checks':checks,'recommended_for_owner_review':selected,'content_state':'DRAFT','human_visual_acceptance':'PENDING','runtime_admission':False,'preview_heights':job['preview_heights']}
    job['audit'] = record
    job['status'] = 'TECHNICALLY_INSPECTED_DRAFT_OWNER_REVIEW_PENDING' if selected else 'PRESERVED_NOT_SELECTED_FRAMING_CORRECTION'
    records.append(record)
data.update({'current_step':'S-004/GALLERY','completed_steps':3,'technical_status':'PASS_WITH_NATIVE_ALPHA_NOTE','owner_visual_acceptance':'PENDING','native_outputs':len(records)})
(OUT/'jobs.json').write_text(json.dumps(data,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
audit = {'plan':data['plan'],'revision':'v01','status':'PASS_WITH_NATIVE_ALPHA_NOTE','content_state':'DRAFT','owner_reply':data['owner_reply'],'approval_mode':'per-plan','review_candidates':6,'native_outputs':len(records),'requested_canvas':[1024,1024],'actual_canvas':[1254,1254],'source_and_reference_hashes':'PASS','previous_accepted_sources_receipts_runtime_plan071':'UNCHANGED_HASH_VERIFIED','native_resizing_cleaning':'NOT_PERFORMED','human_visual_acceptance':'PENDING','records':records,'head':subprocess.check_output(['git','rev-parse','HEAD'],cwd=ROOT).decode().strip(),'notes':['Selected PT02/PT05 have native alpha 1/255 on the border; other four selected have fully empty borders; no source cleaning','Five original v01 versions preserved, superseded only for framing below the 10 percent margin contract','Geometry of throne/inactive stone face/spore and core appearance remains DRAFT, not canonical intent','Slime-core is a collectible event adaptation, not a documented anatomical heart','No game tests, playtest, normalization, integration, canonical promotion, new commit, push or build for this isolated lot','HTML links/metadata checked locally; no browser rendering claim or workaround for known file URL policy block']}
(OUT/'audit.json').write_text(json.dumps(audit,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
notes = {'PT02':'Trono vazio e fúngico; geometria DRAFT.','PT03':'Arco inativo com face central opaca; solução geométrica DRAFT. Marcas abstratas não são texto rúnico canônico.','PT04':'Massa dormente com casulo/olhos; sem ritual, cultistas ou arte nova do chefe.','PT05':'Núcleo verde compacto do evento; forma DRAFT, sem coração anatômico.','PT06':'Unidade fúngica malva experimental; anatomia não fixada na lore.','PT07':'Porção de gosma sem olhos/núcleo; diferenciar do PT05 a 48 px.'}
cards=[]
for rec in records[:6]:
    rel='sources/'+Path(rec['path']).name
    previews=''.join('<div><canvas data-source="%s" data-box=\'%s\' data-height="%d"></canvas><small>%d px de altura visível</small></div>'%(rel,json.dumps(rec['bbox_alpha_above8']),height,height) for height in rec['preview_heights'])
    cards.append('<article><h2>%s %s · %s · DRAFT</h2><a class="native" href="%s"><img src="%s" alt="%s"></a><p>%s</p><div class="samples">%s</div><p class="metrics">1254×1254 RGBA · margem %.2f%% · alfa na borda %d/255</p></article>'%(rec['code'],rec['revision'],html.escape(rec['title']),rel,rel,html.escape(rec['title']),notes[rec['code']],previews,rec['minimum_margin_percent'],rec['border_max_alpha']))
history=' · '.join('<a href="sources/%s">%s %s preservada</a>'%(Path(r['path']).name,r['code'],r['revision']) for r in records[6:])
page='''<!doctype html><html lang="pt-BR"><meta charset="utf-8"><meta name="viewport" content="width=device-width"><title>ART-032 pontos DRAFT</title><style>body{background:#11121b;color:#e4e0d4;font:16px system-ui;max-width:1450px;margin:28px auto;padding:0 22px}h1,h2{color:#d9bd78}p{line-height:1.5}a{color:#a4c9ff}.grid{display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:20px}article{border:1px solid #675842;border-radius:8px;padding:16px;background:#1b1c27}.native{display:flex;height:300px;background:#292b33;background-image:conic-gradient(#383a44 25%,transparent 0 50%,#383a44 0 75%,transparent 0);background-size:20px 20px}.native img{width:100%;height:100%;object-fit:contain}.samples{display:flex;flex-wrap:wrap;align-items:flex-end;gap:22px;min-height:165px;padding:16px;background:#191c28}.samples div{display:flex;flex-direction:column;align-items:center;gap:12px}small,.metrics{color:#b5b5be;font-size:13px}.banner{padding:15px;background:#252231;border-left:4px solid #c3a76f}@media(max-width:1050px){.grid{grid-template-columns:repeat(2,minmax(0,1fr))}}@media(max-width:700px){.grid{grid-template-columns:1fr}}</style><h1>ART-032 / PONTOS / v01</h1><div class="banner"><strong>Seis candidatas DRAFT — revisão visual S-005 pendente.</strong> Continuação da frente proposta aprovada pelo dono; per-plan. Sem CANON, normalização/admissão, integração, novo commit, push ou build.</div><p>PT02 trono v02, PT03 arco v02, PT04 massa v02, PT05 Coração de Limo v01, PT06 esporo v02 e PT07 limo v02. Onze fontes nativas preservadas; candidatas cumprem margem mínima de 10%. PT02/PT05 têm resíduo nativo de alfa 1/255 na borda; demais candidatas têm borda vazia. Geometrias não documentadas continuam hipóteses DRAFT.</p><p>Prancha Godot com doze prévias de leitura: props 80/128px; coletáveis 48/80px. Recorte em memória pela caixa alfa &gt;8, sem mudar pixels nativos nem definir escala runtime. Fontes reais 1254×1254 (pedido 1024×1024). HTML conferido por links/metadados; renderização no navegador não realizada devido ao bloqueio conhecido de file://.</p><a href="review-reading.png"><img src="review-reading.png" style="width:100%;height:auto" alt="Prancha das seis peças em doze prévias"></a><p><a href="jobs.json">Origem/hashes</a> · <a href="audit.json">Auditoria</a> · <a href="prompts.md">Prompts completos</a></p><p id="readiness">Carregando doze prévias…</p><div class="grid">'''+''.join(cards)+'''</div><h2>Histórico de enquadramento</h2><p>'''+history+'''</p><p>Revisar leitura/contraste, trono vazio fúngico, arco inativo e massa dormente; comparar núcleo, esporo e limo a 48px. Aceite por código/revisão. Contraste em mapa, pivôs e tamanhos finais dependem de trabalho futuro.</p><script>const previews=[...document.querySelectorAll('canvas')].map(c=>new Promise((resolve,reject)=>{const im=new Image();im.onload=()=>{const[x,y,x2,y2]=JSON.parse(c.dataset.box),h=+c.dataset.height,w=Math.round((x2-x)/(y2-y)*h);c.width=w;c.height=h;c.style.width=w+'px';c.style.height=h+'px';const ctx=c.getContext('2d');ctx.imageSmoothingEnabled=true;ctx.imageSmoothingQuality='high';ctx.drawImage(im,x,y,x2-x,y2-y,0,0,w,h);c.dataset.ready='true';resolve();};im.onerror=reject;im.src=c.dataset.source;}));Promise.all(previews).then(()=>document.getElementById('readiness').textContent='Doze prévias carregadas.').catch(()=>document.getElementById('readiness').textContent='Falha ao carregar prévias.');</script></html>\n'''
(OUT/'index.html').write_text(page,encoding='utf-8')
class Parser(HTMLParser):
    def __init__(self): super().__init__(); self.links=[]; self.previews=[]
    def handle_starttag(self,tag,attrs):
        attrs=dict(attrs)
        for key in ['src','href','data-source']:
            if key in attrs: self.links.append(attrs[key])
        if tag=='canvas': self.previews.append(attrs)
parser=Parser();parser.feed(page)
assert len(parser.previews)==12
assert sorted(int(c['data-height']) for c in parser.previews)==[48]*3+[80]*6+[128]*3
for link in parser.links:
    if link!='review-reading.png': assert (OUT/link).is_file(), link
print('S-003 PASS: six candidates/eleven natives; alpha/margin/hashes/runtime/prior accepted/PLAN071 verified. Twelve HTML preview records/local links PASS.')
