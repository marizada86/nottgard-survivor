"""Close the pending MJ01 v03 visual checkpoint; preserve source bytes and DRAFT."""
from pathlib import Path
from html.parser import HTMLParser
import hashlib
import json
import re
import subprocess
OUT=Path(__file__).resolve().parent
ROOT=OUT.parents[2]
REPLY='Aprovo visualmente MJ01 v03'
DATE='2026-10-12'
STATUS='COMPLETED_VISUALLY_ACCEPTED_DRAFT'
CHECKPOINT='S-005/OWNER_VISUAL_ACCEPTANCE_RECORDED'
NEXT='Preparar plano futuro de preparação/admissão das dezessete fontes aceitas ART-032; execução ainda requer escopo aprovado'
def load(name):return json.loads((OUT/name).read_text(encoding='utf-8'))
def save(name,data):(OUT/name).write_text(json.dumps(data,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
jobs=load('jobs.json')
assert jobs['approval']=='APPROVED_PER_PLAN' and jobs['content_state']=='DRAFT'
assert [(j['code'],j['revision']) for j in jobs['jobs']]==[('MJ01','v03')]
assert jobs['current_step']=='S-005/OWNER_VISUAL_ACCEPTANCE' and jobs['completed_steps']==4
assert not (OUT/'visual-acceptance.json').exists(), 'Do not overwrite acceptance'
head_before=subprocess.check_output(['git','rev-parse','HEAD'],cwd=ROOT)
index_before=subprocess.check_output(['git','diff','--cached','--name-only'],cwd=ROOT)
rootpath=ROOT/'.atena/state/plan.yaml'
rootbefore=rootpath.read_text(encoding='utf-8')
prefix,protected_tail=rootbefore.split('art032_pontos_2026_10_11:',1)
snapshot=load('protected-snapshot.json')
def verify():
    for path,expected in snapshot.items():
        actual=hashlib.sha256(rootpath.read_text(encoding='utf-8').split('active_plan:',1)[1].encode()).hexdigest() if '#active_plan_tail' in path else sha(ROOT/path)
        assert actual==expected,path
    for j in jobs['jobs']+jobs.get('previous_native_versions',[]):
        assert sha(ROOT/j['destination'])==j['sha256']==sha(Path(j['original_path']))
    for r in jobs['sources']+jobs['style_references']+jobs['comparison_references']:
        p=Path(r['path']);assert sha(p if p.is_absolute() else ROOT/p)==r['sha256']
verify()
j=jobs['jobs'][0]
receipt={'plan':jobs['plan'],'revision':'v01','step':'S-005','date':DATE,'request_classification':'IN_PLAN','owner_reply':REPLY,'authority':'EXPLICIT_HUMAN_REPLY_TO_EXACT_MJ01_V03_VISUAL_GATE','status':'APPROVED_EXPLICITLY','content_state':'DRAFT','accepted':[{'code':j['code'],'title':j['title'],'revision':j['revision'],'path':j['destination'],'sha256':j['sha256']}],'reviewed_scope':'Asymmetric body, broad base, three extensions, style/material and reading at 80/128px compared with the receptacle and dormant mass; minimum margin 18.26% and transparent native border disclosed.','historical_v01_v02_accepted':False,'canonical_promotion':False,'runtime_admission':False,'normalization_execution':False,'commit_push_build':False,'next_execution_authorized':False}
save('visual-acceptance.json',receipt)
jobs.update({'status':STATUS,'current_step':CHECKPOINT,'current_step_position':5,'completed_steps':5,'remaining_steps_after_current':0,'owner_visual_acceptance':'APPROVED_EXPLICITLY','human_visual_acceptance':'APPROVED_EXPLICITLY','visual_acceptance_receipt':'visual-acceptance.json','visual_owner_reply':REPLY,'visual_accepted_date':DATE,'last_request_classification':'IN_PLAN','next_objective':NEXT,'next_execution_authorized':False})
j.update({'status':'VISUALLY_ACCEPTED_DRAFT_NOT_ADMITTED','human_visual_acceptance':'APPROVED_EXPLICITLY'})
j['audit']['human_visual_acceptance']='APPROVED_EXPLICITLY'
save('jobs.json',jobs)
audit=load('audit.json')
audit.update({'human_visual_acceptance':'APPROVED_EXPLICITLY','visual_acceptance_receipt':'visual-acceptance.json'})
for r in audit['records']:
    if r['recommended_for_owner_review']:r['human_visual_acceptance']='APPROVED_EXPLICITLY'
save('audit.json',audit)
qa=load('gallery-qa.json')
assert sha(OUT/qa['reading_image'])==qa['reading_image_sha256']
qa.update({'human_visual_acceptance':'APPROVED_EXPLICITLY','visual_acceptance_receipt':'visual-acceptance.json','reading_sheet_delivery_state':'HISTORICAL_PRE_ACCEPTANCE_REVIEW_SHEET_UNCHANGED'})
save('gallery-qa.json',qa)
def update(text,indent=''):
    fields={'status':STATUS,'checkpoint':CHECKPOINT,'completed_steps':'5','human_visual_acceptance':'APPROVED_EXPLICITLY','next_objective':json.dumps(NEXT,ensure_ascii=False),'next_execution_authorized':'false','visual_owner_reply':json.dumps(REPLY,ensure_ascii=False),'visual_accepted_date':'"'+DATE+'"','visual_acceptance_receipt':'.atena/generated/art032-juiblex-2026-10-12/visual-acceptance.json','last_request_classification':'IN_PLAN'}
    for key,value in fields.items():
        pattern=r'^'+indent+key+r':.*$'
        text,count=re.subn(pattern,indent+key+': '+value,text,flags=re.M)
        assert count<=1,key
        if not count:text+=indent+key+': '+value+'\n'
    return text
statepath=ROOT/'.atena/state/art032-juiblex.yaml'
state=update(statepath.read_text(encoding='utf-8')).replace('completed_ordered_steps: [S-001, S-002, S-003, S-004]','completed_ordered_steps: [S-001, S-002, S-003, S-004, S-005]')
statepath.write_text(state,encoding='utf-8')
rootpath.write_text(update(prefix,'  ')+'art032_pontos_2026_10_11:'+protected_tail,encoding='utf-8')
assert rootpath.read_text(encoding='utf-8').split('art032_pontos_2026_10_11:',1)[1]==protected_tail
planpath=ROOT/'.atena/vault/drafts/PLAN-ART032-JUIBLEX-v01.md'
plan=planpath.read_text(encoding='utf-8').replace('status: DELIVERED_DRAFT_OWNER_VISUAL_REVIEW_PENDING','status: '+STATUS,1)
plan+='''
## Fechamento S-005 — 2026-10-12

**5/5 passos concluídos; zero passos restantes.** Resposta explícita **“Aprovo visualmente MJ01 v03”** ao gate identificado da candidata e comparação 80/128px. Classificação desta decisão **IN_PLAN**. Aceite exclusivo de **MJ01 Manifestação de Juiblex v03**, com silhueta/base/três extensões/material e margem/borda apresentados; geometrias continuam hipóteses DRAFT. [Recibo por revisão/hash](../../generated/art032-juiblex-2026-10-12/visual-acceptance.json). v01/v02 históricos não foram aceitos. Fontes e prancha de entrega permanecem intactas; esta última conserva a indicação histórica pré-aceite.

ART-032 tem agora **dezessete fontes selecionadas DRAFT visualmente aceitas** nos quatro planos, em vinte e sete originais preservados. Admissão/runtime, animações, contraste em bioma e demais conteúdos adiados não estão concluídos. Não houve CANON, normalização, integração, novo commit, push ou build. Registros/estado/jobs/auditoria/QA/galeria/backlog reconciliados; fontes/referências/recibos anteriores/runtime/cauda PLAN-071 conferidos por hash, Git preservado.

Próximo objetivo preparado: **plano futuro de preparação/admissão ART-032**, com as dezessete revisões e quatro recibos, identidade/contexto/bíblia, contrato de tamanho/pivô/transparência e pontos de consumo SPEC-118/renderer como inputs. Saída futura: escopo e destinos limitados, transformação determinística preservando originais, auditoria/galeria e gates de admissão/integração próprios. Nenhuma execução desse próximo plano é autorizada pelo aceite visual. Textos anteriores mantêm o histórico de preparação/produção/entrega.
'''
planpath.write_text(plan,encoding='utf-8')
evidencepath=ROOT/'.atena/evidence/art032-juiblex-delivery-2026-10-12.md'
evidence=evidencepath.read_text(encoding='utf-8')
evidence+='''
## Aceite visual registrado — 2026-10-12

O dono respondeu **“Aprovo visualmente MJ01 v03”** ao checkpoint S-005 da forma assimétrica/base/três extensões/material e leitura 80/128px, comparada com receptáculo/PT04, margem mínima 18,26% e borda transparente. [Recibo exato com hash](../generated/art032-juiblex-2026-10-12/visual-acceptance.json). **5/5 concluído; zero passos restantes.** MJ01 v03 DRAFT visualmente aceita; v01/v02 históricos preservados e não aceitos. Total ART-032: dezessete selecionadas aceitas nos quatro lotes; vinte e sete fontes nativas históricas.

Fontes/copias/refs/recibos, runtime/ativos, prancha e cauda PLAN-071 verificados e preservados. Artefatos/estado/galeria/backlog reconciliados; Git HEAD/índice sem alteração. Sem CANON, normalização/admissão, integração, commit, push, build ou playtest. Prancha/seções anteriores registram a entrega antes do aceite. Próximo objetivo é preparar plano de preparação/admissão das dezessete fontes com quatro recibos e contexto/contratos; nova execução requer escopo aprovado.
'''
evidencepath.write_text(evidence,encoding='utf-8')
backlogpath=ROOT/'.atena/backlog/ARTE.md'
backlog=backlogpath.read_text(encoding='utf-8')
old='MJ01 Manifestação de Juiblex v03 DRAFT gerada/auditada, 4/5, aceite visual S-005 pendente;'
new='MJ01 Manifestação de Juiblex v03 DRAFT gerada/auditada e visualmente aceita em 2026-10-12; 5/5 concluído, dezessete fontes selecionadas aceitas ART-032;'
assert backlog.count(old)==1
backlog=backlog.replace(old,new).replace('Manifestação de Juiblex/admissão ainda abertas.','Manifestação coberta pelo lote MJ01 abaixo; preparação/admissão ainda abertas.')
backlogpath.write_text(backlog,encoding='utf-8')
pagepath=OUT/'index.html'
page=pagepath.read_text(encoding='utf-8')
old='MJ01 v03 DRAFT — revisão visual S-005 pendente.'
assert page.count(old)==1
page=page.replace(old,'MJ01 v03 DRAFT visualmente aprovada — S-005 concluído (5/5).')
page=page.replace('<p>Fonte nativa','<p>O dono respondeu “Aprovo visualmente MJ01 v03” em 2026-10-12. <a href="visual-acceptance.json">Recibo por revisão/hash</a>. A fonte continua DRAFT; a prancha preserva o estado histórico de entrega antes do aceite.</p><p>Fonte nativa',1)
page=page.replace('Candidata DRAFT — aceite pendente','Candidata DRAFT visualmente aceita',1)
pagepath.write_text(page,encoding='utf-8')
class Links(HTMLParser):
    def handle_starttag(self,tag,attrs):
        for key,value in attrs:
            if key in ['src','href','data-source']:assert (OUT/value).resolve().is_file(),value
Links().feed(page)
for path in [planpath,evidencepath]:
    for target in re.findall(r'\]\(([^)]+)\)',path.read_text(encoding='utf-8')):assert (path.parent/target).resolve().is_file(),target
verify()
assert subprocess.check_output(['git','rev-parse','HEAD'],cwd=ROOT)==head_before
assert subprocess.check_output(['git','diff','--cached','--name-only'],cwd=ROOT)==index_before
verification={'plan':jobs['plan'],'revision':'v01','date':DATE,'status':'PASS_VISUAL_ACCEPTANCE_RECORDED','completed_steps':5,'total_steps':5,'current_step':CHECKPOINT,'accepted_revision':'MJ01_v03','accepted_sha256':j['sha256'],'accepted_draft_total_art032':17,'native_sources_in_lot':3,'native_sources_total_art032':27,'receipt':'visual-acceptance.json','source_reference_comparison_runtime_and_plan071_hashes':'PASS_UNCHANGED','links_and_state':'PASS','human_visual_acceptance':'APPROVED_EXPLICITLY','content_state':'DRAFT','canonical_promotion':False,'runtime_admission':False,'new_commit_push_build':False,'git_head_and_index':'UNCHANGED','next_execution_authorized':False}
save('acceptance-verification.json',verification)
print('S-005 PASS: MJ01 v03 accepted; 5/5 complete; seventeen accepted DRAFT sources ART-032. Native/reference/prior receipts/runtime/PLAN071 hashes and links verified; Git unchanged.')
