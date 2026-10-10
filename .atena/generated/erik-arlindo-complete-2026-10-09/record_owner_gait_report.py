from pathlib import Path
import json
root=Path.cwd();base=root/'.atena/generated/erik-arlindo-complete-2026-10-09';path=base/'jobs.json'
data=json.loads(path.read_text(encoding='utf-8'))
for job in data['jobs']:
    if 'move_' in job['piece']:
        job['status']='GENERATED_DRAFT_GAIT_CORRECTION_REQUIRED'
        job['visual_review']='OWNER_REPORTED_NON_ALTERNATING_GAIT; REVIEW_AND_CORRECTION_REQUIRED'
        job['owner_report_evidence']='.atena/evidence/hero-gait-owner-report-2026-10-09.md'
path.write_text(json.dumps(data,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
for file in ['plan.yaml','plan-053-imagens.yaml']:
    path=root/'.atena/state'/file
    text=path.read_text(encoding='utf-8').replace('DEV-024/REVIEW-20','DEV-024/GAIT-CORRECTION-REQUIRED')
    path.write_text(text,encoding='utf-8')
