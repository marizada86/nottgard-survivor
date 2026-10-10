from pathlib import Path
import json,sys,re
base=Path.cwd()/'.atena/generated/erik-arlindo-complete-2026-10-09'
path=base/'jobs.json';data=json.loads(path.read_text(encoding='utf-8'))
job=next(x for x in data['jobs'] if x['code']==sys.argv[1])
old=dict(job);old.pop('rejected_versions',None)
job.setdefault('rejected_versions',[]).append(old)
job['destination']=re.sub(r'-v(\d+)\.png$',lambda m:'-v'+str(int(m[1])+1).zfill(2)+'.png',job['destination'])
path.write_text(json.dumps(data,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
print(job['destination'])
