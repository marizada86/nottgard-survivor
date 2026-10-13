"""Independent raster verification of wide-action packing and protection contract."""
from pathlib import Path
import hashlib
import json
import statistics
import subprocess
import numpy as np
from PIL import Image

OUT=Path(__file__).resolve().parent
ROOT=OUT.parents[2]
def sha(path):return hashlib.sha256(path.read_bytes()).hexdigest()
m=json.loads((OUT/'manifest.json').read_text(encoding='utf-8'))
p=json.loads((OUT/'preparation.json').read_text(encoding='utf-8'))
protected=json.loads((OUT/'protected-snapshot.json').read_text(encoding='utf-8'))
for path,expected in protected.items():
    if path.endswith('#prior_tail'):
        actual=hashlib.sha256((ROOT/'.atena/state/plan.yaml').read_text(encoding='utf-8').split('hero_mask_feasibility_2026_10_12:',1)[1].encode()).hexdigest()
    else:actual=sha(ROOT/path)
    assert actual==expected,path
assert subprocess.check_output(['git','rev-parse','HEAD'],cwd=ROOT).decode().strip()==m['head_before']
assert not subprocess.check_output(['git','diff','--cached','--name-only'],cwd=ROOT).strip()
records=[];count=0
for source,result in zip(m['records'],p['records']):
    assert source['code']==result['code'] and not source['fit_conflict']
    assert sha(ROOT/source['source'])==source['source_sha256']
    ref=source['idle_reference'];assert sha(ROOT/ref['path'])==ref['sha256']
    atlas=np.array(Image.open(OUT/result['strip']).convert('RGBA'))
    assert atlas.shape==(512,len(source['frames'])*512,4)
    frames=[]
    for inp,out in zip(source['frames'],result['frames']):
        assert sha(ROOT/inp['path'])==inp['sha256']
        index=int(out['frame'])
        image=np.array(Image.open(OUT/out['path']).convert('RGBA'));assert image.shape==(512,512,4)
        assert np.array_equal(image,atlas[:,(index-1)*512:index*512,:])
        a=image[:,:,3];assert not np.any((a>0)&(a<=8))
        yy,xx=np.where(a>8);bbox=[int(xx.min()),int(yy.min()),int(xx.max()+1),int(yy.max()+1)]
        margins=[bbox[0],bbox[1],512-bbox[2],512-bbox[3]];assert min(margins)>=10
        px,py,width,height=out['paste_rect'];sx,sy,sw,sh=out['used_rect']
        assert [sx,sy,sx+sw,sy+sh]==inp['significant_bbox']
        scale=source['requested_scale'];assert abs(out['scale']-scale)<=.000002
        assert abs(width-sw*scale)<=.501 and abs(height-sh*scale)<=.501
        # Independently map anatomical coordinates through the integer resize,
        # rather than asserting only the placement values printed by Godot.
        actual_floor=py+(inp['ground_y']-sy)*(height/sh)
        actual_center=px+(inp['hip_x']-sx)*(width/sw)
        assert abs(actual_floor-448)<=1.01 and abs(actual_center-256)<=1.01
        frames.append({'frame':index,'path':out['path'],'sha256':sha(OUT/out['path']),'bbox':bbox,'margins_px':margins,'significant_bottom':bbox[3],'ground_coordinate_resize':actual_floor,'body_center_coordinate_resize':actual_center,'ground_error_px':abs(actual_floor-448),'center_error_px':abs(actual_center-256),'scale':scale,'body_marker_height':448-out['head_y_geometry'],'pose':inp['pose']})
        count+=1
    assert len({f['scale'] for f in frames})==1
    reference=statistics.median(f['body_marker_height'] for f in frames) if source['code']=='AO08' else frames[0]['body_marker_height']
    assert abs(reference-source['reference_body_height'])<=1
    records.append({'code':source['code'],'strip':result['strip'],'sha256':sha(OUT/result['strip']),'size':[len(frames)*512,512],'uniform_scale':source['requested_scale'],'scale_reference_px':source['reference_body_height'],'reference_measured_px':reference,'scale_basis':source['scale_basis'],'all_frames_fit':True,'frames':frames,'technical_status':'PASS','human_visual_acceptance':'PENDING','content_state':'DRAFT','runtime_admission':False})
assert count==20 and len(records)==4
accepted=(OUT/'visual-acceptance.json').exists()
if accepted:
    receipt=json.loads((OUT/'visual-acceptance.json').read_text(encoding='utf-8'))
    assert len(receipt['entries'])==4
    for entry in receipt['entries']:
        record=next(r for r in records if r['code']==entry['code'])
        assert entry['sha256']==record['sha256']
        record['human_visual_acceptance']='APPROVED_EXPLICITLY_DRAFT'
log=(OUT/'preparation-log.txt').read_text(encoding='utf-8');assert 'SCRIPT ERROR' not in log
audit={'status':'TECHNICAL_PASS_OWNER_REVIEW_PENDING','plan':'PLAN-053/DEV-024/hero-wide-actions-v01','strips':4,'frames':20,'cell':[512,512],'guard_px':10,'minimum_margin_px':min(min(f['margins_px']) for r in records for f in r['frames']),'maximum_ground_error_px':max(f['ground_error_px'] for r in records for f in r['frames']),'maximum_center_error_px':max(f['center_error_px'] for r in records for f in r['frames']),'sources_unchanged':True,'protected_hashes':len(protected),'prior_eight_accepted_candidates_preserved':True,'prior_tail_preserved':True,'head_unchanged':m['head_before'],'index_empty':True,'per_frame_zoom':False,'repaint_or_regeneration':False,'runtime_admission':False,'canonical_promotion':False,'commit_push_export':False,'human_visual_acceptance':'PENDING','pose_criteria':'Crouch and fall retain their native compression, never scaled to standing height per frame. Ground/head markers have source-space uncertainty and do not prove artistic mass consistency.','preexisting_engine_warning':'Failed to read root certificate store','new_script_errors':0,'records':records}
if accepted:
    audit['status']='TECHNICAL_PASS_VISUALLY_ACCEPTED_DRAFT'
    audit['human_visual_acceptance']='FOUR_WIDE_V01_APPROVED_EXPLICITLY_DRAFT'
(OUT/'audit.json').write_text(json.dumps(audit,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
print('PASS:',count,'cells, four strips, source/protected hashes, crop/guard, pose anchors, uniform scale, prior accepted idles.')
print('Minimum margin',audit['minimum_margin_px'],'max floor error',round(audit['maximum_ground_error_px'],3),'max center error',round(audit['maximum_center_error_px'],3),'protected',len(protected))
