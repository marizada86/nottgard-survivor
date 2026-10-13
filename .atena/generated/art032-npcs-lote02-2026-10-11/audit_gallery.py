"""Read-only source audit and HTML gallery. Native pixels are never edited."""
import hashlib
import html
from html.parser import HTMLParser
import json
from pathlib import Path
import subprocess
import numpy as np
from PIL import Image
OUT = Path(__file__).resolve().parent
ROOT = OUT.parents[2]
data = json.loads((OUT/'jobs.json').read_text(encoding='utf-8'))
assert data['approval'] == 'APPROVED_PER_PLAN' and data['generated'] == 6
visual_receipt_path = OUT/'visual-acceptance.json'
visually_accepted = visual_receipt_path.is_file()
if visually_accepted:
    visual_receipt = json.loads(visual_receipt_path.read_text(encoding='utf-8'))
    assert visual_receipt['status'] == 'APPROVED_EXPLICITLY'
    assert {(j['code'],j['revision'],j['sha256']) for j in data['jobs']} == {(j['code'],j['revision'],j['sha256']) for j in visual_receipt['accepted']}
def sha(p):
    return hashlib.sha256(p.read_bytes()).hexdigest()
snapshot = json.loads((OUT/'protected-snapshot.json').read_text(encoding='utf-8'))
for path,expected in snapshot.items():
    actual = hashlib.sha256((ROOT/'.atena/state/plan.yaml').read_text(encoding='utf-8').split('active_plan:',1)[1].encode()).hexdigest() if '#active_plan_tail' in path else sha(ROOT/path)
    assert actual == expected,path
for ref in data['sources']+data['style_references']:
    p = Path(ref['path'])
    if not p.is_absolute():
        p = ROOT/p
    assert sha(p) == ref['sha256'],p
prior_receipt = json.loads((ROOT/'.atena/generated/art032-npcs-2026-10-11/visual-acceptance.json').read_text(encoding='utf-8'))
for accepted in prior_receipt['accepted']:
    assert sha(ROOT/accepted['path']) == accepted['sha256']
records = []
for job in data['jobs']+data.get('previous_native_versions',[]):
    path = ROOT/job['destination']
    assert sha(path) == job['sha256'] == sha(Path(job['original_path']))
    with Image.open(path) as image:
        assert image.format == 'PNG' and image.mode == 'RGBA'
        w,h = image.size
        alpha = np.array(image)[:,:,3]
    ys,xs = np.where(alpha > 8)
    box = [int(xs.min()),int(ys.min()),int(xs.max())+1,int(ys.max())+1]
    margins = [box[0],box[1],w-box[2],h-box[3]]
    border = np.concatenate([alpha[0],alpha[-1],alpha[:,0],alpha[:,-1]])
    checks = {'png_rgba':True,'square_canvas':w == h,'native_copy_hash':True,'real_transparent_alpha':float(np.mean(alpha == 0)) > .1,'margin_10_percent_met':min(margins) >= .1*w,'no_visible_border_clipping_alpha_above8':int(border.max()) <= 8}
    selected = job in data['jobs']
    if selected:
        assert all(checks.values()), (job['code'],checks)
    record = {'code':job['code'],'title':job['title'],'revision':job['revision'],'path':job['destination'],'sha256':job['sha256'],'size':[w,h],'bbox_alpha_above8':box,'margins_px':margins,'minimum_margin_percent':round(100*min(margins)/w,2),'border_max_alpha':int(border.max()),'border_exactly_empty':int(border.max()) == 0,'checks':checks,'recommended_for_owner_review':selected,'content_state':'DRAFT','human_visual_acceptance':'PENDING','runtime_admission':False,'preview_heights':job['preview_heights']}
    job.update({'audit':record,'status':'TECHNICALLY_INSPECTED_DRAFT_OWNER_REVIEW_PENDING' if selected else 'PRESERVED_NOT_SELECTED_CORRECTION'})
    if visually_accepted and selected:
        record['human_visual_acceptance']='APPROVED_EXPLICITLY'
        job['status']='VISUALLY_ACCEPTED_DRAFT_NOT_ADMITTED'
    records.append(record)
data.update({'technical_status':'PASS_WITH_NATIVE_ALPHA_NOTE','native_candidates':len(records),'owner_visual_acceptance':'PENDING','human_visual_gate':'S-005'})
if visually_accepted:
    data.update({'owner_visual_acceptance':'APPROVED_EXPLICITLY','status':'COMPLETED_VISUALLY_ACCEPTED_DRAFT','current_step':'S-005/OWNER_VISUAL_ACCEPTANCE_RECORDED','completed_steps':5})
(OUT/'jobs.json').write_text(json.dumps(data,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
audit = {'plan':data['plan'],'revision':'v01','content_state':'DRAFT','authorization':data['owner_reply'],'mode':'per-plan','status':'PASS_WITH_NATIVE_ALPHA_NOTE','review_candidates':6,'native_outputs':len(records),'requested_canvas':[1024,1024],'native_canvas_actual':[1254,1254],'image_tool':'built-in image_gen','native_resizing_cleaning':'NOT_PERFORMED','source_reference_hashes':'PASS','prior_four_accepted_source_hashes':'PASS','runtime_assets_code_data_tests':'UNCHANGED_HASH_VERIFIED','plan071_return_chain':'UNCHANGED_HASH_VERIFIED','head':subprocess.check_output(['git','rev-parse','HEAD'],cwd=ROOT).decode().strip(),'human_visual_acceptance':'PENDING','records':records,'notes':['Five selected sources have native alpha 1/255 on borders; Vhaerith has exactly empty borders; no cleaning performed','NP04 v01 preserved, not selected: native margin 4.78%; v02 reframing passes','NP06 v01 preserved, not selected: unintended pointed ear; v02 rounded ear correction','Native candidates displayed and inspected; proposed physiques/costume ornamentation remain DRAFT, not canonical species or sacred symbols','Vhaerith belt pouch/rolled parchment ornament is DRAFT costume detail, not the rune he requested or a granted quest item','Reading previews crop visible bbox alpha >8 in memory only; not final normalized PNGs or runtime captures','No game tests/playtest/build/integration/commit/push for isolated image production']}
if (OUT/'gallery-qa.json').is_file():
    audit.update({'gallery_qa':'gallery-qa.json','reading_preview':'review-reading.png','browser_render_verification':'NOT_ATTEMPTED_KNOWN_FILE_URL_POLICY_BLOCK_FROM_PILOT'})
if visually_accepted:
    audit.update({'human_visual_acceptance':'APPROVED_EXPLICITLY','visual_acceptance_receipt':'visual-acceptance.json'})
(OUT/'audit.json').write_text(json.dumps(audit,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
notes = {'NP04':'Nyxara v02: margem corrigida; figurino/identidade proposta DRAFT.','NP05':'Vaelis v01: trança, bronze e tecido claro diferenciam a outra guia; aparência DRAFT.','NP06':"Graz’zt v02: corrigida a orelha élfica não prevista; pele/traje DRAFT, sem fixar espécie canônica.",'NP07':'Reaper v01: rosto oculto e vara de barqueiro; sem canoa, cenário ou afirmação de morto-vivo.','NP08':'Vhaerith v01: identidade élfica documentada; aparência e adornos DRAFT. Pergaminho no cinto não representa a runa devida; sem jaula incorporada.','NP09':'Mercador v01: papel anônimo, espécie/gênero não definidos; figurino/adornos DRAFT.'}
cards = []
for record in records[:6]:
    rel = 'sources/'+Path(record['path']).name
    canvases = ''.join('<div><canvas data-source="%s" data-box=\'%s\' data-height="%s"></canvas><small>%s px de altura visível</small></div>'%(rel,json.dumps(record['bbox_alpha_above8']),height,height) for height in record['preview_heights'])
    cards.append('<article><h2>%s · %s %s · DRAFT</h2><a class="native" href="%s"><img src="%s" alt="%s"></a><p>%s</p><div class="samples">%s</div><p class="metrics">1254×1254 RGBA · margem %.2f%% · alfa na borda %s/255</p></article>'%(record['code'],html.escape(record['title']),record['revision'],rel,rel,html.escape(record['title']),notes[record['code']],canvases,record['minimum_margin_percent'],record['border_max_alpha']))
history = ''.join('<a href="sources/%s">%s %s preservada</a> · '%(Path(r['path']).name,r['code'],r['revision']) for r in records[6:])
script = '''<script>const previews=[...document.querySelectorAll('canvas')].map(c=>new Promise((resolve,reject)=>{const im=new Image();im.onload=()=>{const[x,y,x2,y2]=JSON.parse(c.dataset.box),h=+c.dataset.height,w=Math.round((x2-x)/(y2-y)*h);c.width=w;c.height=h;c.style.width=w+'px';c.style.height=h+'px';const ctx=c.getContext('2d');ctx.imageSmoothingEnabled=true;ctx.imageSmoothingQuality='high';ctx.drawImage(im,x,y,x2-x,y2-y,0,0,w,h);c.dataset.ready='true';resolve();};im.onerror=reject;im.src=c.dataset.source;}));Promise.all(previews).then(()=>document.getElementById('readiness').textContent='Sete prévias carregadas: seis atores a 80px e Graz’zt também a 128px.').catch(()=>document.getElementById('readiness').textContent='Falha no carregamento das prévias.');</script>'''
page = '''<!doctype html><html lang="pt-BR"><meta charset="utf-8"><meta name="viewport" content="width=device-width"><title>ART-032 lote 02 DRAFT</title><style>body{background:#11121b;color:#e4e0d4;font:16px system-ui;max-width:1450px;margin:28px auto;padding:0 22px}h1,h2{color:#d9bd78}p{line-height:1.5}a{color:#a4c9ff}.grid{display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:20px}article{border:1px solid #675842;border-radius:8px;padding:16px;background:#1b1c27}.native{display:flex;height:300px;background:#292b33;background-image:conic-gradient(#383a44 25%,transparent 0 50%,#383a44 0 75%,transparent 0);background-size:20px 20px}.native img{width:100%;height:100%;object-fit:contain}.samples{display:flex;align-items:flex-end;gap:22px;min-height:165px;padding:16px;background:#191c28}.samples div{display:flex;flex-direction:column;align-items:center;gap:12px}small,.metrics{color:#b5b5be;font-size:13px}.banner{padding:15px;background:#252231;border-left:4px solid #c3a76f}@media(max-width:1050px){.grid{grid-template-columns:repeat(2,minmax(0,1fr))}}@media(max-width:700px){.grid{grid-template-columns:1fr}}</style><h1>ART-032 / LOTE02 / v01</h1><div class="banner"><strong>Seis peças DRAFT, revisão visual S-005 pendente.</strong> Produção aprovada com “Aprovo as seis peças DRAFT”. Sem promoção a CANON, normalização/admissão, integração, commit, push ou build.</div><p>Candidatas: NP04 Nyxara v02, NP05 Vaelis v01, NP06 Graz’zt v02, NP07 Reaper v01, NP08 Vhaerith v01, NP09 mercador v01. Fontes nativas 1254×1254 (pedido 1024×1024), copiadas byte a byte. Margem mínima contratada 10%, cumprida em todas. Cinco fontes têm resíduo nativo de alfa 1/255 na borda; Vhaerith tem borda exatamente transparente. Nenhuma limpeza ou redimensionamento nativo.</p><p>Prévia recorta só em memória a caixa alfa &gt; 8 e desenha o motivo a 80px/128px; não é tamanho runtime final. A política do navegador bloqueia file://, portanto esta galeria foi conferida por links/metadados e por <a href="review-reading.png">prancha estática Godot</a>, sem alegar teste de renderização do HTML. Clique nos PNGs para ver as fontes.</p><a href="review-reading.png"><img src="review-reading.png" style="width:100%;height:auto" alt="Prancha das seis candidatas DRAFT a 80/128 px"></a><p><a href="audit.json">Auditoria</a> · <a href="jobs.json">Origem/hashes</a> · <a href="prompts.md">Prompts completos</a></p><p id="readiness">Carregando prévias…</p><div class="grid">'''+''.join(cards)+'''</div><h2>Histórico preservado</h2><p>'''+history+'''</p><p>Revisar diferenciação de Nyxara/Vaelis, identidade proposta de Graz’zt, leitura do Reaper, Vhaerith e mercador; estilos/câmera e gestos. Aparências/adornos não documentados são hipóteses DRAFT. Aceite visual por revisão tem gate próprio; contrastes sobre mapas e playtest são futuros.</p>'''+script+'''</html>\n'''
if visually_accepted:
    page=page.replace('Seis peças DRAFT, revisão visual S-005 pendente.','Seis peças DRAFT visualmente aprovadas — S-005 concluído (5/5).')
    page=page.replace('<p>Candidatas:','<p>O dono respondeu “'+html.escape(visual_receipt['owner_reply'])+'”. <a href="visual-acceptance.json">Recibo das seis revisões/hashes</a>. As fontes continuam DRAFT.</p><p>Candidatas:')
(OUT/'index.html').write_text(page,encoding='utf-8')
class Parser(HTMLParser):
    def __init__(self):
        super().__init__(); self.links=[]; self.previews=[]
    def handle_starttag(self,tag,attrs):
        attrs=dict(attrs)
        for key in ['src','href','data-source']:
            if key in attrs: self.links.append(attrs[key])
        if tag=='canvas': self.previews.append(attrs)
parser=Parser(); parser.feed(page)
assert len(parser.previews)==7
assert sorted(int(c['data-height']) for c in parser.previews)==[80,80,80,80,80,80,128]
# The Godot reading sheet is produced next; all other links must exist now.
for link in parser.links:
    if link != 'review-reading.png': assert (OUT/link).is_file(),link
print('Native audit PASS with alpha note: six selected/eight preserved; source/runtime/previous accepted/PLAN071 hashes unchanged; seven preview metadata records verified.')
