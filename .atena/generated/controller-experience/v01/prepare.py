from pathlib import Path
import hashlib
import json
import shutil

root = Path(__file__).resolve().parents[4]
output = Path(__file__).resolve().parent
recovery = output / 'recovery'
manifest = {}
for folder in ['core', 'ui', 'tests']:
    for source in (root / folder).rglob('*'):
        if source.suffix not in ['.gd', '.tscn']:
            continue
        relative = source.relative_to(root)
        target = recovery / relative
        if not target.exists():
            target.parent.mkdir(parents=True, exist_ok=True)
            shutil.copy2(source, target)
        manifest[str(relative)] = hashlib.sha256(target.read_bytes()).hexdigest()
(output / 'baseline-files.json').write_text(json.dumps(manifest, indent=2), encoding='utf-8')
print('Baseline preservada:', len(manifest), 'arquivos; sem descarte de alteracoes.')
