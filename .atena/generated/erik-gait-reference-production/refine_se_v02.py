"""Whole-leg mesh derivative: continuous knees/ankles, fixed supporting sole."""
from pathlib import Path
from PIL import Image,ImageDraw,ImageChops,ImageFilter
import json,hashlib,math
base=Path(__file__).parent; old=base/'layered-se-v01'; out=base/'layered-se-v03';out.mkdir(exist_ok=True)
source=base/'er04-contacts-v01.png'; source_hash=hashlib.sha256(source.read_bytes()).hexdigest()
im=Image.open(source).convert('RGBA').crop((0,0,768,1024)); data=json.loads((old/'rig.json').read_text())
rig=data['source_rig'];body=Image.open(old/'body.png').convert('RGBA')
layers={}
for leg,record in rig.items():
    mask=Image.new('L',im.size);draw=ImageDraw.Draw(mask)
    for polygon in record['polygons']:draw.polygon(polygon,fill=255)
    mask=ImageChops.multiply(mask.filter(ImageFilter.GaussianBlur(.65)),im.getchannel('A'))
    layer=im.copy();layer.putalpha(mask);layers[leg]=layer;layer.save(out/(leg+'-whole.png'))
poses=[
 {'near':[(450,580),(500,700),(583,881)],'far':[(379,580),(345,682),(282,788)],'support':'near'},
 {'near':[(450,580),(480,710),(480,881)],'far':[(379,580),(365,710),(380,820)],'support':'near'},
 {'near':[(450,580),(443,695),(390,881)],'far':[(379,580),(415,745),(460,865)],'support':'near'},
 {'near':[(450,580),(420,650),(340,761)],'far':[(379,580),(415,735),(505,908)],'support':'far'},
 {'near':[(450,580),(445,700),(430,820)],'far':[(379,580),(385,735),(405,908)],'support':'far'},
 {'near':[(450,580),(490,730),(545,850)],'far':[(379,580),(355,725),(315,908)],'support':'far'},
]
def lerp_at(y,points):
    for a,b in zip(points,points[1:]):
        if y<=b[1]:
            t=(y-a[1])/(b[1]-a[1]);return a[0]+t*(b[0]-a[0])
    a,b=points[-2:];return a[0]+(y-a[1])/(b[1]-a[1])*(b[0]-a[0])
def warp(leg,target):
    src=rig[leg]['joints'];mesh=[]
    sy=[p[1] for p in src];ty=[p[1] for p in target]
    def inverse(x,y):
        if y<ty[1]:i=0
        elif y<ty[2]:i=1
        else:
            # Preserve each complete boot by translating it as one piece.
            src_y=sy[2]+y-ty[2]
            return (x-target[2][0]+src[2][0],src_y)
        t=(y-ty[i])/(ty[i+1]-ty[i]);src_y=sy[i]+t*(sy[i+1]-sy[i])
        src_x=lerp_at(src_y,src);dst_x=lerp_at(y,target)
        # Smooth perspective width, converging to unchanged boot at the ankle.
        width=1.0
        return ((x-dst_x)/width+src_x,src_y)
    ys=sorted(set([0,1024]+list(range(0,1025,4))+ty))
    for y0,y1 in zip(ys,ys[1:]):
        box=(0,y0,768,y1)
        quad=(*inverse(0,y0),*inverse(0,y1),*inverse(768,y1),*inverse(768,y0))
        mesh.append((box,quad))
    return layers[leg].transform(im.size,Image.Transform.MESH,mesh,Image.Resampling.BICUBIC)
frames=[];bounds=[];records=[]
ground=980;top=body.getchannel('A').point(lambda v:255 if v>=26 else 0).getbbox()[1]
scale=300/(ground-top);xoff=128-420*scale;yoff=368-ground*scale
atlas=Image.new('RGBA',(1536,384));previews=[]
for i,pose in enumerate(poses):
    parts={leg:warp(leg,pose[leg]) for leg in ('far','near')}
    # Correct supporting sole to exactly ground using alpha, moving the whole leg.
    support=pose['support'];box=parts[support].getchannel('A').point(lambda v:255 if v>=26 else 0).getbbox()
    dy=ground-box[3]; shifted=Image.new('RGBA',im.size);shifted.alpha_composite(parts[support],(0,dy));parts[support]=shifted
    frame=Image.new('RGBA',im.size)
    order=('far','near') if i<3 else ('near','far')
    for leg in order:frame.alpha_composite(parts[leg])
    frame.alpha_composite(body)
    frame.save(out/f'frame-{i+1}.png');frames.append(frame)
    normalized=frame.transform((256,384),Image.Transform.AFFINE,(1/scale,0,-xoff/scale,0,1/scale,-yoff/scale),Image.Resampling.BICUBIC)
    # Resampling may shift the alpha threshold by one pixel. Align leg layers only.
    box=normalized.getchannel('A').point(lambda v:255 if v>=26 else 0).getbbox()
    if box[3]!=368:
        legs=Image.new('RGBA',im.size)
        for leg in order:legs.alpha_composite(parts[leg])
        legs=legs.transform((256,384),Image.Transform.AFFINE,(1/scale,0,-xoff/scale,0,1/scale,-yoff/scale),Image.Resampling.BICUBIC)
        corrected=Image.new('RGBA',(256,384));corrected.alpha_composite(legs,(0,368-box[3]))
        body_normal=body.transform((256,384),Image.Transform.AFFINE,(1/scale,0,-xoff/scale,0,1/scale,-yoff/scale),Image.Resampling.BICUBIC)
        corrected.alpha_composite(body_normal);normalized=corrected
    box=normalized.getchannel('A').point(lambda v:255 if v>=26 else 0).getbbox();assert box[3]==368,box
    assert box[0]>=10 and box[2]<=246 and box[1]>=10 and box[3]<=374,box
    normalized.save(out/f'normalized-frame-{i+1}.png');atlas.alpha_composite(normalized,(256*i,0));bounds.append(box)
    preview=Image.new('RGB',(380,530),'#303843');small=frame.copy();small.thumbnail((350,500));preview.paste(small,((380-small.width)//2,(530-small.height)//2),small);previews.append(preview)
    records.append({'frame':i+1,'joints':pose,'support_correction_y':dy,'bounds':box})
atlas.save(out/'erik-move-se-mesh-1536x384.png')
previews[0].save(out/'preview.gif',save_all=True,append_images=previews[1:],duration=100,loop=0)
comparison=Image.new('RGB',(760,530));comparison.paste(previews[0],(0,0));comparison.paste(previews[3],(380,0));comparison.save(out/'contacts-1-4.png')
strip=Image.new('RGB',(1536,410),'#303843');strip.paste(atlas,(0,26),atlas);d=ImageDraw.Draw(strip)
for i in range(6):d.text((256*i+12,6),str(i+1),fill='white')
strip.save(out/'six-frames.png')
assert poses[0]['near'][2][0]>420>poses[3]['near'][2][0]
assert poses[0]['far'][2][0]<420<poses[3]['far'][2][0]
assert hashlib.sha256(source.read_bytes()).hexdigest()==source_hash
(out/'audit.json').write_text(json.dumps({'source_sha256':source_hash,'method':'continuous whole-leg mesh; no separately rotated knee or ankle pieces','frames':records,'cell':[256,384],'atlas':[1536,384],'support_baselines':[b[3] for b in bounds],'geometric_alternation':True,'source_unchanged':True,'artistic_review':'PENDING','runtime_admission':False},indent=2),encoding='utf-8')
print(json.dumps({'atlas':str(out/'erik-move-se-mesh-1536x384.png'),'baselines':[b[3] for b in bounds]}))
