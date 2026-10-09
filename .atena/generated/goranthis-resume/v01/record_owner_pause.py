from pathlib import Path
import json,hashlib,re,shutil
root=Path(__file__).resolve().parents[4];out=Path(__file__).parent
progress=json.loads((out/'guardiao-generation-progress.json').read_text(encoding='utf-8'))
preserved=[]
for job in progress:
 if job['status']!='generated_pending_review':continue
 result=json.loads((out/f'result-{job["id"]}-{job["state"]}-{job["index"]}-v1.json').read_text(encoding='utf-8'))
 p=Path(result['workspace_path'])
 if not p.exists():
  assert Path(result['source']).is_file()
  shutil.copyfile(result['source'],p)
 assert p.is_file()
 preserved.append(dict(state=job['state'],index=job['index'],path=p.relative_to(root).as_posix(),sha256=hashlib.sha256(p.read_bytes()).hexdigest(),status='GENERATED_PENDING_QA'))
count=len(preserved);assert count==7
pause=dict(date='2026-10-07',plan='PLAN-053',spec='SPEC-121',request='atena, pausar',classification='IN_PLAN',status='PAUSED_BY_OWNER',checkpoint='S-006/GORANTHIS/GUARDIAO/REVIEW-MOVE03',identity_gate='APPROVED',generated_new_frames=count,guardiao_total_sources=8,remaining_guardiao_new_frames=12,remaining_goranthis_new_frames=75,official_goranthis_assets=0,preserved=preserved,in_flight='Generation loop terminated before next call; move03 already returned and was copied during pause persistence.',resume_next='Inspect saved move03 for opposite contact; then continue move04/move05, attack00-03, death00-05. No new generation while paused.',return_plan='PLAN-071')
(out/'owner-pause-2026-10-07.json').write_text(json.dumps(pause,indent=2,ensure_ascii=False)+'\n',encoding='utf-8')
for rel in ['.atena/state/plan.yaml','.atena/state/plan-053-imagens.yaml']:
 p=root/rel;t=p.read_text(encoding='utf-8').replace('  status: EXECUTING_CYCLES','  status: PAUSED_BY_OWNER',1)
 if rel.endswith('/plan.yaml'):
  t=t.replace('S-006/GORANTHIS/GUARDIAO-DE-GORANTHIS-CYCLES',pause['checkpoint'])
  t=re.sub(r"  current: 'PLAN-053 / SPEC-121:.*","  current: 'PLAN-053 / SPEC-121 pausado pelo dono: Goranthis I01-I04 aprovados; Guardiao com 7 quadros novos preservados, nenhum integrado.'",t,count=1)
  t=re.sub(r"  next: '[^\n]*","  next: 'Aguardar pedido de retomada; revisar move03 preservado antes de continuar. Restam 75 quadros Goranthis. Retorno PLAN-071 preservado.'",t,count=1)
 else:
  t=re.sub(r"  current: 'S-006:.*","  current: 'S-006 pausado pelo dono: Goranthis identidades aprovadas; Guardiao com idle01-03 e move00-03 preservados, QA pendente, nenhum integrado.'",t,count=1)
  t=re.sub(r"  next: '[^\n]*","  next: 'Aguardar retomada; revisar move03 e continuar move04-05, ataque e morte. Restam 12 novos quadros Guardiao e 75 no bioma.'",t,count=1)
  t=t.replace('  cycles_generated: 0','  cycles_generated: 7',1).replace('  remaining_new_frames: 82','  remaining_new_frames: 75',1)
  t=t.replace('suspension: null','owner_pause:\n  requested_at: 2026-10-07\n  request: atena, pausar\n  checkpoint: '+pause['checkpoint']+'\n  receipt: .atena/generated/goranthis-resume/v01/owner-pause-2026-10-07.json\nsuspension: null',1)
 p.write_text(t,encoding='utf-8')
p=root/'.atena/generated/CHATGPT-FILA-018-mobs-goranthis.md';t=p.read_text(encoding='utf-8');a=t.index('### `guardiao_de_goranthis`');b=t.index('### `cultista_de_socothbenoth`',a);section=t[a:b]
for job in preserved:section=section.replace(f'- [ ] `{job["state"]}_{job["index"]:02}`',f'- [x] `{job["state"]}_{job["index"]:02}`',1)
t=t[:a]+section+t[b:];t=re.sub(r'^status:.*','status: "pausada pelo dono — identidades aprovadas, sete quadros novos preservados; nenhum ciclo integrado"',t,count=1,flags=re.M);t+='\n2026-10-07 — Dono pediu atena, pausar. Fila interrompida; Guardiao idle01-03/move00-03 preservados. Move03 retornou antes da interrupção e sua cópia foi concluída para preservar o resultado, sem nova geração. QA completo pendente; nenhum PNG Goranthis admitido. Próximo na retomada: revisar move03, gerar os 12 restantes do Guardiao; 75 no bioma. Recibo goranthis-resume/v01/owner-pause-2026-10-07.json.\n';p.write_text(t,encoding='utf-8')
p=root/'.atena/generated/ART-PROMPTS-049-mobs-goranthis.md';t=p.read_text(encoding='utf-8');t=re.sub(r'^status:.*','status: "pausado pelo dono — sete quadros novos do Guardião preservados; nenhum integrado"',t,count=1,flags=re.M);p.write_text(t,encoding='utf-8')
summary='\n2026-10-07 — PLAN-053/SPEC-121 pausa explícita do dono (atena, pausar). Goranthis identidades aprovadas no registro023; Guardiao sete quadros novos preservados, mais identidade; nenhum integrado. Fila interrompida antes da próxima chamada. Retomada exige pedido do dono; revisar move03 antes de seguir; 75 novos quadros no bioma. Recibo owner-pause-2026-10-07.json em goranthis-resume/v01. Retorno PLAN-071 mantido.\n'
for rel in ['.atena/evidence/EVID-145-fila-de-imagens-prioritaria-2026-10-02.md','.atena/specs/SPEC-121-retomada-fila-imagens/tasks.md']:
 p=root/rel;p.write_text(p.read_text(encoding='utf-8')+summary,encoding='utf-8')
print('PAUSED_BY_OWNER: 7 new frames preserved, 75 remaining; no Goranthis runtime assets; resume at review move03.')
