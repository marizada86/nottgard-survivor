from pathlib import Path
base=Path(__file__).parent
s=(base.parent/'erik-gait-pilot/build_layered_pilot.py').read_text(encoding='utf-8')
s=s.replace("source=base/'guided-final-contacts-v01.png'","source=base/'er04-contacts-v01.png'").replace('701','768').replace('1122','1024').replace("out=base/'layered-v01'","out=base/'layered-se-v01'").replace('hip=(350,635)','hip=(420,580)')
a=s.index('rig={');b=s.index('\ndef cut(poly):',a)
s=s[:a]+'''rig={
 'near':{'joints':[(450,580),(500,700),(583,882)],'polygons':[
 [(401,552),(468,556),(524,623),(542,704),(478,738),(434,661),(387,601)],
 [(454,668),(531,662),(566,736),(610,859),(620,908),(546,931),(516,837),(476,773)],
 [(550,851),(617,860),(627,906),(678,923),(709,949),(692,975),(606,981),(546,950),(536,907)]
 ]},
 'far':{'joints':[(379,580),(345,682),(282,798)],'polygons':[
 [(321,558),(402,565),(419,608),(388,678),(371,714),(313,707),(296,671)],
 [(310,652),(380,676),(358,718),(319,780),(313,817),(264,841),(226,810),(251,765)],
 [(252,769),(313,787),(330,813),(371,827),(385,851),(369,870),(290,862),(244,838),(229,812)]
 ]}
}'''+s[b:]
a=s.index('d.rectangle(');b=s.index('from PIL import ImageChops',a)
s=s[:a]+'''d.rectangle((0,0,768,552),fill=255)
d.polygon([(245,540),(395,535),(407,579),(384,606),(343,604),(306,632),(269,621)],fill=255)
d.polygon([(393,532),(516,538),(546,598),(518,618),(479,596),(439,588),(411,604)],fill=255)
d.rectangle((585,450,700,620),fill=255)
'''+s[b:]
s=s.replace('ground=1040','ground=980')
s=s.replace("knee=knee_for(start,end,distance(src[0],src[1]),distance(src[1],src[2]))", "perspective=max(1.0,(distance(start,end)+1)/(distance(src[0],src[1])+distance(src[1],src[2]))) if leg=='far' else 1.0;knee=knee_for(start,end,distance(src[0],src[1])*perspective,distance(src[1],src[2])*perspective)")
a=s.index('targets=[');b=s.index('\nrecords=',a)
s=s[:a]+'''targets=[((580,ny),(290,fy-95)),((455,ny),(360,fy-120)),((315,ny-90),(510,fy-30)),((290,ny-95),(580,fy)),((360,ny-120),(455,fy)),((510,ny-30),(315,fy-90))]'''+s[b:]
s=s.replace('hip[0]*scale','hip[0]*scale').replace('erik-move-e-layered','erik-move-se-layered')
exec(compile(s,str(base/'derived-se-script.py'),'exec'))
