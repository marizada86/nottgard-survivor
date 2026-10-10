from pathlib import Path
import json,hashlib,re,shutil
root=Path.cwd();base=root/'.atena/generated/erik-arlindo-complete-2026-10-09';receipt=base/'restore-first-generations-2026-10-10';receipt.mkdir(exist_ok=True)
jobs_path=base/'jobs.json';data=json.loads(jobs_path.read_text(encoding='utf-8-sig'))
snapshot=receipt/'jobs-before.json';assert not snapshot.exists(),'Restoration already recorded'
snapshot.write_bytes(jobs_path.read_bytes())
for name in ['index.html','review-audit.json']:
    if (base/name).exists():shutil.copyfile(base/name,receipt/(name+'.before'))
changes=[]
for job in data['jobs']:
    current=dict(job);variants=job.get('rejected_versions',[])+[job]
    first=min(variants,key=lambda x:int(re.search(r'-v(\d+)\.png$',x['destination'])[1]))
    path=root/first['destination'];assert path.exists(),path
    sha=hashlib.sha256(path.read_bytes()).hexdigest();assert sha==first['sha256'],job['code']
    restored={k:v for k,v in first.items() if k not in ['rejected_versions','controlled_gait_candidate','controlled_layer_candidate']}
    restored['status']='DRAFT_OWNER_SELECTED_FIRST_GENERATION'
    restored['selection']={'active':True,'owner_request':'desisto volte para as primeiras tiragens geradas','date':'2026-10-10','classification':'IN_PLAN_RECOVERY','gait_correction':'CANCELLED_BY_OWNER','runtime_admission':False}
    restored['preserved_variants']=[{k:v for k,v in x.items() if k not in ['rejected_versions','preserved_variants']} for x in variants if x['destination']!=first['destination']]
    changes.append({'code':job['code'],'before':current['destination'],'selected':first['destination'],'sha256':sha,'original_unchanged':True})
    job.clear();job.update(restored)
jobs_path.write_text(json.dumps(data,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
queue=root/'.atena/generated/CHATGPT-FILA-027-erik-e-arlindo.md';text=queue.read_text(encoding='utf-8-sig')
for item in changes:
    before=Path(item['before']).name;after=Path(item['selected']).name;text=text.replace(before,after)
text+='\n## Seleção restaurada pelo dono — 2026-10-10\n\nPedido: “desisto volte para as primeiras tiragens geradas”. As16 tiras ER03–ER10 e AO03–AO10 voltaram para v01. Retratos e idle previamente selecionados preservados (ER02 permanece v02 aprovado). Pilotos, guias e correções por camadas deixam de ser a seleção ativa; arquivos mantidos como histórico. Correção da caminhada cancelada. [Galeria das tiragens originais](erik-arlindo-complete-2026-10-09/index.html). Runtime não alterado.\n'
queue.write_text(text,encoding='utf-8')
for name in ['plan.yaml','plan-053-imagens.yaml','dev-024-art045-pilots.yaml']:
    path=root/'.atena/state'/name;s=path.read_text(encoding='utf-8-sig')
    s=s.replace('DEV-024/GAIT-REFERENCE/REVIEW-10','DEV-024/ORIGINAL-GENERATIONS/RESTORED').replace('GAIT-REFERENCE/REVIEW-10','ORIGINAL-GENERATIONS/RESTORED').replace('checkpoint: REVIEW-10','checkpoint: ORIGINAL-GENERATIONS/RESTORED')
    if name=='plan.yaml':
        s=s.replace("next: 'Revisar galeria20 Erik/Arlindo e galeria60 VFX; corrigir alertas e normalizar grade/pivo antes da admissao.'","next: 'Primeiras tiragens Erik/Arlindo selecionadas pelo dono; correcao de gait cancelada. Revisao geral e admissao runtime permanecem separadas.'")
    if name=='dev-024-art045-pilots.yaml':
        s=s.replace('  human_art_review_pending: 8','  human_art_review_pending: 0 # nove derivados descartados da selecao pelo dono').replace('  texture_refinement_required: AO03','  texture_refinement_required: CANCELLED_BY_OWNER')
        s+='\nowner_restore_first_generations:\n  status: COMPLETED_LOCAL\n  request_classification: IN_PLAN_RECOVERY\n  owner_request: "desisto volte para as primeiras tiragens geradas"\n  gait_correction: CANCELLED_BY_OWNER\n  selected: FIRST_GENERATIONS_V01\n  approved_idle_preserved: ER02_V02\n  discarded_variants: PRESERVED_HISTORY_ONLY\n  gallery: .atena/generated/erik-arlindo-complete-2026-10-09/index.html\n  receipt: .atena/generated/erik-arlindo-complete-2026-10-09/restore-first-generations-2026-10-10/receipt.json\n  runtime_admission: false\n'
    path.write_text(s,encoding='utf-8')
historical=root/'.atena/generated/erik-gait-reference-production/index.html'
if historical.exists():
    s=historical.read_text(encoding='utf-8');s=s.replace('<header>','<header><p><strong>Histórico: correções descartadas da seleção pelo dono em 2026-10-10.</strong> <a href="../erik-arlindo-complete-2026-10-09/index.html">Ver tiragens originais selecionadas</a></p>',1);historical.write_text(s,encoding='utf-8')
(receipt/'receipt.json').write_text(json.dumps({'date':'2026-10-10','owner_request':'desisto volte para as primeiras tiragens geradas','classification':'IN_PLAN_RECOVERY','status':'RESTORED','selection_scope':'ER03-ER10 and AO03-AO10 earliest v01; previously selected portraits and approved idle preserved','changes':changes,'gait_work':'CANCELLED_BY_OWNER','later_files':'PRESERVED_HISTORY_ONLY','runtime_changes':False,'commit_push':False},ensure_ascii=False,indent=2),encoding='utf-8')
(root/'.atena/evidence/hero-first-generations-restored-2026-10-10.md').write_text('# Restauração das primeiras tiragens\n\nPedido explícito do dono: “desisto volte para as primeiras tiragens geradas”. Recuperação IN_PLAN: primeiras versões v01 das16 tiras selecionadas novamente. Retratos e idle aprovados preservados. Trabalho de correção de gait cancelado; versões posteriores deixam de ser seleção ativa e permanecem no disco. Históricos de aceites anteriores não foram apagados. Hashes dos16 arquivos selecionados confirmados contra os registros originais. Não houve alteração de runtime, commit, push ou exclusão de arquivos.\n\nRecibo: ../generated/erik-arlindo-complete-2026-10-09/restore-first-generations-2026-10-10/receipt.json\n',encoding='utf-8')
print(json.dumps({'selected_strips':len(changes),'earliest_versions':all('-v01.png' in x['selected'] for x in changes),'original_hashes_verified':True,'later_files_preserved':True}))
