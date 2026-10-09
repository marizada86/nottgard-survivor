from pathlib import Path
import json,re,sys
from datetime import datetime,timezone
root=Path(__file__).resolve().parents[4];out=Path(__file__).parent;assert '--visual-inspected' in sys.argv
p=out/'pulso-radiante-sequence-audit-2026-10-09.json';a=json.loads(p.read_text(encoding='utf-8'));assert a['status']=='PREPARED_FOR_SEQUENCE_VISUAL_REVIEW';rows=a['sources'];assert len(rows)==6
assert rows[2]['mean_luminance']>rows[3]['mean_luminance']>rows[4]['mean_luminance']>rows[5]['mean_luminance'];assert rows[1]['mean_luminance']>rows[0]['mean_luminance'];assert max(a['hot_centroid_spread_normalized'])<.04
extent=lambda r:r['visible_bbox_above12'][2]-r['visible_bbox_above12'][0]
assert extent(rows[0])<.25*extent(rows[2]) and extent(rows[0])<extent(rows[1])<.65*extent(rows[2])
a.update(status='COMPLETE_CANDIDATE_SEQUENCE_VISUALLY_REVIEWED',timestamp=datetime.now(timezone.utc).isoformat(),plan='PLAN-053',spec='SPEC-121',visual_inspected=True,visual_review='Six pulse frames: tiny centered spark and small ring, bright growing circle, approved maximum peak, near-maximum hold with thinning band and fewer rays, dim gray outer fragments, barely visible sparse remnants. Native sources and96px montage inspected; same centered flat circle and painted white-gray light style, no visible cuts.',human_gate_approval='.atena/generated/s007-reconciliation/v01/n03-owner-approval-2026-10-09.json',review='.atena/generated/s007-reconciliation/v01/pulso-radiante-six-frame-review-2026-10-09.png',preview_gif='.atena/generated/s007-reconciliation/v01/pulso-radiante-sequence-review-2026-10-09.gif',other_frames_human_approval='Not individually claimed',remaining_native_vfx_frames=66,next='M03 hourglass silence PEAK gate only',native_dimensions_note='Native bytes retained, technical normalization to1024 deferred')
p.write_text(json.dumps(a,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
for name in ['CHATGPT-FILA-022-vfx-projeteis-e-explosoes.md','ART-PROMPTS-053-vfx-projeteis-e-explosoes.md']:
 p=root/'.atena/generated'/name;t=p.read_text(encoding='utf-8-sig')
 if name.startswith('CHATGPT'):
  for r in rows:
   if r['code']=='N03':continue
   t,n=re.subn(r'(#### '+r['code']+r'[^\n]+\n\n)- \[ \] gerada[^\n]+',r'\g<1>- [x] gerada · [ ] aprovada · candidata: `'+r['path']+'` — revisada tecnicamente; N03 v01 aprovada como referência.',t);assert n==1,r['code']
  t=t.replace('pico aprovado pelo dono; continuação após commit/push solicitado.','pico aprovado pelo dono; referência das seis fases geradas/revisadas após commit881f133 publicado.')
 t=t.replace('N03 v01 pico aprovado; commit881f133 publicado e verificado; cinco demais N em geração; M03 pendente','Pulso radiante seis candidatas revisadas, N03 v01 aprovada; commit881f133 publicado e verificado; gerando somente M03 peak');p.write_text(t,encoding='utf-8')
for rel in ['.atena/state/plan.yaml','.atena/state/plan-053-imagens.yaml']:
 p=root/rel;t=p.read_text(encoding='utf-8-sig');m=re.search(r'\nactive_plan:\n(.*?)(?=\n\S|\Z)',t,re.S);assert m;b=m[1].replace('EXECUTING_N_REMAINING','EXECUTING_M_GATE').replace('S-007/VFX/FILA-022/N-REMAINING','S-007/VFX/FILA-022/M03');t=t[:m.start(1)]+b+t[m.end(1):]
 t=t.replace('S-007 N03 v01 aprovada; gerando cinco demais N e depois somente gate M03. Commit881f133 publicado e verificado.','S-007 pulso radiante seis candidatas revisadas; gerando somente gate M03 peak. Commit881f133 publicado e verificado.')
 t=t.replace('Revisar seis fontes do pulso radiante; devolver pico M03 ao dono. Retorno PLAN-071 preservado.','Devolver M03 peak ao dono antes dos cinco demais M. Retorno PLAN-071 preservado.')
 if rel.endswith('plan-053-imagens.yaml'):
  m=re.search(r'\nvfx_gate:\n(.*?)(?=\n\S|\Z)',t,re.S);assert m;b=m[1].replace('  generated: 1','  generated: 6');t=t[:m.start(1)]+b+t[m.end(1):]
 p.write_text(t,encoding='utf-8')
print(json.dumps(dict(status=a['status'],frames=6,remaining=66,next='M03 PEAK gate')))
