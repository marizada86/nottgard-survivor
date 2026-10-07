from pathlib import Path
import hashlib
import json
import shutil

root = Path(__file__).resolve().parents[4]
out = Path(__file__).resolve().parent
ws = root / '.atena'
report = json.loads((out / 'menu-start-report.json').read_text(encoding='utf-8'))
assert len(report['checks']) == 38 and not report['failures']
assert 'testes: 0 falha(s)' in (out / 'suite.log').read_text(encoding='utf-8')
state_path = ws / 'state/plan-068-controles-xbox-playstation.yaml'
state = state_path.read_text(encoding='utf-8')
assert '  map_confirmation:' not in state, 'Reconciliacao ja realizada'
for path in [state_path, ws / 'state/plan.yaml', ws / 'backlog/BUGS.md', ws / 'backlog/README.md']:
    target = out / 'recovery' / path.relative_to(root)
    target.parent.mkdir(parents=True, exist_ok=True)
    shutil.copy2(path, target)
state = state.replace('controller-experience/v02/', 'controller-experience/v03/')
state = state.replace("    request: 'Dono: no Quartel com herois e fases falta o botao jogar; nao conseguiu iniciar tentativa.'", "    request: 'Dono: ao apertar A/X no mapa, automaticamente ser direcionado para jogar.'")
state = state.replace('Dono retestar acesso a Jogar no P068-v02', 'Dono retestar confirmar mapa para Jogar no P068-v03')
state += '''  map_confirmation:
    classification: IN_PLAN
    date: '2026-10-06'
    approval: EXISTING_PER_PLAN_AND_OWNER_REQUEST
    status: LOCAL_VALIDATED_OWNER_RETEST_PENDING
    behavior: CONFIRM_STAGE_FOCUSES_PLAY_NEXT_PRESS_STARTS_RUN
    locked_stage: KEEP_FOCUS_NO_START
    held_input: BLOCK_UNTIL_RELEASE
    evidence: .atena/evidence/EVID-186-quartel-confirmar-mapa-para-jogar-2026-10-06.md
    menu_start_checks: 38
    hardware_acceptance: false
'''
state_path.write_text(state, encoding='utf-8')
central_path = ws / 'state/plan.yaml'
central = central_path.read_text(encoding='utf-8-sig')
central = central.replace('P068-v02 corrige Jogar no Quartel (BUG-030); 21 verificacoes acesso, 90 controle, 144 mobile e suite zero falhas.', 'P068-v03: confirmar mapa foca Jogar; nova confirmacao inicia tentativa. 38 verificacoes acesso e suite zero falhas; regressao anterior em EVID-185.')
central_path.write_text(central, encoding='utf-8')
bugs_path = ws / 'backlog/BUGS.md'
bugs = bugs_path.read_text(encoding='utf-8-sig')
lines = bugs.splitlines()
for index, line in enumerate(lines):
    if line.startswith('| BUG-030 |'):
        lines[index] = line.replace('P068-v02:', 'P068-v03:').replace('21 verificações de acesso e início', 'confirmação no mapa direciona o foco para Jogar; 38 verificações de acesso e início').replace('aguarda reteste físico', 'aguarda reteste físico; [EVID-186](../evidence/EVID-186-quartel-confirmar-mapa-para-jogar-2026-10-06.md)')
bugs_path.write_text('\n'.join(lines) + '\n', encoding='utf-8')
readme_path = ws / 'backlog/README.md'
readme_path.write_text(readme_path.read_text(encoding='utf-8-sig').replace('`EVID-185`', '`EVID-187`'), encoding='utf-8')
launcher = (out.parent / 'v02/Abrir-teste-Xbox.cmd').read_text(encoding='utf-8').replace(r'v02\pilot.log', r'v03\pilot.log')
(out / 'Abrir-teste-Xbox.cmd').write_text(launcher, encoding='utf-8')
guide = (out.parent / 'v02/Como-testar-Xbox.md').read_text(encoding='utf-8').replace('P068-v02', 'P068-v03')
guide = guide.replace('Pressione **direita duas vezes** a partir da lista de heróis para chegar ao botão **JOGAR** no rodapé e confirme com **A** (ou B no Legado).', 'A partir da lista de heróis, pressione **direita** para escolher a fase. Confirme a fase com **A no Xbox / × no PlayStation**: o foco vai para **JOGAR** no rodapé. Solte e pressione novamente para iniciar a tentativa (B/○ confirma no Legado).')
(out / 'Como-testar-Xbox.md').write_text(guide, encoding='utf-8')
old = json.loads((out.parent / 'v02/pilot-manifest.json').read_text(encoding='utf-8'))
old['id'] = 'P068-v03'
old['previous_manifest'] = '../v02/pilot-manifest.json'
old['sources'] = {name: hashlib.sha256((root / name).read_bytes()).hexdigest() for name in old['sources']}
old['fingerprint'] = hashlib.sha256(json.dumps(old['sources'], sort_keys=True, separators=(',', ':')).encode()).hexdigest()
(out / 'pilot-manifest.json').write_text(json.dumps(old, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print('P068-v03 reconciliado; 38 verificacoes, perfil piloto v01 preservado.')
