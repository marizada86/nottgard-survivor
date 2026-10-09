from pathlib import Path
import json
from PIL import Image,ImageDraw
root=Path(__file__).resolve().parents[4];out=Path(__file__).parent
d=json.loads((out/'rn-generation-jobs-2026-10-09.json').read_text(encoding='utf-8'));j=next(j for j in d['jobs'] if j['code']=='N03');assert j['status']=='GENERATED_VISUALLY_INSPECTED'
sheet=Image.new('RGB',(1000,650),(20,20,20));draw=ImageDraw.Draw(sheet)
for x,p,title in [(10,out/'approved-pilot-A03-v02-reference.png','A03 v02 | piloto aprovado'),(510,root/j['destination'],'N03 '+j['version']+' | pulso radiante candidata')]:
 im=Image.open(p).convert('RGB');sheet.paste(im.resize((480,480),Image.Resampling.LANCZOS),(x,35));draw.text((x,10),title,fill='white');sheet.paste(im.resize((96,96),Image.Resampling.LANCZOS),(x,535));draw.text((x+110,575),'Leitura a96px',fill='white')
sheet.save(out/'n03-reference-comparison-2026-10-09.png')
print('N03 style comparison and96px preview prepared; native sources unchanged.')
