from pathlib import Path
import json,subprocess,hashlib
root=Path.cwd();out=Path(__file__).parent;read=lambda p:p.read_text(encoding='utf-8-sig');save=lambda p,d:p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8');git=lambda *a:subprocess.check_output(['git',*a]).decode('utf-8')
scope=json.loads(read(out/'scope.json'));selected=set(scope['selected']);staged=set(x for x in git('diff','--cached','--name-only','-z').split('\0') if x);assert staged==selected,(staged-selected,selected-staged)
subprocess.run(['git','-c','core.whitespace=-blank-at-eof','diff','--cached','--check'],check=True)
assert all(p.startswith('.atena/') and '/art-candidates/' not in p and '/local-profile/' not in p and 'unit-profile' not in p for p in staged)
v=json.loads(read(out/'validation.json'));assert v['status']=='PASSED';v.update(staged_files_checked=len(staged),staged_diff_check='PASSED',payload='Metadata, previews, source audits and operational records only',staged_preview_bytes=sum((root/p).stat().st_size for p in staged if Path(p).suffix in ['.png','.gif']),staged_paths=sorted(staged));save(out/'validation.json',v)
print(json.dumps(dict(status='SEALED_READY_TO_COMMIT',files=len(staged),preview_bytes=v['staged_preview_bytes'],runtime_changes=False)))
