"""Copy native output byte-for-byte, inspect pixels read-only, and persist provenance."""
import hashlib
import json
from pathlib import Path
import shutil
import sys
from datetime import datetime, timezone
import numpy as np
from PIL import Image

ROOT = Path(__file__).resolve().parents[3]
OUT = Path(__file__).resolve().parent
code, original = sys.argv[1:3]
jobs_path = OUT / 'jobs.json'
data = json.loads(jobs_path.read_text(encoding='utf-8'))
assert data['approval'] == 'APPROVED_PER_PLAN'
job = next(j for j in data['jobs'] if j['code'] == code)
if len(sys.argv) > 3:
    version = sys.argv[3]
    assert code == 'NP01' and version == 'v02'
    previous = json.loads(json.dumps(job))
    previous['status'] = 'PRESERVED_NOT_SELECTED_FOR_MARGIN'
    previous['reason'] = 'Original lower visible margin 70/1254 px (5.58%), below requested 10%; native targeted framing correction'
    data.setdefault('previous_native_versions', []).append(previous)
    job['revision'] = version
    job['destination'] = job['destination'].replace('_v01.png', '_v02.png')
    job['prompt'] = (OUT / 'correction-NP01-v02.txt').read_text(encoding='utf-8').strip()
    job['references'] = [previous['destination']]
    job['correction_of'] = previous['sha256']
if code in ['NP02', 'NP03']:
    extra = '\nPrioritize generous empty transparent margins: all figure parts remain strictly in the middle 70 percent of the canvas, with head below y=15 percent and feet above y=85 percent. Nothing near any outer edge.'
    if extra not in job['prompt']:
        job['prompt'] += extra
source = Path(original)
destination = ROOT / job['destination']
assert not destination.exists(), 'Do not overwrite generated versions'
destination.parent.mkdir(parents=True, exist_ok=True)
shutil.copyfile(source, destination)
def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()
assert sha(source) == sha(destination)
with Image.open(destination) as image:
    mode, size = image.mode, image.size
    rgba = np.asarray(image.convert('RGBA'))
alpha = rgba[:,:,3]
ys, xs = np.where(alpha > 8)
assert len(xs) > 0
bbox = [int(xs.min()), int(ys.min()), int(xs.max()) + 1, int(ys.max()) + 1]
margins = [bbox[0], bbox[1], size[0] - bbox[2], size[1] - bbox[3]]
edge = np.concatenate([alpha[0,:], alpha[-1,:], alpha[:,0], alpha[:,-1]])
inspection = {'dimensions': list(size), 'mode': mode, 'visible_bbox_alpha_above8': bbox, 'margins_px': margins, 'minimum_margin_fraction': min(margins) / max(size), 'transparent_fraction': float(np.mean(alpha == 0)), 'semi_transparent_pixels': int(np.sum((alpha > 0) & (alpha < 255))), 'border_max_alpha': int(edge.max()), 'border_exactly_empty': int(edge.max()) == 0, 'alpha_genuine': mode == 'RGBA' and float(np.mean(alpha == 0)) > .1, 'no_visible_border_clipping_alpha_above8': int(edge.max()) <= 8, 'requested_10_percent_margin_met': all(margins[i] >= size[i%2] * .1 for i in range(4)), 'native_bytes_preserved': True}
job.update({'status': 'GENERATED_PENDING_VISUAL_AUDIT', 'original_path': str(source), 'generated_at_utc': datetime.now(timezone.utc).isoformat(), 'tool': 'built-in image_gen', 'sha256': sha(destination), 'inspection': inspection})
data['generated'] = sum('sha256' in j for j in data['jobs'])
jobs_path.write_text(json.dumps(data, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
(OUT / 'prompts.md').write_text('# ART-032 · prompts DRAFT v01, João corrigido v02\n\n' + '\n\n'.join('## ' + j['code'] + ' · ' + j['name'] + ' · ' + j['revision'] + '\n\n```text\n' + j['prompt'] + '\n```' for j in data['jobs']) + '\n\n## Histórico\n\n' + '\n\n'.join(j['code'] + ' ' + j['revision'] + '\n\n```text\n' + j['prompt'] + '\n```' for j in data.get('previous_native_versions', [])) + '\n', encoding='utf-8')
for path in [ROOT / '.atena/state/art032-npcs-piloto.yaml', ROOT / '.atena/state/plan.yaml']:
    text = path.read_text(encoding='utf-8')
    if path.name == 'plan.yaml':
        prefix, tail = text.split('fila026_remaining_2026_10_11:',1)
    else:
        prefix, tail = text, None
    import re
    prefix = re.sub(r'(?m)^(\s*)generated: \d+$', lambda m: m.group(1) + 'generated: ' + str(data['generated']), prefix)
    path.write_text(prefix + ('fila026_remaining_2026_10_11:' + tail if tail is not None else ''), encoding='utf-8')
print(json.dumps({'code': code, 'saved': job['destination'], 'sha256': job['sha256'], 'inspection': inspection}, ensure_ascii=False))
