from pathlib import Path
import shutil,json,hashlib
from PIL import Image
r=Path.cwd(); b=r/'.atena/generated/art045-priority-review/v01'
src=Path('C:/Users/Higor Rossini/.codex/generated_images/01a12116-a4f7-7623-abef-db43878f0eea/exec-af63eb8f-33ac-4848-9f12-6ccb4429e162.png')
out=r/'.atena/generated/art-candidates/heroes-novos/erik/er01-retrato-v01.png'
out.parent.mkdir(parents=True,exist_ok=True); shutil.copyfile(src,out)
digest=hashlib.sha256(src.read_bytes()).hexdigest(); assert hashlib.sha256(out.read_bytes()).hexdigest()==digest
im=Image.open(out); assert im.size==(1536,1024)
record=dict(id='ER01-v01',status='PENDING_OWNER_VISUAL_APPROVAL',content_state='DRAFT',candidate=str(out.relative_to(r)).replace('\\','/'),sha256=digest,original=str(src),native_dimensions=list(im.size),requested_dimensions=[1536,1024],tool='built-in imagegen',prompt='.atena/generated/art045-priority-review/v01/er01-prompt-v01.txt',visual_review='Erik face, forehead scar, beard, wool cowl, leather straps, shoulder fur, sword hilt and gold star amulet retained; pictorial finish; blue forest mist; no visible text. Human likeness and aesthetic acceptance pending.',runtime_admission=False,next_objective='ER02 four-frame idle after owner accepts ER01 v01',next_inputs=['Approved ER01','Nottcard Erik portrait','ART-PROMPTS-060'],next_checks=['Four cells','Real alpha','Body height and baseline','Edges and identity'])
(b/'er01-gate-v01.json').write_text(json.dumps(record,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
for p in [r/'.atena/state/plan.yaml',r/'.atena/state/plan-053-imagens.yaml',r/'.atena/state/dev-024-art045-pilots.yaml']:
 t=p.read_text(encoding='utf-8').replace('DEV-024/S-002/ER01','DEV-024/S-002/ER01-APPROVAL').replace('checkpoint: S-002/ER01','checkpoint: S-002/ER01-APPROVAL').replace('status: EXECUTING_DRAFT','status: GENERATED_WAITING_VISUAL_APPROVAL').replace('Gerar ER01 DRAFT v01 e submeter gate; retorno Sylas preservado.','ER01 DRAFT v01 gerada e verificada; aguardar aceite para ER02; retorno Sylas preservado.')
 p.write_text(t,encoding='utf-8')
e=r/'.atena/evidence/art045-er01-pilot-2026-10-09.md'
e.write_text('# ART-045 — ER01 DRAFT v01\n\nDEV-024 aprovado por plano com retorno a PLAN-053/S-007. Preparação concluída; retrato ER01 produzido pelo imagegen integrado e preservado byte a byte. Dimensões nativas 1536×1024 conferidas. [Gate e hashes](../generated/art045-priority-review/v01/er01-gate-v01.json); [prompt](../generated/art045-priority-review/v01/er01-prompt-v01.txt); [prontidão visual](../generated/art045-priority-review/v01/visual-readiness-er01.json). Sem admissão runtime. Aceite humano pendente. Próximo objetivo ER02, somente após aceite de ER01; AO01/AO02 depois. Retorno Sylas e 41 VFX preservados.\n',encoding='utf-8')
print(json.dumps({'saved':str(out),'size':im.size,'hash_verified':True,'gate':'PENDING_OWNER_VISUAL_APPROVAL'}))
