from pathlib import Path
import json
import re
import runpy

root = Path(__file__).resolve().parents[2]
workspace = root / '.atena'
current_state = workspace / 'state/plan-068-controles-xbox-playstation.yaml'
if current_state.exists() and '  execution_started: true' in current_state.read_text(encoding='utf-8'):
    # A prova de planejamento continua historica; validar a entrega sem reescreve-la.
    version = 'v02' if '    bug: BUG-030' in current_state.read_text(encoding='utf-8') else 'v01'
    if '  map_confirmation:' in current_state.read_text(encoding='utf-8'):
        version = 'v03'
    runpy.run_path(str(workspace / f'generated/controller-experience/{version}/validate_delivery.py'), run_name='__main__')
    raise SystemExit(0)
records = [
    workspace / 'specs/SPEC-135-experiencia-controles-xbox-playstation-2026-10-06.md',
    workspace / 'vault/drafts/PLAN-068-experiencia-controles-xbox-playstation-2026-10-06.md',
    workspace / 'state/plan-068-controles-xbox-playstation.yaml',
    workspace / 'evidence/EVID-177-planejamento-controles-xbox-playstation-2026-10-06.md',
]
errors = []
checked_links = 0
for relative in ['add.yaml', 'vault/canon', 'vault/drafts', 'vault/research', 'specs', 'evidence', 'generated', 'state/plan.yaml']:
    if not (workspace / relative).exists():
        errors.append('Contrato ausente: ' + relative)
for record in records:
    text = record.read_text(encoding='utf-8-sig')
    if record.suffix == '.md':
        header_text = text.split('---', 2)[1]
        header = dict(re.findall(r'^([\w_]+):\s*(.+)$', header_text, re.M))
        header = {key: value.strip().strip('"') for key, value in header.items()}
        if header['origin'] != 'guided-add' or header['implementation_preceded_spec'] != 'false':
            errors.append('Origem incorreta: ' + record.name)
        links = re.findall(r'\]\(([^\s)]+)\)', text)
        links += [header[key] for key in ['plan', 'state', 'spec', 'evidence'] if key in header]
        for link in links:
            if re.match(r'^(https?://|mailto:|#)', link):
                continue
            checked_links += 1
            if not (record.parent / link.split('#')[0]).resolve().exists():
                errors.append('Link local quebrado: ' + link)

state = records[2].read_text(encoding='utf-8')
central = (workspace / 'state/plan.yaml').read_text(encoding='utf-8-sig')
if '    mode: per-plan\n' not in state or '  execution_started: false\n' not in state:
    errors.append('Plano tornou-se executavel indevidamente')
if '    status: WAITING_MOBILE_AND_QUEUE_ORDER\n' not in state:
    errors.append('Checkpoint indevido')
active = central.split('active_plan:', 1)[1].split('plan_cursor:', 1)[0]
if '  id: PLAN-067' not in active:
    errors.append('Plano mobile alterado')
if '    suspended_plan: PLAN-066' not in central:
    errors.append('Retorno a Durvall alterado')
deviations = dict(re.findall(r'  - id: (DEV-\d+)\n(.*?)(?=\n  - id:|\ncompleted_plans:|\Z)', central, re.S))
if '    status: PENDING_AFTER_PLAN_067' not in deviations['DEV-003']:
    errors.append('Solicitacao anterior alterada')
if '    status: PENDING_AFTER_PLAN_067' not in deviations['DEV-004']:
    errors.append('Fila nova incorreta')
if '    approval_mode: per-plan' not in deviations['DEV-004'] or '    approval_status: APPROVED_PER_PLAN' not in deviations['DEV-004']:
    errors.append('Aprovacao central inconsistente')
if '    details_tab_previous: LB_L1' not in state or '    details_tab_next: RB_R1' not in state:
    errors.append('Mapa aprovado de abas ausente')
if not (workspace / 'evidence/PLAN-068-referencia-abas-detalhes-2026-10-06.png').exists():
    errors.append('Referencia visual ausente')
batches = re.findall(r'^    (B-\d+): \{title: .+?, steps: \[(.*?)\], status: NOT_STARTED\}$', state, re.M)
steps = [step.strip() for _, group in batches for step in group.split(',')]
if [batch for batch, _ in batches] != [f'B-{index:03}' for index in range(1, 5)]:
    errors.append('Lotes inconsistentes')
if steps != [f'S-{index:03}' for index in range(1, 13)] or len(set(steps)) != 12:
    errors.append('Etapas inconsistentes')
for directory, prefix in [('specs', 'SPEC-135-'), ('vault/drafts', 'PLAN-068-'), ('evidence', 'EVID-177-'), ('state', 'plan-068-')]:
    if len(list((workspace / directory).glob(prefix + '*'))) != 1:
        errors.append('Colisao de ID: ' + prefix)
for source in re.findall(r'^  (?:source|spec|evidence): (.+)$', state, re.M) + re.findall(r"^  state_file: '(.+)'$", active, re.M):
    if not (root / source).exists():
        errors.append('Referencia de estado quebrada: ' + source)
for relative in ['tests/run_all.gd', 'tests/test_input_controls.gd', 'tools/smoke.tscn', 'tools/backlog_check.ps1']:
    if not (root / relative).exists():
        errors.append('Ferramenta planejada ausente: ' + relative)
report = {
    'date': '2026-10-06', 'kind': 'planning_document_validation',
    'plan': 'PLAN-068', 'spec': 'SPEC-135', 'passed': not errors,
    'errors': errors, 'local_links_checked': checked_links,
    'batches': 4, 'steps': 12, 'active_plan_preserved': 'PLAN-067',
    'active_plan_checkpoint_observed': re.search(r'^  checkpoint: (.+)$', active, re.M).group(1),
    'approval_mode': 'per-plan', 'execution_started': False,
    'yaml_full_parser_used': False,
    'runtime_tests_executed': False, 'hardware_playtest_executed': False,
}
(workspace / 'evidence/PLAN-068-validacao-documental-2026-10-06.json').write_text(
    json.dumps(report, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print(json.dumps(report, ensure_ascii=False))
raise SystemExit(1 if errors else 0)
