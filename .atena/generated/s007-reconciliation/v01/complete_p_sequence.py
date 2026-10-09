from pathlib import Path
import json,re
from datetime import datetime,timezone
root=Path(__file__).resolve().parents[4];out=Path(__file__).parent
read=lambda p:p.read_text(encoding='utf-8-sig')
ap=out/'orbe-radiante-sequence-audit-2026-10-09.json';a=json.loads(read(ap));assert a['status']=='PREPARED_FOR_SEQUENCE_VISUAL_REVIEW';rows=a['sources'];assert len(rows)==8
assert rows[5]['mean_luminance']>rows[4]['mean_luminance'] and rows[5]['mean_luminance']>rows[6]['mean_luminance']>rows[7]['mean_luminance']
assert max(a['flight_centroid_spread_normalized'])<.04,'Flight center drift requires review/correction'
a.update(status='COMPLETE_CANDIDATE_SEQUENCE_VISUALLY_REVIEWED',timestamp=datetime.now(timezone.utc).isoformat(),plan='PLAN-053',spec='SPEC-121',visual_inspected=True,visual_review='Four flight frames keep round centered orb and left tail, small glow/detail/tail changes, final flight returns to first. Four centered impacts lose tail, flash peaks at P06, then breaks into dim fragments/ring and faint specks. Native frames and96px montage inspected; no visible cuts.',human_gate_approval='.atena/generated/s007-reconciliation/v01/p01-owner-approval-2026-10-09.json',review='.atena/generated/s007-reconciliation/v01/orbe-radiante-eight-frame-review-2026-10-09.png',preview_gifs=['.atena/generated/s007-reconciliation/v01/orbe-radiante-flight-review-2026-10-09.gif','.atena/generated/s007-reconciliation/v01/orbe-radiante-impact-review-2026-10-09.gif'],other_frames_human_approval='not individually claimed',remaining_native_vfx_frames=88,next='Q01 arcane orb first flight gate only',native_dimensions_note='Native square sources retained; requested1024 normalization deferred')
ap.write_text(json.dumps(a,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
q=root/'.atena/generated/CHATGPT-FILA-022-vfx-projeteis-e-explosoes.md';t=read(q)
for row in rows:
 if row['code']=='P01':continue
 pattern=r'(#### '+row['code']+r'[^\n]+\n\n)- \[ \] gerada[^\n]+';replacement=r'\g<1>- [x] gerada · [ ] aprovada · candidata: `'+row['path']+'` — revisada tecnicamente; P01 aprovado como referência.'
 t,n=re.subn(pattern,replacement,t);assert n==1,row['code']
t=t.replace('P01 v01 aprovada; sete demais P em geração; Q/R/N/M pendentes','Orbe radiante oito quadros gerados/revisados, P01 v01 aprovada; Q/R/N/M pendentes');q.write_text(t,encoding='utf-8')
art=root/'.atena/generated/ART-PROMPTS-053-vfx-projeteis-e-explosoes.md';t=read(art).replace('Piloto aprovado; P01 v01 candidata com gate humano pendente; demais 35 quadros pendentes; EVID-145','Orbe radiante oito candidatas revisadas, P01 v01 aprovada; Q/R/N/M pendentes; EVID-145');art.write_text(t,encoding='utf-8')
for rel in ['.atena/state/plan.yaml','.atena/state/plan-053-imagens.yaml']:
 p=root/rel;t=read(p).replace('EXECUTING_P_REMAINING','EXECUTING_Q_GATE').replace('S-007/VFX/FILA-022/P-REMAINING','S-007/VFX/FILA-022/Q01')
 t=t.replace('S-007 P01 aprovada pelo dono; gerando sete P, depois somente gate Q01. Manifesto202 preservado.','S-007 orbe radiante oito fontes candidatas revisadas. Gerando somente gate Q01; manifesto202 preservado.')
 t=t.replace('Revisar ciclo de voo e quatro impactos P; gerar Q01 para proximo gate humano. Retorno PLAN-071 preservado.','Aguardar gate Q01 antes dos demais sete quadros do orbe arcano. Retorno PLAN-071 preservado.')
 if rel.endswith('plan-053-imagens.yaml'):
  m=re.search(r'\nvfx_gate:\n(.*?)(?=\n\S|\Z)',t,re.S);b=m.group(1).replace('  generated: 1','  generated: 8');t=t[:m.start(1)]+b+t[m.end(1):]
 p.write_text(t,encoding='utf-8')
print(json.dumps(dict(status=a['status'],frames=8,remaining_native_vfx_frames=88,next_gate='Q01')))
