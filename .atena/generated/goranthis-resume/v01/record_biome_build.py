from pathlib import Path
import hashlib, json, re

root=Path(__file__).resolve().parents[4]
out=Path(__file__).parent
actors=['guardiao_de_goranthis','cultista_de_socothbenoth','death_tyrant','socothbenoth']
receipts=[]
for actor in actors:
    item=json.loads((out/f'{actor}-completion-receipt.json').read_text(encoding='utf-8'))
    assert item['status']=='INTEGRATED_LOCAL_VALIDATED'
    for row in item['sources']+item['assets']:
        assert hashlib.sha256((root/row['path']).read_bytes()).hexdigest()==row['sha256'],row['path']
    for suffix,marker in [('queue','Animation queue: 0 failure(s)'),('runtime','death cleanup OK'),('capture','Shedaklah capture result=0')]:
        t=(out/f'{actor}-{suffix}.log').read_text(encoding='utf-8',errors='replace');assert marker in t and 'SCRIPT ERROR' not in t
    assert (root/f'.atena/generated/priority-review/{actor}_runtime.png').is_file()
    receipts.append(item)
assert sum(len(x['sources']) for x in receipts)==86
assert sum(len(x['assets']) for x in receipts)==17
manifest=json.loads((root/'.atena/generated/PRIORITY-IMAGES-2026-10-02.json').read_text(encoding='utf-8-sig'));assert len(manifest['assets'])==197
for row in manifest['assets']:assert hashlib.sha256((root/row['path']).read_bytes()).hexdigest()==row['sha256']
checks={}
for suffix,marker in [('suite','testes: 0 falha(s)'),('smoke','smoke: ok')]:
    p=out/f'socothbenoth-{suffix}.log';t=p.read_text(encoding='utf-8',errors='replace');assert marker in t and 'SCRIPT ERROR' not in t;checks[suffix]=p.relative_to(root).as_posix()
trigger=out/'socothbenoth-trigger.log';t=trigger.read_text(encoding='utf-8',errors='replace');assert 'actual aoe telegraph/summon/ring -> special, unlock and puddle -> attack OK' in t and 'SCRIPT ERROR' not in t
reuse=json.loads((out/'illusion-reuse-integration-receipt.json').read_text(encoding='utf-8'));assert reuse['status']=='REGISTERED_RUNTIME_VALIDATED' and reuse['source_id']=='cultista_de_socothbenoth' and reuse['native_pngs_generated']==0 and reuse['capture_inspected']
process=json.loads((out/'local-build-process-receipt.json').read_text(encoding='utf-8-sig'));assert process['export_exit']==0 and process['exe_exit']==0 and process['exe_frames']==60
exe=root/'build/image-priority-goranthis-complete/NottgardSurvivors.exe';assert exe.is_file() and exe.stat().st_size==process['bytes'] and hashlib.sha256(exe.read_bytes()).hexdigest()==process['sha256']
for suffix,marker in [('export','[ DONE ] savepack'),('exe','Godot Engine v4.7.2')]:
    t=(out/f'goranthis-{suffix}.log').read_text(encoding='utf-8',errors='replace');assert marker in t and 'SCRIPT ERROR' not in t
build=json.loads((root/'data/build_info.json').read_text(encoding='utf-8'))
receipt=dict(date='2026-10-08',plan='PLAN-053',spec='SPEC-121',status='GORANTHIS_LOCAL_COMPLETE',build_id=build['commit'],build_info=build,path=str(exe),bytes=process['bytes'],sha256=process['sha256'],manifest_assets=197,frames=86,strips=17,actors=actors,reused_actor='ilusao_de_socothbenoth',reused_source='cultista_de_socothbenoth',reused_alpha=.45,checks=checks,trigger=trigger.relative_to(root).as_posix(),export_exit=process['export_exit'],exe_exit=process['exe_exit'],exe_frames=process['exe_frames'],owner_exception=receipts[2]['owner_exception'],human_playtest='pending',next_checkpoint='S-006/PILARES/IDENTITY-PILOT',notes='Native alpha preserved. Actual aoe telegraph/summon/ring trigger special; combat unchanged. No commit/push/publication. PLAN-071 return preserved.')
receipt['owner_exceptions']={item['actor']:item['owner_exception'] for item in receipts if 'owner_exception' in item}
assert set(receipt['owner_exceptions']) == {'death_tyrant','socothbenoth'}
dest=root/'.atena/generated/goranthis-complete-build-validation-2026-10-08.json';dest.write_text(json.dumps(receipt,indent=2)+'\n',encoding='utf-8')
evidence=root/'.atena/evidence/goranthis-complete-2026-10-08.md';evidence.write_text(f'# Goranthis — conclusão local\n\nPLAN-053/SPEC-121 S-006, IN_PLAN. Quatro atores, 86 fontes, 17 tiras integradas; captura de cada ator inspecionada. Ilusão usa Cultista com alfa 0,45, sem novos PNGs. Exceção visual do Death Tyrant limitada a death02-05 com sete hastes visíveis; contexto exato da aprovação preservado no recibo. Socothbenoth: 26 fontes, morte progressiva, especial de seis quadros. Battle._use_ability real emite telegraph no aoe e enemy_action em summon/ring; todos acionam special, desbloqueiam e preservam puddle como attack. Combate sem alterações.\n\n[Recibo da build e hashes](../generated/goranthis-complete-build-validation-2026-10-08.json). [Socothbenoth](../generated/goranthis-resume/v01/socothbenoth-completion-receipt.json). [Captura](../generated/priority-review/socothbenoth_runtime.png). [Gatilho real](../generated/goranthis-resume/v01/socothbenoth-trigger.log).\n\nSuite/fila zero falhas, smoke nove fases; manifesto 197/197 hashes válidos. Exportação e EXE 60 frames exit0. Build {build["commit"]}, {process["bytes"]} bytes, SHA256 {process["sha256"]}. Playtest humano pendente; avisos ambientais de certificados/editor_settings registrados. Bugs abertos conforme backlog-preexport.log. Sem commit/push/publicação. Próximo: um piloto de Síntese Abissal/Pilares e aprovação humana antes de 25 ciclos; retorno PLAN-071 preservado.\n',encoding='utf-8')
evidence.write_text(evidence.read_text(encoding='utf-8').replace('Socothbenoth: 26 fontes,', 'Socothbenoth: exceção de marcha aprovada explicitamente para move03/04v03, com a mesma perna à frente; não se alega contato oposto claro. 26 fontes,'),encoding='utf-8')
for rel in ['.atena/state/plan.yaml','.atena/state/plan-053-imagens.yaml']:
    p=root/rel;t=p.read_text(encoding='utf-8-sig')
    if rel.endswith('/plan.yaml'):
        t=re.sub(r'  checkpoint: S-006/GORANTHIS/[^\n]+',f'  checkpoint: {receipt["next_checkpoint"]}',t,count=1)
        t=re.sub(r"  note: 'PLAN-053 retomado[^\n]*","  note: 'PLAN-053 retomado; Shendilavri e Goranthis validados localmente. Proximo piloto Pilares. PLAN-071 suspenso com retorno acima.'",t,count=1)
    else:
        t=re.sub(r'  cycles_generated: \d+','  cycles_generated: 82',t,count=1);t=re.sub(r'  official_assets_installed: \d+','  official_assets_installed: 17',t,count=1);t=re.sub(r'  remaining_new_frames: \d+','  remaining_new_frames: 0',t,count=1)
        t=re.sub(r"  evidence: '[^\n]+'","  evidence: '.atena/evidence/goranthis-complete-2026-10-08.md'",t,count=1)
    t=re.sub(r"  current: '[^\n]+","  current: 'S-006 Goranthis concluido localmente: 86 quadros/17 tiras, Ilusao alpha0.45 e build validados.'",t,count=1)
    t=re.sub(r"  next: '[^\n]+","  next: 'Gerar um piloto de Sintese Abissal em Pilares, auditar e pedir aprovacao humana antes dos 25 ciclos. Retorno PLAN-071 preservado.'",t,count=1);p.write_text(t,encoding='utf-8')
summary=f'\n2026-10-08 — Goranthis completo local: 4 atores/86 fontes/17 tiras; Ilusao reutiliza Cultista alpha0.45. Death Tyrant com excecao contextual limitada death02-05. Manifesto197 hashes validos, suite/fila0, smoke9, runtimes e capturas inspecionados. Socothbenoth aoe telegraph/summon/ring reais ->special, unlock e puddle->attack passaram. Exportacao/EXE60frames exit0, build {build["commit"]} SHA256{process["sha256"]}. Recibo goranthis-complete-build-validation-2026-10-08.json. Playtest humano pendente. Proximo piloto Pilares com gate antes dos ciclos; retorno PLAN-071 preservado.\n'
for rel in ['.atena/evidence/EVID-145-fila-de-imagens-prioritaria-2026-10-02.md','.atena/specs/SPEC-121-retomada-fila-imagens/plan.md','.atena/specs/SPEC-121-retomada-fila-imagens/tasks.md','.atena/vault/drafts/PLAN-053-fila-de-imagens-2026-10-02.md','.atena/generated/CHATGPT-FILA-018-mobs-goranthis.md']:
    p=root/rel;p.write_text(p.read_text(encoding='utf-8')+summary,encoding='utf-8')
p=root/'.atena/generated/ART-PROMPTS-049-mobs-goranthis.md';t=p.read_text(encoding='utf-8');t=re.sub(r'^status:.*','status: "concluido localmente — 86 fontes, 17 tiras e build validada; playtest humano pendente"',t,count=1,flags=re.M);p.write_text(t,encoding='utf-8')
print(f'Goranthis complete: 86 sources/17 strips/197 hashes; build {build["commit"]}; next Pilares identity pilot.')
