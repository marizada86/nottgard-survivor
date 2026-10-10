from pathlib import Path
from PIL import Image,ImageDraw,ImageChops,ImageFilter
import json,hashlib,math
base=Path(__file__).parent;old=base/'layered-se-v01';out=base/'paired-templates-v01';out.mkdir(exist_ok=True)
source=base/'er04-contacts-v01.png';sha=hashlib.sha256(source.read_bytes()).hexdigest();im=Image.open(source).convert('RGBA').crop((0,0,768,1024))
rig=json.loads((old/'rig.json').read_text())['source_rig'];body=Image.open(old/'body.png').convert('RGBA')
layers={}
for name,record in rig.items():
    mask=Image.new('L',im.size);d=ImageDraw.Draw(mask)
    for polygon in record['polygons']:d.polygon(polygon,fill=255)
    mask=ImageChops.multiply(mask.filter(ImageFilter.GaussianBlur(.4)),im.getchannel('A'))
    layer=im.copy();layer.putalpha(mask);layers[name]=layer
def move(layer,dx,dy=0):
    dst=Image.new('RGBA',im.size);dst.alpha_composite(layer,(dx,dy));return dst
a=Image.new('RGBA',im.size);a.alpha_composite(layers['far']);a.alpha_composite(layers['near']);a.alpha_composite(body)
b=Image.new('RGBA',im.size);b.alpha_composite(move(layers['far'],71));b.alpha_composite(move(layers['near'],-71));b.alpha_composite(body)
for i,frame in enumerate([a,b]):frame.save(out/f'contact-{i+1}.png')
previews=[]
for frame in [a,b]:
    small=frame.copy();small.thumbnail((350,500));bg=Image.new('RGB',(380,530),'#303843');bg.paste(small,((380-small.width)//2,(530-small.height)//2),small);previews.append(bg)
comparison=Image.new('RGB',(760,530));comparison.paste(previews[0],(0,0));comparison.paste(previews[1],(380,0));comparison.save(out/'contacts.png')
(out/'source.json').write_text(json.dumps({'source_sha256':sha,'method':'two depth pose templates anchored at opposite hips; preserve painted pixels, no shin rotation or mesh stretch','source_unchanged':hashlib.sha256(source.read_bytes()).hexdigest()==sha,'contact_a':{'right_leg':'back','left_leg':'front'},'contact_b':{'right_leg':'front','left_leg':'back'},'runtime_admission':False},indent=2),encoding='utf-8')
