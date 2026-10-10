from pathlib import Path
import json,re,hashlib
from datetime import datetime,timezone
root=Path.cwd(); out=Path(__file__).parent
read=lambda p:p.read_text(encoding='utf-8-sig')
save=lambda p,d:p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
gpath=out/'h103-owner-gate-2026-10-09.json'; g=json.loads(read(gpath))
assert hashlib.sha256((root/g['candidate']).read_bytes()).hexdigest()==g['sha256']
receipt=out/'h103-owner-approval-2026-10-09.json'
save(receipt,dict(status='APPROVED',owner_reply='2. aprovado',frame='H103',version='v01',sha256=g['sha256'],candidate=g['candidate'],recorded_at=datetime.now(timezone.utc).isoformat(),scope='H103 v01 visual approval; generate five remaining Durvall frames, then only H201 Brook gate. No runtime admission.'))
g.update(status='APPROVED',owner_reply='2. aprovado',approval_receipt=receipt.relative_to(root).as_posix()); save(gpath,g)
canon=root/'.atena/vault/canon/ASSET-APPROVAL-REGISTER-032-vfx-durvall-2026-10-09.md'
assert not canon.exists()
canon.write_text('# ASSET-APPROVAL-REGISTER-032 — Pico da Ruptura Sombria\n\nH103 v01 aprovado explicitamente pelo dono: “2. aprovado”. Promocao limitada ao pico, SHA256 '+g['sha256']+'. [Recibo](../../generated/s007-reconciliation/v01/h103-owner-approval-2026-10-09.json). Cinco demais quadros permanecem DRAFT; proximo gate H201 Brook. Sem admissao runtime.\n',encoding='utf-8')
save(out/'continuation-git-receipt-2026-10-09.json',dict(status='PUBLISHED_VERIFIED',commit='373979b3f4ecc47d320fd0111d16a3586480aa8f',branch='codex/fila-imagens-continuacao-2026-10-09',remote='https://github.com/marizada86/nottgard-survivor.git',owner_reply='1. autorizado',push='new branch created',pull='Already up to date.',verification='HEAD equals upstream ref',native_sources='ignored, not published'))
q=root/'.atena/generated/CHATGPT-FILA-023-vfx-habilidades-dos-herois.md'; qt=read(q)
notes={'H101':'START only: a small short thin bright sliver beginning at the exact central origin, quarter final reach; most canvas BLACK. No full-sized crescent. Preserve jagged torn cut identity.', 'H102':'SWEEP growth only: about60% of approved peak reach, growing broad right-facing torn band, bright leading edge and faint trailing wisps. Clearly smaller than peak.', 'H104':'HOLD: same full-sized crescent extent and jagged dark central crack as approved peak, but visibly narrower white band, less glow and fewer sparks. Do not shift pivot.', 'H105':'FADE: same outer extent/pivot, torn band breaking into separated dim GRAY fragments, black gaps, no continuous white band. Much dimmer than hold.', 'H106':'DISSIPATE: nearly BLACK canvas, only few extremely faint dark-gray curved scraps/specks at same outer extent. No intact band or bright crescent.'}
jobs=[]; pilot=out/'approved-pilot-A03-v02-reference.png'; anchor=root/g['candidate']
for code in ['H101','H102','H104','H105','H106','H201']:
 m=re.search(r'#### '+code+r' - `([^`]+)`.*?```text\s*(.*?)\s*```',qt,re.S); assert m
 name,prompt=m.groups(); effect='brook_guarda_de_lliira' if code=='H201' else 'durvall_ruptura_sombria'
 dest=root/f'.atena/generated/art-candidates/vfx/{effect}/{name}_v01.png'; assert not dest.exists(); dest.parent.mkdir(parents=True,exist_ok=True)
 if code=='H201':
  refs=[str(pilot)]; prompt+='\nReference is approved painted white-gray VFX STYLE ONLY, never its crescent shape. Generate ONLY H201 Brook protective ring first loop GATE: perfectly round, flat top-down centered translucent light barrier ring, gentle inner glow, small THREE-POINTED STAR marks spaced on its rim. Pure black background, white-gray light, safe margins, no actual shield prop, dome perspective, character or text. Readable at96px; no montage.'
 else:
  refs=[str(anchor),str(pilot)]; prompt+='\nReference1 is APPROVED H103 v01 Durvall PEAK, authoritative shape, jagged cracks, orientation and pivot. Reference2 is approved physical pilot STYLE ONLY. Generate ONLY '+code+', one native square frame, no montage. Safe BLACK margins beyond all light. '+notes[code]
 jobs.append(dict(code=code,effect=effect,name=name,version='v01',prompt=prompt,referenced_image_paths=refs,destination=dest.relative_to(root).as_posix(),status='PENDING',transparent_background=False))
save(out/'hb-generation-jobs-2026-10-09.json',dict(plan='PLAN-053',spec='SPEC-121',generator='built-in imagegen',remaining_at_start=59,counter_field='native_generated_since_H103',approval_receipt=receipt.relative_to(root).as_posix(),jobs=jobs))
p=root/'.atena/state/plan-053-imagens.yaml'; t=read(p).replace('status: AWAITING_EXPLICIT_REMOTE_SCOPE_APPROVAL','status: EXECUTING_H_REMAINING',1).replace('checkpoint: DEV-006/S-003','checkpoint: S-007/VFX/FILA-023/H-REMAINING',1)
t=re.sub(r"  current: '[^\n]*'", "  current: 'H103 v01 aprovada; push373979b verificado; cinco demais Durvall em geracao.'",t,count=1)
t=re.sub(r"  next: '[^\n]*'", "  next: 'Revisar seis Durvall; depois somente H201 Brook para gate humano.'",t,count=1)
t=t.replace('  status: PENDING_OWNER_APPROVAL\n  frame: H103','  status: APPROVED\n  frame: H103')
t=re.sub(r'\nvfx_generation_progress:\n.*?(?=\n\S|\Z)','\nvfx_generation_progress:\n  jobs: .atena/generated/s007-reconciliation/v01/hb-generation-jobs-2026-10-09.json\n  native_generated_since_H103: 0\n  last_frame: H103\n',t,flags=re.S);p.write_text(t,encoding='utf-8')
p=root/'.atena/state/plan.yaml';t=read(p).replace('  status: AWAITING_EXPLICIT_REMOTE_SCOPE_APPROVAL','  status: EXECUTING_H_REMAINING').replace('  visual_gate: H103_v01_PENDING_OWNER_APPROVAL','  visual_gate: H103_v01_APPROVED').replace('  remote_review: rejected_destination_and_payload_need_explicit_approval','  remote_review: explicitly_authorized_and_push_pull_verified');p.write_text(t,encoding='utf-8')
qt=qt.replace('[x] gerada · [ ] aprovada · candidata: `.atena/generated/art-candidates/vfx/durvall_ruptura_sombria/durvall_ruptura_sombria_peak_v01.png`','[x] gerada · [a] aprovada · candidata: `.atena/generated/art-candidates/vfx/durvall_ruptura_sombria/durvall_ruptura_sombria_peak_v01.png`').replace('pico gerado/revisado; gate humano pendente antes dos outros cinco Durvall.','pico aprovado pelo dono; demais cinco em geracao.');q.write_text(qt,encoding='utf-8')
(out/'hb-visual-readiness-2026-10-09.md').write_text('# Prontidao visual — H1/H2\n\nPLAN-053/SPEC-121, IN_PLAN, per-plan. Autoridade textual ART-PROMPTS-054 revisao2026-10-01 e FILA023. Referencia de estilo CANON A03 v02; identidade de efeito H103 v01 CANON por aceite explicito; demais Durvall e H201 DRAFT. Entidade/personagem N/A: somente efeitos isolados, nenhum corpo de heroi. Contexto: sprites planos vistos de cima, fundo preto, branco/cinza para tinta aditiva futura, sem cenario. Ruptura direita, rachadura escura, fases start/sweep/peak/hold/fade/dissipate; Brook circular, calma, marcas estrela tres pontas. Leitura96px, margem segura, nativos preservados; normalizacao1024 e integracao DEFERRED. BLOCKING zero para cinco Durvall e somente piloto Brook; gate Brook BLOCKING para demais Brook. Produzir um quadro por chamada, revisar margens/identidade/continuidade. Integracao fica fora desta geracao.\n',encoding='utf-8')
print('H103 approval, Git receipt, readiness and six jobs prepared')
