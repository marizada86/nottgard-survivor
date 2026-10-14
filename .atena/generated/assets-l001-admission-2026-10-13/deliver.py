from pathlib import Path
import hashlib,html,json,re,subprocess,sys
out=Path(__file__).resolve().parent;root=out.parents[2]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
names=['melee_arco_radiante','melee_arco_fogo','durvall_ruptura_sombria','brook_guarda_de_lliira','maelor_comunhao']
paths=['core/melee_vfx.gd','core/hero_active_vfx.gd','ui/hero_active_vfx.gd','ui/run.gd','tests/test_assets_l001_vfx.gd']+['assets/vfx/'+n+'.png' for n in names]
hashes={p:sha(root/p) for p in paths}
base=subprocess.check_output(['git','rev-parse','--short','HEAD'],cwd=root,text=True).strip()
build='0.4.0/assets-l001-admission-v01/'+base+'+local-'+hashlib.sha256(json.dumps(hashes,sort_keys=True).encode()).hexdigest()[:12]
launchers=[('Jogar-Juizo','durvall','golpe_do_juizo',''),('Jogar-Martelo','durvall','martelo_da_gloria',''),('Jogar-Machado','durvall','machado_de_xargath',''),('Jogar-Durvall','durvall','',''),('Jogar-Brook','brook','',''),('Jogar-Maelor','maelor','',''),('Jogar-Reduzido','brook','','--reduced'),('Jogar-Tou-Um','maelor','','--tou-um')]
for name,hero,weapon,flags in launchers:
 body=f'''@echo off
setlocal
cd /d "%~dp0..\\..\\.."
set "APPDATA=%~dp0qa-{name}"
echo Local QA build: {build}
"C:\\Users\\Higor Rossini\\Desktop\\Nottcard\\Godot_v4.7.2-stable_win64.exe" --path . --log-file ".atena/generated/assets-l001-admission-2026-10-13/{name}.log" %* res://.atena/generated/assets-l001-admission-2026-10-13/playtest.tscn -- {hero} "{weapon}" {flags}
endlocal
'''
 (out/(name+'.cmd')).write_text('\n'.join(l.rstrip() for l in body.splitlines())+'\n',encoding='utf-8',newline='\r\n')
(out/'build.json').write_text(json.dumps({'build_id':build,'runtime_sha256':hashes,'content_state':'DRAFT_WITH_HISTORICAL_GATES_PRESERVED','exported':False},indent=2)+'\n',encoding='utf-8')
reports=[('',json.loads((out/'runtime-checks.json').read_text(encoding='utf-8'))),('vfx-regression/',json.loads((out/'vfx-regression/runtime-checks.json').read_text(encoding='utf-8')))]
assert [len(r['screenshots']) for _,r in reports]==[109,22]
(out/'PLAYTEST.md').write_text(f'''# Playtest L-001 — cinco sequências / v01

Build local `{build}`, checkout d8a8/Godot4.7.2, Dagruve, perfil QA isolado. Escopo: três armas e ativações de Durvall/Brook/Maelor,30fontes/cincoatlas. DRAFT mantido e gates históricos preservados; sem exportação. Objetivo: conferir leitura, brilho, ritmo, alcance visual e alinhamento durante movimento.

1. Jogar30–60s com [Golpe do Juízo](Jogar-Juizo.cmd), [Martelo da Glória](Jogar-Martelo.cmd) e [Machado de Xar'gath](Jogar-Machado.cmd). Mover por pisos claros/escuros e apontar em oito direções com controle de Mira. Observar raios versus chamas, avanço/afinamento do arco e conforto do brilho; cortes duram0,2s.
2. [Durvall](Jogar-Durvall.cmd): usar Q ou botão direito perto de inimigos, esperar cooldown normal e repetir. Conferir rasgo/rachaduras do golpe e ausência de duplicação do corte. Não confundir ring genérico de ativação preservado com um segundo corte.
3. [Brook](Jogar-Brook.cmd): ativar Q/botão direito, mover e observar o anel acompanhando os pés. Sem receber golpe, ele termina em até4s. Em outra ativação receber um golpe: a guarda bloqueia e o anel desaparece quando a carga é consumida. Conferir estrelas e pulsação calma, sem rotação das marcas.
4. [Maelor](Jogar-Maelor.cmd): ativar, observar um único ciclo de0,6s com sinais de mais; mover durante a ativação. Cura/marca continuam instantâneas, sem campo de cura persistente. Comparar [tinta Tou Um](Jogar-Tou-Um.cmd).
5. [Reduzido com Brook](Jogar-Reduzido.cmd): ativações usam o ring simples anterior. Nas Opções, alternar reduzir efeitos durante uma guarda para conferir remoção do atlas. Pausar/retomar em todos os casos e observar se o efeito não fica preso.

Critérios técnicos: orientação coerente/sem corte de borda ou fundo retangular, alinhamento e vida útil corretos, reduzido preservado. Critérios humanos: rasgo/raios/chamas/estrelas/mais legíveis, brilho confortável e cadência aceitável em combate. Atena verifica consistência; você avalia sensação/dificuldade/diversão. Feedback esperado: arma ou herói, modo/cor/direção, aceitável ou problema, voo/golpe/ciclo/fase se identificável. Playtest humano PENDENTE, necessário ao aceite visual em runtime; smoke dos atalhos não substitui jogar.

Cada atalho isola APPDATA e save QA nesta pasta; nenhum progresso real é usado. Os três atalhos de armas equipam só aquela arma no perfil descartável; os de herói mantêm equipamento inicial. [Galeria131capturas](index.html), [verificação](verification.json), [checks principais](runtime-checks.json), [regressão projéteis/Pulso/Ampulheta](vfx-regression/runtime-checks.json).
''',encoding='utf-8')
page=f'<!doctype html><html lang="pt-BR"><meta charset="utf-8"><title>L001 admissão DRAFT v01</title><style>body{{background:#171c24;color:#eee;font:16px system-ui;max-width:1280px;margin:24px auto}}img{{max-width:100%}}h1,h2{{color:#e5c178}}a{{color:#a7d3ef}}</style><h1>L001 · cinco sequências admitidas localmente</h1><p>{html.escape(build)}</p><p>131capturas automáticas; playtest humano pendente. <a href="PLAYTEST.md">Roteiro e oito atalhos</a></p>'
for prefix,report in reports:
 page+='<h1>'+('Lote e regressões corpo a corpo/ativos' if not prefix else 'Projéteis, Pulso e Ampulheta')+'</h1>'
 for tag in report['screenshots']:page+=f'<h2>{html.escape(tag)}</h2><a href="{prefix}captures/{tag}.png"><img loading="lazy" src="{prefix}captures/{tag}.png"></a>'
(out/'index.html').write_text(page,encoding='utf-8')
state=root/'.atena/state/assets-l001-admission.yaml'
if '--prepare' in sys.argv:
 s=state.read_text(encoding='utf-8').replace('S-004/VALIDATION','S-005/DELIVERY_PREPARATION').replace('completed_steps: 3','completed_steps: 4').replace('current_step_position: 4','current_step_position: 5').replace('remaining_steps_after_current: 1','remaining_steps_after_current: 0');state.write_text(s,encoding='utf-8')
 print('Prepared build, gallery, playtest and eight launchers: '+build);raise SystemExit(0)
logs=['focused-final.log','suite.log','smoke.log','capture-final.log','vfx-regression-final.log','import-final.log']+[n+'.log' for n,_,_,_ in launchers]
for n in logs:
 s=(out/n).read_text(encoding='utf-8-sig');assert all(x not in s for x in ['SCRIPT ERROR','Parse Error','Assertion failed']),n
assert 'testes: 0 falha(s)' in (out/'suite.log').read_text(encoding='utf-8')
assert 'smoke: ok' in (out/'smoke.log').read_text(encoding='utf-8')
assert 'L001 focused: 0 failures' in (out/'focused-final.log').read_text(encoding='utf-8')
for prefix,report in reports:
 assert report['status']=='PASS'
 for tag in report['screenshots']:assert (out/prefix/'captures'/(tag+'.png')).exists()
protected=json.loads((out/'protected.json').read_text(encoding='utf-8'));changed=[p for p,h in protected.items() if sha(root/p)!=h]
assert changed==['core/melee_vfx.gd','ui/run.gd'],changed
for p,h in json.loads((out/'backup.json').read_text(encoding='utf-8')).items():assert sha(out/'backup'/p)==h
for e in json.loads((out/'authorization.json').read_text(encoding='utf-8'))['sources']:assert sha(root/e['path'])==e['sha256']
for n in names:assert sha(out/(n+'.png'))==sha(root/'assets/vfx'/(n+'.png'))
for n,hero,_,_ in launchers:assert 'QA L001 launcher: '+hero in (out/(n+'.log')).read_text(encoding='utf-8')
v={'status':'PASS','build_id':build,'content_state':'DRAFT_WITH_HISTORICAL_GATES_PRESERVED','technical_steps_completed':5,'sources_verified':30,'atlases':5,'suite_failures':0,'smoke_stages':9,'captures':131,'capture_groups':[109,22],'preexisting_runtime_files':len(protected),'unchanged_preexisting_runtime_files':len(protected)-2,'allowed_changed_files':changed,'battle_data_overlay_orbs_pulse_hourglass_unchanged':True,'runtime_sha256':hashes,'logs':logs,'native_backup_atlas_hashes':'PASS','human_playtest':'PENDING_NOT_PERFORMED','canonical_promotion':False,'git_operations':'NONE','exported':False,'known_log_warnings':'Sandbox certificate store; preexisting test Image.load warning and teardown resource leaks; no script/parse/assert errors in final checks.'}
(out/'verification.json').write_text(json.dumps(v,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
s=state.read_text(encoding='utf-8').replace('status: IN_PROGRESS','status: LOCAL_TECHNICAL_DELIVERED_AWAITING_OWNER_PLAYTEST').replace('S-005/DELIVERY_PREPARATION','S-005/OWNER_RUNTIME_PLAYTEST').replace('completed_steps: 4','completed_steps: 5').replace('runtime_changed: false','runtime_changed: true');s=re.sub(r'next_objective:.*','next_objective: Dono avaliar cinco sequencias em runtime com roteiro/atalhos QA.',s);s+='''verification: .atena/generated/assets-l001-admission-2026-10-13/verification.json
evidence: .atena/evidence/assets-l001-admission-2026-10-13.md
playtest: .atena/generated/assets-l001-admission-2026-10-13/PLAYTEST.md
human_runtime_playtest: PENDING_NOT_PERFORMED
''';s+='build_id: '+build+'\n';state.write_text(s,encoding='utf-8')
print('PASS all final checks: '+build)
