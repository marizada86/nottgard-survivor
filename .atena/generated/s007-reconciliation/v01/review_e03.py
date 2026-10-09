from pathlib import Path
import json,hashlib
from PIL import Image,ImageChops,ImageDraw
root=Path(__file__).resolve().parents[4];out=Path(__file__).parent
meta=json.loads((out/'e03-prompt-2026-10-09.json').read_text(encoding='utf-8'))
src=root/meta['destination'];im=Image.open(src).convert('RGB');r,g,b=im.split()
diff=max(ImageChops.difference(r,g).getextrema()[1],ImageChops.difference(r,b).getextrema()[1],ImageChops.difference(g,b).getextrema()[1])
mask=im.convert('L').point(lambda v:255 if v>12 else 0);bbox=mask.getbbox()
bordermax=max(im.crop(box).convert('L').getextrema()[1] for box in [(0,0,im.width,1),(0,im.height-1,im.width,im.height),(0,0,1,im.height),(im.width-1,0,im.width,im.height)])
audit=dict(candidate=meta['destination'],sha256=hashlib.sha256(src.read_bytes()).hexdigest(),native_dimensions=list(im.size),mode=Image.open(src).mode,black_corners=[im.getpixel(p) for p in [(0,0),(im.width-1,0),(0,im.height-1),(im.width-1,im.height-1)]],maximum_channel_difference=diff,outer_border_max_luminance=bordermax,visible_bbox_above12=bbox,canvas_square=im.width==im.height,reference_sha256=meta['reference']['sha256'],native_bytes_preserved=True,preview_only_resampling=True,runtime_admission=False)
(out/'e03-audit-2026-10-09.json').write_text(json.dumps(audit,indent=2)+'\n',encoding='utf-8')
sheet=Image.new('RGB',(1000,650),(20,20,20));draw=ImageDraw.Draw(sheet)
for x,p,title in [(10,Path(meta['reference']['path']),'A03 v02 | piloto aprovado'),(510,src,'E03 v01 | pico radiante candidato')]:
 a=Image.open(p).convert('RGB');sheet.paste(a.resize((480,480),Image.Resampling.LANCZOS),(x,35));draw.text((x,10),title,fill='white');sheet.paste(a.resize((96,96),Image.Resampling.LANCZOS),(x,535));draw.text((x+110,575),'Leitura a 96 px',fill='white')
sheet.save(out/'e03-reference-comparison-2026-10-09.png')
print(json.dumps(audit))
