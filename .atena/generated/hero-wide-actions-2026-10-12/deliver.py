"""Persist the audited draft delivery at its required human visual checkpoint."""
from pathlib import Path
import json
import re
OUT=Path(__file__).resolve().parent
ROOT=OUT.parents[2]
a=json.loads((OUT/'audit.json').read_text(encoding='utf-8'))
g=json.loads((OUT/'gallery-qa.json').read_text(encoding='utf-8'))
assert a['frames']==20 and a['strips']==4 and a['status']=='TECHNICAL_PASS_OWNER_REVIEW_PENDING'
assert g['links']==53
p=OUT/'manifest.json';m=json.loads(p.read_text(encoding='utf-8'));m.update({'technical_status':'PASS','prepared_frames':20,'prepared_strips':4,'gallery':'index.html','board':'review-board.png','audit':'audit.json','human_visual_acceptance':'PENDING','next_objective':'Review four wide v01 candidates, before any admission/canonical/Git action'});p.write_text(json.dumps(m,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
for p in [ROOT/'.atena/state/plan.yaml',ROOT/'.atena/state/hero-wide-actions.yaml']:
    text=p.read_text(encoding='utf-8')
    if p.name=='plan.yaml':prefix,tail=text.split('hero_mask_feasibility_2026_10_12:',1)
    else:prefix,tail=text,''
    prefix=re.sub(r'^  next_objective:.*$',"  next_objective: 'Aceite visual de AO08/ER08/ER09/ER10 wide v01 antes de eventual uso futuro'",prefix,flags=re.M)
    prefix=prefix.replace('next_execution_authorized: true','next_execution_authorized: false')
    prefix+='  technical_status: PASS\n  prepared_frames: 20\n  prepared_strips: 4\n  human_visual_acceptance: PENDING\n  gallery: .atena/generated/hero-wide-actions-2026-10-12/index.html\n  board: .atena/generated/hero-wide-actions-2026-10-12/review-board.png\n  evidence: .atena/evidence/hero-wide-actions-2026-10-12.md\n'
    p.write_text(prefix+('hero_mask_feasibility_2026_10_12:'+tail if p.name=='plan.yaml' else ''),encoding='utf-8')
p=ROOT/'.atena/specs/SPEC-121-retomada-fila-imagens/hero-wide-actions-v01.md';text=p.read_text(encoding='utf-8');text+='\nEntrega técnica: S-001–S-004 concluídos, 4/5; S-005 (5/5) atual, pendente de aceite visual das quatro wide v01 DRAFT. Vinte células/4 tiras, margem mínima 37 px; [evidência](../../evidence/hero-wide-actions-2026-10-12.md). Compatibilidade/admissão/CANON/Git permanecem fora deste escopo.\n';p.write_text(text,encoding='utf-8')
p=ROOT/'.atena/backlog/ARTE.md';lines=p.read_text(encoding='utf-8').splitlines()
for i,line in enumerate(lines):
    if line.startswith('| ART-045 |'):
        lines[i]=line.replace('Canvas ampliado de quatro ações proposto, pendente de aprovação.','Canvas ampliado aprovado e preparado: AO08/ER08/ER09/ER10 wide v01 DRAFT, 20 células 512×512/4 tiras, técnico PASS; 4/5, aceite visual pendente. [Entrega](../evidence/hero-wide-actions-2026-10-12.md).')
        break
p.write_text('\n'.join(lines)+'\n',encoding='utf-8')
print('Four wide v01 candidates delivered DRAFT, technical PASS; owner visual gate pending; no admission/CANON/Git.')
