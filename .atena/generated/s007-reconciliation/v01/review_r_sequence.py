from pathlib import Path
import json,hashlib
from PIL import Image,ImageDraw
root=Path(__file__).resolve().parents[4];out=Path(__file__).parent
d=json.loads((out/'rn-generation-jobs-2026-10-09.json').read_text(encoding='utf-8'));jobs={j['code']:j for j in d['jobs']};gate=json.loads((out/'r01-owner-gate-2026-10-09.json').read_text(encoding='utf-8'));assert gate['status']=='APPROVED'
rows=[];frames=[];sheet=Image.new('RGB',(1552,1044),(22,22,22));draw=ImageDraw.Draw(sheet)
for i,code in enumerate(['R01','R02','R03','R04','R05','R06','R07','R08']):
 item=gate if code=='R01' else jobs[code]
 if code!='R01':assert item['status']=='GENERATED_VISUALLY_INSPECTED',code
 path=item['candidate'] if code=='R01' else item['destination'];p=root/path;sha=hashlib.sha256(p.read_bytes()).hexdigest();assert sha==item['sha256']
 im=Image.open(p).convert('RGB');lum=im.convert('L');hist=lum.histogram();w,h=im.size
 row=dict(code=code,path=path,sha256=sha,native_dimensions=[w,h],version=item['version'],mean_luminance=sum(k*n for k,n in enumerate(hist))/(w*h),visible_fraction_above12=sum(hist[13:])/(w*h))
 if i<4:
  x0,y0,x1,y1=int(w*.3),int(h*.3),int(w*.7),int(h*.7);crop=lum.crop((x0,y0,x1,y1));den=sx=sy=0
  for k,v in enumerate(crop.getdata()):
   weight=max(v-180,0)**2;den+=weight;sx+=(k%crop.width+x0)*weight;sy+=(k//crop.width+y0)*weight
  assert den>0;row['central_hot_light_centroid_normalized']=[sx/den/w,sy/den/h]
 rows.append(row);x=(i%4)*388+4;y=(i//4)*522;draw.text((x,y+6),code+' '+item['version'],fill='white');sheet.paste(im.resize((376,376),Image.Resampling.LANCZOS),(x,y+27));sheet.paste(im.resize((96,96),Image.Resampling.LANCZOS),(x,y+412));draw.text((x+108,y+450),'96px',fill='white');frames.append(im.resize((256,256),Image.Resampling.LANCZOS))
sheet.save(out/'onda-cortante-eight-frame-review-2026-10-09.png')
frames[0].save(out/'onda-cortante-flight-review-2026-10-09.gif',save_all=True,append_images=frames[1:4],duration=[130]*4,loop=0)
frames[4].save(out/'onda-cortante-impact-review-2026-10-09.gif',save_all=True,append_images=frames[5:],duration=[100,120,150,200],loop=0)
centers=[r['central_hot_light_centroid_normalized'] for r in rows[:4]]
spread=[max(c[a] for c in centers)-min(c[a] for c in centers) for a in [0,1]]
(out/'onda-cortante-sequence-audit-2026-10-09.json').write_text(json.dumps(dict(status='PREPARED_FOR_SEQUENCE_VISUAL_REVIEW',sources=rows,flight_centroid_spread_normalized=spread,centroid_method='Central30%-70% crop, weights max(luminance-180,0)^2; proxy for hot light consistency, not exact crescent pivot',native_sources_preserved=True,preview_only=True,runtime_admission=False,manifest_assets=202),ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
print(json.dumps(dict(rows=rows,flight_centroid_spread=spread)))
