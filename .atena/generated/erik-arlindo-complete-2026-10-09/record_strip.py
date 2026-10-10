from pathlib import Path
from PIL import Image
import sys,json,hashlib,shutil,re
r=Path.cwd();b=r/'.atena/generated/erik-arlindo-complete-2026-10-09';p=b/'jobs.json';d=json.loads(p.read_text(encoding='utf-8'));code,original=sys.argv[1:3];j=next(x for x in d['jobs'] if x['code']==code);s=Path(original);out=r/j['destination'];assert not out.exists();shutil.copyfile(s,out);assert s.read_bytes()==out.read_bytes();im=Image.open(out);a=im.getchannel('A') if im.mode=='RGBA' else None;frames=[]
if a:
 for i in range(j['frames']):
  l=i*im.width//j['frames'];right=(i+1)*im.width//j['frames'];c=a.crop((l,0,right,im.height));box=c.point(lambda x:255 if x>=26 else 0).getbbox();edges=max(c.crop((0,0,1,im.height)).getextrema()[1],c.crop((c.width-1,0,c.width,im.height)).getextrema()[1],c.crop((0,0,c.width,1)).getextrema()[1],c.crop((0,im.height-1,c.width,im.height)).getextrema()[1]);frames.append(dict(frame=i+1,bbox_alpha26=box,edge_alpha_max=edges,edge_content=edges>=26))
flags=[]
if im.size!=(256*j['frames'],384):flags.append('DIMENSION_MISMATCH')
if not a or a.histogram()[0]==0:flags.append('MISSING_EMPTY_ALPHA')
if any(x['edge_content'] for x in frames):flags.append('EDGE_CONTENT')
j.update(status='GENERATED_DRAFT_PENDING_REVIEW',sha256=hashlib.sha256(out.read_bytes()).hexdigest(),original=str(s),native_size=list(im.size),native_mode=im.mode,alpha_extrema=a.getextrema() if a else None,transparent_fraction=a.histogram()[0]/(im.width*im.height) if a else 0,frame_audit=frames,technical_flags=flags,runtime_admission=False)
d['generated']=sum(x['status'].startswith('GENERATED') for x in d['jobs']);d['remaining']=16-d['generated'];p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
for p in [r/'.atena/state/plan.yaml',r/'.atena/state/plan-053-imagens.yaml',r/'.atena/state/dev-024-art045-pilots.yaml']:
 t=p.read_text(encoding='utf-8');t=re.sub(r'remaining_pieces: \d+','remaining_pieces: '+str(d['remaining']),t);p.write_text(t,encoding='utf-8')
print(json.dumps(dict(code=code,generated=d['generated'],remaining=d['remaining'],size=im.size,flags=flags)))
