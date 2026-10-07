from pathlib import Path
import hashlib
import json
import re
import shutil
import subprocess

root = Path(__file__).resolve().parents[4]
out = Path(__file__).resolve().parent
workspace = root / '.atena'
evidence = '.atena/evidence/EVID-184-controles-xbox-playstation-local-2026-10-06.md'
report = json.loads((out / 'integration-report.json').read_text(encoding='utf-8'))
assert len(report['checks']) == 90 and not report['failures'], report['failures']
assert 'testes: 0 falha(s)' in (out / 'suite.log').read_text(encoding='utf-8')
assert 'mobile buttons: 144 verificacoes; 0 falha(s)' in (out / 'mobile-buttons.log').read_text(encoding='utf-8')
for name in ['desktop-smoke', 'mobile-smoke']:
    assert 'smoke: ok' in (out / (name + '.log')).read_text(encoding='utf-8')

mobile_report = root / '.atena/generated/mobile-controls/v02/buttons-report.json'
shutil.copy2(mobile_report, out / 'mobile-buttons-report.json')
# Somente o relatório que nossos verificadores regravaram. A baseline estava limpa nesse arquivo.
previous = subprocess.run(['rtk', 'proxy', 'git', 'show', 'HEAD:.atena/generated/mobile-controls/v02/buttons-report.json'], cwd=root, capture_output=True, check=True).stdout
json.loads(previous)
mobile_report.write_bytes(previous)

for name in ['INPUT-CONTROL-001-joystick-2026-09-29.md', 'MENU-OPTIONS-001-accessibilidade-audio-video-2026-09-29.md']:
    source = workspace / 'vault/canon' / name
    target = out / 'recovery/.atena/vault/canon' / name
    target.parent.mkdir(parents=True, exist_ok=True)
    if not target.exists():
        shutil.copy2(source, target)

for relative in ['specs/SPEC-135-experiencia-controles-xbox-playstation-2026-10-06.md', 'vault/drafts/PLAN-068-experiencia-controles-xbox-playstation-2026-10-06.md']:
    path = workspace / relative
    text = path.read_text(encoding='utf-8-sig').replace('status: APPROVED_DEFERRED_AFTER_MOBILE', 'status: LOCAL_VALIDATED_HARDWARE_PENDING')
    if '## Ativação e entrega local — 2026-10-06' not in text:
        link = '../evidence/' if relative.startswith('specs/') else '../../evidence/'
        text += '\n## Ativação e entrega local — 2026-10-06\n\nO dono pediu “vamos lá” após a entrega local mobile em 503ccec, autorizando iniciar o plano já aprovado por plano. As declarações acima sobre planejamento e fila descrevem a preparação anterior. O checkpoint nativo mobile foi suspenso com retorno persistido; Durvall e DEV-003 preservados. Entrega local P068-v01 validada; aceite físico Xbox/DS4/DualSense pendente. [EVID-184](' + link + 'EVID-184-controles-xbox-playstation-local-2026-10-06.md).\n'
    path.write_text(text, encoding='utf-8')

path = workspace / 'state/plan-068-controles-xbox-playstation.yaml'
text = path.read_text(encoding='utf-8')
text = text.replace('  status: IN_PROGRESS', '  status: AWAITING_HARDWARE_PLAYTEST', 1)
text = text.replace('  evidence: .atena/evidence/EVID-177-planejamento-controles-xbox-playstation-2026-10-06.md', '  evidence: ' + evidence)
text = text.replace('    current: B-001\n    step: S-001\n    status: IN_PROGRESS', '    current: B-004\n    step: S-011\n    status: AWAITING_HARDWARE_PLAYTEST')
for batch in ['B-001', 'B-002', 'B-003']:
    text = re.sub(r'(^    ' + batch + r': \{.*?status: )[^}]+', r'\g<1>LOCAL_VALIDATED', text, flags=re.M)
text = re.sub(r'(^    B-004: \{.*?status: )[^}]+', r'\g<1>AWAITING_HARDWARE_PLAYTEST', text, flags=re.M)
text = text.replace('    status: PENDING_DEVICE_MATRIX', '    status: AWAITING_OWNER_XBOX_PLAYTEST')
text = text.replace('    Xbox: NOT_TESTED', "    Xbox: ENUMERATED_NOT_PHYSICALLY_TESTED\n    owner_available: Xbox\n    owner_model: UNKNOWN\n    owner_transport: UNKNOWN\n    detected_name: 'XInput Controller'\n    detected_guid: '0300fa675e0400008e02000010017801'")
text = text.replace('  completed_steps: []', '  completed_steps: [S-001, S-002, S-003, S-004, S-005, S-006, S-007, S-008, S-009, S-010]\n  reconciliation: LOCAL_RECONCILED_S_012_PHYSICAL_PENDING\n  local_pilot: .atena/generated/controller-experience/v01/Abrir-teste-Xbox.cmd\n  local_validation: {controller_checks: 90, mobile_checks: 144, suite_failures: 0, smoke_stages: 9, hardware_acceptance: false}')
text = re.sub(r'^  next: .*$', "  next: 'Dono testar P068-v01 com Xbox; informar modelo/transporte e resultados. S-011 e conclusao de S-012 pendentes; retorno mobile preservado.'", text, flags=re.M)
path.write_text(text, encoding='utf-8')

path = workspace / 'state/plan.yaml'
text = path.read_text(encoding='utf-8-sig')
active = text.split('active_plan:', 1)[1].split('plan_cursor:', 1)[0]
assert '  id: PLAN-068' in active, 'Plano ativo mudou; nao reconciliar estado de outro chat.'
updated = active.replace('checkpoint: B-001/S-001', 'checkpoint: B-004/S-011').replace('status: IN_PROGRESS', 'status: AWAITING_HARDWARE_PLAYTEST')
text = text.replace(active, updated, 1)
start = text.index('plan_cursor:')
end = text.index('previous_plan_cursor:')
text = text[:start] + "plan_cursor:\n  current: 'PLAN-068 / SPEC-135: P068-v01 implementado e validado localmente; 90 verificacoes controle, 144 mobile, suite zero falhas e smoke nove fases. Aceite fisico Xbox pendente.'\n  next: 'Playtest Xbox do dono; DS4/DualSense pendentes. Retorno ao checkpoint nativo mobile e Durvall preservado; DEV-003 pendente.'\n" + text[end:]
dev_start = text.index('  - id: DEV-004')
dev_end = text.index('  - id: DEV-003')
part = text[dev_start:dev_end].replace('status: EXECUTING_WITH_RETURN', 'status: LOCAL_DELIVERED_AWAITING_HARDWARE')
text = text[:dev_start] + part + text[dev_end:]
path.write_text(text, encoding='utf-8')

for filename, id in [('MECANICAS.md', 'MEC-050'), ('ARTE.md', 'ART-037')]:
    path = workspace / 'backlog' / filename
    text = path.read_text(encoding='utf-8-sig')
    lines = text.splitlines(keepends=True)
    for index, line in enumerate(lines):
        if line.startswith('| ' + id + ' |'):
            if id == 'MEC-050':
                line = line.replace('APROVADO POR PLANO 2026-10-06; execução após mobile, não iniciada', 'IMPLEMENTADO LOCAL 2026-10-06; P068-v01, 90 verificações controle e 144 mobile sem falhas; aceite físico Xbox/DS4/DualSense pendente')
            else:
                line = line.replace('aprovado por plano 2026-10-06, execução após mobile', 'IMPLEMENTADO LOCAL 2026-10-06; 52 SVGs locais; capturas 720p/1080p; aceite físico pendente')
            lines[index] = line.rstrip('\r\n') + ' [EVID-184](../evidence/EVID-184-controles-xbox-playstation-local-2026-10-06.md).\n'
    path.write_text(''.join(lines), encoding='utf-8')
path = workspace / 'backlog/README.md'
path.write_text(path.read_text(encoding='utf-8-sig').replace('`EVID-184`', '`EVID-185`'), encoding='utf-8')

sources = [root / name for name in ['core/game.gd', 'core/controller_input.gd', 'core/playtest.gd', 'ui/ability_slot.gd', 'ui/character_sheet.gd', 'ui/controller_options.gd', 'ui/hero_panel.gd', 'ui/hq_screen.gd', 'ui/hud.gd', 'ui/menu.gd', 'ui/run.gd', 'ui/title.gd', 'tests/test_input_controls.gd', 'tests/test_controller_experience.gd', 'tools/controller_check.gd', 'tools/controller_check.tscn', 'tools/controller_preview.gd', 'tools/controller_preview.tscn']]
sources += sorted((root / 'assets/icons/controller').rglob('*.svg'))
hashes = {path.relative_to(root).as_posix(): hashlib.sha256(path.read_bytes()).hexdigest() for path in sources}
fingerprint = hashlib.sha256(json.dumps(hashes, sort_keys=True).encode()).hexdigest()
(out / 'pilot-manifest.json').write_text(json.dumps({'id': 'P068-v01', 'date': '2026-10-06', 'baseline_commit': '503ccec4003efff9260821214e75bf49c1b6ab0b', 'uncommitted_local_delta': True, 'fingerprint_scope': 'controller_sources_and_glyphs', 'fingerprint': fingerprint, 'sources': hashes, 'checks': {'controller': 90, 'mobile': 144, 'suite_failures': 0, 'smoke_desktop_stages': 9, 'smoke_mobile_stages': 9}, 'hardware_acceptance': False, 'detected_devices': report['devices_detected'], 'profile': 'res://.atena/generated/controller-experience/v01/pilot-profile.json'}, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print('Registros locais reconciliados; aceite fisico pendente. Fingerprint:', fingerprint[:12])
