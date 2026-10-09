from pathlib import Path
import json,hashlib
from PIL import Image,ImageDraw
root=Path(__file__).resolve().parents[4];out=Path(__file__).parent
d=json.loads((out/'mh-generation-jobs-2026-10-09.json').read_text(encoding='utf-8'));jobs={j['code']:j for j in d['jobs']};gate=json.loads((out/'m03-owner-gate-2026-10-09.json').read_text(encoding='utf-8'));assert gate['status']=='APPROVED'
rows=[];frames=[];sheet=Image.new('RGB',(1164,1044),(22,22,22));draw=ImageDraw.Draw(sheet)
for i,code in enumerate(['M01','M02','M03','M04','M05','M06']):
 item=gate if code=='M03' else jobs[code]
 if code!='M03':assert item['status']=='GENERATED_VISUALLY_INSPECTED',code
 path=item['candidate'] if code=='M03' else item['destination'];p=root/path;sha=hashlib.sha256(p.read_bytes()).hexdigest();assert sha==item['sha256'];im=Image.open(p).convert('RGB');lum=im.convert('L');hist=lum.histogram();w,h=im.size
 bbox=lum.point(lambda v:255 if v>12 else 0).getbbox();row=dict(code=code,path=path,sha256=sha,native_dimensions=[w,h],version=item['version'],visible_bbox_above12=bbox,mean_luminance=sum(k*n for k,n in enumerate(hist))/(w*h),visible_fraction_above12=sum(hist[13:])/(w*h))
 if i<4:
  den=sx=sy=0;radial=[0]*(w//2)
  for k,v in enumerate(lum.get_flattened_data()):
   weight=max(v-80,0)**2;den+=weight;sx+=(k%w)*weight;sy+=(k//w)*weight
   if weight:
    radius=int(((k%w-w/2)**2+(k//w-h/2)**2)**.5)
    if 5<=radius<len(radial):radial[radius]+=weight
  assert den>0;row['hot_light_centroid_normalized']=[sx/den/w,sy/den/h];row['bright_ring_radius_proxy_px']=max(range(8,len(radial)-3),key=lambda r:sum(radial[r-3:r+4]))
 rows.append(row);x=(i%3)*388+4;y=(i//3)*522;draw.text((x,y+6),code+' '+item['version'],fill='white');sheet.paste(im.resize((376,376),Image.Resampling.LANCZOS),(x,y+27));sheet.paste(im.resize((96,96),Image.Resampling.LANCZOS),(x,y+412));draw.text((x+108,y+450),'96px',fill='white');frames.append(im.resize((256,256),Image.Resampling.LANCZOS))
sheet.save(out/'ampulheta-silencio-six-frame-review-2026-10-09.png');frames[0].save(out/'ampulheta-silencio-sequence-review-2026-10-09.gif',save_all=True,append_images=frames[1:],duration=[80,100,100,130,150,220],loop=0)
centers=[r['hot_light_centroid_normalized'] for r in rows[:4]];spread=[max(c[a] for c in centers)-min(c[a] for c in centers) for a in [0,1]]
a=dict(status='PREPARED_FOR_SEQUENCE_VISUAL_REVIEW',sources=rows,hot_centroid_spread_normalized=spread,centroid_method='Whole image weights max(luminance-80,0)^2 for M01-M04, proxy for light position, not exact geometric ring pivot',native_sources_preserved=True,preview_only=True,runtime_admission=False,manifest_assets=202)
(out/'ampulheta-silencio-sequence-audit-2026-10-09.json').write_text(json.dumps(a,ensure_ascii=False,indent=2)+'\n',encoding='utf-8');print(json.dumps(dict(rows=rows,hot_centroid_spread=spread)))
