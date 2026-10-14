from pathlib import Path
import hashlib,html,json,re,subprocess,sys
out=Path(__file__).resolve().parent;root=out.parents[2];sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
a=json.loads((out/'authorization.json').read_text(encoding='utf-8'))
names=[f['name'] for f in a['families']]
paths=['core/battle.gd','core/hero_active_vfx.gd','ui/hero_active_vfx.gd','ui/run.gd','tests/test_assets_l002_vfx.gd']+['assets/vfx/'+n+'.png' for n in names]
hashes={p:sha(root/p) for p in paths};base=subprocess.check_output(['git','rev-parse','--short','HEAD'],cwd=root,text=True).strip()
build='0.4.0/assets-l002-admission-v01/'+base+'+local-'+hashlib.sha256(json.dumps(hashes,sort_keys=True).encode()).hexdigest()[:12]
launchers=[('Jogar-'+h.title(),h,'') for h in ['sylas','kayron','korrak','leoric','nyrelia','zynara','bromnor']]+[('Jogar-Reduzido','kayron','--reduced'),('Jogar-Tou-Um','korrak','--tou-um')]
reports=[(prefix,json.loads((out/prefix/'runtime-checks.json').read_text(encoding='utf-8'))) for prefix in ['','l001-regression/','vfx-regression/']]
assert [len(r['screenshots']) for _,r in reports]==[99,100,22]
for n,hero,flags in launchers:
 body=f'''@echo off
setlocal
cd /d "%~dp0..\\..\\.."
set "APPDATA=%~dp0qa-{n}"
echo Local QA build: {build}
"C:\\Users\\Higor Rossini\\Desktop\\Nottcard\\Godot_v4.7.2-stable_win64.exe" --path . --log-file ".atena/generated/assets-l002-admission-2026-10-14/{n}.log" %* res://.atena/generated/assets-l002-admission-2026-10-14/playtest.tscn -- {hero} {flags}
endlocal
''';(out/(n+'.cmd')).write_text('\n'.join(l.rstrip() for l in body.splitlines())+'\n',encoding='utf-8',newline='\r\n')
(out/'build.json').write_text(json.dumps({'build_id':build,'runtime_sha256':hashes,'exported':False,'content_state':'DRAFT_WITH_H403_V02_HISTORICAL_GATE_PRESERVED'},indent=2)+'\n',encoding='utf-8')
(out/'PLAYTEST.md').write_text(f'''# Playtest L002 — sete habilidades / DRAFT v01

Build local `{build}`, checkout d8a8/Godot4.7.2, Dagruve, perfilQA isolado, sem exportação. Escopo42fontes/seteatlas: sete habilidades. Objetivo: avaliar leitura, tamanho/brilho, continuidade, orientação e efeitos que acompanham estados reais. Gameplay preservado; técnico não comprova sensação ou diversão. Roteiro preparado antes do playtest humano; smoke15quadros dos atalhos não é jogar.

Use **Q ou botão direito** para habilidade, cooldown normal; jogar30–60s por herói e repetir situações em pisos claros/escuros.

1. [Sylas](Jogar-Sylas.cmd): dash em oito direções, depois perto de parede/obstáculo para encurtar ou impedir. Rastro0,30s parte da origem real até destino, não continua seguindo o herói; conferir crescimento/fumaça/máscaras/fim em resíduos. Isca e explosão existentes permanecem.
2. [Kayron](Jogar-Kayron.cmd): ativar e mover; ciclo elétrico acompanha pés enquanto bônus ativo, até7s atuais, sem reaplicar buff. Conferir conforto, centro vazio e fim sem efeito preso.
3. [Korrak](Jogar-Korrak.cmd): perto de grupos, observar pulso0,35s, rachaduras/chamas e ausência de cortes nas bordas. [Bromnor](Jogar-Bromnor.cmd): escudo/onda0,35s; guarda lógica5s/carga e repulsão continuam. Cada um tem um atlas por nova; ring genérico de ativação anterior permanece.
4. [Leoric](Jogar-Leoric.cmd): constelação0,35s de raio visual2tiles, junto a oito projéteis existentes. Alcance11dos projéteis preservado; flash não usa esse alcance para cobrir a tela. Conferir leitura entre pulso e projéteis.
5. [Nyrelia](Jogar-Nyrelia.cmd): dominar inimigo comum; mover herói e alvo, aproximar outro inimigo. Sigilo acompanha exclusivamente o alvo escolhido, até7s ou morte/remoção, sem saltar ao mais próximo. Chefe/ausência de alvo não deve criar atlas.
6. [Zynara](Jogar-Zynara.cmd): relógio0,35s/raio visual7tiles, lento lógico4s preservado. Avaliar tamanho/brilho do pulso breve, não esperar anel durante toda lentidão.
7. [Reduzido com Kayron](Jogar-Reduzido.cmd) e [tinta Tou Um com Korrak](Jogar-Tou-Um.cmd): comparar. Nas Opções, alternar reduzir efeitos durante aura/ciclo; atlas deve sair e próximas ativações usam feedback simples anterior. Pausar/retomar: efeitos não avançam durante pausa nem reiniciam indevidamente.

Critérios técnicos: orientação/âncora/alvo corretos, sem fundo retangular/corte, sem efeito preso, fallback/reduzido preservados. Critérios humanos: motivos legíveis, brilho confortável e ritmo aceitável sob combate/sobreposição. Atena verifica consistência; você avalia sensação/dificuldade/diversão. Feedback esperado: herói/modo/cor/direção, aceitável ou problema, fase/ciclo/pulso. Playtest humano **PENDENTE**, necessário ao aceite visual em runtime.

Nove atalhos isolam APPDATA/saveQA nesta pasta, equipamento inicial e cooldowns normais; seu progresso real não é usado. [Galeria221capturas](index.html), [verificação](verification.json), [paridade140cenários](parity.json), [checksL002](runtime-checks.json), [regressãoL001](l001-regression/runtime-checks.json), [projéteis/Pulso/Ampulheta](vfx-regression/runtime-checks.json).
''',encoding='utf-8')
page=f'<!doctype html><html lang="pt-BR"><meta charset="utf-8"><title>L002 admissão DRAFT</title><style>body{{background:#171c24;color:#eee;font:16px system-ui;max-width:1280px;margin:24px auto}}img{{max-width:100%}}h1,h2{{color:#e5c178}}a{{color:#a7d3ef}}</style><h1>L002 · sete habilidades admitidas localmente</h1><p>{html.escape(build)}</p><p>221capturas automáticas; playtest humano pendente. <a href="PLAYTEST.md">Roteiro/nove atalhos</a></p>'
for prefix,report in reports:
 page+='<h1>'+({'':'L002/sete habilidades','l001-regression/':'Regressão L001/físicos/Estocada/Chicote','vfx-regression/':'Projéteis/Pulso/Ampulheta'}[prefix])+'</h1>'
 for tag in report['screenshots']:page+=f'<h2>{html.escape(tag)}</h2><a href="{prefix}captures/{tag}.png"><img loading="lazy" src="{prefix}captures/{tag}.png"></a>'
(out/'index.html').write_text(page,encoding='utf-8')
state=root/'.atena/state/assets-l002-admission.yaml'
if '--prepare' in sys.argv:
 s=state.read_text(encoding='utf-8').replace('S-004/VALIDATION','S-005/DELIVERY_PREPARATION').replace('completed_steps: 3','completed_steps: 4').replace('current_step_position: 4','current_step_position: 5').replace('remaining_steps_after_current: 1','remaining_steps_after_current: 0');state.write_text(s,encoding='utf-8');print('Prepared9launchers, build, gallery and playtest: '+build);raise SystemExit(0)
logs=['focused-final.log','suite.log','smoke.log','parity-final.log','capture-final.log','l001-regression-final.log','vfx-regression-final.log','import-final.log']+[n+'.log' for n,_,_ in launchers]
for n in logs:
 text=(out/n).read_text(encoding='utf-8-sig');assert all(x not in text for x in ['SCRIPT ERROR','Parse Error','Assertion failed']),n
assert 'testes: 0 falha(s)' in (out/'suite.log').read_text(encoding='utf-8')
assert 'smoke: ok' in (out/'smoke.log').read_text(encoding='utf-8')
assert 'L002 focused: 0 failures' in (out/'focused-final.log').read_text(encoding='utf-8')
assert json.loads((out/'parity.json').read_text(encoding='utf-8'))['status']=='PASS'
for prefix,report in reports:
 assert report['status']=='PASS'
 for tag in report['screenshots']:assert (out/prefix/'captures'/(tag+'.png')).exists()
protected=json.loads((out/'protected.json').read_text(encoding='utf-8'));changed=[p for p,h in protected.items() if sha(root/p)!=h]
assert set(changed)=={'core/battle.gd','core/hero_active_vfx.gd','ui/hero_active_vfx.gd','ui/run.gd'},changed
for p,h in json.loads((out/'backup.json').read_text(encoding='utf-8')).items():assert sha(out/'backup'/p)==h
for e in a['sources']:assert sha(root/e['path'])==e['sha256']
for n in names:assert sha(out/(n+'.png'))==sha(root/'assets/vfx'/(n+'.png'))
for n,h,_ in launchers:assert 'QA L002 launcher: '+h in (out/(n+'.log')).read_text(encoding='utf-8')
old=(out/'backup/core/battle.gd').read_text(encoding='utf-8');current=(root/'core/battle.gd').read_text(encoding='utf-8')
start=current.index('func use_active(');end=current.index('func minute()',start);oldstart=old.index('func use_active(');oldend=old.index('func minute()',oldstart)
assert current[:start]+old[oldstart:oldend]+current[end:]==old,'Battle modified outside use_active'
v={'status':'PASS','build_id':build,'technical_steps_completed':5,'sources_verified':42,'atlases':7,'suite_failures':0,'smoke_stages':9,'captures':221,'capture_groups':[99,100,22],'parity':json.loads((out/'parity.json').read_text(encoding='utf-8')),'preexisting_runtime_files':len(protected),'unchanged_preexisting_runtime_files':len(protected)-4,'allowed_changed_files':changed,'battle_change_limited_to_use_active':True,'data_overlay_melee_orbs_pulse_hourglass_L001_atlases_tests_unchanged':True,'runtime_sha256':hashes,'logs':logs,'native_backup_atlas_hashes':'PASS','human_playtest':'PENDING_NOT_PERFORMED','content_state':'DRAFT_WITH_H403_V02_HISTORICAL_GATE_PRESERVED','canonical_promotion':False,'git_operations':'NONE','exported':False,'known_log_warnings':'Certificate store unavailable in sandbox; Image.load and resource/RID cleanup warnings during test teardown/short launcher exit. No script/parse/assert errors in final logs.'}
(out/'verification.json').write_text(json.dumps(v,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
s=state.read_text(encoding='utf-8').replace('status: IN_PROGRESS','status: LOCAL_TECHNICAL_DELIVERED_AWAITING_OWNER_PLAYTEST').replace('S-005/DELIVERY_PREPARATION','S-005/OWNER_RUNTIME_PLAYTEST').replace('completed_steps: 4','completed_steps: 5').replace('runtime_changed: false','runtime_changed: true');s=re.sub(r'next_objective:.*','next_objective: Dono avaliar sete habilidades em runtime no build local identificado.',s);s=re.sub(r'next_inputs:.*','next_inputs: Roteiro/nove atalhos QA, sete herois, duas tintas/reduzido e galeria221.',s);s=re.sub(r'next_output:.*','next_output: Feedback humano heroi/modo/cor/direcao, aceitavel ou problema.',s);s=re.sub(r'next_checks:.*','next_checks: Leitura/brilho/ritmo/alinhamento, dash real, alvo fixo, ciclos e pulsos breves.',s);s+='verification: .atena/generated/assets-l002-admission-2026-10-14/verification.json\nevidence: .atena/evidence/assets-l002-admission-2026-10-14.md\nplaytest: .atena/generated/assets-l002-admission-2026-10-14/PLAYTEST.md\nhuman_runtime_playtest: PENDING_NOT_PERFORMED\nbuild_id: '+build+'\n';state.write_text(s,encoding='utf-8')
print('PASS logs, source/backups/runtime contract and protected hashes: '+build)
