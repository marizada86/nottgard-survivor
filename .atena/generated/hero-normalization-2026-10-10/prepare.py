from pathlib import Path
from PIL import Image
import hashlib, json, shutil, html

root = Path(__file__).resolve().parents[3]
source_root = Path('C:/Users/Higor Rossini/.codex/worktrees/20f4/nottgard-survivor')
source_base = source_root / '.atena/generated/erik-arlindo-complete-2026-10-09'
out = Path(__file__).parent
jobs = json.loads((source_base/'jobs.json').read_text(encoding='utf-8'))['jobs']
overrides = json.loads((source_base/'review-frame-overrides.json').read_text(encoding='utf-8'))
pilots = [dict(code=c,hero=h,destination=f'.atena/generated/art-candidates/heroes-novos/{h}/{f}',frames=n) for c,h,f,n in [('ER01','erik','er01-retrato-v01.png',1),('ER02','erik','er02-idle-v02.png',4),('AO01','arlindo','ao01-retrato-v01.png',1),('AO02','arlindo','ao02-idle-v01.png',4)]]
records=[]; cards=[]
for job in sorted(pilots+jobs,key=lambda j:j['code']):
    code=job['code']; src=source_root/job['destination']; raw=src.read_bytes()
    digest=hashlib.sha256(raw).hexdigest()
    assert job.get('sha256',digest)==digest, code+' source hash mismatch'
    dest=out/'sources'/src.name; dest.parent.mkdir(exist_ok=True); shutil.copyfile(src,dest)
    im=Image.open(src); override=overrides.get(code)
    if override: assert override['source_sha256']==digest
    status='PORTRAIT_PRESERVED' if job['frames']==1 else 'PREPARATION_READY'
    if code=='ER03': status='SEVEN_FRAMES_CANDIDATE_DECISION_BEFORE_ADMISSION'
    if code=='ER06': status='HELD_SOURCE_CLIP_FRAME6'
    frames=[]
    if override:
        for f in override['frames']:
            frame_src=source_base/f['path']; frame_dest=out/'extracted'/code/frame_src.name
            frame_dest.parent.mkdir(parents=True,exist_ok=True); shutil.copyfile(frame_src,frame_dest)
            fi=Image.open(frame_src)
            frames.append(dict(frame=f['frame'],path=frame_dest.relative_to(out).as_posix(),sha256=hashlib.sha256(frame_src.read_bytes()).hexdigest(),size=list(fi.size),alpha_bbox=fi.getchannel('A').getbbox()))
    record=dict(code=code,hero=job['hero'],status=status,source=str(src),source_sha256=digest,local_source=dest.relative_to(out).as_posix(),size=list(im.size),mode=im.mode,expected_frames=job['frames'],observed_frames=override.get('observed_frames',job['frames']) if override else None,extraction='PRIOR_REVIEW_EXTRACTION_COPIED_NOT_ADMITTED' if override else 'UNIFORM_GRID_NOT_ASSUMED_VALID',frames=frames,target=None if job['frames']==1 else dict(cell=[256,384],feet_y=368,body_height=300 if job['hero']=='erik' else 290,margin=10),content_state='DRAFT',runtime_admission=False,packing_status='NOT_PACKED')
    records.append(record)
    cards.append(f'<article><h2>{code}</h2><p>{html.escape(status)}</p><p>{job["frames"]} quadros previstos; extração conferida: {len(frames)}.</p><a href="{record["local_source"]}">Fonte preservada</a><img src="{record["local_source"]}"></article>')
    assert hashlib.sha256(src.read_bytes()).hexdigest()==digest
    assert hashlib.sha256(dest.read_bytes()).hexdigest()==digest
result=dict(plan='PLAN-053/SPEC-121/S-007',revision='DEV-024/v03',approval='atena, aprovado',approved_route='Prepare other pieces; preserve ER03 seven-frame candidate; hold ER06; decide both before integration',content_state='DRAFT',runtime_admission=False,total=20,portraits=2,strips_prepared=16,held_or_pending=['ER03','ER06'],source_hashes_passed=True,records=records,next='Validate extraction, body landmarks, shared scale and pivot, then pack separate candidates. No uniform slicing of irregular sources. Human artistic admission remains pending.')
(out/'manifest.json').write_text(json.dumps(result,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
(out/'index.html').write_text('<!doctype html><html lang="pt-BR"><meta charset="utf-8"><title>Preparação de normalização</title><style>body{background:#181e27;color:#eee;font:16px system-ui;margin:24px}main{display:grid;grid-template-columns:repeat(auto-fit,minmax(320px,1fr));gap:16px}article{background:#26303d;padding:16px}img{width:100%;background:#303843}a{color:#8bdaff}</style><h1>Erik e Arlindo — preparação DRAFT v03</h1><p>Fontes preservadas e verificadas por hash. 16 tiras preparadas para análise de extração, escala e pivô; dois retratos preservados. ER03: sete poses candidatas. ER06: separado pelo corte no quadro 6. Nenhuma tira normalizada ou integrada nesta preparação.</p><main>'+''.join(cards)+'</main></html>',encoding='utf-8')
assert len(records)==20 and sum(r['status']=='PREPARATION_READY' for r in records)==16
assert all((out/r['local_source']).is_file() for r in records)
print(json.dumps({k:v for k,v in result.items() if k!='records'},ensure_ascii=False))
