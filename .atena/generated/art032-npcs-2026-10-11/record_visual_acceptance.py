"""Record the owner's exact visual acceptance; preserve DRAFT/native/runtime state."""
import hashlib
import json
from pathlib import Path
import re

OUT = Path(__file__).resolve().parent
ROOT = OUT.parents[2]
REPLY = 'Aprovo visualmente as quatro revisões'
STATUS = 'COMPLETED_VISUALLY_ACCEPTED_DRAFT'
CHECKPOINT = 'S-005/OWNER_VISUAL_ACCEPTANCE_RECORDED'
NEXT = 'Preparar um plano futuro de normalização/admissão ou das demais peças ART-032; execução ainda não autorizada'

def load(name):
    return json.loads((OUT / name).read_text(encoding='utf-8'))

def save(name, value):
    (OUT / name).write_text(json.dumps(value, ensure_ascii=False, indent=2)+'\n', encoding='utf-8')

def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()

jobs = load('jobs.json')
expected = [('NP01', 'v02'), ('NP02', 'v01'), ('NP03', 'v01'), ('PT01', 'v01')]
assert [(j['code'], j['revision']) for j in jobs['jobs']] == expected
rootpath = ROOT / '.atena/state/plan.yaml'
rootbefore = rootpath.read_text(encoding='utf-8')
protected_tail = rootbefore.split('fila026_remaining_2026_10_11:', 1)[1]
snapshot = load('protected-snapshot.json')
for path, expected_hash in snapshot.items():
    actual = hashlib.sha256(rootbefore.split('active_plan:', 1)[1].encode()).hexdigest() if '#active_plan_tail' in path else sha(ROOT / path)
    assert actual == expected_hash, path
for job in jobs['jobs'] + jobs.get('previous_native_versions', []):
    assert sha(ROOT / job['destination']) == job['sha256'] == sha(Path(job['original_path']))

receipt = {
    'plan': jobs['plan'], 'revision': 'v01', 'step': 'S-005', 'date': '2026-10-11',
    'owner_reply': REPLY, 'authority': 'EXPLICIT_HUMAN_REPLY_TO_EXACT_FOUR_REVISION_VISUAL_GATE',
    'status': 'APPROVED_EXPLICITLY', 'content_state': 'DRAFT',
    'accepted': [{'code': j['code'], 'revision': j['revision'], 'path': j['destination'], 'sha256': j['sha256']} for j in jobs['jobs']],
    'reviewed_scope': 'Style/proposed appearance/actors at 80px/star at 48 and 80px; native alpha 1/255 note disclosed in the approved question.',
    'canonical_promotion': False, 'runtime_admission': False, 'normalization_execution': False,
    'commit_push_build': False, 'historical_NP01_v01_accepted': False,
    'next_execution_authorized': False
}
save('visual-acceptance.json', receipt)
jobs.update({'status': STATUS, 'current_step': CHECKPOINT, 'completed_steps': 5, 'owner_visual_acceptance': 'APPROVED_EXPLICITLY', 'visual_acceptance_receipt': 'visual-acceptance.json', 'visual_owner_reply': REPLY})
for job in jobs['jobs']:
    job['status'] = 'VISUALLY_ACCEPTED_DRAFT_NOT_ADMITTED'
    job['human_visual_acceptance'] = 'APPROVED_EXPLICITLY'
    job['audit']['human_visual_acceptance'] = 'APPROVED_EXPLICITLY'
for step in jobs['step_results']:
    if step['step'] == 'S-005':
        step.update({'status': 'COMPLETED', 'result': 'Explicit owner acceptance recorded for NP01 v02, NP02 v01, NP03 v01 and PT01 v01; all remain DRAFT.'})
save('jobs.json', jobs)
audit = load('audit.json')
audit.update({'human_visual_acceptance': 'APPROVED_EXPLICITLY', 'visual_acceptance_receipt': 'visual-acceptance.json'})
for record in audit['records']:
    if record['recommended_for_owner_review']:
        record['human_visual_acceptance'] = 'APPROVED_EXPLICITLY'
save('audit.json', audit)
qa = load('gallery-qa.json')
qa.update({'human_visual_acceptance': 'APPROVED_EXPLICITLY', 'visual_acceptance_receipt': 'visual-acceptance.json'})
save('gallery-qa.json', qa)

def update_yaml(text, prefix=''):
    values = {'status': STATUS, 'checkpoint': CHECKPOINT, 'completed_steps': '5', 'human_visual_acceptance': 'APPROVED_EXPLICITLY', 'next_objective': "'"+NEXT+"'"}
    for key, value in values.items():
        text, count = re.subn(r'^'+prefix+re.escape(key)+r':.*$', prefix+key+': '+value, text, flags=re.M)
        assert count == 1, key
    return text

statepath = ROOT / '.atena/state/art032-npcs-piloto.yaml'
state = update_yaml(statepath.read_text(encoding='utf-8'))
state = state.replace('completed_ordered_steps: [S-001, S-002, S-003, S-004]', 'completed_ordered_steps: [S-001, S-002, S-003, S-004, S-005]')
if 'visual_owner_reply:' not in state:
    state += 'visual_owner_reply: "'+REPLY+'"\nvisual_accepted_revisions: [NP01_v02, NP02_v01, NP03_v01, PT01_v01]\nvisual_acceptance_receipt: .atena/generated/art032-npcs-2026-10-11/visual-acceptance.json\ncanonical_promotion: false\nnext_execution_authorized: false\n'
statepath.write_text(state, encoding='utf-8')
prefix = update_yaml(rootbefore.split('fila026_remaining_2026_10_11:', 1)[0], '  ')
if '  visual_owner_reply:' not in prefix:
    prefix += '  visual_owner_reply: "'+REPLY+'"\n  visual_acceptance_receipt: .atena/generated/art032-npcs-2026-10-11/visual-acceptance.json\n  canonical_promotion: false\n  next_execution_authorized: false\n'
rootpath.write_text(prefix+'fila026_remaining_2026_10_11:'+protected_tail, encoding='utf-8')
assert rootpath.read_text(encoding='utf-8').split('fila026_remaining_2026_10_11:', 1)[1] == protected_tail

planpath = ROOT / '.atena/vault/drafts/PLAN-ART032-NPCS-PILOTO-v01.md'
plan = planpath.read_text(encoding='utf-8').replace('status: GENERATED_AUDITED_WAITING_VISUAL_APPROVAL', 'status: '+STATUS)
plan = plan.replace('Aceite por conteúdo/revisão identificados; pendente, sem promoção automática.', 'Concluído: “Aprovo visualmente as quatro revisões”, NP01 v02 e NP02/NP03/PT01 v01; continuam DRAFT, sem promoção ou admissão.')
if '## Fechamento S-005' not in plan:
    plan += '\n## Fechamento S-005 — 2026-10-11\n\n**5/5 passos concluídos.** O dono respondeu “'+REPLY+'” à pergunta que identificava NP01 v02, NP02 v01, NP03 v01 e PT01 v01 e informava a ressalva de alfa 1/255. Aceite exclusivamente visual; não promoveu aparência/lore a CANON nem autorizou integração, normalização, commit ou push. [Recibo das revisões e hashes](../../generated/art032-npcs-2026-10-11/visual-acceptance.json). A entrega anterior documenta o histórico antes deste aceite. Próximo objetivo preparado: novo plano para normalização/admissão destas fontes ou produção das demais peças ART-032, usando fontes aceitas, bíblia/contexto e auditoria como entradas; saída futura deve preservar originais e definir checks/checkpoint próprios. Nenhuma execução futura autorizada por este aceite.\n'
planpath.write_text(plan, encoding='utf-8')
evidencepath = ROOT / '.atena/evidence/art032-npcs-piloto-2026-10-11.md'
evidence = evidencepath.read_text(encoding='utf-8')
if '## Aceite visual registrado' not in evidence:
    evidence += '\n## Aceite visual registrado — 2026-10-11\n\nO dono aprovou explicitamente **NP01 João Barbosa v02, NP02 desertor v01, NP03 vítima v01 e PT01 Estrela do Norte v01** com “'+REPLY+'”. A pergunta incluía estilo/aparência proposta, leitura dos atores a 80 px, estrela a 48/80 px e ressalva de alfa 1/255. [Recibo com hashes](../generated/art032-npcs-2026-10-11/visual-acceptance.json). S-005 concluído; total **5/5**, zero passos restantes. As seções anteriores são o histórico da entrega antes do aceite; o estado atual prevalece neste fechamento. Fontes continuam DRAFT; NP01 v01 histórico não aprovado. Sem promoção a CANON, normalização/admissão, integração, commit, push ou build. Aceite visual não é playtest nem teste de contraste sobre os mapas. Estados, jobs/auditoria/QA, galeria e backlog reconciliados; hashes nativos e cadeia PLAN-071 protegidos. Próxima execução exige novo escopo/checkpoint aprovado.\n'
evidencepath.write_text(evidence, encoding='utf-8')
backlogpath = ROOT / '.atena/backlog/ARTE.md'
backlog = backlogpath.read_text(encoding='utf-8')
backlog = backlog.replace('NP01 v02, NP02/NP03/PT01 v01 gerados e auditados; revisão visual S-005 pendente.', 'NP01 v02, NP02/NP03/PT01 v01 gerados, auditados e visualmente aceitos pelo dono; piloto 5/5 concluído, sem CANON/admissão.')
backlogpath.write_text(backlog, encoding='utf-8')
pagepath = OUT / 'index.html'
page = pagepath.read_text(encoding='utf-8')
page = page.replace('Revisão visual pendente.', 'Revisão visual aprovada pelo dono — S-005 concluído (5/5).')
if 'visual-acceptance.json' not in page:
    page = page.replace('<p>Fontes originais RGBA preservadas.', '<p>O dono respondeu “'+REPLY+'”. As quatro revisões continuam DRAFT, sem CANON ou admissão. <a href="visual-acceptance.json">Recibo do aceite visual</a>.</p><p>Fontes originais RGBA preservadas.')
pagepath.write_text(page, encoding='utf-8')
for doc in (evidencepath, planpath):
    for target in re.findall(r'\]\(([^)]+)\)', doc.read_text(encoding='utf-8')):
        assert (doc.parent / target).is_file(), (doc, target)
for job in jobs['jobs']:
    assert sha(ROOT / job['destination']) == job['sha256']
assert (jobs['state'], jobs['completed_steps']) == ('DRAFT', 5)
print('Visual acceptance recorded: NP01 v02; NP02/NP03/PT01 v01. Pilot 5/5 COMPLETE, DRAFT preserved; native/runtime/PLAN071 hashes and links PASS. No commit/push/admission.')
