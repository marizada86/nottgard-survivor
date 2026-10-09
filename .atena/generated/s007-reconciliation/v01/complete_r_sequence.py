from pathlib import Path
import json,re,sys
from datetime import datetime,timezone
root=Path(__file__).resolve().parents[4];out=Path(__file__).parent
assert '--visual-inspected' in sys.argv
ap=out/'onda-cortante-sequence-audit-2026-10-09.json';a=json.loads(ap.read_text(encoding='utf-8'));assert a['status']=='PREPARED_FOR_SEQUENCE_VISUAL_REVIEW'
rows=a['sources'];assert len(rows)==8
assert rows[5]['mean_luminance']>rows[4]['mean_luminance'] and rows[5]['mean_luminance']>rows[6]['mean_luminance']>rows[7]['mean_luminance']
assert max(a['flight_centroid_spread_normalized'])<.04,'Inspect flight position drift before completion'
a.update(status='COMPLETE_CANDIDATE_SEQUENCE_VISUALLY_REVIEWED',timestamp=datetime.now(timezone.utc).isoformat(),plan='PLAN-053',spec='SPEC-121',visual_inspected=True,visual_review='Four flight frames preserve the right-facing crescent and leftward tapered tips with fine jagged lightning; light/internal texture changes and R04-R01 closure reviewed. Four centered impacts have no intact flying crescent or tail: compact start, brightest peak R06, dim expanding fragmented ring, faint remnants. Native sources and96px montage inspected; no visible edge cuts.',human_gate_approval='.atena/generated/s007-reconciliation/v01/r01-owner-approval-2026-10-09.json',review='.atena/generated/s007-reconciliation/v01/onda-cortante-eight-frame-review-2026-10-09.png',preview_gifs=['.atena/generated/s007-reconciliation/v01/onda-cortante-flight-review-2026-10-09.gif','.atena/generated/s007-reconciliation/v01/onda-cortante-impact-review-2026-10-09.gif'],other_frames_human_approval='Not individually claimed',remaining_native_vfx_frames=72,next='N03 radiant pulse PEAK gate only',native_dimensions_note='Native square bytes retained; technical normalization to1024 deferred')
ap.write_text(json.dumps(a,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
for name in ['CHATGPT-FILA-022-vfx-projeteis-e-explosoes.md','ART-PROMPTS-053-vfx-projeteis-e-explosoes.md']:
 p=root/'.atena/generated'/name;t=p.read_text(encoding='utf-8-sig')
 if name.startswith('CHATGPT'):
  for row in rows[1:]:
   t,n=re.subn(r'(#### '+row['code']+r'[^\n]+\n\n)- \[ \] gerada[^\n]+',r'\g<1>- [x] gerada · [ ] aprovada · candidata: `'+row['path']+'` — revisada tecnicamente; R01 v02 aprovada como referência.',t);assert n==1,row['code']
 t=t.replace('R01 v02 aprovada; sete R restantes em geração; push concluído e verificado; N/M pendentes','Onda cortante oito candidatas revisadas, R01 v02 aprovada; push concluído e verificado; gerando somente N03 peak')
 p.write_text(t,encoding='utf-8')
for rel in ['.atena/state/plan.yaml','.atena/state/plan-053-imagens.yaml']:
 p=root/rel;t=p.read_text(encoding='utf-8-sig').replace('EXECUTING_R_REMAINING','EXECUTING_N_GATE').replace('S-007/VFX/FILA-022/R-REMAINING','S-007/VFX/FILA-022/N03')
 t=t.replace('S-007 R01 v02 aprovada; gerando sete R, depois somente gate N03. Dois commits publicados e ref remota verificada.','S-007 onda cortante oito candidatas revisadas; gerando somente gate N03 peak. Dois commits publicados e verificados.')
 t=t.replace('Revisar voo e impactos R e devolver gate N03 ao dono. Push concluido; retorno PLAN-071 preservado.','Devolver N03 peak ao dono antes dos cinco demais N. Retorno PLAN-071 preservado.')
 # The publication return_checkpoint is a historical Git receipt; restore it after active cursor replacement.
 t=t.replace('return_checkpoint: S-007/VFX/FILA-022/N03','return_checkpoint: S-007/VFX/FILA-022/R-REMAINING')
 if rel.endswith('plan-053-imagens.yaml'):
  m=re.search(r'\nvfx_gate:\n(.*?)(?=\n\S|\Z)',t,re.S);assert m;b=m[1].replace('  generated: 1','  generated: 8');t=t[:m.start(1)]+b+t[m.end(1):]
 p.write_text(t,encoding='utf-8')
print(json.dumps(dict(status=a['status'],frames=8,remaining=72,next='N03 PEAK gate')))
