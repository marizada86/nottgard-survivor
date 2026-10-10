from pathlib import Path
from PIL import Image
import hashlib,json
base=Path(__file__).parent;strip=base/'erik-move-e-guided-v01.png';im=Image.open(strip).convert('RGBA')
frames=[];metrics=[]
for idx in range(6):
    frame=im.crop((idx*im.width//6,0,(idx+1)*im.width//6,im.height));alpha=frame.getchannel('A');box=alpha.point(lambda v:255 if v>=26 else 0).getbbox()
    metrics.append(dict(frame=idx+1,bounds=box,nonempty=box is not None))
    # Preview-only resizing/compositing; never edit or overwrite native source.
    frame.thumbnail((360,420));canvas=Image.new('RGB',(400,450),'#303843');canvas.paste(frame,((400-frame.width)//2,(450-frame.height)//2),frame);frames.append(canvas)
frames[0].save(base/'guided-cycle-preview.gif',save_all=True,append_images=frames[1:],duration=150,loop=0)
contact=Image.new('RGB',(800,450),'#303843');contact.paste(frames[0],(0,0));contact.paste(frames[3],(400,0));contact.save(base/'guided-frames-1-and-4.png')
records=[]
for file in ['pose-guide-v01.png','cycle-guide-v01.png','guided-contacts-v01.png','guided-colored-contacts-v01.png','guided-final-contacts-v01.png','erik-move-e-guided-v01.png']:
    path=base/file;image=Image.open(path);records.append(dict(file=file,sha256=hashlib.sha256(path.read_bytes()).hexdigest(),size=image.size))
(base/'guided-audit.json').write_text(json.dumps(dict(native_files=records,frames=metrics,visually_observed_figures=6,alpha_extrema=im.getchannel('A').getextrema(),final_grid_pass=im.size==(1536,384),review='DRAFT: apparent opposite foreground-leg overlap in contacts1/4, human gait review pending',runtime_admission=False),ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
(base/'guided-review.html').write_text('''<!doctype html><meta charset="utf-8"><title>Erik — piloto guiado</title><style>body{font:16px system-ui;background:#19202b;color:white;margin:32px}img{max-width:100%;background:#303843}section{margin:24px 0}a{color:#8ad6ff}</style><h1>Erik — piloto guiado de caminhada</h1><p>DRAFT. Guia geométrico com identificação de pernas, estudo colorido e aplicação da paleta final. Revisar alternância e continuidade. Grade, margens, câmera e escala ainda precisam de validação para integração.</p><section><h2>Ciclo de seis fases</h2><img src="guided-cycle-preview.gif"><p>Prévia usa recorte uniforme provisório. Não é exportação de runtime.</p></section><section><h2>Contatos 1 e 4</h2><img src="guided-frames-1-and-4.png"></section><section><h2>Tira original</h2><a href="erik-move-e-guided-v01.png">Abrir fonte nativa</a><img src="erik-move-e-guided-v01.png"></section><section><h2>Estudo com identidade de pernas</h2><img src="guided-colored-contacts-v01.png"></section><section><h2>Par com paleta final</h2><img src="guided-final-contacts-v01.png"></section><section><h2>Guia de poses</h2><img src="cycle-guide-v01.png"></section>''',encoding='utf-8')
assert all(x['nonempty'] for x in metrics)
print(json.dumps(dict(frames=6,nonempty=True,size=im.size,alpha=im.getchannel('A').getextrema(),final_grid_pass=im.size==(1536,384))))
