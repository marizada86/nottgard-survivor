from pathlib import Path
import hashlib,json,re
root=Path(__file__).resolve().parents[4]; out=Path(__file__).parent; actor='sintese_abissal'
read=lambda p:json.loads(p.read_text(encoding='utf-8-sig'))
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
item=read(out/f'{actor}-completion-receipt.json')
assert item['status']=='INTEGRATED_LOCAL_VALIDATED' and item.get('capture_inspected') is True
assert len(item['sources'])==26 and len(item['assets'])==5
assert item['owner_exception']['status']=='ACCEPTED_OWNER_EXCEPTION' and item['owner_exception']['exception_scope']==['attack_03']
for row in item['sources']+item['assets']: assert sha(root/row['path'])==row['sha256'],row['path']
manifest=read(root/'.atena/generated/PRIORITY-IMAGES-2026-10-02.json')
assert len(manifest['assets'])==202
for row in manifest['assets']: assert sha(root/row['path'])==row['sha256'],row['path']
checks={}
for suffix,marker in [('queue','Animation queue: 0 failure(s)'),('runtime','death cleanup OK'),('suite','testes: 0 falha(s)'),('smoke','smoke: ok'),('capture','Shedaklah capture result=0'),('trigger','actual aoe telegraph/summon/ring -> special, unlock and puddle -> attack OK')]:
 p=out/f'{actor}-{suffix}.log'; t=p.read_text(encoding='utf-8',errors='replace')
 assert marker in t and 'SCRIPT ERROR' not in t,p
 checks[suffix]=dict(path=p.relative_to(root).as_posix(),passed=True,marker=marker)
identity=read(out/'identity-gate-receipt.json')
assert identity['status']=='APPROVED'
process=read(out/'local-build-process-receipt.json')
assert process['export_exit']==0 and process['exe_exit']==0 and process['exe_frames']==60
exe=root/'build/image-priority-pilares-complete/NottgardSurvivors.exe'
assert exe.stat().st_size==process['bytes'] and sha(exe)==process['sha256']
for suffix,marker in [('export','[ DONE ] savepack'),('exe','Godot Engine v4.7.2')]:
 t=(out/f'pilares-{suffix}.log').read_text(encoding='utf-8',errors='replace')
 assert marker in t and 'SCRIPT ERROR' not in t
build=read(root/'data/build_info.json')
receipt=dict(date='2026-10-08',plan='PLAN-053',spec='SPEC-121',status='PILARES_LOCAL_COMPLETE',build_id=build['commit'],build_info=build,path=str(exe),bytes=process['bytes'],sha256=process['sha256'],manifest_assets=202,frames=26,strips=5,actors=[actor],checks=checks,export_exit=0,exe_exit=0,exe_frames=60,native_alpha_preserved=True,capture_inspected=True,human_playtest='pending',next_checkpoint='S-007/RECONCILIATION',notes='One cage arm, two lamp arms, two green lamps, one left wing and root base reviewed. Technical packing preserves native RGBA. Actual aoe telegraph/summon/ring trigger special; combat unchanged. PLAN-071 return preserved.')
receipt['owner_exception']=item['owner_exception']
receipt['notes']+=' Small extra green pendant drop is explicitly accepted only in attack03v03.'
dest=root/'.atena/generated/pilares-complete-build-validation-2026-10-08.json'
dest.write_text(json.dumps(receipt,indent=2)+'\n',encoding='utf-8')
evidence=root/'.atena/evidence/pilares-complete-2026-10-08.md'
evidence.write_text(f'# Pilares — conclusão local\n\nPLAN-053/SPEC-121 S-006 IN_PLAN, per-plan aprovado. Síntese Abissal: 26 fontes selecionadas, cinco tiras integradas. Três braços, dois lampiões verdes, asa única à esquerda e base de raízes revisados; queda progressiva termina com núcleo apagado. Correções de ornamentos preservam todas as versões. Fontes e células sem cortes, solidez >=0,90, RGB/alfa nativos preservados por empacotamento nearest. Captura do ator real inspecionada.\n\n[Recibo da build](../generated/pilares-complete-build-validation-2026-10-08.json). [Fontes e hashes](../generated/pilares-resume/v01/sintese_abissal-completion-receipt.json). [Captura](../generated/priority-review/sintese_abissal_runtime.png). [Gatilho real](../generated/pilares-resume/v01/sintese_abissal-trigger.log).\n\nSuite/fila zero falhas, smoke nove fases, 202 hashes do manifesto conferidos. Aoe/telegraph, summon e ring reais acionam special; desbloqueio e puddle como attack passaram. Exportação e EXE60frames exit0. Build {build["commit"]}, {process["bytes"]} bytes, SHA256 {process["sha256"]}. Playtest humano pendente. Bugs abertos no backlog-preexport.log. Sem commit/push/publicação. S-007: reconciliar demais pendências autorizadas; retorno PLAN-071 preservado.\n',encoding='utf-8')
evidence.write_text(evidence.read_text(encoding='utf-8')+'\nExceção visual: pequena gota verde de um pingente intermediário aceita explicitamente pelo dono somente em attack03v03, após três versões. [Aprovação e contexto](../generated/pilares-resume/v01/attack03-pendant-owner-approval-2026-10-08.json). Os dois lampiões principais e os três braços originais estão preservados; a exceção não abrange outros quadros.\n',encoding='utf-8')
for rel in ['.atena/state/plan.yaml','.atena/state/plan-053-imagens.yaml']:
 p=root/rel;t=p.read_text(encoding='utf-8-sig')
 if rel.endswith('/plan.yaml'):
  t=re.sub(r'  checkpoint: S-006/PILARES/[^\n]+','  checkpoint: S-007/RECONCILIATION',t,count=1)
 else:
  t=t.replace('  current_step: S-006','  current_step: S-007',1)
  t=re.sub(r'  cycles_generated: \d+','  cycles_generated: 25',t,count=1)
  t=re.sub(r'  official_assets_installed: \d+','  official_assets_installed: 5',t,count=1)
  t=re.sub(r'  remaining_new_frames: \d+','  remaining_new_frames: 0',t,count=1)
  t=re.sub(r"  evidence: '[^\n]+'","  evidence: '.atena/evidence/pilares-complete-2026-10-08.md'",t,count=1)
 t=t.replace('  status: EXECUTING_CYCLES','  status: RECONCILING_REMAINING_QUEUE',1)
 t=re.sub(r"  current: '[^\n]+","  current: 'S-006 Pilares concluido localmente: 26 fontes/5 tiras e build validados; S-007 em reconciliacao.'",t,count=1)
 t=re.sub(r"  next: '[^\n]+","  next: 'Reconciliar S-007 e executar somente pendencias autorizadas ate o proximo gate humano. Retorno PLAN-071 preservado.'",t,count=1)
 p.write_text(t,encoding='utf-8')
summary=f'\n2026-10-08 — Pilares completo local: Sintese Abissal 26 fontes/5 tiras; captura inspecionada; suite/fila0, smoke9, manifesto202 hashes, gatilhos reais de special e desbloqueio passaram. Export/EXE60frames0; build {build["commit"]} SHA256{process["sha256"]}. Recibo pilares-complete-build-validation-2026-10-08.json. Playtest humano pendente. S-006 completo; S-007 em reconciliacao, retorno PLAN-071 preservado.\n'
for rel in ['.atena/evidence/EVID-145-fila-de-imagens-prioritaria-2026-10-02.md','.atena/specs/SPEC-121-retomada-fila-imagens/plan.md','.atena/specs/SPEC-121-retomada-fila-imagens/tasks.md','.atena/vault/drafts/PLAN-053-fila-de-imagens-2026-10-02.md','.atena/generated/CHATGPT-FILA-019-mobs-pilares.md']:
 p=root/rel;t=p.read_text(encoding='utf-8')
 if rel.endswith('/tasks.md'): t=t.replace('- [ ] S-006 próximos biomas; parar nos gates visuais pendentes.','- [x] S-006 próximos biomas; identidades e ciclos integrados localmente até Pilares; playtest humano pendente.')
 p.write_text(t+summary,encoding='utf-8')
p=root/'.atena/generated/ART-PROMPTS-050-mobs-pilares.md'
t=p.read_text(encoding='utf-8');t=re.sub(r'^status:.*','status: "concluido localmente — 26 fontes, 5 tiras e build validada; playtest humano pendente"',t,count=1,flags=re.M);p.write_text(t,encoding='utf-8')
print(f'Pilares complete: 26 sources/5 strips/202 hashes; build {build["commit"]}; next S-007 reconciliation.')
