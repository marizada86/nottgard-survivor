"""Reconcile explicit owner visual acceptance; never modifies image pixels."""
from pathlib import Path
import json, hashlib
base=Path(__file__).parent
root=base.parents[2]
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
audit=json.loads((base/'audit.json').read_text(encoding='utf-8'))
assert all(audit['checks'].values())
inputs=json.loads((base/'inputs.json').read_text(encoding='utf-8'))
assert all(sha(root/e['path'])==e['sha256'] for e in inputs['protected'])
sheet=base/'normalized/AL01_loop_v03.png'
assert sha(sheet)==audit['sheet_sha256']
entries=[dict(code='AL01',source_version='v02',derived_revision='AL01-CORR/v01',path=sheet.relative_to(root).as_posix(),sha256=sha(sheet),content_state='CANON_PREPARATION_VISUAL_ONLY',runtime_admission=False,cycle_ms=900)]
frames=[]
for r in audit['frames']:
    p=base/'frames'/f'AL01_loop_v03_f{r["frame"]}.png'
    assert sha(p)==r['sha256']
    frames.append(dict(frame=r['frame'],path=p.relative_to(root).as_posix(),sha256=sha(p),content_state='CANON_PREPARATION_VISUAL_ONLY'))
register=dict(revision='AL01-CORR/v01',owner_reply='Aprovo com ciclo de 900 ms',request_classification='IN_PLAN',content_state='CANON_PREPARATION_VISUAL_ONLY',cycle_ms=900,runtime_admission=False,entries=entries,frames=frames,previous_derivative_state='DRAFT_HELD_SUPERSEDED_FOR_PREPARATION',commit_push='NOT_AUTHORIZED')
(base/'approved-altar.json').write_text(json.dumps(register,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
old=json.loads((root/'.atena/generated/fila028-preparation-2026-10-10/approved-derivatives.json').read_text(encoding='utf-8'))
current=old['entries']+entries
assert len(current)==34 and len({e['code'] for e in current})==34
for e in current:assert sha(root/e['path'])==e['sha256']
current_register=dict(revision='FILA-028-CURRENT-PREPARATION/v01',accepted_count=34,runtime_admission=False,entries=current,acceptance_registers=['.atena/vault/canon/ASSET-APPROVAL-FILA028-PREPARATION-v01.md','.atena/vault/canon/ASSET-APPROVAL-FILA028-ALTAR-CORRECTION-v01.md'])
(root/'.atena/generated/fila028-acceptance-2026-10-10/approved-prepared-assets.json').write_text(json.dumps(current_register,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
page=(base/'index.html').read_text(encoding='utf-8')
page=page.replace('AL01-CORR/v01 · altar DRAFT','AL01-CORR/v01 · altar aceito').replace('AL01-CORR/v01 · candidata DRAFT','AL01-CORR/v01 · CANON de preparação')
page=page.replace('Revisão humana do ritmo e aparência pendente.','Aceite visual do dono registrado para ciclo de 900 ms.')
page=page.replace('Correção v01 / loop_v03 DRAFT','Correção v01 / loop_v03 CANON de preparação')
page=page.replace('Sem integração, commit ou push.','Preparação visual aceita. Sem integração, commit ou push.')
page=page.replace('Para aceitar: verificar conservação do altar/quatro velas, contornos nos três fundos, se a pulsação parece fogo e se a transição final→inicial é confortável. Escolher 600, 900 ou 1200 ms. Não há playtest do jogo nesta etapa.','Dono aprovou conservação do altar/quatro velas, contornos, pulsação e transição cíclica a 900 ms. 600/1200 ms continuam alternativas de inspeção; cadência aceita é 900 ms. Não houve playtest do jogo nesta etapa.')
if 'href="approved-altar.json"' not in page:page=page.replace('<h1>','<p><a href="approved-altar.json">Aceite visual, ciclo e hashes</a></p><h1>',1)
(base/'index.html').write_text(page,encoding='utf-8')
print('AL01 correction accepted at 900 ms; 34 current preparations CANON; source/image hashes verified.')
