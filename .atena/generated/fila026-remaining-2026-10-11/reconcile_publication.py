from pathlib import Path
import json
import subprocess

base=Path(__file__).parent
root=base.parents[2]
publication=json.loads((base/'publication.json').read_text(encoding='utf-8'))
assert publication['art_commit']==publication['remote_tip_at_art_verification']
subprocess.check_call(['git','merge-base','--is-ancestor',publication['art_commit'],'HEAD'],cwd=root)
for name in ['admission-receipt.json','audit.json','jobs.json']:
    path=base/name
    data=json.loads(path.read_text(encoding='utf-8'))
    data.update(publication=publication,status='ART_COMMITTED_PUSH_VERIFIED_WAITING_S014',
                current_step='S-014/OWNER_INTEGRATION_GATE',step_position=14,completed_steps=13,
                next='Authorize S014 remaining UI hookups; S015 full verification and S016 closure remain pending.')
    path.write_text(json.dumps(data,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
path=root/'.atena/vault/canon/ASSET-APPROVAL-REGISTER-031-fila026-admission-2026-10-11.json'
register=json.loads(path.read_text(encoding='utf-8'))
register.update(publication=publication,remaining='S014 remaining UI hookups; S015 full verification/playtest; S016 closure/code commit.')
path.write_text(json.dumps(register,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
path=base/'index.html'
page=path.read_text(encoding='utf-8').replace('etapa 13/16: admissão autorizada e validada; commit de arte pendente.', 'S013 concluída: arte commitada e push verificado. Próximo checkpoint S014, integração das demais telas.')
page=page.replace('Commit de arte e integração das demais telas aguardam seus checkpoints; sem push ou build.', 'Arte commitada e publicada na branch da fila. Integração das demais telas aguarda S014; sem build.')
if 'href="publication.json"' not in page:
    page=page.replace('<a href="audit.json">Auditoria</a>','<a href="publication.json">Commit e push verificados</a> · <a href="audit.json">Auditoria</a>')
path.write_text(page,encoding='utf-8')
print('Publication facts reconciled; S013 complete, S014 pending.')
