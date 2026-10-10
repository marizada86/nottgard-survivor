from pathlib import Path
from PIL import Image,ImageDraw,ImageChops,ImageFilter
import json
base=Path(__file__).parent
configs=[
 dict(hero='erik',source='er05-move_s-v01-source.png',native='er05-move_s-v01.png',w=370,hip=200,ground=700,height=300,
  near=[(163,460),(162,525),(160,643)],far=[(241,460),(242,511),(244,565)],
  nearpoly=[(122,440),(195,446),(207,487),(197,549),(193,623),(195,675),(180,700),(127,701),(120,674),(129,619),(118,550),(124,494)],
  farpoly=[(211,446),(278,443),(281,491),(264,526),(265,562),(276,592),(262,610),(226,612),(210,597),(212,558),(208,509)],
  bodypolys=[[(35,405),(132,410),(136,450),(124,481),(101,494),(70,507),(34,487)],[(105,406),(229,406),(230,446),(198,464),(181,486),(160,459),(147,464)],[(242,410),(297,405),(318,452),(302,482),(269,472),(256,492),(237,456)],[(303,270),(370,270),(370,418),(310,418)]]),
 dict(hero='arlindo',source='ao05-move_s-v01-source.png',native='ao05-move_s-v01.png',w=341,hip=188,ground=710,height=290,
  near=[(216,418),(213,510),(211,650)],far=[(165,418),(161,500),(158,566)],
  nearpoly=[(185,404),(247,401),(255,450),(243,520),(243,605),(244,664),(233,705),(209,712),(184,698),(177,670),(178,606),(186,531),(177,473)],
  farpoly=[(142,405),(190,409),(190,453),(179,513),(180,548),(181,579),(170,605),(144,607),(133,593),(132,568),(135,530),(134,477)],
  bodypolys=[[(49,391),(148,394),(144,451),(139,518),(139,543),(122,570),(76,548),(62,521),(45,480)],[(256,392),(307,392),(330,474),(317,538),(288,546),(261,520)]]),
]
for c in configs:
    original=base.parent/'art-candidates/heroes-novos'/c['hero']/c['native']
    native_image=Image.open(original).convert('RGBA');h=native_image.height
    cropped=native_image.crop((0,0,c['w'],h))
    if c.get('isolate_component'):
        component=cropped.getchannel('A').point(lambda v:255 if v>=26 else 0)
        ImageDraw.floodfill(component,c['seed'],128,thresh=0)
        component=component.point(lambda v:255 if v==128 else 0).filter(ImageFilter.MaxFilter(7))
        cropped.putalpha(ImageChops.multiply(component,cropped.getchannel('A')))
    cropped.save(base/c['source'])
    rig_dir=c['hero']+'-'+c.get('direction','s')+'-rig'
    im=Image.open(base/c['source']).convert('RGBA');old=base/rig_dir;old.mkdir(exist_ok=True)
    rig={'near':{'joints':c['near'],'polygons':[c['nearpoly']]},'far':{'joints':c['far'],'polygons':[c['farpoly']]}}
    (old/'rig.json').write_text(json.dumps({'source_rig':rig}),encoding='utf-8')
    mask=Image.new('L',im.size);d=ImageDraw.Draw(mask);d.rectangle((0,0,c['w'],c['near'][0][1]+4),fill=255)
    for polygon in c['bodypolys']:d.polygon(polygon,fill=255)
    mask=ImageChops.multiply(mask.filter(ImageFilter.GaussianBlur(.4)),im.getchannel('A'));body=im.copy();body.putalpha(mask);body.save(old/'body.png')
    near,far=c['near'],c['far'];front_y=near[2][1];back_y=far[2][1];nk=near[1][1];fk=far[1][1]
    poses=[]
    for i in range(6):
        ny=[front_y,front_y,front_y,back_y,back_y+15,back_y+45][i]
        fy=[back_y,back_y+15,back_y+45,front_y,front_y,front_y][i]
        poses.append({'near':[near[0],(near[0][0],nk if i<3 else fk),(near[2][0],ny)],'far':[far[0],(far[0][0],fk if i<3 else nk),(far[2][0],fy)],'support':'near' if i<3 else 'far'})
    poses=c.get('poses',poses)
    s=(base/'refine_se_v02.py').read_text(encoding='utf-8')
    s=s.replace("old=base/'layered-se-v01'; out=base/'layered-se-v03'",f"old=base/'{rig_dir}'; out=base/'{c.get('out',c['hero']+'-south-cycle-v01')}'")
    s=s.replace("source=base/'er04-contacts-v01.png'",f"source=base/'{c['source']}'")
    s=s.replace('768',str(c['w'])).replace('1024',str(h)).replace('1025',str(h+1))
    s=s.replace('ground=980',f"ground={c['ground']}").replace('scale=300/',f"scale={c['height']}/").replace('128-420*scale',f"128-{c['hip']}*scale")
    if c.get('top_y') is not None:
        s=s.replace("top=body.getchannel('A').point(lambda v:255 if v>=26 else 0).getbbox()[1]",f"top={c['top_y']}")
    a=s.index('poses=[');b=s.index('\ndef lerp_at',a);s=s[:a]+'poses='+repr(poses)+s[b:]
    s=s.replace('def warp(leg,target):','def warp(leg,target,template):').replace("src=rig[leg]['joints'];mesh=[]","src=rig[template]['joints'];mesh=[]").replace('return layers[leg].transform','return layers[template].transform')
    s=s.replace("parts={leg:warp(leg,pose[leg]) for leg in ('far','near')}","templates={'near':'near','far':'far'} if i<3 else {'near':'far','far':'near'}\n    parts={leg:warp(leg,pose[leg],templates[leg]) for leg in ('far','near')}")
    if c.get('fixed_templates'):
        s=s.replace("templates={'near':'near','far':'far'} if i<3 else {'near':'far','far':'near'}","templates={'near':'near','far':'far'}")
    if c.get('single_template'):
        s=s.replace("templates={'near':'near','far':'far'} if i<3 else {'near':'far','far':'near'}","templates={'near':'near','far':'near'}")
    s=s.replace("assert poses[0]['near'][2][0]>420>poses[3]['near'][2][0]","assert poses[0]['near'][2][1]>poses[0]['far'][2][1]").replace("assert poses[0]['far'][2][0]<420<poses[3]['far'][2][0]","assert poses[3]['far'][2][1]>poses[3]['near'][2][1]")
    if c.get('fixed_depth'):
        s=s.replace("order=('far','near') if i<3 else ('near','far')","order=('far','near')")
    s=s.replace('erik-move-se-mesh',c['hero']+'-move-'+c.get('direction','s')+'-templates')
    exec(compile(s,str(base/(c['hero']+'-south-derived.py')),'exec'),{'__file__':str(base/'build_south_cycles.py')})
