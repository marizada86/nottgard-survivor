from pathlib import Path
import hashlib
import json
from PIL import Image

base=Path(__file__).parent
root=base.parents[2]
proposal=json.loads((base/'admission-proposal.json').read_text(encoding='utf-8'))
assert proposal['png_count']==10 and len(proposal['entries'])==10
assert not (base/'admission-receipt.json').exists(), 'Admission already recorded'
g2=json.loads((base/'owner-approval.json').read_text(encoding='utf-8'))
g1=json.loads((base.parent/'fila026-l01-2026-10-11/owner-selection.json').read_text(encoding='utf-8'))
assert g1['selected']=='v01' and g2['gate']=='G2_ACCEPTED_PER_PIECE'
manifest_path=root/'.atena/generated/ASSET-PRODUCTION-MANIFEST-001.json'
manifest=json.loads(manifest_path.read_text(encoding='utf-8-sig'))
old_entries=manifest['entries'][:]
cursor_path=root/'data/cursor.json'
cursor=json.loads(cursor_path.read_text(encoding='utf-8-sig'))
accepted={r['code']:r['prepared_sha256'] for r in g2['records']}
accepted['L01']='5d5214fbfad023c90ecd8e46a86f8efeded578e9a8009b685d3ff2f04b4eecb5'
for e in proposal['entries']:
    assert e['sha256']==accepted[e['code']]
    assert hashlib.sha256((root/e['source']).read_bytes()).hexdigest()==e['sha256']
    target=(root/e['destination']).resolve()
    assert target.is_relative_to(root.resolve()/'assets'/'ui') and not target.exists()
    assert not any(r['final_path']==e['destination'] for r in old_entries)
# Preserve exact recovery inputs before any runtime/manifest writes.
recovery=base/'admission-recovery'
recovery.mkdir(exist_ok=True)
for source in [manifest_path,cursor_path]:
    target=recovery/source.name
    if target.exists():
        assert target.read_bytes()==source.read_bytes()
    else:
        target.write_bytes(source.read_bytes())
records=[]
for e in proposal['entries']:
    source=root/e['source']
    target=root/e['destination']
    target.parent.mkdir(parents=True,exist_ok=True)
    with target.open('xb') as output:
        output.write(source.read_bytes())
    assert hashlib.sha256(target.read_bytes()).hexdigest()==e['sha256']
    size=list(Image.open(target).size)
    record=dict(e, runtime_admission=True, size=size)
    records.append(record)
    manifest['entries'].append(dict(asset_id=target.stem, family=target.parent.relative_to(root/'assets').as_posix(),
        generation_mode='imagegen', final_path=e['destination'], candidate_path=e['source'],
        prompt_id='ART-PROMPTS-058', dimensions=f'{size[0]}x{size[1]}', alpha=True,
        references=[], status='admitted', selected_version='v01', sha256=e['sha256'],
        approval_register='.atena/vault/canon/ASSET-APPROVAL-REGISTER-031-fila026-admission-2026-10-11.json',
        qa_notes=['G1/G2 visually accepted; deterministic Godot preparation; byte-identical authorized runtime admission S013; remaining UI hookups are S014.']))
manifest['expected_png_files']+=10
assert manifest['entries'][:-10]==old_entries
manifest_path.write_text(json.dumps(manifest,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
for slot,hotspot in proposal['data_change']['hotspots'].items():
    cursor[slot]['hotspot']=hotspot
cursor['_note']='SPEC-132/MEC-058. FILA-026 v01 admitida em S013 (2026-10-11); hotspots em pixels dos PNGs finais aceitos e auditados.'
cursor_path.write_text(json.dumps(cursor,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
receipt=dict(plan='PLAN-065',spec='SPEC-132',step='S-013',date='2026-10-11',request_classification='IN_PLAN',
    authorization_verbatim='Autorizo a admissão e validação',status='ADMITTED_PENDING_VALIDATION',
    content_state='CANON_VISUAL_ADMITTED',runtime_admission=True,records=records,
    hotspots=proposal['data_change']['hotspots'],manifest='.atena/generated/ASSET-PRODUCTION-MANIFEST-001.json',
    manifest_old_entries=len(old_entries),manifest_new_entries=len(manifest['entries']),
    existing_entries_preserved=True,tests_status='PENDING',imports_status='PENDING',
    commit_authorized=False,push_authorized=False,build_authorized=False,
    recovery='admission-recovery/',next='Validate imports and existing cursor/lettering tests; S013 art commit remains gated.')
(base/'admission-receipt.json').write_text(json.dumps(receipt,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
print(json.dumps(dict(admitted=10,manifest_entries=len(manifest['entries']),existing_entries_preserved=True)))
