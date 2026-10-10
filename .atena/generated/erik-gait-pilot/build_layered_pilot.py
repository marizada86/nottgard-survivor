"""Authorized raster derivative. Preserve original; record masks, joints and output."""
from pathlib import Path
from PIL import Image,ImageDraw,ImageFilter,ImageEnhance
import math,json,hashlib
base=Path(__file__).parent
source=base/'guided-final-contacts-v01.png';original_hash=hashlib.sha256(source.read_bytes()).hexdigest()
image=Image.open(source).convert('RGBA').crop((0,0,701,1122))
out=base/'layered-v01';out.mkdir(exist_ok=True)
hip=(350,635)
rig={
 'near':{'joints':[(355,635),(459,780),(553,960)],'polygons':[
 [(330,597),(409,615),(480,751),(475,799),(415,800),(354,709),(306,661)],
 [(415,735),(482,740),(515,800),(577,932),(577,980),(526,1001),(494,910),(426,822)],
 [(524,928),(580,934),(599,959),(655,980),(683,1012),(663,1036),(542,1038),(511,1014),(510,969)]
 ]},
 'far':{'joints':[(340,635),(276,772),(150,962)],'polygons':[
 [(289,605),(356,630),(342,688),(297,759),(278,804),(228,792),(211,759),(254,681)],
 [(236,726),(305,772),(267,844),(189,951),(169,992),(108,991),(108,947),(185,821)],
 [(111,928),(172,949),(190,975),(233,985),(259,1012),(250,1036),(143,1036),(83,1009),(75,980)]
 ]}
}
def cut(poly):
    mask=Image.new('L',image.size);ImageDraw.Draw(mask).polygon(poly,fill=255)
    mask=mask.filter(ImageFilter.GaussianBlur(1))
    from PIL import ImageChops
    mask=ImageChops.multiply(mask,image.getchannel('A'))
    part=image.copy();part.putalpha(mask);return part
layers={}
for leg,data in rig.items():
    for index,poly in enumerate(data['polygons']):
        part=cut(poly)
        if leg=='far':
            rgb=ImageEnhance.Brightness(part.convert('RGB')).enhance(.88);rgb.putalpha(part.getchannel('A'));part=rgb
        part.save(out/(leg+'-'+str(index)+'.png'));layers[(leg,index)]=part
body_mask=Image.new('L',image.size);d=ImageDraw.Draw(body_mask)
d.rectangle((0,0,701,605),fill=255)
# Coat silhouette overlaps hip seams; no source legs retained in body layer.
d.polygon([(0,570),(324,570),(345,617),(311,643),(284,644),(261,669),(206,678),(161,662),(0,662)],fill=255)
d.polygon([(315,570),(470,570),(481,606),(446,628),(393,609),(351,639),(330,620)],fill=255)
from PIL import ImageChops
body_mask=ImageChops.multiply(body_mask.filter(ImageFilter.GaussianBlur(1)),image.getchannel('A'))
body=image.copy();body.putalpha(body_mask);body.save(out/'body.png')
def distance(a,b):return math.hypot(b[0]-a[0],b[1]-a[1])
def knee_for(start,end,l1,l2):
    dx,dy=end[0]-start[0],end[1]-start[1];dist=math.hypot(dx,dy)
    assert abs(l1-l2)<dist<l1+l2, (start,end,dist,l1+l2)
    a=(l1*l1-l2*l2+dist*dist)/(2*dist);h=math.sqrt(max(0,l1*l1-a*a))
    midpoint=(start[0]+a*dx/dist,start[1]+a*dy/dist)
    choices=[(midpoint[0]+s*h*(-dy/dist),midpoint[1]+s*h*dx/dist) for s in [-1,1]]
    return max(choices,key=lambda p:p[0]) # Knee flexes toward facing direction.
def place(layer,a,b,c,d):
    source_angle=math.atan2(b[1]-a[1],b[0]-a[0]);dest_angle=math.atan2(d[1]-c[1],d[0]-c[0]);angle=source_angle-dest_angle
    ratio=distance(a,b)/distance(c,d);co,si=math.cos(angle)*ratio,math.sin(angle)*ratio
    coeff=(co,-si,a[0]-co*c[0]+si*c[1],si,co,a[1]-si*c[0]-co*c[1])
    return layer.transform(image.size,Image.Transform.AFFINE,coeff,Image.Resampling.BICUBIC)
# Opposite contacts1/4 and support/swing phases. Heel plants remain at same baseline.
ground=1040
sole_offset={leg:layers[(leg,2)].getchannel('A').point(lambda v:255 if v>=26 else 0).getbbox()[3]-rig[leg]['joints'][2][1] for leg in ['near','far']}
ny=ground-sole_offset['near'];fy=ground-sole_offset['far']
targets=[((510,ny),(190,fy)),((352,ny),(325,912)),((215,ny),(435,928)),((190,ny),(510,fy)),((325,912),(352,fy)),((435,928),(215,fy))]
records=[];frames=[];debug=[]
for index,(near_target,far_target) in enumerate(targets):
    canvas=Image.new('RGBA',image.size);joints={}
    for leg,end in [('far',far_target),('near',near_target)]:
        src=rig[leg]['joints'];start=src[0];knee=knee_for(start,end,distance(src[0],src[1]),distance(src[1],src[2]));joints[leg]=[start,knee,end]
        # Boots hold orientation independently of shin, with small swing toe lift.
        foot_angle=-.16 if end[1]<950 else 0
        foot_end=(end[0]+90*math.cos(foot_angle),end[1]+90*math.sin(foot_angle))
        boot=place(layers[(leg,2)],src[2],(src[2][0]+90,src[2][1]),end,foot_end)
        calf=place(layers[(leg,1)],src[1],src[2],knee,end)
        thigh=place(layers[(leg,0)],src[0],src[1],start,knee)
        canvas.alpha_composite(boot);canvas.alpha_composite(calf);canvas.alpha_composite(thigh)
    canvas.alpha_composite(body);canvas.save(out/('frame-'+str(index+1)+'.png'));frames.append(canvas)
    overlay=canvas.copy();draw=ImageDraw.Draw(overlay)
    for leg,color in [('far','#ff55cc'),('near','#00ddff')]:
        pts=joints[leg];draw.line(pts,fill=color,width=8)
        for x,y in pts:draw.ellipse((x-10,y-10,x+10,y+10),fill=color)
    overlay.save(out/('rig-frame-'+str(index+1)+'.png'));debug.append(overlay)
    records.append(dict(frame=index+1,joints=joints,foreground='near',support_baseline=ground))
assert records[0]['joints']['near'][2][0]>hip[0] and records[3]['joints']['near'][2][0]<hip[0]
assert records[0]['joints']['far'][2][0]<hip[0] and records[3]['joints']['far'][2][0]>hip[0]
strip=Image.new('RGBA',(701*6,1122))
for idx,frame in enumerate(frames):strip.alpha_composite(frame,(idx*701,0))
strip.save(out/'erik-move-e-layered-native.png')
top=body.getchannel('A').point(lambda v:255 if v>=26 else 0).getbbox()[1]
scale=300/(ground-top);xoff=128-hip[0]*scale;yoff=368-ground*scale
normalized=[];bounds=[]
for index,frame in enumerate(frames):
    result=frame.transform((256,384),Image.Transform.AFFINE,(1/scale,0,-xoff/scale,0,1/scale,-yoff/scale),Image.Resampling.BICUBIC)
    box=result.getchannel('A').point(lambda v:255 if v>=26 else 0).getbbox();bounds.append(box)
    assert box and box[0]>=10 and box[2]<=246 and box[1]>=10 and box[3]<=374,box
    result.save(out/('normalized-frame-'+str(index+1)+'.png'));normalized.append(result)
atlas=Image.new('RGBA',(1536,384))
for index,frame in enumerate(normalized):atlas.alpha_composite(frame,(index*256,0))
atlas.save(out/'erik-move-e-layered-1536x384.png')
def previews(items,name):
    previews=[]
    for frame in items:
        frame=frame.copy();frame.thumbnail((350,500));bg=Image.new('RGB',(380,530),'#303843');bg.paste(frame,((380-frame.width)//2,(530-frame.height)//2),frame);previews.append(bg)
    previews[0].save(out/name,save_all=True,append_images=previews[1:],duration=160,loop=0)
    return previews
preview=previews(frames,'preview.gif');previews(debug,'rig-preview.gif')
comparison=Image.new('RGB',(760,530),'#303843');comparison.paste(preview[0],(0,0));comparison.paste(preview[3],(380,0));comparison.save(out/'contacts-1-4.png')
assert hashlib.sha256(source.read_bytes()).hexdigest()==original_hash
(out/'rig.json').write_text(json.dumps(dict(source=str(source),source_sha256=original_hash,source_rig=rig,phases=records,normalization=dict(scale=scale,body_height=300,baseline=368,bounds=bounds,cell=[256,384],size=atlas.size),art_state='DRAFT_SEAM_REVIEW_REQUIRED',runtime_admission=False),indent=2)+'\n',encoding='utf-8')
print(json.dumps(dict(frames=6,geometric_alternation=True,source_unchanged=True,review=str(out/'preview.gif'))))
