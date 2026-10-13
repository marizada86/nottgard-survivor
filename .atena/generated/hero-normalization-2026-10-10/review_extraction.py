"""Read-only raster analysis. Godot writes the proposed rectangular extracts."""
from pathlib import Path
from PIL import Image
import hashlib
import html
import json
import numpy as np

base = Path(__file__).parent
manifest = json.loads((base / 'manifest.json').read_text(encoding='utf-8'))
rows = []
for record in manifest['records']:
    source = base / record['local_source']
    assert hashlib.sha256(source.read_bytes()).hexdigest() == record['source_sha256']
    if record['status'] != 'PREPARATION_READY' or record['frames']:
        continue
    pixels = np.asarray(Image.open(source))
    alpha = pixels[:, :, 3]
    height, width = alpha.shape
    count = record['expected_frames']
    projection = (alpha > 8).sum(axis=0)
    cuts, boundaries = [0], []
    for index in range(1, count):
        start = max(1, int((index - .32) * width / count))
        stop = min(width - 1, int((index + .32) * width / count))
        zero_columns = np.flatnonzero(projection[start:stop] == 0) + start
        if len(zero_columns):
            runs = np.split(zero_columns, np.flatnonzero(np.diff(zero_columns) > 1) + 1)
            run = max(runs, key=len)
            cut = int(run[len(run) // 2])
        else:
            cut = start + int(projection[start:stop].argmin())
        cuts.append(cut)
        boundaries.append(dict(x=cut, pixels_alpha_gt_8=int(projection[cut]),
                               pixels_alpha_gt_128=int((alpha[:, cut] > 128).sum()),
                               pixels_alpha_gt_0=int((alpha[:, cut] > 0).sum())))
    cuts.append(width)
    safe = all(b['pixels_alpha_gt_8'] == 0 for b in boundaries)
    rows.append(dict(code=record['code'], source=record['local_source'],
                     source_sha256=record['source_sha256'], source_size=[width, height],
                     observed_poses=count, content_state='DRAFT', runtime_admission=False,
                     status='RECTANGULAR_EXTRACTION_CANDIDATE' if safe else 'HELD_UNSAFE_RECTANGULAR_SEPARATION',
                     review='Source inspected visually; boundaries checked numerically. No gait correction or regeneration.',
                     boundaries=boundaries,
                     frames=[dict(frame=i+1, rect=[cuts[i], 0, cuts[i+1]-cuts[i], height],
                                  path=f'extraction-review-2026-10-11/{record["code"]}/f{i+1:02}.png')
                             for i in range(count)] if safe else [],
                     body_landmarks='PENDING', feet_anchor='PENDING'))

result = dict(revision='DEV-024/v03/extraction-review-v01', date='2026-10-11',
              approval='Existing approved route: prepare other pieces, keep originals, hold ER03/ER06 before integration.',
              method='Read-only alpha projections plus visual source review; deterministic Godot rectangle extraction.',
              threshold=8, threshold_note='Low-alpha pixels are preserved; zero alpha>8 at a boundary is not proof of artistic quality.',
              reviewed_strips=len(rows), safe_rectangular_candidates=[r['code'] for r in rows if r['frames']],
              held=[r['code'] for r in rows if not r['frames']], prior_extractions=5,
              source_hashes_passed=True, content_state='DRAFT', runtime_admission=False,
              next='Body/feet landmarks for eleven extractable strips; review non-rectangular separation for five held strips. ER03/ER06 retain their earlier decisions.',
              records=rows)
assert len(rows) == 11
(base / 'extraction-review-v01.json').write_text(json.dumps(result, ensure_ascii=False, indent=2)+'\n', encoding='utf-8')
print(json.dumps({k:v for k,v in result.items() if k != 'records'}, ensure_ascii=False))
