from pathlib import Path
from PIL import Image
import hashlib,json,html,os
from html.parser import HTMLParser
root=Path(__file__).resolve().parents[3]; base=Path(__file__).parent
data=json.loads((base/'jobs.json').read_text(encoding='utf-8'));reports=[];cards=[]
approved=bool(data.get('approval_register')) and (root/data['approval_register']).is_file()
names={'AL01':'Altar animado','EV01':'Pacto de Sangue','EV02':'Relicário Lacrado','EV03':'Peregrino Ferido','EV04':'Contador de Histórias','EV05':'Carroça Abandonada','EV06':'Pedra do Eclipse'}
notes={'AL01':'Quatro velas na v02; a referência estática mostra três chamas visíveis. A contagem textual de quatro foi usada nesta candidata: aceite de identidade pendente. Grade 3×2 nativa; posição/escala e invariância exata do corpo, montagem, recorte e alfa do corpo ainda precisam verificação.','EV01':'v02 removeu tecido, correntes e adornos; três gotas visíveis e selo angular. Aprovação artística pendente.','EV02':'Cofre lacrado com correntes e ossos, sem luz saindo. Aprovação artística pendente.','EV03':'Um viajante genérico, capa azul-clara, bolsa e marco. Aprovação artística pendente.','EV04':'v02 removeu bolsa e marcas do pergaminho; rosto na sombra e fogueira menor. Aprovação artística pendente.','EV05':'v02 removeu tecido, moedas e garrafa; carroça tombada, caixotes, sacos e lanterna. Aprovação artística pendente.','EV06':'v02 reduziu altura e fragmentação; pedra baixa com aro roxo, ciano ao fundo. Acabamento e proporção precisam aceite artístico.'}
for job in data['records']:
    path=root/job['destination']; raw=path.read_bytes(); source=Path(job['source'])
    digest=hashlib.sha256(raw).hexdigest(); assert digest==hashlib.sha256(source.read_bytes()).hexdigest()
    im=Image.open(path); rgb=im.convert('RGB'); cyan=job['code']=='EV06'
    corners=[rgb.getpixel(p) for p in [(0,0),(im.width-1,0),(0,im.height-1),(im.width-1,im.height-1)]]
    def key(c):
        r,g,b=c
        return g>220 and b>220 and r<80 if cyan else r>220 and b>220 and g<80
    assert all(key(c) for c in corners), job['code']+' corner background mismatch'
    selected=data['selected'][job['code']]==job['version']
    report=dict(code=job['code'],version=job['version'],selected_for_review=selected,sha256=digest,source_copy_matches=True,size=list(im.size),mode=im.mode,corner_rgb=corners,background_family='cyan' if cyan else 'magenta',exact_background_uniformity='NOT_PROVEN',square=im.width==im.height,content_state='DRAFT',human_approval='PENDING',runtime_admission=False,visual_notes=notes[job['code']] if selected else 'Prior version retained; objective correction recorded in subsequent prompt.')
    reports.append(report)
    if approved and selected:
        report['human_approval']='APPROVED_BY_OWNER_2026-10-10'
        report['content_state']='CANON_VISUAL_SOURCE'
        report['visual_notes']=report['visual_notes'].replace('Aprovação artística pendente.','Aceite visual registrado.').replace('aceite de identidade pendente.','aceite de identidade registrado.').replace('Acabamento e proporção precisam aceite artístico.','Acabamento e proporção aceitos visualmente.')
    if selected:
        rel=os.path.relpath(path,base).replace('\\','/'); height=160 if job['code']=='AL01' else 80
        cards.append(f'<article><h2>{job["code"]} — {names[job["code"]]} {job["version"]}</h2><p>{html.escape(report["visual_notes"])}</p><a href="{rel}"><img class="native" src="{rel}" alt="{job["code"]}"></a><p>Prévia em escala reduzida (fonte com fundo, não runtime):</p><img style="height:{height}px;max-width:100%;image-rendering:pixelated" src="{rel}"><p>{im.width}×{im.height}, {im.mode}. <a href="{rel}">Abrir fonte nativa</a></p></article>')
refs=[]
for p in ['assets/interactions/altar_active.png','assets/interactions/loja.png','assets/interactions/doacao.png']:
    refs.append(dict(path=p,sha256=hashlib.sha256((root/p).read_bytes()).hexdigest(),role='AL01 identity authority' if 'altar' in p else 'style anchor',state='EXISTING_PROJECT_REFERENCE'))
result=dict(plan='PLAN-053/SPEC-121',revision='FILA-028/v01',approval_mode='per-plan',selected_pieces=7,native_versions=len(reports),source_hashes_passed=True,references=refs,reports=reports,content_state='DRAFT',runtime_admission=False,pending=['human artistic approval','background removal and exact uniformity','AL01 packing, invariant body and body alpha mask check','80px readability in game context'],checks_scope='Native-file metadata, SHA256, corners, link existence and visual review. No runtime or enjoyment claim.')
(base/'audit.json').write_text(json.dumps(result,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
(base/'index.html').write_text('<!doctype html><html lang="pt-BR"><meta charset="utf-8"><title>FILA-028 — revisão DRAFT</title><style>body{background:#181e27;color:#eee;font:16px system-ui;margin:24px}main{display:grid;grid-template-columns:repeat(auto-fit,minmax(340px,1fr));gap:20px}article{background:#26303d;padding:18px;border-radius:12px}.native{width:100%}a{color:#8bdaff}p{line-height:1.5}</style><h1>FILA-028 — sete candidatas DRAFT v01</h1><p>Geração nativa com imagegen. Fontes e versões anteriores preservadas. Seleção técnica para revisão; aprovação artística pendente. Imagens com fundo de recorte: nenhuma integrada ao jogo. Confira silhueta, cor, identidade do altar e distinção dos eventos.</p><main>'+''.join(cards)+'</main><p><a href="jobs.json">Prompts exatos e versões</a> · <a href="audit.json">Auditoria</a></p></html>',encoding='utf-8')
if approved:
    p=base/'index.html';p.write_text(p.read_text(encoding='utf-8').replace('sete candidatas DRAFT v01','sete fontes com aceite visual CANON').replace('Seleção técnica para revisão; aprovação artística pendente.','Versões selecionadas aceitas pelo dono em 2026-10-10. Montagem e recorte ainda pendentes.'),encoding='utf-8')
    result['content_state']='SELECTED_CANON_PRIOR_VERSIONS_DRAFT'
    result['pending']=[x for x in result['pending'] if x!='human artistic approval']
    result['approval_register']=data['approval_register']
    (base/'audit.json').write_text(json.dumps(result,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
class Links(HTMLParser):
    def handle_starttag(self,tag,attrs):
        for k,v in attrs:
            if k in ('href','src'): assert (base/v).is_file(),v
Links().feed((base/'index.html').read_text(encoding='utf-8'))
assert len(cards)==7 and len(reports)==12
print(json.dumps({'pieces':len(cards),'native_versions':len(reports),'hashes':'PASS','corners':'PASS_BACKGROUND_FAMILY','links':'PASS','human_approval':'SELECTED_APPROVED' if approved else 'PENDING','runtime_admission':False}))
