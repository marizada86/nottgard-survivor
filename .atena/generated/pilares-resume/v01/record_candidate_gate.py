from pathlib import Path
from PIL import Image
import hashlib,json,re
root=Path(__file__).resolve().parents[4];out=Path(__file__).parent;base=root/'.atena/generated/art-candidates/enemies-pilares/sintese_abissal'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
read=lambda p:json.loads(p.read_text(encoding='utf-8-sig'))
packing=read(base/'strips/packing.json');audit=read(out/'sintese_abissal-selected-source-audit.json')
assert len(audit)==26 and all(not r['clipped'] and r['solidity']>=.9 for r in audit)
selection=read(base/'frame-selection.json')
assert selection['attack_03']['approval_status']=='PENDING_OWNER_DECISION'
sources=[]
for state,items in packing['sources'].items():
 for index,item in enumerate(items):
  p=root/item['path'].removeprefix('res://')
  row=next(a for a in audit if a['state']==state and a['index']==index)
  assert row['path']==item['path']
  sources.append(dict(state=state,index=index,path=p.relative_to(root).as_posix(),sha256=sha(p),size=Image.open(p).size,bbox=row['bbox'],packed_bbox=row['packed_bbox'],solidity=row['solidity']))
strips=[]
for state,items in packing['sources'].items():
 p=base/'strips'/f'{state}.png';assert Image.open(p).size==(len(items)*256,384)
 strips.append(dict(state=state,path=p.relative_to(root).as_posix(),sha256=sha(p),size=Image.open(p).size))
manifest=read(root/'.atena/generated/PRIORITY-IMAGES-2026-10-02.json')
assert len(manifest['assets'])==197
for row in manifest['assets']:assert sha(root/row['path'])==row['sha256'],row['path']
assert not (root/'assets/animations/enemies/sintese_abissal').exists()
assert '"sintese_abissal":' not in (root/'ui/enemy_view.gd').read_text(encoding='utf-8-sig')
native_versions=[dict(path=p.relative_to(root).as_posix(),sha256=sha(p)) for p in sorted(base.glob('sintese_abissal_*_v*.png'))]
receipt=dict(date='2026-10-08',plan='PLAN-053',spec='SPEC-121',request_classification='IN_PLAN',approval_mode='per-plan',status='CANDIDATE_CYCLES_READY_PENDING_ATTACK03_DECISION',sources=sources,strips=strips,source_versions_preserved=native_versions,packing=packing,selection=selection,native_alpha_preserved=True,technical_review_inspected=True,min_source_solidity=min(r['solidity'] for r in audit),native_and_cell_clipping=False,manifest_verified=197,official_actor_assets_installed=0,runtime_checks='not run: actor admission awaiting owner decision',build='not exported: actor admission awaiting owner decision',pending_owner_gate='GATE-PILARES-ATTACK03-PENDANT-2026-10-08',review='.atena/generated/pilares-resume/v01/sintese_abissal_compact_review.png',notes='Three original arms, two main lamps and single left wing reviewed. Special00-04v02 replace secondary green-drip ornaments with plain gold medallions; special03v02 also restores complete lamp margin. Attack03v03 retains one tiny green drop on a secondary pendant; decision still pending. No acceptance of the exception is inferred. White connected root base; no humanoid leg alternation required. Death core dark from02 through05; terminal corpse preserved. Uniform standing scale and lower-trunk root/bone anchor compensate native canvas scale and extended roots, preserving native RGBA.')
dest=out/'sintese_abissal-candidate-gate-receipt.json';dest.write_text(json.dumps(receipt,indent=2)+'\n',encoding='utf-8')
gate=read(out/'attack03-pendant-owner-gate-2026-10-08.json');gate['independent_work']='COMPLETE: 26 selected sources, five candidate strips, native/cell bounds and alpha passed; no official admission';gate['candidate_receipt']=dest.relative_to(root).as_posix();(out/'attack03-pendant-owner-gate-2026-10-08.json').write_text(json.dumps(gate,indent=2)+'\n')
evidence=root/'.atena/evidence/pilares-sintese-abissal-candidate-gate-2026-10-08.md'
evidence.write_text(f'# Pilares — ciclos candidatos e decisão pendente\n\nPLAN-053/SPEC-121 IN_PLAN, per-plan aprovado. Identidade idle00v02 aprovada explicitamente no registro024; esta revisão técnica não inventa aprovação individual dos ciclos. 26 fontes selecionadas, cinco tiras candidatas, {len(native_versions)} versões nativas preservadas. Fontes/células sem cortes, solidez mínima {receipt["min_source_solidity"]:.6f}. RGB/alfa nativos preservados. Prancha e sequência de cada estado inspecionadas. Escala uniforme dos estados em pé, compensação de canvas na queda e âncora no tronco de raízes registradas em packing/selection, sem pintar fontes.\n\n[Recibo e hashes](../generated/pilares-resume/v01/sintese_abissal-candidate-gate-receipt.json). [Prancha](../generated/pilares-resume/v01/sintese_abissal_compact_review.png). [Ataque](../generated/pilares-resume/v01/sintese_abissal_attack_review.gif). [Morte](../generated/pilares-resume/v01/sintese_abissal_death_review.gif). [Especial](../generated/pilares-resume/v01/sintese_abissal_special_review.gif). [Decisão pendente](../generated/pilares-resume/v01/attack03-pendant-owner-gate-2026-10-08.json). [Detalhe attack03v03](../generated/pilares-resume/v01/attack_03_v03_lamp_detail.png).\n\nSpecial00-04v02 corrigem gotas extras com medalhões dourados; pico03 recupera a margem inteira do lampião. Death00-02v02 preservam dois lampiões; núcleo apagado em02-05, corpo unido tombado no fim. Três braços, asa única esquerda e base de raízes revisados. Attack03v03 ainda tem pequena gota verde num pingente intermediário após três versões, limite max_retries:3; perguntado ao dono se aceita somente esse detalhe nesse quadro ou autoriza uma tentativa adicional. Resposta ainda não recebida. A exceção de Socothbenoth não se aplica a este ator.\n\nTrabalho independente concluído; admissão pendente. Zero assets oficiais de Síntese instalados; EnemyView ainda usa sua arte estática. Manifesto197/197 hashes conferidos. Runtime/captura/build de Pilares não executados. Helpers de integração e validação preparados, sem claim de execução. S-006 permanece pendente até decisão/admissão/validação; S-007 e retorno PLAN-071 preservados.\n',encoding='utf-8')
for rel in ['.atena/state/plan.yaml','.atena/state/plan-053-imagens.yaml']:
 p=root/rel;t=p.read_text(encoding='utf-8-sig')
 t=t.replace('  status: EXECUTING_CYCLES','  status: AWAITING_OWNER_DECISION',1)
 if rel.endswith('/plan.yaml'):
  t=re.sub(r'  checkpoint: S-006/PILARES/[^\n]+','  checkpoint: S-006/PILARES/ATTACK03-DECISION',t,count=1)
 else:
  t=t.replace('  independent_work: Finish death05 and special00-05; no integration pending decision.','  independent_work: COMPLETE; 26 sources and five candidate strips reviewed; no official admission.',1)
  t=re.sub(r"  review: '[^\n]+'","  review: '.atena/generated/pilares-resume/v01/sintese_abissal_compact_review.png'",t,count=1)
  t=re.sub(r"  evidence: '[^\n]+'","  evidence: '.atena/evidence/pilares-sintese-abissal-candidate-gate-2026-10-08.md'",t,count=1)
 t=re.sub(r"  current: '[^\n]+","  current: 'S-006 Pilares: 26 fontes/5 tiras candidatas revisadas; decisao attack03 pendente apos tres versoes, zero oficiais.'",t,count=1)
 t=re.sub(r"  next: '[^\n]+","  next: 'Resolver gota verde do pingente attack03; depois integrar, validar runtime/captura/build e reconciliar S-007. Retorno PLAN-071 preservado.'",t,count=1)
 p.write_text(t,encoding='utf-8')
summary='\n2026-10-08 — Pilares: 26 fontes selecionadas/5 tiras candidatas revisadas; RGB/alfa preservados, limites e solidez passaram. Special00-04v02 corrigem pingentes extras e margem do pico03. Attack03v03 ainda retém pequena gota verde em pingente intermediário; GATE-PILARES-ATTACK03-PENDANT-2026-10-08 PENDING_OWNER_DECISION após três versões. Trabalho independente concluído; nenhuma admissão/runtime/build Pilares. Manifesto197 hashes conferido. Evidência pilares-sintese-abissal-candidate-gate-2026-10-08.md; retorno PLAN-071 preservado.\n'
for rel in ['.atena/evidence/EVID-145-fila-de-imagens-prioritaria-2026-10-02.md','.atena/specs/SPEC-121-retomada-fila-imagens/tasks.md','.atena/generated/CHATGPT-FILA-019-mobs-pilares.md']:
 p=root/rel;p.write_text(p.read_text(encoding='utf-8')+summary,encoding='utf-8')
for rel in ['.atena/generated/CHATGPT-FILA-019-mobs-pilares.md','.atena/generated/ART-PROMPTS-050-mobs-pilares.md']:
 p=root/rel;t=p.read_text(encoding='utf-8');t=re.sub(r'^status:.*','status: "26 fontes/5 tiras candidatas revisadas; attack03 pendente de decisão após três versões; zero oficiais"',t,count=1,flags=re.M);p.write_text(t,encoding='utf-8')
# Verify all Markdown file links in the new evidence and canonical approval register.
paths=[evidence,root/'.atena/vault/canon/ASSET-APPROVAL-REGISTER-024-pilares-identidade-2026-10-08.md']
for p in paths:
 for target in re.findall(r'\]\(([^)]+)\)',p.read_text(encoding='utf-8')):
  if '://' in target:continue
  candidate=p.parent/target.split('#',1)[0]
  assert candidate.exists(),(p,target)
print(f'Pilares candidates ready: 26 sources, 5 strips, {len(native_versions)} native versions; min solidity={receipt["min_source_solidity"]:.6f}; 197 official hashes, links valid. Owner gate pending, no actor admission.')

