"""Record explicit G0 approval and verify readiness before built-in imagegen."""
import hashlib
import json
from pathlib import Path
import re
OUT=Path(__file__).resolve().parent
ROOT=OUT.parents[2]
REPLY='Aprovo MJ01 DRAFT'
data=json.loads((OUT/'jobs.json').read_text(encoding='utf-8'))
assert data['approval']=='PENDING_SCOPE_APPROVAL' and data['generated']==0
assert [(j['code'],j['revision']) for j in data['jobs']]==[('MJ01','v01')]
def sha(p): return hashlib.sha256(p.read_bytes()).hexdigest()
rootpath=ROOT/'.atena/state/plan.yaml'
before=rootpath.read_text(encoding='utf-8')
for p,expected in json.loads((OUT/'protected-snapshot.json').read_text(encoding='utf-8')).items():
    actual=hashlib.sha256(before.split('active_plan:',1)[1].encode()).hexdigest() if '#active_plan_tail' in p else sha(ROOT/p)
    assert actual==expected,p
for record in data['sources']+data['style_references']+data['comparison_references']:
    p=Path(record['path']); p=p if p.is_absolute() else ROOT/p
    assert sha(p)==record['sha256']
data.update({'approval':'APPROVED_PER_PLAN','owner_reply':REPLY,'approved_date':'2026-10-12','current_step':'S-002/PRODUCTION','status':'APPROVED_IN_PROGRESS','next_execution_authorized':True})
data['jobs'][0]['status']='PREPARED_AUTHORIZED'
(OUT/'jobs.json').write_text(json.dumps(data,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
def change(text,indent=''):
    for key,value in {'status':'APPROVED_IN_PROGRESS','approval_status':'APPROVED_EXPLICITLY','checkpoint':'S-002/PRODUCTION','next_execution_authorized':'true','next_objective':"'Gerar MJ01 DRAFT, auditar e apresentar comparação 80/128px para S-005'"}.items():
        text,count=re.subn(r'^'+indent+key+r':.*$',indent+key+': '+value,text,flags=re.M)
        assert count==1,key
    return text+indent+'scope_owner_reply: "'+REPLY+'"\n'+indent+'approved_date: "2026-10-12"\n'
statepath=ROOT/'.atena/state/art032-juiblex.yaml'
statepath.write_text(change(statepath.read_text(encoding='utf-8')),encoding='utf-8')
prefix,tail=before.split('art032_pontos_2026_10_11:',1)
rootpath.write_text(change(prefix,'  ')+'art032_pontos_2026_10_11:'+tail,encoding='utf-8')
assert rootpath.read_text(encoding='utf-8').split('art032_pontos_2026_10_11:',1)[1]==tail
planpath=ROOT/'.atena/vault/drafts/PLAN-ART032-JUIBLEX-v01.md'
plan=planpath.read_text(encoding='utf-8').replace('status: PREPARED_PENDING_SCOPE_APPROVAL','status: APPROVED_IN_PROGRESS',1)
plan+='\n## G0 aprovado — 2026-10-12\n\nResposta explícita **“Aprovo MJ01 DRAFT”** ao plano v01 de uma fonte estática amorfa/filamentosa, auditoria e galeria comparativa 80/128px. Modalidade per-plan. **S-001 concluído; S-002 autorizado, 1/5 concluído, três passos após o atual.** Zero lacunas BLOCKING para hipótese DRAFT. Produção/correções do contrato autorizadas; aceite visual S-005 posterior. Sem integração, CANON, preparação/admissão, commit, push ou build. Texto anterior registra a preparação antes deste aceite.\n'
planpath.write_text(plan,encoding='utf-8')
evidencepath=ROOT/'.atena/evidence/art032-juiblex-preparation-2026-10-12.md'
evidence=evidencepath.read_text(encoding='utf-8')+'\n## Execução autorizada — 2026-10-12\n\nG0 aprovado com **“Aprovo MJ01 DRAFT”**. Modo per-plan, S-002 liberada. Inputs/fontes/referências, dezesseis candidatas anteriores/recibos e snapshot de runtime/PLAN-071 conferidos antes da geração. Aparência proposta continua hipótese DRAFT; nenhum outro gate autorizado.\n'
evidencepath.write_text(evidence,encoding='utf-8')
prompts=OUT/'prompts.md'
prompts.write_text(prompts.read_text(encoding='utf-8').replace('Preparado, geração aguarda aprovação G0; modo per-plan preservado.','G0 aprovado com “Aprovo MJ01 DRAFT”; produção per-plan autorizada, aparência DRAFT.'),encoding='utf-8')
backlogpath=ROOT/'.atena/backlog/ARTE.md'
backlog=backlogpath.read_text(encoding='utf-8').replace('MJ01 Manifestação de Juiblex DRAFT v01: [plano preparado](../vault/drafts/PLAN-ART032-JUIBLEX-v01.md), aguarda G0; sem geração/admissão.','MJ01 Manifestação de Juiblex DRAFT v01: [plano aprovado](../vault/drafts/PLAN-ART032-JUIBLEX-v01.md), em produção; sem admissão.')
backlogpath.write_text(backlog,encoding='utf-8')
print('G0 APPROVED_PER_PLAN; S-002 authorized; references/snapshot PASS; 1/5 complete.')
