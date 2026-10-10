from pathlib import Path
import json,hashlib,shutil
root=Path.cwd();base=root/'.atena/generated/erik-gait-pilot/layered-v01'
source=base/'erik-move-e-layered-1536x384.png';dest=root/'.atena/generated/art-candidates/heroes-novos/erik/er03-move_e-layered-v01.png'
assert not dest.exists();shutil.copyfile(source,dest)
assert source.read_bytes()==dest.read_bytes()
path=root/'.atena/generated/erik-arlindo-complete-2026-10-09/jobs.json';data=json.loads(path.read_text(encoding='utf-8'))
job=next(x for x in data['jobs'] if x['code']=='ER03')
job['controlled_layer_candidate']=dict(path=dest.relative_to(root).as_posix(),sha256=hashlib.sha256(dest.read_bytes()).hexdigest(),size=[1536,384],status='DRAFT_GEOMETRY_CHECKED_ART_REVIEW_PENDING',review='.atena/generated/erik-gait-pilot/layered-v01/index.html')
path.write_text(json.dumps(data,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
for filename in ['plan.yaml','plan-053-imagens.yaml']:
    path=root/'.atena/state'/filename;text=path.read_text(encoding='utf-8').replace('checkpoint: DEV-024/GAIT-CORRECTION-REQUIRED','checkpoint: DEV-024/GAIT-PILOT/LAYERED-REVIEW')
    path.write_text(text,encoding='utf-8')
path=root/'.atena/state/dev-024-art045-pilots.yaml'
with path.open('a',encoding='utf-8') as file:file.write('\nlayered_pilot:\n  owner_authorization: .atena/generated/erik-gait-pilot/layered-v01/authorization.json\n  candidate: .atena/generated/art-candidates/heroes-novos/erik/er03-move_e-layered-v01.png\n  review: .atena/generated/erik-gait-pilot/layered-v01/index.html\n  geometric_checks: PASSED\n  artistic_review: PENDING\n  runtime_admission: false\n')
path=root/'.atena/generated/CHATGPT-FILA-027-erik-e-arlindo.md'
with path.open('a',encoding='utf-8') as file:file.write('\n## Piloto controlado ER03\n\n[Ciclo por camadas](erik-gait-pilot/layered-v01/index.html), grade1536x384 e alternância geométrica verificadas. Candidato alternativo DRAFT, emendas e continuidade pendentes; não substitui automaticamente a seleção anterior.\n')
print('Candidate preserved separately; plan cursor and alternative reference reconciled.')
