"""Record the owner's explicit acceptance of the displayed FILA-012 UI v01."""
from pathlib import Path
import json,hashlib
ROOT=Path(__file__).resolve().parent
REPO=ROOT.parents[2]
def record(path):return dict(path=str(path.relative_to(REPO)).replace('\\','/'),sha256=hashlib.sha256(path.read_bytes()).hexdigest())
sources=[dict(id=code,revision='v01',**record(ROOT/'native-sources'/f'{code}_v01.png')) for code in ['U01','U02','U03','U04']]
receipt=dict(revision='FILA-012-UI/v01',owner_visual_reply='aprovado, continue',owner_git_reply='atena aprovado, commite e push',
    content_state='CANON_VISUAL_v01',sources=sources,previews=[record(p) for p in sorted((ROOT/'previews').glob('*.png'))],
    acceptance='AS_DISPLAYED_WITH_DOCUMENTED_NOTES',runtime_admission=False,
    notes=['U01 native aspect mismatch and 25px height at 180px shown and accepted visually; HUD placement remains undecided.',
           'U02 normalized review sizes differ from native symbol sizes.',
           'U03/U04 dark checker texture accepted as displayed.'],commit_authorized=True,push_authorized=True,export_authorized=False)
(ROOT/'owner-approval.json').write_text(json.dumps(receipt,ensure_ascii=False,indent=2),encoding='utf-8')
lines=['# FILA-012 UI — aceite visual U01–U04 v01','',
    'O dono respondeu **“aprovado, continue”**, seguido de **“atena aprovado, commite e push”**, após a entrega da galeria das quatro candidatas. Este registro promove somente as fontes e prévias v01 identificadas no recibo a **CANON_VISUAL_v01**. Não promove o plano de produção nem autoriza admissão no runtime.','',
    'Aceite como exibido: inclui a proporção/altura de U01, tamanhos nativos diferentes dos marcadores U02 e textura quadriculada pintada de U03/U04. As medições da auditoria permanecem inalteradas. A disposição da barra no HUD (25px versus 4px atuais) ainda precisa de definição antes da integração.','',
    '| Fonte | SHA256 |','|---|---|']
lines.extend(f"| {s['id']} v01 | `{s['sha256']}` |" for s in sources)
lines+=['','[Recibo completo com fontes e prévias](../../generated/fila012-ui-2026-10-14/owner-approval.json) · [Galeria](../../generated/fila012-ui-2026-10-14/index.html) · [Auditoria](../../generated/fila012-ui-2026-10-14/audit.json).','',
    'Identidade de personagem N/A: UI frontal, sem entidade ou lore nova; referências da ficha C inspecionadas na produção. As fontes anteriores e os demais lotes mantêm seus estados. Commit e push deste lote autorizados explicitamente; integração, exportação e merge fora deste aceite.','']
(REPO/'.atena/vault/canon/ASSET-APPROVAL-FILA012-UI-v01.md').write_text('\n'.join(lines),encoding='utf-8')
print('Recorded visual acceptance of four v01 sources and displayed previews.')
