from pathlib import Path
from PIL import Image, ImageOps, ImageDraw
import json, hashlib, shutil

root=Path.cwd(); out=Path(__file__).parent
source=Path('C:/Users/Higor Rossini/.codex/worktrees/ffff/nottgard-survivor/.atena/generated/hero-normalization-2026-10-10')
review=Path('C:/Users/Higor Rossini/.codex/worktrees/20f4/nottgard-survivor/.atena/generated/erik-arlindo-complete-2026-10-09')
manifest=json.loads((out/'source-manifest.json').read_text())
overrides=json.loads((review/'review-frame-overrides.json').read_text())
board=Image.new('RGB',(1200, len(manifest['records'])*160),'#27303c'); draw=ImageDraw.Draw(board)
for i,r in enumerate(manifest['records']):
    src=source/r['local_source']; assert hashlib.sha256(src.read_bytes()).hexdigest()==r['source_sha256']
    dst=out/'sources'/src.name; dst.parent.mkdir(exist_ok=True); shutil.copyfile(src,dst)
    im=Image.open(src).convert('RGBA'); thumb=ImageOps.contain(im,(1080,145))
    board.paste(thumb,(110,i*160),thumb);draw.text((8,i*160+55),r['code'],fill='white')
board.save(out/'sources-board.png')
(out/'overrides.json').write_text(json.dumps(overrides,indent=2))
print('20 source hashes verified and snapshot preserved')
