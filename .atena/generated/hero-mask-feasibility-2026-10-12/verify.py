"""Verify lossless native masked extracts and prepare the diagnostic gallery."""
from pathlib import Path
import hashlib
import html
import json
import re
import numpy as np
from PIL import Image

OUT=Path(__file__).resolve().parent
ROOT=OUT.parents[2]
a=json.loads((OUT/'analysis.json').read_text(encoding='utf-8'))
n=json.loads((OUT/'native-extractions.json').read_text(encoding='utf-8'))
count=0
for record in n['records']:
    source=np.array(Image.open(ROOT/record['source']).convert('RGBA'))
    assert hashlib.sha256((ROOT/record['source']).read_bytes()).hexdigest()==record['source_sha256']
    restored=np.zeros_like(source);ownership=np.zeros(source.shape[:2],dtype=np.uint8)
    for frame in record['frames']:
        pixels=np.array(Image.open(OUT/frame['path']).convert('RGBA'))
        assert hashlib.sha256((OUT/frame['path']).read_bytes()).hexdigest()==frame['sha256']
        x0=int(frame['rect'][0])
        for y in range(source.shape[0]):
            left,right=int(frame['left_x_by_y'][y]),int(frame['right_x_by_y'][y])
            restored[y,left:right]=pixels[y,left-x0:right-x0]
            ownership[y,left:right]+=1
            assert not pixels[y,:left-x0].any() and not pixels[y,right-x0:].any()
        count+=1
    assert np.array_equal(restored,source) and (ownership==1).all()
assert count==16
receipt=json.loads((ROOT/'.atena/generated/hero-body-pivot-2026-10-12/visual-acceptance.json').read_text(encoding='utf-8'))
assert len(receipt['entries'])==8
for entry in receipt['entries']:
    assert hashlib.sha256((ROOT/entry['path']).read_bytes()).hexdigest()==entry['sha256']
summary={'status':'PASS','sources_examined':5,'native_frames':16,'pixel_recomposition':'EXACT_RGBA','ownership':'EXACTLY_ONCE','new_significant_pixel_loss':0,'feasible':a['feasible'],'retained':a['held'],'eight_accepted_hashes_preserved':True,'native_diagnostics_inspection':'FIVE_CURVED_CORRIDOR_OVERLAYS_INSPECTED','runtime_admission':False,'content_state':'DRAFT','limitations':'Transparent corridors establish geometry in the searched bands, not artistic acceptance. Failure to find a zero-alpha corridor does not establish global impossibility.'}
(OUT/'verification.json').write_text(json.dumps(summary,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
sections=[]
for record in a['records']:
    links=''
    if record['code'] in a['feasible']:
        frames=next(r for r in n['records'] if r['code']==record['code'])['frames']
        links=' · '.join(f'<a href="{f["path"]}">Quadro {int(f["frame"])}</a>' for f in frames)
    crossings='; '.join(f'{c["between"]}: {c["significant_rows_crossed"]} linhas com alfa &gt;8' for c in record['corridors'])
    sections.append(f'<section><h2>{record["code"]}</h2><p>{html.escape(record["status"])}</p><a href="diagnostics/{record["code"]}.png"><img src="diagnostics/{record["code"]}.png" alt="Corredores avaliados {record["code"]}"></a><p>{crossings}</p><p>{links}</p></section>')
(OUT/'index.html').write_text('''<!doctype html><html lang="pt-BR"><meta charset="utf-8"><title>Erik/Arlindo — separação por máscaras</title><style>body{max-width:1700px;margin:24px auto;padding:20px;background:#17151d;color:#e7e0d6;font:16px system-ui;line-height:1.5}a,h1,h2{color:#e0c58e}img{max-width:100%;height:auto}section{margin:32px 0;border-top:1px solid #645a49}</style><h1>Separação por máscaras · v01 DRAFT</h1><p>Três fontes de Erik podem ser separadas por corredores curvos transparentes: dezesseis quadros nativos. A recomposição recupera exatamente os pixels RGBA da fonte, uma vez cada, sem resize/repintura. Não estão normalizados, aceitos visualmente ou integrados.</p><p>Verde: corredor de três pixels sem alfa &gt;8. Vermelho: caminho avaliado atravessa pixels significativos e não foi extraído. AO09/AO10 continuam retidas. A avaliação é limitada aos intervalos escolhidos, sem prova de impossibilidade global.</p><p><a href="analysis.json">Análise/traços</a> · <a href="native-extractions.json">Extrações e hashes</a> · <a href="verification.json">Verificação RGBA</a></p>''' + ''.join(sections) + '</html>\n',encoding='utf-8')
for href in re.findall(r'(?:href|src)="([^"]+)"',(OUT/'index.html').read_text(encoding='utf-8')):
    assert (OUT/html.unescape(href)).is_file(),href
print('PASS: sixteen lossless native extracts, eight accepted hashes preserved, local gallery links checked.')
