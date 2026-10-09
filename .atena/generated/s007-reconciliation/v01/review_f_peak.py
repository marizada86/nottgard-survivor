from pathlib import Path
import json
from PIL import Image,ImageDraw
root=Path(__file__).resolve().parents[4];out=Path(__file__).parent
data=json.loads((out/'ef-generation-jobs-2026-10-09.json').read_text(encoding='utf-8'));job=next(j for j in data['jobs'] if j['code']=='F03');assert job['status']=='GENERATED_VISUALLY_INSPECTED'
sheet=Image.new('RGB',(1000,650),(20,20,20));draw=ImageDraw.Draw(sheet)
for x,p,title in [(10,out/'approved-pilot-A03-v02-reference.png','A03 v02 | piloto aprovado'),(510,root/job['destination'],'F03 '+job['version']+' | pico de fogo candidato')]:
 im=Image.open(p).convert('RGB');sheet.paste(im.resize((480,480),Image.Resampling.LANCZOS),(x,35));draw.text((x,10),title,fill='white');sheet.paste(im.resize((96,96),Image.Resampling.LANCZOS),(x,535));draw.text((x+110,575),'Leitura a 96 px',fill='white')
sheet.save(out/'f03-reference-comparison-2026-10-09.png')
print('F03 reference and 96px preview prepared; native sources unchanged.')
