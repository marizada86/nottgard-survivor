from pathlib import Path
import re,json,sys
root=Path(__file__).resolve().parents[4];out=Path(__file__).parent
state,index=sys.argv[1:3];base=root/'.atena/generated/art-candidates/enemies-pilares/sintese_abissal'
frames={}
for path in sorted(base.glob('sintese_abissal_*_v*.png')):
    m=re.match(r'sintese_abissal_(idle|move|attack|death|special)_(\d\d)_v(\d\d)\.png',path.name)
    if not m:continue
    key=f'{m[1]}_{m[2]}';frames.setdefault(key,[]).append(path.relative_to(root).as_posix())
generated=len(frames)-1;assert 0<=generated<=25
(out/'generation-progress.json').write_text(json.dumps({'new_frames_generated':generated,'remaining_new_frames':25-generated,'frames':frames},indent=2)+'\n',encoding='utf-8')
p=root/'.atena/state/plan-053-imagens.yaml';t=p.read_text(encoding='utf-8');assert 'GATE-PILARES-IDENTITY-V01' in t
t=re.sub(r'  cycles_generated: \d+',f'  cycles_generated: {generated}',t,count=1);t=re.sub(r'  remaining_new_frames: \d+',f'  remaining_new_frames: {25-generated}',t,count=1);p.write_text(t,encoding='utf-8')
p=root/'.atena/generated/CHATGPT-FILA-019-mobs-pilares.md';t=p.read_text(encoding='utf-8');t=t.replace(f'- [ ] `{state}_{int(index):02}`',f'- [x] `{state}_{int(index):02}`',1);p.write_text(t,encoding='utf-8')
print(f'Pilares source {state}_{int(index):02} recorded; {generated}/25 new frames preserved.')
