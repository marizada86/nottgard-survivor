"""Verify the complete review package and close S-004 at the owner visual gate."""
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
assert data['generated']==6 and data['technical_status']=='PASS_WITH_NATIVE_ALPHA_NOTE'
def sha(p): return hashlib.sha256(p.read_bytes()).hexdigest()
for j in data['jobs']+data.get('previous_native_versions',[]):
    assert sha(ROOT/j['destination'])==j['sha256']==sha(Path(j['original_path']))
for p,expected in json.loads((OUT/'protected-snapshot.json').read_text(encoding='utf-8')).items():
    actual=hashlib.sha256((ROOT/'.atena/state/plan.yaml').read_text(encoding='utf-8').split('active_plan:',1)[1].encode()).hexdigest() if '#active_plan_tail' in p else sha(ROOT/p)
    assert actual==expected,p
with Image.open(OUT/'review-reading.png') as im:
    assert im.size==(1000,1440) and im.format=='PNG'
log=(OUT/'preview-renderer/render-log.txt').read_text(encoding='utf-8')
assert 'Rendered twelve reading previews' in log
assert 'SCRIPT ERROR' not in log
class Parser(HTMLParser):
    def __init__(self): super().__init__();self.links=[];self.previews=[]
    def handle_starttag(self,tag,attrs):
        attrs=dict(attrs)
        for key in ['src','href','data-source']:
            if key in attrs: self.links.append(attrs[key])
        if tag=='canvas': self.previews.append(attrs)
parser=Parser();parser.feed((OUT/'index.html').read_text(encoding='utf-8'))
assert len(parser.previews)==12
for link in parser.links: assert (OUT/link).is_file(),link
qa={'plan':data['plan'],'revision':'v01','content_state':'DRAFT','gallery_local_links':'PASS','gallery_metadata':'PASS','preview_count':12,'preview_heights':[int(c['data-height']) for c in parser.previews],'reading_image':'review-reading.png','reading_image_size':[1000,1440],'reading_image_sha256':sha(OUT/'review-reading.png'),'reading_render':'GODOT_SUBVIEWPORT_OPENGL_COMPATIBILITY','reading_inspection':'COMPLETED_BY_ATENA','reading_observations':{'PT02_v02':'Empty seat/armrests/back and mushroom clusters read at 80/128px; wood/mycelium geometry remains DRAFT.','PT03_v02':'Closed dark stone face and complete arch remain legible at 80/128px; no active portal; carved marks are DRAFT abstract ornament.','PT04_v02':'Low mound and central wrapped cocoon distinguish dormant ritual mass at 80/128px.','PT05_v01':'Compact upright nucleus with contained center remains distinguishable from the wider coreless slime at 48/80px.','PT06_v02':'Mauve fungal capsule and pale short base remain distinguishable at 48/80px.','PT07_v02':'Irregular wider base/tapered rise and coreless slime read at 48/80px; contrast over actual maps remains deferred.'},'human_visual_acceptance':'PENDING','playtest':'NOT_PERFORMED','browser_render_verification':'NOT_ATTEMPTED_KNOWN_FILE_URL_POLICY_BLOCK','browser_workaround_attempted':False,'native_pixels_changed_by_preview':False,'renderer_notes':['Shader-cache and certificate-store warnings did not prevent successful local rendering; no network operation.','Independent SubViewport preserves full 1000x1440 sheet without screen-size clamping.']}
(OUT/'gallery-qa.json').write_text(json.dumps(qa,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
data.update({'status':'DELIVERED_DRAFT_OWNER_VISUAL_REVIEW_PENDING','current_step':'S-005/OWNER_VISUAL_ACCEPTANCE','current_step_position':5,'completed_steps':4,'remaining_steps_after_current':0,'human_visual_acceptance':'PENDING','reading_preview':'.atena/generated/art032-pontos-2026-10-11/review-reading.png','gallery_qa':'gallery-qa.json'})
(OUT/'jobs.json').write_text(json.dumps(data,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
audit=json.loads((OUT/'audit.json').read_text(encoding='utf-8'))
audit.update({'gallery_qa':'gallery-qa.json','reading_preview':'review-reading.png','reading_inspection':'COMPLETED_BY_ATENA','browser_render_verification':qa['browser_render_verification']})
(OUT/'audit.json').write_text(json.dumps(audit,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
changes={'status':data['status'],'checkpoint':data['current_step'],'current_step_position':'5','completed_steps':'4','remaining_steps_after_current':'0','next_objective':"'Revisar PT02/PT03/PT04/PT06/PT07 v02 e PT05 v01; registrar aceite visual por revisão em S-005'"}
statepath=ROOT/'.atena/state/art032-pontos.yaml'
state=statepath.read_text(encoding='utf-8')
for key,value in changes.items(): state=re.sub(r'^'+key+r': .+$',key+': '+value,state,flags=re.M)
state=re.sub(r'^completed_ordered_steps: .+$','completed_ordered_steps: [S-001, S-002, S-003, S-004]',state,flags=re.M)
state+='technical_status: PASS_WITH_NATIVE_ALPHA_NOTE\nreview_candidates: [PT02_v02, PT03_v02, PT04_v02, PT05_v01, PT06_v02, PT07_v02]\nreading_preview: .atena/generated/art032-pontos-2026-10-11/review-reading.png\ngallery: .atena/generated/art032-pontos-2026-10-11/index.html\ngallery_browser_verification: NOT_ATTEMPTED_KNOWN_FILE_URL_POLICY_BLOCK\n'
statepath.write_text(state,encoding='utf-8')
rootpath=ROOT/'.atena/state/plan.yaml'
prefix,tail=rootpath.read_text(encoding='utf-8').split('art032_npcs_lote02_2026_10_11:',1)
for key,value in changes.items(): prefix=re.sub(r'^  '+key+r': .+$','  '+key+': '+value,prefix,flags=re.M)
prefix+='  technical_status: PASS_WITH_NATIVE_ALPHA_NOTE\n  review_candidates: [PT02_v02, PT03_v02, PT04_v02, PT05_v01, PT06_v02, PT07_v02]\n  human_visual_acceptance: PENDING\n  gallery: .atena/generated/art032-pontos-2026-10-11/index.html\n'
rootpath.write_text(prefix+'art032_npcs_lote02_2026_10_11:'+tail,encoding='utf-8')
planpath=ROOT/'.atena/vault/drafts/PLAN-ART032-PONTOS-v01.md'
plan=planpath.read_text(encoding='utf-8').replace('status: APPROVED_IN_PROGRESS','status: DELIVERED_DRAFT_OWNER_VISUAL_REVIEW_PENDING',1)
plan+='''
## Entrega S-004 — 2026-10-11

**4/5 passos concluídos; S-005 atual, zero passos após o atual.** Seis candidatas: **PT02 trono v02, PT03 arco v02, PT04 massa v02, PT05 Coração de Limo v01, PT06 esporo v02, PT07 limo v02**. Onze saídas nativas; cinco v01 preservadas e não selecionadas devido à margem abaixo de 10%. Correções limitaram-se ao enquadramento. Fontes reais 1254×1254, RGBA, alfa verdadeiro, bytes nativos intactos. Margens selecionadas 14,19%, 20,89%, 13,96%, 12,60%, 20,57%, 14,59%. PT02/PT05 preservam alfa 1/255 na borda, demais quatro têm borda vazia; sem clipping visível com alfa >8.

[Galeria](../../generated/art032-pontos-2026-10-11/index.html), [prancha completa](../../generated/art032-pontos-2026-10-11/review-reading.png), [auditoria](../../generated/art032-pontos-2026-10-11/audit.json), [evidência](../../evidence/art032-pontos-2026-10-11.md). Doze prévias Godot inspecionadas: props 80/128px, coletáveis 48/80px. Links/metadados conferidos; sem alegar QA no navegador. Runtime, fontes/recibos dos dois lotes anteriores e cauda PLAN-071 verificados por hash. Sem alterações de gameplay.

Próximo objetivo: dono avaliar trono vazio, face inativa do arco, casulo da massa e distinção dos três coletáveis, estilo/contraste/leitura; inputs são as seis revisões e a prancha, saída aceite identificado ou correções por código. **S-005 aguarda aceite visual humano.** Esse aceite não promove CANON nem autoriza admissão, integração, commit, push ou build. Após o fechamento, a Manifestação de Juiblex ou a preparação/admissão das fontes exige plano próprio. Texto de preparação acima preserva o estado anterior à produção.
'''
planpath.write_text(plan,encoding='utf-8')
evidencepath=ROOT/'.atena/evidence/art032-pontos-2026-10-11.md'
evidence=evidencepath.read_text(encoding='utf-8')
rows='\n'.join('| '+j['code']+' '+j['revision']+' | '+j['title']+' | '+str(j['audit']['minimum_margin_percent'])+'% | '+str(j['audit']['border_max_alpha'])+'/255 | `'+j['sha256']+'` |' for j in data['jobs'])
evidence+='\n## Entrega técnica — S-002/S-003/S-004\n\n4/5 concluídos; S-005 aguarda aceite visual. Seis candidatas em onze fontes builtin imagegen; cinco correções somente de enquadramento. Todas 1254×1254 RGBA (pedido 1024×1024), cópias com hashes nativos iguais. Nenhum pixel nativo limpo/redimensionado.\n\n| Revisão | Peça | Margem mínima | Alfa na borda | SHA256 |\n|---|---|---:|---:|---|\n'+rows+'\n\n[Galeria](../generated/art032-pontos-2026-10-11/index.html), [prancha](../generated/art032-pontos-2026-10-11/review-reading.png), [auditoria](../generated/art032-pontos-2026-10-11/audit.json), [QA da galeria/prancha](../generated/art032-pontos-2026-10-11/gallery-qa.json). Prancha 1000×1440 completa com doze prévias inspecionadas; coração compacto e limo mais largo/coreless distintos a 48px; esporo malva/ivório, props legíveis a 80/128px. Juízo técnico não substitui o aceite humano, nem testa contraste em biomas ou diversão. HTML conferido por links/metadados, sem render browser ou contorno de política. Godot renderizou com sucesso apesar de avisos de shader cache/certificate store, sem rede.\n\nChecks: fontes/referências, runtime/ativos, treze fontes anteriores e recibos, cauda PLAN-071 e links preservados/verificados; backlog P0=0, quatro P1 abertos, quatorze implementados aguardando playtest. Sem gameplay/playtest, integração, normalização/admissão, CANON, novo commit, push ou build. O commit 51b51f7 contém somente os dois lotes anteriores. Próximo objetivo S-005: aceite visual por estas seis revisões ou correção limitada por código; Manifestação de Juiblex permanece frente específica futura.\n'
evidencepath.write_text(evidence,encoding='utf-8')
backlogpath=ROOT/'.atena/backlog/ARTE.md'
backlog=backlogpath.read_text(encoding='utf-8')
backlog=backlog.replace('Próxima frente: PT02–PT07 DRAFT, [plano aprovado](../vault/drafts/PLAN-ART032-PONTOS-v01.md), em produção.','Pontos PT02/PT03/PT04/PT06/PT07 v02 e PT05 v01 DRAFT gerados/auditados; 4/5, aceite visual S-005 pendente; [entrega](../evidence/art032-pontos-2026-10-11.md). Manifestação de Juiblex/admissão ainda abertas.')
backlogpath.write_text(backlog,encoding='utf-8')
for path in [planpath,evidencepath]:
    for link in re.findall(r'\]\(([^)]+)\)',path.read_text(encoding='utf-8')):
        assert (path.parent/link).resolve().is_file(), (path,link)
assert not subprocess.check_output(['git','diff','--cached','--name-only'],cwd=ROOT).strip()
print('S-004 PASS: complete 1000x1440 reading sheet, twelve previews, local links/metadata, source and protected hashes. 4/5 done; S-005 owner visual gate pending; index empty.')
