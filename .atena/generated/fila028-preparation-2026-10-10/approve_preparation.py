"""Record owner acceptance of the delivered revision; no image modification."""
from pathlib import Path
import json, hashlib, re
base=Path(__file__).parent
root=base.parents[2]
reply='continuando do ultimo checkpoint, está aprovado, pode comitar'
manifest=json.loads((base/'manifest.json').read_text(encoding='utf-8'))
audit=json.loads((base/'audit.json').read_text(encoding='utf-8'))
accepted=[]
held=[]
for entry,report in zip(manifest['entries'],audit['reports']):
    assert entry['code']==report['code']
    assert hashlib.sha256((root/entry['path']).read_bytes()).hexdigest()==entry['sha256']
    output=root/entry['proposed_output']
    assert hashlib.sha256(output.read_bytes()).hexdigest()==report['output_sha256']
    if report['technical_status']=='METRICS_PASS_VISUAL_REVIEW_PENDING':
        accepted.append(dict(code=entry['code'],source_version=entry['version'],derived_revision='FILA-028-PREP/v01',path=entry['proposed_output'],sha256=report['output_sha256'],content_state='CANON_PREPARATION_VISUAL_ONLY',runtime_admission=False))
        entry['derived_state']='CANON_PREPARATION_VISUAL_ONLY'
    else:
        held.append(entry['code'])
        entry['derived_state']='DRAFT_HELD'
assert len(accepted)==33 and held==['AL01']
register=dict(revision='FILA-028-PREP/v01',authority='owner',authorization=reply,request_classification='IN_PLAN',accepted_count=33,held=held,held_reason='Body invariance failed; no waiver or correction authorized',runtime_admission=False,entries=accepted)
(base/'approved-derivatives.json').write_text(json.dumps(register,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
manifest.update(status='ACCEPTED_33_HELD_ALTAR',derived_output_state='MIXED_CANON_PREPARATION_33_DRAFT_ALTAR',owner_acceptance_register='approved-derivatives.json',owner_reply=reply)
(base/'manifest.json').write_text(json.dumps(manifest,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
gallery=(base/'index.html').read_text(encoding='utf-8')
gallery=gallery.replace('34 derivadas DRAFT','33 derivadas CANON de preparação · AL01 DRAFT retido')
gallery=gallery.replace('Revisão técnica/visual pendente; altar retido se falhar invariância.','Preparação visual aceita pelo dono para 33 peças; AL01 retido por falha de invariância. Auditoria JSON preserva o resultado técnico anterior ao aceite.')
gallery=gallery.replace('geometria/câmera em revisão','pareamento visual aceito; geometria/câmera não declaradas idênticas')
for entry in accepted:
    pattern=r'(<article id="'+entry['code']+r'">)(.*?)(</article>)'
    def update(m):
        return m[1]+m[2].replace('METRICS_PASS_VISUAL_REVIEW_PENDING','CANON_PREPARATION_VISUAL_ONLY · métricas aprovadas').replace('PNG DRAFT','PNG CANON de preparação')+m[3]
    gallery,n=re.subn(pattern,update,gallery,flags=re.S)
    assert n==1,entry['code']
gallery=gallery.replace('<h1>','<p><a href="approved-derivatives.json">Registro de aceite e hashes</a></p><h1>',1)
(base/'index.html').write_text(gallery,encoding='utf-8')
print('Accepted 33 derivatives; AL01 held; all source and derivative hashes verified.')
