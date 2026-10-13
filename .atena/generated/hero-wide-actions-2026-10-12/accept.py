"""Record the explicit four-candidate visual acceptance without authorizing admission."""
from pathlib import Path
import hashlib
import json
import re

OUT=Path(__file__).resolve().parent
ROOT=OUT.parents[2]
def sha(path):return hashlib.sha256(path.read_bytes()).hexdigest()
reply='Aprovo visualmente as quatro wide v01'
m=json.loads((OUT/'manifest.json').read_text(encoding='utf-8'))
a=json.loads((OUT/'audit.json').read_text(encoding='utf-8'))
assert m['completed_steps']==4 and m['current_step_position']==5
assert a['strips']==4 and a['frames']==20
assert not (OUT/'visual-acceptance.json').exists()
entries=[]
for source,derived in zip(m['records'],a['records']):
    assert source['code']==derived['code']
    assert sha(OUT/derived['strip'])==derived['sha256']
    assert sha(ROOT/source['source'])==source['source_sha256']
    for frame in derived['frames']:assert sha(OUT/frame['path'])==frame['sha256']
    entries.append({'code':source['code'],'revision':'wide-v01','hero':source['hero'],'action':source['action'],'path':(OUT/derived['strip']).relative_to(ROOT).as_posix(),'sha256':derived['sha256'],'cell':[512,512],'frames':len(derived['frames']),'frame_entries':derived['frames'],'source':source['source'],'source_sha256':source['source_sha256'],'reference_body_height':source['reference_body_height'],'scale_basis':source['scale_basis'],'uniform_scale':source['requested_scale'],'content_state':'DRAFT_VISUALLY_ACCEPTED_PREPARATION','runtime_admission':False})
receipt={'owner_reply':reply,'date':'2026-10-12','plan':'PLAN-053','revision':'DEV-024/hero-wide-actions-v01','request_classification':'IN_PLAN','status':'APPROVED_EXPLICITLY','content_state':'DRAFT_VISUALLY_ACCEPTED_PREPARATION','accepted_codes':['AO08','ER08','ER09','ER10'],'accepted_death_initial_calibration_px':285,'entries':entries,'runtime_admission':False,'canonical_promotion':False,'commit_push_export':False,'scope_limit':'Four wide v01 candidates only; prior holds/exceptions and renderer compatibility are not accepted by this receipt'}
(OUT/'visual-acceptance.json').write_text(json.dumps(receipt,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')

body=ROOT/'.atena/generated/hero-body-pivot-2026-10-12'
prior=json.loads((body/'visual-acceptance.json').read_text(encoding='utf-8'))
body_audit=json.loads((body/'audit.json').read_text(encoding='utf-8'))
selected=[]
for entry in prior['entries']:
    assert sha(ROOT/entry['path'])==entry['sha256']
    audited=next(r for r in body_audit['records'] if r['code']==entry['code'])
    selected.append({'code':entry['code'],'revision':entry['candidate'],'path':entry['path'],'sha256':entry['sha256'],'cell':[256,384],'frames':len(audited['frames']),'receipt':(body/'visual-acceptance.json').relative_to(ROOT).as_posix(),'content_state':'DRAFT_VISUALLY_ACCEPTED_PREPARATION'})
for entry in entries:selected.append({k:entry[k] for k in ('code','revision','path','sha256','cell','frames','content_state')}|{'receipt':(OUT/'visual-acceptance.json').relative_to(ROOT).as_posix()})
assert len(selected)==12 and len({e['code'] for e in selected})==12
assert sum(e['frames'] for e in selected)==64
remaining=[{'code':'AO04','reason':'body height spread 14 px versus 12 px criterion','decision':'Explicit exception or new correction scope; not approved here'},{'code':'AO07','reason':'body height spread 13 px versus 12 px criterion','decision':'Explicit exception or new correction scope; not approved here'},{'code':'AO09','reason':'connected significant pixels between action poses, including opaque rows','decision':'Mask recovery/regeneration proposal required before changing source/appearance'},{'code':'AO10','reason':'four significant rows crossed in final separation within assessed band','decision':'Assess other corridors or explicit treatment of overlapping glow; not assume safe split'},{'code':'ER03','reason':'seven observed poses against six-frame contract','decision':'Keep seven or choose six before admission; existing seven-frame candidate preserved'},{'code':'ER06','reason':'frame six clipped at source edge','decision':'Source correction or explicit exception; preparation cannot recover absent pixels'}]
inventory={'date':'2026-10-12','content_state':'DRAFT_VISUALLY_ACCEPTED_PREPARATION','accepted_strips':12,'accepted_frames':64,'expected_hero_animation_strips':18,'selected':selected,'remaining_animation_strips':remaining,'portrait_sources':'AO01/ER01 preserved; not admitted/promoted by these preparation receipts','runtime_admission':False,'canonical_promotion':False,'commit_push_export':False,'ao08_resolution':'Accepted wide v01 replaces only the retained narrow diagnostic as current preparation candidate; does not accept the narrow 176.5px body version'}
(OUT/'accepted-hero-inventory.json').write_text(json.dumps(inventory,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
m.update({'human_visual_acceptance':'FOUR_WIDE_V01_APPROVED_EXPLICITLY','owner_visual_reply':reply,'visual_acceptance':'visual-acceptance.json','accepted_inventory':'accepted-hero-inventory.json','next_objective':'Resolve six remaining animation holds before any admission; preserve twelve accepted DRAFT strips'});(OUT/'manifest.json').write_text(json.dumps(m,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
for p in [ROOT/'.atena/state/plan.yaml',ROOT/'.atena/state/hero-wide-actions.yaml']:
    text=p.read_text(encoding='utf-8')
    if p.name=='plan.yaml':prefix,tail=text.split('hero_mask_feasibility_2026_10_12:',1)
    else:prefix,tail=text,''
    prefix=prefix.replace('human_visual_acceptance: PENDING','human_visual_acceptance: FOUR_WIDE_V01_APPROVED_EXPLICITLY')
    prefix=re.sub(r'^  next_objective:.*$',"  next_objective: 'Resolver AO04/AO07/AO09/AO10/ER03/ER06; preservar doze tiras DRAFT aceitas'",prefix,flags=re.M)
    prefix+='  last_request_classification: IN_PLAN\n  owner_visual_reply: "'+reply+'"\n  accepted_date: "2026-10-12"\n  visual_acceptance_receipt: .atena/generated/hero-wide-actions-2026-10-12/visual-acceptance.json\n  accepted_hero_inventory: .atena/generated/hero-wide-actions-2026-10-12/accepted-hero-inventory.json\n  accepted_total_strips: 12\n  accepted_total_frames: 64\n  remaining_animation_strips: [AO04, AO07, AO09, AO10, ER03, ER06]\n'
    p.write_text(prefix+('hero_mask_feasibility_2026_10_12:'+tail if p.name=='plan.yaml' else ''),encoding='utf-8')
p=ROOT/'.atena/evidence/hero-wide-actions-2026-10-12.md';text=p.read_text(encoding='utf-8');text+='\n## Aceite do dono\n\nEm 2026-10-12: **“'+reply+'”**. Aceite de AO08/ER08/ER09/ER10 wide v01, incluindo a calibração de 285 px da primeira pose de morte; [recibo por hash](../generated/hero-wide-actions-2026-10-12/visual-acceptance.json). Plano 5/5 concluído visualmente aceito DRAFT, sem integração/CANON/Git. AO08 wide aceita resolve a preparação de escala retida na candidata estreita; a versão estreita de 176,5 px não foi aceita.\n\n[Inventário atual](../generated/hero-wide-actions-2026-10-12/accepted-hero-inventory.json): doze tiras/64 quadros DRAFT aceitos (oito candidatas v02 + quatro wide v01). Restam seis tiras: AO04/AO07 por variação de 14/13 px, AO09/AO10 por separação ambígua, ER03 por sete poses versus seis, ER06 pelo corte no quadro seis. Não estender esse aceite a tais exceções, retratos ou compatibilidade com renderer. Próximo objetivo preparado: resolver esses seis impedimentos com os gates anteriores preservados.\n';p.write_text(text,encoding='utf-8')
p=ROOT/'.atena/specs/SPEC-121-retomada-fila-imagens/hero-wide-actions-v01.md';text=p.read_text(encoding='utf-8');text=text.replace('Rota atual não autoriza presumir nova dimensão nem alterar a passada cancelada.','A rota anterior não autorizava presumir nova dimensão; a dimensão experimental foi aprovada explicitamente abaixo. A passada cancelada permanece fora do escopo.')
text+='\nS-005 concluído: **“'+reply+'”**, 2026-10-12. Cinco passos concluídos, 5/5, conteúdo DRAFT aceito visualmente. O aceite não autoriza admissão/CANON/Git; [recibo](../../generated/hero-wide-actions-2026-10-12/visual-acceptance.json). Restam seis tiras do escopo maior e a compatibilidade do renderer antes da futura admissão.\n';p.write_text(text,encoding='utf-8')
p=ROOT/'.atena/backlog/ARTE.md';lines=p.read_text(encoding='utf-8').splitlines()
for i,line in enumerate(lines):
    if line.startswith('| ART-045 |'):
        line=line.replace('oito com critérios técnicos medidos satisfeitos, AO04/AO07/AO08 retidas','oito com critérios técnicos medidos satisfeitos; AO04/AO07 e diagnóstico estreito AO08 retidos (AO08 resolvida pela wide aceita abaixo)')
        line=line.replace('técnico PASS; 4/5, aceite visual pendente.','técnico PASS; 5/5, quatro wide v01 visualmente aceitas DRAFT pelo dono.')
        lines[i]=line[:-1]+' Total atual: doze tiras/64 quadros visualmente aceitos DRAFT; seis tiras pendentes (AO04/AO07/AO09/AO10/ER03/ER06), nenhuma admissão. |'
        break
p.write_text('\n'.join(lines)+'\n',encoding='utf-8')
print('Four exact wide v01 strips and twenty frames visually accepted DRAFT; twelve total strips/64 frames; six remaining holds unchanged.')
