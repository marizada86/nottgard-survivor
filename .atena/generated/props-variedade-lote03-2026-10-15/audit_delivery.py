"""Read-only PNG checks, hashes and review gallery for the eight prop candidates."""
from pathlib import Path
from PIL import Image
from html.parser import HTMLParser
import json,hashlib,html
ROOT=Path(__file__).resolve().parent;REPO=ROOT.parents[2]
jobs=json.loads((ROOT/'jobs.json').read_text(encoding='utf-8'))
audit=[]
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
for job in jobs:
    path=ROOT/job['source']
    with Image.open(path) as im:
        im.load();rgba=im.convert('RGBA');w,h=im.size;alpha=rgba.getchannel('A')
        boxes={str(th):alpha.point(lambda a:255 if a>=th else 0).getbbox() for th in [1,128]}
        box=boxes['128'];margins=[box[0],box[1],w-box[2],h-box[3]]
        edges=alpha.crop((0,0,w,1)).tobytes()+alpha.crop((0,h-1,w,h)).tobytes()+alpha.crop((0,0,1,h)).tobytes()+alpha.crop((w-1,0,w,h)).tobytes()
        alpha_range=alpha.getextrema()
    reference=REPO/job['reference'];archived=ROOT/'references'/f"{job['id']}.png"
    copy=REPO/job['candidate_copy']
    checks=[]
    for size in [64,128,256]:
        p=ROOT/'previews'/f"{job['id']}-{size}.png"
        with Image.open(p) as im:
            im.load();bounds=im.convert('RGBA').getchannel('A').getbbox()
            checks.append(dict(size=size,dimensions=list(im.size),nonzero_alpha_bounds=bounds,
                decoded=True,sha256=sha(p)))
    audit.append(dict(id=job['id'],name=job['name'],biome=job['biome'],content_state='DRAFT',
        dimensions=[w,h],alpha_range=alpha_range,alpha_boxes=boxes,alpha128_margins=margins,
        native_12percent_margin_pass=min(margins)>=.12*min(w,h),
        opaque_outer_edge_pixels=sum(v>=128 for v in edges),source_sha256=sha(path),prompt_sha256=sha(ROOT/job['prompt']),
        reference_sha256=sha(reference),archived_reference_identical=sha(reference)==sha(archived),
        candidate_copy_identical=(sha(copy)==sha(path) if copy.exists() else None),previews=checks,
        owner_visual_acceptance='PENDING',world_scale_and_anchor='NOT_TESTED',runtime_admission=False))

cards=[]
for item,job in zip(audit,jobs):
    code=item['id'];name=item['name'];biome=job['biome']
    note=('Margem nativa de12% atendida no limite alfa≥128.' if item['native_12percent_margin_pass'] else 'Margem nativa menor que12% em ao menos um lado; sem corrigir a fonte. Prévia técnica inclui margem.')
    if code=='PV18':note+=' Cogumelos vieram abertos, em vez dos brotos fechados pedidos.'
    if code=='PV20':note+=' RESSALVA: caveira acrescentada no topo da moldura; precisa de decisao visual explicita. Centro com residuo alfa de ate1/255 medido em11x11px, sem limpeza da fonte.'
    if code in ['PV17','PV19','PV22','PV23']:note+=' Fluido/energia pintados no sprite nao provam animacao ou translucidez material no jogo.'
    cards.append(f'''<article><h2>{code} · {html.escape(name)} · {biome}</h2><p class="draft">DRAFT v01 · avaliação pendente</p>
<div class="pair"><figure><figcaption>Referência existente</figcaption><img class="asset" src="previews/{code}-reference-256.png" alt="Referência {name}"></figure><figure><figcaption>Nova variante</figcaption><img class="asset" src="previews/{code}-256.png" alt="Variante {name}"></figure></div>
<p class="note">{note}</p><p><a href="{job['source']}">PNG nativo</a> · <a href="{job['prompt']}">Prompt</a> · <a href="references/{code}.png">Referência nativa</a></p></article>''')
page='''<!doctype html><html lang="pt-BR"><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>Oito props — lote03 v01</title>
<style>:root{color-scheme:dark;--size:128px}body{margin:0;background:#11151d;color:#e6e9f0;font:16px/1.6 system-ui}main{max-width:1160px;margin:auto;padding:28px}h1{font-size:28px}h2{font-size:20px}article{background:#1c2330;border:1px solid #425069;border-radius:12px;padding:18px;margin:18px 0}.cards{display:grid;grid-template-columns:repeat(auto-fit,minmax(min(100%,480px),1fr));gap:18px}.cards article{margin:0}img{max-width:100%;height:auto;image-rendering:pixelated}.pair{display:flex;gap:18px;flex-wrap:wrap;background:#121824;border-radius:8px;padding:12px;justify-content:center}.asset{width:var(--size);max-width:100%}figure{margin:0;text-align:center}figcaption{font-size:13px;color:#c0cad9;margin-bottom:6px}.draft{color:#e9c583}.note{font-size:14px;color:#bbc8dd}a{color:#8bcaff}button,select{padding:8px 12px;background:#263750;border:1px solid #536b8e;color:white;border-radius:6px;cursor:pointer}.light .pair{background:#d4d8df}.light figcaption{color:#263142}.toolbar{position:sticky;top:0;background:#11151df5;padding:12px 0;z-index:2}</style>
<main><h1>Oito variantes de cenário · lote03/v01</h1><p>Esporos, poca fungica, estalactite viscosa, espelho, flores, fragmento suspenso, nucleo e corrente. Novas opções estáticas baseadas nas famílias existentes. Todas DRAFT, aguardando sua avaliação; nenhuma integrada. Personagens principais preservados com prioridade reduzida.</p>
<div class="toolbar"><label>Tamanho de revisão <select onchange="document.documentElement.style.setProperty('--size',this.value+'px')"><option>64</option><option selected>128</option><option>256</option></select></label> <button onclick="document.body.classList.toggle('light')">Alternar fundo</button> · <a href="audit.json">Auditoria</a></div>
<article><h2>Prancha do lote</h2><img src="previews/contact-sheet.png" alt="Oito candidatas: PV01 a PV04 acima; PV05 a PV08 abaixo"><p class="note">PV17–PV20 acima; PV21–PV24 abaixo. Recorte e escala de revisão por maior dimensão, com alfa original preservado. Não representam escala ou âncora já verificadas no jogo. Nenhum retoque de conteúdo ou limpeza de borda.</p></article>
<div class="cards">CARDS</div>
<p class="note">Uma chamada por peça, oito PNGs nativos preservados. Prévia256 com margem16px e amostras64/128. Confira material, câmera, variedade, leitura pequena e adequação do desgaste. A aprovação deste lote é separada do aceite anterior de PV09–PV16. Arquivamento DRAFT por commit e push autorizado; revisão visual pendente, sem integração ou promoção CANON.</p></main></html>'''.replace('CARDS','\n'.join(cards))
approved=(ROOT/'owner-approval.json').exists()
if approved:
    receipt=json.loads((ROOT/'owner-approval.json').read_text(encoding='utf-8'))
    expected={i['id']:i['sha256'] for i in receipt['sources']}
    for item in audit:
        if expected.get(item['id'])!=item['source_sha256']:raise ValueError('Approved source changed')
        item['content_state']='CANON_VISUAL_v01';item['owner_visual_acceptance']='APPROVED_AS_DISPLAYED'
    page=page.replace('Todas DRAFT, aguardando sua avaliação; nenhuma integrada.','Todas v01 aceitas visualmente pelo dono; nenhuma integrada. <a href="owner-approval.json">Recibo de aceite</a>.').replace('DRAFT v01 · avaliação pendente','CANON VISUAL v01 · aceita como exibida').replace('Arquivamento DRAFT por commit e push autorizado; revisão visual pendente, sem integração ou promoção CANON.','Aceite visual registrado; commit local autorizado, sem push ou integração.')
(ROOT/'index.html').write_text(page,encoding='utf-8')
class Links(HTMLParser):
    def __init__(self):super().__init__();self.paths=[]
    def handle_starttag(self,tag,attrs):self.paths.extend(v for k,v in attrs if k in ('src','href') and v and not v.startswith(('http:','https:','#')))
parser=Links();parser.feed(page)
missing=[v for v in parser.paths if v!='audit.json' and not (ROOT/v).is_file()]
with Image.open(ROOT/'native-sources/PV20_v01.png') as mirror:
    a=mirror.convert('RGBA').getchannel('A');mx,my=mirror.width//2,mirror.height//2
    mirror_center_alpha_max=a.crop((mx-5,my-5,mx+6,my+6)).getextrema()[1]
result=dict(revision='PROPS-VARIEDADE-LOTE03/v01',content_state='DRAFT',imagegen_calls=8,sources=audit,
    gallery_links=len(parser.paths),missing_links=missing,visual_acceptance=('APPROVED_AS_DISPLAYED' if approved else 'PENDING'),
    technical_delivery_pass=len(audit)==8 and not missing and all(i['alpha_range'][0]==0 and i['alpha_range'][1]>128 and i['opaque_outer_edge_pixels']==0 and i['archived_reference_identical'] and i['candidate_copy_identical'] is not False for i in audit),
    native_margin_notes=[i['id'] for i in audit if not i['native_12percent_margin_pass']],runtime_admission=False,canonical_promotion=('VISUAL_ONLY_PV17_PV24_v01' if approved else False),mirror_center_alpha_max=mirror_center_alpha_max,design_review_notes={'PV18':'Open mushrooms instead of closed buds','PV20':'Extra skull ornament not requested'})
if approved:result['content_state']='CANON_VISUAL_v01'
(ROOT/'audit.json').write_text(json.dumps(result,ensure_ascii=False,indent=2),encoding='utf-8')
print(json.dumps({'technical_delivery_pass':result['technical_delivery_pass'],'native_pngs':len(audit),'native_margin_notes':result['native_margin_notes'],'links':len(parser.paths),'missing_links':missing,'dimensions':{i['id']:i['dimensions'] for i in audit}}))
if not result['technical_delivery_pass']:raise SystemExit(1)
