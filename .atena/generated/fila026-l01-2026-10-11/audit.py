"""Verify rasters without modifying images; write audit and review HTML."""
from pathlib import Path
from PIL import Image
import hashlib
import json
import numpy as np

base = Path(__file__).parent
project = base.parents[2]
metadata = json.loads((base/'preview-metadata.json').read_text(encoding='utf-8'))
refs = ['assets/ui/title/title_background.png', 'assets/ui/evolucao_painel_moldura.png']
reference_hashes = {p:hashlib.sha256((project/p).read_bytes()).hexdigest() for p in refs}
cards = []
for r in metadata['records']:
    source_path = Path(r['source'])
    source = np.asarray(Image.open(source_path).convert('RGBA'))
    snapshot = base/'sources'/f'L01_{r["revision"]}.png'
    assert snapshot.read_bytes() == source_path.read_bytes()
    r['source_sha256'] = hashlib.sha256(source_path.read_bytes()).hexdigest()
    r['local_source_snapshot'] = snapshot.relative_to(base).as_posix()
    values = source[:,:,:3].astype(int)
    red, green, blue = values[:,:,0], values[:,:,1], values[:,:,2]
    key = (green>90)&(blue>90)&(green-red>25)&(blue-red>25)&(abs(green-blue)<65)
    expected = source.copy()
    expected[key] = [0,0,0,0]
    x0,y0,x1,y1 = r['padded_crop']
    native = np.asarray(Image.open(base/r['native']))
    assert np.array_equal(native, expected[y0:y1,x0:x1])
    assert int(key.sum()) == r['key_pixels_removed']
    r['key_rule'] = 'g,b>90; g-r,b-r>25; abs(g-b)<65; remove cyan key and cyan antialias residue only'
    r['checks'] = dict(source_snapshot_identical=True, crop_matches_exact_key_mask=True,
                       non_key_pixels_unchanged=True, rgba=True, proportional_resize=True,
                       exact_text_visual_review='NOTTGARD / SURVIVORS; checked letter by letter',
                       title_composite='Illustrative composition on actual title art, y=24; not a runtime capture',
                       human_style_acceptance='PENDING_G1', human_small_size_acceptance='PENDING_G1')
    r['outputs'] = {}
    for kind in ['native','final','small','title']:
        path = base/r[kind]
        im = Image.open(path)
        assert im.mode == 'RGBA', (r['revision'],kind)
        if kind != 'title':
            alpha = np.asarray(im)[:,:,3]
            assert (alpha==0).any() and (alpha>0).any()
        if kind in ['final','small']:
            limit = [1100,176] if kind=='final' else [300,48]
            assert all(a<=b for a,b in zip(im.size,limit))
            expected_scale = min(limit[0]/native.shape[1], limit[1]/native.shape[0])
            assert abs(im.width-native.shape[1]*expected_scale)<1.01
            assert abs(im.height-native.shape[0]*expected_scale)<1.01
            p = np.asarray(im).astype(int)
            cyan = (p[:,:,1]>90)&(p[:,:,2]>90)&(p[:,:,1]-p[:,:,0]>25)&(p[:,:,2]-p[:,:,0]>25)&(abs(p[:,:,1]-p[:,:,2])<65)&(p[:,:,3]>0)
            assert not cyan.any(), (r['revision'],'cyan residue')
        r['outputs'][kind] = dict(path=r[kind],size=list(im.size),sha256=hashlib.sha256(path.read_bytes()).hexdigest())
    recommendation = 'Recomendada para G1' if r['revision']=='v02' else 'Histórica: mais alta, linha inferior menor'
    cards.append(f'<article><h2>L01 {r["revision"]} · DRAFT</h2><p>{recommendation}</p><h3>Caixa do quartel 300×48 — tamanho real</h3><div class="small"><img src="{r["small"]}" width="{r["small_size"][0]}" height="{r["small_size"][1]}"></div><h3>Prévia sobre o fundo do título</h3><a href="{r["title"]}"><img class="title" src="{r["title"]}"></a><p>Composição ilustrativa 1280×720, sem integração no jogo.</p><details><summary>Recorte RGBA e fonte</summary><img class="wide" src="{r["final"]}"><p><a href="{r["local_source_snapshot"]}">Fonte ciano preservada</a> · <a href="prompt-{r["revision"]}.md">Prompt integral</a></p></details></article>')

result = dict(plan='PLAN-065',spec='SPEC-132',queue='FILA-026',step='S-009',step_position=9,total_steps=16,
              revision='L01/v02',content_state='DRAFT',runtime_admission=False,
              tool='built-in imagegen for generation/edit; Godot 4.7.2 for approved deterministic key/crop/resize',
              reference_hashes=reference_hashes, generated_candidates=2,recommended='v02',
              gate='G1_PENDING_OWNER_STYLE_AND_300x48_REVIEW',records=metadata['records'],
              next='After G1: L03 victory banner, then L04/L05/P01/P02/P03/C01/C02/C03. L02 remains optional. No automatic admission, commit or push.')
(base/'audit.json').write_text(json.dumps(result,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
(base/'index.html').write_text('<!doctype html><html lang="pt-BR"><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>FILA-026 · L01 · G1</title><style>body{background:#141824;color:#eee;font:16px system-ui;margin:24px;max-width:1280px}article{padding:18px;background:#232638;border:1px solid #46405c;margin:24px 0;border-radius:10px}a{color:#bddbff}.small{width:300px;height:48px;background:#15111f;display:flex;align-items:center;justify-content:center;outline:1px solid #635779;margin:15px 0}.small img{image-rendering:pixelated;max-width:none}.title,.wide{max-width:100%;height:auto}h3{font-size:16px}.notice{padding:14px;background:#39304b}p{line-height:1.5}</style><h1>L01 · logo — DRAFT v02</h1><p class="notice">PLAN-065 · etapa 9/16 · portão G1 pendente. Avalie o tom ouro/ferro/roxo e a leitura das duas palavras na caixa 300×48. A v02 é recomendada; nenhuma versão foi admitida, promovida a CANON, commitada ou publicada.</p><p>Grafia conferida: NOTTGARD / SURVIVORS. Prévia técnica aprovada: chave removida, transparência, cortes e redução proporcional verificados. Legibilidade e gosto visual final aguardam o dono.</p><p><a href="audit.json">Auditoria</a> · <a href="../hero-normalization-2026-10-10/extraction-review.html">Revisão das tiras de Erik/Arlindo</a></p>'+''.join(reversed(cards))+'<p>Após G1: L03 Vitória!, seguindo a ordem aprovada. O portão G2 e a admissão permanecem separados.</p></html>',encoding='utf-8')
print(json.dumps(dict(revisions=2, technical_checks='PASS', gate=result['gate'], recommended='v02', source_hashes=[r['source_sha256'] for r in metadata['records']]),ensure_ascii=False))
if (base/'owner-selection.json').is_file():
    import runpy
    runpy.run_path(str(base/'reconcile_selection.py'), run_name='__main__')
