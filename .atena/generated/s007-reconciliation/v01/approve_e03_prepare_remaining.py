from pathlib import Path
import json,re,hashlib
from datetime import datetime,timezone
root=Path(__file__).resolve().parents[4];out=Path(__file__).parent
read=lambda p:p.read_text(encoding='utf-8-sig')
save=lambda p,data:p.write_text(json.dumps(data,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
gatepath=out/'e03-owner-gate-2026-10-09.json';gate=json.loads(read(gatepath))
assert gate['status']=='PENDING_OWNER_APPROVAL'
peak=root/gate['candidate'];assert hashlib.sha256(peak.read_bytes()).hexdigest()==gate['sha256']
receipt=out/'e03-owner-approval-2026-10-09.json'
save(receipt,dict(timestamp=datetime.now(timezone.utc).isoformat(),plan='PLAN-053',spec='SPEC-121',classification='IN_PLAN',status='APPROVED',owner_reply='atena, aprovado, continue',context='Reply to E03 approval question for generation of five remaining radiant arc frames',gate_id=gate['id'],frame='E03',version='v01',sha256=gate['sha256'],scope='Visual E03 peak approval and five E frames, then next existing FILA021 gate; no blanket approval of F03 or future unseen frames',runtime_admission=False))
gate['status']='APPROVED';gate['owner_reply']='atena, aprovado, continue';gate['approval_receipt']=receipt.relative_to(root).as_posix();save(gatepath,gate)
canon=root/'.atena/vault/canon/ASSET-APPROVAL-REGISTER-025-vfx-arco-radiante-2026-10-09.md'
assert not canon.exists()
canon.write_text('# ASSET-APPROVAL-REGISTER-025 — Pico do arco radiante\n\nApós a pergunta “Aprova E03 para gerar os cinco quadros restantes?”, o dono respondeu “atena, aprovado, continue”. E03 peak v01 visualmente aprovada, SHA256 '+gate['sha256']+'. [Recibo da aprovação](../../generated/s007-reconciliation/v01/e03-owner-approval-2026-10-09.json). [Fonte aprovada](../../generated/art-candidates/vfx/arco_largo_radiante/arco_largo_radiante_peak_v01.png).\n\nPLAN-053/SPEC-121, IN_PLAN, per-plan preservado. Gerar os cinco outros quadros E com E03 como referência; continuidade da fila até o próximo gate F03, que ainda exige aceite. Fontes nativas preservadas; fonte1254 quadrada requer futura normalização técnica. Sem aprovação fictícia de quadros ainda não vistos, sem admissão runtime nesta fila, sem autorização Git/publicação.\n',encoding='utf-8')
queue=root/'.atena/generated/CHATGPT-FILA-021-vfx-corpo-a-corpo-excecoes.md';t=read(queue)
old='- [x] gerada · [ ] aprovada · candidata: `'+gate['candidate']+'` — E03 v01: gate humano pendente, fonte nativa preservada.'
assert old in t
t=t.replace(old,old.replace('[ ] aprovada','[a] aprovada').replace('gate humano pendente','aprovada pelo dono em 2026-10-09'))
t=t.replace('E03 v01 gerada com gate pendente','E03 v01 aprovada; cinco demais E em geração');queue.write_text(t,encoding='utf-8')
pilot=out/'approved-pilot-A03-v02-reference.png';jobs=[]
for code in ['E01','E02','E04','E05','E06','F03']:
 match=re.search(r'#### '+code+r' - `([^`]+)`.*?```text\s*(.*?)\s*```',t,re.S);name,prompt=match.groups();effect='arco_largo_radiante' if code.startswith('E') else 'arco_largo_de_fogo'
 dest=root/f'.atena/generated/art-candidates/vfx/{effect}/{name}_v01.png';assert not dest.exists();dest.parent.mkdir(parents=True,exist_ok=True)
 refs=[str(peak),str(pilot)] if code.startswith('E') else [str(pilot)]
 if code.startswith('E'):
  prompt+='\n\nReference image 1 is the APPROVED E03 peak for this exact radiant arc. Reference image 2 is the APPROVED physical pilot for painted white-core/gray-glow STYLE ONLY. Generate ONLY the '+code+' phase specified above, not the peak again. Keep the same exact ground-flat orientation, canvas-center pivot and RIGHT-facing direction as E03. Preserve the radiant arc motif and painted texture, with its brightness, extent, thickness and fragmentation following this frame phase. Pure BLACK everywhere outside the effect, no saturation or scene. Keep all effect pixels, glow and sparks inside the canvas margins.'
 else:
  prompt+='\n\nThe attached image is a STYLE REFERENCE ONLY: the approved physical pilot peak. Match its painted line texture, white core and gray glow, but draw the NEW broad fire arc with licking flame tongues and embers specified above. Flames are strictly neutral WHITE and GRAY, with no orange or red. The canvas-center pivot and RIGHT-facing direction must be preserved. Generate ONLY this F03 peak, with the full shape, glow, embers and flame tips inside black margins.'
 jobs.append(dict(code=code,effect=effect,name=name,version='v01',prompt=prompt,referenced_image_paths=refs,destination=dest.relative_to(root).as_posix(),status='PENDING',transparent_background=False))
save(out/'ef-generation-jobs-2026-10-09.json',dict(plan='PLAN-053',spec='SPEC-121',generator='built-in imagegen',native_originals_preserved=True,approval_receipt=receipt.relative_to(root).as_posix(),jobs=jobs))
for rel in ['.atena/state/plan.yaml','.atena/state/plan-053-imagens.yaml']:
 p=root/rel;t=read(p).replace('AWAITING_OWNER_APPROVAL','EXECUTING_E_REMAINING').replace('S-007/VFX/FILA-021/E03-APPROVAL','S-007/VFX/FILA-021/E-REMAINING')
 t=t.replace('S-007 reconciliado; E03 v01 gerada e revisada; gate visual humano pendente. Manifesto202 preservado.','S-007 E03 aprovada pelo dono; gerando cinco quadros E e depois somente gate F03. Manifesto202 preservado.')
 t=t.replace('Aguardar aprovacao E03 antes dos cinco quadros restantes do arco radiante; 107 fontes VFX restantes. Retorno PLAN-071 preservado.','Revisar sequencia E completa; gerar F03 para proximo gate humano. Retorno PLAN-071 preservado.')
 t=t.replace('S-007 VFX aguardando gate humano E03.','S-007 VFX gerando E apos aceite E03; proximo gate F03.')
 if rel.endswith('plan-053-imagens.yaml'):
  t=t.replace('  id: GATE-FILA-021-E03-2026-10-09\n  status: PENDING_OWNER_APPROVAL','  id: GATE-FILA-021-E03-2026-10-09\n  status: APPROVED')
  t+='  owner_reply: "atena, aprovado, continue"\n  approval_receipt: .atena/generated/s007-reconciliation/v01/e03-owner-approval-2026-10-09.json\n'
 p.write_text(t,encoding='utf-8')
print(json.dumps(dict(status='E03_APPROVED_REMAINING_JOBS_READY',jobs=len(jobs))))
