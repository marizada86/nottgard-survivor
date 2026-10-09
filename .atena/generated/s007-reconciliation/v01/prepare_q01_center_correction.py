from pathlib import Path
import json
root=Path(__file__).resolve().parents[4]
p=Path(__file__).parent/'pq-generation-jobs-2026-10-09.json'
d=json.loads(p.read_text(encoding='utf-8'))
j=next(x for x in d['jobs'] if x['code']=='Q01')
assert j['status']=='REJECTED_VISUAL' and j['version']=='v01'
prior=dict(j)
reason='Native Q01 v01 ring/core visually displaced right of canvas center, approximately 5 percent of canvas width; preserve native source and correct with imagegen.'
d.setdefault('rejected_native_versions',[]).append(dict(**prior,rejection_reason=reason))
new={k:v for k,v in j.items() if k in ['code','effect','name','transparent_background','source_queue']}
new.update(version='v02',status='PENDING',destination='.atena/generated/art-candidates/vfx/orbe_arcano/orbe_arcano_fly_00_v02.png',referenced_image_paths=[str(root/prior['destination']),str(root/'.atena/generated/s007-reconciliation/v01/approved-pilot-A03-v02-reference.png')],correction_reason=reason,reference_roles=['Q01 v01 unapproved native geometry to correct','A03 v02 approved style reference'],prompt='Edit the FIRST attached image (Q01 v01 arcane orb); the SECOND attachment is the approved white/gray painted glow STYLE reference only. Produce ONE corrected first-flight arcane orb frame, never a contact sheet. Preserve its compact dense bright white core, thin circular ring with tiny abstract circular glyph marks, wispy smoky trail extending LEFT for RIGHTWARD flight, hand-painted white/gray glow, pure black background, flat top-down view and circular ring seen face-on.\n\nCRITICAL POSITION CORRECTION: the first image has the core and ring noticeably too far RIGHT. Move the entire effect approximately 60 pixels LEFT on the same square canvas. Put the geometric CENTER of the bright core AND the surrounding ring at EXACT CANVAS CENTER (50 percent width, 50 percent height). The trailing smoke is asymmetric and extends left, so do NOT center the bounding box of the whole effect. Center the ORB CORE AND RING themselves. Preserve their circular shape and scale; preserve the smoky tail relative to the orb. Generous black margins and all particles/glow inside. Requested1024x1024 square, core and ring center at512,512; if native size differs, use exact50 percent center. No color, readable text, character, weapon, hand, scene, border, ground or perspective. Only fix centered placement; do not change the design into a radiant orb or crescent.')
assert not (root/new['destination']).exists()
d['jobs'][d['jobs'].index(j)]=new
p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
print(json.dumps(new,ensure_ascii=False))
