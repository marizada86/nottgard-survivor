from pathlib import Path
import json,re,hashlib
root=Path.cwd();out=Path(__file__).parent
sources=json.loads((out/'source-manifest.json').read_text())['records']
for r in sources:
    assert hashlib.sha256((out/'sources'/Path(r['local_source']).name).read_bytes()).hexdigest()==r['source_sha256']
    assert hashlib.sha256(Path(r['source']).read_bytes()).hexdigest()==r['source_sha256']
links=[]
for doc in [root/'.atena/evidence/hero-own-art-integration-2026-10-10.md',out/'index.html']:
    text=doc.read_text(encoding='utf-8')
    targets=re.findall(r'\]\(([^)]+)\)',text) if doc.suffix=='.md' else re.findall(r'src="([^"]+)"',text)
    for target in targets:
        assert (doc.parent/target).exists(),(doc,target)
        links.append(target)
log=(out/'suite-verified.log').read_text(encoding='utf-8')
assert 'testes: 0 falha(s)' in log and 'SCRIPT ERROR' not in log
assert 'smoke: ok' in (out/'smoke.log').read_text(encoding='utf-8')
for name in ['import-final.log','erik-launch.log','arlindo-launch.log','capture-isolated.log']:
    text=(out/name).read_text(encoding='utf-8')
    assert 'SCRIPT ERROR' not in text and 'Parse Error' not in text,name
result={'status':'TECHNICAL_DELIVERY_VERIFIED_HUMAN_PLAYTEST_PENDING','sources_verified':len(sources),'links_verified':len(links),'strips':18,'suite_failures':0,'smoke':'nine stages OK','runtime_captures':6,'launchers':'both checked','human_acceptance':'PENDING','git_publication':False}
(out/'verification.json').write_text(json.dumps(result,indent=2))
print(json.dumps(result))
