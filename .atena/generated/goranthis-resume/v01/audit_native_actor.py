from pathlib import Path
from PIL import Image, ImageDraw
import json, sys

root = Path(__file__).resolve().parents[4]
out = Path(__file__).parent
actor = sys.argv[1]
base = root / '.atena/generated/art-candidates/enemies-goranthis' / actor
selection_path = base / 'frame-selection.json'
selection = json.loads(selection_path.read_text()) if selection_path.exists() else {}
results = []
states = ['idle', 'move', 'attack', 'death'] + (['special'] if actor == 'socothbenoth' else [])
sheet = Image.new('RGB', (1680, len(states) * 370), '#24242e')
draw = ImageDraw.Draw(sheet)
for row, state in enumerate(states):
    for i in range({'idle': 4, 'move': 6, 'attack': 4, 'death': 6, 'special': 6}[state]):
        candidates = sorted(base.glob(f'{actor}_{state}_{i:02}_v*.png'))
        if not candidates:
            continue
        version = selection.get(f'{state}_{i:02}', {}).get('version')
        path = base / f'{actor}_{state}_{i:02}_v{version:02}.png' if version else candidates[-1]
        if state == 'idle' and i == 0 and actor == 'cultista_de_socothbenoth':
            path = base / f'{actor}_idle_00_v02.png'
        im = Image.open(path).convert('RGBA')
        a = im.getchannel('A'); hist = a.histogram()
        box = a.point(lambda x: 255 if x >= 11 else 0).getbbox()
        cut = box[0] == 0 or box[1] == 0 or box[2] == im.width or box[3] == im.height
        solid = sum(hist[230:]) / sum(hist[11:])
        results.append(dict(state=state, index=i, path=path.relative_to(root).as_posix(), size=im.size, bbox=box, solidity=solid, clipped=cut))
        preview = im.crop(box)
        preview.thumbnail((260, 335), Image.Resampling.NEAREST)
        x = i*280+(280-preview.width)//2; y = row*370+30+(335-preview.height)//2
        sheet.paste(preview,(x,y),preview)
        draw.text((i*280+8,row*370+8),f'{state}_{i:02} {path.stem[-3:]}',fill='white')
sheet.save(out / f'{actor}_native_review.png')
(out / f'{actor}-native-audit.json').write_text(json.dumps(results, indent=2)+'\n')
print(json.dumps({'actor':actor,'frames':len(results),'clipped':[x['path'] for x in results if x['clipped']],'low_solidity':[x['path'] for x in results if x['solidity']<.9]},indent=2))
