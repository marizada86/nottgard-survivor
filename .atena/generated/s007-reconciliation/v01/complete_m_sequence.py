from pathlib import Path
import json,re,sys
from datetime import datetime,timezone
root=Path(__file__).resolve().parents[4];out=Path(__file__).parent;assert '--visual-inspected' in sys.argv
p=out/'ampulheta-silencio-sequence-audit-2026-10-09.json';a=json.loads(p.read_text(encoding='utf-8'));assert a['status']=='PREPARED_FOR_SEQUENCE_VISUAL_REVIEW';rows=a['sources'];assert len(rows)==6
assert rows[2]['mean_luminance']>rows[3]['mean_luminance']>rows[4]['mean_luminance']>rows[5]['mean_luminance'];assert rows[1]['mean_luminance']>rows[0]['mean_luminance'];assert max(a['hot_centroid_spread_normalized'])<.04
extent=lambda r:r['visible_bbox_above12'][2]-r['visible_bbox_above12'][0]
assert extent(rows[0])<.25*extent(rows[2]) and extent(rows[0])<extent(rows[1])<.65*extent(rows[2])
a.update(status='COMPLETE_CANDIDATE_SEQUENCE_VISUALLY_REVIEWED',timestamp=datetime.now(timezone.utc).isoformat(),plan='PLAN-053',spec='SPEC-121',visual_inspected=True,visual_review='Six hourglass silence phases: tiny centered pinpoint and quiet ring, growing ring, approved maximum peak with hourglass motifs, near-maximum hold thinning with fewer grains, dim fragmented outer ring, barely visible sparse remnants. Native sources and96px montage inspected; same flat centered white-gray painted light, no visible clipping.',human_gate_approval='.atena/generated/s007-reconciliation/v01/m03-owner-approval-2026-10-09.json',review='.atena/generated/s007-reconciliation/v01/ampulheta-silencio-six-frame-review-2026-10-09.png',preview_gif='.atena/generated/s007-reconciliation/v01/ampulheta-silencio-sequence-review-2026-10-09.gif',other_frames_human_approval='Not individually claimed',remaining_native_vfx_frames=60,next='H103 Durvall Ruptura Sombria PEAK gate only',native_dimensions_note='Native bytes retained, technical normalization to1024 and geometric alignment deferred')
a['phase_radius_ratios_to_peak']={r['code']:r['bright_ring_radius_proxy_px']/rows[2]['bright_ring_radius_proxy_px'] for r in rows[:4]}
assert .40<=a['phase_radius_ratios_to_peak']['M02']<=.50,'Grow must approximate45%of peak; visual geometric review still required'
a['phase_radius_review']='M02 v03 bright-band proxy about49%of peak, approximating45%target within5percentage points; M03 inner painted band influences proxy. M04 proxy about101%with thinner lower glow. No exact geometric scaling claimed.'
a['owner_scale_exception']={'frame':'M01','version':'v02','owner_reply':'Aceitar M01 v02 como exceção de escala','receipt':'.atena/generated/s007-reconciliation/v01/m01-scale-owner-approval-2026-10-09.json','note':'Initial radius roughly14%visually instead of target10%; proxy below is a measurement, not geometric exactness.'}
p.write_text(json.dumps(a,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
for name in ['CHATGPT-FILA-022-vfx-projeteis-e-explosoes.md','ART-PROMPTS-053-vfx-projeteis-e-explosoes.md']:
 p=root/'.atena/generated'/name;t=p.read_text(encoding='utf-8-sig')
 if name.startswith('CHATGPT'):
  for r in rows:
   if r['code']=='M03':continue
   mark='[a]' if r['code']=='M01' else '[ ]';note='exceção de escala v02 aceita explicitamente pelo dono; M03 v01 referência.' if r['code']=='M01' else 'revisada tecnicamente; M03 v01 aprovada como referência.'
   t,n=re.subn(r'(#### '+r['code']+r'[^\n]+\n\n)- \[ \] gerada[^\n]+',r'\g<1>- [x] gerada · '+mark+' aprovada · candidata: `'+r['path']+'` — '+note,t);assert n==1,r['code']
 t,n=re.subn(r'^status: [^\n]+','status: "FILA02236/36 candidatas geradas e revisadas; M03 v01 aprovada; próximo gate H103 FILA023; integração pendente"',t,count=1,flags=re.M);assert n==1;p.write_text(t,encoding='utf-8')
for rel in ['.atena/state/plan.yaml','.atena/state/plan-053-imagens.yaml']:
 p=root/rel;t=p.read_text(encoding='utf-8-sig');m=re.search(r'\nactive_plan:\n(.*?)(?=\n\S|\Z)',t,re.S);assert m;b=m[1].replace('EXECUTING_M_REMAINING','EXECUTING_H_GATE').replace('S-007/VFX/FILA-022/M-REMAINING','S-007/VFX/FILA-023/H103');t=t[:m.start(1)]+b+t[m.end(1):]
 m=re.search(r'\nplan_cursor:\n(.*?)(?=\n\S|\Z)',t,re.S);assert m;b=re.sub(r'^  current: [^\n]+',"  current: 'S-007 FILA02236/36 candidatas revisadas; ampulheta seis fases, M03 aprovada; gerando somente H103 Durvall.'",m[1],flags=re.M);b=re.sub(r'^  next: [^\n]+',"  next: 'Devolver H103 ao dono antes dos cinco demais Durvall. Retorno PLAN071 B006/S011 preservado.'",b,flags=re.M);t=t[:m.start(1)]+b+t[m.end(1):]
 t=t.replace('S-007 pulso radiante completo como candidata; aguardando gate humano M03. PLAN-071 preservado.','S-007 FILA02236/36 candidatas completas; gerando gate H103 FILA023. PLAN-071 preservado.')
 if rel.endswith('plan-053-imagens.yaml'):
  m=re.search(r'\nvfx_gate:\n(.*?)(?=\n\S|\Z)',t,re.S);assert m and 'frame: M03' in m[1];b=m[1].replace('  generated: 1','  generated: 6');t=t[:m.start(1)]+b+t[m.end(1):]
 p.write_text(t,encoding='utf-8')
print(json.dumps(dict(status=a['status'],frames=6,remaining=60,phase_radius_ratios=a['phase_radius_ratios_to_peak'],next='H103 PEAK gate')))
