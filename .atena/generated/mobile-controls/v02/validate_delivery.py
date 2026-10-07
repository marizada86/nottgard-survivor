from pathlib import Path
import hashlib
import json
import re
import struct

root = Path(__file__).resolve().parents[4]
out = Path(__file__).resolve().parent
sha = lambda path: hashlib.sha256(path.read_bytes()).hexdigest()
report = json.loads((out / 'buttons-report.json').read_text(encoding='utf-8'))
assert len(report['checks']) == 144 and not report['failures']
assert all(case['passed'] for case in report['checks'])
assert 'testes: 0 falha(s)' in (out / 'tests.log').read_text(encoding='utf-8')
smoke = (out / 'smoke-mobile.log').read_text(encoding='utf-8')
assert smoke.count('estado=running') == 9 and 'smoke: ok' in smoke
assert not (out / 'capture-stderr.log').read_text(encoding='utf-8').strip()

previous = json.loads((out.parent / 'v01/manifest.json').read_text(encoding='utf-8'))
recovery = {}
paths = {'mobile_controls.gd': 'ui/mobile_controls.gd', 'touch_ui.gd': 'ui/touch_ui.gd', 'run.gd': 'ui/run.gd', 'mobile_preview.gd': 'tools/mobile_preview.gd', 'test_mobile_controls.gd': 'tests/test_mobile_controls.gd'}
for filename, source in paths.items():
    digest = sha(out / 'recovery' / filename)
    recovery[filename] = {'sha256': digest, 'matches_v01': digest == previous['sources'][source]}
assert all(value['matches_v01'] for value in recovery.values()), recovery
recovery['playtest.gd'] = {'sha256': sha(out / 'recovery/playtest.gd'), 'origin': 'working-file-before-edit; previously-clean'}

sources = ['core/game.gd', 'core/playtest.gd', 'project.godot', 'ui/ability_slot.gd', 'ui/character_sheet.gd', 'ui/hero_panel.gd', 'ui/hq_screen.gd', 'ui/hud.gd', 'ui/menu.gd', 'ui/run.gd', 'ui/mobile_controls.gd', 'ui/touch_ui.gd', 'tests/test_mobile_controls.gd', 'tools/mobile_preview.gd', 'tools/mobile_preview.tscn', 'tools/mobile_buttons_check.gd', 'tools/mobile_buttons_check.tscn']
manifest = {'pilot_id': 'P067-v02', 'date': '2026-10-06', 'kind': 'local-source-pilot-not-apk', 'engine': 'Godot 4.7.2', 'native_validated': False, 'checks': 144, 'failures': 0, 'sources': {path: sha(root / path) for path in sources}, 'recovery': recovery, 'screenshots': {}, 'logs': {}}
for path in out.glob('*.png'):
    w, h = struct.unpack('>II', path.read_bytes()[16:24])
    manifest['screenshots'][path.name] = {'width': w, 'height': h, 'sha256': sha(path)}
for filename in ['tests.log', 'smoke-mobile.log', 'capture.log', 'capture-stdout.log', 'capture-stderr.log', 'buttons-report.json', 'before-fix-tests.log']:
    manifest['logs'][filename] = sha(out / filename)
(out / 'manifest.json').write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')

plan = root / '.atena/vault/drafts/PLAN-067-controles-e-menus-mobile-2026-10-06.md'
text = plan.read_text(encoding='utf-8-sig').replace('joystick flutuante à esquerda somente para andar', 'joystick flutuante na área livre de qualquer lado somente para andar')
note = '\n\nAtualização IN_PLAN após o piloto: joystick também à direita e teste dos botões solicitados pelo dono. Piloto P067-v02; 144 verificações sem falhas, suíte zero e smoke nove fases. [EVID-183](../../evidence/EVID-183-mobile-joystick-direita-e-botoes-2026-10-06.md). Gates e aceite em aparelho continuam pendentes.\n'
if 'Atualização IN_PLAN após o piloto' not in text:
    text += note
plan.write_text(text, encoding='utf-8')
for filename, entry in [('MECANICAS.md', 'MEC-049'), ('ARTE.md', 'ART-036')]:
    path = root / '.atena/backlog' / filename
    lines = path.read_text(encoding='utf-8-sig').splitlines()
    for i, line in enumerate(lines):
        if line.startswith('| ' + entry + ' |') and 'EVID-183' not in line:
            if entry == 'ART-036':
                line = line.replace('joystick à esquerda', 'joystick na arena livre dos dois lados')
            lines[i] = line[:-1] + ' P067-v02: joystick dos dois lados; 144 verificações sem falhas, [EVID-183](../evidence/EVID-183-mobile-joystick-direita-e-botoes-2026-10-06.md). |'
    path.write_text('\n'.join(lines) + '\n', encoding='utf-8')
readme = root / '.atena/backlog/README.md'
text = readme.read_text(encoding='utf-8-sig').replace('SPEC-135 / PLAN-068 / EVID-182', 'SPEC-135 / PLAN-068 / EVID-183').replace('`EVID-183`', '`EVID-184`')
readme.write_text(text, encoding='utf-8')

required = ['.atena/add.yaml', '.atena/vault/canon', '.atena/vault/drafts', '.atena/vault/research', '.atena/specs', '.atena/evidence', '.atena/generated', '.atena/state/plan.yaml']
missing = [path for path in required if not (root / path).exists()]
records = [root / '.atena/evidence/EVID-183-mobile-joystick-direita-e-botoes-2026-10-06.md', root / '.atena/specs/SPEC-134-controles-e-menus-mobile-2026-10-06.md', plan]
broken = []
for path in records:
    for link in re.findall(r'\]\(([^)]+)\)', path.read_text(encoding='utf-8-sig')):
        if '://' in link or link.startswith('#'):
            continue
        if not (path.parent / link.split('#')[0]).exists() and not link.endswith('/reconciliation.json'):
            broken.append({'file': path.name, 'link': link})
yaml_errors = []
for name in ['plan.yaml', 'plan-067-controles-e-menus-mobile.yaml']:
    path = root / '.atena/state' / name
    text = path.read_text(encoding='utf-8-sig')
    if '\t' in text or 'per-plan' not in text or 'AWAITING_DEVICE_VALIDATION' not in text:
        yaml_errors.append(name)
result = {'contract_missing': missing, 'broken_local_links': broken, 'yaml_structural_errors': yaml_errors, 'yaml_validation': 'structural-only-no-parser-installed', 'checks': 144, 'failures': 0, 'suite_failures': 0, 'smoke_stages': 9, 'recovery_hashes_match_v01': True, 'native_device_validated': False}
(out / 'reconciliation.json').write_text(json.dumps(result, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
assert not missing and not broken and not yaml_errors
print(json.dumps(result, ensure_ascii=False))
