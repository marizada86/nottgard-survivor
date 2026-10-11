from pathlib import Path
import hashlib
import json

base=Path(__file__).parent
root=base.parents[2]
receipt_path=base/'admission-receipt.json'
receipt=json.loads(receipt_path.read_text(encoding='utf-8'))
assert receipt['authorization_verbatim']=='Autorizo a admissão e validação'
check=json.loads((base/'admission-godot-check.json').read_text(encoding='utf-8'))
assert check['status']=='PASS' and len(check['imported'])==10 and not check['failures']
manifest=json.loads((root/receipt['manifest']).read_text(encoding='utf-8-sig'))
original=json.loads((base/'admission-recovery/ASSET-PRODUCTION-MANIFEST-001.json').read_text(encoding='utf-8-sig'))
assert manifest['entries'][:-10]==original['entries']
assert len(manifest['entries'])==receipt['manifest_new_entries']==279
assert manifest['expected_png_files']==original['expected_png_files']+10
cursor=json.loads((root/'data/cursor.json').read_text(encoding='utf-8'))
for slot,hotspot in receipt['hotspots'].items():
    assert cursor[slot]['hotspot']==hotspot
for r in receipt['records']:
    for path in [r['source'],r['destination']]:
        assert hashlib.sha256((root/path).read_bytes()).hexdigest()==r['sha256']
    imported=root/(r['destination']+'.import')
    assert imported.is_file()
    assert 'source_file="res://'+r['destination']+'"' in imported.read_text(encoding='utf-8')
    entry=next(e for e in manifest['entries'] if e['final_path']==r['destination'])
    assert entry['sha256']==r['sha256'] and entry['selected_version']=='v01'
receipt.update(status='ADMITTED_VALIDATED_WAITING_ART_COMMIT',tests_status='PASS',imports_status='PASS',
               manifest_status='PASS_269_EXISTING_ENTRIES_PRESERVED_10_ADDED',
               godot_check='admission-godot-check.json',runtime_validation='Ten PNG resources loaded at expected sizes; existing cursor and lettering checks zero failures.',
               next='S013 art commit requires explicit authorization; S014 hookups and S015 full verification remain pending.')
receipt_path.write_text(json.dumps(receipt,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
register=dict(id='ASSET-APPROVAL-REGISTER-031',date_brt='2026-10-11',plan='PLAN-065',spec='SPEC-132',
              authorization_verbatim=receipt['authorization_verbatim'],scope='S013 byte-identical admission of ten accepted v01 PNGs, hotspots and targeted validation.',
              status='ADMITTED_VALIDATED',runtime_admission=True,assets=receipt['records'],
              visual_registers=['.atena/vault/canon/ASSET-APPROVAL-FILA026-L01-v01.md','.atena/vault/canon/ASSET-APPROVAL-FILA026-G2-v01.md'],
              receipt='.atena/generated/fila026-remaining-2026-10-11/admission-receipt.json',
              manifest=receipt['manifest'],tests_status='PASS',commit_push_build_authorized=False,
              remaining='S013 art commit; S014 remaining UI hookups; S015 full suite/captures/playtest; S016 closure/code commit.')
(root/'.atena/vault/canon/ASSET-APPROVAL-REGISTER-031-fila026-admission-2026-10-11.json').write_text(json.dumps(register,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
for name in ['audit.json','jobs.json']:
    path=base/name
    data=json.loads(path.read_text(encoding='utf-8'))
    data.update(runtime_admission=True,admission_receipt='admission-receipt.json',
                current_step='S-013/ART_COMMIT_GATE',status=receipt['status'],
                next='Authorized admission/targeted checks complete; art commit and further UI hookups remain gated.')
    for r in data.get('records',data.get('jobs',[])):
        r['runtime_admission']=True
    path.write_text(json.dumps(data,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
path=base/'cursor-candidates.json'
cursors=json.loads(path.read_text(encoding='utf-8'))
cursors.update(status='CANON_VISUAL_G2_ADMITTED',admission_receipt='admission-receipt.json')
for r in cursors['cursors'].values():
    r['runtime_admission']=True
path.write_text(json.dumps(cursors,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
path=base/'index.html'
page=path.read_text(encoding='utf-8')
page=page.replace('próxima etapa 13/16, admissão sob gate próprio.', 'etapa 13/16: admissão autorizada e validada; commit de arte pendente.')
page=page.replace('Nenhuma admissão runtime.', 'Dez PNGs admitidos; imports e testes de lettering/cursor aprovados.')
if 'href="admission-receipt.json"' not in page:
    page=page.replace('<a href="audit.json">Auditoria</a>', '<a href="admission-receipt.json">Admissão validada</a> · <a href="audit.json">Auditoria</a>')
page=page.replace('O G2 é aceite artístico por peça. Admissão, integração, commit e push permanecem em seus checkpoints próprios.',
                  'G2 e admissão autorizada concluídos. Composições acima permanecem ilustrativas. Commit de arte e integração das demais telas aguardam seus checkpoints; sem push ou build.')
path.write_text(page,encoding='utf-8')
print(json.dumps(dict(admitted=10,imports='PASS',targeted_tests='PASS',manifest='PASS',next='ART_COMMIT_GATE')))
