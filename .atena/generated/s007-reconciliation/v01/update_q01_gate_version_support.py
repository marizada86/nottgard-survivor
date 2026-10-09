from pathlib import Path
p=Path(__file__).parent/'finalize_p_q01_gate.py'
t=p.read_text(encoding='utf-8')
assert 'Q01 v01 candidata com gate pendente' in t
t=t.replace("old='- [ ] gerada · [ ] aprovada · candidata: `'+j['destination']+'`';assert t.count(old)==1;t=t.replace(old,old.replace('[ ] gerada','[x] gerada')+' — gate humano pendente; fonte nativa preservada.')", "old='- [ ] gerada · [ ] aprovada · candidata: `.atena/generated/art-candidates/vfx/orbe_arcano/orbe_arcano_fly_00_v01.png`';assert t.count(old)==1;selected='- [x] gerada · [ ] aprovada · candidata: `'+j['destination']+'` — gate humano pendente; fonte nativa preservada.';t=t.replace(old,selected)")
t=t.replace("'Orbe radiante oito quadros gerados/revisados, P01 v01 aprovada; Q01 v01 candidata com gate pendente; demais27 quadros pendentes'", "'Orbe radiante oito quadros gerados/revisados, P01 v01 aprovada; Q01 '+j['version']+' candidata com gate pendente; demais27 quadros pendentes'")
t=t.replace("'Orbe radiante oito candidatas revisadas, P01 aprovada; Q01 v01 candidata com gate pendente; demais27 quadros pendentes; EVID-145'", "'Orbe radiante oito candidatas revisadas, P01 aprovada; Q01 '+j['version']+' candidata com gate pendente; demais27 quadros pendentes; EVID-145'")
t=t.replace("'S-007 orbe radiante oito candidatas revisadas; Q01 v01 gerada, gate humano pendente. Manifesto202 preservado.'", "'S-007 orbe radiante oito candidatas revisadas; Q01 '+j['version']+' gerada, gate humano pendente. Manifesto202 preservado.'")
t=t.replace("\"plan='PLAN-053',spec='SPEC-121'\"", "\"plan='PLAN-053',spec='SPEC-121'\"")
t=t.replace("runtime_admission=False,official_manifest_assets=202", "rejected_versions=d.get('rejected_native_versions',[]),runtime_admission=False,official_manifest_assets=202")
t=t.replace("Nenhum outro Q gerado; gate obrigatório FILA022 antes de sete demais Q.", "Q01 v01 preservada e rejeitada por deslocamento à direita; v02 corrige a posição com imagegen nativo. Nenhum outro quadro Q gerado; gate obrigatório FILA022 antes de sete demais Q.")
p.write_text(t,encoding='utf-8')
print('Q gate finalizer accepts selected version, preserves rejected version audit and truthfully records native center correction.')
