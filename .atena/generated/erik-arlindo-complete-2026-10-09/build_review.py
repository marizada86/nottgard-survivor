from pathlib import Path
from PIL import Image, ImageOps, ImageDraw
import json, hashlib, html, os

root = Path.cwd()
base = root / '.atena/generated/erik-arlindo-complete-2026-10-09'
data = json.loads((base / 'jobs.json').read_text(encoding='utf-8'))
override_path=base/'review-frame-overrides.json'
overrides=json.loads(override_path.read_text(encoding='utf-8')) if override_path.exists() else {}
pilots = [('ER01','erik','er01-retrato-v01.png',1),('ER02','erik','er02-idle-v02.png',4),('AO01','arlindo','ao01-retrato-v01.png',1),('AO02','arlindo','ao02-idle-v01.png',4)]
entries = [dict(code=c,hero=h,destination=f'.atena/generated/art-candidates/heroes-novos/{h}/{n}',frames=f,status='OWNER_APPROVED_VISUAL' if c != 'AO02' else 'DRAFT_PENDING_REVIEW',technical_flags=['NORMALIZATION_PENDING'] if f>1 else []) for c,h,n,f in pilots]
entries += data['jobs']
cards=[]; checks=[]; tiles=[]
for entry in sorted(entries,key=lambda x:(x['hero'],x['code'])):
    path=root/entry['destination']
    if not path.exists():
        checks.append(dict(code=entry['code'],exists=False)); continue
    digest=hashlib.sha256(path.read_bytes()).hexdigest()
    checks.append(dict(code=entry['code'],exists=True,sha256=digest,record_matches=entry.get('sha256',digest)==digest))
    image=Image.open(path).convert('RGBA')
    override=overrides.get(entry['code'])
    if override:
        assert override['source_sha256']==digest, 'Preview extraction belongs to a different source'
        assert len(override['frames'])==entry['frames']
    frames=[]
    for i in range(entry['frames']):
        # Review-only crop. Source art is never modified or replaced.
        frame=Image.open(base/override['frames'][i]['path']).convert('RGBA') if override else image.crop((i*image.width//entry['frames'],0,(i+1)*image.width//entry['frames'],image.height))
        frame.thumbnail((300,360))
        canvas=Image.new('RGB',(340,400),'#303843')
        canvas.paste(frame,((340-frame.width)//2,(400-frame.height)//2),frame)
        frames.append(canvas)
    preview=base/(entry['code']+'-preview'+('-'+override['preview_suffix'] if override else '')+'.gif')
    frames[0].save(preview,save_all=True,append_images=frames[1:],duration=180,loop=0)
    tile=Image.new('RGB',(340,430),'#303843')
    tile.paste(frames[0],(0,30));ImageDraw.Draw(tile).text((12,8),entry['code']+' '+entry['hero'],fill='white')
    tiles.append(tile)
    relative=os.path.relpath(path,base).replace('\\','/')
    flags=', '.join(entry.get('technical_flags',[])) or 'Sem alerta automático'
    visual='; '.join(entry.get('visual_flags',[]))
    if override:visual+=' Prévia com personagens isolados: sem recorte do pé nem fragmento do quadro vizinho. Fonte preservada; grade original ainda irregular.'
    cards.append(f'<article><h2>{entry["code"]} — {entry["hero"]}</h2><p>{html.escape(entry["status"])}</p><img class="preview" src="{preview.name}"><p>{html.escape(flags)} {html.escape(visual)}</p><a href="{html.escape(relative)}">Abrir original ({image.width} × {image.height})</a><img class="strip" src="{html.escape(relative)}"></article>')
(base/'index.html').write_text('<!doctype html><html lang="pt-BR"><meta charset="utf-8"><title>Erik e Arlindo — revisão</title><style>body{background:#181e27;color:#edf2f7;font:16px system-ui;margin:32px}main{display:grid;grid-template-columns:repeat(auto-fit,minmax(440px,1fr));gap:24px}article{background:#26303d;padding:20px;border-radius:12px}a{color:#8bdaff}.preview{max-width:100%;height:300px}.strip{display:block;width:100%;margin-top:16px;background:repeating-conic-gradient(#303843 0% 25%,#414b58 0% 50%) 0/20px 20px}</style><h1>Erik e Arlindo — candidatos para revisão</h1><p>Originais preservados. Prévia animada usa divisão uniforme provisória; alertas de grade indicam que a animação ainda precisa de normalização. Apenas ER01, ER02 e AO01 têm aprovação visual anterior. Novas peças continuam DRAFT e não foram integradas ao jogo.</p><main>'+''.join(cards)+'</main></html>',encoding='utf-8')
(base/'review-audit.json').write_text(json.dumps(dict(total_available=len(cards),expected=20,files=checks,runtime_admission=False),ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
contact=Image.new('RGB',(4*340,((len(tiles)+3)//4)*430),'#181e27')
for index,tile in enumerate(tiles):contact.paste(tile,((index%4)*340,(index//4)*430))
contact.save(base/'contact-sheet.png')
from html.parser import HTMLParser
class Links(HTMLParser):
    def __init__(self):super().__init__();self.paths=[]
    def handle_starttag(self,tag,attrs):
        for key,value in attrs:
            if key in ('href','src'):self.paths.append(value)
parser=Links();parser.feed((base/'index.html').read_text(encoding='utf-8'))
assert all((base/path).is_file() for path in parser.paths), 'Broken gallery link'
print(json.dumps(dict(available=len(cards),missing=20-len(cards),hashes_match=all(x.get('record_matches',False) for x in checks),gallery=str(base/'index.html'))))
