from pathlib import Path
from PIL import Image
import hashlib,json,html,os
root=Path.cwd();base=root/'.atena/generated/erik-gait-pilot'
findings={'contacts-v01.png':'REPROVADO: dois contatos com mesma perna à frente.','contact-b-v01.png':'REPROVADO: contato oposto não demonstrado com clareza.','contact-b-v02.png':'REPROVADO para continuidade: perna próxima recua, mas câmera, traje, tocha e escala divergem do contato A.'}
entries=[];cards=[]
for name,reason in findings.items():
    path=base/name;im=Image.open(path);alpha=im.getchannel('A') if im.mode=='RGBA' else None
    entries.append(dict(file=name,sha256=hashlib.sha256(path.read_bytes()).hexdigest(),size=im.size,alpha_extrema=alpha.getextrema() if alpha else None,result=reason))
    cards.append('<article><h2>'+html.escape(name)+'</h2><p>'+html.escape(reason)+'</p><img src="'+name+'"></article>')
inventory=[dict(hero=p.parent.name,path=p.relative_to(root).as_posix(),gait_review='PENDING') for p in sorted((root/'assets/animations/heroes').glob('*/move_*.png'))]
(base/'other-heroes-inventory.json').write_text(json.dumps(inventory,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
(base/'audit.json').write_text(json.dumps(dict(status='PILOT_NOT_ACCEPTED',attempts=3,checks=entries,runtime_admission=False,next='Controlled pose guide preserving original camera and equipment; do not extrapolate rejected pilot.'),ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
(base/'index.html').write_text('<!doctype html><meta charset="utf-8"><title>Piloto Erik — contatos</title><style>body{background:#19202b;color:white;font:16px system-ui;margin:32px}article{display:inline-block;vertical-align:top;width:30%;margin:1%;background:#303843}img{width:100%}h2,p{padding:12px}</style><h1>Piloto de alternância — Erik</h1><p>Nenhuma tentativa admitida. Comparação de três resultados: repetição de pose versus perda de continuidade visual.</p>'+''.join(cards),encoding='utf-8')
print(json.dumps(dict(variants=len(entries),other_strips=len(inventory),pilot_accepted=False)))
