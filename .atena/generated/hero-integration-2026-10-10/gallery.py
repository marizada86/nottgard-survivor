from pathlib import Path
from PIL import Image,ImageDraw
import json,html

out=Path(__file__).parent;root=Path.cwd()
records=json.loads((out/'packing.json').read_text());parts=[]
for hero,title in [('arlindo','Arlindo Orlando'),('erik','Erik Blackthorn')]:
    parts.append('<section><h2>'+title+'</h2><img class="scene" src="'+hero+'-idle-runtime.png"><div class="grid">')
    for r in records:
        if r['hero']!=hero:continue
        parts.append(f'<article><h3>{r["animation"]}</h3><img src="{hero}-{r["animation"]}.gif"><p>{r["count"]} quadros</p></article>')
    parts.append('</div></section>')
(out/'index.html').write_text('<!doctype html><html lang="pt-BR"><meta charset="utf-8"><title>Erik e Arlindo no jogo</title><style>body{background:#171e28;color:#eee;font:16px system-ui;margin:24px}h1,h2{color:#e3bd72}.scene{width:min(100%,1000px)}.grid{display:grid;grid-template-columns:repeat(3,minmax(180px,1fr));max-width:1000px;gap:12px}article{background:#27303c;padding:12px;text-align:center}article img{max-width:100%;height:250px;object-fit:contain;image-rendering:pixelated}</style><h1>Erik e Arlindo — arte própria no jogo</h1><p>Integração local v04. As cenas abaixo foram capturadas no jogo em Dagruve. Animações usam as tiras admitidas, com as primeiras gerações selecionadas. Erik leste: sete poses; nordeste: cinco quadros íntegros. Fluidez e leitura aguardam avaliação humana.</p>'+''.join(parts)+'</html>',encoding='utf-8')
board=Image.new('RGB',(1280,590),'#171e28');draw=ImageDraw.Draw(board)
for i,(hero,title) in enumerate([('arlindo','Arlindo Orlando'),('erik','Erik Blackthorn')]):
    scene=Image.open(out/(hero+'-idle-runtime.png')).convert('RGB')
    board.paste(scene.resize((640,360)),(i*640,32));draw.text((i*640+16,12),title,fill='#e3bd72')
    # Actual on-screen pixels around the hero, enlarged without smoothing.
    crop=scene.crop((590,300,690,410)).resize((180,198),Image.Resampling.NEAREST)
    board.paste(crop,(i*640+230,392))
board.save(out/'result-runtime.png')
print('gallery and actual runtime comparison ready')
