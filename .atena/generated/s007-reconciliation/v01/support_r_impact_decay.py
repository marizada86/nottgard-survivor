from pathlib import Path
import json
root=Path(__file__).resolve().parents[4];out=Path(__file__).parent
p=out/'rn-generation-jobs-2026-10-09.json';d=json.loads(p.read_text(encoding='utf-8'));peak=next(j for j in d['jobs'] if j['code']=='R06');assert peak['status']=='GENERATED_VISUALLY_INSPECTED'
for j in d['jobs']:
 if j['code'] not in ['R07','R08']:continue
 assert j['status']=='PENDING' and len(j['referenced_image_paths'])==2
 j['referenced_image_paths'].append(str(root/peak['destination']))
 j['supporting_phase_reference']=dict(code='R06',path=peak['destination'],sha256=peak['sha256'],role='Preceding generated impact peak, technical continuity only; not separately owner-approved')
 j['prompt']+='\n\nReference3 is the preceding GENERATED R06 cutting-wave IMPACT PEAK as technical phase-continuity support, not separately human-approved. Preserve its exact center and fragmented blade-energy texture while removing ALL solid white core and following requested dim decay phase. Approved R01 identity (reference1) and physical style pilot (reference2) remain authoritative. No intact flying crescent, tail, glyphs or orb motifs. '
 if j['code']=='R07':j['prompt']+='Thin expanding GRAY broken ring and dim blade-energy fragments with fading fine electric filaments, clearly dimmer than R06, open black center.'
 else:j['prompt']+='Almost black remnants: barely visible dark gray broken ring and sparse faint fragments. No white core, bright lightning or bright sparks.'
p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
print('R07/R08 technical peak reference added; native sources unchanged.')
