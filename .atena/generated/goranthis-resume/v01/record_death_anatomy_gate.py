from pathlib import Path
from PIL import Image, ImageDraw
import hashlib, json, re

root = Path(__file__).resolve().parents[4]
out = Path(__file__).parent
base = root / '.atena/generated/art-candidates/enemies-goranthis/death_tyrant'
sheet = Image.new('RGB',(1600,490),'#24242e');draw=ImageDraw.Draw(sheet)
frames=[('idle_00',1,8),('death_02',3,7),('death_03',3,7),('death_04',3,7)]
rows=[]
for col,(frame,version,eyes) in enumerate(frames):
    p=base/f'death_tyrant_{frame}_v{version:02}.png';im=Image.open(p).convert('RGBA');a=im.getchannel('A');h=a.histogram();b=a.point(lambda x:255 if x>=11 else 0).getbbox()
    cut=b[0]==0 or b[1]==0 or b[2]==im.width or b[3]==im.height;solid=sum(h[230:])/sum(h[11:]);assert not cut and solid>=.9
    preview=im.crop(b);preview.thumbnail((380,410),Image.Resampling.NEAREST);sheet.paste(preview,(col*400+(400-preview.width)//2,50+(410-preview.height)//2),preview)
    draw.text((col*400+12,12),f'{frame} v{version:02}: {eyes} smaller visible stalks',fill='white')
    draw.text((col*400+12,472),'APPROVED IDENTITY' if col==0 else 'PENDING OWNER DECISION',fill='white')
    rows.append(dict(frame=frame,version=version,path=p.relative_to(root).as_posix(),sha256=hashlib.sha256(p.read_bytes()).hexdigest(),size=im.size,bbox=b,solidity=solid,clipped=False,visible_smaller_stalks=eyes))
review=out/'death-tyrant-death-anatomy-gate-2026-10-08.png';sheet.save(review)
receipt=dict(date='2026-10-08',plan='PLAN-053',spec='SPEC-121',status='AWAITING_OWNER_DECISION',checkpoint='S-006/GORANTHIS/DEATH_TYRANT/DEATH-ANATOMY-DECISION',reason='death02/03/04 remain seven visible smaller ocular stalks after three versions; approved identity has eight.',policy='.atena/add.yaml autonomy.max_retries: 3',frames=rows,review=review.relative_to(root).as_posix(),official_tyrant_assets_installed=0,death05_generated=False,socothbenoth_cycles_generated=0,options=['Accept seven visible stalks as scoped exception for death02-05','Defer Death Tyrant and proceed with Socothbenoth','Authorize one extra attempt per affected frame'],return_plan='PLAN-071 preserved')
(out/'death-tyrant-death-anatomy-gate-2026-10-08.json').write_text(json.dumps(receipt,indent=2)+'\n')
selection_path=base/'frame-selection.json';selection=json.loads(selection_path.read_text())
for i in [0,1]:selection[f'attack_{i:02}']=dict(version=2,reason='Corrected anatomy: two human arms, eight smaller ocular stalks.')
for i in [2,3,4]:selection[f'death_{i:02}']=dict(version=3,approval_status='PENDING_OWNER_DECISION',reason='Seven visible smaller stalks after three versions; approved identity has eight. Not integrated.')
selection_path.write_text(json.dumps(selection,indent=2)+'\n')
for rel in ['.atena/state/plan.yaml','.atena/state/plan-053-imagens.yaml']:
    p=root/rel;t=p.read_text(encoding='utf-8-sig');t=re.sub(r'  status: EXECUTING_CYCLES','  status: AWAITING_OWNER_DECISION',t,count=1)
    if rel.endswith('/plan.yaml'):
        t=re.sub(r'  checkpoint: S-006/GORANTHIS/[^\n]+',f'  checkpoint: {receipt["checkpoint"]}',t,count=1)
    else:
        t=re.sub(r'  cycles_generated: \d+','  cycles_generated: 56',t,count=1);t=re.sub(r'  remaining_new_frames: \d+','  remaining_new_frames: 26',t,count=1)
        t=re.sub(r"  review: '[^\n]+'",f"  review: '{review.relative_to(root).as_posix()}'",t,count=1)
        t=re.sub(r"  evidence: '[^\n]+'","  evidence: '.atena/evidence/goranthis-death-tyrant-anatomy-gate-2026-10-08.md'",t,count=1)
        assert 'pending_owner_decision:' not in t
        t+='\npending_owner_decision:\n  id: GATE-DEATH-TYRANT-DEATH-ANATOMY-2026-10-08\n  status: PENDING\n  frames: [death_02, death_03, death_04]\n  max_versions: 3\n  visible_smaller_stalks: 7\n  approved_identity_smaller_stalks: 8\n  receipt: .atena/generated/goranthis-resume/v01/death-tyrant-death-anatomy-gate-2026-10-08.json\n'
    t=re.sub(r"  current: '[^\n]+","  current: 'S-006 Goranthis: Guardiao e Cultista validados; Death Tyrant 19 fontes em revisao, morte02-04 com sete hastes apos tres versoes.'",t,count=1)
    t=re.sub(r"  next: '[^\n]+","  next: 'Aguardar decisao sobre sete hastes visiveis na morte, adiamento ou tentativa extra. Death05 e Socothbenoth pendentes; retorno PLAN-071 preservado.'",t,count=1)
    p.write_text(t,encoding='utf-8')
evidence=root/'.atena/evidence/goranthis-death-tyrant-anatomy-gate-2026-10-08.md'
evidence.write_text('# Death Tyrant — decisão de anatomia da morte\n\nPLAN-053/SPEC-121, IN_PLAN. Move02-04v02 corrigidos para oito hastes, ataque00v02 remove terceiro braço, ataque01v02 restaura oitava haste. Ataque02/03v01 e morte00/01v01 mantêm oito. Morte02/03/04 permanecem com sete hastes menores visíveis após três versões; não inferir ocultação da oitava. Versões v03 selecionadas somente para prévia, com PENDING_OWNER_DECISION; nenhuma tira deste ator instalada. Death05 aguarda escolha da pose final. Socothbenoth possui identidade aprovada e 24 prompts preparados, nenhum ciclo gerado.\n\n[Prancha](../generated/goranthis-resume/v01/death-tyrant-death-anatomy-gate-2026-10-08.png). [Recibo, hashes e opções](../generated/goranthis-resume/v01/death-tyrant-death-anatomy-gate-2026-10-08.json). [Auditoria nativa](../generated/goranthis-resume/v01/death_tyrant-native-audit.json). Todos os 19 quadros da prévia final passaram limites e solidez >=0.90; a revisão compositada confirma que RGB residual do fundo em death04 não é visível no alfa.\n\nBloqueio operacional: .atena/add.yaml autonomy.max_retries: 3; requer decisão explícita para exceção visual, adiamento do ator ou tentativa adicional. A aprovação anterior da marcha arrastada do Escravo não abrange esta anatomia. Guardião/Cultista/Ilusão e retorno PLAN-071 preservados. Manifesto permanece 188; sem exportação nova, commit ou push.\n',encoding='utf-8')
print('Death Tyrant anatomy decision checkpoint saved; no actor assets installed.')
