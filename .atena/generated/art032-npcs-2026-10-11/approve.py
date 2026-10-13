import hashlib
import json
from pathlib import Path
import subprocess

ROOT = Path(__file__).resolve().parents[3]
OUT = Path(__file__).resolve().parent
REPLY = 'Aprovo as quatro peças DRAFT'
jobs = json.loads((OUT / 'jobs.json').read_text(encoding='utf-8'))
for record in jobs['sources'] + jobs['style_references']:
    path = Path(record['path'])
    if not path.is_absolute():
        path = ROOT / path
    assert hashlib.sha256(path.read_bytes()).hexdigest() == record['sha256'], record['path']
jobs.update({'approval': 'APPROVED_PER_PLAN', 'owner_reply': REPLY, 'current_step': 'S-002/GENERATION', 'generated': 0})
for job in jobs['jobs']:
    job['status'] = 'APPROVED_PENDING_GENERATION'
(OUT / 'jobs.json').write_text(json.dumps(jobs, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
path = ROOT / '.atena/state/art032-npcs-piloto.yaml'
text = path.read_text(encoding='utf-8').replace('status: PROPOSED_WAITING_SCOPE_APPROVAL', 'status: APPROVED_GENERATION_IN_PROGRESS').replace('approval_status: PENDING_SCOPE_APPROVAL', 'approval_status: APPROVED_EXPLICITLY').replace('checkpoint: S-001/PLAN_APPROVAL', 'checkpoint: S-002/GENERATION').replace('current_step_position: 1', 'current_step_position: 2')
text += 'scope_owner_reply: "' + REPLY + '"\napproved_at: "2026-10-11"\ngenerated: 0\n'
path.write_text(text, encoding='utf-8')
path = ROOT / '.atena/state/plan.yaml'
text = path.read_text(encoding='utf-8')
prefix, tail = text.split('fila026_remaining_2026_10_11:', 1)
prefix = prefix.replace('status: PROPOSED_WAITING_SCOPE_APPROVAL', 'status: APPROVED_GENERATION_IN_PROGRESS').replace('checkpoint: S-001/PLAN_APPROVAL', 'checkpoint: S-002/GENERATION').replace('current_step_position: 1', 'current_step_position: 2')
prefix += '  scope_owner_reply: "' + REPLY + '"\n'
path.write_text(prefix + 'fila026_remaining_2026_10_11:' + tail, encoding='utf-8')
path = ROOT / '.atena/vault/drafts/PLAN-ART032-NPCS-PILOTO-v01.md'
text = path.read_text(encoding='utf-8').replace('status: PROPOSED_WAITING_SCOPE_APPROVAL', 'status: APPROVED_IN_EXECUTION')
text = text.replace('o escopo abaixo aguarda aprovação', 'o escopo abaixo foi aprovado explicitamente em 2026-10-11')
text = text.replace('Concluído localmente; aprovação deste escopo pendente.', 'Concluído; escopo aprovado com “Aprovo as quatro peças DRAFT”.')
text = text.replace('# ART-032 — primeiro lote de NPCs e ponto de acontecimento\n', '# ART-032 — primeiro lote de NPCs e ponto de acontecimento\n\nAprovação de execução: **“Aprovo as quatro peças DRAFT”**, 2026-10-11, per-plan. Não constitui aceite visual das futuras imagens.\n', 1)
path.write_text(text, encoding='utf-8')
protected = subprocess.check_output(['git', 'ls-files', '--', 'ui', 'core', 'data', 'assets', 'tests'], cwd=ROOT).decode().splitlines()
snapshot = {p: hashlib.sha256((ROOT / p).read_bytes()).hexdigest() for p in protected}
snapshot['.atena/state/plan.yaml#active_plan_tail'] = hashlib.sha256(tail.split('active_plan:', 1)[1].encode()).hexdigest()
(OUT / 'protected-snapshot.json').write_text(json.dumps(snapshot, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print('Scope approved per-plan; source/style hashes verified; runtime and PLAN071 protected snapshot saved')
