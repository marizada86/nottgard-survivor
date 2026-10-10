from pathlib import Path
base=Path(__file__).parent
s=(base/'refine_se_v02.py').read_text(encoding='utf-8')
s=s.replace("out=base/'layered-se-v03'","out=base/'template-cycle-v01'")
a=s.index('poses=[');b=s.index('\ndef lerp_at',a)
s=s[:a]+'''poses=[
 {'near':[(450,580),(500,700),(583,881)],'far':[(379,580),(345,682),(282,798)],'support':'near'},
 {'near':[(450,580),(475,700),(500,881)],'far':[(379,580),(325,680),(300,805)],'support':'near'},
 {'near':[(450,580),(460,700),(420,881)],'far':[(379,580),(335,700),(320,830)],'support':'near'},
 {'near':[(450,580),(480,682),(520,798)],'far':[(379,580),(360,700),(330,881)],'support':'far'},
 {'near':[(450,580),(490,680),(545,805)],'far':[(379,580),(385,700),(400,881)],'support':'far'},
 {'near':[(450,580),(510,700),(570,830)],'far':[(379,580),(400,700),(480,881)],'support':'far'},
]'''+s[b:]
s=s.replace('def warp(leg,target):','def warp(leg,target,template):').replace("src=rig[leg]['joints'];mesh=[]","src=rig[template]['joints'];mesh=[]").replace('return layers[leg].transform','return layers[template].transform')
s=s.replace("parts={leg:warp(leg,pose[leg]) for leg in ('far','near')}","templates={'near':'near','far':'far'} if i<3 else {'near':'far','far':'near'}\n    parts={leg:warp(leg,pose[leg],templates[leg]) for leg in ('far','near')}")
s=s.replace("assert poses[0]['near'][2][0]>420>poses[3]['near'][2][0]","assert poses[0]['near'][2][1]>poses[0]['far'][2][1]")
s=s.replace("assert poses[0]['far'][2][0]<420<poses[3]['far'][2][0]","assert poses[3]['far'][2][1]>poses[3]['near'][2][1]")
s=s.replace("'method':'continuous whole-leg mesh; no separately rotated knee or ankle pieces'","'method':'front/back painted leg templates anchored at anatomical hips; continuous mesh; fixed supporting baseline'")
s=s.replace('erik-move-se-mesh-1536x384','erik-move-se-templates-1536x384')
exec(compile(s,str(base/'template-cycle-derived.py'),'exec'))
