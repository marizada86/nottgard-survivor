from PIL import Image
from pathlib import Path
root=Path(__file__).resolve().parents[4]; base=root/'.atena/generated/art-candidates/enemies-pilares/sintese_abissal'
for state in ['attack_03','death_00']:
 im=Image.open(base/f'sintese_abissal_{state}_v02.png').convert('RGBA')
 bg=Image.new('RGBA',im.size,'#24242e');bg.alpha_composite(im)
 bg.crop((780,480,1024,1040)).save(Path(__file__).parent/f'{state}_v02_lamp_detail.png')

