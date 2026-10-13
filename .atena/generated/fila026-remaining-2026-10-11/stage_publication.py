from pathlib import Path
import subprocess

base=Path(__file__).parent
root=base.parents[2]
def git(*args, **kwargs):
    return subprocess.check_output(['git',*args],cwd=root,**kwargs)

paths=[
 '.atena/generated/ASSET-PRODUCTION-MANIFEST-001.json',
 '.atena/generated/CHATGPT-FILA-026-lettering-placas-e-cursor.md',
 '.atena/state/plan-065-lettering-cursor.yaml', '.atena/state/fila026-remaining.yaml',
 '.atena/vault/drafts/PLAN-065-lettering-e-cursor-2026-10-06.md',
 'data/cursor.json', 'assets/ui/title/logo.png', 'assets/ui/title/logo.png.import',
]
for folder in ['.atena/generated/fila026-l01-2026-10-11','.atena/generated/fila026-remaining-2026-10-11','assets/ui/lettering','assets/ui/cursor']:
    paths.extend(p.relative_to(root).as_posix() for p in (root/folder).rglob('*') if p.is_file() and p.name!='import.log')
paths.extend(p.relative_to(root).as_posix() for p in (root/'.atena/evidence').glob('fila026-*.md'))
paths.extend(p.relative_to(root).as_posix() for p in (root/'.atena/vault/canon').glob('ASSET-APPROVAL-FILA026-*.md'))
paths.append('.atena/vault/canon/ASSET-APPROVAL-REGISTER-031-fila026-admission-2026-10-11.json')
allowed=set(paths+['.atena/state/plan.yaml'])
staged=git('diff','--cached','--name-only').decode().splitlines()
assert set(staged).issubset(allowed), f'Unrelated staged files: {staged}'
git('add','--',*paths)
# Only stage the new FILA026 header. Keep the unrelated hero extraction state unstaged.
head=git('show','HEAD:.atena/state/plan.yaml').decode('utf-8').replace('\r\n','\n')
working=(root/'.atena/state/plan.yaml').read_text(encoding='utf-8')
marker='fila028_altar_correction_2026_10_10:\n'
assert working.count(marker)==head.count(marker)==1
planned=working.split(marker,1)[0]+marker+head.split(marker,1)[1]
blob=git('hash-object','-w','--stdin',input=planned.encode('utf-8')).decode().strip()
git('update-index','--cacheinfo',f'100644,{blob},.atena/state/plan.yaml')
staged=git('diff','--cached','--name-only').decode().splitlines()
assert set(staged).issubset(allowed)
assert 'hero-extraction-review' not in git('show',':.atena/state/plan.yaml').decode()
git('diff','--cached','--check')
print(f'Staged {len(staged)} FILA026 files; hero changes remain in the working tree.')
