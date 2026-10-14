"""Build a review-only GIF from native strips; no raster source changes."""
from pathlib import Path
from PIL import Image, ImageDraw, ImageFont
import json, math, hashlib
from array import array

def isolated_frames(native, expected):
    """Find independent alpha components before using the declared grid fallback."""
    w,h=native.size
    alpha=native.getchannel('A').tobytes()
    labels=array('i',[0])*(w*h)
    found=[]
    tag=0
    for start in range(w*h):
        if labels[start] or alpha[start]<128:
            continue
        tag+=1
        labels[start]=tag
        stack=[start]
        area=0; x0=w; y0=h; x1=0; y1=0
        while stack:
            p=stack.pop(); y,x=divmod(p,w)
            area+=1; x0=min(x0,x); x1=max(x1,x); y0=min(y0,y); y1=max(y1,y)
            for q in (p-1 if x else -1,p+1 if x<w-1 else -1,p-w if y else -1,p+w if y<h-1 else -1):
                if q>=0 and labels[q]==0 and alpha[q]>=128:
                    labels[q]=tag; stack.append(q)
        if area>=2000:
            found.append((x0,y0,x1+1,y1+1,tag,area))
    found.sort()
    if expected==1 and found:
        found=[max(found,key=lambda item:item[5])]
    if len(found)!=expected:
        return None,len(found)
    # Keep vertical coordinates common. Centre using the upper-body centroid.
    aligned=[]
    for x0,y0,x1,y1,tag,area in found:
        top_end=y0+max(1,(y1-y0)//5)
        xs=[x for y in range(y0,top_end) for x in range(x0,x1) if labels[y*w+x]==tag]
        head_x=sum(xs)/len(xs) if xs else (x0+x1)/2
        frame=Image.new('RGBA',(w//expected*2,h))
        crop=native.crop((x0,y0,x1,y1))
        # Isolate the component; alpha stays native for retained pixels.
        ca=crop.getchannel('A'); values=bytearray(ca.tobytes())
        for cy in range(y1-y0):
            for cx in range(x1-x0):
                if labels[(y0+cy)*w+x0+cx]!=tag:
                    values[cy*(x1-x0)+cx]=0
        crop.putalpha(Image.frombytes('L',crop.size,bytes(values)))
        frame.paste(crop,(round(frame.width/2-(head_x-x0)),y0))
        aligned.append(frame)
    return aligned,len(found)

ROOT = Path(__file__).resolve().parent
OUT = ROOT / 'avaliacao'
OUT.mkdir(exist_ok=True)
SOURCES = [
    ('P1 move_e / 6', 'durvall_move_e_v01.png', 6),
    ('P2 move_se / 6', 'durvall_move_se_v01.png', 6),
    ('P3 move_s / 6', 'durvall_move_s_v01.png', 6),
    ('P4 attack / 4', 'durvall_attack_v01.png', 4),
    ('P5 move_e / 8', 'durvall_move_e8_v01.png', 8),
]
font = ImageFont.truetype('C:/Windows/Fonts/arial.ttf', 17)
small = ImageFont.truetype('C:/Windows/Fonts/arial.ttf', 13)
tracks, report = [], []
for label, name, count in SOURCES:
    path = ROOT / 'retorno' / name
    native = Image.open(path).convert('RGBA')
    width, height = native.size
    # Equal cells as requested by the prompts; preserve misregistration and cuts.
    frames,component_count = isolated_frames(native,count)
    method='alpha components; horizontal upper-body anchor; common vertical origin'
    if frames is None:
        method='equal-cell fallback; dominant component per cell (joins unresolved)'
        frames = [native.crop((round(i*width/count), 0,
                               round((i+1)*width/count), height)) for i in range(count)]
        frames = [isolated_frames(frame,1)[0][0] for frame in frames]
    boxes = [frame.getchannel('A').point(lambda v: 255 if v>=128 else 0).getbbox() for frame in frames]
    valid = [box for box in boxes if box]
    envelope = (min(b[0] for b in valid), min(b[1] for b in valid),
                max(b[2] for b in valid), max(b[3] for b in valid))
    ew, eh = envelope[2]-envelope[0], envelope[3]-envelope[1]
    scale = min(210/ew, 230/eh)
    shown = [frame.crop(envelope).resize((round(ew*scale), round(eh*scale)),
              Image.Resampling.NEAREST) for frame in frames]
    tracks.append((label, shown, count))
    report.append(dict(prompt=label, file=name, dimensions=[width,height],
        frames=count, alpha_range=native.getchannel('A').getextrema(),
        component_count=component_count, extraction=method, preview_alpha_threshold=128,
        cells_divisible=width%count==0,
        expected_dimensions=[count*256,384],
        exact_format_pass=width==count*256 and height==384,
        cell_alpha_boxes=boxes, fixed_envelope=envelope,
        preview_scale=scale, sha256=hashlib.sha256(path.read_bytes()).hexdigest()))

timeline = math.lcm(*(count for _,_,count in tracks))
frames = []
for tick in range(timeline):
    canvas = Image.new('RGB',(1200,370),(22,26,35))
    draw = ImageDraw.Draw(canvas)
    draw.text((18,12),'Durvall | DRAFT | 10 fps | P1 seis quadros x P5 oito quadros',font=font,fill='white')
    for col,(label,images,count) in enumerate(tracks):
        x = col*240
        draw.rectangle((x+5,47,x+235,325),outline=(75,85,105))
        draw.text((x+12,56),label,font=font,fill=(224,226,235))
        draw.text((x+12,81),f'Quadro {tick%count+1}/{count}',font=small,fill=(165,180,200))
        sprite = images[tick%count]
        canvas.paste(sprite,(x+120-sprite.width//2,315-sprite.height),sprite)
    draw.text((18,344),'Componentes alfa quando separaveis; senao grade declarada. Escala fixa por tira, sem interpolacao. PNGs preservados.',font=small,fill=(170,185,205))
    frames.append(canvas)
frames[0].save(OUT/'durvall_p1_p5_10fps.gif',save_all=True,append_images=frames[1:],duration=100,loop=0,optimize=False)
frames[0].save(OUT/'review-first-frame.png')
for label,images,count in tracks:
    name = label.split()[0].lower()
    individual=[]
    for i,sprite in enumerate(images):
        canvas=Image.new('RGB',(280,340),(22,26,35))
        draw=ImageDraw.Draw(canvas)
        draw.text((12,12),label+' | 10 fps',font=font,fill='white')
        draw.text((12,39),f'DRAFT | quadro {i+1}/{count}',font=small,fill=(170,185,205))
        canvas.paste(sprite,(140-sprite.width//2,310-sprite.height),sprite)
        individual.append(canvas)
    individual[0].save(OUT/f'{name}_10fps.gif',save_all=True,append_images=individual[1:],duration=100,loop=0,optimize=False)
gif = Image.open(OUT/'durvall_p1_p5_10fps.gif')
assert gif.n_frames == timeline
assert gif.info['duration'] == 100 and gif.info['loop'] == 0
report_doc=dict(fps=10,frames=gif.n_frames,cycle_ms=timeline*100,
    human_acceptance='PENDING',runtime_admission=False,
    preview_method='alpha components when separable, equal-cell fallback; fixed scale per strip; upper-body x anchor and common y origin; no interpolation',sources=report)
(OUT/'report.json').write_text(json.dumps(report_doc,indent=2),encoding='utf-8')
print(json.dumps(dict(gif=str(OUT/'durvall_p1_p5_10fps.gif'),frames=gif.n_frames,duration_ms=gif.info['duration'],sources=len(tracks))))
