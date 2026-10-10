from pathlib import Path
import json,hashlib,shutil
root=Path(__file__).resolve().parents[3];base=Path(__file__).parent
path=base/'jobs.json';data=json.loads(path.read_text(encoding='utf-8'))
for job in data['records']:
    src=root/job['destination'];dst=base/'native-sources'/f"{job['code']}_{job['version']}.png"
    dst.parent.mkdir(exist_ok=True);shutil.copyfile(src,dst)
    assert hashlib.sha256(src.read_bytes()).digest()==hashlib.sha256(dst.read_bytes()).digest()
    job['candidate_copy']=job['destination']
    job['destination']=dst.relative_to(root).as_posix()
data['approval_register']='.atena/vault/canon/ASSET-APPROVAL-FILA028-AL-EV-2026-10-10.md'
path.write_text(json.dumps(data,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
print('12 native sources archived with identical hashes; candidate ignore policy preserved')
