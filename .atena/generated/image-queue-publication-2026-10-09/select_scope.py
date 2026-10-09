from pathlib import Path
import json,subprocess
root=Path.cwd();out=Path(__file__).parent
git=lambda *a:subprocess.check_output(['git',*a]).decode('utf-8').split('\0')
tracked=[p for p in git('diff','--name-only','-z') if p]
untracked=[p for p in git('ls-files','--others','--exclude-standard','-z') if p]
prefixes=['.atena/generated/shendilavri-resume/','.atena/generated/goranthis-resume/','.atena/generated/pilares-resume/','.atena/generated/s007-reconciliation/','.atena/generated/priority-review/']
actors=['escravo_de_rivenheart','sucubo','guarda_do_castelo','master_of_cruelties','malcanthet','guardiao_de_goranthis','cultista_de_socothbenoth','death_tyrant','socothbenoth','sintese_abissal']
prefixes +=['assets/animations/enemies/'+a+'/' for a in actors]
def included(p):
 if any(p.startswith(x) for x in prefixes):return True
 if p.startswith('.atena/evidence/') and Path(p).name.startswith(('shendilavri-','goranthis-','pilares-','s007-','image-queue-publication-')):return True
 if p.startswith('.atena/generated/') and '-complete-build-validation-2026-10-' in p:return True
 if p.startswith('.atena/vault/canon/ASSET-APPROVAL-REGISTER-') and any('-'+str(i).zfill(3)+'-' in p for i in range(22,30)):return True
 if p.startswith('.atena/generated/image-queue-publication-2026-10-09/') and Path(p).parent==out.relative_to(root):return True
 if p=='.atena/specs/SPEC-121-retomada-fila-imagens/publication-checkpoint-2026-10-09.md':return True
 return False
cursor=['ui/cursor_skin.gd','ui/cursor_skin.gd.uid','data/cursor.json']
selected=sorted(set(tracked+[p for p in untracked if included(p)]))
selected=[p for p in selected if p not in cursor]
assert len(tracked)==25 and all((root/p).is_file() for p in selected)
rows=[dict(path=p,bytes=(root/p).stat().st_size) for p in selected]
assert max(r['bytes'] for r in rows)<50*1024*1024
excluded=[p for p in untracked if p not in selected and p not in cursor]
report=dict(status='SELECTED_FOR_REVIEW',files=len(rows),bytes=sum(r['bytes'] for r in rows),largest_bytes=max(r['bytes'] for r in rows),selected=rows,cursor_support_separate_commit=cursor,excluded_untracked=excluded,ignored_native_sources='remain local; no force-add',force_add_qa_logs=['.atena/generated/image-queue-publication-2026-10-09/'+n+'.log' for n in ['import-isolated','suite','smoke']])
(out/'scope.json').write_text(json.dumps(report,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
selected +=[(out/'scope.json').relative_to(root).as_posix(),(out/'art-pathspec.nul').relative_to(root).as_posix()]
(out/'art-pathspec.nul').write_bytes('\0'.join(sorted(set(selected))).encode('utf-8')+b'\0')
print(json.dumps({k:report[k] for k in ['files','bytes','largest_bytes','excluded_untracked']},ensure_ascii=False))
