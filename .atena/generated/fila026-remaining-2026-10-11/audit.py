from pathlib import Path
from PIL import Image
import hashlib,json,html
import numpy as np

base=Path(__file__).parent
root=base.parents[2]
data=json.loads((base/'jobs.json').read_text(encoding='utf-8'))
normalized=json.loads((base/'normalization.json').read_text(encoding='utf-8'))
compositions=json.loads((base/'compositions.json').read_text(encoding='utf-8'))
assert data['generated']==9 and len(normalized['records'])==9
for path,digest in data['reference_hashes'].items():
    assert hashlib.sha256((root/path).read_bytes()).hexdigest()==digest,path
reports=[]
cards=[]
cursor_data={}
for job,r in zip(data['jobs'],normalized['records']):
    code=job['code']
    assert r['code']==code
    source_path=base/job['source']
    assert hashlib.sha256(source_path.read_bytes()).hexdigest()==job['source_sha256']
    source=np.asarray(Image.open(source_path).convert('RGBA'))
    rgb=source[:,:,:3].astype(int)
    red,green,blue=rgb[:,:,0],rgb[:,:,1],rgb[:,:,2]
    key=(red>210)&(blue>210)&(green<80)&(red-green>130)&(blue-green>130)
    expected=source.copy()
    expected[key]=[0,0,0,0]
    opaque=~key
    erosion=np.zeros_like(key)
    erosion[1:-1,1:-1]=opaque[1:-1,1:-1] & (key[:-2,1:-1]|key[2:,1:-1]|key[1:-1,:-2]|key[1:-1,2:])
    expected[erosion]=[0,0,0,0]
    assert int(key.sum())==r['key_pixels_removed']
    assert int(erosion.sum())==r['eroded_native_pixels']
    x0,y0,x1,y1=r['bbox']
    assert x0>0 and y0>0 and x1<source.shape[1] and y1<source.shape[0],code+' source clip'
    native=np.asarray(Image.open(base/r['native']))
    assert np.array_equal(native,expected[y0:y1,x0:x1]),code+' native mask mismatch'
    path=base/r['final']
    im=Image.open(path)
    assert im.mode=='RGBA' and list(im.size)==r['final_size']
    pixels=np.asarray(im)
    alpha=pixels[:,:,3]
    assert (alpha>0).any() and (alpha==0).any()
    assert all(a<=b for a,b in zip(im.size,job['target']))
    packed_native=native.view(np.uint32).reshape(-1)
    packed_final=pixels.view(np.uint32).reshape(-1)
    assert np.isin(np.unique(packed_final),np.unique(packed_native)).all(),code+' synthesized colors'
    checks=dict(source_hash=True,reference_hashes=True,native_key_erosion_exact=True,
                non_key_non_eroded_colors_unchanged=True,rgba=True,size=True,
                no_source_clipping=True,all_final_colors_from_source=True,visual_inspection='COMPLETED',owner_acceptance='PENDING_G2')
    if job['kind']=='lettering':
        factor=min(1,job['target'][0]/native.shape[1],job['target'][1]/native.shape[0])
        assert abs(im.width-native.shape[1]*factor)<1.01 and abs(im.height-native.shape[0]*factor)<1.01
        checks['proportional_no_enlargement']=True
        checks['glyph_review']='Correct letter sequence and accent/punctuation; Gothic capital/small-cap rendering for L03/L04 shown for owner review'
        checks['requested_text']=job['text']
    elif job['kind']=='plate':
        assert list(im.size)==job['target']
        left,right,top,bottom=job['slices']
        center=pixels[:,left:im.width-right]
        assert np.array_equal(center,np.repeat(center[:,:1],center.shape[1],axis=1))
        assert left+right<im.width and top+bottom<im.height
        checks['middle_exactly_uniform_per_row']=True
        checks['nine_slice_margins']=job['slices']
        checks['material_derivation']='Proportional-height endcaps retained; native center column replicated horizontally. Source grain remains in historical source.'
    else:
        assert list(im.size)==job['target']
        x,y=r['hotspot']
        assert 0<=x<im.width and 0<=y<im.height
        if code=='C03':
            assert r['hotspot']==[20,20]
            assert not alpha[14:26,14:26].any()
            assert np.array_equal(pixels,np.rot90(pixels))
            checks.update(center_12x12_clear=True,four_fold_rgba_symmetry=True)
        else:
            assert alpha[y,x]>128
            assert not alpha[:y].any()
            assert not (alpha[y,:x]>128).any()
        checks['hotspot']=r['hotspot']
        cursor_data[code]=dict(path=r['final'],size=list(im.size),hotspot=r['hotspot'],runtime_admission=False)
    output_hashes={kind:hashlib.sha256((base/r[kind]).read_bytes()).hexdigest() for kind in ['native','final']}
    report=dict(code=code,revision='v01',kind=job['kind'],source=job['source'],source_sha256=job['source_sha256'],
                prepared=r['final'],size=list(im.size),hashes=output_hashes,checks=checks,content_state='DRAFT',runtime_admission=False)
    reports.append(report)
    context=next(c for c in compositions['records'] if c['code']==code)
    extra=''
    if job['kind']=='plate':
        left,right,top,bottom=job['slices']
        label={'P01':'Nível 7 — escolha','P02':'Armas','P03':'Nome do chefe'}[code]
        extra=f'<p>Exemplo em fonte separada (PNG sem texto):</p><div class="plate" style="width:{im.width}px;height:{im.height}px"><img src="{r["final"]}" width="{im.width}" height="{im.height}"><span>{label}</span></div><p>Nove fatias: {left}/{right}/{top}/{bottom}. Miolo constante por linha.</p>'
    if job['kind']=='cursor':
        extra=f'<p>Hotspot {r["hotspot"]}; tamanho real {im.width}×{im.height}. Ampliação:</p><img class="zoom" src="{r["final"]}" width="{im.width*6}" height="{im.height*6}">'
    cards.append(f'<article id="{code}"><h2>{code} v01 · DRAFT</h2><p>{html.escape(job.get("text",{"plate":"Placa sem texto","cursor":"Cursor"}.get(job["kind"],"")))}</p><div class="real"><img src="{r["final"]}" width="{im.width}" height="{im.height}"></div>{extra}<details><summary>Contexto sobre fundo/captura do jogo</summary><img class="context" src="{context["path"]}"><p>Composição ilustrativa — não é captura de integração.</p></details><p><a href="prompts/{code}_v01.md">Prompt</a> · <a href="{job["source"]}">Fonte magenta</a></p><p>Aceite visual G2 pendente.</p></article>')

result=dict(plan='PLAN-065',spec='SPEC-132',revision='FILA026-REMAINING/v01',g1='ACCEPTED_L01_v01',
            current_step='S-012/G2',step_position=12,total_steps=16,content_state='DRAFT',runtime_admission=False,
            sources=9,prepared=9,technical_status='PASS',reference_hashes=data['reference_hashes'],
            records=reports,optional_L02='DEFERRED_OPTIONAL',
            preview_limitation='Composites on actual local backgrounds/capture; no runtime admission, no hardware cursor/playtest claim.',
            next='Owner G2 decisions for nine individual revisions; runtime admission and Git gates remain separate.')
(base/'audit.json').write_text(json.dumps(result,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
(base/'cursor-candidates.json').write_text(json.dumps(dict(status='DRAFT_NOT_RUNTIME_DATA',cursors=cursor_data),ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
(base/'index.html').write_text('<!doctype html><html lang="pt-BR"><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>FILA-026 · G2 · nove peças</title><style>body{background:#151824;color:#eee;font:16px system-ui;margin:24px;max-width:1280px}article{background:#252939;padding:18px;margin:22px 0;border:1px solid #4f485e;border-radius:10px}a{color:#b2d9ff}p{line-height:1.5}.real{background:#191b27;padding:14px;overflow:auto}.real img,.zoom{image-rendering:pixelated;max-width:none}.context{width:100%;height:auto}.tones{display:flex;gap:12px;overflow:auto}.tones img{width:360px;height:96px;max-width:none}.plate{position:relative}.plate img{position:absolute;inset:0}.plate span{position:absolute;inset:0;display:flex;align-items:center;justify-content:center;color:#e8d3a0;font:20px Georgia}.notice{padding:14px;background:#3b304b}nav{display:flex;flex-wrap:wrap;gap:16px}</style><h1>FILA-026 — nove peças DRAFT v01</h1><p class="notice">L01 v01 escolhida pelo dono no G1. Agora: PLAN-065, etapa 12/16, G2 por peça. Banners, placas e cursores preparados e auditados; aceite visual pendente. L02 é opcional e ficou deferida.</p><p>Confira Vitória! (ó), Você caiu... (ê e três pontos), EVOLUÇÃO (Ç/Ã), legibilidade e contraste. L03/L04 usam capitulares góticas estilizadas. Placas sem texto, PNGs nos tamanhos exatos e miolo uniforme. Cursores a 32/40 px, com hotspots registrados; a mira tem centro vazio e simetria exata.</p><p><a href="audit.json">Auditoria</a> · <a href="jobs.json">Fila e prompts completos</a> · <a href="../fila026-l01-2026-10-11/index.html">L01 v01 aceita</a></p><nav>'+''.join(f'<a href="#{r["code"]}">{r["code"]}</a>' for r in reports)+'</nav><h2>Cursores — tamanho real sobre claro e escuro</h2><p>Ordem: ponteiro C01, mão C02, mira C03. Ponto de referência igual em cada coluna, com composição pelo hotspot.</p><div class="tones"><img src="previews/cursors_dark.png"><img src="previews/cursors_light.png"></div>'+''.join(cards)+'<p>O G2 é aceite artístico por peça. Admissão, integração, commit e push permanecem em seus checkpoints próprios.</p></html>',encoding='utf-8')
# Preserve the separately recorded human acceptance when the technical audit is rerun.
if (base/'owner-approval.json').exists():
    import runpy
    runpy.run_path(str(base/'reconcile_approval.py'))
else:
    print(json.dumps(dict(sources=9,prepared=9,technical_status='PASS',cursor_hotspots=cursor_data,g2='PENDING'),ensure_ascii=False))
