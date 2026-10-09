from pathlib import Path
from PIL import Image,ImageDraw,ImageFont
import json,hashlib,re
root=Path(__file__).resolve().parents[4];out=Path(__file__).parent
jobs=[('guardiao_de_goranthis',1,'I01 — Guardião do Paraíso'),('cultista_de_socothbenoth',2,'I02 — Sacerdote de Ilusões'),('death_tyrant',1,'I03 — Death Tyrant'),('socothbenoth',1,'I04 — Socothbenoth')]
sheet=Image.new('RGB',(1080,1360),'#24242d');d=ImageDraw.Draw(sheet)
font=ImageFont.truetype('C:/Windows/Fonts/segoeui.ttf',24)
small=ImageFont.truetype('C:/Windows/Fonts/segoeui.ttf',17)
audit=[]
for i,(id,version,title) in enumerate(jobs):
 p=root/'.atena/generated/art-candidates/enemies-goranthis'/id/f'{id}_idle_00_v{version:02}.png'
 im=Image.open(p).convert('RGBA');a=im.getchannel('A');h=a.histogram();box=a.point(lambda x:255 if x>=11 else 0).getbbox()
 assert box and min(box[0],box[1],im.width-box[2],im.height-box[3])>0,p
 solid=sum(h[230:])/sum(h[11:]);assert solid>=.90 and h[0]>0,p
 record=dict(id=id,version=version,path=p.relative_to(root).as_posix(),sha256=hashlib.sha256(p.read_bytes()).hexdigest(),size=im.size,bbox=box,solidity=solid,clipped=False,native_alpha_preserved=True)
 audit.append(record)
 cropped=im.crop(box);ratio=min(460/cropped.width,585/cropped.height)
 preview=cropped.resize((round(cropped.width*ratio),round(cropped.height*ratio)),Image.Resampling.NEAREST)
 x=(i%2)*540;y=(i//2)*680
 d.text((x+24,y+15),title,fill='white',font=font)
 d.text((x+24,y+49),f'idle_00 v{version:02} · candidata para aprovação',fill='#b8b8c7',font=small)
 sheet.paste(preview,(x+(540-preview.width)//2,y+80+585-preview.height),preview)
prancha=root/'.atena/generated/priority-review/goranthis_identities_v01.png';sheet.save(prancha)
receipt=dict(date='2026-10-07',plan='PLAN-053',spec='SPEC-121',gate='GATE-GORANTHIS-IDENTITIES-V01',status='PENDING_OWNER_APPROVAL',selected=audit,prancha=prancha.relative_to(root).as_posix(),sources_tool='built-in image_gen',prompts='.atena/generated/goranthis-resume/v01/identity-prompts.json',correction='.atena/generated/goranthis-resume/v01/result-cultista_de_socothbenoth-v2.json',rejected=[dict(id='cultista_de_socothbenoth',version=1,reason='Primary face facing left; v02 corrects direction without swapping staff hand.')],cycles_generated=0,official_assets_installed=0,remaining_new_frames=82,return_plan='PLAN-071')
(out/'identity-gate-receipt.json').write_text(json.dumps(receipt,indent=2,ensure_ascii=False)+'\n',encoding='utf-8')
p=root/'.atena/state/plan.yaml';t=p.read_text(encoding='utf-8')
t=t.replace('S-006/GORANTHIS/IDENTITIES','S-006/GORANTHIS/GATE-IDENTITIES-V01')
t=t.replace('  status: EXECUTING_CYCLES','  status: AWAITING_IDENTITY_APPROVAL',1)
t=re.sub(r"  current: 'PLAN-053 / SPEC-121:.*","  current: 'PLAN-053 / SPEC-121: Shendilavri completo local, build validada; quatro pilotos Goranthis auditados, gate de identidade pendente.'",t,count=1)
t=re.sub(r"  next: '[^\n]*","  next: 'Aguardar aprovacao I01-I04 Goranthis antes dos 82 novos quadros. Retorno PLAN-071 preservado.'",t,count=1);p.write_text(t,encoding='utf-8')
p=root/'.atena/state/plan-053-imagens.yaml';t=p.read_text(encoding='utf-8')
t=t.replace('  status: EXECUTING_CYCLES','  status: AWAITING_IDENTITY_APPROVAL',1)
t=re.sub(r"  current: 'S-006:.*","  current: 'S-006: Shendilavri completo local; quatro pilotos Goranthis auditados, aprovacao pendente. Nenhum ciclo Goranthis.'",t,count=1)
t=re.sub(r"  next: '[^\n]*","  next: 'Aguardar gate I01-I04 Goranthis; depois gerar 82 quadros, um ator por vez.'",t,count=1)
t=re.sub(r"  review: '[^\n]+'","  review: '.atena/generated/priority-review/goranthis_identities_v01.png'",t,count=1)
t=re.sub(r"  evidence: '[^\n]+'","  evidence: '.atena/evidence/goranthis-identities-2026-10-07.md'",t,count=1)
start=t.index('identity_gate:');end=t.index('suspension:',start)
previous=t[start:end].replace('identity_gate:','completed_identity_gates:\n  shendilavri:',1)
previous_lines=previous.splitlines();previous='\n'.join(previous_lines[:2]+['  '+line for line in previous_lines[2:]])+'\n'
gate='identity_gate:\n  id: GATE-GORANTHIS-IDENTITIES-V01\n  status: PENDING_OWNER_APPROVAL\n  generated: 4\n  selected_versions: {I01: v01, I02: v02, I03: v01, I04: v01}\n  cycles_generated: 0\n  official_assets_installed: 0\n  remaining_new_frames: 82\n  receipt: .atena/generated/goranthis-resume/v01/identity-gate-receipt.json\n'
t=t[:start]+gate+previous+t[end:];p.write_text(t,encoding='utf-8')
e=root/'.atena/evidence/goranthis-identities-2026-10-07.md'
e.write_text('# Goranthis — gate de identidade\n\nPLAN-053/SPEC-121 S-006, IN_PLAN, escopo per-plan aprovado. Quatro identidades geradas pelo image_gen integrado a partir das referências estáticas locais; I01/I03/I04 v01 e I02 v02 selecionadas. I02 v01 conserva face à esquerda e foi rejeitada; v02 vira rosto à direita sem trocar a mão do cajado. As quatro candidatas foram inspecionadas; limites inteiros, alfa nativo e solidez >=0,90 auditados. Nenhum ciclo ou asset oficial Goranthis.\n\n[Prancha](../generated/priority-review/goranthis_identities_v01.png). [Recibo com auditoria e hashes](../generated/goranthis-resume/v01/identity-gate-receipt.json). [Prompts iniciais](../generated/goranthis-resume/v01/identity-prompts.json). [Correção I02](../generated/goranthis-resume/v01/result-cultista_de_socothbenoth-v2.json).\n\nCheckpoint GATE-GORANTHIS-IDENTITIES-V01 PENDING_OWNER_APPROVAL: a FILA-018 exige devolver ao dono para aprovar cada identidade antes dos 82 quadros restantes. Shendilavri concluído localmente e [build validada](../generated/shendilavri-complete-build-validation-2026-10-07.json); playtest humano separado. Retorno PLAN-071 preservado. Sem commit/push/publicação.\n',encoding='utf-8')
p=root/'.atena/generated/CHATGPT-FILA-018-mobs-goranthis.md';t=p.read_text(encoding='utf-8');t=re.sub(r'^status:.*','status: "quatro identidades auditadas — aguardando aprovação; nenhum ciclo"',t,count=1,flags=re.M)
for i,(id,_,_) in enumerate(jobs,1):t=t.replace(f'- [ ] gerada · [ ] aprovada — I{i:02}',f'- [x] gerada · [ ] aprovada — I{i:02}',1)
t+='\n2026-10-07 — I01/I03/I04v01, I02v02 candidatas completas e auditadas, alfa nativo preservado. I02v01 rejeitada por face à esquerda. Prancha priority-review/goranthis_identities_v01.png; recibo goranthis-resume/v01/identity-gate-receipt.json. Gate pendente, nenhum ciclo ou PNG oficial; 82 quadros após aprovação. Shendilavri/build concluídos; retorno PLAN-071 preservado.\n';p.write_text(t,encoding='utf-8')
p=root/'.atena/generated/ART-PROMPTS-049-mobs-goranthis.md';t=p.read_text(encoding='utf-8');t=re.sub(r'^status:.*','status: "quatro identidades auditadas — aguardando gate humano; ciclos não iniciados"',t,count=1,flags=re.M);p.write_text(t,encoding='utf-8')
summary='\n2026-10-07 — Goranthis I01-I04 gerados e auditados; I02v02 corrige direção do rosto sem trocar cajado. Gate GATE-GORANTHIS-IDENTITIES-V01 PENDING_OWNER_APPROVAL; nenhum ciclo ou asset oficial; 82 quadros restantes após aprovação. Evidência goranthis-identities-2026-10-07.md, prancha goranthis_identities_v01.png. Shendilavri concluído localmente com build validada; retorno PLAN-071 preservado.\n'
for rel in ['.atena/evidence/EVID-145-fila-de-imagens-prioritaria-2026-10-02.md','.atena/specs/SPEC-121-retomada-fila-imagens/plan.md','.atena/specs/SPEC-121-retomada-fila-imagens/tasks.md']:
 p=root/rel;p.write_text(p.read_text(encoding='utf-8')+summary,encoding='utf-8')
print('Goranthis: four identity sources passed bounds/alpha/solidity; pending owner approval. No cycles or runtime installation.')
for r in audit:print(r['id'],r['version'],r['bbox'],round(r['solidity'],4))
