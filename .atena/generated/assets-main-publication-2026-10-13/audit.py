import hashlib
import json
import pathlib
import re
import subprocess
import zipfile

root = pathlib.Path(__file__).resolve().parents[3]
out = pathlib.Path(__file__).resolve().parent
base = '2ae8c48e2378eb9fa6a1cc75b3bc0fa50f37c096'
head = subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=root, text=True).strip()
changed = subprocess.check_output(['git', 'diff', '--name-only', base, head], cwd=root, text=True).splitlines()
tree = set(subprocess.check_output(['git', 'ls-tree', '-r', '--name-only', head], cwd=root, text=True).splitlines())
plan = json.loads((out / 'plan.json').read_text(encoding='utf-8-sig'))
assert not (set(plan['excluded_local_paths']) & tree) if 'excluded_local_paths' in plan else True
qa = [p for p in changed if any(x.startswith('qa-') for x in pathlib.PurePosixPath(p).parts)]
assert not qa, qa
runtime = [p for p in changed if p.startswith(('assets/', 'core/', 'ui/', 'tests/')) and p.endswith(('.png', '.gd'))]
hashes = {}
with zipfile.ZipFile(out / 'snapshot.zip') as archive:
    for p in runtime:
        archived = archive.read(p)
        extracted = (out / 'clean-checkout' / p).read_bytes()
        assert archived == extracted, p
        hashes[p] = hashlib.sha256(extracted).hexdigest()
assert len([p for p in runtime if p.endswith('.png')]) == 22
result = {'status': 'PASS', 'validated_commit': head, 'runtime_hashes': hashes, 'qa_files_published': qa,
          'artifact_paths_in_tree': all(p in tree for p in plan['artifact_paths']),
          'maximum_changed_blob_bytes': max((root / p).stat().st_size for p in changed if (root / p).is_file()),
          'whitespace_exception': 'Two blank-at-EOF warnings in recovered historical provenance markdown; original content preserved.',
          'human_playtest': 'PROCEDURE_NOT_REPORTED', 'canonical_promotion': False}
assert result['artifact_paths_in_tree']
links = []
for p in changed:
    if not p.endswith('.md') or not p.startswith(('.atena/evidence/', '.atena/specs/')):
        continue
    for target in re.findall(r'\]\(([^)]+)\)', (root / p).read_text(encoding='utf-8-sig')):
        if '://' in target or target.startswith('#'):
            continue
        target_path = ((root / p).parent / target.split('#')[0]).resolve()
        if not target_path.exists():
            raise AssertionError((p, target))
        rel = target_path.relative_to(root).as_posix()
        links.append({'document': p, 'target': rel, 'in_committed_tree': rel in tree or target_path.is_dir()})
result['links'] = links
result['local_only_link_targets'] = sorted(set(x['target'] for x in links if not x['in_committed_tree']))
(out / 'clean-audit.json').write_text(json.dumps(result, indent=2) + '\n', encoding='utf-8')
print(json.dumps({k: v for k, v in result.items() if k != 'runtime_hashes'}))
