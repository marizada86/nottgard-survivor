from pathlib import Path
import hashlib, html, json, os, shutil, subprocess
from PIL import Image
import numpy as np

out = Path(__file__).resolve().parent
root = out.parents[2]
ref = '10bd31c'
base = '.atena/generated/s007-reconciliation/v01/'
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
def blob(name):
    return subprocess.check_output(['git', 'show', ref + ':' + base + name], cwd=root)
def load(name):
    return json.loads(blob(name).decode('utf-8-sig'))
def save(name, value):
    (out / name).write_text(json.dumps(value, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')

protected = {p.relative_to(root).as_posix(): sha(p) for folder in ['assets', 'core', 'ui', 'data', 'tests'] for p in (root / folder).rglob('*') if p.is_file()}
save('protected.json', protected)
for name in ['plan.yaml', 'plan-053-imagens.yaml', 'onda-cortante-review.yaml']:
    dst = out / 'before' / name
    dst.parent.mkdir(parents=True, exist_ok=True)
    shutil.copy2(root / '.atena/state' / name, dst)
history = ['onda-cortante-sequence-audit-2026-10-09.json', 'r01-owner-approval-2026-10-09.json', 'r01-owner-gate-2026-10-09.json', 'onda-cortante-eight-frame-review-2026-10-09.png', 'onda-cortante-flight-review-2026-10-09.gif', 'onda-cortante-impact-review-2026-10-09.gif', 'qr-generation-jobs-2026-10-09.json', 'rn-generation-jobs-2026-10-09.json']
for name in history:
    dst = out / 'provenance' / name
    dst.parent.mkdir(parents=True, exist_ok=True)
    dst.write_bytes(blob(name))
jobs = load(history[-2])['jobs'] + load(history[-1])['jobs']
entries = load(history[0])['sources']
selected, metrics = [], []
for e in entries:
    job = next(j for j in jobs if j.get('sha256') == e['sha256'])
    original = Path(job['original_path'])
    dst = root / e['path']
    source = dst if dst.exists() else original
    assert source.is_file() and sha(source) == e['sha256'], (e['code'], str(source))
    dst.parent.mkdir(parents=True, exist_ok=True)
    if not dst.exists():
        shutil.copy2(source, dst)
    assert sha(dst) == e['sha256']
    selected.append(dict(e, archived_original=str(original), prompt=job['prompt'], human_acceptance='R01_HISTORICAL_APPROVED' if e['code'] == 'R01' else 'PENDING_VISUAL_ACCEPTANCE'))
    with Image.open(dst) as im:
        a = np.array(im.convert('RGB'))
        lum = a.max(axis=2)
        yy, xx = np.where(lum > 12)
        edge = int(max(lum[0].max(), lum[-1].max(), lum[:,0].max(), lum[:,-1].max()))
        assert im.size == (1254,1254) and edge <= 12, (e['code'], im.size, edge)
        metrics.append({'code':e['code'], 'version':e['version'], 'sha256':sha(dst), 'size':list(im.size), 'mode':im.mode, 'edge_max_channel':edge, 'max_channel_difference':int((a.max(axis=2).astype(int)-a.min(axis=2).astype(int)).max()), 'bbox_gt12':[int(xx.min()),int(yy.min()),int(xx.max()+1),int(yy.max()+1)], 'native_bytes_preserved':True})
assert selected[0]['sha256'] == '53f665277345e5a59d093f25e5f3f9ebfd800a1b146c535d0b48513b4e4308f1'
save('recovery.json', {'revision':'onda-cortante-review/v01', 'classification':'IN_PLAN', 'mode':'per-plan', 'owner_reply':'aprovado, continue', 'source_record_ref':ref, 'sources':selected, 'historical_approval':load(history[1]), 'new_generation':0, 'runtime_admission':False, 'canonical_promotion':False})
save('audit.json', {'status':'PASS_NATIVE_RECOVERY', 'sources':metrics, 'normalized':False, 'exact_black_or_grayscale':'NOT_CLAIMED', 'historical_flight_centroid_spread_normalized':load(history[0])['flight_centroid_spread_normalized'], 'centroid_note':'Historical hot-light proxy; not exact pivot or runtime approval'})
page = '''<!doctype html><html lang="pt-BR"><meta charset="utf-8"><title>Onda Cortante — DRAFT v01</title><style>body{background:#171c24;color:#eee;font:16px system-ui;max-width:1100px;margin:32px auto;padding:0 16px}h1,h2{color:#e5c178}.grid{display:grid;grid-template-columns:repeat(4,1fr);gap:16px}.native{width:100%}.small{width:96px;height:96px}figure{margin:0}small{overflow-wrap:anywhere}.motion{display:flex;gap:24px;flex-wrap:wrap}</style><h1>Onda Cortante · oito quadros DRAFT</h1><p>R01 v02 aprovado historicamente. R02–R08 aguardam aceite visual. Fontes nativas intactas; prévias históricas abaixo, cadência ilustrativa. Nada admitido neste lote.</p><div class="motion"><figure><img src="provenance/onda-cortante-flight-review-2026-10-09.gif" width="320" height="320"><figcaption>Voo R01–R04: verificar fechamento R04→R01.</figcaption></figure><figure><img src="provenance/onda-cortante-impact-review-2026-10-09.gif" width="320" height="320"><figcaption>Impacto R05–R08: flash, fragmentos e dissipação.</figcaption></figure></div><p>Observar crescente para a direita, pontas para a esquerda, raios finos, continuidade e legibilidade a 96 px. Ritmo e tamanho em jogo ficam para admissão/playtest.</p><div class="grid">'''
for e in selected:
    url = html.escape(os.path.relpath(root / e['path'], out).replace('\\','/'))
    page += f'<figure><h2>{e["code"]} {e["version"]}</h2><a href="{url}"><img class="native" src="{url}"></a><img class="small" src="{url}"><p>{e["human_acceptance"]}</p><small>{e["sha256"]}</small></figure>'
(out / 'index.html').write_text(page + '</div></html>', encoding='utf-8')
assert all(sha(root / p) == h for p,h in protected.items())
state = root / '.atena/state/onda-cortante-review.yaml'
s = state.read_text(encoding='utf-8').replace('checkpoint: S-001/VERIFY_AUTHORITY_AND_INPUTS','checkpoint: S-003/VISUAL_REVIEW').replace('current_step_position: 1','current_step_position: 3').replace('completed_steps: 0','completed_steps: 2').replace('remaining_steps_after_current: 3','remaining_steps_after_current: 1')
state.write_text(s, encoding='utf-8')
print('PASS: eight sources restored by exact hashes; native margins verified; runtime unchanged. S-001/S-002 complete.')
