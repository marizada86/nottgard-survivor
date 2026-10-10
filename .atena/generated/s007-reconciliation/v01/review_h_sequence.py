from pathlib import Path
import json,hashlib
from PIL import Image,ImageDraw
root=Path.cwd();out=Path(__file__).parent;d=json.loads((out/'hb-generation-jobs-2026-10-09.json').read_text());jobs={j['code']:j for j in d['jobs']};gate=json.loads((out/'h103-owner-gate-2026-10-09.json').read_text());sheet=Image.new('RGB',(1200,620),(20,20,20));draw=ImageDraw.Draw(sheet);frames=[];audit=[]
for i,code in enumerate(['H101','H102','H103','H104','H105','H106']):
 j=gate if code=='H103' else jobs[code];p=root/(j['candidate'] if code=='H103' else j['destination']);assert hashlib.sha256(p.read_bytes()).hexdigest()==j['sha256'];im=Image.open(p).convert('RGB');x=(i%3)*400;y=(i//3)*310;sheet.paste(im.resize((260,260),Image.Resampling.LANCZOS),(x,y+25));sheet.paste(im.resize((96,96),Image.Resampling.LANCZOS),(x+280,y+105));draw.text((x+10,y+5),code+' '+j['version']+(' CANON peak' if code=='H103' else ' DRAFT'),fill='white');frames.append(im.resize((480,480),Image.Resampling.LANCZOS));audit.append(dict(code=code,path=p.relative_to(root).as_posix(),sha256=j['sha256'],mean_luminance=sum(k*n for k,n in enumerate(im.convert('L').histogram()))/(im.width*im.height)))
sheet.save(out/'durvall-six-frame-review-2026-10-09.png');frames[0].save(out/'durvall-sequence-review-2026-10-09.gif',save_all=True,append_images=frames[1:]+[Image.new('RGB',(480,480))],duration=[110,110,180,130,130,160,300],loop=0)
(out/'durvall-sequence-native-audit-2026-10-09.json').write_text(json.dumps(dict(status='PREPARED_FOR_SEQUENCE_REVIEW',frames=audit,native_bytes_preserved=True,normalization='Deferred1024 and pivot alignment; previews only',runtime_admission=False),indent=2)+'\n')
print('Six hashes verified; preview sheet and GIF prepared')
