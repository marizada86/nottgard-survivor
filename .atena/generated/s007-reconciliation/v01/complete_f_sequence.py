from pathlib import Path
import json,re
from datetime import datetime,timezone
root=Path(__file__).resolve().parents[4];out=Path(__file__).parent
read=lambda p:p.read_text(encoding='utf-8-sig')
ap=out/'arco-fogo-sequence-audit-2026-10-09.json';audit=json.loads(read(ap));assert audit['status']=='PREPARED_FOR_SEQUENCE_VISUAL_REVIEW';rows=audit['sources'];assert len(rows)==6
assert rows[2]['mean_luminance']>max(r['mean_luminance'] for r in rows if r['code']!='F03')
assert rows[3]['mean_luminance']>rows[4]['mean_luminance']>rows[5]['mean_luminance']
audit.update(status='COMPLETE_CANDIDATE_SEQUENCE_VISUALLY_REVIEWED',timestamp=datetime.now(timezone.utc).isoformat(),plan='PLAN-053',spec='SPEC-121',visual_inspected=True,visual_review='Single right-facing fire arc grows start/sweep to approved peak, then narrows and fades through fragments to faint wisps. Neutral white/gray flames and embers. Native frames and96px montage inspected; no visible cuts.',human_peak_approval='.atena/generated/s007-reconciliation/v01/f03-owner-approval-2026-10-09.json',review='.atena/generated/s007-reconciliation/v01/arco-fogo-six-frame-review-2026-10-09.png',preview_gif='.atena/generated/s007-reconciliation/v01/arco-fogo-review-2026-10-09.gif',other_frames_human_approval='not individually claimed',remaining_native_vfx_frames=96,next='FILA022 P01 first flight gate only',native_dimensions_note='Native1254 square sources retained; requested1024 normalization deferred')
ap.write_text(json.dumps(audit,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
q=root/'.atena/generated/CHATGPT-FILA-021-vfx-corpo-a-corpo-excecoes.md';t=read(q)
for row in rows:
 if row['code']=='F03':continue
 pattern=r'(#### '+row['code']+r'[^\n]+\n\n)- \[ \] gerada[^\n]+'
 replacement=r'\g<1>- [x] gerada · [ ] aprovada · candidata: `'+row['path']+'` — revisada tecnicamente; F03 aprovado como referência.'
 t,n=re.subn(pattern,replacement,t);assert n==1,row['code']
t=t.replace('F03 v01 aprovada; cinco demais F em geração','Arco de fogo seis quadros gerados e revisados, F03 v01 aprovada; FILA021 geração completa, E/F candidatas')
q.write_text(t,encoding='utf-8')
art=root/'.atena/generated/ART-PROMPTS-052-vfx-corpo-a-corpo-excecoes.md';t=read(art).replace('Estocada e Chicote: 12 quadros gerados e integrados; picos aprovados; E e F pendentes; EVID-145','24 quadros gerados: C/D integrados; E/F seis candidatas cada revisadas, picos E03/F03 aprovados; EVID-145');art.write_text(t,encoding='utf-8')
for rel in ['.atena/state/plan.yaml','.atena/state/plan-053-imagens.yaml']:
 p=root/rel;t=read(p).replace('EXECUTING_F_REMAINING','EXECUTING_P_GATE').replace('S-007/VFX/FILA-021/F-REMAINING','S-007/VFX/FILA-022/P01')
 t=t.replace('S-007 F03 aprovada pelo dono; gerando cinco F, depois somente gate P01 FILA022. Manifesto202 preservado.','S-007 arco de fogo seis fontes revisadas; FILA021 gerada. Gerando somente gate P01 FILA022.')
 t=t.replace('Revisar sequencia F completa; gerar P01 para proximo gate humano. Retorno PLAN-071 preservado.','Aguardar gate P01 antes dos demais sete quadros do orbe radiante; retorno PLAN-071 preservado.')
 if rel.endswith('plan-053-imagens.yaml'):
  match=re.search(r'\nvfx_gate:\n(.*?)(?=\n\S|\Z)',t,re.S);block=match.group(1).replace('  generated: 1','  generated: 6');t=t[:match.start(1)]+block+t[match.end(1):]
 p.write_text(t,encoding='utf-8')
print(json.dumps(dict(status=audit['status'],frames=6,remaining_native_vfx_frames=96,next_gate='P01')))
