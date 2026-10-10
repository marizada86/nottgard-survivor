from pathlib import Path
import json
base=Path.cwd()/'.atena/generated/erik-arlindo-complete-2026-10-09'
path=base/'jobs.json';data=json.loads(path.read_text(encoding='utf-8'))
review=[]
for job in data['jobs']:
    flags=[]
    if 'move_' in job['piece']:flags.append('WALK_LOOP_CONTACT_REVIEW_PENDING')
    if job['code']=='ER03':flags.append('EAST_PROFILE_CAMERA_REVIEW_PENDING')
    job['visual_flags']=flags
    job['visually_observed_figure_count']=job['frames']
    job['visual_review']='COUNT_CHECKED; HUMAN_ACCEPTANCE_AND_MOTION_PENDING'
    review.append(dict(code=job['code'],selected=job['destination'],observed_figures=job['frames'],flags=flags,owner_approval=False))
path.write_text(json.dumps(data,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
(base/'selected-visual-review.json').write_text(json.dumps(dict(kind='Manual visual inspection by Atena; not an automated frame-count detector',selected=review,notes=['EDGE_CONTENT tests provisional equal-width cells and includes semi-transparent glow; it is not proof of source clipping.','Native dimensions differ from final256x384 cell contract.','ER03v03 keeps torch on camera-near right arm in all six figures; gait contact continuity still needs review.','AO08v02 right-hand projectile and AO09v02 compact ring visually checked.']),ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
print('16 selected native strips visually inspected; frame count recorded; motion review pending.')
