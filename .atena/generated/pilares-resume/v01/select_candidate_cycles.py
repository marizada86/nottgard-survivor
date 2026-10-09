from pathlib import Path
from PIL import Image
import json
root=Path(__file__).resolve().parents[4];out=Path(__file__).parent;base=root/'.atena/generated/art-candidates/enemies-pilares/sintese_abissal'
p=base/'frame-selection.json';selection=json.loads(p.read_text())
def height(path):
 im=Image.open(path).convert('RGBA');b=im.getchannel('A').point(lambda x:255 if x>=230 else 0).getbbox()
 return b[3]-b[1]
idle_height=height(base/'sintese_abissal_idle_00_v02.png')
for state,count in [('attack',4),('special',6)]:
 for index in range(count):
  key=f'{state}_{index:02}';candidates=sorted(base.glob(f'sintese_abissal_{key}_v*.png'));path=candidates[-1]
  choice=selection.setdefault(key,{})
  choice['version']=int(path.stem.rsplit('v',1)[1])
  choice['scale_multiplier']=idle_height/height(path)
  choice['technical_scale_reason']='Uniform apparent standing body scale relative to approved idle; native RGBA unchanged.'
for index,multiplier in [(0,.80),(1,.80),(2,.88)]:
 key=f'death_{index:02}';choice=selection.setdefault(key,{})
 choice.update(version=2,scale_multiplier=multiplier,reason='v01 extra outer green pendant rejected; v02 preserves two main lamps. Uniform native-scale compensation keeps progressive collapse, not height normalization of death.')
for index in [3,4,5]:
 selection.setdefault(f'death_{index:02}',{}).update(version=1,anchor_y_offset=-30.0,reason='Final collapsed source kept; technical support anchor above hanging lamp drips.')
p.write_text(json.dumps(selection,indent=2)+'\n')
print('Candidate selections and uniform scale/anchor transforms recorded; pending attack03 owner status preserved.')

