from pathlib import Path
from PIL import Image
import json, hashlib, re
root=Path(__file__).resolve().parents[4]
out=Path(__file__).parent
actors=['escravo_de_rivenheart','sucubo','guarda_do_castelo','master_of_cruelties','malcanthet']
receipts=[]
for actor in actors:
 p=out/(('escravo' if actor=='escravo_de_rivenheart' else actor)+'-completion-receipt.json')
 receipts.append(json.loads(p.read_text()))
manifest=json.loads((root/'.atena/generated/PRIORITY-IMAGES-2026-10-02.json').read_text(encoding='utf-8-sig'))
for row in manifest['assets']:
 assert hashlib.sha256((root/row['path']).read_bytes()).hexdigest()==row['sha256'],row['path']
assert len(manifest['assets'])==180
trigger=out/'malcanthet-trigger-v02.log'
assert 'actual aoe telegraph -> special, unlock and shoot -> attack OK' in trigger.read_text()
checks={}
for suffix,marker in [('queue','Animation queue: 0 failure(s)'),('runtime','death cleanup OK'),('suite','testes: 0 falha(s)'),('smoke','smoke: ok'),('capture','Shedaklah capture result=0')]:
 p=out/f'malcanthet-{suffix}.log';t=p.read_text(encoding='utf-8',errors='replace')
 assert marker in t and 'SCRIPT ERROR' not in t,p
 checks[suffix]=p.relative_to(root).as_posix()
exe=root/'build/image-priority-shendilavri-complete/NottgardSurvivors.exe'
assert exe.is_file() and exe.stat().st_size>100000000
export=(out/'shendilavri-export.log').read_text(encoding='utf-8',errors='replace')
assert '[ DONE ] savepack' in export and 'SCRIPT ERROR' not in export
launch=(out/'shendilavri-exe.log').read_text(encoding='utf-8',errors='replace')
assert 'Godot Engine v4.7.2' in launch and 'SCRIPT ERROR' not in launch
assert sum(len(r.get('sources',r.get('selected_sources',[]))) for r in receipts)==106
assert sum(len(r.get('assets',r.get('official_assets',[]))) for r in receipts)==21
build=json.loads((root/'data/build_info.json').read_text())
receipt=dict(date='2026-10-07',plan='PLAN-053',spec='SPEC-121',status='SHENDILAVRI_LOCAL_COMPLETE',build_id=build['commit'],build_info=build,path=str(exe),bytes=exe.stat().st_size,sha256=hashlib.sha256(exe.read_bytes()).hexdigest(),manifest_assets=180,frames=106,strips=21,actors=actors,reused_actor='ilusao_de_sucubo',reused_source='sucubo',reused_alpha=.45,checks=checks,trigger=trigger.relative_to(root).as_posix(),export_exit=0,exe_exit=0,exe_frames=60,human_playtest='pending',next_checkpoint='GATE-GORANTHIS-IDENTITIES-V01',notes='Native alpha preserved. Existing visual aoe telegraph triggers special, with no combat changes. Environmental root certificate/editor settings errors remain in logs. No commit/push/publication.')
dest=root/'.atena/generated/shendilavri-complete-build-validation-2026-10-07.json'
dest.write_text(json.dumps(receipt,indent=2)+'\n',encoding='utf-8')
evidence=root/'.atena/evidence/shendilavri-complete-2026-10-07.md'
evidence.write_text(f'# Shendilavri — conclusão local\n\nPLAN-053/SPEC-121 S-006, IN_PLAN. Cinco atores, 106 quadros, 21 tiras integrados e captura de cada ator inspecionada. Ilusão reutiliza Súcubo com alfa 0,45. Exceções de marcha limitadas a Escravo e Súcubo, conforme registro 022. Malcanthet: 26 fontes sem cortes, morte progressiva; versões em frame-selection.json e transformações em packing.json. Dois quadros especiais corrigidos para início e recuperação baixos; nenhuma mudança em combate. O teste usa Battle._use_ability real, recebe telegraph e confirma special, desbloqueio e ataque normal.\n\n[Recibo da build e hashes](../generated/shendilavri-complete-build-validation-2026-10-07.json). [Recibo de Malcanthet](../generated/shendilavri-resume/v01/malcanthet-completion-receipt.json). [Captura](../generated/priority-review/malcanthet_runtime.png). [Gatilho real](../generated/shendilavri-resume/v01/malcanthet-trigger-v02.log).\n\nSuite e fila zero falhas; smoke nove fases; escala/base/ações/limpeza passaram, inclusive reuso da Ilusão. Manifesto 180/180 hashes válidos. Exportação e EXE60 frames exit0. Build {build["commit"]}, {receipt["bytes"]} bytes, SHA256 {receipt["sha256"]}. Local: build/image-priority-shendilavri-complete/NottgardSurvivors.exe. Avisos de certificados/editor_settings ambientais registrados. Playtest humano pendente; BUG-025/027/028/029 abertos, sem P0. Sem commit/push/publicação. Próximo: quatro pilotos Goranthis e aprovação humana antes dos ciclos. Retorno PLAN-071 preservado.\n',encoding='utf-8')
for rel in ['.atena/state/plan.yaml','.atena/state/plan-053-imagens.yaml']:
 p=root/rel;t=p.read_text(encoding='utf-8-sig')
 if rel.endswith('/plan.yaml'):
  t=t.replace('S-006/SHENDILAVRI/GORANTHIS-IDENTITIES-CYCLES','S-006/GORANTHIS/IDENTITIES')
  t=re.sub(r"  current: 'PLAN-053 / SPEC-121:.*", "  current: 'PLAN-053 / SPEC-121: Shendilavri concluido localmente, 106 quadros/21 tiras; build ac14526+ validada. Gerar quatro pilotos Goranthis.'",t,count=1)
  t=re.sub(r"  next: '[^\n]*", "  next: 'Gerar e auditar I01-I04 Goranthis, submeter gate humano antes dos 82 quadros restantes. Retorno PLAN-071 preservado.'",t,count=1)
  t=re.sub(r"  note: 'PLAN-053 retomado[^\n]*", "  note: 'PLAN-053 retomado; Shendilavri 106 quadros/21 tiras e build local validados. Proximo Goranthis. PLAN-071 suspenso com retorno acima.'",t,count=1)
 else:
  t=re.sub(r"  current: 'S-006:.*", "  current: 'S-006: Shendilavri concluido localmente, 106 quadros/21 tiras; build ac14526+ validada. Quatro pilotos Goranthis pendentes.'",t,count=1)
  t=re.sub(r"  next: '[^\n]*", "  next: 'Gerar I01-I04 Goranthis, auditar e submeter aprovacao de identidade antes dos ciclos.'",t,count=1)
  t=re.sub(r"  evidence: '[^\n]+'", "  evidence: '.atena/evidence/shendilavri-complete-2026-10-07.md'",t,count=1)
 p.write_text(t,encoding='utf-8')
summary=f'\n2026-10-07 — Shendilavri completo local: cinco atores/106 quadros/21 tiras, Ilusao reutiliza Sucubo alpha0.45; manifesto180 hashes validos, suite/fila0, smoke9, runtime/capturas aprovados tecnicamente. Malcanthet aoe usa telegraph real para special, teste completo passou. Exportacao/EXE60frames exit0; build {build["commit"]}, {receipt["bytes"]}bytes SHA256{receipt["sha256"]}. Recibo shendilavri-complete-build-validation-2026-10-07.json; evidencia shendilavri-complete-2026-10-07.md. Playtest humano pendente, sem commit/push. Proximo quatro pilotos Goranthis, gate antes de ciclos; retorno PLAN-071 preservado.\n'
for rel in ['.atena/evidence/EVID-145-fila-de-imagens-prioritaria-2026-10-02.md','.atena/specs/SPEC-121-retomada-fila-imagens/plan.md','.atena/specs/SPEC-121-retomada-fila-imagens/tasks.md','.atena/vault/drafts/PLAN-053-fila-de-imagens-2026-10-02.md','.atena/generated/CHATGPT-FILA-017-mobs-shendilavri.md']:
 p=root/rel;p.write_text(p.read_text(encoding='utf-8')+summary,encoding='utf-8')
p=root/'.atena/generated/ART-PROMPTS-048-mobs-shendilavri.md';t=p.read_text(encoding='utf-8');t=re.sub(r'^status:.*','status: "concluido localmente — 106 quadros, 21 tiras, build validada; playtest humano pendente"',t,count=1,flags=re.M);p.write_text(t,encoding='utf-8')
print(f'Shendilavri complete: 106 frames / 21 strips / 180 hashes, build {build["commit"]}, {receipt["bytes"]} bytes, next Goranthis identity gate.')
