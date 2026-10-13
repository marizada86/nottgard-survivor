"""Persist proposal and completed local commit facts; preserve unrelated work."""
import json
from pathlib import Path
import subprocess

ROOT = Path(__file__).resolve().parents[3]
OUT = Path(__file__).resolve().parent

def read(path):
    return (ROOT / path).read_text(encoding='utf-8-sig')

def write(path, text):
    (ROOT / path).write_text(text, encoding='utf-8')

commit = 'fc5c709f3ef5c4acdc7c5a8a842747b72c7f70ec'
assert subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=ROOT).decode().strip() == commit
receipt_path = '.atena/generated/fila026-integration-2026-10-11/commit-receipt.json'
receipt = json.loads(read(receipt_path))
assert receipt['commit'] == commit and receipt['status'] == 'LOCAL_COMMIT_VERIFIED'
for path in ['.atena/state/fila026-remaining.yaml', '.atena/state/plan-065-lettering-cursor.yaml']:
    text = read(path).replace('S-016: RECORDS_PREPARED_CODE_COMMIT_PENDING', 'S-016: DONE_LOCAL_COMMIT_VERIFIED')
    text = text.replace('status: IN_PROGRESS\n', 'status: IMPLEMENTED_LOCAL_COMMITTED_PENDING_PLAYTEST\n', 1)
    text = text.replace('status: LOCAL_READY_WAITING_CODE_COMMIT', 'status: DONE_LOCAL_COMMITTED_PENDING_PLAYTEST')
    text = text.replace('commit separado MEC-058/codigo; playtest humano e publicacao em gates proprios', 'playtest humano e publicacao em gates proprios')
    text = text.replace("next_objective: 'Obter aprovacao explicita para commit separado MEC-058/codigo; playtest humano e publicacao em gates proprios'", "next_objective: 'Playtest humano em build autorizada; novas fontes ART032 em plano separado'")
    write(path, text)
for path, heading in [('.atena/vault/drafts/PLAN-065-lettering-e-cursor-2026-10-06.md', '# PLAN-065\n'), ('.atena/vault/drafts/SPEC-132-lettering-e-cursor-do-jogo.md', '# SPEC-132\n')]:
    text = read(path)
    note = '\nFechamento local 2026-10-11: commit de código separado `' + commit[:7] + '` executado e verificado com autorização **“atena, commit e vamos criar as proximas imagens”**. S016 concluída, 16/16 passos executados; [recibo](../../generated/fila026-integration-2026-10-11/commit-receipt.json). Playtest humano e publicação permanecem pendentes. Os registros abaixo são históricos.\n'
    if 'Fechamento local 2026-10-11:' not in text:
        text = text.replace(heading, heading + note, 1)
    if 'PLAN-065' in path:
        text = text.replace('status: S014 e S015 concluidas; S016 registros prontos, commit de codigo pendente', 'status: IMPLEMENTED_LOCAL_COMMITTED_PENDING_PLAYTEST')
    write(path, text)
path = '.atena/evidence/fila026-integration-2026-10-11.md'
text = read(path)
if 'Commit efetivamente executado:' not in text:
    text += '\nCommit efetivamente executado: `' + commit + '`, 58 arquivos de MEC-058/integração/evidências; [recibo](../generated/fila026-integration-2026-10-11/commit-receipt.json). Logs preservados como cópias `.txt` rastreáveis, sem alterar a política de ignore. S016 concluída localmente, 16/16 passos; nenhum push/build. Trabalho dos heróis permaneceu fora do commit.\n'
write(path, text)
path = '.atena/generated/fila026-integration-2026-10-11/index.html'
text = read(path).replace('integração local ainda sem commit', 'integração local no commit fc5c709; playtest humano pendente')
write(path, text)
path = '.atena/state/plan.yaml'
text = read(path)
before_active = text.split('active_plan:', 1)[1]
entry = '''art032_npcs_piloto_2026_10_11:
  plan: PLAN-ART032-NPCS-PILOTO
  revision: v01
  card: ART-032
  state_file: .atena/state/art032-npcs-piloto.yaml
  request_classification: PLAN_DEVIATION
  route: PROPOSE_SELECTED_FRONT_NOW_PRESERVE_PLAN071_AND_HERO_REVIEW
  status: PROPOSED_WAITING_SCOPE_APPROVAL
  mode: per-plan
  checkpoint: S-001/PLAN_APPROVAL
  current_step_position: 1
  completed_steps: 1
  total_steps: 5
  proposed_sources: [NP01, NP02, NP03, PT01]
  generated: 0
  content_state: DRAFT
  runtime_admission: false
  git_publication_build: NOT_AUTHORIZED_FOR_NEW_IMAGES
  next_objective: 'Aprovar o escopo preparado; gerar quatro fontes DRAFT, auditar e apresentar galeria'
'''
if 'art032_npcs_piloto_2026_10_11:' not in text:
    text = text.replace('version: 2\n', 'version: 2\n' + entry, 1)
assert text.split('active_plan:', 1)[1] == before_active
write(path, text)
source_ref = 'cf17d7c3a0ff059320c7f580fd6a7d4ef8ec8aa1'
snapshot = subprocess.check_output(['git', 'show', source_ref + ':.atena/state/plan-053-imagens.yaml'], cwd=ROOT)
(OUT / 'historical-queue-state-cf17d7c.yaml').write_bytes(snapshot)
path = '.atena/state/plan-053-imagens.yaml'
text = read(path)
if 'queue_inventory_reconciliation_2026_10_11:' not in text:
    text += '''
queue_inventory_reconciliation_2026_10_11:
  status: OLDER_N03_CURSOR_SUPERSEDED_BY_VERIFIED_LOCAL_RECORD
  source_git_ref: cf17d7c3a0ff059320c7f580fd6a7d4ef8ec8aa1
  source_snapshot: .atena/generated/art032-npcs-2026-10-11/historical-queue-state-cf17d7c.yaml
  source_counts: {fila022: '36/36', fila023: '60/60', fila027: '20/20'}
  current_authoritative_hero_review: .atena/state/hero-extraction-review-2026-10-11.yaml
  proposed_next_generation: .atena/state/art032-npcs-piloto.yaml
  warning: 'Older top-level N03 publication checkpoint is historical; do not regenerate missing copies from that cursor'
  merge: NOT_PERFORMED
  plan071_return: PRESERVED
'''
write(path, text)
print('Local FILA026 commit reconciled; ART032 scope proposal prepared; PLAN071/hero checkpoint preserved')
