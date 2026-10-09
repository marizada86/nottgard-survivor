from pathlib import Path
from PIL import Image, ImageDraw
import hashlib, json, re

root=Path(__file__).resolve().parents[4];out=Path(__file__).parent
base=root/'.atena/generated/art-candidates/enemies-pilares/sintese_abissal'
source=root/'assets/enemies/sintese_abissal.png'
versions=[]
for version in [1,2]:
    path=base/f'sintese_abissal_idle_00_v{version:02}.png'
    im=Image.open(path).convert('RGBA');a=im.getchannel('A');h=a.histogram()
    box=a.point(lambda x:255 if x>=11 else 0).getbbox()
    margins=[box[0]/im.width,box[1]/im.height,(im.width-box[2])/im.width,(im.height-box[3])/im.height]
    solid=sum(h[230:])/sum(h[11:])
    clipped=box[0]==0 or box[1]==0 or box[2]==im.width or box[3]==im.height
    versions.append(dict(version=version,path=path.relative_to(root).as_posix(),sha256=hashlib.sha256(path.read_bytes()).hexdigest(),size=im.size,bbox=box,solidity=solid,margins=margins,clipped=clipped,corner_alpha=a.getpixel((0,0)),status='REJECTED_FRAMING_MARGIN' if version==1 else 'CANDIDATE_AWAITING_OWNER_APPROVAL'))
candidate=versions[1]
assert not candidate['clipped'] and candidate['solidity']>=.9 and min(candidate['margins'])>=.08 and candidate['corner_alpha']==0
sheet=Image.new('RGB',(1160,660),'#25252e');draw=ImageDraw.Draw(sheet)
for column,(path,label) in enumerate([(source,'Fonte estatica'),(root/candidate['path'],'I01 candidata v02 / identidade pendente')]):
    im=Image.open(path).convert('RGBA');box=im.getchannel('A').point(lambda x:255 if x>=11 else 0).getbbox()
    preview=im.crop(box);scale=min(520/preview.width,570/preview.height);preview=preview.resize((round(preview.width*scale),round(preview.height*scale)),Image.Resampling.NEAREST)
    x=column*580+(580-preview.width)//2;y=630-preview.height
    sheet.paste(preview,(x,y),preview);draw.text((column*580+20,20),label,fill='white')
review=root/'.atena/generated/priority-review/pilares_identity_gate_v02.png'
sheet.save(review)
receipt=dict(date='2026-10-08',plan='PLAN-053',spec='SPEC-121',gate='GATE-PILARES-IDENTITY-V01',status='AWAITING_OWNER_IDENTITY_APPROVAL',request_classification='IN_PLAN',approval_mode='per-plan',approved=False,source=dict(path=source.relative_to(root).as_posix(),sha256=hashlib.sha256(source.read_bytes()).hexdigest()),candidate=candidate,versions=versions,review=review.relative_to(root).as_posix(),review_method='Technical nearest composition only, source native RGBA preserved; no alpha cleanup or RGB modification.',generator='built-in imagegen',prompt_records=['.atena/generated/pilares-resume/v01/identity-prompt-2026-10-08.json','.atena/generated/pilares-resume/v01/identity-framing-v02-prompts-2026-10-08.json'],reviewed_features='One crimson wing and cage gauntlet/claw at SCREENLEFT; white roots/pink fungi, green body/purple chest core; original two lamp-bearing limbs at SCREENRIGHT with two green dripping lamps. Full tips retained.',native_alpha_valid=True,halo_review='Generated RGB preview glow lies outside native visible alpha; dark composite inspected, no visible background halo.',cycles_generated=0,remaining_cycle_frames=25,official_assets_installed=0,prior_biome_receipt='.atena/generated/goranthis-complete-build-validation-2026-10-08.json',human_identity_approval='PENDING',return_plan='PLAN-071')
(out/'identity-gate-receipt.json').write_text(json.dumps(receipt,indent=2)+'\n',encoding='utf-8')
p=out/'identity-prompt-2026-10-08.json';r=json.loads(p.read_text(encoding='utf-8'));r.update(status='GENERATED_V01_FRAMING_REJECTED_V02_CANDIDATE',receipt='.atena/generated/pilares-resume/v01/identity-gate-receipt.json');p.write_text(json.dumps(r,indent=2)+'\n',encoding='utf-8')
evidence=root/'.atena/evidence/pilares-identity-gate-2026-10-08.md'
evidence.write_text('# Pilares — gate da identidade da Síntese Abissal\n\nPLAN-053/SPEC-121 S-006, IN_PLAN, per-plan preservado. Um único piloto de identidade, duas versões nativas produzidas com imagegen integrado. V01 preservada e rejeitada por margem insuficiente; v02 candidata, sem aprovação presumida. Fonte estática do projeto somente lida.\n\nV02: alfa nativo, solidez '+f'{candidate["solidity"]:.6f}'+', nenhuma ponta cortada, menor margem '+f'{min(candidate["margins"])*100:.2f}%'+'. Asa e gaiola à esquerda da tela, raízes brancas/cogumelos rosados, núcleo roxo e dois membros com lampiões pingando verde à direita preservados. Composição sobre fundo escuro inspecionada: o brilho RGB da apresentação da ferramenta é externo à região alfa visível; não há halo de fundo na composição. Fontes sem edição de RGB/alfa; prancha técnica por nearest.\n\n[Prancha fonte/candidata](../generated/priority-review/pilares_identity_gate_v02.png). [Recibo, versões, hashes e prompts](../generated/pilares-resume/v01/identity-gate-receipt.json). [Prompt v02](../generated/pilares-resume/v01/identity-framing-v02-prompts-2026-10-08.json).\n\nAprovação humana da identidade pendente antes dos 25 quadros de ciclos. Nenhuma tira ou integração de Pilares realizada. Goranthis está concluído localmente (86 fontes/17 tiras, build e manifesto197 validados); [recibo anterior](../generated/goranthis-complete-build-validation-2026-10-08.json). Playtest humano separado e pendente. Retorno PLAN-071 e exceções visuais já aprovadas de Goranthis preservados.\n',encoding='utf-8')
for rel in ['.atena/state/plan.yaml','.atena/state/plan-053-imagens.yaml']:
    p=root/rel;t=p.read_text(encoding='utf-8-sig')
    t=t.replace('  status: GENERATING_IDENTITY','  status: AWAITING_OWNER_IDENTITY_APPROVAL',1)
    t=re.sub(r"  current: '[^\n]+","  current: 'S-006 Pilares: I01 Sintese Abissal v02 gerada e auditada; aguarda aprovacao humana da identidade.'",t,count=1)
    t=re.sub(r"  next: '[^\n]+","  next: 'Aprovar identidade v02 antes dos 25 quadros de ciclos; Goranthis completo localmente. Retorno PLAN-071 preservado.'",t,count=1)
    if rel.endswith('/plan.yaml'):
        t=t.replace('S-006/PILARES/IDENTITY-PILOT','S-006/PILARES/IDENTITY-APPROVAL')
        assert 'ranking_return_after_images:' in t
    else:
        t=t.replace('  status: GENERATING\n  generated: 0\n  selected_versions: {}','  status: AWAITING_OWNER_APPROVAL\n  generated: 1\n  candidate_versions: {I01: v02}\n  selected_versions: {}',1)
        t=re.sub(r"  review: '[^\n]+'","  review: '.atena/generated/priority-review/pilares_identity_gate_v02.png'",t,count=1)
        t=re.sub(r"  evidence: '[^\n]+'","  evidence: '.atena/evidence/pilares-identity-gate-2026-10-08.md'",t,count=1)
        assert '  goranthis:' in t and '  shendilavri:' in t and 'owner_reply: atena, aprovado, continue' in t
    p.write_text(t,encoding='utf-8')
p=root/'.atena/generated/CHATGPT-FILA-019-mobs-pilares.md';t=p.read_text(encoding='utf-8');t=t.replace('- [ ] gerada · [ ] aprovada — I01','- [x] gerada · [ ] aprovada — I01',1);t=re.sub(r'^status:.*','status: "identidade v02 gerada e auditada; aprovacao humana pendente antes de 25 ciclos"',t,count=1,flags=re.M);p.write_text(t,encoding='utf-8')
p=root/'.atena/generated/ART-PROMPTS-050-mobs-pilares.md';t=re.sub(r'^status:.*','status: "identidade v02 candidata, alfa/margens auditados; aguarda aprovacao humana antes dos ciclos"',p.read_text(encoding='utf-8'),count=1,flags=re.M);p.write_text(t,encoding='utf-8')
note='\n2026-10-08 — Pilares: I01 Sintese Abissal v02 candidata auditada, alfa nativo/limites/margens passaram; v01 preservada por margem insuficiente. Gate humano pendente antes de 25 ciclos, sem integração. Evidência pilares-identity-gate-2026-10-08.md. Goranthis completo localmente; retorno PLAN-071 preservado.\n'
for rel in ['.atena/evidence/EVID-145-fila-de-imagens-prioritaria-2026-10-02.md','.atena/specs/SPEC-121-retomada-fila-imagens/tasks.md']:
    p=root/rel;p.write_text(p.read_text(encoding='utf-8')+note,encoding='utf-8')
assert all((evidence.parent/target).resolve().is_file() for target in re.findall(r'\]\(([^)]+)\)',evidence.read_text(encoding='utf-8')))
assert not (root/'assets/animations/enemies/sintese_abissal').exists()
assert len(list(base.glob('sintese_abissal_*_v*.png')))==2
print('Pilares I01v02 audit passed; source/candidate review saved, links checked, persistent owner identity gate pending. Zero cycle frames generated.')
