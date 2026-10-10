from pathlib import Path
from PIL import Image,ImageDraw
import json
base=Path(__file__).parent
canvas=Image.new('RGB',(800,640),'#f3f5f8');draw=ImageDraw.Draw(canvas)
poses=[]
for index in range(2):
    dx=index*400;hip=(dx+190,330)
    near=[hip,(dx+(242 if index==0 else 132),425),(dx+(292 if index==0 else 82),525)]
    far=[hip,(dx+(135 if index==0 else 240),425),(dx+(82 if index==0 else 292),525)]
    draw.text((dx+24,24),'CONTACT '+('A' if index==0 else 'B')+' / EAST',fill='#182131')
    draw.text((dx+24,48),'CYAN = NEAR RIGHT LEG; MAGENTA = FAR LEFT LEG',fill='#182131')
    # Fixed depth order: far limb first, foreground limb last in both contacts.
    for points,color,width in [(far,'#cc438f',32),(near,'#009eb4',44)]:
        draw.line(points,fill=color,width=width,joint='curve')
        for x,y in points:draw.ellipse((x-width//2,y-width//2,x+width//2,y+width//2),fill=color)
        x,y=points[-1];draw.rounded_rectangle((x-19,y-10,x+48,y+18),radius=8,fill=color)
    draw.polygon([(dx+152,174),(dx+226,174),(dx+243,304),(dx+218,344),(dx+142,344)],fill='#6f7782')
    draw.ellipse((dx+167,85,dx+237,171),fill='#6f7782')
    draw.polygon([(dx+226,108),(dx+253,130),(dx+233,139)],fill='#6f7782')
    draw.line([(dx+170,193),(dx+201,254),(dx+283,241)],fill='#444b55',width=27,joint='curve')
    draw.line([(dx+288,251),(dx+297,177)],fill='#956329',width=10)
    draw.ellipse((dx+279,143,dx+311,183),fill='#ee922c')
    draw.text((dx+24,580),'NEAR LEG '+('FORWARD' if index==0 else 'BACKWARD'),fill='#007e91')
    poses.append(dict(contact='A' if index==0 else 'B',hip=hip,near_right=near,far_left=far,foreground_order='near_right_on_top'))
canvas.save(base/'pose-guide-v01.png')
(base/'pose-guide-v01.json').write_text(json.dumps(dict(kind='Procedural pose diagram, not an edit of character art',poses=poses),indent=2)+'\n',encoding='utf-8')
assert poses[0]['near_right'][-1][0]-poses[0]['hip'][0]>0
assert poses[1]['near_right'][-1][0]-poses[1]['hip'][0]<0
print('Guide coordinates validated: opposite near-leg contacts, fixed depth order.')
