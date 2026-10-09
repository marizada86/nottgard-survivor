from pathlib import Path
import json,hashlib
from PIL import Image,ImageDraw
root=Path(__file__).resolve().parents[4];out=Path(__file__).parent
data=json.loads((out/'ef-generation-jobs-2026-10-09.json').read_text(encoding='utf-8'))
jobs={j['code']:j for j in data['jobs']};peak=json.loads((out/'e03-owner-gate-2026-10-09.json').read_text(encoding='utf-8'));assert peak['status']=='APPROVED'
frames=[];rows=[];sheet=Image.new('RGB',(1164,1044),(22,22,22));draw=ImageDraw.Draw(sheet)
for i,code in enumerate(['E01','E02','E03','E04','E05','E06']):
 item=peak if code=='E03' else jobs[code]
 if code!='E03':assert item['status']=='GENERATED_VISUALLY_INSPECTED',code
 path=item['candidate'] if code=='E03' else item['destination'];p=root/path;sha=hashlib.sha256(p.read_bytes()).hexdigest();assert sha==item['sha256']
 im=Image.open(p).convert('RGB');hist=im.convert('L').histogram();rows.append(dict(code=code,path=path,sha256=sha,native_dimensions=list(im.size),version=item['version'],mean_luminance=sum(k*n for k,n in enumerate(hist))/(im.width*im.height),visible_fraction_above12=sum(hist[13:])/(im.width*im.height)))
 x=(i%3)*388+4;y=(i//3)*522;draw.text((x,y+6),code+' '+item['version'],fill='white');sheet.paste(im.resize((376,376),Image.Resampling.LANCZOS),(x,y+27));sheet.paste(im.resize((96,96),Image.Resampling.LANCZOS),(x,y+412));draw.text((x+108,y+450),'96 px',fill='white');frames.append(im.resize((256,256),Image.Resampling.LANCZOS))
sheet.save(out/'arco-radiante-six-frame-review-2026-10-09.png')
frames[0].save(out/'arco-radiante-review-2026-10-09.gif',save_all=True,append_images=frames[1:],duration=[100,90,120,100,130,180],loop=0)
(out/'arco-radiante-sequence-audit-2026-10-09.json').write_text(json.dumps(dict(status='PREPARED_FOR_SEQUENCE_VISUAL_REVIEW',sources=rows,native_sources_preserved=True,preview_only=True,runtime_admission=False,manifest_assets=202),ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
print(json.dumps(rows))
