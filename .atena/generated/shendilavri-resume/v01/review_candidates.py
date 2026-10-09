"""Read-only candidate audit and labeled contact sheet; never rewrite source PNGs."""
from pathlib import Path
from PIL import Image, ImageDraw, ImageFont
import hashlib
import json

ROOT = Path(__file__).resolve().parents[4]
IDS = ['escravo_de_rivenheart', 'sucubo', 'guarda_do_castelo', 'master_of_cruelties', 'malcanthet']
LABELS = ['I01 - Escravo de Rivenheart', 'I02 - Sucubo', 'I03 - Guarda do Castelo', 'I04 - Master of Cruelties', 'I05 - Malcanthet']
OUT = Path(__file__).parent
sheet = Image.new('RGB', (1500, 1060), '#202128')
draw = ImageDraw.Draw(sheet)
font_path = Path('C:/Windows/Fonts/arial.ttf')
font = ImageFont.truetype(str(font_path), 20) if font_path.exists() else ImageFont.load_default()
rows = []
for index, (actor, label) in enumerate(zip(IDS, LABELS)):
    version = 'v02' if actor == 'master_of_cruelties' else 'v01'
    source = ROOT / '.atena/generated/art-candidates/enemies-shendilavri' / actor / f'{actor}_idle_00_{version}.png'
    im = Image.open(source).convert('RGBA')
    alpha = im.getchannel('A')
    raw_bbox = alpha.getbbox()
    bbox = alpha.point(lambda a: 255 if a >= 11 else 0).getbbox()
    solid = alpha.point(lambda a: 255 if a >= 251 else 0).getbbox()
    histogram = alpha.histogram()
    visible = sum(histogram[11:])
    solidity = sum(histogram[230:]) / visible if visible else 0
    clipped = bool(bbox and (bbox[0] == 0 or bbox[1] == 0 or bbox[2] == im.width or bbox[3] == im.height))
    row = dict(id=actor, version=version, path=source.relative_to(ROOT).as_posix(), size=list(im.size), sha256=hashlib.sha256(source.read_bytes()).hexdigest(), raw_alpha_bbox=raw_bbox, visible_alpha_threshold=11, visible_bbox=bbox, solid_bbox=solid, clipped=clipped, transparent_pixels=histogram[0], solidity=round(solidity, 6), human_approval='pending')
    rows.append(row)
    col, line = index % 3, index // 3
    x, y = col * 500, line * 530
    draw.text((x + 18, y + 14), label, font=font, fill='white')
    for by in range(y + 48, y + 490, 20):
        for bx in range(x + 10, x + 490, 20):
            color = '#303139' if ((bx - x) // 20 + (by - y) // 20) % 2 else '#272830'
            draw.rectangle((bx, by, min(bx + 19, x + 489), min(by + 19, y + 489)), fill=color)
    preview = im.crop(bbox)
    preview.thumbnail((440, 425), Image.Resampling.NEAREST)
    sheet.paste(preview, (x + (500 - preview.width) // 2, y + 485 - preview.height), preview)
    draw.text((x + 18, y + 500), version + ' - aguardando aprovacao', font=font, fill='#bdc0cc')
sheet.save(OUT / 'shendilavri_identities_v01_complete.png')
(OUT / 'candidate-audit-2026-10-07.json').write_text(json.dumps(rows, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
assert len(rows) == 5
assert all(not r['clipped'] and r['transparent_pixels'] > 0 and r['solidity'] >= 0.90 for r in rows), rows
print(json.dumps(rows, ensure_ascii=False, indent=2))
