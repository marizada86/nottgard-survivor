"""Record six exact owner-approved visual revisions, keeping DRAFT and runtime intact."""
import hashlib
from html.parser import HTMLParser
import json
from pathlib import Path
import re

OUT = Path(__file__).resolve().parent
ROOT = OUT.parents[2]
REPLY = 'Aprovo visualmente as seis revisões'
STATUS = 'COMPLETED_VISUALLY_ACCEPTED_DRAFT'
CHECKPOINT = 'S-005/OWNER_VISUAL_ACCEPTANCE_RECORDED'
NEXT = 'Preparar plano futuro dos pontos restantes ART-032, mantendo as dez fontes aceitas; geração ainda depende de escopo aprovado'

def load(name):
    return json.loads((OUT/name).read_text(encoding='utf-8'))

def save(name,value):
    (OUT/name).write_text(json.dumps(value,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')

def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()

jobs = load('jobs.json')
assert [(j['code'],j['revision']) for j in jobs['jobs']] == [('NP04','v02'),('NP05','v01'),('NP06','v02'),('NP07','v01'),('NP08','v01'),('NP09','v01')]
assert jobs['approval']=='APPROVED_PER_PLAN' and jobs['state']=='DRAFT'
rootpath = ROOT/'.atena/state/plan.yaml'
rootbefore = rootpath.read_text(encoding='utf-8')
prefix, protected_tail = rootbefore.split('art032_npcs_piloto_2026_10_11:',1)
for path,expected in load('protected-snapshot.json').items():
    actual = hashlib.sha256(rootbefore.split('active_plan:',1)[1].encode()).hexdigest() if '#active_plan_tail' in path else sha(ROOT/path)
    assert actual==expected,path
for job in jobs['jobs']+jobs.get('previous_native_versions',[]):
    assert sha(ROOT/job['destination'])==job['sha256']==sha(Path(job['original_path']))
prior_receipt = json.loads((ROOT/'.atena/generated/art032-npcs-2026-10-11/visual-acceptance.json').read_text(encoding='utf-8'))
for accepted in prior_receipt['accepted']:
    assert sha(ROOT/accepted['path'])==accepted['sha256']
receipt = {'plan':jobs['plan'],'revision':'v01','step':'S-005','date':'2026-10-11','owner_reply':REPLY,'authority':'EXPLICIT_HUMAN_REPLY_TO_EXACT_SIX_REVISION_VISUAL_GATE','status':'APPROVED_EXPLICITLY','content_state':'DRAFT','accepted':[{'code':j['code'],'title':j['title'],'revision':j['revision'],'path':j['destination'],'sha256':j['sha256']} for j in jobs['jobs']],'reviewed_scope':'Proposed physiques/costume, distinction of Radiant Sisters, six actors at 80px and Grazzt at 128px; five native border alpha 1/255 notes disclosed in approved question.','canonical_promotion':False,'runtime_admission':False,'normalization_execution':False,'commit_push_build':False,'historical_NP04_NP06_v01_accepted':False,'next_execution_authorized':False}
save('visual-acceptance.json',receipt)
jobs.update({'status':STATUS,'current_step':CHECKPOINT,'current_step_position':5,'completed_steps':5,'owner_visual_acceptance':'APPROVED_EXPLICITLY','visual_acceptance_receipt':'visual-acceptance.json','visual_owner_reply':REPLY})
for job in jobs['jobs']:
    job.update({'status':'VISUALLY_ACCEPTED_DRAFT_NOT_ADMITTED','human_visual_acceptance':'APPROVED_EXPLICITLY'})
    job['audit']['human_visual_acceptance']='APPROVED_EXPLICITLY'
for step in jobs['step_results']:
    if step['step']=='S-005':
        step.update({'status':'COMPLETED','result':'Owner explicitly accepted NP04 v02, NP05 v01, NP06 v02, NP07 v01, NP08 v01 and NP09 v01. All remain DRAFT; no admission/canonical promotion.'})
save('jobs.json',jobs)
audit=load('audit.json')
audit.update({'human_visual_acceptance':'APPROVED_EXPLICITLY','visual_acceptance_receipt':'visual-acceptance.json'})
for record in audit['records']:
    if record['recommended_for_owner_review']:
        record['human_visual_acceptance']='APPROVED_EXPLICITLY'
save('audit.json',audit)
qa=load('gallery-qa.json')
qa.update({'human_visual_acceptance':'APPROVED_EXPLICITLY','visual_acceptance_receipt':'visual-acceptance.json'})
save('gallery-qa.json',qa)

def update_yaml(text,indent=''):
    for key,value in {'status':STATUS,'checkpoint':CHECKPOINT,'completed_steps':'5','human_visual_acceptance':'APPROVED_EXPLICITLY','next_objective':"'"+NEXT+"'"}.items():
        text,count=re.subn(r'^'+indent+key+r':.*$',indent+key+': '+value,text,flags=re.M)
        assert count==1,key
    return text

statepath=ROOT/'.atena/state/art032-npcs-lote02.yaml'
state=update_yaml(statepath.read_text(encoding='utf-8'))
state=state.replace('completed_ordered_steps: [S-001, S-002, S-003, S-004]','completed_ordered_steps: [S-001, S-002, S-003, S-004, S-005]')
if 'visual_owner_reply:' not in state:
    state+='visual_owner_reply: "'+REPLY+'"\nvisual_accepted_revisions: [NP04_v02, NP05_v01, NP06_v02, NP07_v01, NP08_v01, NP09_v01]\nvisual_acceptance_receipt: .atena/generated/art032-npcs-lote02-2026-10-11/visual-acceptance.json\nnext_execution_authorized: false\n'
statepath.write_text(state,encoding='utf-8')
prefix=update_yaml(prefix,'  ')
if '  visual_owner_reply:' not in prefix:
    prefix+='  visual_owner_reply: "'+REPLY+'"\n  visual_acceptance_receipt: .atena/generated/art032-npcs-lote02-2026-10-11/visual-acceptance.json\n  next_execution_authorized: false\n'
rootpath.write_text(prefix+'art032_npcs_piloto_2026_10_11:'+protected_tail,encoding='utf-8')
assert rootpath.read_text(encoding='utf-8').split('art032_npcs_piloto_2026_10_11:',1)[1]==protected_tail
planpath=ROOT/'.atena/vault/drafts/PLAN-ART032-NPCS-LOTE02-v01.md'
plan=planpath.read_text(encoding='utf-8').replace('status: GENERATED_AUDITED_WAITING_VISUAL_APPROVAL','status: '+STATUS)
plan=plan.replace('Concluído: papéis, referências, hipóteses e seis prompts preparados; escopo aguarda G0.','Concluído: papéis/referências/prompts preparados; G0 aprovado antes da produção.')
plan=plan.replace('Após G0: seis fontes DRAFT rastreáveis, na ordem da tabela; preservar todas as saídas nativas e versões.','Concluído: seis candidatas em oito saídas nativas; NP04/NP06 v02 corrigidos, histórico preservado.')
plan=plan.replace('Aceite humano identificado das seis revisões ou ajustes por código. Produção não implica aceite visual/CANON/admissão.','Concluído: dono respondeu “'+REPLY+'” para NP04/NP06 v02 e NP05/NP07–NP09 v01; DRAFT, sem CANON/admissão.')
if '## Fechamento S-005' not in plan:
    plan+='\n## Fechamento S-005 — 2026-10-11\n\n**5/5 passos concluídos.** Aceite explícito “'+REPLY+'” para **NP04 Nyxara v02, NP05 Vaelis v01, NP06 Graz’zt v02, NP07 Reaper v01, NP08 Vhaerith v01 e NP09 mercador v01**. [Recibo com hashes](../../generated/art032-npcs-lote02-2026-10-11/visual-acceptance.json). Aparências/adornos permanecem DRAFT; não houve promoção a CANON, normalização/admissão, integração, commit, push ou build. Histórico v01 NP04/NP06 não aceito. Texto de entrega anterior registra o estado antes desta decisão.\n\nPróximo objetivo preparado: novo plano para os pontos restantes ART-032 (trono de Zuggtmoy, arco de pedra, massa de Thullgrime, Coração de Limo, esporo e limo); arte própria da Manifestação de Juiblex permanece pendente específica. Inputs futuros: vault, contexto SPEC-118, bíblia de props e as dez fontes já aceitas. Saída futura: escopo/prompts DRAFT limitados, referências/hashes, checks de alfa/leitura e gate visual próprios. Ainda não há escopo executivo aprovado para essas peças; este aceite fecha apenas o lote 02.\n'
planpath.write_text(plan,encoding='utf-8')
evidencepath=ROOT/'.atena/evidence/art032-npcs-lote02-delivery-2026-10-11.md'
evidence=evidencepath.read_text(encoding='utf-8')
if '## Aceite visual registrado' not in evidence:
    evidence+='\n## Aceite visual registrado — 2026-10-11\n\nO dono respondeu **“'+REPLY+'”** à pergunta que identificava **NP04 v02, NP05 v01, NP06 v02, NP07 v01, NP08 v01 e NP09 v01**, com propostas físicas/figurinos, diferença das Irmãs, leitura 80/128px e alfa residual 1/255 em cinco fontes. [Recibo exato com hashes](../generated/art032-npcs-lote02-2026-10-11/visual-acceptance.json). **S-005 concluído; 5/5, zero passos restantes.** Seções anteriores preservam o histórico antes do aceite; o fechamento presente é o estado atual. Todas as seis revisões seguem DRAFT; versões históricas NP04/NP06 v01 não foram aceitas. Sem CANON, normalização/admissão, integração, commit, push ou build. Aceite visual não é playtest ou avaliação nos mapas. Registro/estado/jobs/auditoria/QA/galeria/backlog reconciliados; fontes nativas, piloto anterior e cadeia PLAN-071 protegidos. Próxima frente preparada é o plano dos pontos restantes ART-032, com prontidão/escopo ainda por definir e aprovar.\n'
evidencepath.write_text(evidence,encoding='utf-8')
backlogpath=ROOT/'.atena/backlog/ARTE.md'
backlog=backlogpath.read_text(encoding='utf-8').replace('NP04/NP06 v02 e NP05/NP07–NP09 v01 DRAFT gerados/auditados, 4/5, gate visual S-005 pendente','NP04/NP06 v02 e NP05/NP07–NP09 v01 DRAFT gerados, auditados e visualmente aceitos, lote 5/5 concluído; pontos restantes/admissão abertos')
backlogpath.write_text(backlog,encoding='utf-8')
pagepath=OUT/'index.html'
page=pagepath.read_text(encoding='utf-8').replace('Seis peças DRAFT, revisão visual S-005 pendente.','Seis peças DRAFT visualmente aprovadas — S-005 concluído (5/5).')
if 'visual-acceptance.json' not in page:
    page=page.replace('<p>Candidatas:','<p>O dono respondeu “'+REPLY+'”. <a href="visual-acceptance.json">Recibo das seis revisões/hashes</a>. As fontes continuam DRAFT.</p><p>Candidatas:')
pagepath.write_text(page,encoding='utf-8')
class Parser(HTMLParser):
    def handle_starttag(self,tag,attrs):
        for key,value in attrs:
            if key in ['src','href','data-source']:assert (OUT/value).is_file(),value
Parser().feed(page)
for doc in [planpath,evidencepath]:
    for target in re.findall(r'\]\(([^)]+)\)',doc.read_text(encoding='utf-8')):assert (doc.parent/target).is_file(),(doc,target)
for job in jobs['jobs']:assert sha(ROOT/job['destination'])==job['sha256']
print('Six exact visual acceptances recorded; LOTE02 5/5 complete; ten total accepted DRAFT sources. Native/runtime/PLAN071 hashes and links PASS; no admission/commit/push.')
