"""Read-only image verification and delivery audit for L02 v01."""
from pathlib import Path
from PIL import Image
from html.parser import HTMLParser
import json,hashlib
ROOT=Path(__file__).resolve().parent;REPO=ROOT.parents[2]
source=ROOT/'native-sources/L02_v01.png'
with Image.open(source) as im:
    im.load();rgba=im.convert('RGBA');w,h=im.size
    info=dict(dimensions=[w,h],alpha_range=rgba.getchannel('A').getextrema(),corners_rgba=[rgba.getpixel(p) for p in [(0,0),(w-1,0),(0,h-1),(w-1,h-1)]])
prep=json.loads((ROOT/'previews/preparation.json').read_text(encoding='utf-8'))
checks=[]
for path in sorted((ROOT/'previews').glob('*.png')):
    with Image.open(path) as im:
        im.load();checks.append(dict(file=path.name,dimensions=list(im.size),sha256=hashlib.sha256(path.read_bytes()).hexdigest()))
with Image.open(ROOT/'previews/L02-480x64.png') as im:
    canvas_pass=im.size==(480,64) and im.convert('RGBA').getchannel('A').getextrema()==(0,255)
with Image.open(ROOT/'previews/L02-30px.png') as im:small_pass=im.height==30
class Links(HTMLParser):
    def __init__(self):super().__init__();self.paths=[]
    def handle_starttag(self,tag,attrs):self.paths.extend(v for k,v in attrs if k in ('src','href') and v and not v.startswith(('http:','https:','#')))
parser=Links();parser.feed((ROOT/'index.html').read_text(encoding='utf-8'))
missing=[v for v in parser.paths if v!='audit.json' and not (ROOT/v).is_file()]
candidate=REPO/'.atena/generated/art-candidates/lettering/prompt_clique_v01.png'
copy_matches=candidate.read_bytes()==source.read_bytes() if candidate.exists() else None
b=prep['bounds_xywh'];margins=[b[0],b[1],w-b[0]-b[2],h-b[1]-b[3]]
result=dict(revision='L02/v01',content_state='DRAFT',imagegen_calls=1,source=info,source_sha256=hashlib.sha256(source.read_bytes()).hexdigest(),
    prompt_sha256=hashlib.sha256((ROOT/'prompt.txt').read_bytes()).hexdigest(),candidate_copy_matches=copy_matches,
    content_margins=margins,preparation=prep,previews=checks,
    text_visual_check=dict(expected='Clique para jogar',observed='Clique para jogar',method='manual visual inspection of native image and 30px preview',owner_acceptance='PENDING'),
    gallery_links=len(parser.paths),missing_links=missing,runtime_admission=False,canonical_promotion=False,
    technical_delivery_pass=canvas_pass and small_pass and min(margins)>0 and copy_matches is not False and not missing,
    notes=['Preview is a technical composition, not a runtime capture.','Dynamic keyboard/controller/touch prompt behavior preserved.'])
if (ROOT/'owner-approval.json').exists():
    receipt=json.loads((ROOT/'owner-approval.json').read_text(encoding='utf-8'))
    if receipt['source']['sha256']!=result['source_sha256']:raise ValueError('Approved source hash changed')
    result['content_state']='CANON_VISUAL_v01';result['canonical_promotion']='VISUAL_ONLY_L02_v01'
    result['text_visual_check']['owner_acceptance']='APPROVED_v01'
(ROOT/'audit.json').write_text(json.dumps(result,indent=2,ensure_ascii=False),encoding='utf-8')
print(json.dumps({'technical_delivery_pass':result['technical_delivery_pass'],'native_dimensions':[w,h],'content_margins':margins,'canvas':prep['final_canvas'],'small':prep['small_size'],'links':len(parser.paths),'missing_links':missing}))
if not result['technical_delivery_pass']:raise SystemExit(1)
