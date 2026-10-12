"""Stage exact approved paths and a reconciled plan without modifying the checkout."""
from pathlib import Path
import hashlib
import json
import subprocess
OUT = Path(__file__).resolve().parent
ROOT = OUT.parents[2]
def git(*args):
    return subprocess.check_output(['git', *args], cwd=ROOT).decode('utf-8')
s = json.loads((OUT/'selection.json').read_text(encoding='utf-8'))
assert git('rev-parse', 'HEAD').strip() == s['head_before']
assert not git('diff', '--cached', '--name-only')
assert hashlib.sha256((ROOT/'.atena/state/plan.yaml').read_bytes()).hexdigest() == s['working_plan_sha256']
paths = s['paths'] + [(OUT/'selection.json').relative_to(ROOT).as_posix()]
changed = set(git('diff', '--name-only').splitlines()) | set(git('ls-files', '--others', '--exclude-standard').splitlines())
expected = (set(paths) & changed) | {'.atena/state/plan.yaml'}
subprocess.run(['git', 'add', '--', *paths], cwd=ROOT, check=True)
blob = git('hash-object', '-w', '--path=.atena/state/plan.yaml', s['partial_index_source']).strip()
subprocess.run(['git', 'update-index', '--cacheinfo', '100644,'+blob+',.atena/state/plan.yaml'], cwd=ROOT, check=True)
actual = set(git('diff', '--cached', '--name-only').splitlines())
assert actual == expected, sorted(actual.symmetric_difference(expected))
subprocess.run(['git', 'diff', '--cached', '--check'], cwd=ROOT, check=True)
assert hashlib.sha256((ROOT/'.atena/state/plan.yaml').read_bytes()).hexdigest() == s['working_plan_sha256']
print(f'Staged and checked {len(actual)} scoped files. Working plan and unrelated changes preserved.')
