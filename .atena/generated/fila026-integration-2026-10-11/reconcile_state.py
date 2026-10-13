"""Reconcile approved local PLAN-065 facts; preserves the root active-plan tail."""
from pathlib import Path

ROOT = Path(__file__).resolve().parents[3]
EVID = '.atena/evidence/fila026-integration-2026-10-11.md'
PACK = '.atena/generated/fila026-integration-2026-10-11'

def read(path):
    return (ROOT / path).read_text(encoding='utf-8-sig')

def write(path, text):
    (ROOT / path).write_text(text, encoding='utf-8')

path = '.atena/state/fila026-remaining.yaml'
text = read(path)
text = text.replace('status: S014_INTEGRATION_IN_PROGRESS', 'status: S016_PREPARED_WAITING_CODE_COMMIT')
text = text.replace('checkpoint: B-004/S-014/INTEGRATION', 'checkpoint: B-004/S-016/CODE_COMMIT_PENDING_EXPLICIT_APPROVAL')
text = text.replace('current_step_position: 14', 'current_step_position: 16').replace('completed_steps: 13', 'completed_steps: 15')
text = text.replace("current_activity: 'Integrar banners e placas nas telas, com fallback e verificacao local'", "current_activity: 'Integracao e verificacao completas; fechamento local pronto, commit de codigo pendente'")
text = text.replace("next_objective: 'Gate S014: integracao das demais telas; depois S015 validacao completa e S016 fechamento'", "next_objective: 'Obter aprovacao explicita para commit separado MEC-058/codigo; playtest humano e publicacao em gates proprios'")
text = text.replace('commit_push_authorization: APPROVED_EXPLICITLY_2026_10_11', 'commit_push_authorization: ART_CHECKPOINT_ONLY_ALREADY_EXECUTED')
if 'integration_validation:' not in text:
    text += f'''integration_validation: PASS_LOCAL
integration_evidence: {EVID}
integration_gallery: {PACK}/index.html
integration_audit: {PACK}/audit.json
integration_code_state: LOCAL_UNCOMMITTED
code_commit_authorization: PENDING_EXPLICIT_OWNER_APPROVAL
code_push_build_authorization: NOT_AUTHORIZED
human_playtest: PENDING
step_results:
  S-014: DONE_LOCAL_INTEGRATION
  S-015: DONE_SUITE_0_FAILURES_AUDIT_0_ERRORS_9_WARNINGS_SMOKE_9_STAGES_18_CAPTURES
  S-016: RECORDS_PREPARED_CODE_COMMIT_PENDING
'''
write(path, text)

path = '.atena/state/plan-065-lettering-cursor.yaml'
text = read(path).replace('Admissao S013 validada; commit de arte pendente.', 'S013 arte publicada; S014/S015 concluidas; S016 pronta, commit de codigo pendente.')
text = text.replace("checkpoint: {step: S-014, status: INTEGRATION_IN_PROGRESS, evidence: '.atena/evidence/fila026-publication-2026-10-11.md', next: 'Integrar banners/placas; G5 verificada; validar localmente sem Git ou build'}", f"checkpoint: {{step: S-016, status: CODE_COMMIT_PENDING_EXPLICIT_APPROVAL, evidence: '{EVID}', next: 'Commit separado MEC-058/codigo apos autorizacao; playtest e publicacao pendentes'}}")
text = text.replace('completed_step_positions: 13', 'completed_step_positions: 15').replace('current_step_position: 14', 'current_step_position: 16')
text = text.replace("B-004: {title: 'Integracao, verificacao e fechamento', steps: [S-014, S-015, S-016], status: PENDING, depends: 'B-003; commits de PLAN-063/064 para ui/hud.gd, ui/character_sheet.gd, ui/hero_panel.gd'}", f"B-004: {{title: 'Integracao, verificacao e fechamento', steps: [S-014, S-015, S-016], status: LOCAL_READY_WAITING_CODE_COMMIT, evidence: '{EVID}', depends: 'G5 atendida: 7c4da5d e 1ef33bf ancestrais de HEAD'}}")
if 'integration_result:' not in text:
    text += f'''  integration_result:
    revision: FILA026-INTEGRATION/v01
    S-014: DONE_LOCAL
    S-015: DONE_PASS
    S-016: RECORDS_PREPARED_CODE_COMMIT_PENDING
    suite_failures: 0
    project_audit: {{errors: 0, warnings: 9}}
    smoke_stages: 9
    captures: 18
    evidence: {EVID}
    gallery: {PACK}/index.html
    human_playtest: PENDING
    code_commit_authorization: PENDING_EXPLICIT_OWNER_APPROVAL
    code_push_build_authorization: NOT_AUTHORIZED
    art_git_authorization_scope: HISTORICAL_ART_CHECKPOINT_ALREADY_EXECUTED
'''
write(path, text)

path = '.atena/state/plan.yaml'
text = read(path)
prefix, tail = text.split('fila026_l01_2026_10_11:', 1)
prefix = prefix.replace('status: S014_INTEGRATION_IN_PROGRESS', 'status: S016_PREPARED_WAITING_CODE_COMMIT')
prefix = prefix.replace('checkpoint: B-004/S-014/INTEGRATION', 'checkpoint: B-004/S-016/CODE_COMMIT_PENDING_EXPLICIT_APPROVAL')
prefix = prefix.replace('current_step_position: 14', 'current_step_position: 16').replace('completed_steps: 13', 'completed_steps: 15')
prefix = prefix.replace("next_objective: 'S014 integracao pendente; S015 validacao completa; L02 opcional deferida'", "next_objective: 'Commit separado MEC-058/codigo aguarda aprovacao explicita; playtest pendente'")
if 'integration_gallery:' not in prefix:
    prefix += f'''  integration_revision: FILA026-INTEGRATION/v01
  integration_evidence: {EVID}
  integration_gallery: {PACK}/index.html
  integration_audit: {PACK}/audit.json
  suite_failures: 0
  captures: 18
  code_commit_authorization: PENDING_EXPLICIT_OWNER_APPROVAL
  code_push_build_authorization: NOT_AUTHORIZED
  human_playtest: PENDING
'''
write(path, prefix + 'fila026_l01_2026_10_11:' + tail)

path = '.atena/vault/drafts/SPEC-132-lettering-e-cursor-do-jogo.md'
text = read(path).replace('status: approved-in-execution (aprovada por plano pelo dono em 2026-10-06; B-001 e B-002 feitas, EVID-172)', 'status: implemented-pending-playtest')
note = '\nImplementação local 2026-10-11: fontes CANON v01 admitidas e publicadas; S014/S015 concluídas, S016 com registros prontos e commit de código pendente de aprovação. Suíte 0 falhas, auditoria 0 erros/9 avisos, smoke nove fases, 18 capturas. [Evidência](../../evidence/fila026-integration-2026-10-11.md). Nenhuma build ou aceite humano nesta etapa; o estado operacional é `.atena/state/plan-065-lettering-cursor.yaml`.\n'
if 'Implementação local 2026-10-11:' not in text:
    text = text.replace('# SPEC-132\n', '# SPEC-132\n' + note, 1)
write(path, text)

path = '.atena/vault/drafts/PLAN-065-lettering-e-cursor-2026-10-06.md'
text = read(path).replace('status: S013 concluida, arte commitada e push verificado; S014 integracao pendente', 'status: S014 e S015 concluidas; S016 registros prontos, commit de codigo pendente')
note = '\nContinuação 2026-10-11 autorizada com **“atena, vamos seguir para o proximo”**: S014 integração e S015 verificação concluídas. S016/16 atual, quinze passos concluídos, nenhum após o atual; registros reconciliados, commit isolado de MEC-058/código aguarda aprovação explícita. Suíte 0 falhas, auditoria 0 erros/9 avisos, smoke nove fases e 18 capturas. [Evidência e roteiro](../../evidence/fila026-integration-2026-10-11.md). Playtest humano, push e build pendentes em seus gates. As passagens seguintes preservam checkpoints históricos.\n'
if 'Continuação 2026-10-11 autorizada' not in text:
    text = text.replace('# PLAN-065\n', '# PLAN-065\n' + note, 1)
write(path, text)

updates = {
    '.atena/backlog/ARTE.md': {
        'ART-039': '**CANON v01 admitida, commitada e publicada em 2026-10-11** (L01 e L03–L05/P01–P03, `86c453f`); integração local concluída com 18 capturas, suíte 0 falhas. [Evidência](../evidence/fila026-integration-2026-10-11.md), PLAN-065/SPEC-132. L02 opcional deferida; commit de código MEC-058 e playtest humano pendentes.',
        'ART-040': '**C01–C03 v01 CANON admitidos e publicados em 2026-10-11** (`86c453f`), 32/32/40 px e hotspots (1,1)/(4,1)/(20,20). Contratos cursor/AUTO/MOUSE/modais passam na suíte; aparência e mira na janela real aguardam playtest. [Evidência](../evidence/fila026-integration-2026-10-11.md); integração MEC-058 local, commit de código pendente.'},
    '.atena/backlog/MECANICAS.md': {
        'MEC-058': '**IMPLEMENTADO LOCAL 2026-10-11; aguarda commit separado e playtest humano.** Banners/placas integrados com fallback, logo/cursor pelos hookups existentes; suíte 0 falhas, auditoria 0 erros/9 avisos, smoke nove fases e 18 capturas. [Evidência](../evidence/fila026-integration-2026-10-11.md), PLAN-065/SPEC-132. Arte já publicada no commit independente `86c453f`; sem build nova.'}
}
for path, cards in updates.items():
    lines = read(path).splitlines()
    for i, line in enumerate(lines):
        for card, result in cards.items():
            if line.startswith('| ' + card + ' |'):
                columns = line.split('|')
                columns[-2] = ' ' + result + ' '
                lines[i] = '|'.join(columns)
    write(path, '\n'.join(lines) + '\n')

path = '.atena/backlog/RELEASES.md'
text = read(path)
note = '\n- **Lettering e cursor (MEC-058, ART-039/040)**: peças CANON v01 publicadas em `86c453f`; integração local pronta, **ainda sem commit de código nem build** ([evidência](../evidence/fila026-integration-2026-10-11.md), PLAN-065/SPEC-132). **O que testar na próxima build autorizada que inclua a integração:** título, Quartel, HQ, ficha C, vitória/derrota, evolução e chefe em 720p/1080p, sem texto cortado/controles cobertos; ponteiro/mão 32 px e mira 40 px na janela real; AUTO/MOUSE e retorno ao ponteiro ao abrir pausa, nível, altar e ficha C, restaurando a mira ao fechar. Touch simulado passou; aparelho real e avaliação humana continuam pendentes. Registrar versão/build_id reais e tela/resolução ao reportar problemas.\n'
if '**Lettering e cursor (MEC-058, ART-039/040)**:' not in text:
    text = text.replace('## Aguardando versão (sem build)\n', '## Aguardando versão (sem build)\n' + note, 1)
write(path, text)
print('PLAN-065 S016 local records prepared; code commit remains pending; PLAN-071 root active-plan tail preserved')
