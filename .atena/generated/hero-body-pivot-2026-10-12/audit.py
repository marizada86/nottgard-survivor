"""Independent read-only raster QA and gallery for the current candidate set."""
from pathlib import Path
import hashlib
import html
import json
import re
import statistics
import subprocess
import numpy as np
from PIL import Image

OUT=Path(__file__).resolve().parent
ROOT=OUT.parents[2]
m=json.loads((OUT/'manifest.json').read_text(encoding='utf-8'))
variant=OUT/m['output_variant']
p=json.loads((variant/'preparation.json').read_text(encoding='utf-8'))
def sha(path):return hashlib.sha256(path.read_bytes()).hexdigest()
protected=json.loads((OUT/'protected-snapshot.json').read_text(encoding='utf-8'))
for path,h in protected.items():
    if path.endswith('#prior_tail'):
        state=(ROOT/'.atena/state/plan.yaml').read_text(encoding='utf-8')
        before='version: 2\nart032_publication_2026_10_12:'+state.split('art032_publication_2026_10_12:',1)[1]
        actual=hashlib.sha256(before.encode()).hexdigest()
    else:actual=sha(ROOT/path)
    assert actual==h,path
assert subprocess.check_output(['git','rev-parse','HEAD'],cwd=ROOT).decode().strip()==m['git_head']
assert not subprocess.check_output(['git','diff','--cached','--name-only'],cwd=ROOT).strip()
records=[]
for source,prepared in zip(m['records'],p['strips']):
    assert source['code']==prepared['code']
    atlas=np.array(Image.open(variant/prepared['output']).convert('RGBA'))
    assert atlas.shape==(384,len(source['frames'])*256,4)
    frames=[]
    for original,f in zip(source['frames'],prepared['frames']):
        assert sha(ROOT/original['path'])==original['sha256']
        pixels=np.array(Image.open(variant/f['path']).convert('RGBA'));assert pixels.shape==(384,256,4)
        frame_index=int(f['frame'])
        assert np.array_equal(pixels,atlas[:,(frame_index-1)*256:frame_index*256,:])
        a=pixels[:,:,3];assert not np.any((a>0)&(a<=8))
        yy,xx=np.where(a>8);bbox=[int(xx.min()),int(yy.min()),int(xx.max()+1),int(yy.max()+1)]
        margins=[bbox[0],bbox[1],256-bbox[2],384-bbox[3]];assert min(margins)>=10
        assert abs(bbox[3]-368)<=1
        if source['hero']=='arlindo':head=bbox[1]
        else:
            x,y,w,h=f['paste_rect'];sx,sy,sw,sh=f['used_rect'];roi=original['head_roi']
            x0=max(0,round(x+(roi[0]-sx)*f['scale']));x1=min(256,round(x+(roi[2]-sx)*f['scale']))
            ys,_=np.where(a[:200,x0:x1]>32)
            assert len(ys)>0
            head=int(ys.min())
        frames.append({'frame':frame_index,'path':m['output_variant']+'/'+f['path'],'sha256':sha(variant/f['path']),'bbox':bbox,'margins_px':margins,'body_height_raster':bbox[3]-head,'body_height_landmark':f['body_height'],'feet_y_raster':bbox[3],'head_y_raster':head,'scale':f['scale']})
    assert len({f['scale'] for f in frames})==1
    heights=[f['body_height_raster'] for f in frames]
    med=statistics.median(heights);spread=max(heights)-min(heights)
    target=source['target_body_height']
    reasons=[]
    if source['size_conflict']:reasons.append('SIZE_CONFLICT_WITH_BODY_TARGET')
    if abs(med-target)>target*.03:reasons.append('BODY_MEDIAN_OUTSIDE_3_PERCENT')
    if spread>12:reasons.append('BODY_SPREAD_OVER_12_PX')
    records.append({'code':source['code'],'hero':source['hero'],'status':'HELD_TECHNICAL_CRITERIA' if reasons else 'TECHNICAL_CANDIDATE_VISUAL_REVIEW_PENDING','reasons':reasons,'target_body_height':target,'body_median':med,'body_spread':spread,'landmark_spread':max(f['body_height_landmark'] for f in frames)-min(f['body_height_landmark'] for f in frames),'uniform_scale':prepared['scale'],'source_bytes_unchanged':True,'frames':frames,'strip':m['output_variant']+'/'+prepared['output'],'strip_sha256':sha(variant/prepared['output']),'runtime_admission':False,'human_visual_acceptance':'PENDING'})
if (OUT/'visual-acceptance.json').exists():
    receipt=json.loads((OUT/'visual-acceptance.json').read_text(encoding='utf-8'))
    for entry in receipt['entries']:
        record=next(r for r in records if r['code']==entry['code'])
        assert entry['sha256']==record['strip_sha256'] and not record['reasons']
        record['human_visual_acceptance']='APPROVED_EXPLICITLY_DRAFT'
        record['status']='TECHNICALLY_VERIFIED_VISUALLY_ACCEPTED_DRAFT'
summary={'status':'STRUCTURAL_QA_PASS_CRITERIA_RECORDED','revision':m['revision'],'candidate_variant':'v02','strips':11,'frames':60,'technical_candidates':[r['code'] for r in records if not r['reasons']],'held_candidates':[r['code'] for r in records if r['reasons']],'original_held_unprocessed':m['held_unprocessed'],'sources_preserved':20,'protected_hashes':len(protected),'head_unchanged':m['git_head'],'index_empty':True,'per_frame_zoom':False,'threshold_cleanup':'derivative alpha<=8 only','runtime_admission':False,'content_state':'DRAFT','browser_verification':'NOT_ATTEMPTED_KNOWN_FILE_URL_POLICY_BLOCK','human_visual_acceptance':'EIGHT_APPROVED_EXPLICITLY_DRAFT' if (OUT/'visual-acceptance.json').exists() else 'PENDING','records':records}
(OUT/'audit.json').write_text(json.dumps(summary,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
sections=[]
for r in records:
    label='RETIDA: '+', '.join(r['reasons']) if r['reasons'] else ('CANDIDATA — visualmente aceita pelo dono, DRAFT' if r['human_visual_acceptance']=='APPROVED_EXPLICITLY_DRAFT' else 'CANDIDATA — revisão visual pendente')
    count=len(r['frames']);cells=''.join(f'<a href="{f["path"]}"><img src="{f["path"]}" width="128" height="192" alt="{r["code"]} quadro {f["frame"]}"></a>' for f in r['frames'])
    small_style=f'width:{256*85/r["target_body_height"]:.3f}px;height:{384*85/r["target_body_height"]:.3f}px'
    sections.append(f'<section><h2>{r["code"]} · {r["hero"]}</h2><p class="status">{html.escape(label)}</p><p>Corpo mediano: {r["body_median"]} px (alvo {r["target_body_height"]}); variação: {r["body_spread"]} px; escala única: {r["uniform_scale"]:.4f}.</p><div class="preview" data-src="{r["strip"]}" data-frames="{count}"><canvas width="256" height="384"></canvas><canvas class="small" width="256" height="384" style="{small_style}"></canvas></div><p>Prévia pequena: corpo-alvo a 85 px; candidatas reduzidas mantêm sua diferença de tamanho.</p><p><a href="{r["strip"]}">Tira original da candidata</a></p><div class="cells">{cells}</div></section>')
(OUT/'index.html').write_text('''<!doctype html><html lang="pt-BR"><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>Erik e Arlindo · corpo e pivô v01</title><style>body{margin:24px auto;padding:20px;max-width:1500px;background:#17151d;color:#eee8df;font:16px system-ui}a{color:#e2c994}h1,h2{color:#e2c994}section{margin:32px 0;border-top:1px solid #6a5c49;padding-top:16px}.preview{display:flex;align-items:end;gap:48px}canvas{background:#29262c;width:256px;height:384px;border:1px solid #685a48}.small{width:57px;height:85px}.cells{display:flex;flex-wrap:wrap;gap:4px}.cells img{background:#29262c}.status{color:#dbb37a}button,select{padding:8px;background:#343039;color:#eee;border:1px solid #988363}#board{max-width:100%;height:auto}</style><h1>Erik e Arlindo · corpo e pivô</h1><p>PLAN-053 / DEV-024/v03 · preparação v01, candidatas v02. Onze tiras, sessenta células DRAFT. Fontes e extrações preservadas. Nenhum asset runtime admitido.</p><p>As prévias têm escala constante dentro da tira, centro corporal e sola-alvo y=368. A altura da chama/projétil não define altura corporal. Linha dourada: base; eixo ciano: centro do tronco. AO08 reduzida serve apenas como diagnóstico retido; não aceitar como equivalente às demais. Critérios excedidos aparecem em cada seção.</p><p>Prancha: primeira linha AO02/AO03/AO04/AO05/AO06/AO07/AO08; segunda ER02/ER04/ER05/ER07. <a href="audit.json">Auditoria</a> · <a href="manifest.json">Manifesto/marcações</a> · <a href="v02/preparation.json">Registro Godot</a></p><img id="board" src="v02/body-pivot-board.png" width="1792" height="840" alt="Comparação de corpo e base"><p><button id="pause">Pausar</button> <label>Cadência <select id="speed"><option value="160">160 ms/quadro</option><option value="220">220 ms/quadro</option><option value="320">320 ms/quadro</option></select></label> <span id="state">Prévia local; não é playtest</span></p>''' + ''.join(sections) + '''<script>let paused=false,step=0;const views=[...document.querySelectorAll('.preview')].map(el=>{const img=new Image();img.src=el.dataset.src;return{img,count:Number(el.dataset.frames),canvases:[...el.querySelectorAll('canvas')]}});document.querySelector('#pause').onclick=e=>{paused=!paused;e.target.textContent=paused?'Retomar':'Pausar'};function tick(){for(const v of views){if(v.img.complete&&v.img.naturalWidth){for(const canvas of v.canvases){const c=canvas.getContext('2d');c.clearRect(0,0,256,384);c.drawImage(v.img,(step%v.count)*256,0,256,384,0,0,256,384)}}}if(!paused)step++;setTimeout(tick,Number(document.querySelector('#speed').value))}tick();</script></html>\n''',encoding='utf-8')
for href in re.findall(r'(?:href|src)="([^"]+)"',(OUT/'index.html').read_text(encoding='utf-8')):
    assert (OUT/html.unescape(href)).is_file(),href
print('Structural QA PASS: protected/source hashes, sixty cells, eleven atlases, margins, anchors, one scale per strip, gallery links.')
print('Technical candidates:',summary['technical_candidates'])
print('Held:',summary['held_candidates'])
for r in records:print(r['code'],r['body_median'],r['body_spread'],r['status'])
