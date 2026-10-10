from pathlib import Path
from PIL import Image, ImageDraw, ImageFilter, ImageChops, ImageOps
import numpy as np
import json, hashlib, shutil

root=Path.cwd();out=Path(__file__).parent
review=Path('C:/Users/Higor Rossini/.codex/worktrees/20f4/nottgard-survivor/.atena/generated/erik-arlindo-complete-2026-10-09')
manifest=json.loads((out/'source-manifest.json').read_text());overrides=json.loads((out/'overrides.json').read_text())
reports=[];board=Image.new('RGB',(1800,18*190),'#27303c');draw=ImageDraw.Draw(board);row=0
names=['idle','move_e','move_se','move_s','move_ne','move_n','attack','active','death']
def separate(im,expected,code):
    a=np.asarray(im.getchannel('A'));parents=[];runs=[];previous=[]
    if code=='AO09':
        # Annotated gaps between bodies: effects overlap in the source sheet.
        # These cuts keep hats, hands, coat and boots intact.
        cuts=[0,306,598,950,1360,1688,im.width]
        result=[]
        for x,z in zip(cuts,cuts[1:]):
            f=im.crop((x,0,z,im.height));raw=np.array(f)
            # Dissolve only cyan/violet trails at seams; no body recoloring.
            effect=(raw[:,:,2].astype(int)>raw[:,:,0].astype(int)*1.08)&(raw[:,:,2]>65)
            for xx in range(f.width):
                fade=min(1.,xx/10 if x else 1.,(f.width-1-xx)/10 if z<im.width else 1.)
                if fade<1:raw[:,xx,3]=np.where(effect[:,xx],raw[:,xx,3]*fade,raw[:,xx,3]).astype(np.uint8)
            result.append(Image.fromarray(raw))
        return result
    def find(v):
        while parents[v]!=v:parents[v]=parents[parents[v]];v=parents[v]
        return v
    for y,row in enumerate(a>=26):
        d=np.diff(np.r_[False,row,False].astype(int));current=[]
        for x,z in zip(np.where(d==1)[0],np.where(d==-1)[0]):
            idx=len(parents);parents.append(idx);runs.append((y,int(x),int(z),idx));current.append((x,z,idx))
            for px,pz,pidx in previous:
                if px<=z and pz>=x:parents[find(idx)]=find(pidx)
        previous=current
    components={}
    for y,x,z,idx in runs:components.setdefault(find(idx),[]).append((y,x,z))
    groups=list(components.values())
    def box(g):return (min(x for y,x,z in g),min(y for y,x,z in g),max(z for y,x,z in g),max(y for y,x,z in g)+1)
    bodies=[g for g in groups if sum(z-x for y,x,z in g)>3000 and box(g)[3]-box(g)[1]>im.height*.22]
    bodies.sort(key=lambda g:(box(g)[0]+box(g)[2])/2)
    if len(bodies)!=expected:
        # Detached/connected spell trails may join adjacent figures. Split at the
        # lowest alpha mass between their centers, never at an assumed grid edge.
        projection=(a>=26).sum(axis=0);cuts=[0];counts=[]
        for j in range(1,expected):
            mid=im.width*j/expected;radius=im.width/expected*.32
            lo=int(mid-radius);hi=int(mid+radius)
            x=min(range(lo,hi),key=lambda x:float(projection[x])+abs(x-mid)*.06)
            assert projection[x]<80,(code,'no safe gap',j,x,int(projection[x]))
            cuts.append(x);counts.append(int(projection[x]))
        cuts.append(im.width)
        print('EFFECT_GAPS',code,cuts,counts,flush=True)
        return [im.crop((x,0,z,im.height)) for x,z in zip(cuts,cuts[1:])]
    centers=[((box(g)[0]+box(g)[2])/2,(box(g)[1]+box(g)[3])/2) for g in bodies]
    masks=[Image.new('L',im.size) for g in bodies];pens=[ImageDraw.Draw(m) for m in masks]
    for g in groups:
        b=box(g);cx=(b[0]+b[2])/2;cy=(b[1]+b[3])/2
        owner=min(range(len(bodies)),key=lambda k:(cx-centers[k][0])**2+(cy-centers[k][1])**2)
        for y,x,z in g:pens[owner].line((x,y,z-1,y),fill=255)
    result=[]
    for m in masks:
        f=im.copy();f.putalpha(ImageChops.multiply(m.filter(ImageFilter.MaxFilter(7)),im.getchannel('A')))
        b=f.getchannel('A').getbbox();result.append(f.crop((b[0],0,b[2],im.height)))
    return result
for r in manifest['records']:
    code=r['code'];src=out/'sources'/Path(r['local_source']).name
    assert hashlib.sha256(src.read_bytes()).hexdigest()==r['source_sha256']
    im=Image.open(src).convert('RGBA');h=r['hero']
    if r['expected_frames']==1:continue
    if code in overrides:
        frames=[Image.open(review/f['path']).convert('RGBA') for f in overrides[code]['frames']]
    else:
        # Use alpha silhouettes where separated; grid only when character/effect remains within cell.
        a=np.asarray(im.getchannel('A'));occupied=(a>=26).sum(axis=0)>0
        edges=np.diff(np.r_[False,occupied,False].astype(int));starts=np.where(edges==1)[0];ends=np.where(edges==-1)[0]
        groups=[(int(x),int(y)) for x,y in zip(starts,ends) if (a[:,x:y]>=26).sum()>3000]
        if len(groups)==r['expected_frames']:
            frames=[im.crop((x,0,y,im.height)) for x,y in groups]
        else:frames=separate(im,r['expected_frames'],code)
    if code=='ER03':assert len(frames)==7
    if code=='ER06':assert len(frames)==6;frames=frames[:5]
    name=names[int(code[2:])-2]
    for f in frames:
        native=f.getchannel('A')
        nearby=native.point(lambda x:255 if x>=26 else 0).filter(ImageFilter.MaxFilter(7))
        f.putalpha(ImageChops.multiply(native,nearby))
    bboxes=[f.getchannel('A').point(lambda x:255 if x>=26 else 0).getbbox() for f in frames]
    target=300 if h=='erik' else 290
    reference=bboxes[0][3]-bboxes[0][1] if name in ['death','active','attack'] else int(np.median([b[3]-b[1] for b in bboxes]))
    scale=target/reference
    widest=max(b[2]-b[0] for b in bboxes)
    # Wider cells preserve body scale when the torch or spell extends sideways.
    cell_width=384
    assert widest*scale<cell_width-24,(code,'effect too wide',widest*scale)
    sheet=Image.new('RGBA',(len(frames)*cell_width,384));items=[]
    gif=[]
    for i,(f,b) in enumerate(zip(frames,bboxes)):
        # Keep native alpha fringes; three-pixel expansion around the visible silhouette.
        alpha=f.getchannel('A');bb=alpha.getbbox();crop=f.crop(bb)
        size=(max(1,round(crop.width*scale)),max(1,round(crop.height*scale)))
        crop=crop.resize(size,Image.Resampling.NEAREST)
        baseline=368
        pos=((cell_width-size[0])//2,baseline-size[1])
        assert pos[0]>=6 and pos[1]>=6 and pos[0]+size[0]<=cell_width-6,(code,i,size,pos)
        cell=Image.new('RGBA',(cell_width,384));cell.paste(crop,pos)
        cb=cell.getchannel('A').point(lambda v:255 if v>=26 else 0).getbbox()
        assert cb[0]>=6 and cb[1]>=6 and cb[2]<=cell_width-6 and cb[3]<=378,(code,i,cb)
        sheet.paste(cell,(i*cell_width,0));items.append({'frame':i,'bbox':cb,'scale':scale})
        bg=Image.new('RGB',cell.size,'#27303c');bg.paste(cell,mask=cell.getchannel('A'));gif.append(bg)
        small=cell.resize((192,192),Image.Resampling.NEAREST);board.paste(small,(130+i*220,row*190),small)
    dest=root/'assets/animations/heroes'/h/(name+'.png');dest.parent.mkdir(parents=True,exist_ok=True);sheet.save(dest)
    gif[0].save(out/(h+'-'+name+'.gif'),save_all=True,append_images=gif[1:],loop=0,duration=125 if name=='idle' else 100)
    draw.text((4,row*190+60),h+' '+name,fill='white');row+=1
    reports.append({'code':code,'hero':h,'animation':name,'count':len(frames),'source_sha256':r['source_sha256'],'path':dest.relative_to(root).as_posix(),'frames':items})
for h in ['arlindo','erik']:
    idle=root/'assets/animations/heroes'/h/'idle.png';frame=Image.open(idle).crop((0,0,384,384))
    (root/'assets/heroes').mkdir(exist_ok=True);frame.save(root/'assets/heroes'/(h+'.png'))
    r=next(r for r in manifest['records'] if r['hero']==h and r['expected_frames']==1)
    dest=root/'assets/portraits'/(h+'.png');backup=out/'backups'/dest.name;backup.parent.mkdir(exist_ok=True)
    if not backup.exists():shutil.copyfile(dest,backup)
    shutil.copyfile(out/'sources'/Path(r['local_source']).name,dest)
board.save(out/'packed-board.png')
(out/'packing.json').write_text(json.dumps(reports,indent=2))
print(json.dumps({'strips':len(reports),'counts':{r['code']:r['count'] for r in reports}},indent=2))
