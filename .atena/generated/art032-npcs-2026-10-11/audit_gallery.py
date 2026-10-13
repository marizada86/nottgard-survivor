"""Read-only native raster audit and browser-only previews; never alters image pixels."""
import hashlib
import html
import json
from pathlib import Path
import subprocess
import numpy as np
from PIL import Image

ROOT = Path(__file__).resolve().parents[3]
OUT = Path(__file__).resolve().parent
data = json.loads((OUT / 'jobs.json').read_text(encoding='utf-8'))
assert data['approval'] == 'APPROVED_PER_PLAN' and len(data['jobs']) == 4
visual_receipt_path = OUT / 'visual-acceptance.json'
visually_accepted = visual_receipt_path.is_file()
if visually_accepted:
    visual_receipt = json.loads(visual_receipt_path.read_text(encoding='utf-8'))
    assert visual_receipt['status'] == 'APPROVED_EXPLICITLY'
    assert {(j['code'], j['revision'], j['sha256']) for j in data['jobs']} == {(j['code'], j['revision'], j['sha256']) for j in visual_receipt['accepted']}
snapshot = json.loads((OUT / 'protected-snapshot.json').read_text(encoding='utf-8'))
def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()
for path, expected in snapshot.items():
    if '#active_plan_tail' in path:
        actual = hashlib.sha256((ROOT / '.atena/state/plan.yaml').read_text(encoding='utf-8').split('active_plan:',1)[1].encode()).hexdigest()
    else:
        actual = sha(ROOT / path)
    assert actual == expected, path
for record in data['sources'] + data['style_references']:
    path = Path(record['path'])
    if not path.is_absolute():
        path = ROOT / path
    assert sha(path) == record['sha256'], record['path']
assert subprocess.check_output(['git','rev-parse','HEAD'],cwd=ROOT).decode().strip() == 'fc5c709f3ef5c4acdc7c5a8a842747b72c7f70ec'
records = []
for job in data['jobs'] + data.get('previous_native_versions',[]):
    path = ROOT / job['destination']
    assert sha(path) == job['sha256'] == sha(Path(job['original_path']))
    with Image.open(path) as image:
        assert image.mode == 'RGBA' and image.format == 'PNG'
        rgba = np.array(image)
        w, h = image.size
    alpha = rgba[:,:,3]
    ys, xs = np.where(alpha > 8)
    bbox = [int(xs.min()),int(ys.min()),int(xs.max())+1,int(ys.max())+1]
    margins = [bbox[0],bbox[1],w-bbox[2],h-bbox[3]]
    border = np.concatenate([alpha[0],alpha[-1],alpha[:,0],alpha[:,-1]])
    bmax = int(border.max())
    selected = job in data['jobs']
    checks = {'png_rgba': True, 'square_canvas': w == h, 'native_copy_hash': True, 'real_transparent_alpha': float(np.mean(alpha == 0)) > .1, 'no_visible_border_clipping_alpha_above8': bmax <= 8, 'requested_margin_10_percent': min(margins) >= .1*w}
    if selected:
        assert all(checks.values()), (job['code'], checks)
    record = {'code':job['code'],'revision':job['revision'],'path':job['destination'],'sha256':job['sha256'],'size':[w,h],'bbox_alpha_above8':bbox,'margins_px':margins,'minimum_margin_percent':round(100*min(margins)/w,2),'border_max_alpha':bmax,'border_exactly_empty':bmax == 0,'border_note':'None' if bmax == 0 else 'Native extremely low alpha residue preserved; alpha 1/255 on border is not visible object clipping. No cleaning performed.','checks':checks,'recommended_for_owner_review':selected,'content_state':'DRAFT','runtime_admission':False,'human_visual_acceptance':'PENDING','inspection':'NATIVE_TECHNICAL_VISUAL_INSPECTION_COMPLETED','preview_heights':job['preview_heights']}
    job.update({'status':'TECHNICALLY_INSPECTED_DRAFT_OWNER_REVIEW_PENDING' if selected else 'PRESERVED_NOT_SELECTED_FOR_MARGIN','audit':record})
    if visually_accepted and selected:
        record['human_visual_acceptance'] = 'APPROVED_EXPLICITLY'
        job['status'] = 'VISUALLY_ACCEPTED_DRAFT_NOT_ADMITTED'
    records.append(record)
data.update({'current_step':'S-004/GALLERY','generated':4,'native_candidates':5,'technical_status':'PASS_WITH_NATIVE_ALPHA_NOTE','owner_visual_acceptance':'PENDING'})
if visually_accepted:
    data.update({'current_step':'S-005/OWNER_VISUAL_ACCEPTANCE_RECORDED','status':'COMPLETED_VISUALLY_ACCEPTED_DRAFT','owner_visual_acceptance':'APPROVED_EXPLICITLY'})
(OUT / 'jobs.json').write_text(json.dumps(data,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
audit = {'plan':data['plan'],'revision':data['revision'],'authorization':data['owner_reply'],'mode':'per-plan','status':'PASS_WITH_NATIVE_ALPHA_NOTE','native_sources':5,'review_candidates':4,'image_tool':'built-in image_gen','native_canvas_actual':[1254,1254],'requested_canvas':[1024,1024],'resizing_or_cleaning_native':'NOT_PERFORMED','protected_runtime_files':len(snapshot)-1,'runtime_assets_code_data_tests':'UNCHANGED_HASH_VERIFIED','plan071_and_return_chain':'UNCHANGED_HASH_VERIFIED','source_reference_hashes':'PASS','head':'fc5c709f3ef5c4acdc7c5a8a842747b72c7f70ec','git_commit_push_build_this_generation':'NONE','records':records,'review_limits':['Physical appearance of Joao and deserter remains DRAFT hypothesis; no canonical promotion','Pixel alpha >8 used only as visible bounding-box proxy; very faint glow may extend beyond it','Browser previews show cropped visible bounding boxes at 48/80px; no PNG normalization or game admission','Technical reading is not human acceptance; no playtest performed']}
if (OUT / 'gallery-qa.json').is_file():
    audit.update({'gallery_qa':'gallery-qa.json','reading_preview':'review-reading.png','browser_render_verification':'NOT_PERFORMED_URL_POLICY_BLOCKED_FILE_PROTOCOL'})
if visually_accepted:
    audit.update({'human_visual_acceptance':'APPROVED_EXPLICITLY','visual_acceptance_receipt':'visual-acceptance.json'})
(OUT / 'audit.json').write_text(json.dumps(audit,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')

titles = {'NP01':'João Barbosa','NP02':'Desertor de Durao','NP03':'Vítima enfeitiçada','PT01':'Estrela do Norte'}
notes = {'NP01':'Papel confirmado no vault; aparência proposta DRAFT. v02 corrige a margem inferior; v01 preservada.','NP02':'Espécie e gênero não definidos; rosto oculto, sem fixar identidade de humano/demônio.','NP03':'Humano adulto debilitado, vestido, vivo; aparência genérica DRAFT.','PT01':'Miragem/ponto de guia; geometria luminosa DRAFT, sem representar o corpo de uma divindade.'}
cards = []
for record in records[:4]:
    rel = Path(record['path']).relative_to(OUT.relative_to(ROOT)).as_posix()
    box = json.dumps(record['bbox_alpha_above8'])
    canvases = ''.join('<div class="sample"><canvas class="preview" data-source="%s" data-box=\'%s\' data-height="%d"></canvas><small>%d px de altura visível</small></div>'%(rel,box,height,height) for height in record['preview_heights'])
    cards.append('<article><h2>%s · %s %s · DRAFT</h2><a href="%s" class="native"><img src="%s" alt="%s" loading="lazy"></a><p>%s</p><div class="samples">%s</div><p class="metrics">Canvas nativo: %d×%d. Margem mínima visível: %.2f%%. Alfa máximo na borda: %d/255.</p></article>'%(record['code'],html.escape(titles[record['code']]),record['revision'],rel,rel,html.escape(titles[record['code']]),notes[record['code']],canvases,*record['size'],record['minimum_margin_percent'],record['border_max_alpha']))
previous = next(r for r in records if not r['recommended_for_owner_review'])
oldrel = Path(previous['path']).relative_to(OUT.relative_to(ROOT)).as_posix()
script = '''<script>const tasks=[...document.querySelectorAll('canvas.preview')].map(c=>new Promise((resolve,reject)=>{const im=new Image();im.onload=()=>{const [x,y,x2,y2]=JSON.parse(c.dataset.box),h=+c.dataset.height,w=Math.round((x2-x)/(y2-y)*h);c.width=w;c.height=h;c.style.width=w+'px';c.style.height=h+'px';const ctx=c.getContext('2d');ctx.imageSmoothingEnabled=true;ctx.imageSmoothingQuality='high';ctx.drawImage(im,x,y,x2-x,y2-y,0,0,w,h);c.dataset.ready='true';resolve();};im.onerror=reject;im.src=c.dataset.source;}));Promise.all(tasks).then(()=>{document.getElementById('readiness').textContent='Cinco prévias carregadas: atores a 80 px; estrela a 48 e 80 px.';document.body.dataset.ready='true';}).catch(()=>document.getElementById('readiness').textContent='Erro ao carregar prévia.');</script>'''
page = '''<!doctype html><html lang="pt-BR"><meta charset="utf-8"><meta name="viewport" content="width=device-width"><title>ART-032 · quatro peças DRAFT</title><style>body{background:#11121b;color:#e4e0d4;font:16px system-ui;max-width:1450px;margin:28px auto;padding:0 22px}h1,h2{color:#d9bd78}p{line-height:1.55}a{color:#a4c9ff}.grid{display:grid;grid-template-columns:repeat(2,minmax(0,1fr));gap:20px}article{border:1px solid #675842;border-radius:9px;padding:18px;background:#1b1c27}.native{display:flex;justify-content:center;height:320px;background-color:#292b33;background-image:conic-gradient(#383a44 25%,transparent 0 50%,#383a44 0 75%,transparent 0);background-size:20px 20px;border-radius:6px}.native img{height:100%;width:100%;object-fit:contain}.samples{display:flex;align-items:flex-end;gap:28px;min-height:120px;padding:15px;background:#191c28}.sample{display:flex;align-items:center;flex-direction:column;gap:12px}small,.metrics{color:#b5b5be;font-size:13px}.tag{color:#ffdd91}.comparison img{height:230px;background:#292b33}.banner{background:#252231;padding:15px;border-left:4px solid #c3a76f}@media(max-width:800px){.grid{grid-template-columns:1fr}}</style><h1>ART-032 / v01 · quatro peças DRAFT</h1><div class="banner"><strong>Revisão visual pendente.</strong> João NP01 v02; desertor NP02 v01; vítima NP03 v01; estrela PT01 v01. Aprovar este plano autorizou produção, não promoveu as imagens a CANON. Sem admissão no jogo, commit, push ou build.</div><p>Fontes originais RGBA preservadas. Canvas nativo real 1254×1254 (pedido 1024×1024). A prévia recorta somente em memória a caixa visível com alfa &gt; 8 e a desenha com suavização do browser; a altura indicada é do motivo, não da margem transparente. Nenhum PNG foi redimensionado ou limpo. Clique na imagem grande para abrir a fonte nativa.</p><p class="tag">NP02/NP03/PT01 têm resíduo nativo de alfa 1/255 na borda. Não é corte do objeto; limpeza/normalização final permanece posterior. João v02 tem borda exatamente transparente.</p><p>A inspeção automatizada desta página no navegador não ocorreu: a política de URLs bloqueou file://. A leitura foi conferida na <a href="review-reading.png">prancha estática renderizada pelo Godot</a>, com os mesmos recortes e alturas. Os links e metadados da galeria foram validados localmente.</p><a href="review-reading.png"><img src="review-reading.png" alt="Prancha de leitura ART-032, DRAFT" style="width:100%;height:auto"></a><p id="readiness">Carregando as prévias…</p><p><a href="audit.json">Auditoria</a> · <a href="jobs.json">Prompts e rastreabilidade</a> · <a href="prompts.md">Prompts completos</a></p><div class="grid">'''+''.join(cards)+'''</div><section class="comparison"><h2>João v01 preservado</h2><p>A v01 manteve 5,58% de margem inferior; a v02 gerada preserva a identidade proposta e amplia a menor margem para 15,15%. A v01 permanece como histórico, sem seleção automática pelo dono.</p><a href="'''+oldrel+'''"><img src="'''+oldrel+'''" alt="João v01 histórico"></a></section><p>Ao revisar: avaliar identidade/traje de João, leitura de resgate do desertor e da vítima, estilo/câmera e leitura da estrela a 48/80 px. Informar código e revisão de qualquer ajuste. O aceite visual tem gate próprio; integração e publicação exigem autorização separada.</p>'''+script+'''</html>\n'''
if visually_accepted:
    page = page.replace('Revisão visual pendente.', 'Revisão visual aprovada pelo dono — S-005 concluído (5/5).')
    page = page.replace('<p>Fontes originais RGBA preservadas.', '<p>O dono respondeu “'+html.escape(visual_receipt['owner_reply'])+'”. As quatro revisões continuam DRAFT, sem CANON ou admissão. <a href="visual-acceptance.json">Recibo do aceite visual</a>.</p><p>Fontes originais RGBA preservadas.')
(OUT / 'index.html').write_text(page,encoding='utf-8')
print('Native audit PASS with alpha note; four DRAFT candidates, five preserved native outputs, five browser previews; protected runtime and PLAN071 hashes unchanged')
