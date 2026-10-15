from pathlib import Path
from PIL import Image
from html.parser import HTMLParser
import json,hashlib,html,shutil
ROOT=Path(__file__).resolve().parent;REPO=ROOT.parents[2]
jobs=json.loads((ROOT/'jobs.json').read_text(encoding='utf-8'))
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
notes={'PV26':'Bordado mais elaborado que o da referência; avaliar a leitura pequena.', 'PV28':'Detalhes do traçado central da runa alterados; não assumir equivalência de símbolo.', 'PV29':'Só três pernas da mesa ficam visíveis nesta perspectiva; o pedido de quatro visíveis não foi atendido. Taça com detalhes decorativos diferentes.', 'PV30':'Bordados, joias e distribuição das manchas diferem da referência.', 'PV31':'Trepadeiras sobem além do terço inferior pedido; avaliar a proximidade visual da variante com a referência.'}
sources=[];cards=[]
for j in jobs:
 source=ROOT/j['source'];copy=REPO/j['candidate_copy'];copy.parent.mkdir(parents=True,exist_ok=True)
 if not copy.exists():shutil.copyfile(source,copy)
 with Image.open(source) as im:
  im.load();a=im.convert('RGBA').getchannel('A');w,h=im.size
  boxes={str(t):a.point(lambda v:255 if v>=t else 0).getbbox() for t in [1,128]}
  box=boxes['128'];assert box
  margins=[box[0],box[1],w-box[2],h-box[3]]
  edge=a.crop((0,0,w,1)).tobytes()+a.crop((0,h-1,w,h)).tobytes()+a.crop((0,0,1,h)).tobytes()+a.crop((w-1,0,w,h)).tobytes()
  alpha_range=a.getextrema()
 previews=[]
 for size in [64,128,256]:
  p=ROOT/f"previews/{j['id']}-{size}.png"
  with Image.open(p) as im:
   im.load();assert im.size==(size,size)
   previews.append(dict(size=size,sha256=sha(p),alpha_bounds=im.convert('RGBA').getchannel('A').getbbox()))
 item=dict(id=j['id'],name=j['name'],content_state='DRAFT',dimensions=[w,h],alpha_range=alpha_range,alpha_boxes=boxes,alpha128_margins=margins,native_12percent_margin_pass=min(margins)>=.12*min(w,h),opaque_outer_edge_pixels=sum(v>=128 for v in edge),source_sha256=sha(source),prompt_sha256=sha(ROOT/j['prompt']),reference_sha256=sha(REPO/j['reference']),archived_reference_identical=sha(REPO/j['reference'])==sha(ROOT/f"references/{j['id']}.png"),candidate_copy_identical=sha(source)==sha(copy),previews=previews,design_review_note=notes.get(j['id'],''),runtime_scale_anchor_collision='NOT_TESTED',owner_visual_acceptance='PENDING')
 sources.append(item)
 note=('Margem nativa12% atendida.' if item['native_12percent_margin_pass'] else 'Margem nativa menor que12%; prévia técnica inclui margem sem alterar fonte.')+' '+item['design_review_note']
 code=j['id']
 cards.append(f'''<article><h2>{code} · {html.escape(j['name'])}</h2><p>DRAFT v01 · avaliação pendente</p><div class="pair"><figure><figcaption>Referência v01</figcaption><img src="previews/{code}-reference-256.png"></figure><figure><figcaption>Nova variante v01</figcaption><img src="previews/{code}-256.png"></figure></div><p>{html.escape(note)}</p><p><a href="{j['source']}">PNG nativo</a> · <a href="{j['prompt']}">Prompt</a> · <a href="references/{code}.png">Referência nativa</a></p></article>''')
 page=''
page='''<!doctype html><html lang="pt-BR"><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>Lote04 · oito variantes de props</title>
<style>:root{color-scheme:dark;--size:128px}body{background:#11151d;color:#e6e9f0;font:16px/1.6 system-ui;margin:0}main{max-width:1150px;margin:auto;padding:24px}article{background:#1c2330;border:1px solid #425069;border-radius:10px;padding:16px;margin:16px 0}.cards{display:grid;grid-template-columns:repeat(auto-fit,minmax(min(100%,470px),1fr));gap:18px}.pair{display:flex;flex-wrap:wrap;gap:16px;justify-content:center;background:#121824;padding:12px}.pair img{width:var(--size);height:auto}img{image-rendering:pixelated;max-width:100%}figure{margin:0;text-align:center}figcaption{font-size:13px}a{color:#8bcaff}button,select{background:#263750;color:white;padding:8px;border:1px solid #536b8e}.light .pair{background:#d4d8df}.light figcaption{color:#263142}.toolbar{position:sticky;top:0;background:#11151df5;padding:12px 0}h2{font-size:20px}</style>
<main><h1>Props · lote04/v01 · PV25–PV32</h1><p>Resina, véu, sino, runa, taça sobre mesa, taça sobre tecido, coluna e ossos. Oito variantes opcionais das referências existentes. Todas DRAFT, sem integração; heróis com prioridade reduzida.</p>
<div class="toolbar"><label>Tamanho <select onchange="document.documentElement.style.setProperty('--size',this.value+'px')"><option>64</option><option selected>128</option><option>256</option></select></label> <button onclick="document.body.classList.toggle('light')">Alternar fundo</button> · <a href="audit.json">Auditoria</a></div>
<article><h2>Prancha</h2><img src="previews/contact-sheet.png" alt="PV25 a PV28 acima; PV29 a PV32 abaixo"><p>PV25–PV28 acima; PV29–PV32 abaixo. Prévia normalizada por maior dimensão; não representa escala física no jogo.</p></article><div class="cards">CARDS</div><p>Uma chamada por peça, fontes e alfa preservados. Prévia256 com margem16 e amostras64/128. Ressalvas de margem, runa, ornamentação e trepadeiras documentadas. Aceite do lote03 não aprova este lote. Nenhuma integração, promoção CANON, novo commit ou push.</p></main></html>'''.replace('CARDS','\n'.join(cards))
approved=(ROOT/'owner-approval.json').exists()
if approved:
 receipt=json.loads((ROOT/'owner-approval.json').read_text(encoding='utf-8'))
 expected={i['id']:i['sha256'] for i in receipt['sources']}
 for item in sources:
  if expected.get(item['id'])!=item['source_sha256']:raise ValueError('Approved source changed')
  item['content_state']='CANON_VISUAL_v01';item['owner_visual_acceptance']='APPROVED_AS_DISPLAYED'
 page=page.replace('DRAFT v01 · avaliação pendente','CANON VISUAL v01 · aceita como exibida').replace('Todas DRAFT, sem integração;','Todas v01 aceitas visualmente, sem integração;').replace('Aceite do lote03 não aprova este lote. Nenhuma integração, promoção CANON, novo commit ou push.','Aceite visual explícito do lote04 registrado no <a href="owner-approval.json">recibo</a>, com ressalvas preservadas. Commit e push autorizados; integração pendente.')
(ROOT/'index.html').write_text(page,encoding='utf-8')
class Links(HTMLParser):
 def __init__(self):super().__init__();self.paths=[]
 def handle_starttag(self,tag,attrs):self.paths.extend(v for k,v in attrs if k in ('src','href') and v)
parser=Links();parser.feed(page);missing=[v for v in parser.paths if v!='audit.json' and not (ROOT/v).is_file()]
passed=len(sources)==8 and not missing and all(i['alpha_range'][0]==0 and i['alpha_range'][1]>128 and i['opaque_outer_edge_pixels']==0 and i['archived_reference_identical'] and i['candidate_copy_identical'] for i in sources)
result=dict(revision='PROPS-VARIEDADE-LOTE04/v01',content_state='DRAFT',imagegen_calls=8,sources=sources,technical_delivery_pass=passed,gallery_links=len(parser.paths),missing_links=missing,native_margin_notes=[i['id'] for i in sources if not i['native_12percent_margin_pass']],design_review_notes=notes,visual_acceptance='PENDING',runtime_admission=False,canonical_promotion=False)
if approved:result.update(content_state='CANON_VISUAL_v01',visual_acceptance='APPROVED_AS_DISPLAYED',canonical_promotion='VISUAL_ONLY_PV25_PV32_v01')
(ROOT/'audit.json').write_text(json.dumps(result,ensure_ascii=False,indent=2),encoding='utf-8')
print(json.dumps({k:result[k] for k in ['technical_delivery_pass','gallery_links','missing_links','native_margin_notes']}))
if not passed:raise SystemExit(1)
