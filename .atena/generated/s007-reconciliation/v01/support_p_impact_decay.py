from pathlib import Path
import json,hashlib
root=Path(__file__).resolve().parents[4];out=Path(__file__).parent;p=out/'pq-generation-jobs-2026-10-09.json';d=json.loads(p.read_text(encoding='utf-8'))
peak=next(j for j in d['jobs'] if j['code']=='P06');assert peak['status']=='GENERATED_VISUALLY_INSPECTED';ref=root/peak['destination'];assert hashlib.sha256(ref.read_bytes()).hexdigest()==peak['sha256']
for j in d['jobs']:
 if j['code'] in ['P07','P08']:
  assert j['status']=='PENDING' and len(j['referenced_image_paths'])==2
  j['referenced_image_paths'].append(str(ref));j['supporting_phase_reference']=dict(code='P06',role='technical preceding impact phase; not individually owner-approved',path=peak['destination'],sha256=peak['sha256'])
  j['prompt']+='\nReference3 is the GENERATED P06 preceding impact peak, technically inspected but not individually owner-approved. It is a SUPPORTING PHASE REFERENCE for exact canvas-center position, impact painting texture, and spatial continuity only. Keep the approved P01 identity/style, but decay this P06 explosion: remove its solid white core entirely, let the round effect EXPAND into a thin dim fragmented ring slightly beyond the old round core. Do not shrink back to flight-orb size and do not copy the bright peak. Keep all fragments, ring and specks inside black margins. Follow the dimness and fragmentation specified for '+j['code']+'.'
p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
print('P07/P08 supporting phase reference saved; approved P01 and pilot references retained.')
