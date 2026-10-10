from pathlib import Path
import json,hashlib
from PIL import Image,ImageDraw,ImageChops,ImageStat
root=Path.cwd();out=Path(__file__).parent;d=json.loads((out/'ms-generation-jobs-2026-10-09.json').read_text(encoding='utf-8'));jobs={j['code']:j for j in d['jobs']};g=json.loads((out/'h301-owner-gate-2026-10-09.json').read_text(encoding='utf-8'));sheet=Image.new('RGB',(1200,640),(20,20,20));draw=ImageDraw.Draw(sheet);frames=[];audit=[]
for i,code in enumerate(['H301','H302','H303','H304','H305','H306']):
 j=g if code=='H301' else jobs[code];p=root/(j['candidate'] if code=='H301' else j['destination']);assert hashlib.sha256(p.read_bytes()).hexdigest()==j['sha256'];im=Image.open(p).convert('RGB');x=(i%3)*400;y=(i//3)*320;sheet.paste(im.resize((260,260),Image.Resampling.LANCZOS),(x,y+25));sheet.paste(im.resize((96,96),Image.Resampling.LANCZOS),(x+280,y+110));draw.text((x+10,y+5),code+' '+j['version']+(' CANON gate' if code=='H301' else ' DRAFT'),fill='white');frames.append(im.resize((480,480),Image.Resampling.LANCZOS));audit.append(dict(code=code,path=p.relative_to(root).as_posix(),sha256=j['sha256'],mean_luminance=sum(k*n for k,n in enumerate(im.convert('L').histogram()))/(im.width*im.height)))
sheet.save(out/'maelor-six-frame-review-2026-10-09.png');frames[0].save(out/'maelor-sequence-review-2026-10-09.gif',save_all=True,append_images=frames[1:],duration=140,loop=0)
adj=[]
for i in range(6):adj.append(dict(from_frame=audit[i]['code'],to_frame=audit[(i+1)%6]['code'],mean_abs_preview_luminance_difference=ImageStat.Stat(ImageChops.difference(frames[i].convert('L'),frames[(i+1)%6].convert('L'))).mean[0]))
seam=Image.new('RGB',(800,450),(20,20,20));sd=ImageDraw.Draw(seam)
for x,f,label in [(0,frames[-1],'H306 -> retorno'),(400,frames[0],'H301 -> inicio')]:seam.paste(f.resize((400,400)),(x,30));sd.text((x+10,10),label,fill='white')
seam.save(out/'maelor-loop-seam-review-2026-10-09.png')
(out/'maelor-sequence-native-audit-2026-10-09.json').write_text(json.dumps(dict(status='PREPARED_FOR_SEQUENCE_REVIEW',sources=audit,adjacent_preview_differences=adj,native_bytes_preserved=True,runtime_admission=False,geometry='Static circle/plus slots, subtle breathing glow; native1254;1024 normalization deferred'),ensure_ascii=False,indent=2)+'\n',encoding='utf-8');print(json.dumps(adj,indent=2))
