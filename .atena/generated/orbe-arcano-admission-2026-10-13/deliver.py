from pathlib import Path
import hashlib,html,json,re,subprocess,sys
out=Path(__file__).resolve().parent
root=out.parents[2]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
paths=['core/arcane_orb_vfx.gd','ui/radiant_orb_layer.gd','assets/vfx/orbe_arcano_voo.png','assets/vfx/orbe_arcano_impacto.png','core/radiant_orb_vfx.gd','assets/vfx/orbe_radiante_voo.png','assets/vfx/orbe_radiante_impacto.png','tests/test_arcane_orb_vfx.gd']
hashes={p:sha(root/p) for p in paths}
base=subprocess.check_output(['git','rev-parse','--short','HEAD'],cwd=root,text=True).strip()
build='0.4.0/orbe-arcano-admission-v01/'+base+'+local-'+hashlib.sha256(json.dumps(hashes,sort_keys=True).encode()).hexdigest()[:12]
(out/'build.json').write_text(json.dumps({'build_id':build,'runtime_sha256':hashes,'content_state':'DRAFT','exported':False},indent=2)+'\n',encoding='utf-8')
launchers=[('Jogar-Raio','raio_enfraquecedor',''),('Jogar-Dominar','dominar_pessoa',''),('Jogar-Cajado','cajado_dos_desejos',''),('Jogar-Reduzido','cajado_dos_desejos','--reduced'),('Jogar-Tou-Um','cajado_dos_desejos','--tou-um'),('Jogar-Misto','raio_enfraquecedor','--mixed')]
for name,weapon,flags in launchers:
    body=f'''@echo off
setlocal
cd /d "%~dp0..\\..\\.."
set "APPDATA=%~dp0qa-{name}"
echo Local QA build: {build}
"C:\\Users\\Higor Rossini\\Desktop\\Nottcard\\Godot_v4.7.2-stable_win64.exe" --path . --log-file ".atena/generated/orbe-arcano-admission-2026-10-13/{name}.log" %* res://.atena/generated/orbe-arcano-admission-2026-10-13/playtest.tscn -- {weapon} {flags}
endlocal
'''
    (out/(name+'.cmd')).write_text(body,encoding='utf-8',newline='\r\n')
playtest=f'''# Playtest Orbe Arcano — DRAFT v01

Build local `{build}`, checkout d8a8/Godot4.7.2, Dagruve/Maelor. Sem exportação/release. Oito fontes aceitas; integração visual ainda depende da avaliação humana. Este roteiro/atalhos foi preparado antes do playtest; smoke automático do launcher não é playtest humano.

Objetivo: avaliar estabilidade do anel, leitura de glifos/cauda, conforto do impacto e ritmo. Voo12fps, impacto0,24s; anel de voo5px e pico12px, cauda≈26px preserva a fonte. Pivô fixo por animação; nenhuma alteração de simulação.

1. [Raio Enfraquecedor](Jogar-Raio.cmd): jogar30–60s, mover por pisos claros/escuros e usar controle de Mira do jogo para apontar em oito direções. Observar se a cauda fica atrás e o anel parece estável no loop.
2. [Dominar Pessoa](Jogar-Dominar.cmd): repetir, conferindo leitura do acerto enquanto o alvo fica atordoado; [Cajado dos Desejos](Jogar-Cajado.cmd): observar os três tiros sem confundir voo e impacto.
3. [Tinta Tou Um](Jogar-Tou-Um.cmd): repetir Cajado com tinta alternativa. [Impacto reduzido](Jogar-Reduzido.cmd): deve manter círculo/rastro procedural anterior e ausência do novo flash.
4. [Arcano + Radiante](Jogar-Misto.cmd): comparar as duas famílias no mesmo combate, clareza de cada efeito e sobreposição em grupos.

Critérios técnicos: orientação e anel alinhados, sem cortes/retângulos de fundo, sem efeito preso, modo reduzido preservado. Critérios humanos: projétil/impacto legíveis, brilho confortável e ritmo aceitável. Atena verifica funcionamento/consistência; você avalia sensação/dificuldade/diversão. Feedback esperado: arma/modo/cor/direção, aceitável ou problema e fase/voo/impacto; screenshot se útil. Playtest humano ainda pendente, necessário ao aceite visual em runtime.

Cada atalho isola APPDATA/save QA nesta pasta e equipa arma(s) apenas no perfil descartável. Seu progresso real não é usado. [Galeria47capturas](index.html), [checks Arcano/misto](runtime-checks.json), [regressão Radiante](radiant-regression/runtime-checks.json), [verificação final](verification.json).
'''
(out/'PLAYTEST.md').write_text(playtest,encoding='utf-8')
arc=json.loads((out/'runtime-checks.json').read_text(encoding='utf-8'))
rad=json.loads((out/'radiant-regression/runtime-checks.json').read_text(encoding='utf-8'))
page=f'<!doctype html><html lang="pt-BR"><meta charset="utf-8"><title>Orbe Arcano — DRAFT v01</title><style>body{{background:#171c24;color:#eee;font:16px system-ui;max-width:1200px;margin:30px auto}}img{{max-width:100%}}h1,h2{{color:#e5c178}}a{{color:#a7d3ef}}</style><h1>Orbe Arcano · admissão DRAFT v01</h1><p>{html.escape(build)}</p><p>24 capturas Arcano/misto +23 de regressão Radiante; não é playtest humano. <a href="PLAYTEST.md">Roteiro/atalhos</a></p>'
for prefix,label,report in [('', 'Arcano/misto',arc),('radiant-regression/','Regressão Radiante',rad)]:
    page+=f'<h1>{label}</h1>'
    for tag in report['screenshots']:page+=f'<h2>{html.escape(tag)}</h2><a href="{prefix}captures/{tag}.png"><img loading="lazy" src="{prefix}captures/{tag}.png"></a>'
(out/'index.html').write_text(page,encoding='utf-8')
state=root/'.atena/state/orbe-arcano-admission.yaml'
if '--prepare' in sys.argv:
    s=state.read_text(encoding='utf-8').replace('checkpoint: S-003/VALIDATION','checkpoint: S-004/DELIVERY_PREPARATION').replace('completed_steps: 2','completed_steps: 3').replace('current_step_position: 3','current_step_position: 4').replace('remaining_steps_after_current: 1','remaining_steps_after_current: 0');state.write_text(s,encoding='utf-8')
    print('Prepared build, gallery, instructions and six launchers: '+build)
    raise SystemExit(0)
logs=['focused-final.log','suite.log','smoke.log','capture-final.log','radiant-regression-final.log','import-final.log']+[name+'.log' for name,_,_ in launchers]
for name in logs:
    text=(out/name).read_text(encoding='utf-8-sig')
    assert all(x not in text for x in ['SCRIPT ERROR','Parse Error','Assertion failed']),name
assert 'testes: 0 falha(s)' in (out/'suite.log').read_text(encoding='utf-8')
assert 'smoke: ok' in (out/'smoke.log').read_text(encoding='utf-8')
assert 'arcane focused: 0 failures' in (out/'focused-final.log').read_text(encoding='utf-8')
assert arc['status']=='PASS' and len(arc['screenshots'])==24 and 'mixed-arcane-radiant' in arc['screenshots']
assert rad['status']=='PASS' and len(rad['screenshots'])==23
protected=json.loads((out/'protected.json').read_text(encoding='utf-8'))
changed=[p for p,h in protected.items() if sha(root/p)!=h]
assert changed==['ui/radiant_orb_layer.gd'],changed
for p,h in json.loads((out/'backup.json').read_text(encoding='utf-8')).items():assert sha(out/'backup'/p)==h
for e in json.loads((out/'authorization.json').read_text(encoding='utf-8'))['sources']:assert sha(root/e['path'])==e['sha256']
for name,weapon,flags in launchers:assert 'QA arcane launcher: '+weapon in (out/(name+'.log')).read_text(encoding='utf-8')
for n in ['voo','impacto']:assert sha(out/('orbe_arcano_'+n+'.png'))==sha(root/'assets/vfx'/('orbe_arcano_'+n+'.png'))
for prefix,report in [('',arc),('radiant-regression/',rad)]:
    for tag in report['screenshots']:assert (out/prefix/'captures'/(tag+'.png')).exists()
verification={'status':'PASS','build_id':build,'content_state':'DRAFT_ADMITTED_LOCAL','steps_completed':4,'sources_verified':8,'atlases':2,'suite_failures':0,'smoke_stages':9,'arcane_mixed_captures':24,'radiant_regression_captures':23,'combined_impact_budget':32,'protected_preexisting_files':len(protected),'unchanged_preexisting_files':len(protected)-1,'allowed_changed_files':changed,'battle_data_run_overlay_radiant_helper_and_atlases_unchanged':True,'source_backup_and_atlas_hashes':'PASS','logs':logs,'runtime_sha256':hashes,'human_playtest':'PENDING_NOT_PERFORMED','canonical_promotion':False,'git_operations':'NO_COMMIT_PUSH_MERGE','exported':False}
(out/'verification.json').write_text(json.dumps(verification,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
s=state.read_text(encoding='utf-8').replace('classification: PLAN_CHANGE_REQUEST','classification: IN_PLAN_APPROVED_ADMISSION').replace('status: IN_PROGRESS','status: LOCAL_TECHNICAL_DELIVERED_AWAITING_OWNER_PLAYTEST').replace('checkpoint: S-004/DELIVERY_PREPARATION','checkpoint: S-004/OWNER_RUNTIME_PLAYTEST').replace('completed_steps: 3','completed_steps: 4').replace('runtime_changed: false','runtime_changed: true').replace('next_objective: Escolher modo e aprovar escopo antes da execucao de S-001.','next_objective: Dono avaliar estabilidade do anel, leitura de glifos/cauda, conforto e ritmo em runtime.')
s+=f'''authorization: .atena/generated/orbe-arcano-admission-2026-10-13/authorization.json
verification: .atena/generated/orbe-arcano-admission-2026-10-13/verification.json
evidence: .atena/evidence/orbe-arcano-admission-2026-10-13.md
playtest: .atena/generated/orbe-arcano-admission-2026-10-13/PLAYTEST.md
build_id: {build}
human_runtime_playtest: PENDING_NOT_PERFORMED
next_inputs: Roteiro e seis atalhos QA, tres armas e cena mista.
next_output: Feedback humano arma/modo/cor/direcao, aceitavel ou problema.
next_checks: Legibilidade, conforto, ritmo, anel/cauda e reduzido; nao afirmar diversao por metricas.
'''
state.write_text(s,encoding='utf-8')
for name in ['plan.yaml','plan-053-imagens.yaml']:
    p=root/'.atena/state'/name;s=p.read_text(encoding='utf-8')
    prefix,block=s.split('orbe_arcano_admission_2026_10_13:',1)
    block=block.replace('classification: PLAN_CHANGE_REQUEST','classification: IN_PLAN_APPROVED_ADMISSION').replace('status: IN_PROGRESS','status: LOCAL_TECHNICAL_DELIVERED_AWAITING_OWNER_PLAYTEST').replace('checkpoint: S-001/DERIVATIVES','checkpoint: S-004/OWNER_RUNTIME_PLAYTEST').replace('completed_steps: 0','completed_steps: 4')
    block+='  evidence: .atena/evidence/orbe-arcano-admission-2026-10-13.md\n'
    prefix=prefix.replace('admission_proposal: .atena/specs/SPEC-121-retomada-fila-imagens/orbe-arcano-admission-v01.md\n  admission_mode: unconfigured','admission_proposal: .atena/specs/SPEC-121-retomada-fila-imagens/orbe-arcano-admission-v01.md\n  admission_mode: per-plan')
    s=prefix+'orbe_arcano_admission_2026_10_13:'+block
    if name=='plan-053-imagens.yaml':
        s=s.replace('S-007/VFX/ORBE_ARCANO/ADMISSION_PLAN_APPROVAL','S-007/VFX/ORBE_ARCANO/OWNER_RUNTIME_PLAYTEST').replace('ORBE_ARCANO_VISUALLY_ACCEPTED_ADMISSION_PROPOSED','ORBE_ARCANO_ADMITTED_LOCAL_OWNER_PLAYTEST_PENDING').replace('Orbe Arcano Q02-Q08 aceitos DRAFT e Q01v03 preservado; proposta de admissao v01 preparada, sem execucao.','Orbe Arcano admitido localmente DRAFT; suite/smoke/capturas/regressao Radiante PASS; feedback humano runtime pendente.').replace('Selecionar modo e aprovar orbe-arcano-admission/v01 antes de executar.','Playtest humano Orbe Arcano; depois retomar Onda Cortante existente, sem regeneracao automatica.').replace("review: '.atena/generated/orbe-arcano-review-2026-10-13/index.html'","review: '.atena/generated/orbe-arcano-admission-2026-10-13/index.html'").replace("evidence: '.atena/evidence/orbe-arcano-review-2026-10-13.md'","evidence: '.atena/evidence/orbe-arcano-admission-2026-10-13.md'")
    p.write_text(s,encoding='utf-8')
print('PASS logs, hashes, runtime contract and state reconciled: '+build)
