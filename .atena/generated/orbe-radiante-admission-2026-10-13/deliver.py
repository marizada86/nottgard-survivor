from pathlib import Path
import hashlib,html,json,subprocess,sys,re
out=Path(__file__).resolve().parent
root=out.parents[2]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
runtime=['assets/vfx/orbe_radiante_voo.png','assets/vfx/orbe_radiante_impacto.png','core/radiant_orb_vfx.gd','ui/radiant_orb_layer.gd','core/battle.gd','ui/overlay.gd','ui/run.gd','tests/test_radiant_orb_vfx.gd']
hashes={p:sha(root/p) for p in runtime}
base=subprocess.check_output(['git','rev-parse','--short','HEAD'],cwd=root,text=True).strip()
build='0.4.0/orbe-radiante-admission-v01/'+base+'+local-'+hashlib.sha256(json.dumps(hashes,sort_keys=True).encode()).hexdigest()[:12]
(out/'build.json').write_text(json.dumps({'build_id':build,'content_state':'DRAFT','runtime_sha256':hashes,'exported':False},indent=2)+'\n',encoding='utf-8')
launchers=[('Jogar-Raio','raio_de_luz',''),('Jogar-Luz-Pura','luz_mais_pura',''),('Jogar-Marca','marca_da_retidao',''),('Jogar-Reduzido','luz_mais_pura','--reduced'),('Jogar-Tou-Um','luz_mais_pura','--tou-um')]
for name,weapon,flags in launchers:
    body=f'''@echo off
setlocal
cd /d "%~dp0..\\..\\.."
set "APPDATA=%~dp0qa-{name}"
echo Local QA build: {build}
"C:\\Users\\Higor Rossini\\Desktop\\Nottcard\\Godot_v4.7.2-stable_win64.exe" --path . --log-file ".atena/generated/orbe-radiante-admission-2026-10-13/{name}.log" %* res://.atena/generated/orbe-radiante-admission-2026-10-13/playtest.tscn -- {weapon} {flags}
endlocal
'''
    (out/(name+'.cmd')).write_text(body,encoding='utf-8',newline='\r\n')
playtest=f'''# Playtest Orbe Radiante — DRAFT v01

Build local `{build}`, projeto no checkout d8a8, Godot4.7.2, Dagruve/Maelor. Sem exportação/release. Fontes P01–P08 aceitas; integração visual ainda precisa da avaliação humana. Este roteiro e seus atalhos foram preparados antes do playtest; execução automática do launcher não é playtest humano.

Objetivo: avaliar conforto, ritmo e leitura do voo12fps e impacto0,24s nas três armas, tamanho/orientação e cor. Núcleo5px e impacto principal≈12px; simulação/alcance/perfuração não foram alterados.

1. [Raio de Luz](Jogar-Raio.cmd): jogar30–60s. Caminhar por trechos claros/escuros; usar controle de Mira do jogo para apontar em oito direções. Observar se a cauda fica atrás, se o loop é contínuo e se o impacto parece ligado ao alvo.
2. [Luz Mais Pura](Jogar-Luz-Pura.cmd): repetir com três projéteis e perfuração; conferir leitura dos impactos sem confundir tiros que continuam viajando.
3. [Marca da Retidão](Jogar-Marca.cmd): conferir que voo e acerto têm a mesma família visual, preservando a aplicação da marca.
4. [Tinta Tou Um](Jogar-Tou-Um.cmd): repetir Luz Mais Pura com a tinta alternativa; [Impacto reduzido](Jogar-Reduzido.cmd): deve manter o círculo/rastro procedural anterior, sem o novo flash de impacto.

Critérios técnicos: direção correta, sem cortes/retângulo de fundo, sem efeitos presos, fallback reduzido e interface preservados. Critérios humanos: projétil e impacto legíveis, brilho confortável e ritmo aceitável. Atena verifica funcionamento e consistência; você avalia sensação/dificuldade/diversão. Feedback esperado: arma/modo/cor/direção, aceitável ou problema em voo/impacto/fase; screenshot quando útil. Nada aqui atesta playtest já realizado. Esse feedback é necessário ao aceite visual em runtime.

Cada atalho usa APPDATA/save QA descartável dentro desta pasta; não usa seu progresso real. [Galeria](index.html), [checks renderizados](runtime-checks.json), [comparação determinística](parity.json), [verificação final](verification.json).
'''
(out/'PLAYTEST.md').write_text(playtest,encoding='utf-8')
rendered=json.loads((out/'runtime-checks.json').read_text(encoding='utf-8'))
page=f'<!doctype html><html lang="pt-BR"><meta charset="utf-8"><title>Orbe Radiante — admissão DRAFT v01</title><style>body{{background:#171c24;color:#eee;font:16px system-ui;max-width:1200px;margin:30px auto}}img{{max-width:100%}}h1,h2{{color:#e5c178}}a{{color:#a7d3ef}}</style><h1>Orbe Radiante · admissão DRAFT v01</h1><p>{html.escape(build)}</p><p>23 capturas renderizadas de QA; não substituem playtest humano. Voo12fps, impacto0,24s, três armas. <a href="PLAYTEST.md">Roteiro</a></p>'
for tag in rendered['screenshots']:
    page+=f'<h2>{html.escape(tag)}</h2><a href="captures/{tag}.png"><img src="captures/{tag}.png" loading="lazy"></a>'
(out/'index.html').write_text(page,encoding='utf-8')
if '--prepare' in sys.argv:
    print('Build, gallery, playtest instructions and five launchers prepared: '+build)
    raise SystemExit(0)

logs=['focused-final.log','suite.log','smoke.log','parity-verified.log','capture-final.log','import-final.log']+[name+'.log' for name,_,_ in launchers]
for log in logs:
    text=(out/log).read_text(encoding='utf-8-sig')
    assert 'SCRIPT ERROR' not in text and 'Parse Error' not in text and 'Assertion failed' not in text,log
assert 'testes: 0 falha(s)' in (out/'suite.log').read_text(encoding='utf-8')
assert 'smoke: ok' in (out/'smoke.log').read_text(encoding='utf-8')
assert 'orb focused: 0 failures' in (out/'focused-final.log').read_text(encoding='utf-8')
assert rendered['status']=='PASS' and len(rendered['screenshots'])==23
parity=json.loads((out/'parity.json').read_text(encoding='utf-8'));assert parity['status']=='PASS'
protected=json.loads((out/'protected.json').read_text(encoding='utf-8'))
changed=[p for p,h in protected.items() if sha(root/p)!=h]
assert sorted(changed)==sorted(['core/battle.gd','ui/overlay.gd','ui/run.gd']),changed
# Verify the full simulation file is byte-for-byte identical except the two approved hit metadata fields.
before=(out/'backup/core/battle.gd').read_text(encoding='utf-8')
current=(root/'core/battle.gd').read_text(encoding='utf-8')
metadata=', "weapon": p.get("_audio_id", p.get("id", "")), "kind": p.get("kind", "")'
assert current.count(metadata)==1 and current.replace(metadata,'')==before
for p,h in json.loads((out/'backup.json').read_text(encoding='utf-8')).items():assert sha(out/'backup'/p)==h
for e in json.loads((out/'authorization.json').read_text(encoding='utf-8'))['sources']:assert sha(root/e['path'])==e['sha256']
for n in ['voo','impacto']:assert sha(root/'assets/vfx'/('orbe_radiante_'+n+'.png'))==sha(out/('orbe_radiante_'+n+'.png'))
for name,weapon,flags in launchers:assert 'QA orb launcher: '+weapon in (out/(name+'.log')).read_text(encoding='utf-8')
evidence=root/'.atena/evidence/orbe-radiante-admission-2026-10-13.md'
verification={'status':'PASS','build_id':build,'sources':8,'atlases':2,'steps_completed':4,'suite_failures':0,'smoke_stages':9,'rendered_captures':23,'simulation_parity':parity,'protected_preexisting_files':len(protected),'unchanged_preexisting_files':len(protected)-len(changed),'allowed_changed_files':changed,'battle_only_approved_hit_metadata':True,'source_and_backup_hashes':'PASS','human_playtest':'PENDING_NOT_PERFORMED','canonical_promotion':False,'content_state':'DRAFT_ADMITTED_LOCAL','git':'NO_COMMIT_PUSH_MERGE','exported':False,'logs':logs,'runtime_sha256':hashes,'qa_attempt_notes':'Initial focused draw API and capture typing errors corrected; baseline harness adapted to Battle subclass overriding only original _hero_hit, boon/status fixtures corrected. Only clean final logs accepted.'}
(out/'verification.json').write_text(json.dumps(verification,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
state=root/'.atena/state/orbe-radiante-admission.yaml'
s=state.read_text(encoding='utf-8').replace('classification: PLAN_CHANGE_REQUEST','classification: IN_PLAN_APPROVED_ADMISSION').replace('status: IN_PROGRESS','status: LOCAL_TECHNICAL_DELIVERED_AWAITING_OWNER_PLAYTEST').replace('checkpoint: S-003/VALIDATION','checkpoint: S-004/OWNER_RUNTIME_PLAYTEST').replace('current_step_position: 3','current_step_position: 4').replace('completed_steps: 2','completed_steps: 4').replace('remaining_steps_after_current: 1','remaining_steps_after_current: 0').replace('runtime_changed: false','runtime_changed: true').replace('next_objective: Escolher modo e aprovar escopo de normalizacao/admissao antes de executar S-001.','next_objective: Dono avaliar conforto, leitura e ritmo do voo/impacto nas tres armas e modo reduzido.')
s+=f'''authorization: .atena/generated/orbe-radiante-admission-2026-10-13/authorization.json
verification: .atena/generated/orbe-radiante-admission-2026-10-13/verification.json
evidence: .atena/evidence/orbe-radiante-admission-2026-10-13.md
playtest: .atena/generated/orbe-radiante-admission-2026-10-13/PLAYTEST.md
build_id: {build}
human_runtime_playtest: PENDING_NOT_PERFORMED
next_inputs: Roteiro QA, tres armas radiantes e modo reduzido.
next_output: Feedback humano arma/modo/cor/direcao e aceitavel ou problema.
next_checks: Legibilidade, conforto, ritmo, orientacao e residuos; sem afirmar diversao por metricas.
'''
state.write_text(s,encoding='utf-8')
for name in ['plan.yaml','plan-053-imagens.yaml']:
    p=root/'.atena/state'/name;text=p.read_text(encoding='utf-8')
    prefix,block=text.split('orbe_radiante_admission_2026_10_13:',1)
    block=block.replace('classification: PLAN_CHANGE_REQUEST','classification: IN_PLAN_APPROVED_ADMISSION').replace('status: IN_PROGRESS','status: LOCAL_TECHNICAL_DELIVERED_AWAITING_OWNER_PLAYTEST').replace('checkpoint: S-001/DERIVATIVES','checkpoint: S-004/OWNER_RUNTIME_PLAYTEST').replace('completed_steps: 0','completed_steps: 4')
    block+='  evidence: .atena/evidence/orbe-radiante-admission-2026-10-13.md\n'
    text=prefix+'orbe_radiante_admission_2026_10_13:'+block
    if name=='plan-053-imagens.yaml':
        text=text.replace('S-007/VFX/ORBE_RADIANTE/ADMISSION_PLAN_APPROVAL','S-007/VFX/ORBE_RADIANTE/OWNER_RUNTIME_PLAYTEST').replace('ORBE_RADIANTE_VISUALLY_ACCEPTED_ADMISSION_PROPOSED','ORBE_RADIANTE_ADMITTED_LOCAL_OWNER_PLAYTEST_PENDING').replace('Orbe Radiante P02-P08 aceitos DRAFT; P01 aprovado preservado; proposta de admissao v01 preparada, sem execucao.','Orbe Radiante admitido localmente DRAFT; suite/smoke/paridade/capturas PASS, feedback humano runtime pendente.').replace('Aprovar escopo/modo orbe-radiante-admission/v01; playtests humanos anteriores preservados.','Playtest humano Orbe Radiante; depois retomar Orbe Arcano existente, sem regeneracao automatica.').replace("review: '.atena/generated/orbe-radiante-review-2026-10-13/index.html'","review: '.atena/generated/orbe-radiante-admission-2026-10-13/index.html'").replace("evidence: '.atena/evidence/orbe-radiante-review-2026-10-13.md'","evidence: '.atena/evidence/orbe-radiante-admission-2026-10-13.md'")
    p.write_text(text,encoding='utf-8')
print('PASS delivery contract, hashes, clean final logs and operational states reconciled: '+build)
