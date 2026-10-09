from pathlib import Path
from PIL import Image,ImageDraw
import json,hashlib
root=Path(__file__).resolve().parents[4];out=Path(__file__).parent
actor='sucubo';base=root/'.atena/generated/art-candidates/enemies-shendilavri'/actor
versions=[1,1,2,3,1,1]
sheet=Image.new('RGB',(1536,420),'#25252e');draw=ImageDraw.Draw(sheet);frames=[]
for i,v in enumerate(versions):
 p=base/f'{actor}_move_{i:02d}_v{v:02d}.png';im=Image.open(p).convert('RGBA')
 b=im.getchannel('A').point(lambda x:255 if x>=11 else 0).getbbox();crop=im.crop(b)
 crop=crop.resize((round(crop.width*.245),round(crop.height*.245)),Image.Resampling.NEAREST)
 fr=Image.new('RGBA',(256,384),'#25252e');fr.alpha_composite(crop,((256-crop.width)//2,356-crop.height));frames.append(fr.convert('RGB'));sheet.paste(fr,(i*256,20));draw.text((i*256+12,7),f'move_{i:02d} v{v:02d}',fill='white')
sheet.save(out/'sucubo_move_partial_review.png');frames[0].save(out/'sucubo_move_partial_review.gif',save_all=True,append_images=frames[1:],duration=180,loop=0)
print('Review generated: opposite contact at frame03, short return at frame04; owner decision pending.')
