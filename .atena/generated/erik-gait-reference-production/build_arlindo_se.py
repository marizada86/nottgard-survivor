from pathlib import Path
from PIL import Image,ImageDraw,ImageChops,ImageFilter
import json
base=Path(__file__).parent;old=base/'arlindo-se-rig';old.mkdir(exist_ok=True)
im=Image.open(base/'arlindo-se-source.png').convert('RGBA')
rig={
 'near':{'joints':[(199,440),(218,520),(248,612)],'polygons':[
 [(167,426),(213,423),(226,474),(238,522),(207,552),(185,519),(165,471)],
 [(203,500),(238,505),(248,557),(266,603),(256,624),(222,625),(202,566),(188,525)],
 [(222,599),(257,595),(270,618),(291,630),(292,645),(265,654),(226,642),(213,619)]
 ]},
 'far':{'joints':[(169,440),(145,495),(128,546)],'polygons':[
 [(140,430),(176,430),(184,471),(165,509),(132,513),(120,477)],
 [(125,488),(169,495),(157,525),(150,556),(123,565),(104,545),(109,514)],
 [(109,530),(145,537),(149,546),(156,556),(150,571),(129,577),(111,563),(102,547)]
 ]}
}
(old/'rig.json').write_text(json.dumps({'source_rig':rig}),encoding='utf-8')
mask=Image.new('L',im.size);d=ImageDraw.Draw(mask);d.rectangle((0,0,341,450),fill=255)
d.polygon([(60,400),(179,400),(174,463),(166,511),(145,542),(88,532),(59,513)],fill=255)
d.polygon([(234,398),(280,411),(285,495),(277,522),(253,542),(239,532),(236,477)],fill=255)
d.rectangle((280,340,337,475),fill=255)
mask=ImageChops.multiply(mask.filter(ImageFilter.GaussianBlur(.4)),im.getchannel('A'));body=im.copy();body.putalpha(mask);body.save(old/'body.png')
s=(base/'refine_se_v02.py').read_text(encoding='utf-8')
s=s.replace("old=base/'layered-se-v01'; out=base/'layered-se-v03'","old=base/'arlindo-se-rig'; out=base/'arlindo-template-cycle-v02'")
s=s.replace("source=base/'er04-contacts-v01.png'","source=base/'arlindo-se-source.png'")
s=s.replace('768','341').replace('1024','768').replace('1025','769')
s=s.replace('ground=980','ground=650').replace('scale=300/','scale=290/').replace('128-420*scale','128-195*scale')
a=s.index('poses=[');b=s.index('\ndef lerp_at',a)
s=s[:a]+'''poses=[
 {'near':[(199,440),(218,520),(248,608)],'far':[(169,440),(145,495),(128,546)],'support':'near'},
 {'near':[(199,440),(210,520),(225,608)],'far':[(169,440),(147,510),(133,570)],'support':'near'},
 {'near':[(199,440),(199,520),(190,608)],'far':[(169,440),(151,520),(145,585)],'support':'near'},
 {'near':[(199,440),(231,495),(270,546)],'far':[(169,440),(160,520),(150,608)],'support':'far'},
 {'near':[(199,440),(238,510),(270,570)],'far':[(169,440),(165,520),(170,608)],'support':'far'},
 {'near':[(199,440),(231,520),(260,585)],'far':[(169,440),(180,520),(195,608)],'support':'far'},
]'''+s[b:]
s=s.replace('def warp(leg,target):','def warp(leg,target,template):').replace("src=rig[leg]['joints'];mesh=[]","src=rig[template]['joints'];mesh=[]").replace('return layers[leg].transform','return layers[template].transform')
s=s.replace("parts={leg:warp(leg,pose[leg]) for leg in ('far','near')}","templates={'near':'near','far':'near'}\n    parts={leg:warp(leg,pose[leg],templates[leg]) for leg in ('far','near')}")
s=s.replace('width=1.0',"width=.82 if target[2][1]<600 else 1.0")
s=s.replace("assert poses[0]['near'][2][0]>420>poses[3]['near'][2][0]","assert poses[0]['near'][2][1]>poses[0]['far'][2][1]").replace("assert poses[0]['far'][2][0]<420<poses[3]['far'][2][0]","assert poses[3]['far'][2][1]>poses[3]['near'][2][1]")
s=s.replace('erik-move-se-mesh','arlindo-move-se-templates')
exec(compile(s,str(base/'arlindo-cycle-derived.py'),'exec'))
