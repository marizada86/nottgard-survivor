"""Prepare the authorized six event-point DRAFT sources; no runtime mutations."""
import hashlib
import json
from pathlib import Path
import subprocess

OUT = Path(__file__).resolve().parent
ROOT = OUT.parents[2]
assert not (OUT/'jobs.json').exists(), 'Never reset a production checkpoint'
(OUT/'sources').mkdir(exist_ok=True)
OWNER = 'atena, aprovado, commite e continue a Próxima frente proposta: os pontos de acontecimentos restantes de ART-032.'
common = '''Use case: stylized-concept.
Asset type: ONE standalone static DRAFT isometric event-point raster prop for Nottgard Survivors, requested square 1024x1024 with genuine transparent alpha background.
Style/medium: dark fantasy painted pixel-art, deliberate pixel clusters, worn materials, elevated three-quarter isometric camera looking down, front visible toward lower-right, light upper-left. Material detail subordinate to a clear silhouette at small sizes. No modern/vector/chibi/photoreal style.
Composition: ONE complete object centered, about 65-70 percent of canvas extent, at least 15 percent clear transparent space around all extremities. Keep the entire object, attached drips/caps/corners, and restrained highlights away from all canvas edges. An isolated asset, not a scene, sheet, collage or multiple views.
Constraints: actual transparent background; no floor, backdrop, projected shadow, other objects/characters, text, letters, logo, watermark, framing or pedestal unrelated to the object. No broad halo or loose particles. Entire subject visible. Physical geometry is an experimental DRAFT proposal, not new canon. References concern style/material only; never reproduce their literal subjects or layouts.
'''
chest = 'assets/interactions/chest_closed.png'
mass = 'assets/enemies/receptaculo_de_juiblex.png'
slime = 'assets/enemies/slime_de_juiblex.png'
specs = [
 ('PT02','trono_zuggtmoy','Trono de Zuggtmoy',[80,128],[chest],'''Subject: ONE EMPTY fungal throne, a delivery landmark in Zuggtmoy's palace in Shedaklah. Lore documents fungal sovereign and palace but not throne geometry. DRAFT form: compact high-backed chair grown from dark weathered brown wood entwined with thick mycelium, coherent seat and two armrests; a few large muted-mauve shelf mushroom caps integrated along the back and lower sides. Read clearly as a throne at 80px. Restrained organic elegance, simple asymmetrical cap clusters, soft ivory mycelium edges. No queen, humanoid face, crown, sacred symbol, chest, room, decorative scattered mushrooms, gore or shiny gold furniture. Input reference: chest is CAMERA/PIXEL/MATERIAL quality only; do not make a chest.'''),
 ('PT03','arco_pedra','Arco de pedra',[80,128],[chest],'''Subject: ONE ancient INACTIVE stone arch portal with NO traversable opening. Lore: stone arch without passage, old marks that require fungus and slime plus strong essence; portal is not active in this state. DRAFT geometry: freestanding thick weathered grey-stone arch outline with a dark OPAQUE stone/slate face filling the central span, two stout jambs and a rounded lintel; a small compact foot integral to the arch, no surrounding floor. A few shallow abstract worn notches, no readable alphabet or sacred seal asserted as canon. Central panel reads as sealed solid dark stone, NOT a view of background/transparent hole, liquid curtain or lit portal. Quiet muted grey/umber, sparse moss. Entire arch and foot complete. No purple/green portal effect, columns from a temple, room or people. Input reference: chest CAMERA/PIXEL/MATERIAL quality only, not its subject.'''),
 ('PT04','massa_thullgrime','Massa de Thullgrime',[80,128],[chest,mass],'''Subject: ONE dormant Thullgrime ritual mass, an event landmark BEFORE it awakens as Juiblex's receptacle. Lore documents a mass of flesh and slime with a cocoon and eyes at the center, sustained by ritual. DRAFT form: low broad asymmetrical mound of olive-green viscous slime intertwined with restrained muted-mauve organic folds, a rounded closed cocoon bulging centrally, a few small dull amber eyes nestled close around this center. CLEARLY RESTING MOUND, NOT a standing humanoid/monster, not attacking. Readable central cocoon and mound silhouette at 80/128px. Organic flesh stylized and restrained, no open wounds, body parts, teeth, blood or realistic gore. No cultists, crates, ritual ring, active portal, floor or extra scene. Reference 1 chest: CAMERA/PIXEL quality only. Reference 2 receptacle: OLIVE SLIME texture, amber eye color and restrained wet glints only; do NOT copy upright humanoid pose, limbs or exposed bright nucleus.'''),
 ('PT05','coracao_limo','Coração de Limo',[48,80],[chest,mass],'''Subject: ONE collectible slime-heart CORE from Juiblex's receptacle, an item delivered to Zuggtmoy. Physical heart shape is not documented; propose a compact organic ovoid gelatinous nucleus with asymmetric olive-green outer membrane and contained yellow-green pulsing-looking center, several thick short filaments folded tightly around the core. Static sprite, no animated pulse. Readable rounded CORE at 48px, strong contained bright center, dark olive edge, no large halo. NOT a literal anatomical human heart, gemstone, egg shell, severed organ, enemy, face or eyeball. No blood, container, pedestal, surrounding puddle, loose droplets or particles. Input 1 chest CAMERA/PIXEL quality only; input 2 receptacle SLIME/CORE MATERIAL and color only, no figure or eyes.'''),
 ('PT06','esporo_zuggtmoy','Esporo de Zuggtmoy',[48,80],[chest],'''Subject: ONE collectible unit of fungal matter called a spore of Zuggtmoy, paired with Juiblex's slime in the stone-arch event. Exact spore anatomy is undocumented, so use a DRAFT compact fungal capsule/puffball, rounded muted-mauve textured cap with several large clear ridges/pores and a very short off-white mycelial base integrated into the same object. One cohesive fungal unit, not a group of mushrooms or microscopic diagram. A substantial pale underside/ridged edge distinguishes it at 48px. Organic rather than a jewel, dull plum cap/ivory mycelium, restrained luminosity, no cloud, particles, butterflies, faces, sacred emblem, plant pot, forest or floor. Do not invent a visible magical alphabet. Input chest CAMERA/PIXEL/MATERIAL quality only, never chest structure.'''),
 ('PT07','limo_juiblex','Limo de Juiblex',[48,80],[chest,slime],'''Subject: ONE small collectible PORTION OF SLIME from Juiblex, paired with Zuggtmoy's fungal spore at the stone arch. Compact irregular droplet-shaped olive/acid-green gelatinous lump with short attached folded filaments and two or three controlled wet surface highlights. Low asymmetrical silhouette, wider base, one modest tapered rise, no separate detached drops. Reads clearly as goo at 48px. Distinct from the slime-heart: NO bright internal core/nucleus, no round jewel-like capsule. No eyes, face, limbs, humanoid posture, teeth, horn or creature anatomy. No ground tile, large puddle, container, halo, scene or particles. Input 1 chest CAMERA/PIXEL quality only; input 2 slime enemy SLIME TEXTURE and color only, never humanoid silhouette/eyes/limbs.''')
]

def sha(path):
    p = Path(path)
    if not p.is_absolute(): p = ROOT/p
    return hashlib.sha256(p.read_bytes()).hexdigest()

vault = 'F:/dev/nottgard-vault/'
sources = [vault+p for p in ['03_NPCs/Zuggtmoy.md','03_NPCs/Juiblex.md','04_Locais/Palácio de Zuggtmoy.md','04_Locais/Thullgrime.md','07_Criaturas/Receptáculo de Juiblex.md']]
sources += [vault+'10_Sessões/Arco 01 - Nottgard, A Noite Sem Fim/Sessão '+str(n)+'.md' for n in [15,16,17]]
sources += ['data/stage_events.json','.atena/vault/canon/PLAN-001-nottgard-survivors.md','.atena/generated/art032-npcs-2026-10-11/visual-acceptance.json','.atena/generated/art032-npcs-lote02-2026-10-11/visual-acceptance.json']
jobs = [{'code':c,'name':n,'title':t,'revision':'v01','content_state':'DRAFT','status':'PREPARED_AUTHORIZED','prompt':common+s,'preview_heights':h,'transparent_background':True,'references':r,'destination':(OUT/'sources'/f'{c}_{n}_v01.png').relative_to(ROOT).as_posix(),'runtime_admission':False} for c,n,t,h,r,s in specs]
data = {'plan':'PLAN-ART032-PONTOS','revision':'v01','content_state':'DRAFT','approval_mode':'per-plan','approval':'APPROVED_PER_PLAN','owner_reply':OWNER,'approval_authority':'EXPLICIT_CONTINUATION_OF_PREVIOUSLY_NAMED_SIX_POINT_FRONT','current_step':'S-002/PRODUCTION','completed_steps':1,'total_steps':5,'generated':0,'blocking_visual_gaps':0,'visual_bible':'.atena/vault/drafts/PLAN-ART032-PONTOS-v01.md','sources':[{'path':p,'sha256':sha(p),'authority':'CANON_LORE_READ_ONLY' if p.startswith('F:') else 'PROJECT_CONTEXT'} for p in sources],'style_references':[{'path':p,'sha256':sha(p),'role':'STYLE_CAMERA_OR_MATERIAL_NOT_POSE_IDENTITY'} for p in [chest,mass,slime]],'jobs':jobs,'git_admission_canon_push_build':'NOT_AUTHORIZED_FOR_NEW_OUTPUTS'}
(OUT/'jobs.json').write_text(json.dumps(data,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
(OUT/'prompts.md').write_text('# ART-032 pontos — seis prompts efetivos DRAFT v01\n\nProdução autorizada pela continuação explícita da frente proposta; per-plan.\n\n'+'\n\n'.join('## '+j['code']+' '+j['title']+' v01\n\n```text\n'+j['prompt']+'\n```' for j in jobs)+'\n',encoding='utf-8')
snapshot = json.loads((ROOT/'.atena/generated/art032-npcs-lote02-2026-10-11/protected-snapshot.json').read_text(encoding='utf-8'))
for directory in ['art032-npcs-2026-10-11','art032-npcs-lote02-2026-10-11']:
    for path in (ROOT/'.atena/generated'/directory/'sources').glob('*.png'):
        snapshot[path.relative_to(ROOT).as_posix()] = sha(path)
    receipt = ROOT/'.atena/generated'/directory/'visual-acceptance.json'
    snapshot[receipt.relative_to(ROOT).as_posix()] = sha(receipt)
for path, expected in snapshot.items():
    if '#active_plan_tail' in path:
        actual = hashlib.sha256((ROOT/'.atena/state/plan.yaml').read_text(encoding='utf-8').split('active_plan:',1)[1].encode()).hexdigest()
    else: actual = sha(path)
    assert actual == expected, path
(OUT/'protected-snapshot.json').write_text(json.dumps(snapshot,indent=2)+'\n',encoding='utf-8')
state = '''version: 1
plan: PLAN-ART032-PONTOS
revision: v01
card: ART-032
request_classification: PLAN_CHANGE_REQUEST
route: EXECUTE_APPROVED_NAMED_SIX_POINT_FRONT_PRESERVE_CLOSED_LOTS_AND_PLAN071
status: APPROVED_IN_PROGRESS
approval_mode: per-plan
approval_status: APPROVED_EXPLICITLY
content_state: DRAFT
checkpoint: S-002/PRODUCTION
current_step_position: 2
completed_steps: 1
total_steps: 5
remaining_steps_after_current: 3
ordered_steps: [S-001, S-002, S-003, S-004, S-005]
completed_ordered_steps: [S-001]
proposed_sources: [PT02, PT03, PT04, PT05, PT06, PT07]
generated: 0
blocking_visual_gaps: 0
runtime_admission: false
canonical_promotion: false
git_publication_build: NOT_AUTHORIZED_FOR_NEW_OUTPUTS
visual_bible: .atena/vault/drafts/PLAN-ART032-PONTOS-v01.md
output_package: .atena/generated/art032-pontos-2026-10-11
evidence: .atena/evidence/art032-pontos-2026-10-11.md
human_visual_acceptance: PENDING
preserved_checkpoint: PLAN071_AND_HERO_EXTRACTION_REVIEW
next_objective: 'Gerar PT02-PT07 na ordem aprovada, preservar originais, auditar e apresentar galeria para S-005'
'''
state += 'scope_owner_reply: '+json.dumps(OWNER,ensure_ascii=False)+'\napproved_date: "2026-10-11"\n'
(ROOT/'.atena/state/art032-pontos.yaml').write_text(state,encoding='utf-8')
rootpath = ROOT/'.atena/state/plan.yaml'
before = rootpath.read_text(encoding='utf-8')
assert before.startswith('version: 2\n')
assert 'art032_pontos_2026_10_11:' not in before
block = '''art032_pontos_2026_10_11:
  plan: PLAN-ART032-PONTOS
  revision: v01
  state_file: .atena/state/art032-pontos.yaml
  request_classification: PLAN_CHANGE_REQUEST
  status: APPROVED_IN_PROGRESS
  mode: per-plan
  approval_status: APPROVED_EXPLICITLY
  checkpoint: S-002/PRODUCTION
  current_step_position: 2
  completed_steps: 1
  total_steps: 5
  remaining_steps_after_current: 3
  proposed_sources: [PT02, PT03, PT04, PT05, PT06, PT07]
  generated: 0
  content_state: DRAFT
  runtime_admission: false
  canonical_promotion: false
  git_publication_build: NOT_AUTHORIZED_FOR_NEW_OUTPUTS
  evidence: .atena/evidence/art032-pontos-2026-10-11.md
  next_objective: 'Gerar seis pontos DRAFT, auditar e apresentar galeria; aceite visual S-005 pendente'
'''
block += '  scope_owner_reply: '+json.dumps(OWNER,ensure_ascii=False)+'\n'
rootpath.write_text('version: 2\n'+block+before[len('version: 2\n'):],encoding='utf-8')
assert rootpath.read_text(encoding='utf-8').split('art032_npcs_lote02_2026_10_11:',1)[1] == before.split('art032_npcs_lote02_2026_10_11:',1)[1]
evidence = '''# ART-032 pontos — 2026-10-11

Preparação S-001 concluída, 1/5. Continuação da frente de seis pontos já proposta e explicitamente aprovada pelo dono; modo per-plan preservado. [Plano/bíblia DRAFT v01](../vault/drafts/PLAN-ART032-PONTOS-v01.md), [estado](../state/art032-pontos.yaml), [jobs/fontes/referências SHA256](../generated/art032-pontos-2026-10-11/jobs.json), [prompts](../generated/art032-pontos-2026-10-11/prompts.md). A resposta atual autoriza PT02 trono, PT03 arco, PT04 massa, PT05 coração, PT06 esporo e PT07 limo, sem ampliar à Manifestação de Juiblex.

Lore consultada no vault somente leitura; contexto mecânico local diferenciado do relato de campanha. Referências PNG locais inspecionadas antes da produção, papéis de câmera/material documentados. Identidade pessoal N/A nos objetos; afiliação/material/contexto verificados; massa corresponde ao receptáculo dormente. Geometrias não documentadas são hipóteses DRAFT. Nenhuma lacuna BLOCKING para experimento aprovado. Não houve geração nesta preparação; próximos outputs são seis fontes e galeria/auditoria, seguido de aceite visual humano S-005.

Commit anterior verificado: 51b51f7369ae34eede997435e6eb52ea057daf25, 65 arquivos, dez candidatas aceitas/treze originais. Índice vazio após commit; demais modificações preservadas. [Verificação pré-commit](../generated/art032-commit-2026-10-11/precommit-verification.json). Este plano não autoriza novo commit, integração, normalização/admissão, CANON, push ou build. Snapshot protege runtime, fontes anteriores/recibos e cauda PLAN-071. Sem gameplay/playtest nesta produção isolada.
'''
(ROOT/'.atena/evidence/art032-pontos-2026-10-11.md').write_text(evidence,encoding='utf-8')
backlogpath = ROOT/'.atena/backlog/ARTE.md'
backlog = backlogpath.read_text(encoding='utf-8')
line = next(l for l in backlog.splitlines() if l.startswith('| ART-032 |'))
backlogpath.write_text(backlog.replace(line,line[:-1]+' Próxima frente: PT02–PT07 DRAFT, [plano aprovado](../vault/drafts/PLAN-ART032-PONTOS-v01.md), em produção. |'),encoding='utf-8')
commit = subprocess.check_output(['git','rev-parse','HEAD'],cwd=ROOT).decode().strip()
assert commit == '51b51f7369ae34eede997435e6eb52ea057daf25'
assert not subprocess.check_output(['git','diff','--cached','--name-only'],cwd=ROOT).strip()
receipt = {'commit':commit,'branch':subprocess.check_output(['git','branch','--show-current'],cwd=ROOT).decode().strip(),'owner_reply':OWNER,'status':'LOCAL_COMMIT_VERIFIED','files':65,'accepted_draft_sources':10,'native_outputs_preserved':13,'index_after_commit':'EMPTY','push':False,'canon_promotion':False,'runtime_changes':False}
(ROOT/'.atena/generated/art032-commit-2026-10-11/commit-receipt.json').write_text(json.dumps(receipt,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
print('S-001 PASS: approved six-point front, lore/refs/snapshot verified; S-002 authorized; previous commit verified.')
