from pathlib import Path
import hashlib,html,json,re,subprocess,sys
out=Path(__file__).resolve().parent
root=out.parents[2]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
paths=['core/cutting_wave_vfx.gd','ui/radiant_orb_layer.gd','assets/vfx/onda_cortante_voo.png','assets/vfx/onda_cortante_impacto.png','tests/test_cutting_wave_vfx.gd']
hashes={p:sha(root/p) for p in paths}
base=subprocess.check_output(['git','rev-parse','--short','HEAD'],cwd=root,text=True).strip()
build='0.4.0/onda-cortante-admission-v01/'+base+'+local-'+hashlib.sha256(json.dumps(hashes,sort_keys=True).encode()).hexdigest()[:12]
launchers=[('Jogar-Lamina','lamina_trovejante',''),('Jogar-Tempestade','tempestade',''),('Jogar-Reduzido','tempestade','--reduced'),('Jogar-Tou-Um','tempestade','--tou-um'),('Jogar-Misto','lamina_trovejante','--mixed')]
reports=[('', 'Onda Cortante / três famílias'),('arcane-regression/','Regressão Arcano'),('radiant-regression/','Regressão Radiante')]
reports=[(prefix,label,json.loads((out/prefix/'runtime-checks.json').read_text(encoding='utf-8'))) for prefix,label in reports]
assert [len(r['screenshots']) for _,_,r in reports]==[22,24,23]
for name,weapon,flags in launchers:
 body=f'''@echo off
setlocal
cd /d "%~dp0..\\..\\.."
set "APPDATA=%~dp0qa-{name}"
echo Local QA build: {build}
"C:\\Users\\Higor Rossini\\Desktop\\Nottcard\\Godot_v4.7.2-stable_win64.exe" --path . --log-file ".atena/generated/onda-cortante-admission-2026-10-13/{name}.log" %* res://.atena/generated/onda-cortante-admission-2026-10-13/playtest.tscn -- {weapon} {flags}
endlocal
'''
 (out/(name+'.cmd')).write_text(body,encoding='utf-8',newline='\r\n')
(out/'build.json').write_text(json.dumps({'build_id':build,'runtime_sha256':hashes,'content_state':'DRAFT','exported':False},indent=2)+'\n',encoding='utf-8')
(out/'PLAYTEST.md').write_text(f'''# Playtest Onda Cortante — DRAFT v01

Build local `{build}`, checkout d8a8/Godot 4.7.2, Dagruve/Maelor, sem exportação. Oito fontes aceitas, incluindo R01v02 e R05v02. Escopo: apresentação de Lâmina Trovejante/Tempestade. Objetivo: avaliar crescente/pontas/raios, alinhamento em movimento, leitura da perfuração, brilho e ritmo; gameplay preservado. Voo 12fps, impacto 0,24s, crescente principal 18px, pico principal 12px de raio; pivô fixo por animação.

1. Abrir [Lâmina Trovejante](Jogar-Lamina.cmd), jogar 30–60s; mover por pisos claros/escuros e usar o controle de Mira do jogo para apontar em oito direções. Observar se o crescente aponta para o deslocamento e se o loop parece estável.
2. Repetir com [Tempestade](Jogar-Tempestade.cmd): quatro projéteis, alvos em grupo, perfuração e impactos breves. Conferir se acertos e voo continuam distinguíveis.
3. Comparar [tinta Tou Um](Jogar-Tou-Um.cmd) e [impacto reduzido](Jogar-Reduzido.cmd). O reduzido mantém círculo/rastro procedural e ausência do novo flash.
4. Abrir [três famílias juntas](Jogar-Misto.cmd), comparando Onda Cortante, Orbe Arcano e Orbe Radiante no mesmo combate; avaliar clareza sob sobreposição.

Critérios técnicos: direção/alinhamento coerentes, sem cortes/fundo retangular, sem efeito preso e reduzido preservado. Critérios humanos: leitura do crescente/impacto, brilho confortável, ritmo e sensação aceitáveis. Atena verifica funcionamento e consistência; você avalia sensação, dificuldade e diversão. Feedback esperado: arma/modo/cor/direção, aceitável ou problema, fase/voo/impacto. Playtest humano PENDENTE, necessário ao aceite visual em runtime; smoke automático dos atalhos não o substitui.

Cada atalho isola APPDATA e perfil QA nesta pasta; não usa seu progresso real. [Galeria de 69 capturas](index.html), [verificação](verification.json), [paridade de simulação](parity.json).
''',encoding='utf-8')
page=f'<!doctype html><html lang="pt-BR"><meta charset="utf-8"><title>Onda Cortante DRAFT v01</title><style>body{{background:#171c24;color:#eee;font:16px system-ui;max-width:1200px;margin:30px auto}}img{{max-width:100%}}h1,h2{{color:#e5c178}}a{{color:#a7d3ef}}</style><h1>Onda Cortante · admissão DRAFT v01</h1><p>{html.escape(build)}</p><p>69 capturas automáticas; playtest humano pendente. <a href="PLAYTEST.md">Roteiro e atalhos</a></p>'
for prefix,label,report in reports:
 page+=f'<h1>{label}</h1>'
 for tag in report['screenshots']:page+=f'<h2>{html.escape(tag)}</h2><a href="{prefix}captures/{tag}.png"><img loading="lazy" src="{prefix}captures/{tag}.png"></a>'
(out/'index.html').write_text(page,encoding='utf-8')
state=root/'.atena/state/onda-cortante-admission.yaml'
if '--prepare' in sys.argv:
 s=state.read_text(encoding='utf-8').replace('S-003/VALIDATION','S-004/DELIVERY_PREPARATION').replace('completed_steps: 2','completed_steps: 3').replace('current_step_position: 3','current_step_position: 4').replace('remaining_steps_after_current: 1','remaining_steps_after_current: 0');state.write_text(s,encoding='utf-8')
 print('Prepared five QA launchers: '+build);raise SystemExit(0)
logs=['focused-final.log','suite.log','smoke.log','capture-final.log','arcane-regression-final.log','radiant-regression-final.log','import-final.log','parity-final.log']+[n+'.log' for n,_,_ in launchers]
for name in logs:
 text=(out/name).read_text(encoding='utf-8-sig')
 assert all(x not in text for x in ['SCRIPT ERROR','Parse Error','Assertion failed']),name
assert 'testes: 0 falha(s)' in (out/'suite.log').read_text(encoding='utf-8')
assert 'smoke: ok' in (out/'smoke.log').read_text(encoding='utf-8')
assert 'cutting focused: 0 failures' in (out/'focused-final.log').read_text(encoding='utf-8')
assert json.loads((out/'parity.json').read_text())['status']=='PASS'
for prefix,label,report in reports:
 assert report['status']=='PASS'
 for tag in report['screenshots']:assert (out/prefix/'captures'/(tag+'.png')).exists()
assert reports[0][2]['mixed_three_families']
assert reports[0][2]['weapons'][1]['spawned']==4
protected=json.loads((out/'protected.json').read_text(encoding='utf-8'))
changed=[p for p,h in protected.items() if sha(root/p)!=h]
assert changed==['ui/radiant_orb_layer.gd'],changed
for p,h in json.loads((out/'backup.json').read_text(encoding='utf-8')).items():assert sha(out/'backup'/p)==h
for e in json.loads((out/'authorization.json').read_text(encoding='utf-8'))['sources']:assert sha(root/e['path'])==e['sha256']
for name,weapon,flags in launchers:assert 'QA cutting launcher: '+weapon in (out/(name+'.log')).read_text(encoding='utf-8')
for n in ['voo','impacto']:assert sha(out/('onda_cortante_'+n+'.png'))==sha(root/'assets/vfx'/('onda_cortante_'+n+'.png'))
verification={'status':'PASS','build_id':build,'content_state':'DRAFT_ADMITTED_LOCAL','steps_completed':4,'sources_verified':8,'atlases':2,'suite_failures':0,'smoke_stages':9,'captures':69,'capture_groups':[22,24,23],'combined_impact_budget':32,'protected_preexisting_files':len(protected),'unchanged_preexisting_files':len(protected)-1,'allowed_changed_files':changed,'battle_data_run_overlay_orb_helpers_tests_atlases_unchanged':True,'source_backup_and_atlas_hashes':'PASS','logs':logs,'runtime_sha256':hashes,'human_playtest':'PENDING_NOT_PERFORMED','canonical_promotion':False,'git_operations':'NO_COMMIT_PUSH_MERGE','exported':False,'known_log_warnings':'Godot root certificate store unavailable; preexisting suite teardown resource leaks and Image.load warning. No script/parse/assert errors; no external networking required.'}
(out/'verification.json').write_text(json.dumps(verification,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
s=state.read_text(encoding='utf-8').replace('classification: PLAN_CHANGE_REQUEST','classification: IN_PLAN_APPROVED_ADMISSION').replace('status: IN_PROGRESS','status: LOCAL_TECHNICAL_DELIVERED_AWAITING_OWNER_PLAYTEST').replace('S-004/DELIVERY_PREPARATION','S-004/OWNER_RUNTIME_PLAYTEST').replace('completed_steps: 3','completed_steps: 4').replace('runtime_changed: false','runtime_changed: true')
s=re.sub(r'next_objective:.*','next_objective: Dono avaliar crescente, perfuracao, conforto e ritmo em runtime.',s)
s+=f'''authorization: .atena/generated/onda-cortante-admission-2026-10-13/authorization.json
verification: .atena/generated/onda-cortante-admission-2026-10-13/verification.json
evidence: .atena/evidence/onda-cortante-admission-2026-10-13.md
playtest: .atena/generated/onda-cortante-admission-2026-10-13/PLAYTEST.md
build_id: {build}
human_runtime_playtest: PENDING_NOT_PERFORMED
next_inputs: Roteiro, cinco atalhos QA, duas armas e cena de tres familias.
next_output: Feedback humano arma/modo/cor/direcao, aceitavel ou problema.
next_checks: Crescente/pontas/raios, leitura da perfuracao, conforto, ritmo e reduzido.
'''
state.write_text(s,encoding='utf-8')
for name in ['plan.yaml','plan-053-imagens.yaml']:
 p=root/'.atena/state'/name;s=p.read_text(encoding='utf-8');prefix,block=s.split('onda_cortante_admission_2026_10_13:',1)
 block=block.replace('classification: PLAN_CHANGE_REQUEST','classification: IN_PLAN_APPROVED_ADMISSION').replace('status: IN_PROGRESS','status: LOCAL_TECHNICAL_DELIVERED_AWAITING_OWNER_PLAYTEST').replace('S-001/DERIVATIVES','S-004/OWNER_RUNTIME_PLAYTEST').replace('completed_steps: 0','completed_steps: 4')
 block+='  evidence: .atena/evidence/onda-cortante-admission-2026-10-13.md\n'
 prefix=prefix.replace('admission_proposal: .atena/specs/SPEC-121-retomada-fila-imagens/onda-cortante-admission-v01.md\n  admission_mode: unconfigured','admission_proposal: .atena/specs/SPEC-121-retomada-fila-imagens/onda-cortante-admission-v01.md\n  admission_mode: per-plan')
 s=prefix+'onda_cortante_admission_2026_10_13:'+block
 if name=='plan-053-imagens.yaml':
  s=s.replace('ONDA_CORTANTE/ADMISSION_PLAN_APPROVAL','ONDA_CORTANTE/OWNER_RUNTIME_PLAYTEST').replace('ONDA_CORTANTE_VISUALLY_ACCEPTED_ADMISSION_PROPOSED','ONDA_CORTANTE_ADMITTED_LOCAL_OWNER_PLAYTEST_PENDING').replace('Onda Cortante sete fases aceitas DRAFT e R01v02 preservado; proposta de admissao v01 preparada, sem execucao.','Onda Cortante admitida localmente DRAFT; suite/smoke/69capturas/paridade PASS, playtest humano pendente.').replace('Selecionar modo e aprovar onda-cortante-admission/v01 antes de executar.','Playtest humano Onda Cortante; depois conferir proxima pendencia nas filas existentes sem regeneracao automatica.').replace("review: '.atena/generated/onda-cortante-review-2026-10-13/index.html'","review: '.atena/generated/onda-cortante-admission-2026-10-13/index.html'").replace("evidence: '.atena/evidence/onda-cortante-review-2026-10-13.md'","evidence: '.atena/evidence/onda-cortante-admission-2026-10-13.md'")
 p.write_text(s,encoding='utf-8')
print('PASS final runtime/hash/log checks: '+build)
