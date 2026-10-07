from pathlib import Path
import hashlib
import json
import re

root = Path(__file__).resolve().parents[4]
out = Path(__file__).resolve().parent
ws = root / '.atena'
errors = []
links = 0
target = out / 'delivery-validation.json'
target.write_text('{"status":"VALIDATING"}\n', encoding='utf-8')
for part in ['add.yaml', 'vault/canon', 'vault/drafts', 'vault/research', 'specs', 'evidence', 'generated', 'state/plan.yaml']:
    if not (ws / part).exists():
        errors.append('Contrato ausente: ' + part)
for relative in ['specs/SPEC-135-experiencia-controles-xbox-playstation-2026-10-06.md', 'evidence/EVID-186-quartel-confirmar-mapa-para-jogar-2026-10-06.md']:
    path = ws / relative
    for link in re.findall(r'\]\(([^\s)]+)\)', path.read_text(encoding='utf-8-sig')):
        if re.match(r'^(https?://|mailto:|#)', link):
            continue
        links += 1
        if not (path.parent / link.split('#')[0]).resolve().exists():
            errors.append('Link quebrado: ' + link)
central = (ws / 'state/plan.yaml').read_text(encoding='utf-8-sig')
active = central.split('active_plan:', 1)[1].split('plan_cursor:', 1)[0]
state = (ws / 'state/plan-068-controles-xbox-playstation.yaml').read_text(encoding='utf-8')
if '  id: PLAN-068' in active:
    for expected in ['  mode: per-plan', '  checkpoint: B-004/S-011', '  status: AWAITING_HARDWARE_PLAYTEST']:
        if expected not in active:
            errors.append('Checkpoint central inconsistente: ' + expected)
else:
    # Outra tarefa autorizada assumiu o estado central durante esta validacao.
    # Preservar o plano ativo e comprovar o retorno, sem reativa-lo.
    for expected in ['    suspended_plan: PLAN-068', '    checkpoint: B-004/S-011', '    prior_status: AWAITING_HARDWARE_PLAYTEST']:
        if expected not in central:
            errors.append('Retorno do PLAN-068 ausente: ' + expected)
    for expected in ['  status: AWAITING_HARDWARE_PLAYTEST', '    mode: per-plan', '    current: B-004', '    step: S-011']:
        if expected not in state:
            errors.append('Checkpoint proprio inconsistente: ' + expected)
for expected in ['  map_confirmation:', '    behavior: CONFIRM_STAGE_FOCUSES_PLAY_NEXT_PRESS_STARTS_RUN', '    hardware_acceptance: false']:
    if expected not in state:
        errors.append('Estado inconsistente: ' + expected)
for expected in ['    suspended_plan: PLAN-067', '    suspended_plan: PLAN-066', '    status: PENDING_AFTER_PLAN_067']:
    if expected not in central:
        errors.append('Retorno perdido: ' + expected)
manifest = json.loads((out / 'pilot-manifest.json').read_text(encoding='utf-8'))
for name, digest in manifest['sources'].items():
    if hashlib.sha256((root / name).read_bytes()).hexdigest() != digest:
        errors.append('Fonte mudou: ' + name)
fingerprint = hashlib.sha256(json.dumps(manifest['sources'], sort_keys=True, separators=(',', ':')).encode()).hexdigest()
if fingerprint != manifest['fingerprint']:
    errors.append('Fingerprint inconsistente')
report = json.loads((out / 'menu-start-report.json').read_text(encoding='utf-8'))
if len(report['checks']) != 38 or report['failures'] or report['hardware_acceptance']:
    errors.append('Acesso a Jogar invalido')
if 'testes: 0 falha(s)' not in (out / 'suite.log').read_text(encoding='utf-8'):
    errors.append('Suite nao passou')
result = {'plan': 'PLAN-068', 'pilot': 'P068-v03', 'local_passed': not errors, 'errors': errors, 'local_links_checked': links, 'sources_checked': len(manifest['sources']), 'yaml_full_parser_used': False, 'hardware_acceptance': False, 'status': 'AWAITING_HARDWARE_PLAYTEST'}
result['central_active_plan'] = re.search(r'^  id: (PLAN-\d+)', active, re.M).group(1)
target.write_text(json.dumps(result, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print(json.dumps(result, ensure_ascii=False))
raise SystemExit(1 if errors else 0)
