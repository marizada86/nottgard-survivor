"""Verify the comparison package and close S-004, preserving the owner visual gate."""
from pathlib import Path
from html.parser import HTMLParser
import hashlib
import json
import re
import subprocess
from PIL import Image
OUT=Path(__file__).resolve().parent
ROOT=OUT.parents[2]
assert not (OUT/'visual-acceptance.json').exists()
data=json.loads((OUT/'jobs.json').read_text(encoding='utf-8'))
assert data['approval']=='APPROVED_PER_PLAN' and data['generated']==1 and data['technical_status']=='PASS'
assert data['jobs'][0]['revision']=='v03' and len(data['previous_native_versions'])==2
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
for j in data['jobs']+data['previous_native_versions']:
    assert sha(ROOT/j['destination'])==j['sha256']==sha(Path(j['original_path']))
for r in data['sources']+data['style_references']+data['comparison_references']:
    p=Path(r['path']);p=p if p.is_absolute() else ROOT/p
    assert sha(p)==r['sha256']
rootpath=ROOT/'.atena/state/plan.yaml'
rootbefore=rootpath.read_text(encoding='utf-8')
for p,expected in json.loads((OUT/'protected-snapshot.json').read_text(encoding='utf-8')).items():
    actual=hashlib.sha256(rootbefore.split('active_plan:',1)[1].encode()).hexdigest() if '#active_plan_tail' in p else sha(ROOT/p)
    assert actual==expected,p
with Image.open(OUT/'review-reading.png') as im: assert im.format=='PNG' and im.size==(1000,810)
log=(OUT/'preview-renderer/render-log.txt').read_text(encoding='utf-8')
assert 'Rendered six comparative previews' in log and 'SCRIPT ERROR' not in log
class Links(HTMLParser):
    def __init__(self):super().__init__();self.links=[];self.previews=[]
    def handle_starttag(self,tag,attrs):
        attrs=dict(attrs)
        for key in ['src','href','data-source']:
            if key in attrs:self.links.append(attrs[key])
        if tag=='canvas':self.previews.append(attrs)
parser=Links();parser.feed((OUT/'index.html').read_text(encoding='utf-8'))
assert len(parser.previews)==6 and sorted(int(c['data-height']) for c in parser.previews)==[80]*3+[128]*3
for link in parser.links:assert (OUT/link).resolve().is_file(),link
qa={'plan':data['plan'],'revision':'v01','content_state':'DRAFT','gallery_local_links':'PASS','gallery_metadata':'PASS','preview_count':6,'preview_heights':[int(c['data-height']) for c in parser.previews],'reading_image':'review-reading.png','reading_image_size':[1000,810],'reading_image_sha256':sha(OUT/'review-reading.png'),'reading_render':'GODOT_SUBVIEWPORT_OPENGL_COMPATIBILITY','reading_inspection':'COMPLETED_BY_ATENA','reading_observations':{'MJ01_v03':'Broad asymmetric base, raised lobe and three thick cohesive curved extensions remain distinct at 80/128px; no humanoid legs, fixed face, cocoon or exposed luminous core. Proposed lobes/vesicles remain DRAFT geometry.','receptacle_comparison':'Existing narrower upright humanoid with eyes and exposed core, compared at same visible height; native runtime texture unchanged.','PT04_v02_comparison':'Accepted DRAFT dormant low mass with central cocoon/eyes remains distinct from MJ01; unchanged source.','limits':'Fine gel recesses simplify at 80px. Equal-height comparison is for silhouette, not real world/runtime scale. Owner still assesses appearance/style/readability; map contrast deferred.'},'human_visual_acceptance':'PENDING','playtest':'NOT_PERFORMED','native_pixels_changed_by_preview':False,'browser_render_verification':'NOT_ATTEMPTED_KNOWN_FILE_URL_POLICY_BLOCK','browser_workaround_attempted':False,'renderer_notes':['Local render completed despite shader-cache/certificate-store warnings; no network operation.','Independent SubViewport preserves complete 1000x810 image; native reference aspect ratio preserved.']}
(OUT/'gallery-qa.json').write_text(json.dumps(qa,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
STATUS='DELIVERED_DRAFT_OWNER_VISUAL_REVIEW_PENDING'
CHECKPOINT='S-005/OWNER_VISUAL_ACCEPTANCE'
NEXT='Revisar MJ01 Manifestação de Juiblex v03, comparando com receptáculo e PT04 a 80/128px; registrar aceite visual ou correções'
data.update({'status':STATUS,'current_step':CHECKPOINT,'current_step_position':5,'completed_steps':4,'remaining_steps_after_current':0,'human_visual_acceptance':'PENDING','reading_preview':'.atena/generated/art032-juiblex-2026-10-12/review-reading.png','gallery_qa':'gallery-qa.json','next_objective':NEXT,'next_execution_authorized':False})
(OUT/'jobs.json').write_text(json.dumps(data,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
audit=json.loads((OUT/'audit.json').read_text(encoding='utf-8'))
audit.update({'gallery_qa':'gallery-qa.json','reading_preview':'review-reading.png','reading_inspection':'COMPLETED_BY_ATENA','browser_render_verification':qa['browser_render_verification']})
(OUT/'audit.json').write_text(json.dumps(audit,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
fields={'status':STATUS,'checkpoint':CHECKPOINT,'current_step_position':'5','completed_steps':'4','remaining_steps_after_current':'0','next_objective':json.dumps(NEXT,ensure_ascii=False),'next_execution_authorized':'false'}
def update(text,indent=''):
    for key,value in fields.items():
        text,count=re.subn(r'^'+indent+key+r':.*$',indent+key+': '+value,text,flags=re.M)
        assert count==1,key
    text+=indent+'technical_status: PASS\n'+indent+'review_candidates: [MJ01_v03]\n'+indent+'reading_preview: .atena/generated/art032-juiblex-2026-10-12/review-reading.png\n'+indent+'gallery: .atena/generated/art032-juiblex-2026-10-12/index.html\n'+indent+'gallery_browser_verification: NOT_ATTEMPTED_KNOWN_FILE_URL_POLICY_BLOCK\n'
    return text
statepath=ROOT/'.atena/state/art032-juiblex.yaml'
state=update(statepath.read_text(encoding='utf-8')).replace('completed_ordered_steps: [S-001, S-002, S-003]','completed_ordered_steps: [S-001, S-002, S-003, S-004]')
statepath.write_text(state,encoding='utf-8')
prefix,tail=rootbefore.split('art032_pontos_2026_10_11:',1)
rootpath.write_text(update(prefix,'  ')+'art032_pontos_2026_10_11:'+tail,encoding='utf-8')
assert rootpath.read_text(encoding='utf-8').split('art032_pontos_2026_10_11:',1)[1]==tail
planpath=ROOT/'.atena/vault/drafts/PLAN-ART032-JUIBLEX-v01.md'
plan=planpath.read_text(encoding='utf-8').replace('status: APPROVED_IN_PROGRESS','status: '+STATUS,1)
plan+='''
## Entrega S-004 — 2026-10-12

**4/5 passos concluídos; S-005 atual, zero passos após o atual.** Candidata **MJ01 Manifestação de Juiblex v03**, DRAFT. Três saídas nativas 1254×1254 RGBA (pedido 1024×1024) preservadas, sem limpeza/recorte/redimensionamento original. Correções exclusivamente de enquadramento: v01 margem 4,23%; v02 margem 13,16% mas largura 72,09%; ambas não selecionadas. v03 ocupa 60,53% da largura e 48,09% da altura, margem mínima 18,26%, borda totalmente transparente. Hash nativo/cópia verificado.

[Galeria](../../generated/art032-juiblex-2026-10-12/index.html), [prancha comparativa](../../generated/art032-juiblex-2026-10-12/review-reading.png), [auditoria](../../generated/art032-juiblex-2026-10-12/audit.json), [prompts](../../generated/art032-juiblex-2026-10-12/prompts.md), [evidência](../../evidence/art032-juiblex-delivery-2026-10-12.md). Seis prévias Godot completas, comparando MJ01/receptáculo/PT04 com a mesma altura visível a 80/128px. Igualar altura serve à comparação de forma, não fixa escala runtime. Fontes antigas e cadeia PLAN-071 conferidas; links/metadados verificados. Não alegar render browser ou playtest.

Próximo objetivo S-005: dono avaliar silhueta/filamentos, estilo/material, diferenciação do receptáculo e da massa dormente, leitura 80/128px e geometria experimental DRAFT. Inputs são v03 e comparação; output aceite identificado ou correção por código. **Aceite visual humano pendente**, sem CANON, preparação/admissão, integração, commit, push ou build. O limite de três versões por defeito de enquadramento foi consumido; eventual novo defeito exige registro e checkpoint próprio. Textos anteriores registram os estados de preparação/aprovação.
'''
planpath.write_text(plan,encoding='utf-8')
j=data['jobs'][0]
evidence='''# ART-032 — MJ01 Manifestação de Juiblex, entrega 2026-10-12

Plano [PLAN-ART032-JUIBLEX/v01](../vault/drafts/PLAN-ART032-JUIBLEX-v01.md), modo per-plan, produção aprovada com **“Aprovo MJ01 DRAFT”**. **S-002/S-003/S-004 concluídas, 4/5; S-005 aguarda aceite visual humano de MJ01 v03.** Geometria experimental DRAFT: massa amorfa assimétrica, base larga, lobo elevado e três extensões coesas. Identidade/lore/contexto prontos antes da produção; manifestação ativa do próprio ser, diferenciada do backup e do ponto dormente. Não impor anatomia de franquias.

Uma candidata selecionada em três saídas builtin imagegen; duas correções apenas de enquadramento. v01: margem 4,23%, insuficiente; v02: margem 13,16%, mas largura 72,09%, acima de 70%; v03: margem 18,26%, largura 60,53%, altura 48,09%, borda alfa exatamente zero. Todas 1254×1254 RGBA (pedido 1024×1024), originais e cópias com SHA256 igual. Nenhuma limpeza/recorte/redimensionamento nativo. **MJ01 v03 SHA256: `'''+j['sha256']+'''`.**

[Fonte nativa v03](../generated/art032-juiblex-2026-10-12/sources/MJ01_manifestacao_juiblex_v03.png), [galeria](../generated/art032-juiblex-2026-10-12/index.html), [prancha](../generated/art032-juiblex-2026-10-12/review-reading.png), [auditoria](../generated/art032-juiblex-2026-10-12/audit.json), [origem/hashes](../generated/art032-juiblex-2026-10-12/jobs.json), [prompts efetivos/histórico](../generated/art032-juiblex-2026-10-12/prompts.md), [QA](../generated/art032-juiblex-2026-10-12/gallery-qa.json), [estado](../state/art032-juiblex.yaml).

Prancha Godot independente 1000×810, completa, inspecionada: MJ01 v03, receptáculo runtime existente e PT04 v02 aceito, todos a 80/128px de altura visível. Base mais larga/três extensões diferenciam MJ01 da figura ereta com olhos/núcleo e da massa baixa com casulo. Recessos finos do gel simplificam a 80px; a leitura geral continua examinável. Comparação não testa escala world/runtime, contraste em bioma ou diversão. Lobos/vesículas permanecem propostas DRAFT, não afirmação de olhos/anatomia canônica. Critério técnico não substitui revisão humana.

Checks: alfa/margem/ocupação/hash/cópia, referências de lore/estilo/comparação, HTML links/metadados, três recibos/dezesseis candidatas/vinte e quatro fontes anteriores, runtime/ativos e cauda PLAN-071 preservados por hash. Godot completou render apesar de avisos de shader cache/certificate store, sem rede; não houve tentativa de contornar bloqueio file:// ou alegar renderização HTML no navegador. Git HEAD e índice preservados, sem integração/CANON/normalização/admissão/commit/push/build/gameplay/playtest.

Próximo objetivo: dono aprovar visualmente **MJ01 v03** ou identificar correção limitada; este aceite não libera admissão/CANON/commit. Após o aceite, as dezessete fontes selecionadas ART-032 poderão ter preparação/admissão planejada, com autorização própria; ainda não há execução dessa fase. Backlog: P0=0, quatro P1 abertos, quatorze implementados aguardando playtest, zero alertas.
'''
evidencepath=ROOT/'.atena/evidence/art032-juiblex-delivery-2026-10-12.md'
evidencepath.write_text(evidence,encoding='utf-8')
state=statepath.read_text(encoding='utf-8').replace('evidence: .atena/evidence/art032-juiblex-preparation-2026-10-12.md','evidence: .atena/evidence/art032-juiblex-delivery-2026-10-12.md')
statepath.write_text(state,encoding='utf-8')
roottext=rootpath.read_text(encoding='utf-8').replace('  evidence: .atena/evidence/art032-juiblex-preparation-2026-10-12.md','  evidence: .atena/evidence/art032-juiblex-delivery-2026-10-12.md',1)
rootpath.write_text(roottext,encoding='utf-8')
backlogpath=ROOT/'.atena/backlog/ARTE.md'
backlog=backlogpath.read_text(encoding='utf-8').replace('MJ01 Manifestação de Juiblex DRAFT v01: [plano aprovado](../vault/drafts/PLAN-ART032-JUIBLEX-v01.md), em produção; sem admissão.','MJ01 Manifestação de Juiblex v03 DRAFT gerada/auditada, 4/5, aceite visual S-005 pendente; [entrega](../evidence/art032-juiblex-delivery-2026-10-12.md). Admissão de ART-032 ainda aberta.')
backlogpath.write_text(backlog,encoding='utf-8')
for path in [planpath,evidencepath]:
    for link in re.findall(r'\]\(([^)]+)\)',path.read_text(encoding='utf-8')):assert (path.parent/link).resolve().is_file(),link
assert rootpath.read_text(encoding='utf-8').split('art032_pontos_2026_10_11:',1)[1]==tail
assert subprocess.check_output(['git','rev-parse','HEAD'],cwd=ROOT).decode().strip()=='51b51f7369ae34eede997435e6eb52ea057daf25'
assert not subprocess.check_output(['git','diff','--cached','--name-only'],cwd=ROOT).strip()
verification={'plan':data['plan'],'revision':'v01','status':'PASS_OWNER_VISUAL_GATE_PENDING','completed_steps':4,'total_steps':5,'current_step':CHECKPOINT,'content_state':'DRAFT','candidate':'MJ01_v03','native_outputs_preserved':3,'source_reference_and_comparison_hashes':'PASS','runtime_prior_accepted_and_plan071_return':'UNCHANGED_HASH_VERIFIED','links_contract_state':'PASS','reading_sheet':[1000,810],'preview_count':6,'browser_render_verification':qa['browser_render_verification'],'head':'51b51f7369ae34eede997435e6eb52ea057daf25','index':'EMPTY','runtime_admission':False,'canonical_promotion':False,'commit_push_build':False,'human_visual_acceptance':'PENDING','next_execution_authorized':False}
(OUT/'delivery-verification.json').write_text(json.dumps(verification,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
print('S-004 PASS: MJ01 v03 plus two unchanged references, six 80/128px comparisons, complete reading sheet, links/contract/state/source/protected checks. 4/5 done; S-005 pending; Git unchanged.')
