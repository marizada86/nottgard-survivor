"""Read-only pixel audit and HTML/JSON reports; never writes image pixels."""
from pathlib import Path
from PIL import Image
import hashlib, json, numpy as np, html

base = Path(__file__).parent
root = base.parents[2]
manifest = json.loads((base/'manifest.json').read_text(encoding='utf-8'))
reports = []
for e in manifest['entries']:
    source = root/e['path']
    output = root/e['proposed_output']
    im = Image.open(output)
    pixels = np.asarray(im)
    a = pixels[:,:,3]
    yy,xx = np.where(a > 0)
    bbox = [int(xx.min()),int(yy.min()),int(xx.max()+1),int(yy.max()+1)]
    margins = [bbox[0],bbox[1],im.width-bbox[2],im.height-bbox[3]]
    rgb = pixels[:,:,:3].astype(float)/255
    cyan = (np.minimum(rgb[:,:,1],rgb[:,:,2])>=.45)&(rgb[:,:,0]<=np.minimum(rgb[:,:,1],rgb[:,:,2])*.55)&(a>0)
    magenta = (np.minimum(rgb[:,:,0],rgb[:,:,2])>=.45)&(rgb[:,:,1]<=np.minimum(rgb[:,:,0],rgb[:,:,2])*.55)&(a>0)
    h = hashlib.sha256(source.read_bytes()).hexdigest()
    icon = e['operation']=='preserve_alpha_resize'
    required = int(np.ceil(im.width*(.18 if e['code'] in ['I01','I02'] else .15))) if icon else 0
    r = dict(code=e['code'],version=e['version'],source_sha256=h,source_unchanged=h==e['sha256'],output_sha256=hashlib.sha256(output.read_bytes()).hexdigest(),mode=im.mode,size=list(im.size),dimensions_pass=list(im.size)==e['target_size'],bbox=bbox,margins_px=margins,required_margin_px=required,margin_pass=min(margins)>=required,nonzero_alpha_pixels=int((a>0).sum()),fractional_alpha_pixels=int(((a>0)&(a<255)).sum()),edge_alpha_pixels=int((a[0]>0).sum()+(a[-1]>0).sum()+(a[:,0]>0).sum()+(a[:,-1]>0).sum()),cyan_hue_pixels=int(cyan.sum()),magenta_hue_pixels=int(magenta.sum()),visual_state='DRAFT_TECHNICAL',runtime_admission=False)
    original=np.asarray(Image.open(source).convert('RGBA'))
    def rgb_codes(p):
        c=p[:,:,:3].astype(np.uint32)
        return (c[:,:,0]<<16)|(c[:,:,1]<<8)|c[:,:,2]
    r['visible_rgb_palette_from_source']=bool(np.isin(rgb_codes(pixels)[a>0],np.unique(rgb_codes(original))).all())
    r['visible_alpha_values_from_source']=bool(np.isin(a[a>0],np.unique(original[:,:,3])).all())
    if not icon:
        native = np.asarray(Image.open(source).convert('RGBA'))
        corner = native[0,0,:3]
        keyed_hue = 'cyan' if corner[1]>corner[0] else 'magenta'
        r.update(keyed_hue=keyed_hue,remaining_key_hue_pixels=r[keyed_hue+'_hue_pixels'],mask_scope='edge connected plus documented visually confirmed interior holes')
    r['technical_status']='METRICS_PASS_VISUAL_REVIEW_PENDING' if r['source_unchanged'] and r['dimensions_pass'] and r['margin_pass'] and r['edge_alpha_pixels']==0 and r['visible_rgb_palette_from_source'] and r['visible_alpha_values_from_source'] else 'HELD_METRIC'
    if r['code'] in ['SE02','SE03']:
        r['pair_body_height_px']=bbox[3]-bbox[1]
        r['pair_scale_status']='HEIGHT_BASE_NORMALIZED_CAMERA_IDENTITY_REVIEW_PENDING'
    if r['code']=='AL01':
        frames=[np.asarray(Image.open(base/'frames'/f"AL01_v02_f{i}.png")) for i in range(6)]
        # Conservative explicit stone/cloth/base ROI, separate from upper flames.
        roi=(slice(110,140),slice(65,125))
        body=[f[roi] for f in frames]
        union=np.any(np.stack([f[:,:,3]>0 for f in body]),axis=0)
        alpha_holes=[int((f[:,:,3]!=255).sum()) for f in body]
        diffs=[int(np.any(body[i][:,:,:3]!=body[0][:,:,:3],axis=2)[union].sum()) for i in range(1,6)]
        bases=[]
        for f in frames:
            fy,fx=np.where(f[:,:,3]>0); bases.append([int(fx.min()),int(fy.max()+1),int(fx.max()+1)])
        r.update(body_roi_xyxy=[65,110,125,140],body_roi_nonopaque_pixels=alpha_holes,body_rgb_changed_pixels_vs_first=diffs,frame_bases=bases,body_roi_invariance_pass=all(d==0 for d in diffs),body_opacity_roi_pass=all(d==0 for d in alpha_holes),full_body_opacity='manual review required beyond explicit ROI',anchor_definition='foreground left edge and bottom row; not animated flame',anchor_pass=all(b[:2]==bases[0][:2] for b in bases),frame_width_consistency=all(b[2]==bases[0][2] for b in bases),loop_seam_changed_pixels=int(np.any(frames[-1]!=frames[0],axis=2).sum()))
        if not r['body_roi_invariance_pass'] or not r['anchor_pass'] or not r['body_opacity_roi_pass']:r['technical_status']='HELD_ALTAR_INVARIANCE'
    reports.append(r)
assert len(reports)==34 and all(r['source_unchanged'] for r in reports)
pair=[r for r in reports if r['code'] in ['SE02','SE03']]
pair_pass=pair[0]['pair_body_height_px']==pair[1]['pair_body_height_px'] and pair[0]['bbox'][3]==pair[1]['bbox'][3]
for r in pair:
    r['pair_height_base_match']=pair_pass
    if not pair_pass:r['technical_status']='HELD_PAIR_SCALE_DIFFERENCE'
report=dict(revision='FILA-028-PREP/v01',sources=34,source_hashes_unchanged=True,reports=reports,visual_review='PENDING',runtime_admission=False,limitations=['Hue counts include legitimate object colors; not proof of residue.','Altar body ROI is a conservative sample, not whole-body segmentation.','SE02/SE03 proportional foreground scaling matches silhouette height/base, not camera geometry.'])
(base/'audit.json').write_text(json.dumps(report,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
cards=[]
for e,r in zip(manifest['entries'],reports):
    name=html.escape(e['code']+' '+e['version'])
    src=html.escape(Path(e['path']).relative_to(Path('.atena/generated')).as_posix())
    derived='normalized/'+e['code']+'_'+e['version']+'.png'
    sz=r['size'];display=f'width:{sz[0]}px;height:{sz[1]}px'
    cards.append(f'<article id="{e["code"]}"><h2>{name}</h2><p>{r["technical_status"]} · {sz[0]}×{sz[1]}</p><div class="triple">'+''.join(f'<div class="stage {bg}"><img src="{derived}" style="{display}"></div>' for bg in ['dark','light','checker'])+f'</div><details><summary>Comparar com fonte CANON</summary><img src="../{src}" style="max-width:512px;max-height:512px"></details><p>Margens {r["margins_px"]}; alfa parcial {r["fractional_alpha_pixels"]}; matiz do fundo restante {r.get("remaining_key_hue_pixels","N/A")}</p><p><a href="../{src}">Fonte CANON</a> · <a href="{derived}">PNG DRAFT</a></p></article>')
page='''<!doctype html><html lang="pt-BR"><meta charset="utf-8"><title>FILA-028 · Preparação v01</title><style>body{font:16px system-ui;background:#17191f;color:#eee;margin:24px}article{padding:18px;border:1px solid #555;margin:20px 0}h2{margin:0}a{color:#9ed9ff}.triple{display:flex;gap:12px;overflow:auto}.stage{min-width:270px;min-height:270px;display:flex;align-items:center;justify-content:center}.dark{background:#292934}.light{background:#eee}.checker{background:repeating-conic-gradient(#9b9b9b 0 25%,#ccc 0 50%) 0/20px 20px}img{image-rendering:pixelated}.loop{width:192px;height:192px;background-image:url(normalized/AL01_v02.png);animation:altar .9s steps(6) infinite}@keyframes altar{to{background-position:-1152px 0}}.pair{display:flex;gap:20px}</style><h1>FILA-028-PREP/v01 · 34 derivadas DRAFT</h1><p>Fontes CANON intactas. Sem integração no jogo. Revisão técnica/visual pendente; altar retido se falhar invariância.</p><p><a href="audit.json">Auditoria</a> · <a href="parameters.json">Parâmetros</a> · <a href="manifest.json">Manifesto</a></p><h2>Prévia do altar · loop de inspeção, duração experimental 900 ms</h2><div class="checker"><div class="loop"></div></div><h2>Câmaras SE02/SE03 · altura e base normalizadas; geometria/câmera em revisão</h2><div class="pair checker"><img width="256" height="256" src="normalized/SE02_v03.png"><img width="256" height="256" src="normalized/SE03_v02.png"></div>'''+''.join(cards)+'</html>'
(base/'index.html').write_text(page,encoding='utf-8')
print(json.dumps([dict(code=r['code'],status=r['technical_status'],margin=min(r['margins_px']),key_hue=r.get('remaining_key_hue_pixels',0)) for r in reports]))
