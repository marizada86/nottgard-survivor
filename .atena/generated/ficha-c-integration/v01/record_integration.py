import hashlib
import json
from pathlib import Path
from PIL import Image
import re

ROOT = Path(__file__).resolve().parents[4]
OUT = Path(__file__).resolve().parent
EVIDENCE = '.atena/evidence/fila-025-integracao-2026-10-06.json'
ADMISSION = '.atena/vault/canon/ASSET-ADMISSION-fila-025-ficha-c-2026-10-06.json'

def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()

def write(path, data):
    path.write_text(json.dumps(data, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')

approval = json.loads((ROOT / '.atena/vault/canon/ASSET-APPROVAL-REGISTER-021-ficha-c-2026-10-06.json').read_text(encoding='utf-8-sig'))
transforms = json.loads((OUT / 'assets/normalization.json').read_text())
assets = []
for original in approval['assets']:
    source = ROOT / original['path']
    assert sha(source) == original['sha256'], f"Origem mudou: {source}"
    target = ROOT / 'assets/ui/ficha' / (original['name'] + '.png')
    normalized = OUT / 'assets' / target.name
    assert sha(target) == sha(normalized)
    transform = next(t for t in transforms if t['source'] == 'res://' + original['path'])
    with Image.open(target) as image:
        assert list(image.size) == transform['size']
        assert image.mode == ('RGB' if original['id'] == 'A10' else 'RGBA')
        alpha_range = list(image.getchannel('A').getextrema()) if image.mode == 'RGBA' else [255, 255]
        if original['id'] != 'A10':
            assert alpha_range[0] == 0
        texture_contrast = None
        if original['id'] == 'A10':
            luminances = [0.2126*r + 0.7152*g + 0.0722*b for r, g, b in image.getdata()]
            texture_contrast = (max(luminances) - min(luminances)) / 255 * 100
            assert texture_contrast <= 8
    assets.append(dict(id=original['id'], source=original['path'], source_sha256=sha(source),
        output=str(target.relative_to(ROOT)).replace('\\', '/'), output_sha256=sha(target),
        size=transform['size'], mode='RGB' if original['id'] == 'A10' else 'RGBA', alpha_range=alpha_range,
        crop=transform['crop'], interpolation=transform['interpolation'], texture_contrast_percent=texture_contrast))

layouts = {}
captures = []
for mode in ('desktop', 'mobile'):
    report = json.loads((OUT / (mode + '-layout.json')).read_text())
    assert not report['failures']
    assert len(report['layouts']) == (21 if mode == 'desktop' else 19)
    layouts[mode] = report
    for record in report['layouts']:
        png = OUT / (mode + '_' + record['label'] + '.png')
        with Image.open(png) as image:
            assert image.size == (1280, 720)
        captures.append(dict(path=str(png.relative_to(ROOT)).replace('\\', '/'), sha256=sha(png)))
    log = (OUT / ('capture-mobile.log' if mode == 'mobile' else 'capture.log')).read_text(encoding='utf-8-sig')
    assert '0 falhas de geometria' in log
    assert 'SCRIPT ERROR' not in log

tests = (OUT / 'tests.log').read_text(encoding='utf-8-sig')
assert 'testes: 0 falha(s)' in tests
assert 'SCRIPT ERROR' not in tests and 'FALHA ' not in tests
for relative in ('add.yaml', 'vault/canon', 'vault/drafts', 'vault/research', 'specs', 'evidence', 'generated', 'state/plan.yaml'):
    assert (ROOT / '.atena' / relative).exists(), relative
for relative, identifier in (('.atena/specs/SPEC-139-integracao-ficha-c.yaml', 'id: SPEC-139'), ('.atena/state/plan-072-integracao-ficha-c.yaml', 'id: PLAN-072')):
    assert identifier in (ROOT / relative).read_text(encoding='utf-8-sig')

record = dict(plan='PLAN-072', spec='SPEC-139', date_brt='2026-10-06', status='INTEGRATED_LOCALLY_VALIDATED',
    authorization_verbatim='vamos lá', authorization_context='Continuidade apos aprovacao visual das dez candidatas; normalizacao e integracao pendentes.',
    source_approval='.atena/vault/canon/ASSET-APPROVAL-REGISTER-021-ficha-c-2026-10-06.json',
    transformations='Godot Image.get_region/resize nearest; recorte do excesso transparente A01/A02/A05; demais somente escala; sem desenho ou retoque.',
    assets=assets, layouts=layouts, captures=captures,
    validation=dict(png_count=10, source_hashes_preserved=True, target_dimensions_pass=True,
        runtime_geometry_failures=0, desktop_captures=21, mobile_captures=19, all_heroes=10,
        existing_suite_failures=0, existing_suite_exit_code=0, contract_valid=True,
        source_code_sha256={path: sha(ROOT / path) for path in ('ui/character_sheet.gd', 'ui/sheet_slot.gd', 'ui/sheet_art.gd')},
        notes=['Suite avisa objetos/recursos ainda em uso no encerramento; nenhuma falha funcional ou erro de script.',
            'PANEL_SIZE 1088x612 e margem 40; altura se expande conforme conteudo. Todos os casos capturados cabem no viewport.',
            'Inspecao visual das quatro abas cheias, slots vazios, tooltip, layout mobile e glifos.'],
        limits=['Simulacao de toque e familias de controle; teste fisico continua no plano correspondente.',
            'Tiling inspecionado visualmente; nao declarado perfeito pixel a pixel.']),
    official_admission=True, publication=False, commit=False, return_plan='PLAN-071',
    reconciliation=['ART-035', 'CHATGPT-FILA-025', 'PLAN-072', 'SPEC-139'])
write(ROOT / EVIDENCE, record)
write(ROOT / ADMISSION, dict(id='ASSET-ADMISSION-FILA-025', status=record['status'],
    authorization_verbatim='vamos lá', source_approval=record['source_approval'], evidence=EVIDENCE,
    assets=assets, official_admission=True, human_visual_approval='Candidatas aprovadas anteriormente; interface integrada apresentada apos validacao local.'))

backlog = ROOT / '.atena/backlog/ARTE.md'
content = backlog.read_text(encoding='utf-8-sig')
rows = content.splitlines()
index = next(i for i, row in enumerate(rows) if row.startswith('| ART-035 |'))
row = rows[index]
prefix = row.split('| **10 candidatas')[0]
assert prefix != row
rows[index] = prefix + '| **10 imagens normalizadas e integradas localmente 2026-10-06 (PLAN-072)**; quatro abas e dez herois validados em 1280x720, desktop/toque simulado; suite zero falhas. [Evidencia](../evidence/fila-025-integracao-2026-10-06.json). Prompts [[ART-PROMPTS-057-ficha-c-molduras-e-icones]] · base: [[SPEC-130-ficha-c-em-abas-grade-e-detalhe]] |'
backlog.write_text('\n'.join(rows) + '\n', encoding='utf-8')

queue = ROOT / '.atena/generated/CHATGPT-FILA-025-ficha-c-molduras-e-icones.md'
content = queue.read_text(encoding='utf-8-sig')
content = content.replace('dez candidatas geradas e aprovadas visualmente pelo dono em 2026-10-06, PLAN-070; admissao no jogo pendente',
    'concluida: dez imagens aprovadas, normalizadas e integradas localmente; PLAN-070 geracao, PLAN-072 integracao')
content = content.replace('incluindo topo 57,39 px versus limite de 56 px; v01–v03 preservadas; admissão oficial pendente',
    'incluindo variacao do topo originalmente divulgada; v01–v03 preservadas; normalizada e admitida no PLAN-072')
content = content.replace('Dimensões finais, recortes em nove partes e aceite no jogo continuam pendentes; não declarar admissão oficial.',
    'Normalizacao e admissao local concluidas no PLAN-072, apos capturas reais e suite zero falhas. Evidencia: `.atena/evidence/fila-025-integracao-2026-10-06.json`. Aceite fisico permanece nos planos de controles/mobile.')
content = content.replace('O aceite visual não declara teste no jogo ou admissão oficial.',
    'Este aceite registra a etapa visual. A integracao foi autorizada em seguida com “vamos lá” e validada no PLAN-072; registro separado de admissao em `.atena/vault/canon/ASSET-ADMISSION-fila-025-ficha-c-2026-10-06.json`.')
content = content.replace('**Alta, 2ª da fila de imagens.** Ordem das filas abertas:',
    '**Concluida localmente em 2026-10-06.** A prioridade abaixo registra a ordem antes da conclusao; FILA-025 sai das filas abertas:')
queue.write_text(content, encoding='utf-8')

plan = ROOT / '.atena/state/plan-072-integracao-ficha-c.yaml'
content = plan.read_text(encoding='utf-8').replace('status: IN_PROGRESS', 'status: COMPLETED_LOCAL').replace('checkpoint: S-001', 'checkpoint: S-003')
content = content.replace('status: PENDING', 'status: COMPLETED').replace('task: normalizar em staging, status: COMPLETED_LOCAL', 'task: normalizar em staging, status: COMPLETED')
plan.write_text(content + '\nevidence: ' + EVIDENCE + '\nadmission: ' + ADMISSION + '\n', encoding='utf-8')
spec = ROOT / '.atena/specs/SPEC-139-integracao-ficha-c.yaml'
spec.write_text(spec.read_text(encoding='utf-8').replace('status: IN_PROGRESS', 'status: COMPLETED_LOCAL'), encoding='utf-8')

# Somente acrescentar um recibo lateral; nao restaurar snapshots do cursor compartilhado.
state = ROOT / '.atena/state/plan.yaml'
current = state.read_text(encoding='utf-8-sig')
assert 'completed_side_plans:' in current and 'id: PLAN-072' not in current
active_before = re.search(r'(?m)^active_plan:\n  id: (.+)$', current).group(1)
block = re.search(r'(?m)^completed_side_plans:\n(?:[ \t].*\n|\n)*', current)
assert block
receipt = "  - {id: PLAN-072, spec_id: SPEC-139, status: COMPLETED_LOCAL, evidence: '" + EVIDENCE + "', note: 'FILA-025 integrada com autorizacao vamos la; cursor de PLAN-071 preservado.'}\n"
current = current[:block.end()] + receipt + current[block.end():]
state.write_text(current, encoding='utf-8')
assert re.search(r'(?m)^active_plan:\n  id: (.+)$', state.read_text(encoding='utf-8')).group(1) == active_before
for relative in (EVIDENCE, ADMISSION, '.atena/state/plan-072-integracao-ficha-c.yaml', '.atena/specs/SPEC-139-integracao-ficha-c.yaml'):
    assert (ROOT / relative).is_file()
print('Integracao registrada: 10 assets, 40 capturas, contrato e hashes validos; PLAN-071 preservado.')
