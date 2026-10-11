"""Finish audited DRAFT delivery; leave exact owner visual gate pending."""
import hashlib
from html.parser import HTMLParser
import json
from pathlib import Path
import re
from PIL import Image
OUT = Path(__file__).resolve().parent
ROOT = OUT.parents[2]
assert not (OUT/'visual-acceptance.json').exists(), 'Closed owner-approved lot; preserve acceptance.'
jobs = json.loads((OUT/'jobs.json').read_text(encoding='utf-8'))
audit = json.loads((OUT/'audit.json').read_text(encoding='utf-8'))
assert audit['status']=='PASS_WITH_NATIVE_ALPHA_NOTE'
assert [(j['code'],j['revision']) for j in jobs['jobs']]==[('NP04','v02'),('NP05','v01'),('NP06','v02'),('NP07','v01'),('NP08','v01'),('NP09','v01')]
class Parser(HTMLParser):
    def __init__(self):
        super().__init__(); self.links=[]; self.previews=[]
    def handle_starttag(self,tag,attrs):
        attrs=dict(attrs)
        for key in ['src','href','data-source']:
            if key in attrs:self.links.append(attrs[key])
        if tag=='canvas':self.previews.append(attrs)
parser=Parser(); parser.feed((OUT/'index.html').read_text(encoding='utf-8'))
assert len(parser.previews)==7
for link in parser.links:assert (OUT/link).is_file(),link
for job in jobs['jobs']:
    previews=[p for p in parser.previews if Path(p['data-source']).name==Path(job['destination']).name]
    assert [int(p['data-height']) for p in previews]==job['preview_heights']
    assert all(json.loads(p['data-box'])==job['audit']['bbox_alpha_above8'] for p in previews)
with Image.open(OUT/'review-reading.png') as image:
    assert image.size==(1000,1120)
log=(OUT/'preview-renderer/render-log.txt').read_text(encoding='utf-8')
assert 'Rendered seven reading previews' in log and 'SCRIPT ERROR' not in log
qa={'plan':jobs['plan'],'revision':'v01','content_state':'DRAFT','gallery_local_links':'PASS','gallery_metadata':'PASS','preview_count':7,'preview_heights':[80,80,80,128,80,80,80],'reading_render':'GODOT_SUBVIEWPORT_OPENGL_COMPATIBILITY','reading_image':'review-reading.png','reading_image_size':[1000,1120],'reading_image_sha256':hashlib.sha256((OUT/'review-reading.png').read_bytes()).hexdigest(),'reading_inspection':'COMPLETED_BY_ATENA','browser_render_verification':'NOT_ATTEMPTED_KNOWN_FILE_URL_POLICY_BLOCK_FROM_PILOT','browser_workaround_attempted':False,'native_pixels_changed_by_preview':False,'human_visual_acceptance':'PENDING','playtest':'NOT_PERFORMED','reading_observations':{'NP04_v02':'Silver/plum armor, tied dark hair and lowered sword distinguish Nyxara at 80px.','NP05_v01':'Braid, bronze armor, pale cloth and empty hands distinguish Vaelis at 80px.','NP06_v02':'Purple mantle/dark armor/sword remain readable at 80 and 128px; proposed physique is DRAFT.','NP07_v01':'Hood and ferry pole remain distinct at 80px.','NP08_v01':'Grey hair, blue robe and unarmed posture readable at 80px; belt parchment/ornaments are proposed costume only.','NP09_v01':'Burgundy hood, pouch and open hand read as commercial/noncombat pose at 80px.'},'renderer_notes':['Initial root-window capture was clamped by screen size and clipped lower row; changed to independent 1000x1120 SubViewport and inspected complete final PNG.','Shader cache/certificate-store warnings under sandbox did not prevent rendering; no network operation.'],'limits':['Technical inspection is not owner acceptance or map contrast validation','Alpha >8 bbox only approximates visible motif','No native PNG resizing/cleaning or game admission']}
(OUT/'gallery-qa.json').write_text(json.dumps(qa,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
audit.update({'gallery_qa':'gallery-qa.json','reading_preview':'review-reading.png','browser_render_verification':qa['browser_render_verification']})
(OUT/'audit.json').write_text(json.dumps(audit,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
jobs.update({'gallery_qa':'gallery-qa.json','reading_preview':'review-reading.png','step_results':[{'step':'S-001','status':'COMPLETED','result':'Six roles/identities/context/readiness/source hashes/prompts prepared; exact production scope approved.'},{'step':'S-002','status':'COMPLETED','result':'Six candidates/eight unchanged native outputs; NP04 v02 margin and NP06 v02 ear correction; previous versions preserved.'},{'step':'S-003','status':'COMPLETED','result':'Native alpha/PNG/RGBA/margins/hash/reference/prior accepted/runtime/PLAN071 audits pass with native alpha note; seven reading samples inspected.'},{'step':'S-004','status':'COMPLETED','result':'HTML references/metadata and complete Godot 1000x1120 reading sheet verified; evidence and owner review objective recorded.'},{'step':'S-005','status':'PENDING_OWNER_VISUAL_REVIEW','result':'Exact six revisions await explicit owner visual acceptance or identified corrections.'}]})
(OUT/'jobs.json').write_text(json.dumps(jobs,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
planpath=ROOT/'.atena/vault/drafts/PLAN-ART032-NPCS-LOTE02-v01.md'
plan=planpath.read_text(encoding='utf-8').replace('status: APPROVED_IN_EXECUTION','status: GENERATED_AUDITED_WAITING_VISUAL_APPROVAL')
plan += '\n## Entrega para S-005 — 2026-10-11\n\n**4/5 passos concluídos.** Candidatas DRAFT: **NP04 Nyxara v02, NP05 Vaelis v01, NP06 Graz’zt v02, NP07 Reaper v01, NP08 Vhaerith v01, NP09 mercador v01**. S-002: oito chamadas/saídas nativas, seis candidatas; S-003: alfa/hashes/margens/contexto e leitura verificadas; S-004: galeria, prancha e evidência entregues. Histórico NP04/NP06 v01 preservado, não selecionado. Fontes reais 1254×1254, sem limpeza/redimensionamento nativo; cinco bordas têm alfa 1/255, Vhaerith tem borda vazia. [Evidência de entrega](../../evidence/art032-npcs-lote02-delivery-2026-10-11.md). O texto de preparação acima preserva o histórico anterior a G0.\n\nPróximo objetivo: dono conferir estilo/câmera, distinção das duas Irmãs, proposta física de Graz’zt e leitura/gestos de Reaper/Vhaerith/mercador a 80px (Graz’zt também 128px). Inputs são fontes/revisões e prancha; saída é aceite visual identificado ou correções por código. Aparências e adornos continuam hipóteses DRAFT; o pergaminho no cinto de Vhaerith não é a runa devida. Aprovação S-005 pendente e não autoriza integração, CANON, commit ou push.\n'
planpath.write_text(plan,encoding='utf-8')
evidence='''# ART-032 LOTE02/v01 — entrega DRAFT, 2026-10-11

[Plano](../vault/drafts/PLAN-ART032-NPCS-LOTE02-v01.md), modo per-plan, execução aprovada **antes da geração** com “Aprovo as seis peças DRAFT”. Quatro de cinco etapas concluídas; S-005 visual pendente. [Preparação anterior](art032-npcs-lote02-preparation-2026-10-11.md) preserva a prontidão e o estado pré-G0. [Estado atual](../state/art032-npcs-lote02.yaml).

| Candidata DRAFT | Fonte nativa selecionada | Margem mínima alfa >8 | Alfa máximo na borda |
|---|---|---:|---:|
| NP04 Nyxara v02 | [PNG](../generated/art032-npcs-lote02-2026-10-11/sources/NP04_nyxara_v02.png) | 15,31% | 1/255 |
| NP05 Vaelis v01 | [PNG](../generated/art032-npcs-lote02-2026-10-11/sources/NP05_vaelis_v01.png) | 11,88% | 1/255 |
| NP06 Graz’zt aliado v02 | [PNG](../generated/art032-npcs-lote02-2026-10-11/sources/NP06_grazzt_aliado_v02.png) | 12,28% | 1/255 |
| NP07 Reaper barqueiro v01 | [PNG](../generated/art032-npcs-lote02-2026-10-11/sources/NP07_reaper_barqueiro_v01.png) | 16,59% | 1/255 |
| NP08 Vhaerith Aetherion v01 | [PNG](../generated/art032-npcs-lote02-2026-10-11/sources/NP08_vhaerith_aetherion_v01.png) | 12,60% | 0/255 |
| NP09 mercador de Rivenheart v01 | [PNG](../generated/art032-npcs-lote02-2026-10-11/sources/NP09_mercador_rivenheart_v01.png) | 14,51% | 1/255 |

Oito saídas via **built-in image_gen**, na ordem NP04–NP09 com correções antes de avançar. Todas as fontes nativas reais 1254×1254 PNG RGBA (pedido 1024×1024), copiadas byte a byte com hash idêntico ao original. Nenhum PNG fonte redimensionado/limpo. Cinco fontes têm resíduo nativo de alfa 1/255 na borda, preservado; isso não é corte visível do corpo/acessório. Transparência real e margem mínima contratada de 10% passam em todas as candidatas; bbox alfa >8 é aproximação de visibilidade.

Histórico: [NP04 v01](../generated/art032-npcs-lote02-2026-10-11/sources/NP04_nyxara_v01.png) teve margem 4,78%; correção dirigida de enquadramento via imagegen criou v02. [NP06 v01](../generated/art032-npcs-lote02-2026-10-11/sources/NP06_grazzt_aliado_v01.png) apresentou orelha élfica não prevista; v02 corrigiu para orelha arredondada, evitando transferência de identidade da referência Durvall. Ambas v01 preservadas, não selecionadas. Prompts seguintes reforçaram apenas a invariância de enquadramento/margem; nenhuma mudança de lore, escopo ou estilo.

Papéis/contexto e revisões das referências estruturados antes da produção. Vault de Nottgard e Nottcard somente leitura; lore canônica define papéis, mas detalhes físicos/figurino não documentados são hipóteses DRAFT. Nyxara e Vaelis têm fontes separadas. Reaper/mercador com rosto oculto, sem fixar espécie/gênero; Graz’zt com proposta física experimental, sem anatomia externa tratada como canon. Vhaerith é elfo confirmado; seu pergaminho/adornos de cinto são detalhes de figurino proposto, não a runa pedida ou conclusão de quest. Padrões de roupa e ornamentos não afirmam símbolos sagrados. Jaula, canoa, ambientes e cenas não incluídos. [Jobs, hashes, prompts efetivos e origem de cada saída](../generated/art032-npcs-lote02-2026-10-11/jobs.json); [prompts completos com histórico](../generated/art032-npcs-lote02-2026-10-11/prompts.md).

[Auditoria](../generated/art032-npcs-lote02-2026-10-11/audit.json): PASS_WITH_NATIVE_ALPHA_NOTE. Hashes dos originais, referências, quatro fontes aceitas do piloto, arquivos runtime/assets/data/testes protegidos e cadeia ativa PLAN-071 verificados inalterados. HEAD fc5c709f3ef5c4acdc7c5a8a842747b72c7f70ec. Sem integração, normalização/admissão, promoção a CANON, commit, push ou build. Testes de gameplay não reexecutados, pois nenhum código/runtime mudou; nenhum playtest realizado.

[Galeria](../generated/art032-npcs-lote02-2026-10-11/index.html): todos os links locais e sete prévias/metadados verificados. Browser não usado para file://, seguindo o bloqueio já registrado no piloto; sem contorno e sem alegar renderização HTML verificada. [Prancha Godot](../generated/art032-npcs-lote02-2026-10-11/review-reading.png) completa 1000×1120, inspeção Atena: seis atores distinguíveis a 80px; Graz’zt também a 128px. Recorte visível feito apenas em memória; fontes intactas. [QA](../generated/art032-npcs-lote02-2026-10-11/gallery-qa.json), [render log](../generated/art032-npcs-lote02-2026-10-11/preview-renderer/render-log.txt). Primeira captura por janela foi limitada pelo monitor e cortou a segunda linha; refeita em SubViewport independente. Avisos ambientais de cache de shader/certificados não impediram o PNG; nenhuma operação de rede.

## Próximo checkpoint

S-005, posição 5/5, quatro concluídos, zero após o passo atual. Dono avaliar **NP04 v02, NP05 v01, NP06 v02, NP07 v01, NP08 v01, NP09 v01**: estilo/câmera, propostas físicas, diferenciação das Irmãs, leitura a 80px e Graz’zt a 128px. Saída: aceite visual explícito dessas revisões ou ajustes por código. Adequação subjetiva permanece pendente; leitura técnica não equivale a aceite humano ou teste de contraste sobre os mapas. Aceite não autoriza integração, CANON, commit ou push. Demais pontos de ART-032 permanecem abertos.
'''
evidencepath=ROOT/'.atena/evidence/art032-npcs-lote02-delivery-2026-10-11.md'
evidencepath.write_text(evidence,encoding='utf-8')
for doc in [evidencepath,planpath]:
    for target in re.findall(r'\]\(([^)]+)\)',doc.read_text(encoding='utf-8')):assert (doc.parent/target).is_file(),(doc,target)
backlogpath=ROOT/'.atena/backlog/ARTE.md'
backlog=backlogpath.read_text(encoding='utf-8').replace('Próximo lote: seis NPCs NP04–NP09 DRAFT, [plano preparado](../vault/drafts/PLAN-ART032-NPCS-LOTE02-v01.md), aguarda G0.','Lote02: NP04/NP06 v02 e NP05/NP07–NP09 v01 DRAFT gerados/auditados, 4/5, gate visual S-005 pendente; [entrega](../evidence/art032-npcs-lote02-delivery-2026-10-11.md).')
backlogpath.write_text(backlog,encoding='utf-8')
statepath=ROOT/'.atena/state/art032-npcs-lote02.yaml'
state=statepath.read_text(encoding='utf-8').replace('evidence: .atena/evidence/art032-npcs-lote02-preparation-2026-10-11.md','evidence: .atena/evidence/art032-npcs-lote02-delivery-2026-10-11.md')
state += 'review_candidates: [NP04_v02, NP05_v01, NP06_v02, NP07_v01, NP08_v01, NP09_v01]\nnative_outputs_preserved: 8\ntechnical_status: PASS_WITH_NATIVE_ALPHA_NOTE\nreading_preview: .atena/generated/art032-npcs-lote02-2026-10-11/review-reading.png\ngallery_browser_verification: NOT_ATTEMPTED_KNOWN_FILE_URL_POLICY_BLOCK\n'
statepath.write_text(state,encoding='utf-8')
rootpath=ROOT/'.atena/state/plan.yaml'
prefix,tail=rootpath.read_text(encoding='utf-8').split('art032_npcs_piloto_2026_10_11:',1)
prefix=prefix.replace('.atena/evidence/art032-npcs-lote02-preparation-2026-10-11.md','.atena/evidence/art032-npcs-lote02-delivery-2026-10-11.md')
prefix += '  review_candidates: [NP04_v02, NP05_v01, NP06_v02, NP07_v01, NP08_v01, NP09_v01]\n  human_visual_acceptance: PENDING\n'
rootpath.write_text(prefix+'art032_npcs_piloto_2026_10_11:'+tail,encoding='utf-8')
print('Gallery complete: seven preview samples, all links PASS, 1000x1120 reading sheet inspected. Six exact DRAFT revisions ready for S-005.')
