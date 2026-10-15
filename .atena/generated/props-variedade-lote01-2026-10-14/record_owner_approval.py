"""Record explicit approval of PV01–PV08 v01 without changing their pixels."""
from pathlib import Path
import json,hashlib
ROOT=Path(__file__).resolve().parent;REPO=ROOT.parents[2]
jobs=json.loads((ROOT/'jobs.json').read_text(encoding='utf-8'))
def entry(p):return dict(path=str(p.relative_to(REPO)).replace('\\','/'),sha256=hashlib.sha256(p.read_bytes()).hexdigest())
sources=[dict(id=j['id'],name=j['name'],revision='v01',**entry(ROOT/j['source'])) for j in jobs]
receipt=dict(revision='PROPS-VARIEDADE-LOTE01/v01',owner_reply='atena aprovado, commite e continue',content_state='CANON_VISUAL_v01',
    sources=sources,previews=[entry(p) for p in sorted((ROOT/'previews').glob('*.png'))],
    accepted_as_displayed=True,native_margin_notes_preserved=['PV02','PV03','PV05','PV06','PV07','PV08'],
    runtime_admission=False,commit_authorized=True,push_authorized=False,new_batch_visual_approval=False)
(ROOT/'owner-approval.json').write_text(json.dumps(receipt,ensure_ascii=False,indent=2),encoding='utf-8')
lines=['# PV01–PV08 v01 — oito variantes de props aceitas','',
    'O dono respondeu **“atena aprovado, commite e continue”** após a galeria das oito candidatas. As fontes e prévias v01 identificadas no recibo são promovidas a **CANON_VISUAL_v01**, como exibidas, incluindo as ressalvas de margem nativa e desgaste. As métricas permanecem inalteradas.','',
    '| Código | Variante | SHA256 fonte |','|---|---|---|']
lines += [f"| {s['id']} v01 | {s['name']} | `{s['sha256']}` |" for s in sources]
lines += ['','[Recibo completo](../../generated/props-variedade-lote01-2026-10-14/owner-approval.json) · [Galeria](../../generated/props-variedade-lote01-2026-10-14/index.html).','',
    'Identidade de personagem N/A: props estáticos das famílias existentes, sem lore nova. O aceite não modifica assets oficiais, escala/âncora de runtime ou colisões. Commit local autorizado, sem push, merge, exportação ou integração presumidos. Novas candidatas de um próximo lote continuam DRAFT até novo aceite.','']
(REPO/'.atena/vault/canon/ASSET-APPROVAL-PROPS-VARIEDADE-LOTE01-v01.md').write_text('\n'.join(lines),encoding='utf-8')
print('Eight v01 sources and displayed previews accepted as-is; local commit authorized.')
