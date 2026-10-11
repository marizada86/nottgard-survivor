"""Explicitly approved FILA-026 code checkpoint; stage only the reviewed scope."""
import fnmatch
import json
from pathlib import Path
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[3]
OUT = Path(__file__).resolve().parent
REPLY = 'atena, commit e vamos criar as proximas imagens'

def git(*args, **kwargs):
    return subprocess.check_output(['git', *args], cwd=ROOT, **kwargs)

def read(path):
    return (ROOT / path).read_text(encoding='utf-8-sig')

def write(path, text):
    (ROOT / path).write_text(text, encoding='utf-8')

if len(sys.argv) > 1 and sys.argv[1] == 'receipt':
    commit = git('rev-parse', 'HEAD').decode().strip()
    assert git('show', '-s', '--format=%s', commit).decode().strip() == 'feat(ui): integrate approved lettering across game screens'
    receipt = {'status': 'LOCAL_COMMIT_VERIFIED', 'authorization': REPLY, 'commit': commit, 'branch': git('branch', '--show-current').decode().strip(), 'push': 'NOT_REQUESTED_NOT_EXECUTED', 'build': 'NOT_REQUESTED_NOT_EXECUTED', 'remaining': 'HUMAN_PLAYTEST_PENDING', 'files': git('show', '--format=', '--name-only', commit).decode().splitlines()}
    (OUT / 'commit-receipt.json').write_text(json.dumps(receipt, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
    for path in ['.atena/state/fila026-remaining.yaml', '.atena/state/plan-065-lettering-cursor.yaml', '.atena/state/plan.yaml']:
        text = read(path)
        if path.endswith('/plan.yaml'):
            prefix, tail = text.split('fila026_l01_2026_10_11:', 1)
        else:
            prefix, tail = text, None
        prefix = prefix.replace('S016_COMMIT_AUTHORIZED', 'IMPLEMENTED_LOCAL_COMMITTED_PENDING_PLAYTEST').replace('CODE_COMMIT_AUTHORIZED', 'LOCAL_COMMIT_VERIFIED_PENDING_PLAYTEST')
        prefix = prefix.replace('completed_steps: 15', 'completed_steps: 16').replace('completed_step_positions: 15', 'completed_step_positions: 16')
        prefix += ('  ' if path.endswith('/plan.yaml') else ('  ' if path.endswith('plan-065-lettering-cursor.yaml') else '')) + 'code_commit: ' + commit + '\n'
        write(path, prefix + ('fila026_l01_2026_10_11:' + tail if tail is not None else ''))
    print('Local code commit verified: ' + commit + '; receipt/state updated locally; no push')
    sys.exit(0)

prior_staged = set(git('diff', '--cached', '--name-only').decode().splitlines())
for path in ['.atena/state/fila026-remaining.yaml', '.atena/state/plan-065-lettering-cursor.yaml', '.atena/state/plan.yaml']:
    text = read(path)
    if path.endswith('/plan.yaml'):
        prefix, tail = text.split('fila026_l01_2026_10_11:', 1)
    else:
        prefix, tail = text, None
    prefix = prefix.replace('S016_PREPARED_WAITING_CODE_COMMIT', 'S016_COMMIT_AUTHORIZED').replace('CODE_COMMIT_PENDING_EXPLICIT_APPROVAL', 'CODE_COMMIT_AUTHORIZED')
    prefix = prefix.replace('code_commit_authorization: PENDING_EXPLICIT_OWNER_APPROVAL', 'code_commit_authorization: APPROVED_EXPLICITLY_2026_10_11')
    indent = '  ' if path.endswith('/plan.yaml') or path.endswith('plan-065-lettering-cursor.yaml') else ''
    if 'code_commit_owner_reply:' not in prefix:
        prefix += indent + 'code_commit_owner_reply: ' + json.dumps(REPLY, ensure_ascii=False) + '\n'
    write(path, prefix + ('fila026_l01_2026_10_11:' + tail if tail is not None else ''))
evidence = '.atena/evidence/fila026-integration-2026-10-11.md'
text = read(evidence)
if 'Commit local separado autorizado explicitamente' not in text:
    text += '\n2026-10-11 — Commit local separado autorizado explicitamente com **“' + REPLY + '”**. Checkpoint em execução; receipt e SHA só serão registrados após o Git confirmar o commit. Sem autorização nova de push ou build.\n'
write(evidence, text)
proposal = json.loads((OUT / 'commit-proposal.json').read_text(encoding='utf-8'))
proposal['status'] = 'LOCAL_COMMIT_APPROVED_EXPLICITLY'
proposal['authorization'] = REPLY
(OUT / 'commit-proposal.json').write_text(json.dumps(proposal, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
audit = json.loads((OUT / 'audit.json').read_text(encoding='utf-8'))
audit['publication']['code_commit'] = 'AUTHORIZED_EXPLICITLY_PENDING_GIT_EXECUTION'
audit['publication']['authorization'] = REPLY
(OUT / 'audit.json').write_text(json.dumps(audit, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
paths = proposal['tracked_whitelist']
log_dir = OUT / 'tracked-logs'
log_dir.mkdir(exist_ok=True)
for path in OUT.glob('*.log'):
    (log_dir / path.with_suffix('.txt').name).write_bytes(path.read_bytes())
text = read(evidence)
for path in OUT.glob('*.log'):
    text = text.replace('fila026-integration-2026-10-11/' + path.name + ')', 'fila026-integration-2026-10-11/tracked-logs/' + path.with_suffix('.txt').name + ')')
write(evidence, text)
paths += [p.relative_to(ROOT).as_posix() for p in OUT.rglob('*') if p.is_file() and not any(fnmatch.fnmatch(p.name, pattern) for pattern in proposal['exclude_generated_temporary_profiles']) and p.name != 'commit-receipt.json' and p.suffix != '.log']
allowed = set(paths + ['.atena/state/plan.yaml'])
assert prior_staged.issubset(allowed), 'Unexpected index content outside reviewed scope'
git('add', '--', *paths)
head = git('show', 'HEAD:.atena/state/plan.yaml').decode('utf-8-sig')
working = read('.atena/state/plan.yaml')
marker = 'fila026_l01_2026_10_11:\n'
assert working.count(marker) == head.count(marker) == 1
planned = working.split(marker, 1)[0] + marker + head.split(marker, 1)[1]
blob = git('hash-object', '-w', '--stdin', input=planned.encode('utf-8')).decode().strip()
git('update-index', '--cacheinfo', '100644,' + blob + ',.atena/state/plan.yaml')
staged = git('diff', '--cached', '--name-only').decode().splitlines()
assert set(staged).issubset(allowed)
assert 'hero-extraction-review' not in git('show', ':.atena/state/plan.yaml').decode()
git('diff', '--cached', '--check')
for path in proposal['tracked_whitelist']:
    assert git('show', ':' + path).replace(b'\r\n', b'\n') == (ROOT / path).read_bytes().replace(b'\r\n', b'\n')
print('Staged reviewed FILA-026 code/evidence only: ' + str(len(staged)) + ' files; unrelated hero work preserved')
