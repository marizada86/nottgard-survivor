from pathlib import Path
import json,hashlib,re
root=Path(__file__).resolve().parents[3];base=Path(__file__).parent;remaining=root/'.atena/generated/fila028-remaining-2026-10-10'
audit=json.loads((remaining/'audit.json').read_text(encoding='utf-8'));entries=[]
for r in audit['reports']:
    if not r['selected']:continue
    p=remaining/'native-sources'/f'{r["code"]}_{r["version"]}.png';assert hashlib.sha256(p.read_bytes()).hexdigest()==r['sha256']
    entries.append(dict(code=r['code'],version=r['version'],path=str(p.relative_to(root)),sha256=r['sha256'],visual_state='CANON',runtime_admission=False))
assert len(entries)==11
(base/'approved-remaining-sources.json').write_text(json.dumps(dict(owner_reply='atena, aprovado, commit e continue',approval_date='2026-10-10',scope='Selected source visuals only; no runtime admission',entries=entries),ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=root/'.atena/state/fila028-remaining.yaml';t=p.read_text(encoding='utf-8').replace('GENERATED_AUDITED_AWAITING_OWNER_REVIEW','VISUALLY_APPROVED_PREPARATION_PENDING').replace('S-012/OWNER-VISUAL-REVIEW','S-012/ACCEPTED').replace('content_state: DRAFT','content_state: CANON_SOURCE_VISUAL_ONLY').replace('next_approval: PENDING_OWNER_VISUAL_ACCEPTANCE','next_approval: APPROVED_SOURCE_VISUAL_ONLY')
t=re.sub(r'^next_objective: .*',"next_objective: 'Preparar escopo de recorte e normalizacao das fontes aceitas'",t,flags=re.M)
t+="visual_approval_reply: 'atena, aprovado, commit e continue'\nvisual_register: .atena/vault/canon/ASSET-APPROVAL-FILA028-REMAINING-2026-10-10.md\ncommit_authorization: 'atena, aprovado, commit e continue'\n"
p.write_text(t,encoding='utf-8')
p=root/'.atena/state/plan.yaml';t=p.read_text(encoding='utf-8');start=t.index('fila028_remaining_2026_10_10:');end=t.index('fila028_publish_2026_10_10:')
block=t[start:end].replace('GENERATED_AUDITED_AWAITING_OWNER_REVIEW','VISUALLY_APPROVED_PREPARATION_PENDING').replace('S-012/OWNER-VISUAL-REVIEW','S-012/ACCEPTED').replace('content_state: DRAFT','content_state: CANON_SOURCE_VISUAL_ONLY')
block+='  visual_register: .atena/vault/canon/ASSET-APPROVAL-FILA028-REMAINING-2026-10-10.md\n';p.write_text(t[:start]+block+t[end:],encoding='utf-8')
p=root/'.atena/generated/CHATGPT-FILA-028-eventos-arcanista-icones-segredos-e-altar.md';t=p.read_text(encoding='utf-8');t=re.sub(r'- \[x\] gerada · \[ \] aprovada: (SE\d{2}|I0[12])',r'- [x] gerada · [x] aprovada: \1',t);t=t.replace('SE03-SE11 e I01/I02 geradas DRAFT; aceite pendente','SE03-SE11 e I01/I02 aceitas visualmente; todas as 34 fontes aceitas, preparacao pendente');p.write_text(t,encoding='utf-8')
p=remaining/'index.html';t=p.read_text(encoding='utf-8');banner='<div style="padding:16px;border:2px solid #79b898">Aceite visual registrado pelo dono em 2026-10-10: SE03–SE11 v02, I01 v03, I02 v02 são CANON como fontes visuais. Abaixo, auditoria histórica DRAFT preservada. Preparação e runtime pendentes.</div>';t=t.replace('<header>',banner+'<header>',1);p.write_text(t,encoding='utf-8')
print('11 selected source hashes verified; owner visual acceptance recorded. 34 FILA-028 source visuals accepted.')
