from pathlib import Path
from PIL import Image,ImageDraw
import json
base=Path(__file__).parent;im=Image.new('RGB',(2400,640),'#f3f5f8');d=ImageDraw.Draw(im)
# Near right and far left points: knee, ankle. Constant depth order.
phases=[(((242,425),(292,525)),((135,425),(82,525))),(((205,435),(208,525)),((182,413),(175,480))),(((157,425),(132,525)),((230,405),(250,498))),(((132,425),(82,525)),((242,425),(292,525))),(((182,413),(175,480)),((205,435),(208,525))),(((230,405),(250,498)),((157,425),(132,525)))]
records=[]
for idx,(near,far) in enumerate(phases):
    dx=idx*400;hip=(dx+190,330)
    for points,color,width in [(far,'#cc438f',32),(near,'#009eb4',44)]:
        poly=[hip]+[(dx+x,y) for x,y in points];d.line(poly,fill=color,width=width,joint='curve')
        for x,y in poly:d.ellipse((x-width//2,y-width//2,x+width//2,y+width//2),fill=color)
        x,y=poly[-1];d.rounded_rectangle((x-19,y-10,x+48,y+18),radius=8,fill=color)
    d.polygon([(dx+152,174),(dx+226,174),(dx+243,304),(dx+218,344),(dx+142,344)],fill='#6f7782')
    d.ellipse((dx+167,85,dx+237,171),fill='#6f7782');d.polygon([(dx+226,108),(dx+253,130),(dx+233,139)],fill='#6f7782')
    d.line([(dx+170,193),(dx+201,254),(dx+283,241)],fill='#444b55',width=27,joint='curve')
    d.line([(dx+288,251),(dx+297,177)],fill='#956329',width=10);d.ellipse((dx+279,143,dx+311,183),fill='#ee922c')
    d.text((dx+24,24),'FRAME '+str(idx+1),fill='#182131')
    records.append(dict(frame=idx+1,near_right=near,far_left=far))
im.save(base/'cycle-guide-v01.png');(base/'cycle-guide-v01.json').write_text(json.dumps(records,indent=2)+'\n',encoding='utf-8')
print('Six phases: opposing contacts1/4 and passing2/5, approach3/6; fixed foreground order.')
