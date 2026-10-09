from pathlib import Path
import json,re,hashlib
from datetime import datetime,timezone
root=Path(__file__).resolve().parents[4];out=Path(__file__).parent
read=lambda p:p.read_text(encoding='utf-8-sig')
auditp=out/'arco-radiante-sequence-audit-2026-10-09.json';audit=json.loads(read(auditp));assert audit['status']=='PREPARED_FOR_SEQUENCE_VISUAL_REVIEW'
rows=audit['sources'];assert len(rows)==6
peak=rows[2];assert peak['code']=='E03'
assert peak['mean_luminance']>max(r['mean_luminance'] for r in rows if r['code']!='E03'),'Peak must be brightest'
assert rows[3]['mean_luminance']>rows[4]['mean_luminance']>rows[5]['mean_luminance'],'Decay must progress'
audit.update(status='COMPLETE_CANDIDATE_SEQUENCE_VISUALLY_REVIEWED',timestamp=datetime.now(timezone.utc).isoformat(),plan='PLAN-053',spec='SPEC-121',visual_inspected=True,visual_review='One continuous right-facing radiant arc expands from start/sweep to peak; hold thins, fade breaks into fragments, dissipate leaves faint gray specks; review montage and 96px thumbnails inspected.',human_peak_approval='.atena/generated/s007-reconciliation/v01/e03-owner-approval-2026-10-09.json',review='.atena/generated/s007-reconciliation/v01/arco-radiante-six-frame-review-2026-10-09.png',preview_gif='.atena/generated/s007-reconciliation/v01/arco-radiante-review-2026-10-09.gif',other_frames_human_approval='not individually claimed',remaining_native_vfx_frames=102,native_dimensions_note='Native1254 square sources retained; requested1024 normalization deferred to future admission',next='F03 peak generation only, then required owner gate')
auditp.write_text(json.dumps(audit,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
queue=root/'.atena/generated/CHATGPT-FILA-021-vfx-corpo-a-corpo-excecoes.md';t=read(queue)
for row in rows:
 if row['code']=='E03':continue
 pattern=r'(#### '+row['code']+r'[^\n]+\n\n)- \[ \] gerada[^\n]+'
 replacement=r'\g<1>- [x] gerada · [ ] aprovada · candidata: `'+row['path']+'` — revisada tecnicamente; '+('v01 preservada por curva dupla rejeitada.' if row['code']=='E01' else 'pico E03 aprovado como referência.')
 t,n=re.subn(pattern,replacement,t);assert n==1,row['code']
t=t.replace('E03 v01 aprovada; cinco demais E em geração; demais E e F pendentes','Arco radiante seis quadros gerados e revisados, E03 v01 aprovada; F pendente')
queue.write_text(t,encoding='utf-8')
for rel in ['.atena/state/plan.yaml','.atena/state/plan-053-imagens.yaml']:
 p=root/rel;t=read(p).replace('EXECUTING_E_REMAINING','EXECUTING_F_GATE').replace('S-007/VFX/FILA-021/E-REMAINING','S-007/VFX/FILA-021/F03')
 t=t.replace('S-007 E03 aprovada pelo dono; gerando cinco quadros E e depois somente gate F03. Manifesto202 preservado.','S-007 arco radiante seis fontes candidatas revisadas; E03 aprovada. Gerando apenas F03 para gate humano.')
 t=t.replace('Revisar sequencia E completa; gerar F03 para proximo gate humano. Retorno PLAN-071 preservado.','Aguardar gate F03 antes dos demais cinco quadros F; manifesto202, retorno PLAN-071 preservado.')
 if rel.endswith('plan-053-imagens.yaml'):t=t.replace('  generated: 1\n  remaining_native_vfx_frames: 102','  generated: 6\n  remaining_native_vfx_frames: 102')
 p.write_text(t,encoding='utf-8')
print(json.dumps(dict(status=audit['status'],frames=6,remaining_native_vfx_frames=102)))
