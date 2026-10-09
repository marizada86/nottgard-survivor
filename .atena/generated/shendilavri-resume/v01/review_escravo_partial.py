from pathlib import Path
from PIL import Image, ImageDraw
import json, hashlib

root = Path(__file__).resolve().parents[4]
out = Path(__file__).parent
actor = 'escravo_de_rivenheart'
base = root / '.atena/generated/art-candidates/enemies-shendilavri' / actor
rows = []
for path in sorted(base.glob('*.png')):
    im = Image.open(path).convert('RGBA')
    a = im.getchannel('A')
    box = a.point(lambda v: 255 if v >= 11 else 0).getbbox()
    histogram = a.histogram()
    visible = sum(histogram[11:])
    rows.append(dict(path=path.relative_to(root).as_posix(), sha256=hashlib.sha256(path.read_bytes()).hexdigest(), size=list(im.size), visible_bbox=box, solidity=sum(histogram[230:])/visible, clipped=box[0]==0 or box[1]==0 or box[2]==im.width or box[3]==im.height))
(out / 'escravo-partial-source-audit.json').write_text(json.dumps(rows, indent=2)+'\n', encoding='utf-8')
assert all(not r['clipped'] and r['solidity'] >= .9 for r in rows)
sheet = Image.new('RGB', (1536, 420), '#25252e')
draw = ImageDraw.Draw(sheet)
frames = []
fit = .245
for index in range(6):
    version = 3 if index == 3 else 1
    path = base / f'{actor}_move_{index:02d}_v{version:02d}.png'
    im = Image.open(path).convert('RGBA')
    box = im.getchannel('A').point(lambda v: 255 if v >= 11 else 0).getbbox()
    crop = im.crop(box)
    crop = crop.resize((round(crop.width*fit), round(crop.height*fit)), Image.Resampling.NEAREST)
    frame = Image.new('RGBA', (256,384), '#25252e')
    frame.alpha_composite(crop, ((256-crop.width)//2, 356-crop.height))
    frames.append(frame.convert('RGB'))
    sheet.paste(frame, (index*256, 20))
    draw.text((index*256+16, 7), f'move_{index:02d} v{version:02d}', fill='white')
sheet.save(out / 'escravo_move_partial_review.png')
frames[0].save(out / 'escravo_move_partial_review.gif', save_all=True, append_images=frames[1:], duration=180, loop=0)
print(f'{len(rows)} preserved PNGs checked; diagnostic walk montage and GIF saved. Gait alternation is pending owner decision.')
