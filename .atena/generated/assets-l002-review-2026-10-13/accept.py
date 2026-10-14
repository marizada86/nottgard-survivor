from pathlib import Path
import hashlib,json,re
out=Path(__file__).resolve().parent;root=out.parents[2]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
m=json.loads((out/'manifest.json').read_text(encoding='utf-8'));sources=m['sources'];protected=json.loads((out/'protected.json').read_text(encoding='utf-8'))
assert all(sha(root/e['path'])==e['sha256'] for e in sources)
assert all(sha(root/p)==h for p,h in protected.items())
accepted=[dict(e,content_state='DRAFT_VISUALLY_ACCEPTED') for e in sources if e['code'] not in ['H402','H403','H406']]
reserved=[dict(e,decision='RESERVED_FOR_CORRECTION_NOT_ACCEPTED') for e in sources if e['code'] in ['H402','H406']]
gates=[e for e in sources if e['code']=='H403'];assert len(accepted)==39 and len(reserved)==2 and len(gates)==1
receipt={'revision':'assets-l002-review/v01','batch':'L-002','owner_reply':'Aprovo as 39 fases DRAFT; reservar H402/H406 para correção (Recomendado)','accepted':accepted,'reserved_for_correction':reserved,'historical_gate_acceptances_preserved':gates,'content_state':'DRAFT_WITH_H403_V02_HISTORICAL_GATE_PRESERVED','canonical_promotion':False,'authorized_next_action':'PREPARE_BOUNDED_TWO_FRAME_CORRECTION_PROPOSAL','correction_execution_authorized':False,'admission_execution_authorized':False,'git_authorized':False}
(out/'visual-acceptance.json').write_text(json.dumps(receipt,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=out/'index.html';page=p.read_text(encoding='utf-8').replace('41 fontes DRAFT aguardam aceite; H403v02 possui aceite histórico preservado.','39 fases DRAFT aceitas pelo dono; H402v01/H406v01 reservadas para correção; H403v02 histórico preservado.')
for e in sources:
 old=f'<h3>{e["code"]} {e["version"]}'+(' · AJUSTE RECOMENDADO' if e['code'] in ['H402','H406'] else '')+'</h3>'
 pos=page.index(old);end=page.index('</figure>',pos)
 section=page[pos:end]
 section=section.replace('PENDING_VISUAL_ACCEPTANCE','RESERVED_FOR_CORRECTION_NOT_ACCEPTED' if e['code'] in ['H402','H406'] else 'DRAFT_VISUALLY_ACCEPTED')
 page=page[:pos]+section+page[end:]
p.write_text(page,encoding='utf-8')
proposal=root/'.atena/generated/sylas-two-frame-correction-2026-10-13';proposal.mkdir(exist_ok=True)
bycode={e['code']:e for e in sources}
prompts=[{'code':'H402','planned_version':'v02','intent':'edit','use_case':'precise-object-edit','edit_target':bycode['H402'],'references':[dict(bycode['H403'],role='IMMUTABLE_APPROVED_PEAK_STYLE_AND_MAX_EXTENT'),dict(bycode['H401'],role='ACCEPTED_START_SEQUENCE_CONTEXT')],'transparent_background':False,'prompt':'Use case: precise-object-edit. Asset: isolated 2D game VFX, growth frame H402 for Sylas shadow dash. Image 1 is the edit target H402v01, Image 2 is immutable approved H403v02 PEAK reference, Image 3 is accepted H401v01 START reference. Correct only the phase progression: a compact right-facing torn smoke ribbon, approximately 60 percent of the peak forward extent, larger than START and clearly shorter/dimmer than PEAK. Square 1024x1024, exact black opaque background, no transparency. Keep logical origin at canvas center; effect stays predominantly in RIGHT half, brightest head around x=0.78 to0.82, y=0.5; do not extend the tail far left of center. Preserve painted white/gray smoke texture and subtle abstract mask-shaped glints, same top-down flat orientation, not perspective. Do not move/resize the entire old full-length streak; redraw its growth phase so it no longer exceeds the approved peak. Keep safe black margins. No character, body, weapon, text, border, scenery, color, new emblem, full peak or longer/brighter tail.'},{'code':'H406','planned_version':'v02','intent':'edit','use_case':'precise-object-edit','edit_target':bycode['H406'],'references':[dict(bycode['H405'],role='ACCEPTED_PREVIOUS_BREAK_PHASE'),dict(bycode['H403'],role='IMMUTABLE_STYLE_ONLY_NOT_BRIGHTNESS_OR_SHAPE_TARGET')],'transparent_background':False,'prompt':'Use case: precise-object-edit. Asset: isolated 2D game VFX, LAST dissipation frame H406 for Sylas shadow dash. Image 1 is edit target H406v01; Image 2 is accepted previous BREAK phase H405v01; Image 3 is immutable approved H403v02 PEAK for painted white/gray STYLE ONLY, never recreate its head or brightness. Replace coherent luminous arrowhead, continuous smoke ribbon and intact mask glints with only a FEW tiny very faint gray torn wisps/fragments and specks in the residual locations of Image2. This is the final almost-black instant: much dimmer/sparser than H405, no recognizable head, no continuous stroke, no intact mask face or eyes, no bright core, no renewed growth. Square1024x1024, exact BLACK opaque background, no transparency; almost all canvas pure black. Preserve central origin and rightward spatial context, top-down flat orientation, safe black margins. Do not merely lower opacity while keeping the full arrow shape: break/remove that silhouette. No character/body/weapon/text/border/scenery/color/new motif.'}]
(proposal/'prompts.json').write_text(json.dumps({'revision':'sylas-two-frame-correction/v01','status':'PROPOSED_NOT_EXECUTABLE_UNTIL_APPROVAL','tool':'built-in image_gen','skill':'C:/Users/Higor Rossini/.codex/skills/.system/imagegen/SKILL.md','jobs':prompts,'initial_calls':2,'max_total_calls_including_one_retry_per_frame':4,'canonical_promotion':False,'runtime_admission':False},ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=root/'.atena/state/assets-l002-review.yaml';s=p.read_text(encoding='utf-8').replace('status: TECHNICAL_REVIEW_COMPLETE_AWAITING_OWNER_VISUAL_DECISION','status: COMPLETED_VISUALLY_ACCEPTED_WITH_EXCLUSIONS').replace('S-004/OWNER_VISUAL_BATCH_DECISION','S-004/OWNER_VISUAL_DECISION_RECORDED').replace('approval_status: PENDING_VISUAL_DECISION','approval_status: APPROVED_39_DRAFT_RESERVED_2');s=re.sub(r'next_objective:.*','next_objective: Escolher modo e aprovar proposta limitada sylas-two-frame-correction/v01.',s);s+='visual_acceptance: .atena/generated/assets-l002-review-2026-10-13/visual-acceptance.json\naccepted_additional_frames: 39\nreserved_frames: [H402v01, H406v01]\ncorrection_proposal: .atena/specs/SPEC-121-retomada-fila-imagens/sylas-two-frame-correction-v01.md\ncorrection_execution_authorized: false\n';p.write_text(s,encoding='utf-8')
for n in ['plan.yaml','plan-053-imagens.yaml']:
 p=root/'.atena/state'/n;s=p.read_text(encoding='utf-8');prefix,block=s.split('assets_l002_review_2026_10_13:',1)
 block=block.replace('status: TECHNICAL_REVIEW_COMPLETE_AWAITING_OWNER_VISUAL_DECISION','status: COMPLETED_VISUALLY_ACCEPTED_WITH_EXCLUSIONS').replace('S-004/OWNER_VISUAL_BATCH_DECISION','S-004/OWNER_VISUAL_DECISION_RECORDED').replace('additional_frames_pending_acceptance: 41','additional_frames_pending_acceptance: 2');block+='  accepted_additional_frames: 39\n  reserved_frames: [H402v01, H406v01]\n  visual_acceptance: .atena/generated/assets-l002-review-2026-10-13/visual-acceptance.json\n'
 s=prefix+'assets_l002_review_2026_10_13:'+block
 if n=='plan-053-imagens.yaml':s=s.replace('S-007/VFX/L-002/OWNER_VISUAL_BATCH_DECISION','S-007/VFX/L-002/CORRECTION_PLAN_APPROVAL').replace('status: L002_42_IMAGES_REVIEWED_AWAITING_OWNER','status: L002_39_ACCEPTED_2_RESERVED_CORRECTION_PROPOSED').replace('L001 commit2b96638 local concluido; L00242fontes recuperadas, sete sequencias revisadas, recomendacao reservarH402/H406.','L00239fases aceitas DRAFT, H403v02 preservado e H402/H406 reservados; proposta de duas correcoes preparada.').replace('Decisao visual agrupada L002; depois proposta de correcao/admissao limitada, sem regeneracao automatica.','Escolher modo/aprovar sylas-two-frame-correction/v01; depois aceite conjunto dos dois candidatos.')
 s+='''sylas_two_frame_correction_2026_10_13:
  plan: PLAN-053
  revision: sylas-two-frame-correction/v01
  classification: PLAN_CHANGE_REQUEST
  state_file: .atena/state/sylas-two-frame-correction.yaml
  mode: unconfigured
  status: PROPOSED_AWAITING_SCOPE_AND_MODE
  checkpoint: PLAN_APPROVAL
  completed_steps: 0
  total_steps: 4
  frames: [H402, H406]
  content_state: DRAFT
  runtime_admission: false
  canonical_promotion: false
  return_plan: PLAN-071
  return_checkpoint: B-006/S-011
''';p.write_text(s,encoding='utf-8')
for rel in ['.atena/evidence/assets-l002-review-2026-10-13.md','.atena/specs/SPEC-121-retomada-fila-imagens/assets-l002-review-v01.md']:
 with (root/rel).open('a',encoding='utf-8') as f:f.write('\nDecisão posterior: dono respondeu “Aprovo as39fases DRAFT; reservarH402/H406 para correção (Recomendado)”.39aceites registrados por hash, H403v02 histórico preservado, duasv01 reservadas/não aceitas; nenhuma geração/admissão autorizada. Proposta sylas-two-frame-correction/v01 preparada, dois alvos/referências/prompts delimitados e modo unconfigured. Recibo `.atena/generated/assets-l002-review-2026-10-13/visual-acceptance.json`; prompts `.atena/generated/sylas-two-frame-correction-2026-10-13/prompts.json`.\n')
with (root/'.atena/backlog/ARTE.md').open('a',encoding='utf-8') as f:f.write('\n2026-10-13 — ART030 L002: dono aceitou39fasesDRAFT e reservouH402v01/H406v01 para correção; H403v02 histórico preservado. Proposta limitada sylas-two-frame-correction/v01 pronta, aguardando escopo/modo; nenhum novo gerado/integrado, semCANON/Git. Recibo `.atena/generated/assets-l002-review-2026-10-13/visual-acceptance.json`.\n')
spec=root/'.atena/specs/SPEC-121-retomada-fila-imagens/sylas-two-frame-correction-v01.md';links=re.findall(r'\]\(([^)]+)\)',spec.read_text(encoding='utf-8'));assert all((spec.parent/link).exists() for link in links)
for job in prompts:
 for e in [job['edit_target']]+job['references']:assert sha(root/e['path'])==e['sha256']
assert re.search(r'active_plan:\s+id: PLAN-071',(root/'.atena/state/plan.yaml').read_text(encoding='utf-8'))
result={'status':'PASS','accepted':39,'reserved':2,'historical_gate_preserved':1,'source_hashes_verified':42,'runtime_files_unchanged':len(protected),'proposal_links_verified':len(links),'proposed_edit_jobs':2,'generated_images':0,'correction_mode':'unconfigured','execution_authorized':False,'canonical_promotion':False,'git_operations':'NONE'}
(out/'acceptance-proposal-checks.json').write_text(json.dumps(result,indent=2)+'\n',encoding='utf-8');print(json.dumps(result))
