from pathlib import Path
from PIL import Image
import hashlib
import html
import json
import numpy as np

base = Path(__file__).parent
manifest = json.loads((base/'manifest.json').read_text(encoding='utf-8'))
review = json.loads((base/'extraction-review-v01.json').read_text(encoding='utf-8'))
for r in manifest['records']:
    assert hashlib.sha256((base/r['local_source']).read_bytes()).hexdigest() == r['source_sha256']
    for f in r['frames']:
        assert hashlib.sha256((base/f['path']).read_bytes()).hexdigest() == f['sha256']
cards = []
verified = 0
for r in review['records']:
    source = np.asarray(Image.open(base/r['source']))
    arrays = []
    previews = []
    for f in r['frames']:
        path = base/f['path']
        pixels = np.asarray(Image.open(path))
        x, y, w, h = f['rect']
        assert np.array_equal(pixels, source[y:y+h, x:x+w]), (r['code'], f['frame'])
        f['sha256'] = hashlib.sha256(path.read_bytes()).hexdigest()
        f['size'] = [w, h]
        arrays.append(pixels)
        verified += 1
        previews.append(f'<figure><img src="{f["path"]}"><figcaption>Quadro {f["frame"]} · {w}×{h}</figcaption></figure>')
    if arrays:
        assert np.array_equal(np.concatenate(arrays, axis=1), source), r['code']
    label = 'Extração candidata — escala e pivô pendentes' if arrays else 'Separação por retângulos retida — não extraída'
    cards.append(f'<article><h2>{r["code"]}</h2><p>{label}</p><details><summary>Fonte e limites candidatos</summary><div class="source"><img src="{r["source"]}">'+''.join(f'<i style="left:{b["x"]/r["source_size"][0]*100:.5f}%"></i>' for b in r['boundaries'])+'</div><p>'+html.escape(str(r['boundaries']))+'</p></details><div class="frames">'+''.join(previews)+'</div></article>')
review['verification'] = dict(native_frames=verified, pixel_identical_to_source=True, full_source_reconstruction_passed=True,
                              sources_verified=20, prior_extractions_unchanged=True, discarded_pixels=0,
                              normalized=False, runtime_admission=False)
(base/'extraction-review-v01.json').write_text(json.dumps(review, ensure_ascii=False, indent=2)+'\n', encoding='utf-8')
(base/'extraction-review.html').write_text('<!doctype html><html lang="pt-BR"><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>Erik e Arlindo — revisão de extração</title><style>body{background:#141a23;color:#eee;font:16px system-ui;margin:24px}article{padding:16px;background:#222d3b;margin:20px 0}a{color:#9cddff}.frames{display:flex;flex-wrap:wrap;gap:12px}figure{margin:0}figure img{height:280px;max-width:100%;object-fit:contain;background:repeating-conic-gradient(#59606a 0% 25%,#333b45 0% 50%) 0 0/20px 20px}figcaption{font-size:13px}.source{position:relative}.source img{width:100%}.source i{position:absolute;top:0;bottom:0;border-left:2px solid #ff5e82}details p{overflow-wrap:anywhere;font-size:12px}</style><h1>Erik e Arlindo — DRAFT · extração v01</h1><p>11 fontes revisadas; seis tiras extraídas em 30 quadros nativos. Cada pixel RGBA preservado, incluindo alfa baixo. Nenhuma escala, pivô, correção de passada ou integração aplicada.</p><p>Cinco tiras retidas: AO09, AO10, ER08, ER09, ER10. ER03 (sete poses) e ER06 (corte de fonte) mantêm os gates anteriores. Cinco outras tiras conservam a extração histórica. O contorno de alfa inclui efeitos e não comprova a altura do corpo.</p><p><a href="index.html">Todas as 20 fontes</a> · <a href="extraction-review-v01.json">Auditoria e retângulos</a></p>'+''.join(cards)+'</html>', encoding='utf-8')
assert verified == 30
print(json.dumps(review['verification']))
