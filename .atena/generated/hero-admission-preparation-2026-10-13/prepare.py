from pathlib import Path
import hashlib, json, shutil, struct, html

ROOT = Path(__file__).resolve().parents[3]
SOURCE = Path('C:/Users/Higor Rossini/.codex/worktrees/ffff/nottgard-survivor')
OUT = Path(__file__).resolve().parent
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
def read(p):
    return json.loads(p.read_text(encoding='utf-8-sig'))
def png(p):
    b = p.read_bytes()
    assert b[:8] == b'\x89PNG\r\n\x1a\n', p
    w, h = struct.unpack('>II', b[16:24])
    return {'size': [w,h], 'color_type': b[25], 'alpha_channel': b[25] in (4,6)}
def mirror(rel, expected=None):
    src, dst = SOURCE/rel, ROOT/rel
    digest = sha(src)
    if expected: assert digest == expected, rel
    dst.parent.mkdir(parents=True, exist_ok=True)
    if dst.exists(): assert sha(dst) == digest, f'Existing local file differs: {rel}'
    else: shutil.copy2(src,dst)
    assert sha(dst)==digest
    return digest

protected = {p.relative_to(ROOT).as_posix(): sha(p) for folder in ['assets','core','ui','data','tests'] for p in (ROOT/folder).rglob('*') if p.is_file()}
inventory_rel = '.atena/generated/hero-final-four-2026-10-13/accepted-hero-inventory.json'
mirror(inventory_rel)
inventory = read(ROOT/inventory_rel)
assert inventory['accepted_strips']==18 and inventory['accepted_frames']==101
source_manifest_rel = '.atena/generated/hero-normalization-2026-10-10/manifest.json'
mirror(source_manifest_rel)
source_manifest = read(ROOT/source_manifest_rel)
for rel in ['.atena/state/hero-final-four.yaml','.atena/state/plan.yaml','.atena/evidence/hero-final-four-2026-10-13.md']:
    dst = OUT/'provenance'/Path(rel).name
    dst.parent.mkdir(parents=True,exist_ok=True)
    shutil.copy2(SOURCE/rel,dst)
    assert sha(dst)==sha(SOURCE/rel)
for rel in ['.atena/generated/hero-final-four-2026-10-13/manifest.json','.atena/generated/hero-wide-actions-2026-10-12/manifest.json']:
    mirror(rel)
rows=[]
for e in inventory['selected']:
    mirror(e['path'],e['sha256']); mirror(e['receipt'])
    hero = 'arlindo' if e['code'].startswith('AO') else 'erik'
    action={2:'idle',3:'move_e',4:'move_se',5:'move_s',6:'move_ne',7:'move_n',8:'attack',9:'active',10:'death'}[int(e['code'][2:])]
    info=png(ROOT/e['path'])
    assert info['size']==[e['cell'][0]*e['frames'],e['cell'][1]]
    assert info['alpha_channel']
    target=f'assets/animations/heroes/{hero}/{action}.png'
    current=ROOT/target
    rows.append(dict(e,hero=hero,animation=action,proposed_destination=target,current_sha256=sha(current),current_png=png(current),candidate_png=info,bytes_equal=sha(current)==e['sha256']))
portraits=[]
for e in source_manifest['records']:
    if e['code'] not in ('AO01','ER01'): continue
    rel='.atena/generated/hero-normalization-2026-10-10/'+e['local_source']
    mirror(rel,e['source_sha256'])
    target=f"assets/portraits/{e['hero']}.png"
    portraits.append({'code':e['code'],'hero':e['hero'],'revision':'v01','content_state':'DRAFT_PRESERVED_SOURCE','candidate':rel,'sha256':e['source_sha256'],'png':png(ROOT/rel),'destination':target,'current_sha256':sha(ROOT/target),'bytes_equal':sha(ROOT/target)==e['source_sha256'],'human_acceptance_this_checkpoint':'PENDING'})
assert len(rows)==18 and sum(e['frames'] for e in rows)==101 and len(portraits)==2
assert all(sha(ROOT/rel)==digest for rel,digest in protected.items())
report={'revision':'hero-admission-preparation/v01','date':'2026-10-13','origin':'pre-implementation-preparation','request':'Atena vamos continuar o Próximo checkpoint: conferir os retratos e preparar a admissão dos assets.','source_workspace':str(SOURCE),'content_state':'DRAFT','portrait_count':2,'accepted_strips':18,'accepted_frames':101,'portraits':portraits,'animations':rows,'runtime_protected_files':len(protected),'runtime_unchanged':True,'admission_executed':False,'canonical_promotion':False,'proposal_approval':'PENDING','protected_hashes':protected}
(OUT/'admission-manifest.json').write_text(json.dumps(report,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
parts=['<!doctype html><html lang="pt-BR"><meta charset="utf-8"><title>Retratos e admissão — DRAFT v01</title><style>body{background:#151a20;color:#eee;font:16px system-ui;max-width:1180px;margin:32px auto}h1,h2{color:#edc180}.grid{display:grid;grid-template-columns:1fr 1fr;gap:18px}img{width:100%;height:auto;background:#252b33}figure{margin:0}small{overflow-wrap:anywhere}table{width:100%;border-collapse:collapse}td,th{padding:9px;border-bottom:1px solid #444;text-align:left}</style><h1>Retratos e preparação da admissão</h1><p>DRAFT v01 · AO01/ER01 v01 · 18 tiras/101 quadros aceitos anteriormente. Nenhuma admissão executada.</p>']
def url(rel):
    import os
    return html.escape(os.path.relpath(ROOT/rel,OUT).replace('\\','/'))
for p in portraits:
    idle=next(e for e in rows if e['hero']==p['hero'] and e['animation']=='idle')
    parts.append(f'<h2>{p["code"]} — {p["hero"].title()}</h2><div class="grid"><figure><img src="{url(p["candidate"])}"><figcaption>Candidata v01 · 1536×1024 · fonte preservada</figcaption></figure><figure><img src="{url(p["destination"])}"><figcaption>Retrato atual · {"mesmos bytes" if p["bytes_equal"] else "bytes diferentes"}</figcaption></figure></div><p><small>SHA-256 {p["sha256"]}</small></p><p>Idle DRAFT aceito ({idle["revision"]}):</p><img src="{url(idle["path"])}"><p>Avaliar rosto, idade/porte, vestuário, acessórios, luz e acabamento. Aceite visual e promoção CANON não são inferidos desta comparação.</p>')
parts.append('<h2>Destinos propostos</h2><table><tr><th>Código</th><th>Destino</th><th>Quadros</th><th>Célula candidata</th></tr>')
for r in rows:
    parts.append(f'<tr><td>{r["code"]}</td><td>{r["proposed_destination"]}</td><td>{r["frames"]}</td><td>{r["cell"][0]}×{r["cell"][1]}</td></tr>')
parts.append('</table><p>O runtime atual usa célula única 384×384 por herói; as candidatas misturam 256×384 e 512×512. Não copiar diretamente. O plano propõe derivados 512×512 sem redimensionar corpo, alinhando base e centro por translação validada.</p></html>')
(OUT/'index.html').write_text('\n'.join(parts),encoding='utf-8')
print(json.dumps({'portraits':portraits,'strips':len(rows),'frames':sum(e['frames'] for e in rows),'candidate_cells':sorted({tuple(e['cell']) for e in rows}),'protected_files':len(protected),'unchanged':True},ensure_ascii=False,indent=2))
