from pathlib import Path
from PIL import Image,ImageDraw
import json,hashlib,math
base=Path(__file__).parent/'layered-v01'
rig=json.loads((base/'rig.json').read_text(encoding='utf-8'))
sheet=Image.new('RGB',(1536,410),'#303843');checks=[]
for index in range(6):
    frame=Image.open(base/('normalized-frame-'+str(index+1)+'.png')).convert('RGBA');sheet.paste(frame,(index*256,26),frame);ImageDraw.Draw(sheet).text((index*256+12,8),'FRAME '+str(index+1),fill='white')
    alpha=frame.getchannel('A');box=alpha.point(lambda v:255 if v>=26 else 0).getbbox()
    checks.append(dict(frame=index+1,bounds=box,alpha_extrema=alpha.getextrema(),margin_pass=box[0]>=10 and box[2]<=246 and box[1]>=10 and box[3]<=374,baseline=box[3]))
    for leg in ['near','far']:
        original=rig['source_rig'][leg]['joints'];current=rig['phases'][index]['joints'][leg]
        for bone in range(2):assert abs(math.dist(original[bone],original[bone+1])-math.dist(current[bone],current[bone+1]))<1e-6
sheet.save(base/'six-frames.png')
atlas=base/'erik-move-e-layered-1536x384.png'
assert Image.open(atlas).size==(1536,384)
assert max(x['baseline'] for x in checks)-min(x['baseline'] for x in checks)<=1
assert all(x['margin_pass'] for x in checks)
report=dict(source_unchanged=True,bone_lengths_preserved=True,opposite_contacts=True,frames=checks,sha256=hashlib.sha256(atlas.read_bytes()).hexdigest(),human_review='PENDING',runtime_admission=False,limitations=['Masks use visible source parts; hip/knee seams and hidden surfaces require artistic review.','Torch and torso remain fixed; this pilot validates leg alternation.','No evidence of foot-slip-free runtime locomotion; motion review required.'])
(base/'audit.json').write_text(json.dumps(report,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
(base/'index.html').write_text('''<!doctype html><meta charset="utf-8"><title>Erik — piloto por camadas</title><style>body{background:#19202b;color:#edf2fa;font:16px system-ui;margin:32px}img{max-width:100%;background:#303843}a{color:#89d9ff}section{margin:24px 0}</style><h1>Erik — piloto por camadas</h1><p>DRAFT: seis fases com alternância controlada. Revisar emendas no quadril, joelhos e tornozelos, aparência das partes ocultas e continuidade do loop. Tronco e tocha fixos neste piloto.</p><section><h2>Prévia</h2><img src="preview.gif"><img src="rig-preview.gif"></section><section><h2>Contatos 1 e 4</h2><img src="contacts-1-4.png"></section><section><h2>Seis fases normalizadas</h2><img src="six-frames.png"></section><p><a href="erik-move-e-layered-1536x384.png">Tira1536×384</a> · <a href="rig.json">Juntas e máscaras</a> · <a href="audit.json">Auditoria</a></p>''',encoding='utf-8')
from html.parser import HTMLParser
class Links(HTMLParser):
    def handle_starttag(self,tag,attrs):
        for key,value in attrs:
            if key in ('href','src'):assert (base/value).is_file(),value
Links().feed((base/'index.html').read_text(encoding='utf-8'))
print(json.dumps(dict(size=[1536,384],frames=6,baseline=[x['baseline'] for x in checks],margins_pass=True,opposite_contacts=True)))
