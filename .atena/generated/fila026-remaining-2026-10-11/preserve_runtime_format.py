from pathlib import Path
import json

base=Path(__file__).parent
root=base.parents[2]
path=root/'.atena/generated/ASSET-PRODUCTION-MANIFEST-001.json'
current=json.loads(path.read_text(encoding='utf-8-sig'))
prior=(base/'admission-recovery/ASSET-PRODUCTION-MANIFEST-001.json').read_bytes().decode('utf-8-sig')
newline='\r\n' if '\r\n' in prior else '\n'
marker=newline+'                ],'+newline+'    "logical_reuse"'
assert prior.count(marker)==1
added=(',\n'.join('\n'.join('                    '+line for line in json.dumps(e,ensure_ascii=False,indent=4).splitlines()) for e in current['entries'][-10:])).replace('\n',newline)
updated=prior.replace('"expected_png_files":  269','"expected_png_files":  279',1)
updated=updated.replace(marker,','+newline+added+marker,1)
assert json.loads(updated)==current
path.write_bytes(updated.encode('utf-8'))
path=root/'data/cursor.json'
cursor=json.loads(path.read_text(encoding='utf-8'))
prior=(base/'admission-recovery/cursor.json').read_bytes().decode('utf-8-sig')
old=json.loads(prior)
updated=prior.replace(json.dumps(old['_note'],ensure_ascii=False),json.dumps(cursor['_note'],ensure_ascii=False),1)
updated=updated.replace('"hotspot": [2, 2]','"hotspot": [1, 1]',1).replace('"hotspot": [10, 2]','"hotspot": [4, 1]',1)
assert json.loads(updated)==cursor
path.write_bytes(updated.encode('utf-8'))
print('Manifest and cursor semantics verified; existing formatting preserved.')
