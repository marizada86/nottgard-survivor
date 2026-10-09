from pathlib import Path
import json
import hashlib
import re

root = Path(__file__).resolve().parents[4]
directory = Path(__file__).parent
rows = json.loads((directory / 'candidate-audit-2026-10-07.json').read_text())
assert len(rows) == 5
for row in rows:
    assert hashlib.sha256((root / row['path']).read_bytes()).hexdigest() == row['sha256']
    assert not row['clipped']
    assert row['human_approval'] == 'pending'
records = json.loads((directory / 'prompts-and-results-2026-10-07.json').read_text())
assert len(records['calls']) == 4
assert records['cycles_generated'] == records['official_assets_installed'] == 0
evidence = root / '.atena/evidence/shendilavri-identities-resume-2026-10-07.md'
links = re.findall(r'\]\(([^)]+)\)', evidence.read_text(encoding='utf-8'))
assert len(links) == 7, links
for link in links:
    assert (evidence.parent / link).exists(), link
for actor in ['escravo_de_rivenheart', 'sucubo']:
    original = Path('F:/dev/nottgard-survivor/.atena/generated/art-candidates/enemies-shendilavri') / actor / f'{actor}_idle_00_v01.png'
    copied = root / '.atena/generated/art-candidates/enemies-shendilavri' / actor / original.name
    assert original.read_bytes() == copied.read_bytes()
print(f'PASS: 5 hashes, 4 generation calls, {len(links)} evidence links, 2 exact recovered originals; owner gate pending.')
