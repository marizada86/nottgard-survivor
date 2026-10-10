from pathlib import Path
import json,hashlib,re
root=Path(__file__).resolve().parents[3];base=Path(__file__).parent
ic=root/'.atena/generated/fila028-icons-2026-10-10';arse=root/'.atena/generated/fila028-ar-se-2026-10-10'
a=json.loads((ic/'audit.json').read_text(encoding='utf-8'));b=json.loads((arse/'audit.json').read_text(encoding='utf-8'))
entries=[]
for s in a['selected']:
    p=ic/s['file'];assert hashlib.sha256(p.read_bytes()).hexdigest()==s['geometry']['sha256']
    entries.append(dict(code=s['code'],version=s['version'],path=str(p.relative_to(root)),sha256=s['geometry']['sha256'],visual_state='CANON',runtime_admission=False))
for code,version in b['selection'].items():
    r=next(r for r in b['reports'] if r['code']==code and r['version']==version);p=arse/'native-sources'/f'{code}_{version}.png'
    assert hashlib.sha256(p.read_bytes()).hexdigest()==r['sha256']
    entries.append(dict(code=code,version=version,path=str(p.relative_to(root)),sha256=r['sha256'],visual_state='CANON',runtime_admission=False))
register=dict(approval_date='2026-10-10',authority='owner',owner_reply='atena, aprovo tudo ... vamos continuar a produção de assets',scope='Visual acceptance of selected source versions only',accepted_exceptions=['IC04 v02 margin 14.51 percent','IC03 v02 one pixel tolerance'],entries=entries)
(base/'approved-sources.json').write_text(json.dumps(register,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
queue=root/'.atena/generated/CHATGPT-FILA-028-eventos-arcanista-icones-segredos-e-altar.md'
q=queue.read_text(encoding='utf-8');q=re.sub(r'- \[x\] gerada · \[ \] aprovada: (IC\d{2}|AR01|SE01|SE02)',r'- [x] gerada · [x] aprovada: \1',q)
q=q.replace('IC01–IC13 geradas DRAFT com auditoria e aceite pendente','IC01–IC13 aceitas visualmente').replace('AR01/SE01/SE02 geradas DRAFT','AR01/SE01/SE02 aceitas visualmente')
queue.write_text(q,encoding='utf-8')
for f,step in [('fila028-icons.yaml','S-014/ACCEPTED'),('fila028-ar-se.yaml','S-004/ACCEPTED')]:
    p=root/'.atena/state'/f;t=p.read_text(encoding='utf-8')
    t=t.replace('status: GENERATED_AUDITED_AWAITING_OWNER_REVIEW','status: VISUALLY_APPROVED_PREPARATION_PENDING')
    t=re.sub(r'checkpoint: S-\d+/OWNER-VISUAL-REVIEW',f'checkpoint: {step}',t)
    t=t.replace('content_state: DRAFT','content_state: CANON_SOURCE_VISUAL_ONLY').replace('next_approval: PENDING_OWNER_VISUAL_ACCEPTANCE','next_approval: APPROVED_SOURCE_VISUAL_ONLY').replace('unapproved_exceptions: [IC04-margin, IC03-one-pixel-tolerance]','accepted_exceptions: [IC04-margin, IC03-one-pixel-tolerance]')
    t=re.sub(r'next_objective: .*',"next_objective: 'Preparar proximo escopo de producao; recorte e integracao dependem de plano proprio'",t)
    t+="visual_approval_reply: 'atena, aprovo tudo'\nvisual_register: .atena/vault/canon/ASSET-APPROVAL-FILA028-IC-AR-SE-2026-10-10.md\n"
    p.write_text(t,encoding='utf-8')
# Previous audit records are historical DRAFT provenance; authoritative approval is separate.
for folder in [ic,arse]:
    p=folder/'index.html';t=p.read_text(encoding='utf-8')
    banner='<div style="padding:16px;border:2px solid #79b898">Aceite visual registrado pelo dono em 2026-10-10: versões selecionadas CANON como fontes visuais. Ressalvas IC04/IC03 aceitas. Conteúdo abaixo preserva a auditoria histórica DRAFT. Recorte e integração pendentes.</div>'
    if banner not in t:t=t.replace('<header>',banner+'<header>',1)
    p.write_text(t,encoding='utf-8')
print('16 selected sources checked and visual approval reconciled; previous versions remain DRAFT.')
