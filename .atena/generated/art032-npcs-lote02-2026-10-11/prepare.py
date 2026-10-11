"""Prepare the second DRAFT NPC plan. No generation or runtime changes."""
import hashlib
import json
from pathlib import Path
import re

OUT = Path(__file__).resolve().parent
ROOT = OUT.parents[2]
assert not (OUT / 'jobs.json').exists(), 'Do not reset an existing production plan.'
(OUT / 'sources').mkdir(exist_ok=True)
common = '''Use case: stylized-concept.
Asset type: ONE standalone static DRAFT NPC sprite for Nottgard Survivors. Requested square 1024x1024, genuine transparent alpha.
Style: dark fantasy detailed painted pixel-art, deliberate pixel clusters, elevated three-quarter isometric camera, facing lower-right, upper-left light. Ref 1 healer: MATERIALS/PIXEL QUALITY ONLY, never shop, race, costume or identity. Ref 2 Durvall idle strip: CAMERA/PIXEL QUALITY ONLY, never his race, face, weapon, costume or multiple-frame layout.
Composition: exactly one full-body adult figure in neutral idle pose, centered, entire head, feet and accessories inside frame. Visible subject approximately 65-70 percent of canvas height, at least 15 percent empty transparent room at top/bottom. Readable silhouette/costume at 80px. Not a portrait, sheet, animation strip or multiple views.
Constraints: true alpha, no floor/projected shadow, scene, extra figures, labels, writing, logo, frame or watermark. No chibi, photorealistic or vector style. Coherent anatomy/hands, fully clothed, no gore or nudity. Proposed appearance is an experimental DRAFT hypothesis, never an assertion of undocumented canonical anatomy or biography. All weapons/accessories remain lowered, complete and comfortably away from edges. Restrained contrast/glow, no huge halo.
'''
subjects = [
    ('NP04','nyxara','Nyxara', common+'''Subject: Nyxara, ONE of the two Radiant Sisters, an adult female warrior and guide serving Malcanthet in Shendilavri. Lore confirms the role, not species or physical appearance. DRAFT proposal: dark hair tied high, calm attentive expression, fully covering aged-silver practical armor over muted plum cloth, dark boots, a modest sword lowered beside her leg, no raised attack. Distinct slim upright silhouette and visible armor/cloth separation. No wings, horns, halo or angelic/succubus anatomy inferred from the title. No sister beside her, pregnancy or narrative scene.''', [80]),
    ('NP05','vaelis','Vaelis', common+'''Subject: Vaelis, the OTHER Radiant Sister, an adult female warrior and guide in Shendilavri. Role, armor and tiredness are documented; race and physical appearance are not. DRAFT proposal deliberately distinct from Nyxara: long brown braid over one shoulder, fully covering dark aged-bronze armor over grey-mauve fabric, practical boots, slightly tired relaxed shoulders, empty hands or one hand resting neutrally on her belt. Stand unaided, composed and able to act. No pregnancy depiction, injury, seduction, wings, horns, angel halo or narrative event. Exactly one figure.''', [80]),
    ('NP06','grazzt_aliado',"Graz'zt aliado", common+'''Subject: Graz'zt, an Abyssal Lord temporarily allied with the group, summoned through rings; sword use is documented. Physical appearance is undefined in the consulted Nottgard source. DRAFT proposal: tall imposing adult masculine humanoid, dark grey skin, long dark hair, severe composed face, fitted black plate/leather with restrained silver edges, deep-violet mantle, one plain long sword held LOW entirely within frame. Regal disciplined silhouette rather than an attacking boss pose. Do not import an external franchise's six fingers, fixed horns, tail, wings, symbols or distinctive costume. No throne, portal, magical ring, mirror, slain victim or floor. No canonical claim for this proposed appearance. Preserve all cloth/sword within margins.''', [80,128]),
    ('NP07','reaper_barqueiro','Reaper barqueiro', common+'''Subject: ONE Reaper ferryman who conjures a canoe for payment on the Styx. Source defines its role, not exact anatomy or species. DRAFT proposal: upright adult-sized hooded figure in layered worn charcoal-grey ferry-worker cloth, face concealed in natural shadow, scuffed belt with small plain pouch, ONE simple wooden ferry pole held low and entirely within margins. Calm transactional stance, neither attacking nor a giant death apparition. No assertion of skeleton/undead anatomy, skull face, glowing evil eyes, scythe, boat, river, platform, souls or scenery. Distinct hood/pole silhouette readable at 80px.''', [80]),
    ('NP08','vhaerith_aetherion','Vhaerith Aetherion', common+'''Subject: Vhaerith Aetherion, an adult ELF archaeologist and rune scholar imprisoned in Durao. Elf identity and imprisoned role are documented; age styling, face and costume are DRAFT proposals. A mature thoughtful elf with visible pointed ears, long grey hair, worn modest blue-grey layered robe, weathered cloth belt, practical boots, empty lowered hands, tired but welcoming upright pose. Entirely opaque living character, not ghost. No cage, chains, blood, injured hand, received rune, glowing rune inscriptions, book with text, portal, floor or invented sacred mark. The prison is textual context only; do not imply he has been freed.''', [80]),
    ('NP09','mercador_rivenheart','Mercador de Rivenheart', common+'''Subject: ONE anonymous adult merchant from the shop of purported magical items in Rivenheart, Shendilavri. No canonical name, species or gender is assigned. DRAFT proposal: hooded biped with much of the face/ears concealed, restrained dusty-burgundy layered trading coat, dark leather belt and small pouch, sturdy shoes, one open hand in a modest commercial gesture, other hand down. Clear noncombat merchant silhouette. No horns, tail, wings or explicit succubus/incubus anatomy inferred from city demographics. No counter, stall, crates, weapon display, magic demonstration, glittering inventory, enslaved people, text, coins with emblems, floor or background.''', [80])
]
style = ['assets/interactions/curandeiro.png','assets/animations/heroes/durvall/idle.png']
vault = 'F:/dev/nottgard-vault/'
sources = [vault+p for p in ['03_NPCs/Irmãs Radiantes.md','03_NPCs/Nyxara.md','03_NPCs/Vaelis.md',"03_NPCs/Graz'zt.md", "12_Lore/Graz'zt.md",'07_Criaturas/Reaper do Estige.md','03_NPCs/Vhaerith Aetherion.md','04_Locais/Rivenheart.md','10_Sessões/Arco 01 - Nottgard, A Noite Sem Fim/Sessão 15.md','10_Sessões/Arco 01 - Nottgard, A Noite Sem Fim/Sessão 16.md','10_Sessões/Arco 01 - Nottgard, A Noite Sem Fim/Sessão 18.md','10_Sessões/Arco 01 - Nottgard, A Noite Sem Fim/Sessão 19 e 20 (parte 1).md']]
sources += ['data/stage_events.json','.atena/vault/canon/PLAN-001-nottgard-survivors.md','.atena/generated/art032-npcs-2026-10-11/visual-acceptance.json']
def sha(path):
    path = Path(path)
    if not path.is_absolute():
        path = ROOT / path
    return hashlib.sha256(path.read_bytes()).hexdigest()
jobs = [{'code':c,'name':n,'title':t,'revision':'v01','content_state':'DRAFT','status':'PREPARED_PENDING_SCOPE_APPROVAL','prompt':p,'preview_heights':heights,'transparent_background':True,'references':style,'destination':(OUT/'sources'/f'{c}_{n}_v01.png').relative_to(ROOT).as_posix(),'runtime_admission':False} for c,n,t,p,heights in subjects]
data = {'plan':'PLAN-ART032-NPCS-LOTE02','revision':'v01','state':'DRAFT','approval_mode':'per-plan','approval':'PENDING_SCOPE_APPROVAL','owner_front_reply':'Produzir as próximas imagens de ART-032','current_step':'G0/SCOPE_APPROVAL','completed_steps':1,'total_steps':5,'generated':0,'blocking_visual_gaps':0,'identity_status':'ROLES_VERIFIED_PHYSICAL_APPEARANCE_DRAFT_HYPOTHESES','visual_bible':'.atena/vault/drafts/PLAN-ART032-NPCS-LOTE02-v01.md','sources':[{'path':p,'sha256':sha(p),'authority':'CANON_LORE_READ_ONLY' if p.startswith('F:') else 'PROJECT_CONTEXT'} for p in sources],'style_references':[{'path':p,'sha256':sha(p),'role':'STYLE_OR_CAMERA_NOT_IDENTITY'} for p in style],'jobs':jobs,'git_admission_canon_build':'NOT_AUTHORIZED'}
(OUT/'jobs.json').write_text(json.dumps(data,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
(OUT/'prompts.md').write_text('# ART-032 lote 02 — seis prompts DRAFT v01\n\nEscopo preparado, geração aguarda G0.\n\n'+'\n\n'.join('## '+j['code']+' '+j['title']+' v01\n\n```text\n'+j['prompt']+'\n```' for j in jobs)+'\n',encoding='utf-8')
state = '''version: 1
plan: PLAN-ART032-NPCS-LOTE02
revision: v01
card: ART-032
request_classification: PLAN_CHANGE_REQUEST
route: PREPARE_NEXT_IMAGE_LOT_PRESERVE_CLOSED_PILOT_PLAN071_AND_HERO_REVIEW
owner_reply: 'Produzir as próximas imagens de ART-032'
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
proposed_sources: [NP04_NYXARA_v01, NP05_VAELIS_v01, NP06_GRAZZT_v01, NP07_REAPER_v01, NP08_VHAERITH_v01, NP09_MERCADOR_v01]
generated: 0
blocking_visual_gaps: 0
runtime_admission: false
canonical_promotion: false
git_publication_build: NOT_AUTHORIZED
visual_bible: .atena/vault/drafts/PLAN-ART032-NPCS-LOTE02-v01.md
output_package: .atena/generated/art032-npcs-lote02-2026-10-11
evidence: .atena/evidence/art032-npcs-lote02-preparation-2026-10-11.md
next_objective: 'Aprovar o escopo NP04-NP09/v01; depois gerar seis fontes DRAFT na ordem, auditar e apresentar galeria'
preserved_checkpoint: PLAN071_AND_HERO_EXTRACTION_REVIEW
'''
(ROOT/'.atena/state/art032-npcs-lote02.yaml').write_text(state,encoding='utf-8')
rootpath = ROOT/'.atena/state/plan.yaml'
rootstate = rootpath.read_text(encoding='utf-8')
assert rootstate.startswith('version: 2\n')
rootblock = '''art032_npcs_lote02_2026_10_11:
  plan: PLAN-ART032-NPCS-LOTE02
  revision: v01
  card: ART-032
  state_file: .atena/state/art032-npcs-lote02.yaml
  request_classification: PLAN_CHANGE_REQUEST
  status: PREPARED_PENDING_SCOPE_APPROVAL
  mode: per-plan
  checkpoint: G0/SCOPE_APPROVAL
  current_step_position: 2
  completed_steps: 1
  total_steps: 5
  proposed_sources: [NP04, NP05, NP06, NP07, NP08, NP09]
  generated: 0
  content_state: DRAFT
  runtime_admission: false
  canonical_promotion: false
  git_publication_build: NOT_AUTHORIZED
  owner_front_reply: 'Produzir as próximas imagens de ART-032'
  evidence: .atena/evidence/art032-npcs-lote02-preparation-2026-10-11.md
  next_objective: 'Aprovar seis fontes DRAFT NP04-NP09/v01; gerar, auditar e apresentar galeria'
'''
rootpath.write_text('version: 2\n'+rootblock+rootstate[len('version: 2\n'):],encoding='utf-8')
assert rootpath.read_text(encoding='utf-8').split('art032_npcs_piloto_2026_10_11:',1)[1] == rootstate.split('art032_npcs_piloto_2026_10_11:',1)[1]
backlogpath = ROOT/'.atena/backlog/ARTE.md'
backlog = backlogpath.read_text(encoding='utf-8')
line = next(l for l in backlog.splitlines() if l.startswith('| ART-032 |'))
replacement = line[:-1]+' Próximo lote: seis NPCs NP04–NP09 DRAFT, [plano preparado](../vault/drafts/PLAN-ART032-NPCS-LOTE02-v01.md), aguarda G0. |'
backlogpath.write_text(backlog.replace(line,replacement),encoding='utf-8')
evidence = '''# ART-032 lote 02 — preparação, 2026-10-11

O dono esclareceu **“Produzir as próximas imagens de ART-032”**. [Plano DRAFT v01](../vault/drafts/PLAN-ART032-NPCS-LOTE02-v01.md) preparado: NP04 Nyxara, NP05 Vaelis, NP06 Graz'zt aliado, NP07 Reaper barqueiro, NP08 Vhaerith Aetherion, NP09 mercador de Rivenheart. As Irmãs Radiantes têm duas peças distintas. Papéis/lore confirmados; aparência não documentada é hipótese DRAFT, nunca canon presumido. Jaula/canoa/cenários e demais pontos fora do escopo.

[Jobs/fontes e referências SHA256](../generated/art032-npcs-lote02-2026-10-11/jobs.json) e [seis prompts](../generated/art032-npcs-lote02-2026-10-11/prompts.md). Vault e Nottcard somente leitura. Buscas de nomes em arquivos Nottcard e JSONs `F:/dev/nottcard/data/` sem resultados; não é afirmação de inventário global. Canon de estilo PLAN-001 e referências locais de acabamento/câmera; contexto das entidades estruturado antes de imagegen. Nenhuma imagem gerada nesta preparação.

Modo per-plan preservado. S-001 concluído (1/5); G0 antes de S-002 aguarda aceite do escopo exato NP04–NP09/v01. Não confundir aprovação da frente com aprovação desse escopo novo. Novo plano amplia apenas a produção DRAFT e seu gate visual; piloto concluído e cadeia PLAN-071/revisão de heróis preservados. Não altera arquitetura, dependencies, runtime, dados ou fontes anteriormente aceitas. Sem integração, normalização/admissão, CANON, commit, push ou build. [Estado](../state/art032-npcs-lote02.yaml).

Próximo objetivo após G0: seis chamadas individuais builtin imagegen, fontes intactas em `sources/`, auditoria RGBA/hash/margem/corpo inteiro, prévias dos atores 80px (Graz'zt também 128px), galeria/prancha e gate visual S-005 por revisão. Rodar checks locais de referências/hashes/links e backlog; gameplay/playtest não aplicável sem runtime alterado.
'''
evidencepath = ROOT/'.atena/evidence/art032-npcs-lote02-preparation-2026-10-11.md'
evidencepath.write_text(evidence,encoding='utf-8')
for target in re.findall(r'\]\(([^)]+)\)',evidence):
    assert (evidencepath.parent/target).is_file(), target
old_snapshot = json.loads((ROOT/'.atena/generated/art032-npcs-2026-10-11/protected-snapshot.json').read_text(encoding='utf-8'))
for path, expected in old_snapshot.items():
    actual = hashlib.sha256(rootpath.read_text(encoding='utf-8').split('active_plan:',1)[1].encode()).hexdigest() if '#active_plan_tail' in path else sha(path)
    assert actual == expected, path
(OUT/'protected-snapshot.json').write_text(json.dumps(old_snapshot,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
print('Prepared six NPC DRAFT prompts and bounded plan: S-001 complete, G0 pending. References/links/runtime/PLAN071 hashes PASS; no generation or admission.')
