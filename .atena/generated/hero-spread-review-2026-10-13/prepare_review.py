"""Read existing rasters; prepare a bounded owner decision without modifying images."""
from pathlib import Path
import hashlib, html, json, re, statistics, subprocess
import numpy as np
from PIL import Image

OUT = Path(__file__).resolve().parent
ROOT = OUT.parents[2]
BODY = ROOT / '.atena/generated/hero-body-pivot-2026-10-12'
AUDIT = json.loads((BODY / 'audit.json').read_text(encoding='utf-8'))
MANIFEST = json.loads((BODY / 'manifest.json').read_text(encoding='utf-8'))
INVENTORY = ROOT / '.atena/generated/hero-wide-actions-2026-10-12/accepted-hero-inventory.json'
def sha(p): return hashlib.sha256(p.read_bytes()).hexdigest()
inventory = json.loads(INVENTORY.read_text(encoding='utf-8'))
assert inventory['accepted_strips'] == 12 and inventory['accepted_frames'] == 64
for entry in inventory['selected']:
    assert sha(ROOT / entry['path']) == entry['sha256'], entry['code']
head = subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=ROOT).decode().strip()
assert head == MANIFEST['git_head']
assert not subprocess.check_output(['git', 'diff', '--cached', '--name-only'], cwd=ROOT).strip()
records = []
for code, spread in [('AO04', 14), ('AO07', 13)]:
    r = next(r for r in AUDIT['records'] if r['code'] == code)
    source = next(r for r in MANIFEST['records'] if r['code'] == code)
    assert r['reasons'] == ['BODY_SPREAD_OVER_12_PX']
    assert sha(ROOT / source['source']) == source['source_sha256']
    for native in source['frames']:
        assert sha(ROOT / native['path']) == native['sha256']
    assert sha(BODY / r['strip']) == r['strip_sha256']
    atlas = np.array(Image.open(BODY / r['strip']).convert('RGBA'))
    assert atlas.shape == (384, 1536, 4)
    cells = []
    for f in r['frames']:
        path = BODY / f['path']
        assert sha(path) == f['sha256']
        pixels = np.array(Image.open(path).convert('RGBA'))
        assert np.array_equal(pixels, atlas[:, (f['frame']-1)*256:f['frame']*256])
        a = pixels[:, :, 3]
        assert not np.any((a > 0) & (a <= 8))
        y, x = np.where(a > 8)
        bbox = [int(x.min()), int(y.min()), int(x.max()+1), int(y.max()+1)]
        margins = [bbox[0], bbox[1], 256-bbox[2], 384-bbox[3]]
        assert min(margins) >= 10 and abs(bbox[3]-368) <= 1
        cells.append(dict(frame=f['frame'], path=str(path.relative_to(ROOT)).replace('\\','/'), sha256=f['sha256'], height=bbox[3]-bbox[1], margins=margins, floor=bbox[3]))
    heights = [f['height'] for f in cells]
    assert max(heights)-min(heights) == spread
    assert statistics.median(heights) == 290
    assert len({f['scale'] for f in r['frames']}) == 1
    records.append(dict(code=code, revision='body-pivot-v01/candidates-v02', path=str((BODY/r['strip']).relative_to(ROOT)).replace('\\','/'), sha256=r['strip_sha256'], source=source['source'], source_sha256=source['source_sha256'], frames=cells, body_median=290, body_spread=spread, criterion=12, excess=spread-12, spread_at_85=round(spread*85/290,3), uniform_scale=r['uniform_scale'], human_visual_acceptance='PENDING', exception_approval='PENDING', content_state='DRAFT'))
report = dict(date='2026-10-13', plan='PLAN-053', revision='DEV-024/hero-spread-exception-v01', status='REVIEW_PREPARED_OWNER_DECISION_PENDING', content_state='DRAFT', records=records, existing_accepted_strips=12, existing_accepted_frames=64, inventory_sha256=sha(INVENTORY), head=head, index_empty=True, raster_writes=False, runtime_admission=False, canonical_promotion=False, commit_push_export=False, browser_execution='NOT_PERFORMED_KNOWN_FILE_URL_POLICY_BLOCK')
accepted = (OUT / 'visual-acceptance.json').exists()
if accepted:
    receipt = json.loads((OUT / 'visual-acceptance.json').read_text(encoding='utf-8'))
    for r in records:
        e = next(e for e in receipt['entries'] if e['code'] == r['code'])
        assert e['sha256'] == r['sha256'] and e['accepted_spread_max_px'] == r['body_spread']
        assert e['frames'] == r['frames']
        r['human_visual_acceptance'] = 'APPROVED_EXPLICITLY_DRAFT_WITH_EXCEPTION'
        r['exception_approval'] = 'APPROVED_EXPLICITLY_EXACT_REVISION_ONLY'
    report['status'] = 'COMPLETED_VISUALLY_ACCEPTED_DRAFT_WITH_EXCEPTION'
    report['acceptance_receipt'] = 'visual-acceptance.json'
    report['current_inventory'] = 'accepted-hero-inventory.json'
    report['accepted_total_strips'] = 14
    report['accepted_total_frames'] = 76
(OUT / 'review.json').write_text(json.dumps(report,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
sections = []
for r in records:
    path = '../hero-body-pivot-2026-10-12/' + next(x for x in AUDIT['records'] if x['code']==r['code'])['strip']
    frames = ''.join(f'<a href="../../../../{f["path"]}"><img src="../../../../{f["path"]}" width="128" height="192" alt="{r["code"]} quadro {f["frame"]}"></a>' for f in r['frames'])
    # OUT is root/.atena/generated/package, so three levels return to root.
    frames = frames.replace('../../../../','../../../')
    sections.append(f'<section><h2>{r["code"]} v02 · {"sudeste" if r["code"]=="AO04" else "norte, de costas"}</h2><p>Mediana 290 px. Variação {r["body_spread"]} px, limite original 12 px: excesso {r["excess"]} px. Exceção e aceite visual PENDENTES.</p><div class="preview" data-src="{path}"><canvas width="256" height="384"></canvas><canvas width="256" height="384" style="width:{256*85/290:.3f}px;height:{384*85/290:.3f}px"></canvas></div><p>Esquerda: célula nativa. Direita: corpo-alvo a 85 px. Mesma escala durante o ciclo.</p><p><a href="{path}">Tira PNG v02 preservada</a></p><div class="cells">{frames}</div></section>')
page = '''<!doctype html><html lang="pt-BR"><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>Arlindo · decisão AO04/AO07 v02</title><style>body{max-width:1200px;margin:24px auto;padding:20px;background:#17151d;color:#eee8df;font:16px system-ui}h1,h2,a{color:#e2c994}section{border-top:1px solid #685a48;margin-top:28px;padding-top:16px}.preview,.cells{display:flex;align-items:end;gap:20px;flex-wrap:wrap}canvas,.cells img{background:#29262c}canvas{border:1px solid #685a48}button,select{padding:8px;background:#343039;color:#eee}</style><h1>Arlindo · AO04/AO07 v02</h1><p>PLAN-053 · proposta hero-spread-exception/v01. DRAFT; revisão preparada em 2026-10-13. As duas tiras continuam retidas até decisão explícita. Fontes, desenhos e passada preservados; nenhum PNG foi produzido ou alterado nesta revisão.</p><p>Proposta: tolerância limitada a 14 px em AO04 e 13 px em AO07 nestes hashes. O limite global de 12 px permanece. Avaliar porte, figurino, oscilação e continuidade da passada; a medida pequena não prova qualidade do movimento.</p><p><a href="review.json">Hashes e medidas</a> · <a href="../hero-body-pivot-2026-10-12/index.html">Comparação anterior com idles</a> · <a href="../hero-body-pivot-2026-10-12/v02/strips/AO02.png">Idle aceito</a></p><p><button id="pause">Pausar</button> <label>Cadência <select id="speed"><option value="160">160 ms/quadro</option><option value="220">220 ms/quadro</option><option value="320">320 ms/quadro</option></select></label></p>''' + ''.join(sections) + '''<script>let paused=false,step=0;const views=[...document.querySelectorAll('.preview')].map(el=>{const img=new Image();img.src=el.dataset.src;return{img,canvases:[...el.querySelectorAll('canvas')]}});document.querySelector('#pause').onclick=e=>{paused=!paused;e.target.textContent=paused?'Retomar':'Pausar'};function tick(){for(const v of views){if(v.img.complete&&v.img.naturalWidth){for(const canvas of v.canvases){const c=canvas.getContext('2d');c.clearRect(0,0,256,384);c.drawImage(v.img,(step%6)*256,0,256,384,0,0,256,384)}}}if(!paused)step++;setTimeout(tick,Number(document.querySelector('#speed').value))}tick();</script></html>\n'''
if accepted:
    page = page.replace('As duas tiras continuam retidas até decisão explícita.', 'AO04/AO07 v02 visualmente aceitas pelo dono com exceção limitada de 14/13 px. DRAFT mantido; sem admissão ou CANON.')
    page = page.replace('Exceção e aceite visual PENDENTES.', 'Aceite visual e exceção APROVADOS explicitamente em 2026-10-13; limite global continua 12 px.')
    page = page.replace('Proposta: tolerância limitada', 'Exceção aceita: tolerância limitada')
    page = page.replace('<p><button id="pause">', '<p><a href="visual-acceptance.json">Recibo do aceite e exceção</a> · <a href="accepted-hero-inventory.json">Inventário atual: 14 tiras/76 quadros DRAFT</a></p><p><button id="pause">')
(OUT / 'index.html').write_text(page,encoding='utf-8')
links = re.findall(r'(?:href|src)="([^"]+)"', page) + re.findall(r'data-src="([^"]+)"',page)
for link in links: assert (OUT/html.unescape(link)).is_file(), link
report['local_links_checked'] = len(links)
report['native_visual_inspection'] = 'BOTH_STRIPS_INSPECTED; SUBJECTIVE_ACCEPTANCE_PENDING'
(OUT / 'review.json').write_text(json.dumps(report,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
print('PASS: 2 preserved strips/12 cells, one scale per strip, medians290, spreads14/13, margins/base, sources and12prior accepted hashes; all',len(links),'local links. No raster writes;', 'explicit DRAFT exception accepted.' if accepted else 'owner gate pending.')
