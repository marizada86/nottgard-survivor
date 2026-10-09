from pathlib import Path
import json,re
from datetime import datetime,timezone
root=Path(__file__).resolve().parents[4];out=Path(__file__).parent
read=lambda p:p.read_text(encoding='utf-8-sig')
ap=out/'orbe-arcano-sequence-audit-2026-10-09.json';a=json.loads(read(ap));assert a['status']=='PREPARED_FOR_SEQUENCE_VISUAL_REVIEW'
rows=a['sources'];assert len(rows)==8
assert rows[5]['mean_luminance']>rows[4]['mean_luminance'] and rows[5]['mean_luminance']>rows[6]['mean_luminance']>rows[7]['mean_luminance']
assert max(a['flight_centroid_spread_normalized'])<.04,'Flight center drift requires visual review/correction'
a.update(status='COMPLETE_CANDIDATE_SEQUENCE_VISUALLY_REVIEWED',timestamp=datetime.now(timezone.utc).isoformat(),plan='PLAN-053',spec='SPEC-121',visual_inspected=True,visual_review='Four flight frames maintain arcane core, circular glyph ring and left wispy tail; small glow/internal detail/tail variation with Q04-Q01 closure reviewed. Four centered impacts remove flight tail, flash peaks at Q06, then dim fragments/ring and faint residues. Native frames and96px montage inspected; no visible cuts.',human_gate_approval='.atena/generated/s007-reconciliation/v01/q01-owner-approval-2026-10-09.json',review='.atena/generated/s007-reconciliation/v01/orbe-arcano-eight-frame-review-2026-10-09.png',preview_gifs=['.atena/generated/s007-reconciliation/v01/orbe-arcano-flight-review-2026-10-09.gif','.atena/generated/s007-reconciliation/v01/orbe-arcano-impact-review-2026-10-09.gif'],other_frames_human_approval='Not individually claimed',remaining_native_vfx_frames=80,next='R01 cutting wave first-flight gate only',native_dimensions_note='Native square bytes retained; technical normalization to1024 deferred')
ap.write_text(json.dumps(a,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
q=root/'.atena/generated/CHATGPT-FILA-022-vfx-projeteis-e-explosoes.md';t=read(q)
for row in rows:
 if row['code']=='Q01':continue
 pattern=r'(#### '+row['code']+r'[^\n]+\n\n)- \[ \] gerada[^\n]+'
 replacement=r'\g<1>- [x] gerada · [ ] aprovada · candidata: `'+row['path']+'` — revisada tecnicamente; Q01 v03 aprovado como referência.'
 t,n=re.subn(pattern,replacement,t);assert n==1,row['code']
t=t.replace('Q01 v03 aprovada; sete demais Q em geração; R/N/M pendentes','Orbe arcano oito quadros gerados/revisados, Q01 v03 aprovada; R/N/M pendentes');q.write_text(t,encoding='utf-8')
art=root/'.atena/generated/ART-PROMPTS-053-vfx-projeteis-e-explosoes.md';t=read(art).replace('Q01 v03 aprovada; sete demais Q em geração; R/N/M pendentes','Orbe arcano oito candidatas revisadas, Q01 v03 aprovada; R/N/M pendentes');art.write_text(t,encoding='utf-8')
for rel in ['.atena/state/plan.yaml','.atena/state/plan-053-imagens.yaml']:
 p=root/rel;t=read(p).replace('EXECUTING_Q_REMAINING','EXECUTING_R_GATE').replace('S-007/VFX/FILA-022/Q-REMAINING','S-007/VFX/FILA-022/R01')
 t=t.replace('S-007 Q01 v03 aprovada; gerando sete demais Q, depois somente gate R01. Manifesto202 preservado.','S-007 orbe arcano oito fontes candidatas revisadas; gerando somente gate R01. Manifesto202 preservado.')
 t=t.replace('Revisar voo e quatro impactos Q; gerar R01 para proximo gate humano. Retorno PLAN-071 preservado.','Aguardar gate R01 antes dos sete demais quadros da onda cortante. Retorno PLAN-071 preservado.')
 if rel.endswith('plan-053-imagens.yaml'):
  m=re.search(r'\nvfx_gate:\n(.*?)(?=\n\S|\Z)',t,re.S);assert m;b=m.group(1).replace('  generated: 1','  generated: 8');t=t[:m.start(1)]+b+t[m.end(1):]
 p.write_text(t,encoding='utf-8')
print(json.dumps(dict(status=a['status'],frames=8,remaining_native_vfx_frames=80,next_gate='R01')))
