"""Record explicit approval of the six pending point revisions; preserve DRAFT."""
from pathlib import Path
from html.parser import HTMLParser
import hashlib
import json
import re
import subprocess

OUT=Path(__file__).resolve().parent
ROOT=OUT.parents[2]
REPLY='atena, aprovado'
DATE='2026-10-12'
STATUS='COMPLETED_VISUALLY_ACCEPTED_DRAFT'
CHECKPOINT='S-005/OWNER_VISUAL_ACCEPTANCE_RECORDED'
NEXT='Preparar plano futuro da Manifestação de Juiblex ou preparação/admissão das dezesseis fontes aceitas ART-032; nova execução depende de escopo aprovado'
EXPECTED=[('PT02','v02'),('PT03','v02'),('PT04','v02'),('PT05','v01'),('PT06','v02'),('PT07','v02')]

def load(name): return json.loads((OUT/name).read_text(encoding='utf-8'))
def save(name,data): (OUT/name).write_text(json.dumps(data,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
def sha(path): return hashlib.sha256(path.read_bytes()).hexdigest()

jobs=load('jobs.json')
assert [(j['code'],j['revision']) for j in jobs['jobs']]==EXPECTED
assert jobs['approval']=='APPROVED_PER_PLAN' and jobs['content_state']=='DRAFT'
assert jobs['completed_steps']==4 and jobs['current_step']=='S-005/OWNER_VISUAL_ACCEPTANCE'
assert not (OUT/'visual-acceptance.json').exists(), 'Do not replace an acceptance receipt'
head_before=subprocess.check_output(['git','rev-parse','HEAD'],cwd=ROOT)
index_before=subprocess.check_output(['git','diff','--cached','--name-only'],cwd=ROOT)
rootpath=ROOT/'.atena/state/plan.yaml'
rootbefore=rootpath.read_text(encoding='utf-8')
prefix,protected_tail=rootbefore.split('art032_npcs_lote02_2026_10_11:',1)
snapshot=load('protected-snapshot.json')

def verify_protected():
    for path,expected in snapshot.items():
        actual=hashlib.sha256(rootpath.read_text(encoding='utf-8').split('active_plan:',1)[1].encode()).hexdigest() if '#active_plan_tail' in path else sha(ROOT/path)
        assert actual==expected,path
    for job in jobs['jobs']+jobs.get('previous_native_versions',[]):
        assert sha(ROOT/job['destination'])==job['sha256']==sha(Path(job['original_path']))
    for record in jobs['sources']+jobs['style_references']:
        path=Path(record['path'])
        assert sha(path if path.is_absolute() else ROOT/path)==record['sha256']

verify_protected()
receipt={'plan':jobs['plan'],'revision':'v01','step':'S-005','date':DATE,'owner_reply':REPLY,'authority':'EXPLICIT_HUMAN_APPROVAL_OF_PENDING_SIX_REVISION_VISUAL_GATE','status':'APPROVED_EXPLICITLY','content_state':'DRAFT','accepted':[{'code':j['code'],'title':j['title'],'revision':j['revision'],'path':j['destination'],'sha256':j['sha256']} for j in jobs['jobs']],'reviewed_scope':'Six proposed DRAFT geometries; props at 80/128px and collectibles at 48/80px; PT02/PT05 native border alpha 1/255 disclosed in pending visual question.','canonical_promotion':False,'runtime_admission':False,'normalization_execution':False,'commit_push_build':False,'historical_five_v01_versions_accepted':False,'next_execution_authorized':False}
save('visual-acceptance.json',receipt)
jobs.update({'status':STATUS,'current_step':CHECKPOINT,'current_step_position':5,'completed_steps':5,'remaining_steps_after_current':0,'owner_visual_acceptance':'APPROVED_EXPLICITLY','human_visual_acceptance':'APPROVED_EXPLICITLY','visual_acceptance_receipt':'visual-acceptance.json','visual_owner_reply':REPLY,'visual_accepted_date':DATE,'next_objective':NEXT,'next_execution_authorized':False})
for job in jobs['jobs']:
    job.update({'status':'VISUALLY_ACCEPTED_DRAFT_NOT_ADMITTED','human_visual_acceptance':'APPROVED_EXPLICITLY'})
    job['audit']['human_visual_acceptance']='APPROVED_EXPLICITLY'
save('jobs.json',jobs)
audit=load('audit.json')
audit.update({'human_visual_acceptance':'APPROVED_EXPLICITLY','visual_acceptance_receipt':'visual-acceptance.json'})
for record in audit['records']:
    if record['recommended_for_owner_review']: record['human_visual_acceptance']='APPROVED_EXPLICITLY'
save('audit.json',audit)
qa=load('gallery-qa.json')
assert sha(OUT/qa['reading_image'])==qa['reading_image_sha256']
qa.update({'human_visual_acceptance':'APPROVED_EXPLICITLY','visual_acceptance_receipt':'visual-acceptance.json','reading_sheet_delivery_state':'HISTORICAL_PRE_ACCEPTANCE_REVIEW_SHEET_UNCHANGED'})
save('gallery-qa.json',qa)

def update_yaml(text,indent=''):
    fields={'status':STATUS,'checkpoint':CHECKPOINT,'completed_steps':'5','human_visual_acceptance':'APPROVED_EXPLICITLY','next_objective':json.dumps(NEXT,ensure_ascii=False)}
    for key,value in fields.items():
        text,count=re.subn(r'^'+indent+key+r':.*$',indent+key+': '+value,text,flags=re.M)
        assert count==1,key
    text+=indent+'visual_owner_reply: '+json.dumps(REPLY,ensure_ascii=False)+'\n'+indent+'visual_accepted_date: "'+DATE+'"\n'+indent+'visual_acceptance_receipt: .atena/generated/art032-pontos-2026-10-11/visual-acceptance.json\n'+indent+'next_execution_authorized: false\n'
    return text

statepath=ROOT/'.atena/state/art032-pontos.yaml'
state=update_yaml(statepath.read_text(encoding='utf-8'))
state=state.replace('completed_ordered_steps: [S-001, S-002, S-003, S-004]','completed_ordered_steps: [S-001, S-002, S-003, S-004, S-005]')
statepath.write_text(state,encoding='utf-8')
prefix=update_yaml(prefix,'  ')
rootpath.write_text(prefix+'art032_npcs_lote02_2026_10_11:'+protected_tail,encoding='utf-8')
assert rootpath.read_text(encoding='utf-8').split('art032_npcs_lote02_2026_10_11:',1)[1]==protected_tail
planpath=ROOT/'.atena/vault/drafts/PLAN-ART032-PONTOS-v01.md'
plan=planpath.read_text(encoding='utf-8').replace('status: DELIVERED_DRAFT_OWNER_VISUAL_REVIEW_PENDING','status: '+STATUS,1)
plan+='''
## Fechamento S-005 — 2026-10-12

**5/5 passos concluídos; zero passos restantes.** O dono respondeu **“atena, aprovado”** ao checkpoint visual pendente das seis revisões: **PT02 trono de Zuggtmoy v02, PT03 arco de pedra v02, PT04 massa de Thullgrime v02, PT05 Coração de Limo v01, PT06 esporo de Zuggtmoy v02 e PT07 limo de Juiblex v02**. [Recibo por revisão/hash](../../generated/art032-pontos-2026-10-11/visual-acceptance.json). Leitura 80/128px nos props e 48/80px nos coletáveis, propostas geométricas DRAFT e nota de alfa residual 1/255 em PT02/PT05 estavam expostas no gate. Cinco fontes históricas v01 não foram aceitas. A prancha original registra a entrega antes do aceite e permanece intacta.

Todas as peças seguem **DRAFT visualmente aceitas**; nenhuma promoção a CANON, preparação/admissão, integração, novo commit, push ou build foi autorizada por esta resposta. Registros, estado, auditoria, galeria e backlog reconciliados; bytes das onze fontes, ativos/runtime, recibos/fontes anteriores e cadeia PLAN-071 preservados e verificados. Texto anterior mantém o histórico da produção/entrega.

Próximo objetivo preparado: plano futuro da arte própria da **Manifestação de Juiblex**, pendência específica ART-032, ou preparação/admissão das **dezesseis fontes DRAFT aceitas**. Inputs: lore/identidade de Juiblex, contexto SPEC-118, bíblia visual, arte do receptáculo para diferenciação e os três recibos de aceite existentes. Saída futura: escopo/prompts, prontidão e checks próprios, com gate visual posterior; execução do próximo plano ainda não aprovada. Este fechamento não altera o checkpoint preservado de PLAN-071.
'''
planpath.write_text(plan,encoding='utf-8')
evidencepath=ROOT/'.atena/evidence/art032-pontos-2026-10-11.md'
evidence=evidencepath.read_text(encoding='utf-8')
evidence+='''
## Aceite visual registrado — 2026-10-12

Resposta explícita **“atena, aprovado”** ao checkpoint S-005 pendente que identificava **PT02/PT03/PT04/PT06/PT07 v02 e PT05 v01**, geometrias DRAFT, leitura 80/128px e 48/80px e alfa residual 1/255 de trono/coração. [Recibo exato com hashes](../generated/art032-pontos-2026-10-11/visual-acceptance.json). **S-005 concluído, 5/5, zero passos restantes.** Total ART-032: dezesseis fontes selecionadas visualmente aceitas nos três lotes; esta entrega contém seis aceitas em onze originais preservados. Cinco v01 históricas não aceitas.

Todas permanecem DRAFT. Não houve CANON, normalização/admissão, integração, novo commit, push ou build. Aceite visual não é playtest nem validação sobre mapas. Estados/jobs/auditoria/QA/galeria/backlog atualizados; fontes nativas, referências, runtime/ativos e cauda PLAN-071 verificadas por hash; demais alterações locais preservadas. Prancha e evidência anterior conservam o histórico antes deste aceite. Próxima pendência específica: arte própria da Manifestação de Juiblex; produção/preparação/admissão futura requer novo plano aprovado.
'''
evidencepath.write_text(evidence,encoding='utf-8')
backlogpath=ROOT/'.atena/backlog/ARTE.md'
backlog=backlogpath.read_text(encoding='utf-8')
old='Pontos PT02/PT03/PT04/PT06/PT07 v02 e PT05 v01 DRAFT gerados/auditados; 4/5, aceite visual S-005 pendente;'
new='Pontos PT02/PT03/PT04/PT06/PT07 v02 e PT05 v01 DRAFT gerados/auditados e visualmente aceitos em 2026-10-12; 5/5 concluído, dezesseis fontes aceitas ART-032;'
assert backlog.count(old)==1
backlogpath.write_text(backlog.replace(old,new),encoding='utf-8')
pagepath=OUT/'index.html'
page=pagepath.read_text(encoding='utf-8')
old='Seis candidatas DRAFT — revisão visual S-005 pendente.'
assert page.count(old)==1
page=page.replace(old,'Seis peças DRAFT visualmente aprovadas — S-005 concluído (5/5).')
page=page.replace('<p>PT02 trono v02,','<p>O dono respondeu “atena, aprovado” em 2026-10-12. <a href="visual-acceptance.json">Recibo das seis revisões/hashes</a>. Geometrias continuam DRAFT. A prancha abaixo preserva o estado histórico de entrega antes do aceite.</p><p>PT02 trono v02,',1)
page=page.replace('Aceite por código/revisão.','Aceite por código/revisão registrado em S-005.',1)
pagepath.write_text(page,encoding='utf-8')
class Links(HTMLParser):
    def handle_starttag(self,tag,attrs):
        for key,value in attrs:
            if key in ['src','href','data-source']: assert (OUT/value).is_file(),value
Links().feed(page)
for path in [planpath,evidencepath]:
    for target in re.findall(r'\]\(([^)]+)\)',path.read_text(encoding='utf-8')): assert (path.parent/target).is_file(),(path,target)
verify_protected()
assert subprocess.check_output(['git','rev-parse','HEAD'],cwd=ROOT)==head_before
assert subprocess.check_output(['git','diff','--cached','--name-only'],cwd=ROOT)==index_before
verification={'plan':jobs['plan'],'revision':'v01','date':DATE,'status':'PASS_VISUAL_ACCEPTANCE_RECORDED','completed_steps':5,'total_steps':5,'current_step':CHECKPOINT,'accepted_revisions':[c+'_'+r for c,r in EXPECTED],'accepted_draft_total_art032':16,'native_sources_in_lot':11,'receipt':'visual-acceptance.json','source_reference_runtime_and_plan071_hashes':'PASS_UNCHANGED','links_and_state':'PASS','human_visual_acceptance':'APPROVED_EXPLICITLY','content_state':'DRAFT','canonical_promotion':False,'runtime_admission':False,'new_commit_push_build':False,'git_head_and_index':'UNCHANGED','next_execution_authorized':False}
save('acceptance-verification.json',verification)
print('S-005 PASS: six exact revisions accepted, 5/5 complete, sixteen accepted DRAFT sources ART-032. Native/runtime/previous lots/PLAN071 hashes and links verified; Git unchanged.')
