from pathlib import Path
import json,re,hashlib
from datetime import datetime,timezone
root=Path(__file__).resolve().parents[4];out=Path(__file__).parent
read=lambda p:p.read_text(encoding='utf-8-sig')
save=lambda p,d:p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
gp=out/'q01-owner-gate-2026-10-09.json';g=json.loads(read(gp));assert g['status']=='PENDING_OWNER_APPROVAL' and g['version']=='v03'
anchor=root/g['candidate'];assert hashlib.sha256(anchor.read_bytes()).hexdigest()==g['sha256']
receipt=out/'q01-owner-approval-2026-10-09.json';assert not receipt.exists()
save(receipt,dict(timestamp=datetime.now(timezone.utc).isoformat(),plan='PLAN-053',spec='SPEC-121',classification='IN_PLAN',status='APPROVED',owner_reply='atena, aprovado, continue',context='Reply to approval question for Q01 v03 and generation of seven other arcane orb frames',frame='Q01',version='v03',sha256=g['sha256'],scope='Q01 v03 visual approval; Q02-Q08 generation; continuation to R01 mandatory gate under existing plan. Unseen future frames not individually approved.',runtime_admission=False))
g.update(status='APPROVED',owner_reply='atena, aprovado, continue',approval_receipt=receipt.relative_to(root).as_posix());save(gp,g)
canon=root/'.atena/vault/canon/ASSET-APPROVAL-REGISTER-028-vfx-orbe-arcano-2026-10-09.md';assert not canon.exists()
canon.write_text('# ASSET-APPROVAL-REGISTER-028 — Primeiro voo do orbe arcano\n\nApós a pergunta “Aprova Q01 v03 para gerar os outros sete quadros?”, o dono respondeu “atena, aprovado, continue”. Q01 fly00 v03 aprovada visualmente, SHA256 '+g['sha256']+'. [Aprovação](../../generated/s007-reconciliation/v01/q01-owner-approval-2026-10-09.json), [fonte aprovada](../../generated/art-candidates/vfx/orbe_arcano/orbe_arcano_fly_00_v03.png).\n\nPLAN-053/SPEC-121, IN_PLAN, per-plan preservado. Gerar Q02–Q08 usando Q01 v03 como referência, depois seguir até R01 da FILA-022. Próximo gate obrigatório; sem aceite fictício de imagens futuras ou admissão runtime nesta fila. Fontes e versões nativas preservadas; normalização técnica futura para1024 permanece pendente. Sem autorização Git/publicação.\n',encoding='utf-8')
q=root/'.atena/generated/CHATGPT-FILA-022-vfx-projeteis-e-explosoes.md';t=read(q)
old='- [x] gerada · [ ] aprovada · candidata: `'+g['candidate']+'` — gate humano pendente; fonte nativa preservada.';assert t.count(old)==1
t=t.replace(old,old.replace('[ ] aprovada','[a] aprovada').replace('gate humano pendente','aprovada pelo dono em 2026-10-09')).replace('Q01 v03 candidata com gate pendente; demais27 quadros pendentes','Q01 v03 aprovada; sete demais Q em geração; R/N/M pendentes');q.write_text(t,encoding='utf-8')
art=root/'.atena/generated/ART-PROMPTS-053-vfx-projeteis-e-explosoes.md';canonical=read(art);art.write_text(canonical.replace('Q01 v03 candidata com gate pendente; demais27 quadros pendentes','Q01 v03 aprovada; sete demais Q em geração; R/N/M pendentes'),encoding='utf-8')
pilot=out/'approved-pilot-A03-v02-reference.png';jobs=[]
notes={
 'Q02':'FLIGHT LOOP: Keep exactly the approved Q01 core and circular glyph-ring center, diameter and shape. Center of dense white core at50% canvas width/height, not bounding box center. Only slightly brighter pulse and slightly longer wispy LEFT tail. No orb translation/scaling.',
 'Q03':'FLIGHT LOOP: Keep the exact approved Q01 core and thin glyph-ring center, circular diameter and shape. Rotate only painted internal swirls and small ring motifs a quarter turn; left wispy tail slightly shorter. No orb translation/scaling, no changing tail direction.',
 'Q04':'LOOP CLOSURE: Exact approved Q01 core/ring center, diameter, circular shape and small circular glyph motifs. Slightly dimmer glow and original left smoky trail length so Q04 returns gently to Q01 with no position or size jump.',
 'Q05':'IMPACT START: No tail or left smoky stream. The arcane orb has collided: a COMPACT centered circular flash, thin ring with tiny abstract circular glyph motifs and only tiny radial sparks beginning, about60% of the coming impact peak diameter. Same centered core pivot as approved Q01. Early impact only, not full burst. White/gray painted light, no readable text.',
 'Q06':'IMPACT PEAK: No tail or left smoky stream. Centered arcane burst at maximum impact size: hot white core inside expanding circular arcane ring, small abstract circular glyph fragments and short sparks/ribbons radiating evenly around the center. Brightest phase; flat face-on circle, comfortable black margins outside all spark tips. Exact canvas-centered pivot as Q01.',
 'Q07':'IMPACT DECAY: No tail or left smoke stream and NO solid bright white core or intact orb. Expand burst into a centered THIN GRAY ring, dim broken circular glyph fragments and radial smoky fragments. Clearly dimmer than peak, black open center. Same pivot and painted glow texture as Q01.',
 'Q08':'FINAL IMPACT: Almost pure BLACK; only a barely visible DARK GRAY centered broken ring and a few very faint scattered circular fragments/specks. No white core, bright sparks, intact orb, tail or leftward smoke. Same exact canvas-center pivot.'
}
for code in ['Q02','Q03','Q04','Q05','Q06','Q07','Q08','R01']:
 m=re.search(r'#### '+code+r' - `([^`]+)`.*?```text\s*(.*?)\s*```',t,re.S);assert m;name,prompt=m.groups()
 assert re.search(r'Subject: (.*?) Frame ',prompt).group(1) in canonical
 effect='orbe_arcano' if code.startswith('Q') else 'onda_cortante';dest=root/f'.atena/generated/art-candidates/vfx/{effect}/{name}_v01.png';assert not dest.exists();dest.parent.mkdir(parents=True,exist_ok=True)
 if code.startswith('Q'):
  refs=[str(anchor),str(pilot)];prompt+='\n\nReference1 is APPROVED Q01 v03 for arcane orb identity and CENTERED core placement. Reference2 is the APPROVED physical pilot for painted white-core/gray-falloff STYLE ONLY. Generate ONLY '+code+' phase specified above, never a contact sheet. Flat ground-plane view, exact canvas-center core pivot; all glow and particles inside pure-black margins. Neutral white/gray; no text, character, weapon, hand or scene. Small glyphs must be abstract CIRCLES, not readable letters.\n'+notes[code]
 else:
  refs=[str(pilot)];prompt+='\n\nAttached approved physical pilot is STYLE ONLY for white painted core and soft gray glow. Generate a NEW compact flying crescent blade of energy with fine jagged white/gray lightning crackling along its edge. Tips point backward LEFT while convex leading edge faces RIGHT. Flat face-on ground-plane shape, no perspective or ellipse. Center the projectile near exact canvas center, with generous black margins on every side. Only this first flight frame, normal compact size; do not copy the full-canvas sweep scale of the pilot. No color, weapon, hand, character, readable text, border, ground or scene.'
 jobs.append(dict(code=code,effect=effect,name=name,version='v01',prompt=prompt,referenced_image_paths=refs,destination=dest.relative_to(root).as_posix(),status='PENDING',transparent_background=False,source_queue=q.relative_to(root).as_posix()))
save(out/'qr-generation-jobs-2026-10-09.json',dict(plan='PLAN-053',spec='SPEC-121',generator='built-in imagegen',remaining_at_start=87,counter_field='native_generated_since_Q01',approval_receipt=receipt.relative_to(root).as_posix(),native_originals_preserved=True,jobs=jobs))
for rel in ['.atena/state/plan.yaml','.atena/state/plan-053-imagens.yaml']:
 p=root/rel;s=read(p).replace('AWAITING_OWNER_APPROVAL','EXECUTING_Q_REMAINING').replace('S-007/VFX/FILA-022/Q01-APPROVAL','S-007/VFX/FILA-022/Q-REMAINING')
 s=s.replace('S-007 orbe radiante oito candidatas revisadas; Q01 v03 gerada, gate humano pendente. Manifesto202 preservado.','S-007 Q01 v03 aprovada; gerando sete demais Q, depois somente gate R01. Manifesto202 preservado.')
 s=s.replace('Aguardar aprovacao Q01 antes dos sete demais Q; 87 fontes VFX restantes. Retorno PLAN-071 preservado.','Revisar voo e quatro impactos Q; gerar R01 para proximo gate humano. Retorno PLAN-071 preservado.')
 s=s.replace('S-007 orbe radiante completo como candidata; aguardando gate humano Q01. PLAN-071 preservado.','S-007 Q em geracao apos aceite Q01 v03; proximo gate R01. PLAN-071 preservado.')
 if rel.endswith('plan-053-imagens.yaml'):
  s=s.replace('  id: GATE-FILA-022-Q01-2026-10-09\n  status: PENDING_OWNER_APPROVAL','  id: GATE-FILA-022-Q01-2026-10-09\n  status: APPROVED')
  s=s.replace('  receipt: .atena/generated/s007-reconciliation/v01/q01-owner-gate-2026-10-09.json\n','  receipt: .atena/generated/s007-reconciliation/v01/q01-owner-gate-2026-10-09.json\n  owner_reply: "atena, aprovado, continue"\n  approval_receipt: .atena/generated/s007-reconciliation/v01/q01-owner-approval-2026-10-09.json\n')
  m=re.search(r'\nvfx_generation_progress:\n(.*?)(?=\n\S|\Z)',s,re.S);assert m
  s=s[:m.start(1)]+'  jobs: .atena/generated/s007-reconciliation/v01/qr-generation-jobs-2026-10-09.json\n  native_generated_since_Q01: 0\n  last_frame: none\n'+s[m.end(1):]
 p.write_text(s,encoding='utf-8')
print(json.dumps(dict(status='Q01_APPROVED_Q_REMAINING_READY',jobs=len(jobs),next_gate='R01')))
