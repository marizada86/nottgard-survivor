from pathlib import Path
import json,subprocess
root=Path.cwd();out=Path(__file__).parent
entry='\n2026-10-09 — Dono respondeu “aprovado, commit e pus”: N03 v01 aceita; commit/push do checkpoint R completo/N03 aprovado na branch existente antes de N01,N02,N04,N05,N06 e somente gate M03. Recibo .atena/generated/s007-reconciliation/v01/n03-owner-approval-2026-10-09.json; registro canônico030. Publicação em preparação, sem alegar conclusão.\n'
for rel in ['.atena/evidence/EVID-145-fila-de-imagens-prioritaria-2026-10-02.md','.atena/evidence/s007-onda-cortante-completa-n03-gate-2026-10-09.md','.atena/specs/SPEC-121-retomada-fila-imagens/tasks.md','.atena/specs/SPEC-121-retomada-fila-imagens/plan.md','.atena/vault/drafts/PLAN-053-fila-de-imagens-2026-10-02.md']:
 p=root/rel;p.write_text(p.read_text(encoding='utf-8-sig')+entry,encoding='utf-8')
p=root/'.atena/backlog/ARTE.md';t=p.read_text(encoding='utf-8-sig');t=t.replace('N03 pulso radiante v01 pico candidato, gate humano pendente antes de cinco N e gate M03','N03 pulso radiante v01 pico aprovado pelo dono; commit/push solicitado antes de cinco N e gate M03');p.write_text(t,encoding='utf-8')
assert not subprocess.check_output(['git','diff','--cached','--name-only']).strip(),'Preexisting index requires inspection'
p=out/'scope.json';d=json.loads(p.read_text(encoding='utf-8'));d['selected']=sorted(set(d['selected']+[(out/'seal.py').relative_to(root).as_posix()]));d.update(files=len(d['selected']),bytes_before_scope=sum((root/f).stat().st_size for f in d['selected']));p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8');(out/'pathspec.nul').write_bytes(('\0'.join(d['selected'])+'\0').encode('utf-8'));print(json.dumps(dict(files=d['files'],bytes=d['bytes_before_scope'],staged_before=0)))
