"""Record the explicit owner acceptance, preserve historical receipts, close S-003."""
from pathlib import Path
import copy, hashlib, json, re, subprocess, sys

OUT=Path(__file__).resolve().parent
ROOT=OUT.parents[2]
REPLY='Aprovo as duas v02 com exceção de 14/13 px (recomendado)'
def sha(p): return hashlib.sha256(p.read_bytes()).hexdigest()
def write(p, value): p.write_text(json.dumps(value,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
assert not (OUT/'visual-acceptance.json').exists()
subprocess.run([sys.executable,str(OUT/'prepare_review.py')],check=True,cwd=ROOT)
review=json.loads((OUT/'review.json').read_text(encoding='utf-8'))
previous=ROOT/'.atena/generated/hero-wide-actions-2026-10-12/accepted-hero-inventory.json'
inventory=json.loads(previous.read_text(encoding='utf-8'))
historical=[previous,ROOT/'.atena/generated/hero-wide-actions-2026-10-12/visual-acceptance.json',ROOT/'.atena/generated/hero-body-pivot-2026-10-12/visual-acceptance.json',ROOT/'.atena/generated/hero-body-pivot-2026-10-12/audit.json']
hashes={str(p.relative_to(ROOT)):sha(p) for p in historical}
state=ROOT/'.atena/state/hero-spread-exception.yaml'
operational=ROOT/'.atena/state/plan.yaml'
old=operational.read_text(encoding='utf-8')
anchor='hero_wide_actions_2026_10_12:'
prior_tail=anchor+old.split(anchor,1)[1]
def set_state(completed, checkpoint, status):
    text=state.read_text(encoding='utf-8')
    for key,value in {'status':status,'approval_status':'APPROVED_EXPLICITLY_WITH_LIMITED_EXCEPTION','checkpoint':checkpoint,'current_step_position':3,'completed_steps':completed,'remaining_steps_after_current':0,'next_objective':"'Avaliar AO09/AO10; decidir ER03/ER06 antes da admissão'"}.items():
        text,n=re.subn(r'^  '+key+r':.*$',f'  {key}: {value}',text,flags=re.M)
        assert n==1,key
    if '  owner_reply:' not in text:
        text+='  owner_reply: '+json.dumps(REPLY,ensure_ascii=False)+'\n  accepted_date: "2026-10-13"\n  last_request_classification: IN_PLAN\n'
    state.write_text(text,encoding='utf-8')
    operational.write_text('version: 2\n'+text.split('\n',1)[1]+prior_tail,encoding='utf-8')
set_state(2,'S-003/RECEIPT_INVENTORY','OWNER_APPROVED_RECORDING_RECEIPT')
entries=[]
for r in review['records']:
    assert sha(ROOT/r['path'])==r['sha256']
    for f in r['frames']: assert sha(ROOT/f['path'])==f['sha256']
    e=copy.deepcopy(r)
    e.update(accepted_spread_max_px=r['body_spread'],original_criterion_satisfied=False,technical_status='STRUCTURAL_PASS_SPREAD_EXCEPTION_ACCEPTED',human_visual_acceptance='APPROVED_EXPLICITLY_DRAFT_WITH_EXCEPTION',exception_approval='APPROVED_EXPLICITLY_EXACT_REVISION_ONLY',content_state='DRAFT_VISUALLY_ACCEPTED_PREPARATION_WITH_EXCEPTION',runtime_admission=False)
    entries.append(e)
receipt=dict(date='2026-10-13',owner_reply=REPLY,scope='AO04_AO07_BODY_PIVOT_V02_ONLY_WITH_14_13_PX_SPREAD_EXCEPTION',content_state='DRAFT_VISUALLY_ACCEPTED_PREPARATION_WITH_EXCEPTION',global_spread_limit_px=12,entries=entries,runtime_admission=False,canonical_promotion=False,commit_push_export=False,source_rasters_unchanged=True,other_revisions_not_accepted=True)
write(OUT/'visual-acceptance.json',receipt)
new_inventory=copy.deepcopy(inventory)
new_inventory.update(date='2026-10-13',accepted_strips=14,accepted_frames=76,previous_inventory=str(previous.relative_to(ROOT)).replace('\\','/'),previous_inventory_sha256=sha(previous),limited_exceptions={'AO04':{'revision':'body-pivot-v01/candidates-v02','max_spread_px':14},'AO07':{'revision':'body-pivot-v01/candidates-v02','max_spread_px':13}},global_spread_limit_px=12)
receipt_path=str((OUT/'visual-acceptance.json').relative_to(ROOT)).replace('\\','/')
for e in entries:
    new_inventory['selected'].append(dict(code=e['code'],revision=e['revision'],path=e['path'],sha256=e['sha256'],cell=[256,384],frames=6,receipt=receipt_path,content_state=e['content_state'],accepted_spread_max_px=e['accepted_spread_max_px'],original_spread_limit_px=12))
new_inventory['selected'].sort(key=lambda e:e['code'])
new_inventory['remaining_animation_strips']=[e for e in inventory['remaining_animation_strips'] if e['code'] not in ['AO04','AO07']]
assert len(new_inventory['selected'])==14 and sum(e['frames'] for e in new_inventory['selected'])==76
assert len({e['code'] for e in new_inventory['selected']})==14
write(OUT/'accepted-hero-inventory.json',new_inventory)
subprocess.run([sys.executable,str(OUT/'prepare_review.py')],check=True,cwd=ROOT)
evidence=ROOT/'.atena/evidence/hero-spread-review-2026-10-13.md'
with evidence.open('a',encoding='utf-8') as f:
    f.write('\n## Aceite e fechamento\n\nEm 2026-10-13 o dono respondeu exatamente **“'+REPLY+'”**. Aceite de AO04/AO07 v02 e exceção limitada de 14/13 px registrados no [recibo](../generated/hero-spread-review-2026-10-13/visual-acceptance.json). O limite global de 12 px e as medidas/falhas originais continuam explícitos; conteúdo DRAFT, nenhuma promoção CANON. Plano 3/3 concluído.\n\n[Inventário atualizado](../generated/hero-spread-review-2026-10-13/accepted-hero-inventory.json): quatorze tiras/76 quadros. Restam AO09/AO10/ER03/ER06. Inventário histórico 12/64 e recibos anteriores preservados por hash; fontes, atlas e doze células reconferidos. Galeria atualizada com aceite e links dos dois novos registros, sem afirmar execução no navegador. Nenhuma admissão, raster novo, alteração de runtime ou operação Git. Próximo objetivo: avaliar os corredores de AO09/AO10 e preparar decisão concreta para ER03/ER06 antes da admissão; novas alterações ainda não autorizadas por este recibo.\n')
spec=ROOT/'.atena/specs/SPEC-121-retomada-fila-imagens/hero-spread-exception-v01.md'
with spec.open('a',encoding='utf-8') as f:
    f.write('\n## Resultado do checkpoint\n\n2026-10-13: **“'+REPLY+'”**. S-002 aprovada explicitamente; S-003 concluída após reconferir hashes e registrar recibo/inventário 14/76. Plano 3/3 concluído, exceção limitada aos hashes de AO04/AO07 v02. Sem alteração do critério global, PNG, runtime, CANON ou Git. Os textos de pendência acima descrevem a proposta antes deste aceite; o registro atual está no [estado](../../state/hero-spread-exception.yaml).\n')
backlog=ROOT/'.atena/backlog/ARTE.md'
text=backlog.read_text(encoding='utf-8')
lines=text.splitlines(keepends=True)
found=0
for i,line in enumerate(lines):
    if line.startswith('| ART-045 |'):
        assert line.rstrip().endswith('|')
        lines[i]=line.rstrip()[:-1]+' **2026-10-13:** AO04/AO07 v02 visualmente aceitas DRAFT com exceção restrita de 14/13 px; limite global 12 px mantido. [Registro atual](../evidence/hero-spread-review-2026-10-13.md). Total atual: quatorze tiras/76 quadros; pendentes AO09/AO10/ER03/ER06, sem admissão. |\n'
        found+=1
assert found==1
backlog.write_text(''.join(lines),encoding='utf-8')
text=state.read_text(encoding='utf-8')
text+='  visual_acceptance_receipt: .atena/generated/hero-spread-review-2026-10-13/visual-acceptance.json\n  accepted_hero_inventory: .atena/generated/hero-spread-review-2026-10-13/accepted-hero-inventory.json\n  accepted_total_strips: 14\n  accepted_total_frames: 76\n  remaining_animation_strips: [AO09, AO10, ER03, ER06]\n'
state.write_text(text,encoding='utf-8')
set_state(3,'S-003/TWO_V02_ACCEPTED_WITH_LIMITED_EXCEPTION','COMPLETED_VISUALLY_ACCEPTED_DRAFT_WITH_EXCEPTION')
for p,h in hashes.items(): assert sha(ROOT/p)==h,p
assert anchor+operational.read_text(encoding='utf-8').split(anchor,1)[1]==prior_tail
for e in new_inventory['selected']:
    assert sha(ROOT/e['path'])==e['sha256'],e['code']
    assert (ROOT/e['receipt']).is_file(),e['receipt']
assert subprocess.check_output(['git','rev-parse','HEAD'],cwd=ROOT).decode().strip()==review['head']
assert not subprocess.check_output(['git','diff','--cached','--name-only'],cwd=ROOT).strip()
for p in [evidence,spec]:
    for link in re.findall(r'\]\(([^)]+)\)',p.read_text(encoding='utf-8')): assert (p.parent/link).is_file(),link
write(OUT/'acceptance-verification.json',dict(status='PASS_WITH_EXPLICIT_LIMITED_SPREAD_EXCEPTION',steps_completed=3,steps_total=3,accepted_strips=14,accepted_frames=76,remaining=['AO09','AO10','ER03','ER06'],historical_hashes_preserved=hashes,prior_state_tail_sha256=hashlib.sha256(prior_tail.encode()).hexdigest(),prior_state_tail_preserved=True,global_spread_limit_px=12,runtime_admission=False,canonical_promotion=False,git_mutations=False))
print('Acceptance closure PASS: 3/3; 14 exact accepted DRAFT strips/76 frames, original criterion12 and limited14/13 exceptions explicit; four remaining; historical hashes/state tail/HEAD/index preserved. Zero raster, admission, CANON or Git mutations.')
