from pathlib import Path
import json,hashlib,subprocess,re,struct
root=Path(__file__).resolve().parents[3];out=Path(__file__).resolve().parent
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
packing=json.loads((out/'packing.json').read_text(encoding='utf-8'))
baseline=json.loads((root/'.atena/generated/hero-admission-preparation-2026-10-13/admission-manifest.json').read_text(encoding='utf-8'))
backup=json.loads((out/'backup-manifest.json').read_text(encoding='utf-8'))
allowed={r['destination'] for r in packing['records']}|{f'assets/heroes/{h}.png' for h in ['arlindo','erik']}|{'ui/hero_view.gd','tests/test_animation_assets.gd','tests/test_hero_own_art.gd'}
for rel,digest in baseline['protected_hashes'].items():
 if rel not in allowed:assert sha(root/rel)==digest,rel
for rel,digest in backup.items():assert sha(out/'backup'/rel)==digest
for e in packing['records']:
 assert sha(root/e['source'])==e['source_sha256']
 assert sha(root/e['path'])==e['sha256']==sha(root/e['destination'])
for p in baseline['portraits']:assert sha(root/p['candidate'])==p['sha256']==sha(root/p['destination'])
for name,text in [('suite.log','testes: 0 falha(s)'),('smoke.log','smoke: ok'),('capture.log','capture PASS:')]:
 log=(out/name).read_text(encoding='utf-8');assert text in log and 'SCRIPT ERROR' not in log and 'Parse Error' not in log
shots=sorted((out/'captures').glob('*.png'));assert len(shots)==32
for shot in shots:assert struct.unpack('>II',shot.read_bytes()[16:24])==(1280,720)
comparison=json.loads((out/'runtime-board.json').read_text(encoding='utf-8'))
assert all(p['rendered_rgba_equal'] for p in comparison['fallback_comparisons'].values())
head=subprocess.check_output(['git','rev-parse','--short','HEAD'],cwd=root).decode().strip()
fingerprint=hashlib.sha256(''.join(sha(root/rel) for rel in sorted(allowed)).encode()).hexdigest()
build=f'0.4.0/hero-admission-v01/{head}+local-{fingerprint[:12]}'
for hero,label in [('arlindo','Arlindo'),('erik','Erik')]:
 cmd=f'''@echo off
setlocal
cd /d "%~dp0..\\..\\.."
set "APPDATA=%~dp0qa-playtest-{hero}"
echo Local playtest build: {build}
"C:\\Users\\Higor Rossini\\Desktop\\Nottcard\\Godot_v4.7.2-stable_win64.exe" --path . --log-file ".atena/generated/hero-admission-2026-10-13/playtest-{hero}.log" res://tools/hero_art_playtest.tscn -- {hero}
endlocal
'''
 (out/f'Jogar-{label}.cmd').write_text(cmd,encoding='utf-8')
verification={'result':'PASS','revision':'hero-admission/v01','build_id':build,'runtime_fingerprint_sha256':fingerprint,'head_unchanged':head,'content_state':'DRAFT_ADMITTED_LOCAL','canonical_promotion':False,'strips':18,'frames':101,'stills':2,'source_atlas_hashes':'PASS','portraits':'V01_VISUALLY_APPROVED_AND_UNCHANGED','rgba_preservation':'PASS','margins_minimum_px':10,'baseline':448,'cell':[512,512],'suite_failures':0,'smoke_stages':9,'runtime_captures':32,'fallback_render_rgba_equal':True,'protected_files_unchanged':len(baseline['protected_hashes'])-len(allowed),'allowed_runtime_paths':sorted(allowed),'backups_verified':len(backup),'checks_environment':'APPDATA within workspace; distinct QA directories for suite/smoke/capture','human_playtest':'PENDING','browser_gallery_interactions':'NOT_TESTED','notes':['Godot root certificate-store warning','Shutdown resource/RID warnings in tool output; no script/test failure'],'commit_push_merge_export':False}
(out/'verification.json').write_text(json.dumps(verification,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
readme=f'''# Playtest local — hero-admission/v01

Build: `{build}`. Checkout d8a8, projeto Godot 4.7.2, versão 0.4.0; não é exportação nem release. Assets DRAFT admitidos localmente. A preparação artística foi aceita; fluidez no jogo aguarda feedback humano.

Objetivo: conferir continuidade/porte, pés e efeitos completos de Arlindo e Erik no tamanho real. Use [Arlindo](Jogar-Arlindo.cmd) e [Erik](Jogar-Erik.cmd); os launchers usam APPDATA e perfis QA locais separados, sem seu progresso real. Escopo: Dagruve, 18 atlas/101 poses, ER03 sete e ER06 seis; mesmos números, habilidades e dificuldade.

Para cada herói: andar 30–60 segundos nas oito direções; observar ataque automático; usar Q/botão da ativa; provocar morte se possível. Conferir retrato na HUD e ficha C. Observar salto de tamanho/base, arma trocando de mão, corte de corpo/efeito, loop abrupto ou perda de legibilidade. Critério técnico: ausência desses defeitos. Critério humano: aparência e fluidez aceitáveis; dificuldade/diversão não foram medidas por Atena.

Feedback esperado: herói, direção/ação, se está aceitável e quadro/captura do problema quando houver. O feedback é necessário para aceitar o marco visual em runtime e decidir o próximo lote; os checks técnicos não o substituem. Nenhum playtest humano realizado nesta execução.

Verificação: [resultado](verification.json), [galeria dos atlas](index.html), [prancha das capturas](runtime-board.png), [ordem da prancha](runtime-board.json), [32 capturas completas](captures/), [backup](backup-manifest.json).
'''
(out/'PLAYTEST.md').write_text(readme,encoding='utf-8')
evidence=f'''# Admissão local de Arlindo e Erik — v01, 2026-10-13

PLAN-053 / SPEC-121, IN_PLAN, modo per-plan. [Spec aprovada](../specs/SPEC-121-retomada-fila-imagens/hero-admission-v01.md). [Recibo de autorização](../generated/hero-admission-2026-10-13/authorization.json): dono aceitou os retratos AO01/ER01 v01 e aprovou por plano a preparação/admissão/verificação local. Conteúdo **DRAFT**, nenhuma promoção CANON. As opiniões históricas de fontes/animações não são reescritas.

S-001: 25 arquivos respaldados e hashes verificados, incluindo 18 destinos de animação, dois estáticos, código, dois testes e estado anterior. [Backup](../generated/hero-admission-2026-10-13/backup-manifest.json). Godot produziu 18 atlas/101 poses em512×512: células256×384 coladas em(128,80), centro256/base448; seis atlas de ações512×512 copiados byte a byte. Nenhuma reamostragem, pintura, limpeza de alfa ou pose nova. As101 regiões recompõem os pixels RGBA aceitos exatamente; padding transparente, margens>=10 e bases do movimento conferidas. [Packing](../generated/hero-admission-2026-10-13/packing.json). Dois estáticos são primeira pose idle. Prévia estática de ambos inspecionada; [galeria](../generated/hero-admission-2026-10-13/index.html) preparada, controles do navegador não testados.

S-002: 18 atlas e dois estáticos admitidos nos destinos limitados. Retratos v01 já eram idênticos aos atuais; nada substituído nesses dois PNGs. `ui/hero_view.gd`: célula512×512, base448, ER03=7 mantida e ER06=6; porte62/64 e alturas290/300 preservados. Taxas/espelhamento/habilidades/balanceamento não mudaram. Não existe move.png nestes dois conjuntos; cinco direções fonte mantidas. Ajuste IN_PLAN necessário ao fallback: para estes dois heróis, desenhar o estático usando escala/âncora do idle; o antigo rect72px contava padding como corpo. Outros heróis mantêm o fallback anterior. Validações existentes passaram a medir toda a altura de célula e a conferir região/base/contagem admitidas. [Recibo da admissão](../generated/hero-admission-2026-10-13/admission-receipt.json).

S-003: importação Godot4.7.2 concluída; [suíte](../generated/hero-admission-2026-10-13/suite.log) **0 falhas**, [smoke](../generated/hero-admission-2026-10-13/smoke.log) **nove fases OK**. [Harness/captura](../generated/hero-admission-2026-10-13/capture.gd) verifica oito direções/flip, ações e morte;32 capturas1280×720 em Dagruve, incluindo idle/HUD, oito direções, ataque, ativa, morte/meio/final, ficha, fallback e seleção para cada herói. [Log](../generated/hero-admission-2026-10-13/capture.log), [prancha de28 recortes em tamanho nativo](../generated/hero-admission-2026-10-13/runtime-board.png), [ordem/comparação](../generated/hero-admission-2026-10-13/runtime-board.json). Prancha inteira e capturas representativas de cena/UI inspecionadas pelo modelo. Fallback e primeiro idle coincidem pixel a pixel na região600,315,80,85 de ambos. Opinião artística/fluidez continua pendente. Não foi playtest humano.

Checks usaram APPDATA em diretórios QA dentro do workspace, separados por suite/smoke/capture, e save/profile descartáveis. Um arquivo QA da captura existe nesse diretório isolado. Não houve checksum prévio do save real; sua preservação decorre do isolamento dos comandos, não de uma comparação de hashes antes/depois. Aviso de leitura de certificados do Godot e avisos de RIDs/recursos remanescentes ao encerrar aparecem nos outputs; sem SCRIPT ERROR/Parse Error ou falhas de testes. Nenhuma dependência instalada.

S-004: [verificação final](../generated/hero-admission-2026-10-13/verification.json), fontes de atlas/retratos e backups íntegros;2.972 arquivos protegidos fora dos23 destinos de runtime/testes permitidos inalterados. Git diff --check passou; HEAD `{head}` preservado, índice não alterado pela execução. Build local `{build}`. [Roteiro e launchers](../generated/hero-admission-2026-10-13/PLAYTEST.md) preparados antes do playtest. Feedback humano é necessário para aceitar o marco visual em runtime e decidir próximos assets.

Plano **4/4 entregue tecnicamente**, checkpoint OWNER_RUNTIME_PLAYTEST. Próximo objetivo: dono avaliar os dois heróis seguindo o roteiro; registrar direção/ação/quadro de defeitos ou aceite. Nenhum BLOCKING técnico principal permanece; playtest subjetivo DEFERRED, bugs globais BUG-025/027/028/029 e áudio continuam pendentes. Backlog:0P0,4P1abertos,16implementados aguardando playtest,0alertas. Retorno PLAN-071 B-006/S-011 preservado. Sem commit, push, merge, exportação, publicação ou CANON.
'''
(root/'.atena/evidence/hero-admission-2026-10-13.md').write_text(evidence,encoding='utf-8')
p=root/'.atena/state/hero-admission.yaml';s=p.read_text(encoding='utf-8').replace('status: EXECUTING','status: LOCAL_TECHNICAL_DELIVERED_AWAITING_OWNER_PLAYTEST').replace('checkpoint: S-003/RUNTIME_VERIFICATION','checkpoint: S-004/OWNER_RUNTIME_PLAYTEST').replace('current_step_position: 3','current_step_position: 4').replace('completed_steps: 2','completed_steps: 4').replace('remaining_steps_after_current: 1','remaining_steps_after_current: 0').replace('S-003: IN_PROGRESS, S-004: NOT_STARTED','S-003: COMPLETED, S-004: COMPLETED').replace('next_objective: Importar e validar suite, smoke, capturas e fallback em perfil QA isolado.','next_objective: Dono avaliar fluidez, aparencia, porte e efeitos em playtest dos dois herois.');s+=f'build_id: "{build}"\nevidence: .atena/evidence/hero-admission-2026-10-13.md\nverification: .atena/generated/hero-admission-2026-10-13/verification.json\nnext_execution_authorized: false\n';p.write_text(s,encoding='utf-8')
p=root/'.atena/state/plan.yaml';s=p.read_text(encoding='utf-8');prefix,tail=s.split('hero_admission_2026_10_13:',1);tail=tail.replace('status: EXECUTING','status: LOCAL_TECHNICAL_DELIVERED_AWAITING_OWNER_PLAYTEST').replace('checkpoint: S-003/RUNTIME_VERIFICATION','checkpoint: S-004/OWNER_RUNTIME_PLAYTEST');tail+='  completed_steps: 4\n  total_steps: 4\n  evidence: .atena/evidence/hero-admission-2026-10-13.md\n';p.write_text(prefix+'hero_admission_2026_10_13:'+tail,encoding='utf-8')
spec=root/'.atena/specs/SPEC-121-retomada-fila-imagens/hero-admission-v01.md';s=spec.read_text(encoding='utf-8');s+='\n## Resultado da execução\n\nQuatro etapas técnicas concluídas. [Evidência](../../evidence/hero-admission-2026-10-13.md) e [verificação](../../generated/hero-admission-2026-10-13/verification.json). Entrega local DRAFT; aceite humano em runtime pendente. Gates de Git/publicação/CANON não foram acionados.\n';spec.write_text(s,encoding='utf-8')
links=0
for p in [spec,root/'.atena/evidence/hero-admission-2026-10-13.md',out/'PLAYTEST.md']:
 for link in re.findall(r'\]\(([^)]+)\)',p.read_text(encoding='utf-8')):
  assert (p.parent/link).exists(),link;links+=1
verification['active_document_links_verified']=links
(out/'verification.json').write_text(json.dumps(verification,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'result':'PASS','steps':'4/4','build_id':build,'document_links':links,'protected_files_unchanged':verification['protected_files_unchanged'],'human_playtest':'PENDING'},ensure_ascii=False,indent=2))
