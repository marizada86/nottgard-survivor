"""Strengthen the already approved framing constraint after NP04 native margin failure."""
import json
from pathlib import Path
OUT = Path(__file__).resolve().parent
data = json.loads((OUT/'jobs.json').read_text(encoding='utf-8'))
extra = '\nFraming priority: zoom out. One SMALL complete figure in a spacious square transparent canvas. Its visible height must be ONLY 60 percent of canvas height, with roughly 20 percent genuinely empty transparent canvas above the highest hair and below the lowest boot/pole. Never fill the frame. Keep the entire subject including every accessory within x=20..80 percent and y=20..80 percent. No element approaches an edge.'
for job in data['jobs'][1:]:
    assert 'sha256' not in job
    job['prompt'] = job['prompt'].replace('65-70 percent', '60 percent').replace('at least 15 percent empty', 'at least 20 percent empty')+extra
data['framing_refinement'] = 'After NP04 v01 returned 4.78% margins, reinforce only the existing full-body/transparent margin invariant for remaining calls; no identity/style/scope change.'
(OUT/'jobs.json').write_text(json.dumps(data,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
(OUT/'prompts.md').write_text('# ART-032 lote 02 — prompts efetivos DRAFT\n\n'+'\n\n'.join('## '+j['code']+' '+j['title']+' '+j['revision']+'\n\n```text\n'+j['prompt']+'\n```' for j in data['jobs'])+'\n\n## Histórico\n\n'+'\n\n'.join(j['code']+' '+j['revision']+'\n\n```text\n'+j['prompt']+'\n```' for j in data['previous_native_versions'])+'\n',encoding='utf-8')
print('Remaining prompts updated only for stronger empty-margin framing; NP04 v01 history and v02 preserved.')
