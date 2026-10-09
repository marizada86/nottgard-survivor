from pathlib import Path
import re
root=Path(__file__).resolve().parents[3]
for rel in ['.atena/state/plan.yaml','.atena/state/plan-053-imagens.yaml']:
 p=root/rel;t=p.read_text(encoding='utf-8-sig');m=re.search(r'\nimage_git_publication:\n(.*?)(?=\n\S|\Z)',t,re.S);assert m and 'status: PUBLISHED_VERIFIED' in m[1];b=re.sub(r'(  checkpoint: )[^\n]+',r'\g<1>DEV-006/S-001',m[1]);t=t[:m.start(1)]+b+t[m.end(1):];p.write_text(t,encoding='utf-8')
print('Completed publication checkpoint DEV-006/S-001 distinguished from active image cursor.')
