from pathlib import Path
from PIL import Image,ImageDraw
import json,sys
root=Path(__file__).resolve().parents[4];out=Path(__file__).parent;actor=sys.argv[1]
base=root/'.atena/generated/art-candidates/enemies-goranthis'/actor
packing=json.loads((base/'strips/packing.json').read_text())
sheet=Image.new('RGB',(1536,len(packing['sources'])*389),'#25252e');draw=ImageDraw.Draw(sheet);audit=[]
for row,(state,sources) in enumerate(packing['sources'].items()):
 strip=Image.open(base/'strips'/f'{state}.png').convert('RGBA');frames=[]
 assert strip.size==(len(sources)*256,384)
 for i,item in enumerate(sources):
  p=root/item['path'].removeprefix('res://');im=Image.open(p).convert('RGBA');a=im.getchannel('A');h=a.histogram();b=a.point(lambda x:255 if x>=11 else 0).getbbox()
  clipped=b[0]==0 or b[1]==0 or b[2]==im.width or b[3]==im.height;solid=sum(h[230:])/sum(h[11:]);assert not clipped and solid>=.9,p
  frame=strip.crop((i*256,0,(i+1)*256,384));box=frame.getchannel('A').point(lambda x:255 if x>=11 else 0).getbbox();assert box[0]>0 and box[1]>0 and box[2]<256 and box[3]<384,(state,i,box)
  bg=Image.new('RGBA',(256,384),'#25252e');bg.alpha_composite(frame);frames.append(bg.convert('RGB'));sheet.paste(bg,(i*256,row*389+5));draw.text((i*256+8,row*389+5),f'{state}_{i:02}',fill='white')
  audit.append(dict(state=state,index=i,path=item['path'],bbox=b,solidity=solid,clipped=clipped,packed_bbox=box))
 frames[0].save(out/f'{actor}_{state}_review.gif',save_all=True,append_images=frames[1:],duration=180,loop=0)
sheet.save(out/f'{actor}_compact_review.png');(out/f'{actor}-selected-source-audit.json').write_text(json.dumps(audit,indent=2)+'\n')
print(f'{actor}: {len(audit)} source and cell bounds validated; review and GIFs saved.')
