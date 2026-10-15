"""Record explicit owner acceptance of the displayed L02 v01."""
from pathlib import Path
import json,hashlib
ROOT=Path(__file__).resolve().parent;REPO=ROOT.parents[2]
def item(p):return dict(path=str(p.relative_to(REPO)).replace('\\','/'),sha256=hashlib.sha256(p.read_bytes()).hexdigest())
source=item(ROOT/'native-sources/L02_v01.png')
receipt=dict(revision='L02/v01',owner_reply='atena aprovado, faça um lote maior de imagens para eu aprovar',
    content_state='CANON_VISUAL_v01',source=source,previews=[item(p) for p in sorted((ROOT/'previews').glob('*.png'))],
    runtime_admission=False,commit_push_authorized=False,new_batch_approval=False)
(ROOT/'owner-approval.json').write_text(json.dumps(receipt,ensure_ascii=False,indent=2),encoding='utf-8')
text='''# L02 v01 — Clique para jogar — aceite visual

Após a entrega de L02 v01, o dono respondeu **“atena aprovado, faça um lote maior de imagens para eu aprovar”**. Fonte e prévias identificadas no recibo são promovidas a **CANON_VISUAL_v01**. O novo lote de props é apenas autorizado para produção, sem aceite visual presumido.

Texto aceito: Clique para jogar. Fonte SHA256: `HASH`.

[Recibo completo](../../generated/fila026-l02-2026-10-14/owner-approval.json) · [Galeria](../../generated/fila026-l02-2026-10-14/index.html).

UI sem identidade de personagem (N/A), sem lore nova. Aceite visual separado de integração: prompt dinâmico de teclado/controle/toque preservado; PNG representa mensagem de mouse. Sem novo commit, push, exportação ou alteração de runtime autorizado por este aceite.
'''
(REPO/'.atena/vault/canon/ASSET-APPROVAL-FILA026-L02-v01.md').write_text(text.replace('HASH',source['sha256']),encoding='utf-8')
gallery=(ROOT/'index.html').read_text(encoding='utf-8-sig')
gallery=gallery.replace('v01 DRAFT','v01 CANON VISUAL').replace('Sem integração ou aceite presumido.','Aceite visual recebido do dono; integração pendente. <a href="owner-approval.json">Recibo</a>.').replace('Legibilidade e estilo aguardam aceite do dono.','Legibilidade e estilo aceitos pelo dono na revisão v01.').replace('Sem novo commit, push, promoção a CANON ou integração nesta entrega.','Aceite CANON visual de L02 registrado separadamente; sem novo commit, push ou integração.')
(ROOT/'index.html').write_text(gallery,encoding='utf-8')
print('L02 v01 visually accepted; new props remain DRAFT.')
