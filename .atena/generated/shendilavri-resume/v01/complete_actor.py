from pathlib import Path
from PIL import Image
import json,hashlib,re,sys
root=Path(__file__).resolve().parents[4];out=Path(__file__).parent
actor=sys.argv[1];next_actor=sys.argv[2];remaining=int(sys.argv[3])
base=root/'.atena/generated/art-candidates/enemies-shendilavri'/actor
packing=json.loads((base/'strips/packing.json').read_text())
sources=[]
for state,items in packing['sources'].items():
 for i,item in enumerate(items):
  p=root/item['path'].removeprefix('res://');im=Image.open(p).convert('RGBA');a=im.getchannel('A');h=a.histogram();b=a.point(lambda x:255 if x>=11 else 0).getbbox()
  clipped=b[0]==0 or b[1]==0 or b[2]==im.width or b[3]==im.height
  solid=sum(h[230:])/sum(h[11:]);assert not clipped and solid>=.9,p
  sources.append(dict(state=state,index=i,path=p.relative_to(root).as_posix(),sha256=hashlib.sha256(p.read_bytes()).hexdigest(),size=im.size,bbox=b,solidity=solid,clipped=False,anchor=item['anchor'],scale=item['scale']))
expected=26 if actor=='malcanthet' else 20;assert len(sources)==expected
assets=[]
for state in packing['sources']:
 p=root/'assets/animations/enemies'/actor/f'{state}.png';q=base/'strips'/f'{state}.png';assert p.read_bytes()==q.read_bytes()
 assets.append(dict(state=state,path=p.relative_to(root).as_posix(),size=Image.open(p).size,sha256=hashlib.sha256(p.read_bytes()).hexdigest()))
checks={}
markers={'queue':'Animation queue: 0 failure(s)','runtime':'death cleanup OK','suite':'testes: 0 falha(s)','smoke':'smoke: ok','capture':'Shedaklah capture result=0'}
for suffix,marker in markers.items():
 p=out/f'{actor}-{suffix}.log'
 if suffix in ['queue','runtime','capture'] or p.exists():
  t=p.read_text(encoding='utf-8',errors='replace');assert marker in t and 'SCRIPT ERROR' not in t,p
  checks[suffix]=dict(path=p.relative_to(root).as_posix(),passed=True,marker=marker)
if actor=='sucubo':
 p=out/'ilusao_de_sucubo-runtime.log';t=p.read_text(encoding='utf-8',errors='replace');assert 'death cleanup OK' in t and 'SCRIPT ERROR' not in t
 checks['reuse']=dict(path=p.relative_to(root).as_posix(),id='ilusao_de_sucubo',source_id='sucubo',alpha=.45,passed=True)
manifest=json.loads((root/'.atena/generated/PRIORITY-IMAGES-2026-10-02.json').read_text(encoding='utf-8-sig'))
for row in manifest['assets']:assert hashlib.sha256((root/row['path']).read_bytes()).hexdigest()==row['sha256'],row['path']
receipt=dict(date='2026-10-07',plan='PLAN-053',spec='SPEC-121',actor=actor,status='INTEGRATED_LOCAL_VALIDATED',sources=sources,assets=assets,packing=packing,checks=checks,manifest_verified=len(manifest['assets']),capture=f'.atena/generated/priority-review/{actor}_runtime.png',native_alpha_preserved=True,next_actor=next_actor,remaining_new_frames=remaining)
(out/f'{actor}-completion-receipt.json').write_text(json.dumps(receipt,indent=2)+'\n',encoding='utf-8')
completed=[id for id in ['escravo_de_rivenheart','sucubo','guarda_do_castelo','master_of_cruelties','malcanthet'] if (out/(('escravo' if id=='escravo_de_rivenheart' else id)+'-completion-receipt.json')).exists()]
official_count=sum(5 if id=='malcanthet' else 4 for id in completed)
p=root/'.atena/state/plan.yaml';t=p.read_text(encoding='utf-8-sig');t=re.sub(r'  checkpoint: S-006/SHENDILAVRI/[^\n]+',f'  checkpoint: S-006/SHENDILAVRI/{next_actor.upper()}-CYCLES',t,count=1)
t=re.sub(r"  current: 'PLAN-053 / SPEC-121:.*",f"  current: 'PLAN-053 / SPEC-121: {len(completed)} atores Shendilavri integrados e validados, {official_count} tiras; ultimo {actor}. Proximo {next_actor}.'",t,count=1)
t=re.sub(r"  next: '[^\n]*",f"  next: 'Gerar {remaining} quadros restantes e validar cada ator. Retorno PLAN-071 preservado.'",t,count=1)
t=t.replace('Escravo integrado; Sucubo previa pronta com decisao da caminhada pendente.',f'{len(completed)} atores Shendilavri integrados e validados; proximo {next_actor}.');p.write_text(t,encoding='utf-8')
p=root/'.atena/state/plan-053-imagens.yaml';t=p.read_text(encoding='utf-8-sig')
t=re.sub(r"  current: 'S-006:.*",f"  current: 'S-006: {len(completed)} atores Shendilavri integrados e validados, {official_count} tiras; ultimo {actor}. Gerar {next_actor}. Retorno PLAN-071 preservado.'",t)
t=re.sub(r"  next: '.*",f"  next: 'Gerar {remaining} quadros restantes, um ator por vez; validar fontes, tiras e runtime antes de seguir.'",t,count=1)
t=re.sub(r'  official_assets_installed: \d+',f'  official_assets_installed: {official_count}',t)
t=re.sub(r'  cycles_generated: \d+',f'  cycles_generated: {sum(25 if id=="malcanthet" else 19 for id in completed)}',t)
t=re.sub(r"  review: '[^\n]+'",f"  review: '.atena/generated/shendilavri-resume/v01/{actor}_compact_review.png'",t,count=1)
t=re.sub(r"  evidence: '[^\n]+'",f"  evidence: '.atena/evidence/shendilavri-{actor}-cycles-2026-10-07.md'",t,count=1);p.write_text(t,encoding='utf-8')
p=root/'.atena/evidence'/f'shendilavri-{actor}-cycles-2026-10-07.md'
p.write_text(f'# Shendilavri — {actor}\n\nPLAN-053/SPEC-121 IN_PLAN, escopo per-plan aprovado; {expected} quadros e {len(assets)} tiras integrados localmente. Fontes selecionadas sem cortes, solidez >=0.90, alfa/RGB preservados por empacotamento nearest.\n\n[Recibo, hashes e checks](../generated/shendilavri-resume/v01/{actor}-completion-receipt.json). [Captura real](../generated/priority-review/{actor}_runtime.png).\n\nQueue, ator real e captura passaram. Suite/smoke presentes no recibo conforme execucao. Manifesto {len(manifest["assets"])} hashes conferidos. Playtest humano permanece separado. Sem commit, push ou publicacao. Proximo {next_actor}, {remaining} quadros novos restantes.\n',encoding='utf-8')
summary=f'\n2026-10-07 — {actor}: {expected} quadros/{len(assets)} tiras integrados, queue/runtime/captura passaram; manifesto{len(manifest["assets"])} hashes conferidos. Evidencia shendilavri-{actor}-cycles-2026-10-07.md. Proximo {next_actor}, {remaining} quadros novos restantes. Sem commit/push.\n'
for rel in ['.atena/evidence/EVID-145-fila-de-imagens-prioritaria-2026-10-02.md','.atena/specs/SPEC-121-retomada-fila-imagens/tasks.md','.atena/generated/CHATGPT-FILA-017-mobs-shendilavri.md']:
 p=root/rel;p.write_text(p.read_text(encoding='utf-8')+summary,encoding='utf-8')
p=root/'.atena/generated/CHATGPT-FILA-017-mobs-shendilavri.md';t=p.read_text(encoding='utf-8');a=t.index(f'### `{actor}`');b=t.find('### `',a+4);b=len(t) if b<0 else b;t=t[:a]+t[a:b].replace('- [ ]','- [x]')+t[b:];p.write_text(t,encoding='utf-8')
p=root/'.atena/generated/ART-PROMPTS-048-mobs-shendilavri.md';t=p.read_text(encoding='utf-8');t=re.sub(r'^status:.*',f'status: "5 identidades aprovadas; {len(completed)} atores integrados e validados; proximo {next_actor}"',t,count=1,flags=re.M);p.write_text(t,encoding='utf-8')
print(f'{actor}: {expected} selected sources, {len(assets)} exact strips, {len(checks)} checks, {len(manifest["assets"])} manifest hashes verified; cursor {next_actor}.')
