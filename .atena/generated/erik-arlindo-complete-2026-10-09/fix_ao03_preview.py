from pathlib import Path
from PIL import Image,ImageDraw,ImageFilter,ImageChops
import json,hashlib,shutil
root=Path.cwd();base=root/'.atena/generated/erik-arlindo-complete-2026-10-09';out=base/'review-frame-extraction/AO03-v01';out.mkdir(parents=True,exist_ok=True)
src=root/'.atena/generated/art-candidates/heroes-novos/arlindo/ao03-move_e-v01.png';sha=hashlib.sha256(src.read_bytes()).hexdigest();im=Image.open(src).convert('RGBA')
records=[];component_masks=[]
for i in range(6):
    binary=im.getchannel('A').point(lambda v:255 if v>=26 else 0)
    center=round(im.width*(i+.5)/6);seed=(center,300);assert binary.getpixel(seed)==255,seed
    ImageDraw.floodfill(binary,seed,128,thresh=0)
    component=binary.point(lambda v:255 if v==128 else 0);box=component.getbbox();assert box and 150<box[2]-box[0]<440,(i,box)
    assert not any(ImageChops.multiply(component,other).getbbox() for other in component_masks),'Components overlap'
    component_masks.append(component)
    # Preview only: preserve the original fringe around the identified character.
    mask=ImageChops.multiply(component.filter(ImageFilter.MaxFilter(7)),im.getchannel('A'))
    frame=im.copy();frame.putalpha(mask);bounds=mask.getbbox()
    frame=frame.crop((bounds[0],0,bounds[2],im.height));name=f'frame-{i+1}.png';frame.save(out/name)
    records.append({'frame':i+1,'path':str((out/name).relative_to(base)).replace('\\','/'),'bbox_source':bounds,'seed':seed})
assert hashlib.sha256(src.read_bytes()).hexdigest()==sha
overrides=base/'review-frame-overrides.json';data=json.loads(overrides.read_text()) if overrides.exists() else {}
data['AO03']={'source_sha256':sha,'method':'one alpha-connected character per frame; preview only','preview_suffix':'regions-v01','frames':records}
overrides.write_text(json.dumps(data,indent=2),encoding='utf-8')
(out/'audit.json').write_text(json.dumps({'source':str(src),'source_sha256':sha,'source_unchanged':True,'frames':records,'distinct_disjoint_components':6,'source_not_normalized':True,'runtime_admission':False},indent=2),encoding='utf-8')
for name in ['index.html','AO03-preview.gif','review-audit.json']:
    if (base/name).exists() and not (out/(name+'.before')).exists():shutil.copyfile(base/name,out/(name+'.before'))
print(json.dumps({'code':'AO03','isolated_characters':6,'source_unchanged':True,'bounds':[r['bbox_source'] for r in records]}))
