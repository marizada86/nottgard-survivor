"""Prepare one bounded DRAFT proposal. Generation waits for explicit G0 approval."""
from pathlib import Path
import hashlib
import json
import re
import subprocess

OUT=Path(__file__).resolve().parent
ROOT=OUT.parents[2]
assert not (OUT/'jobs.json').exists(), 'Do not reset a prepared checkpoint'
(OUT/'sources').mkdir(exist_ok=True)
def sha(path):
    p=Path(path)
    if not p.is_absolute(): p=ROOT/p
    return hashlib.sha256(p.read_bytes()).hexdigest()
refs=['assets/enemies/receptaculo_de_juiblex.png','assets/enemies/slime_de_juiblex.png']
assert sha('assets/enemies/manifestacao_de_juiblex.png')==sha(refs[0])
prompt='''Use case: stylized-concept.
Asset type: ONE standalone full-body static DRAFT boss sprite for Nottgard Survivors: Manifestation of Juiblex. Square 1024x1024 requested, genuine transparent alpha.
Subject/context: Juiblex is a sticky filamentous hive-mind entity; each manifestation is part of the actual being. This is the active boss of Shedaklah after the alliance with Zuggtmoy, not the dormant ritual mass or unconscious Thullgrime backup. Proposed physical geometry is experimental DRAFT, not a canonical anatomy claim.
Input images: ref 1 receptacle and ref 2 slime enemy are MATERIAL/CAMERA/PIXEL QUALITY/COLOR references ONLY. Never copy their humanoid stance, eyes, exposed luminous nucleus, limb layout or the unconscious backup identity.
Style/medium: dark fantasy painted pixel-art with deliberate clusters; elevated three-quarter isometric view looking down, front toward lower-right, upper-left light. Olive-green/green-black gelatinous surfaces, dark recesses, restrained pale wet glints. Keep broad simple masses legible at 80 and 128 px, not photoreal, vector or chibi.
DRAFT body: ONE cohesive asymmetric amorphous creature with a broad grounded gel base, an off-center raised main lobe and THREE thick attached filament extensions of different lengths curling inward. The silhouette is wider and less human than the upright receptacle. Active watchful neutral/resting pose, not an attack blast. No human anatomy, two legs/two arms, fixed face, visible eyes, closed cocoon or exposed bright nucleus. No tiny separate creatures. Filaments are parts of the body, not background roots.
Composition/framing: entire coherent body centered and SMALL within canvas, max 65 percent of canvas width and height. At least 16 percent clear transparent padding above, below, left and right around all filament tips. Never fill the frame or zoom. Whole base/filaments intact, no visible clipping.
Constraints: actual transparent alpha; one figure only. No floor, projected shadow, backdrop, scene, aura, giant puddle, loose particles/drops, other slimes, victims, ritual, portal, symbols, armor, crown, text, border, watermark, sheet, animation strip or multiple views. No gore or imported external-franchise anatomy. A static original candidate, not a recolor of a reference.
'''
vault='F:/dev/nottgard-vault/'
sources=[vault+'03_NPCs/Juiblex.md',vault+'07_Criaturas/Receptáculo de Juiblex.md']
sources += [vault+'10_Sessões/Arco 01 - Nottgard, A Noite Sem Fim/Sessão '+str(n)+'.md' for n in [12,16,17]]
sources += ['.atena/specs/SPEC-118-acontecimentos-exclusivos-por-fase.md','.atena/vault/canon/PLAN-001-nottgard-survivors.md','data/enemies.json','data/stage_events.json','data/boss_phases.json','ui/enemy_view.gd']
receipts=['.atena/generated/'+p+'/visual-acceptance.json' for p in ['art032-npcs-2026-10-11','art032-npcs-lote02-2026-10-11','art032-pontos-2026-10-11']]
sources+=receipts
snapshot=json.loads((ROOT/'.atena/generated/art032-pontos-2026-10-11/protected-snapshot.json').read_text(encoding='utf-8'))
for directory in ['art032-npcs-2026-10-11','art032-npcs-lote02-2026-10-11','art032-pontos-2026-10-11']:
    for p in (ROOT/'.atena/generated'/directory/'sources').glob('*.png'):
        snapshot[p.relative_to(ROOT).as_posix()]=sha(p)
for p in receipts:
    receipt=json.loads((ROOT/p).read_text(encoding='utf-8'))
    assert receipt['status']=='APPROVED_EXPLICITLY' and receipt['content_state']=='DRAFT'
    snapshot[p]=sha(p)
    for accepted in receipt['accepted']: assert sha(accepted['path'])==accepted['sha256']
rootpath=ROOT/'.atena/state/plan.yaml'
rootbefore=rootpath.read_text(encoding='utf-8')
for p,expected in snapshot.items():
    actual=hashlib.sha256(rootbefore.split('active_plan:',1)[1].encode()).hexdigest() if '#active_plan_tail' in p else sha(p)
    assert actual==expected,p
(OUT/'protected-snapshot.json').write_text(json.dumps(snapshot,indent=2)+'\n',encoding='utf-8')
job={'code':'MJ01','name':'manifestacao_juiblex','title':'Manifestação de Juiblex','revision':'v01','content_state':'DRAFT','status':'PREPARED_PENDING_SCOPE_APPROVAL','prompt':prompt,'transparent_background':True,'references':refs,'preview_heights':[80,128],'destination':'.atena/generated/art032-juiblex-2026-10-12/sources/MJ01_manifestacao_juiblex_v01.png','runtime_admission':False}
comparison='.atena/generated/art032-pontos-2026-10-11/sources/PT04_massa_thullgrime_v02.png'
data={'plan':'PLAN-ART032-JUIBLEX','revision':'v01','content_state':'DRAFT','approval_mode':'per-plan','approval':'PENDING_SCOPE_APPROVAL','owner_front_reply':'atena, continue','request_classification':'PLAN_CHANGE_REQUEST','current_step':'G0/SCOPE_APPROVAL','current_step_position':2,'completed_steps':1,'total_steps':5,'remaining_steps_after_current':3,'generated':0,'blocking_visual_gaps':0,'identity':'JUIBLEX_HIVE_MIND_MANIFESTATION_NOT_UNCONSCIOUS_BACKUP','physical_geometry':'DRAFT_HYPOTHESIS','visual_bible':'.atena/vault/drafts/PLAN-ART032-JUIBLEX-v01.md','sources':[{'path':p,'sha256':sha(p),'authority':'CANON_LORE_READ_ONLY' if p.startswith('F:') else 'PROJECT_CONTEXT_OR_ACCEPTANCE'} for p in sources],'style_references':[{'path':p,'sha256':sha(p),'role':'MATERIAL_CAMERA_NOT_HUMANOID_GEOMETRY'} for p in refs],'comparison_references':[{'path':comparison,'sha256':sha(comparison),'content_state':'DRAFT_VISUALLY_ACCEPTED','role':'DORMANT_VS_ACTIVE_SILHOUETTE_COMPARISON_NOT_EDIT_TARGET'}],'jobs':[job],'canon_admission_commit_push_build':'NOT_AUTHORIZED'}
(OUT/'jobs.json').write_text(json.dumps(data,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
(OUT/'prompts.md').write_text('# MJ01 — Manifestação de Juiblex DRAFT v01\n\nPreparado, geração aguarda aprovação G0; modo per-plan preservado.\n\n```text\n'+prompt+'```\n',encoding='utf-8')
state='''version: 1
plan: PLAN-ART032-JUIBLEX
revision: v01
card: ART-032
request_classification: PLAN_CHANGE_REQUEST
route: PREPARE_NEXT_IMAGE_FRONT_PRESERVE_THREE_CLOSED_LOTS_AND_PLAN071
owner_front_reply: 'atena, continue'
status: PREPARED_PENDING_SCOPE_APPROVAL
approval_mode: per-plan
approval_status: PENDING_SCOPE_APPROVAL
content_state: DRAFT
checkpoint: G0/SCOPE_APPROVAL
current_step_position: 2
completed_steps: 1
total_steps: 5
remaining_steps_after_current: 3
ordered_steps: [S-001, S-002, S-003, S-004, S-005]
completed_ordered_steps: [S-001]
proposed_sources: [MJ01_manifestacao_juiblex_v01]
generated: 0
blocking_visual_gaps: 0
physical_identity: DRAFT_GEOMETRY_HYPOTHESIS_FOR_CANON_LORE_ENTITY
visual_bible: .atena/vault/drafts/PLAN-ART032-JUIBLEX-v01.md
output_package: .atena/generated/art032-juiblex-2026-10-12
evidence: .atena/evidence/art032-juiblex-preparation-2026-10-12.md
runtime_admission: false
canonical_promotion: false
git_publication_build: NOT_AUTHORIZED
human_visual_acceptance: PENDING
preserved_checkpoint: PLAN071_AND_HERO_EXTRACTION_REVIEW
next_objective: 'Aprovar MJ01 DRAFT v01; depois gerar, auditar e comparar com receptáculo e massa a 80/128px'
next_execution_authorized: false
'''
(ROOT/'.atena/state/art032-juiblex.yaml').write_text(state,encoding='utf-8')
assert rootbefore.startswith('version: 2\n') and 'art032_juiblex_2026_10_12:' not in rootbefore
block='''art032_juiblex_2026_10_12:
  plan: PLAN-ART032-JUIBLEX
  revision: v01
  state_file: .atena/state/art032-juiblex.yaml
  request_classification: PLAN_CHANGE_REQUEST
  status: PREPARED_PENDING_SCOPE_APPROVAL
  mode: per-plan
  approval_status: PENDING_SCOPE_APPROVAL
  checkpoint: G0/SCOPE_APPROVAL
  current_step_position: 2
  completed_steps: 1
  total_steps: 5
  remaining_steps_after_current: 3
  proposed_sources: [MJ01]
  generated: 0
  content_state: DRAFT
  runtime_admission: false
  canonical_promotion: false
  git_publication_build: NOT_AUTHORIZED
  evidence: .atena/evidence/art032-juiblex-preparation-2026-10-12.md
  owner_front_reply: 'atena, continue'
  next_objective: 'Aprovar plano MJ01 DRAFT; gerar, auditar e apresentar comparação 80/128px'
  next_execution_authorized: false
'''
rootpath.write_text('version: 2\n'+block+rootbefore[len('version: 2\n'):],encoding='utf-8')
assert rootpath.read_text(encoding='utf-8').split('art032_pontos_2026_10_11:',1)[1]==rootbefore.split('art032_pontos_2026_10_11:',1)[1]
evidence='''# ART-032 — preparação da Manifestação de Juiblex, 2026-10-12

Pedido **“atena, continue”** após identificar a próxima imagem pendente. [Plano/bíblia DRAFT v01](../vault/drafts/PLAN-ART032-JUIBLEX-v01.md) preparado com uma fonte **MJ01**: criatura amorfa ativa, base larga/lobo assimétrico e filamentos espessos; geometria experimental, sem núcleo/casulo e sem pose humanoide copiada. Identidade/lore e cena estruturadas antes da produção. [Estado](../state/art032-juiblex.yaml), [jobs/referências SHA256](../generated/art032-juiblex-2026-10-12/jobs.json), [prompt](../generated/art032-juiblex-2026-10-12/prompts.md).

Vault somente leitura: Juiblex/Receptáculo e Sessões 12/16/17. Contexto SPEC-118 e dados locais do chefe/pacto/fases. Fontes runtime Manifestação e Receptáculo têm SHA256 idêntico, confirmando reaproveitamento provisório. Referências PNG inspecionadas para material/câmera; aparência não importa anatomia de franquia. Nottcard somente leitura: buscas de filenames visuais e termo nos JSONs data sem resultado, sem alegar ausência global. Dezesseis selecionadas aceitas em vinte e quatro fontes históricas e três recibos protegidos/verificados; runtime/ativos/cauda PLAN-071 preservados por hash.

**S-001 concluída (1/5); G0/SCOPE_APPROVAL antes de S-002 pendente.** Modo per-plan preservado, sem repetir seleção. Zero lacunas BLOCKING visuais para experimento; aprovação operacional de escopo permanece pendente porque é novo plano. Nenhuma imagem gerada. Não há integração, normalização/admissão, CANON, commit, push ou build. Próximo objetivo: após G0, gerar MJ01 intacta, auditar alfa/margem/corpo/identidade e comparação a 80/128px, entregar galeria/prancha para aceite visual S-005. Checks de refs/links/estado/backlog/snapshot; gameplay não aplicável sem runtime alterado. Bugs: P0=0, quatro P1 abertos, quatorze implementados aguardando playtest.
'''
(ROOT/'.atena/evidence/art032-juiblex-preparation-2026-10-12.md').write_text(evidence,encoding='utf-8')
backlogpath=ROOT/'.atena/backlog/ARTE.md'
backlog=backlogpath.read_text(encoding='utf-8')
line=next(l for l in backlog.splitlines() if l.startswith('| ART-032 |'))
replacement=line[:-1]+' MJ01 Manifestação de Juiblex DRAFT v01: [plano preparado](../vault/drafts/PLAN-ART032-JUIBLEX-v01.md), aguarda G0; sem geração/admissão. |'
backlogpath.write_text(backlog.replace(line,replacement),encoding='utf-8')
for relative in ['.atena/vault/drafts/PLAN-ART032-JUIBLEX-v01.md','.atena/evidence/art032-juiblex-preparation-2026-10-12.md']:
    path=ROOT/relative
    for link in re.findall(r'\]\(([^)]+)\)',path.read_text(encoding='utf-8')): assert (path.parent/link).resolve().is_file(),link
assert not subprocess.check_output(['git','diff','--cached','--name-only'],cwd=ROOT).strip()
verification={'plan':data['plan'],'revision':'v01','status':'PASS_PREPARED_PENDING_G0','completed_steps':1,'total_steps':5,'proposed_sources':1,'generated':0,'visual_blocking_gaps':0,'approval_mode':'per-plan','scope_approval':'PENDING','lore_refs_and_comparison_hashes':'PASS','prior_sixteen_accepted_sources_receipts_and_runtime':'UNCHANGED_HASH_VERIFIED','plan071_return_chain':'UNCHANGED_HASH_VERIFIED','links_contract_and_state':'PASS','placeholder_manifestation_equals_receptacle':True,'index':'EMPTY','next_execution_authorized':False}
(OUT/'preparation-verification.json').write_text(json.dumps(verification,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
print('S-001 PASS: MJ01 DRAFT scope/prompt/identity/lore/refs/links/snapshot prepared; 1/5 done; G0 pending, generation not started.')
