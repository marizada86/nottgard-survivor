from pathlib import Path
import json
root=Path(__file__).resolve().parents[4];out=Path(__file__).parent
p=out/'qr-generation-jobs-2026-10-09.json';d=json.loads(p.read_text(encoding='utf-8'));peak=next(j for j in d['jobs'] if j['code']=='Q06');assert peak['status']=='GENERATED_VISUALLY_INSPECTED'
for j in d['jobs']:
 if j['code'] not in ['Q07','Q08']:continue
 assert j['status']=='PENDING' and len(j['referenced_image_paths'])==2
 j['referenced_image_paths'].append(str(root/peak['destination']))
 j['supporting_phase_reference']=dict(code='Q06',path=peak['destination'],sha256=peak['sha256'],role='Preceding generated impact peak, technical continuity only; not separately owner-approved')
 j['prompt']+='\n\nReference3 is the preceding GENERATED Q06 arcane IMPACT PEAK as technical phase-continuity support, not a separately human-approved frame. Preserve its exact center and arcane ring/glyph shape relationships while removing the solid white core and following the requested dim decay phase. The approved Q01 identity (reference1) and physical style pilot (reference2) remain authoritative. No flight tail. '
 if j['code']=='Q07':j['prompt']+='Expanding thin gray ring and broken glyph fragments beyond the old core, dimmer than Q06, black open center.'
 else:j['prompt']+='Almost black remnants: only a barely visible dark gray broken ring and sparse faint fragments, no white core or bright sparks.'
p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
print('Q07/Q08 technical peak reference added; original native sources unchanged.')
