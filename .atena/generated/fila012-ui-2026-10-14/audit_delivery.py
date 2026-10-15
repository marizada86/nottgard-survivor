"""Read-only raster checks and persistent delivery audit; does not edit images."""
from pathlib import Path
from PIL import Image
from html.parser import HTMLParser
import hashlib,json
ROOT=Path(__file__).resolve().parent
prep=json.loads((ROOT/'previews/preparation.json').read_text(encoding='utf-8'))
bounds={i['code']:i.get('keyed_bounds',i.get('bounds')) for i in prep}
names={'U01':'hud_progresso_moldura','U02':'hud_progresso_marcador','U03':'catalogo_item_bloqueado','U04':'catalogo_item_moldura'}
sources=[]
for code,name in names.items():
    path=ROOT/'native-sources'/f'{code}_v01.png'
    with Image.open(path) as raw:
        raw.load();im=raw.convert('RGBA');w,h=im.size
        corners=[im.getpixel((x,y)) for x,y in [(0,0),(w-1,0),(0,h-1),(w-1,h-1)]]
        size=im.size;native_alpha=im.getchannel('A').getextrema()
    copy=ROOT.parent/'art-candidates/ui-fila012'/f'{name}_v01.png'
    b=bounds[code];expected={'U01':8,'U02':2,'U03':1,'U04':1}[code]
    keyed=Image.open(ROOT/'previews'/f'{code}-keyed.png').convert('RGBA')
    mask=keyed.getchannel('A');hist=mask.histogram()
    edge=mask.crop((0,0,w,1)).tobytes()+mask.crop((0,h-1,w,h)).tobytes()+mask.crop((0,0,1,h)).tobytes()+mask.crop((w-1,0,w,h)).tobytes()
    sources.append(dict(id=code,name=name,source=f'native-sources/{path.name}',prompt=f'prompts/{code}.txt',
        dimensions=size,native_aspect=w/h,requested_aspect=expected,native_aspect_pass=abs(w/h-expected)<.02,
        content_bounds_xywh=b,content_aspect=b[2]/b[3],content_margins=[b[0],b[1],w-b[0]-b[2],h-b[1]-b[3]],
        corner_rgba=corners,native_alpha_range=native_alpha,keyed_alpha_range=mask.getextrema(),
        transparent_preview_pixels=hist[0],opaque_preview_outer_edge_pixels=sum(v>=128 for v in edge),
        sha256=hashlib.sha256(path.read_bytes()).hexdigest(),candidate_copy_hash_matches=(copy.read_bytes()==path.read_bytes() if copy.exists() else None),
        content_state='DRAFT',owner_visual_acceptance='PENDING',runtime_admission=False))
for path in (ROOT/'previews').glob('*.png'):
    with Image.open(path) as im: im.verify()
class Links(HTMLParser):
    def __init__(self):super().__init__();self.paths=[]
    def handle_starttag(self,tag,attrs):self.paths.extend(v for k,v in attrs if k in ('href','src') and v and not v.startswith(('http:','https:','#')))
parser=Links();parser.feed((ROOT/'index.html').read_text(encoding='utf-8'))
missing=[p for p in parser.paths if not (ROOT/p).is_file() and p!='audit.json']
result=dict(revision='FILA-012-UI/v01',content_state='DRAFT',imagegen_calls=4,sources=sources,
    gallery_links=len(parser.paths),missing_gallery_links=missing,preparation=prep,
    technical_delivery_pass=len(sources)==4 and not missing and all(i['candidate_copy_hash_matches'] is not False and i['transparent_preview_pixels']>0 and i['opaque_preview_outer_edge_pixels']==0 for i in sources),
    visual_acceptance='PENDING_OWNER_REVIEW',full_visual_contract_verified=False,
    limitations=['U01 native aspect differs from 8:1; actual HUD placement not tested.','U02 source symbols have different pixel sizes; review canvases normalized independently.','U03/U04 dark interiors include painted checker texture, retained in previews.'])
if (ROOT/'owner-approval.json').exists():
    receipt=json.loads((ROOT/'owner-approval.json').read_text(encoding='utf-8'))
    approved={i['id']:i['sha256'] for i in receipt['sources']}
    for item in sources:
        if approved.get(item['id'])!=item['sha256']:raise ValueError('Approved source hash differs: '+item['id'])
        item['content_state']='CANON_VISUAL_v01';item['owner_visual_acceptance']='APPROVED_AS_DISPLAYED'
    result['content_state']='CANON_VISUAL_v01';result['visual_acceptance']='APPROVED_AS_DISPLAYED_RUNTIME_PENDING'
(ROOT/'audit.json').write_text(json.dumps(result,ensure_ascii=False,indent=2),encoding='utf-8')
print(json.dumps({'technical_delivery_pass':result['technical_delivery_pass'],'gallery_links':len(parser.paths),'missing_links':missing,'native_dimensions':{i['id']:i['dimensions'] for i in sources},'native_aspect_pass':{i['id']:i['native_aspect_pass'] for i in sources}}))
if not result['technical_delivery_pass']:raise SystemExit(1)
