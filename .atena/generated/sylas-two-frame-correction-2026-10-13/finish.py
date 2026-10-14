from pathlib import Path
import hashlib,html,json,os,re
import numpy as np
from PIL import Image
out=Path(__file__).resolve().parent;root=out.parents[2];sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
old=json.loads((root/'.atena/generated/assets-l002-review-2026-10-13/manifest.json').read_text(encoding='utf-8'))['sources']
assert all(sha(root/e['path'])==e['sha256'] for e in old)
protected=json.loads((out/'protected.json').read_text(encoding='utf-8'));assert all(sha(root/p)==h for p,h in protected.items())
jobs=json.loads((out/'generation-records.json').read_text(encoding='utf-8'))['jobs'];assert len(jobs)==3
initial=json.loads((out/'prompts.json').read_text(encoding='utf-8'))
for j in jobs:
 j['prompt']=(out/'H402-retry-prompt.txt').read_text(encoding='utf-8').strip() if j['attempt']==2 else next(p['prompt'] for p in initial['jobs'] if p['code']==j['code'])
 if j['code']=='H402':
  target=next(e for e in old if e['code']=='H402') if j['attempt']==1 else next(e for e in jobs if e['code']=='H402' and e['attempt']==1)
  refs=[target,next(e for e in old if e['code']=='H403'),next(e for e in old if e['code']=='H401')]
 else:refs=[next(e for e in old if e['code']==code) for code in ['H406','H405','H403']]
 j['references']=[{'path':e['path'],'sha256':e['sha256'],'role':'edit target' if i==0 else 'immutable supporting reference'} for i,e in enumerate(refs)]
 assert sha(root/j['path'])==j['sha256']
 assert sha(Path(j['original_path']))==j['sha256']
 for e in j['references']:assert sha(root/e['path'])==e['sha256']
(out/'generation-records.json').write_text(json.dumps({'revision':'sylas-two-frame-correction/v01','jobs':jobs,'calls_used':3,'max_calls':4,'H402_retry_used':True,'H406_retry_used':False,'selected_for_owner_review':['H402v03','H406v02'],'owner_acceptance':'PENDING'},ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
selected=[next(j for j in jobs if j['code']=='H402' and j['version']=='v03'),next(j for j in jobs if j['code']=='H406')]
six=[]
for code in ['H401','H402','H403','H404','H405','H406']:
 e=next((j for j in selected if j['code']==code),next(e for e in old if e['code']==code)).copy()
 e['acceptance']='PENDING_OWNER_VISUAL_ACCEPTANCE' if code in ['H402','H406'] else ('HISTORICAL_GATE_ACCEPTED' if code=='H403' else 'DRAFT_VISUALLY_ACCEPTED')
 six.append(e)
def metric(e):
 with Image.open(root/e['path']) as im:
  rgb=np.array(im.convert('RGB'));l=rgb@np.array([.2126,.7152,.0722]);y,x=np.where(l>12)
  edge=int(max(rgb[0].max(),rgb[-1].max(),rgb[:,0].max(),rgb[:,-1].max()))
  return {'code':e['code'],'version':e['version'],'path':e['path'],'sha256':sha(root/e['path']),'native_dimensions':list(im.size),'mode':im.mode,'mean_luminance':float(l.mean()),'visible_gt12':int(len(x)),'hot_gt128':int((l>128).sum()),'bbox_gt12':[int(x.min()),int(y.min()),int(x.max()+1),int(y.max()+1)],'edge_max_channel':edge,'channel_difference_max':int((rgb.max(axis=2).astype(int)-rgb.min(axis=2).astype(int)).max())}
rows=[metric(e) for e in six];new={e['code']:e for e in rows}
assert new['H401']['mean_luminance']<new['H402']['mean_luminance']<new['H403']['mean_luminance']
assert new['H401']['bbox_gt12'][2]<new['H402']['bbox_gt12'][2]<new['H403']['bbox_gt12'][2]
assert new['H402']['bbox_gt12'][0]>=new['H403']['bbox_gt12'][0]
assert new['H406']['mean_luminance']<new['H405']['mean_luminance'] and new['H406']['hot_gt128']<new['H405']['hot_gt128']
assert all(e['edge_max_channel']<=12 for e in rows)
audit={'status':'PASS_TECHNICAL_AND_ATENA_INSPECTION','rows':rows,'not_selected_H402v02':metric(next(j for j in jobs if j['code']=='H402' and j['version']=='v02')),'diagnostics':{'growth_width_fraction_of_peak':(new['H402']['bbox_gt12'][2]-new['H402']['bbox_gt12'][0])/(new['H403']['bbox_gt12'][2]-new['H403']['bbox_gt12'][0]),'growth_mean_fraction_of_peak':new['H402']['mean_luminance']/new['H403']['mean_luminance'],'dissipate_hot_fraction_of_previous':new['H406']['hot_gt128']/new['H405']['hot_gt128'],'faint_left_wisp_note':'H402v03 left bound570/1254, comparable to accepted peak565/1254 and start558/1254. Not exact x0.49 prompt envelope; main form is rightward, no long left tail as v01. Record actual placement; no pixel correction.'},'atena_visual_review':'H402v03 compact intermediate plume; H406v02 fragmented residual without coherent arrowhead or intact masks. Subjective acceptance pending.','normalization':'NOT_PERFORMED: generated1254square vs requested1024; native preserved','native_source_bytes_preserved':True}
(out/'audit.json').write_text(json.dumps(audit,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
(out/'selected-candidates.json').write_text(json.dumps({'revision':'sylas-two-frame-correction/v01','candidates':selected,'six_frame_context':six,'selection_state':'TECHNICAL_PROPOSAL_FOR_OWNER_REVIEW_NOT_VISUAL_ACCEPTANCE','canonical_promotion':False,'runtime_admission':False},ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
def url(e):return os.path.relpath(root/e['path'],out).replace('\\','/')
urls=[url(e) for e in six]
page='''<!doctype html><html lang="pt-BR"><meta charset="utf-8"><title>Sylas · correções DRAFT</title><style>body{background:#171c24;color:#eee;font:16px system-ui;max-width:1300px;margin:24px auto;padding:12px}a{color:#acd4ff}h1,h2{color:#edcc8a}.grid{display:grid;grid-template-columns:repeat(3,1fr);gap:16px}figure{margin:0}.large{width:100%}.small{width:96px;height:96px}small{overflow-wrap:anywhere}.motion{width:320px;height:320px}@media(max-width:700px){.grid{grid-template-columns:repeat(2,1fr)}}</style><h1>Sylas · H402v03 + H406v02 · DRAFT</h1><p>Dois candidatos para aceite visual conjunto. As39fases aceitas e H403v02 permanecem intactos. Três chamadas built-in imagegen; H402v02 preservada, não proposta. Nativos1254quadrados, sem reamostragem ou admissão.</p><p><button id="toggle">Pausar prévia</button> <span id="phase"></span><br><img class="motion" id="motion" src="'''+urls[0]+'''"> <img class="small" id="motion96" src="'''+urls[0]+'''"> Cadência ilustrativa; avaliar crescimento e dissipação, não runtime.</p><h2>Sequência proposta · seis fases</h2><div class="grid">'''
for e in six:page+=f'<figure><h2>{e["code"]} {e["version"]}</h2><a href="{html.escape(url(e))}"><img class="large" src="{html.escape(url(e))}"></a><img class="small" src="{html.escape(url(e))}"><p>{e["acceptance"]}</p><small>{e["sha256"]}</small></figure>'
page+='</div><h2>Histórico de H402 · v01 → v02 → v03</h2><div class="grid">'
history=[next(e for e in old if e['code']=='H402'),next(j for j in jobs if j['code']=='H402' and j['version']=='v02'),selected[0]]
for e in history:page+=f'<figure><h3>{e["code"]} {e["version"]}</h3><img class="large" src="{url(e)}"><img class="small" src="{url(e)}"></figure>'
page+='</div><p>H402v03: brilho médio≈65%do pico e cabeça entre início/pico. Pequenas fibras à esquerda do centro são semelhantes às referências aceitas; não há cauda longa cruzando o canvas. H406v02: poucos resíduos, sem cabeça contínua; pixels muito brilhantes≈4%da fase anterior. A forma/máscaras e leitura96px dependem do seu aceite.</p><p><a href="audit.json">Auditoria</a> · <a href="generation-records.json">Prompts finais/referências/resultados</a> · <a href="selected-candidates.json">Candidatos/hashes</a></p>'
page+='<script>const frames='+json.dumps(urls)+';const labels='+json.dumps([e['code']+' '+e['version'] for e in six])+';let i=0,play=true;const m=document.getElementById("motion"),s=document.getElementById("motion96"),p=document.getElementById("phase");document.getElementById("toggle").onclick=()=>{play=!play};setInterval(()=>{if(!play)return;m.src=frames[i];s.src=frames[i];p.textContent=labels[i];i=(i+1)%6},160);</script>'
(out/'index.html').write_text(page,encoding='utf-8')
evidence='''# Sylas correção de dois quadros / v01

PLAN053/SPEC121 S007, per-plan explicitamente aprovado;39fases L002 visualmente aceitas e H403v02 histórico preservados. [Autorização](../generated/sylas-two-frame-correction-2026-10-13/authorization.json), [spec](../specs/SPEC-121-retomada-fila-imagens/sylas-two-frame-correction-v01.md). Skill imagegen/built-in aplicada, nenhuma CLI/API/key/dependência. Identidade de personagem N/A, somente VFX de fumaça para direita; autoridade/revisões/referências/contexto previamente estruturados na spec.

S001:42hashes fontes originais conferidos,39aceites e referências intactos,3049arquivosruntime protegidos; snapshots de estado em before/. S002: três chamadas built-in: H402v02 primeira edição, H406v02 primeira edição e única iteraçãoH402v03. Alvos/referências vistos antes das chamadas; prompt/referências/original/sha/candidato preservados. [Prompts finais e registros](../generated/sylas-two-frame-correction-2026-10-13/generation-records.json). Resultados copiados por bytes para candidatos versionados no workspace; originais do gerador preservados. Sem pintura/reamostragem via script.

H402v02 não proposta: largura681px e brilho5,119 ainda próximos/acima do pico649px/4,994. H402v03 largura470px/brilho3,221, entre H401355px/2,146 e pico649px/4,994; cabeça vai até1040px entre início913 e pico1214. Fibra esquerda570px é semelhante ao pico565/início558, sem a cauda longa de v01190px. O envelope numérico exato do prompt x0,49 não foi cumprido nas fibras fracas; posicionamento real registrado e inspecionado, sem ocultar divergência ou mover pixels. H406v02 brilho0,388 contraH4052,282,215pixels>128 contra5512; remanescentes quebrados, sem ponta/rastro contínuos ou máscaras inteiras. Fonte1254quadrada em vez1024solicitado: normalização diferida, nativo preservado.

S003: inspeção das saídas nativas e comparação entre fases; galeria HTML com seis fontes exatas, animação ilustrativa e96px, históricoH402v01/v02/v03 e métricas. [Galeria](../generated/sylas-two-frame-correction-2026-10-13/index.html), [auditoria](../generated/sylas-two-frame-correction-2026-10-13/audit.json), [candidatos](../generated/sylas-two-frame-correction-2026-10-13/selected-candidates.json). Seleção técnica H402v03/H406v02 para revisão humana; isso não é aceite visual nem seleção para runtime.

S004: links/hashes/cópias originais/fontes aceitas/runtime conferidos, estado/evidência reconciliados. Sem alteração do jogo, testes/build/playtest não executados; não se justificam para dois DRAFTs isolados. PLAN071/B006/S011 preservado; sem CANON/Git/exportação/admissão. Técnico4/4; gate OWNER_TWO_FRAME_VISUAL_ACCEPTANCE pendente. [Verificação](../generated/sylas-two-frame-correction-2026-10-13/verification.json).

Próximo objetivo: dono avaliar e aceitar os dois candidatos juntos ou indicar exceções. Entradas: H402v03/H406v02 hashes, contexto seis fases/H403v02 imutável, galeria96px. Saída: recibo humano, depois proposta de admissão conjunta42fontes L002. Checks humanos: crescimento progressivo menor que pico, preservação de fumaça/máscaras/centro aparente, fim em resíduos sem reacendimento e leitura96px. Sem inferir aceite subjetivo de métricas; correção aprovada não autoriza integração.
'''
(root/'.atena/evidence/sylas-two-frame-correction-2026-10-13.md').write_text(evidence,encoding='utf-8')
p=root/'.atena/state/sylas-two-frame-correction.yaml';s=p.read_text(encoding='utf-8').replace('status: IN_PROGRESS','status: TECHNICAL_CORRECTION_COMPLETE_AWAITING_OWNER_VISUAL_ACCEPTANCE').replace('S-002/TWO_FRAME_EDITS','S-004/OWNER_TWO_FRAME_VISUAL_ACCEPTANCE').replace('completed_steps: 1','completed_steps: 4').replace('current_step_position: 2','current_step_position: 4').replace('remaining_steps_after_current: 2','remaining_steps_after_current: 0').replace('new_generation: 0','new_generation: 3');s=re.sub(r'next_objective:.*','next_objective: Dono avaliar H402v03/H406v02 no contexto das seis fases.',s);s+='''selected_for_owner_review: [H402v03, H406v02]
not_selected: [H402v02]
image_calls_used: 3
evidence: .atena/evidence/sylas-two-frame-correction-2026-10-13.md
gallery: .atena/generated/sylas-two-frame-correction-2026-10-13/index.html
verification: .atena/generated/sylas-two-frame-correction-2026-10-13/verification.json
owner_visual_acceptance: PENDING
''';p.write_text(s,encoding='utf-8')
for n in ['plan.yaml','plan-053-imagens.yaml']:
 p=root/'.atena/state'/n;s=p.read_text(encoding='utf-8');prefix,block=s.split('sylas_two_frame_correction_2026_10_13:',1);block=block.replace('status: IN_PROGRESS','status: TECHNICAL_CORRECTION_COMPLETE_AWAITING_OWNER_VISUAL_ACCEPTANCE').replace('S-002/TWO_FRAME_EDITS','S-004/OWNER_TWO_FRAME_VISUAL_ACCEPTANCE').replace('completed_steps: 0','completed_steps: 4');block+='  selected_for_owner_review: [H402v03, H406v02]\n  evidence: .atena/evidence/sylas-two-frame-correction-2026-10-13.md\n';s=prefix+'sylas_two_frame_correction_2026_10_13:'+block
 if n=='plan-053-imagens.yaml':s=s.replace('S-007/VFX/L-002/CORRECTION_PLAN_APPROVAL','S-007/VFX/L-002/TWO_FRAME_VISUAL_ACCEPTANCE').replace('status: L002_39_ACCEPTED_2_RESERVED_CORRECTION_PROPOSED','status: L002_39_ACCEPTED_2_CORRECTED_AWAITING_OWNER').replace('L00239fases aceitas DRAFT, H403v02 preservado e H402/H406 reservados; proposta de duas correcoes preparada.','L00239fases aceitas, H403v02 preservado; H402v03/H406v02 corrigidos DRAFT aguardam aceite conjunto.').replace('Escolher modo/aprovar sylas-two-frame-correction/v01; depois aceite conjunto dos dois candidatos.','Aceite visual H402v03/H406v02; depois proposta conjunta de admissao42fontes L002.').replace("review: '.atena/generated/assets-l002-review-2026-10-13/index.html'","review: '.atena/generated/sylas-two-frame-correction-2026-10-13/index.html'")
 p.write_text(s,encoding='utf-8')
with (root/'.atena/specs/SPEC-121-retomada-fila-imagens/sylas-two-frame-correction-v01.md').open('a',encoding='utf-8') as f:f.write('\n## Resultado\n\nTécnico4/4: três chamadas built-in, H402v03/H406v02 candidatos propostos; H402v02 preservada/não proposta.39fases e H403v02 intactos; fontes1254nativas preservadas, normalização diferida. Gate visual humano dos dois pendente. [Evidência](../../evidence/sylas-two-frame-correction-2026-10-13.md), [galeria](../../generated/sylas-two-frame-correction-2026-10-13/index.html). Sem runtime/CANON/Git.\n')
with (root/'.atena/backlog/ARTE.md').open('a',encoding='utf-8') as f:f.write('\n2026-10-13 — ART030 L002 correção técnica4/4: H402v03/H406v02 candidatos DRAFT após3chamadas built-in, gate visual conjunto pendente. H402v02 não proposta;39aceites/H403v02/fontes/runtime intactos. Sem admissão/CANON/Git. Evidência `.atena/evidence/sylas-two-frame-correction-2026-10-13.md`.\n')
(out/'verification.json').write_text('{}\n',encoding='utf-8')
checked=0
for p in [root/'.atena/evidence/sylas-two-frame-correction-2026-10-13.md',root/'.atena/specs/SPEC-121-retomada-fila-imagens/sylas-two-frame-correction-v01.md']:
 for link in re.findall(r'\]\(([^)]+)\)',p.read_text(encoding='utf-8')):assert (p.parent/link).exists(),(p,link);checked+=1
links=re.findall(r'(?:src|href)="([^"]+)"',page);assert all((out/link).exists() for link in links)
assert all(sha(root/p)==h for p,h in protected.items())
central=(root/'.atena/state/plan.yaml').read_text(encoding='utf-8');assert re.search(r'active_plan:\s+id: PLAN-071',central) and 'checkpoint: B-006/S-011' in central
v={'status':'PASS_TECHNICAL_OWNER_VISUAL_PENDING','technical_steps_completed':4,'image_calls':3,'candidates':['H402v03','H406v02'],'old_sources_verified':42,'other_acceptances_preserved':39,'runtime_files_unchanged':len(protected),'document_links_verified':checked,'gallery_links_verified':len(links),'native_dimensions':[1254,1254],'normalization_performed':False,'active_plan071_preserved':True,'owner_visual_acceptance':'PENDING','canonical_promotion':False,'runtime_admission':False,'git_operations':'NONE'}
(out/'verification.json').write_text(json.dumps(v,indent=2)+'\n',encoding='utf-8');print(json.dumps(v))
