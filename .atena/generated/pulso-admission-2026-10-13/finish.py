from pathlib import Path
import json,hashlib,subprocess,re,html
root=Path(__file__).resolve().parents[3];out=Path(__file__).resolve().parent
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
snap=json.loads((out/'protected.json').read_text(encoding='utf-8'));assert all(sha(root/p)==h for p,h in snap.items() if p!='ui/run.gd')
auth=json.loads((out/'authorization.json').read_text(encoding='utf-8'))
for e in auth['sources']:assert sha(root/e['path'])==e['sha256']
backup=json.loads((out/'backup.json').read_text(encoding='utf-8'))
for p,h in backup['existing'].items():assert sha(out/'backup'/p)==h
for name,text in [('suite.log','testes: 0 falha(s)'),('smoke.log','smoke: ok'),('capture.log','capture PASS:')]:
 s=(out/name).read_text(encoding='utf-8');assert text in s and 'SCRIPT ERROR' not in s and 'Parse Error' not in s
runtime=json.loads((out/'runtime-checks.json').read_text(encoding='utf-8'));assert runtime['result']=='PASS' and len(runtime['weapons'])==6 and runtime['freed_after_completion']
shots=sorted((out/'captures').glob('*.png'));assert len(shots)==16
assert sha(out/'pulso_radiante.png')==sha(root/'assets/vfx/pulso_radiante.png')
paths=['assets/vfx/pulso_radiante.png','core/radiant_pulse_vfx.gd','ui/run.gd','tests/test_radiant_pulse_vfx.gd']
fingerprint=hashlib.sha256(''.join(sha(root/p) for p in paths).encode()).hexdigest()
head=subprocess.check_output(['git','rev-parse','--short','HEAD'],cwd=root).decode().strip();build=f'0.4.0/pulso-admission-v01/{head}+local-{fingerprint[:12]}'
for tag,weapon,extra in [('Sentenca','sentenca_de_lliira',''),('Chuva','chuva_de_estrelas',''),('Reduzido','sentenca_de_lliira',' --reduced')]:
 cmd=f'''@echo off
setlocal
cd /d "%~dp0..\\..\\.."
set "APPDATA=%~dp0qa-playtest-{tag.lower()}"
echo Local QA build: {build}
"C:\\Users\\Higor Rossini\\Desktop\\Nottcard\\Godot_v4.7.2-stable_win64.exe" --path . --log-file ".atena/generated/pulso-admission-2026-10-13/playtest-{tag.lower()}.log" res://.atena/generated/pulso-admission-2026-10-13/playtest.tscn -- {weapon}{extra}
endlocal
'''
 (out/f'Jogar-{tag}.cmd').write_text(cmd,encoding='utf-8')
gallery='''<!doctype html><html lang="pt-BR"><meta charset="utf-8"><title>Pulso admitido localmente — DRAFT v01</title><style>body{background:#181c24;color:#eee;font:16px system-ui;max-width:1280px;margin:30px auto}.grid{display:grid;grid-template-columns:1fr 1fr;gap:18px}img{width:100%}h1,h2{color:#e6c480}.atlas{background:#000}figure{margin:0}</style><h1>Pulso Radiante · admissão local DRAFT</h1><p>Seis fases em0,35s; seis novas radiantes; impacto reduzido mantém anel simples. Aceite de gameplay/ritmo pendente.</p><img class="atlas" src="black-preview.png"><div class="grid">'''
for shot in shots:gallery+=f'<figure><h2>{html.escape(shot.stem)}</h2><a href="captures/{shot.name}"><img src="captures/{shot.name}"></a></figure>'
(out/'index.html').write_text(gallery+'</div></html>',encoding='utf-8')
readme=f'''# Playtest Pulso Radiante — DRAFT v01

Build local `{build}`; checkout d8a8, Godot4.7.2, Dagruve, Maelor em perfil QA. Não é release/exportação. O harness equipa uma arma de teste somente no perfil descartável.

Objetivo: avaliar legibilidade, intensidade e ritmo do pulso de seis fases, duração0,35s, projeção2:1 e centro nos pés. As fontes foram aceitas visualmente; aparência em combate ainda precisa de feedback.

1. [Sentença de Lliira](Jogar-Sentenca.cmd): caminhar por30–60s e esperar inimigos entrarem no alcance, pois a nova só dispara se houver alvo. Observar crescimento, pico, afinamento e resíduos, em trechos claros/escuros do chão.
2. [Chuva de Estrelas](Jogar-Chuva.cmd): repetir para o raio maior, conferindo alcance visual, cortes, brilho e se o personagem continua legível.
3. [Impacto reduzido](Jogar-Reduzido.cmd): repetir; deve aparecer o anel simples anterior, sem o novo flash.

Critério técnico: efeito centrado, sem fundo retangular/cortes, raio coerente e sem ficar preso em tela. Critério humano: legível, confortável e ritmo aceitável. Atena confere funcionamento; você avalia sensação/diversão. Feedback esperado: arma/modo, aceitável ou defeito específico (fase/raio/cor), captura se possível. Não houve playtest humano nesta execução; esse feedback é necessário para aceitar o marco visual em runtime.

Cada launcher isola APPDATA/save em pasta QA local; seu progresso real não é usado. [Galeria das capturas](index.html), [verificação](verification.json), [dados dos eventos](runtime-checks.json), [backup](backup.json).
'''
(out/'PLAYTEST.md').write_text(readme,encoding='utf-8')
verify={'result':'PASS','revision':'pulso-admission/v01','build_id':build,'content_state':'DRAFT_ADMITTED_LOCAL','canonical_promotion':False,'atlas_sha256':sha(root/paths[0]),'runtime_fingerprint':fingerprint,'source_hashes':'PASS','frame_count':6,'cell':[256,256],'duration_seconds':0.35,'peak_ring_radius_px':88,'suite_failures':0,'smoke_stages':9,'weapon_events_verified':6,'captures':16,'reduced_impact_fallback':True,'unsupported_event_fallback':True,'absent_invalid_texture_fallback':'UNIT_CHECKED','freed_after_completion':True,'protected_preexisting_files_unchanged':len(snap)-1,'only_changed_preexisting_runtime_file':'ui/run.gd','runtime_additions':paths[:2],'test_addition':paths[3],'gameplay_tables_unchanged':True,'hero_admission_preserved':True,'human_playtest':'PENDING','browser_gallery':'NOT_TESTED','git_export_publish':False,'notes':['Godot certificate-store warning','Suite shutdown resource/RID warnings','Test-only Image.load_from_file res:// warning; runtime loads Texture2D','Capture attempt1 failed because QA inspected consumed events; harness fixed, final capture PASS']}
(out/'verification.json').write_text(json.dumps(verify,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
ev=f'''# Pulso Radiante — admissão local v01, 2026-10-13

PLAN-053/SPEC-121, IN_PLAN após aprovação da proposta, modo per-plan. [Spec](../specs/SPEC-121-retomada-fila-imagens/pulso-admission-v01.md), [autorização](../generated/pulso-admission-2026-10-13/authorization.json). Dono: “1. Por plano — uma aprovação para todo o escopo planejado.” Seis fontes revisadas/aceitas, [recibo anterior](../generated/pulso-resume-2026-10-13/visual-acceptance.json). Conteúdo DRAFT; nenhuma promoção CANON.

S-001: backups e hashes antes de escrita; seis originais1254×1254 preservados. Godot Lanczos gerou cópias1024×1024 para auditoria e atlas1536×256, com redução direta1254→256 por canvas, igual em todas as fases. RGB branco/alfa=luminânciaRec709, piso<=2/255 removido só no derivado. [Packing](../generated/pulso-admission-2026-10-13/packing.json), [auditoria](../generated/pulso-admission-2026-10-13/derivative-audit.json), [prévia](../generated/pulso-admission-2026-10-13/black-preview.png). Pico medido88px (proxy histórico87,58px na escala256); pivô comum128/128, sem ajuste de escala individual. Bordas transparentes,312pixels com alfa>12 na dissipação N06. Prévia dos seis inspecionada; sem perda artística além das transformações aprovadas. Centro fotométrico é proxy, não pivô exato; variações naturais da luz preservadas.

S-002: atlas admitido e helper visual `core/radiant_pulse_vfx.gd` criado, roteado no consumo nova de `ui/run.gd`. Só dtype radiante e allowlist das seis armas. Duração0,35s, seis fases one-shot, cache/material aditivo, posição do evento. Raio luminoso do pico calibrado pela projeção `radius*TILE_W*sqrt(2)/2` e metade na vertical, com pico88px. Cor `impact_accent` existente. `_ring` mantido como fallback para tipos/armas fora do escopo, recurso indisponível ou impacto reduzido. Som anterior preservado; sem RNG/dano/colisão/cooldown alterados. Backup de run/estado e destinos novos registrados; rollback restaura run e remove referências aos novos arquivos sem apagar fontes/história.

S-003: importação concluída; [suíte](../generated/pulso-admission-2026-10-13/suite.log) **0 falhas**, [smoke](../generated/pulso-admission-2026-10-13/smoke.log) **nove fases OK**. Teste focado verifica allowlist/dtype/tipo, ausência/atlas inválido, regiões, cadência, bordas/resíduos, projeção/tinta/aditivo e evento intacto. [Harness runtime](../generated/pulso-admission-2026-10-13/capture.gd) dispara via Battle._fire e Run._consume_events para todas as seis armas, confere pivô/escala, captura seis fases, duas tintas e fallbacks. [Dados PASS](../generated/pulso-admission-2026-10-13/runtime-checks.json), [log final](../generated/pulso-admission-2026-10-13/capture.log), [galeria16 capturas](../generated/pulso-admission-2026-10-13/index.html). Liberação após término conferida com espera0,55s. Capturas representativas inspecionadas no tamanho real, sem retângulo preto/corte ou deslocamento visível; julgamento do modelo não é aceite humano de ritmo/conforto.

Primeira captura falhou no harness por ler a lista de eventos depois que o consumidor a limpava; [log preservado](../generated/pulso-admission-2026-10-13/capture-attempt1.log). Corrigido com snapshot do evento antes do consumo; processo desse harness encerrado e captura final PASS. Sem reparo adicional no jogo. Logs têm aviso de certificado e outputs de suíte/smoke têm avisos de recursos/RIDs ao encerrar. O teste carrega imagem fonte por res:// e emite aviso sobre exportação; renderer do jogo usa Texture2D importada, nenhuma exportação executada. Não houve SCRIPT ERROR/Parse Error nos checks finais.

Perfis APPDATA/save QA separados no workspace para prepare/import/suite/smoke/capture; nenhum save real usado. Fontes e2.994arquivos preexistentes runtime/testes fora de run.gd inalterados por hash, preservando a admissão dos heróis. Adições limitadas a atlas/helper/teste; gameplay/tabelas intactos. [Verificação final](../generated/pulso-admission-2026-10-13/verification.json), [backup](../generated/pulso-admission-2026-10-13/backup.json). HEAD `{head}` e índice preservados; nenhuma dependência ou geração nova.

S-004: entrega técnica **4/4**, build local `{build}`. [Roteiro/launchers](../generated/pulso-admission-2026-10-13/PLAYTEST.md) preparados antes de solicitar playtest. Nenhum BLOCKING técnico principal permanece; aceite humano de intensidade/ritmo/legibilidade DEFERRED e não realizado. Próximo checkpoint OWNER_RUNTIME_PLAYTEST: testar Sentença, Chuva e impacto reduzido, informar aceitável/defeitos por arma/fase/raio/cor. Atena não afirma diversão por métricas. Sem CANON, commit, push, merge, exportação ou publicação. BUG-025/027/028/029 e playtests dos heróis/ART032 continuam pendentes; PLAN071 B006/S011 preservado.
'''
(root/'.atena/evidence/pulso-admission-2026-10-13.md').write_text(ev,encoding='utf-8')
state=root/'.atena/state/pulso-admission.yaml';s=state.read_text(encoding='utf-8').replace('status: EXECUTING_APPROVED','status: LOCAL_TECHNICAL_DELIVERED_AWAITING_OWNER_PLAYTEST').replace('checkpoint: S-003/RUNTIME_VERIFICATION','checkpoint: S-004/OWNER_RUNTIME_PLAYTEST').replace('completed_steps: 2','completed_steps: 4').replace('current_step_position: 3','current_step_position: 4').replace('remaining_steps_after_current: 1','remaining_steps_after_current: 0').replace('executable: true','executable: false').replace('next_objective: Validar suite/smoke, todos os eventos, fases e fallback em QA isolado.','next_objective: Dono avaliar intensidade, legibilidade e ritmo do pulso no playtest.');s+=f'build_id: "{build}"\nevidence: .atena/evidence/pulso-admission-2026-10-13.md\nverification: .atena/generated/pulso-admission-2026-10-13/verification.json\n';state.write_text(s,encoding='utf-8')
p=root/'.atena/state/plan.yaml';s=p.read_text(encoding='utf-8');prefix,tail=s.split('pulso_admission_2026_10_13:',1);tail=tail.replace('status: EXECUTING','status: LOCAL_TECHNICAL_DELIVERED_AWAITING_OWNER_PLAYTEST').replace('checkpoint: S-003/RUNTIME_VERIFICATION','checkpoint: S-004/OWNER_RUNTIME_PLAYTEST');tail+='  completed_steps: 4\n  total_steps: 4\n  evidence: .atena/evidence/pulso-admission-2026-10-13.md\n';p.write_text(prefix+'pulso_admission_2026_10_13:'+tail,encoding='utf-8')
p=root/'.atena/state/plan-053-imagens.yaml';s=p.read_text(encoding='utf-8').replace('status: PULSO_ACCEPTED_DRAFT_ADMISSION_PROPOSED','status: PULSO_ADMITTED_LOCAL_OWNER_PLAYTEST_PENDING').replace('checkpoint: S-007/VFX/PULSO/ADMISSION_PLAN_APPROVAL','checkpoint: S-007/VFX/PULSO/OWNER_RUNTIME_PLAYTEST');s=re.sub(r'^  current:.*$',"  current: 'Pulso seis fases admitidas localmente DRAFT, checks PASS, aceite humano runtime pendente.'",s,count=1,flags=re.M);s=re.sub(r'^  next:.*$',"  next: 'Playtest humano Pulso; depois decidir outra familia de VFX existente. Fila02236/36 e Fila02360/60 no historico.'",s,count=1,flags=re.M);p.write_text(s,encoding='utf-8')
spec=root/'.atena/specs/SPEC-121-retomada-fila-imagens/pulso-admission-v01.md';s=spec.read_text(encoding='utf-8');s+='\n## Resultado\n\nQuatro etapas técnicas concluídas; [evidência](../../evidence/pulso-admission-2026-10-13.md). Pulso admitido localmente DRAFT. Cadência/material/calibração conformes à proposta; aceite humano em jogo pendente.\n';spec.write_text(s,encoding='utf-8')
links=0
for p in [root/'.atena/evidence/pulso-admission-2026-10-13.md',spec,out/'PLAYTEST.md']:
 for target in re.findall(r'\]\(([^)]+)\)',p.read_text(encoding='utf-8')):assert (p.parent/target).exists(),target;links+=1
for target in re.findall(r'(?:src|href)="([^"]+)"',(out/'index.html').read_text(encoding='utf-8')):assert (out/target).exists();links+=1
verify['active_links_verified']=links;(out/'verification.json').write_text(json.dumps(verify,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'result':'PASS','steps':'4/4','links':links,'build':build,'human_playtest':'PENDING'},indent=2))
