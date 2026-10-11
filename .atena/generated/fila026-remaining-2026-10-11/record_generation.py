from pathlib import Path
from PIL import Image
import sys,json,hashlib,shutil
base=Path(__file__).parent
code,path=sys.argv[1:]
data=json.loads((base/'jobs.json').read_text(encoding='utf-8'))
job=next(j for j in data['jobs'] if j['code']==code)
dest=base/'sources'/f'{code}_{job["revision"]}.png'
dest.parent.mkdir(exist_ok=True)
assert not dest.exists(), 'Do not overwrite existing candidate'
shutil.copyfile(path,dest)
job.update(status='GENERATED',source=dest.relative_to(base).as_posix(),source_sha256=hashlib.sha256(dest.read_bytes()).hexdigest(),source_size=list(Image.open(dest).size),tool='built-in imagegen')
data['generated']=sum(j['status']=='GENERATED' for j in data['jobs'])
(base/'jobs.json').write_text(json.dumps(data,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
print(json.dumps(dict(code=code,generated=data['generated'],total=data['total'],source=job['source'],sha256=job['source_sha256'])))
