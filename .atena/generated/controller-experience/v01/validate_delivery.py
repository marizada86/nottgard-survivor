from pathlib import Path
import hashlib
import json
import re
import struct

root = Path(__file__).resolve().parents[4]
out = Path(__file__).resolve().parent
ws = root / '.atena'
errors = []
links = 0
for part in ['add.yaml', 'vault/canon', 'vault/drafts', 'vault/research', 'specs', 'evidence', 'generated', 'state/plan.yaml']:
    if not (ws / part).exists():
        errors.append('Contrato ausente: ' + part)
records = ['specs/SPEC-135-experiencia-controles-xbox-playstation-2026-10-06.md', 'vault/drafts/PLAN-068-experiencia-controles-xbox-playstation-2026-10-06.md', 'evidence/EVID-177-planejamento-controles-xbox-playstation-2026-10-06.md', 'evidence/EVID-184-controles-xbox-playstation-local-2026-10-06.md', 'vault/canon/INPUT-CONTROL-001-joystick-2026-09-29.md', 'vault/canon/MENU-OPTIONS-001-accessibilidade-audio-video-2026-09-29.md']
for relative in records:
    path = ws / relative
    body = path.read_text(encoding='utf-8-sig')
    for link in re.findall(r'\]\(([^\s)]+)\)', body):
        if re.match(r'^(https?://|mailto:|#)', link):
            continue
        links += 1
        if not (path.parent / link.split('#')[0]).resolve().exists():
            errors.append('Link quebrado: ' + relative + ' -> ' + link)
central = (ws / 'state/plan.yaml').read_text(encoding='utf-8-sig')
state = (ws / 'state/plan-068-controles-xbox-playstation.yaml').read_text(encoding='utf-8')
active = central.split('active_plan:', 1)[1].split('plan_cursor:', 1)[0]
for expected in ['  id: PLAN-068', '  mode: per-plan', '  checkpoint: B-004/S-011', '  status: AWAITING_HARDWARE_PLAYTEST']:
    if expected not in active:
        errors.append('Checkpoint central inconsistente: ' + expected)
for expected in ['  execution_started: true', '    synthetic_tests_are_hardware_acceptance: false', '  completed_steps: [S-001, S-002, S-003, S-004, S-005, S-006, S-007, S-008, S-009, S-010]']:
    if expected not in state:
        errors.append('Estado inconsistente: ' + expected)
for expected in ['    suspended_plan: PLAN-067', '    suspended_plan: PLAN-066', '    status: PENDING_AFTER_PLAN_067']:
    if expected not in central:
        errors.append('Retorno/fila perdido: ' + expected)
manifest = json.loads((out / 'pilot-manifest.json').read_text(encoding='utf-8'))
for name, digest in manifest['sources'].items():
    if hashlib.sha256((root / name).read_bytes()).hexdigest() != digest:
        errors.append('Fonte mudou depois da validacao: ' + name)
report = json.loads((out / 'integration-report.json').read_text(encoding='utf-8'))
if len(report['checks']) != 90 or report['failures'] or report['hardware_acceptance']:
    errors.append('Resultado de controle invalido')
mobile = json.loads((out / 'mobile-buttons-report.json').read_text(encoding='utf-8'))
if len(mobile['checks']) != 144 or mobile['failures']:
    errors.append('Regressao mobile falhou')
if len(list((root / 'assets/icons/controller').rglob('*.svg'))) != 52:
    errors.append('Catalogo incompleto')
captures = []
for name in ['hud_xbox', 'ficha_ps5', 'oferta_ps5', 'pausa_ps5', 'opcoes_ps5', 'quartel_xbox', 'resultado_xbox']:
    for width, height in [(1280, 720), (1920, 1080)]:
        path = out / f'{name}_{width}x{height}.png'
        if not path.exists() or struct.unpack('>II', path.read_bytes()[16:24]) != (width, height):
            errors.append('Captura ausente/tamanho incorreto: ' + path.name)
        captures.append(path.name)
result = {'plan': 'PLAN-068', 'local_passed': not errors, 'errors': errors, 'local_links_checked': links, 'sources_checked': len(manifest['sources']), 'captures_checked': captures, 'yaml_full_parser_used': False, 'hardware_acceptance': False, 'status': 'AWAITING_HARDWARE_PLAYTEST', 'fingerprint': manifest['fingerprint']}
(out / 'delivery-validation.json').write_text(json.dumps(result, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print(json.dumps(result, ensure_ascii=False))
raise SystemExit(1 if errors else 0)
