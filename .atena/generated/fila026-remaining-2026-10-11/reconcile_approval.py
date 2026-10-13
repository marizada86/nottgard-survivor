from pathlib import Path
import hashlib
import json

base = Path(__file__).parent
receipt = json.loads((base / 'owner-approval.json').read_text(encoding='utf-8'))
assert receipt['owner_reply'] == 'Aprovo as nove revisões v01'
assert receipt['gate'] == 'G2_ACCEPTED_PER_PIECE' and not receipt['runtime_admission']
accepted = {r['code']: r for r in receipt['records']}
assert list(accepted) == ['L03', 'L04', 'L05', 'P01', 'P02', 'P03', 'C01', 'C02', 'C03']
for r in accepted.values():
    assert r['revision'] == 'v01'
    for path, digest in [(r['source'], r['source_sha256']), (r['prepared'], r['prepared_sha256']),
                         (f"native/{r['code']}_v01.png", r['native_sha256'])]:
        assert hashlib.sha256((base / path).read_bytes()).hexdigest() == digest

audit_path = base / 'audit.json'
audit = json.loads(audit_path.read_text(encoding='utf-8'))
audit.update(owner_approval=receipt, gate='G2_ACCEPTED_PER_PIECE', content_state='CANON_VISUAL_G2',
             current_step='S-013/ADMISSION_GATE', step_position=13, completed_steps=12,
             next='Prepare runtime admission under its explicit gate; no integration or Git authorization from G2.')
for r in audit['records']:
    assert r['hashes']['final'] == accepted[r['code']]['prepared_sha256']
    r['content_state'] = 'CANON_VISUAL_G2'
    r['checks']['owner_acceptance'] = 'ACCEPTED_G2_v01'
audit_path.write_text(json.dumps(audit, ensure_ascii=False, indent=2)+'\n', encoding='utf-8')
jobs_path = base / 'jobs.json'
jobs = json.loads(jobs_path.read_text(encoding='utf-8'))
jobs.update(owner_approval='owner-approval.json', owner_g2_status='ACCEPTED_PER_PIECE',
            content_state='CANON_VISUAL_G2', status='VISUALLY_ACCEPTED_WAITING_ADMISSION_GATE',
            current_step='S-013/ADMISSION_GATE')
for job in jobs['jobs']:
    job.update(content_state='CANON_VISUAL_G2', owner_acceptance='ACCEPTED_G2_v01')
jobs_path.write_text(json.dumps(jobs, ensure_ascii=False, indent=2)+'\n', encoding='utf-8')
cursor_path = base / 'cursor-candidates.json'
cursors = json.loads(cursor_path.read_text(encoding='utf-8'))
cursors.update(status='CANON_VISUAL_G2_NOT_RUNTIME_DATA', owner_approval='owner-approval.json')
cursor_path.write_text(json.dumps(cursors, ensure_ascii=False, indent=2)+'\n', encoding='utf-8')
page_path = base / 'index.html'
page = page_path.read_text(encoding='utf-8')
page = page.replace('nove peças DRAFT v01', 'nove peças v01 aceitas no G2')
page = page.replace('v01 · DRAFT', 'v01 · CANON visual G2')
page = page.replace('Aceite visual G2 pendente.', 'Aceite visual G2 registrado: “Aprovo as nove revisões v01”.')
page = page.replace('Agora: PLAN-065, etapa 12/16, G2 por peça.', 'PLAN-065: G2 concluído; próxima etapa 13/16, admissão sob gate próprio.')
page = page.replace('aceite visual pendente.', 'aceite visual por peça registrado. Nenhuma admissão runtime.')
page = page.replace('<a href="audit.json">Auditoria</a>', '<a href="owner-approval.json">Aceite G2 e hashes</a> · <a href="audit.json">Auditoria</a>') if 'href="owner-approval.json"' not in page else page
page_path.write_text(page, encoding='utf-8')
print(json.dumps(dict(gate='G2_ACCEPTED_PER_PIECE', pieces=9, content_state='CANON_VISUAL_G2', runtime_admission=False)))
if (base/'admission-godot-check.json').exists():
    import runpy
    runpy.run_path(str(base/'reconcile_admission.py'))
