from pathlib import Path
from PIL import Image
import json,hashlib
base=Path(__file__).parent;root=base.parents[2]
entries=[]
for name in ['approved-sources.json','approved-remaining-sources.json']:
    entries+=json.loads((root/'.atena/generated/fila028-acceptance-2026-10-10'/name).read_text(encoding='utf-8'))['entries']
al=root/'.atena/generated/fila028-generation-2026-10-10';audit=json.loads((al/'audit.json').read_text(encoding='utf-8'))
versions={'AL01':'v02','EV01':'v02','EV02':'v01','EV03':'v01','EV04':'v02','EV05':'v02','EV06':'v02'}
for code,version in versions.items():
    r=next(r for r in audit['reports'] if r['code']==code and r['version']==version);p=al/'native-sources'/f'{code}_{version}.png'
    entries.append(dict(code=code,version=version,path=str(p.relative_to(root)),sha256=r['sha256'],visual_state='CANON',runtime_admission=False))
assert len(entries)==34
for e in entries:
    p=root/e['path'];assert hashlib.sha256(p.read_bytes()).hexdigest()==e['sha256'];im=Image.open(p)
    code=e['code'];target=[1152,192] if code=='AL01' else ([128,128] if code.startswith(('IC','I')) or code=='SE01' else [256,256])
    e.update(native_size=list(im.size),native_mode=im.mode,target_size=target,operation='extract_3x2_six_frames_key_resize_192_and_pack' if code=='AL01' else ('preserve_alpha_resize' if code.startswith(('IC','I')) else 'chroma_key_resize'),hash_verified=True)
    if code=='AL01':e.update(grid=[3,2],native_grid_divisible=im.width%3==0 and im.height%2==0)
    e['proposed_output']=f'.atena/generated/fila028-preparation-2026-10-10/normalized/{code}_{e["version"]}.png'
manifest=dict(revision='FILA-028-PREP/v01',status='READ_ONLY_PREFLIGHT_COMPLETE_SCOPE_PENDING',previous_commit='09bdda2df184e15cf5748c4c779acebe1f360978',source_visual_state='CANON',derived_output_state='DRAFT_UNTIL_VERIFIED',runtime_admission=False,entries=entries)
(base/'manifest.json').write_text(json.dumps(manifest,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
print(json.dumps(dict(sources=len(entries),hashes_verified=True,alpha_icons=sum(e['operation']=='preserve_alpha_resize' for e in entries),props=sum(e['operation']=='chroma_key_resize' for e in entries),altar=[e for e in entries if e['code']=='AL01']),ensure_ascii=False))
