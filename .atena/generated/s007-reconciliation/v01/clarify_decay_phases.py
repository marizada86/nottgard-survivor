from pathlib import Path
import json
p=Path(__file__).parent/'ef-generation-jobs-2026-10-09.json';d=json.loads(p.read_text(encoding='utf-8'))
notes={'E04':'PHASE CLARIFICATION: this is HOLD after the peak. Use the same full-radius single C-shaped radiant arc as approved E03, opening LEFT, bulging RIGHT, centered on the same pivot. Its white core must be clearly narrower and weaker, with ragged fading edges and substantially fewer tiny sparks than E03. The arc remains continuous but visibly thinning; do not duplicate the thick brilliant peak.','E05':'PHASE CLARIFICATION: this is FADE. Only disconnected broken fragments of the same C-shaped radiant arc remain, at the same full-radius positions as E03. Mostly DIM GRAY, no continuous bright white band, no fully intact crescent, few dim tiny particles. Clearly much weaker than the hold frame. Preserve the same pivot and right-facing arc layout.','E06':'PHASE CLARIFICATION: this is final DISSIPATE. The image is almost entirely pure BLACK. Only a few very faint DARK GRAY thin wisps and tiny specks remain where E03 had its right-facing C-shaped arc. Nothing bright, no white core, no intact crescent, no strong star glints. The same pivot and spatial layout must be preserved.'}
for j in d['jobs']:
 if j['code'] in notes:
  assert j['status']=='PENDING';j['prompt']+='\n'+notes[j['code']]
p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
