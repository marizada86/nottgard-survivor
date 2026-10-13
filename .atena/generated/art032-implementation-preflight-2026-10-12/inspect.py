"""Read-only source/runtime preflight. Write analysis records only; no admission."""
from pathlib import Path
import hashlib
import json
OUT=Path(__file__).resolve().parent
ROOT=OUT.parents[2]
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
packages=['art032-npcs-2026-10-11','art032-npcs-lote02-2026-10-11','art032-pontos-2026-10-11','art032-juiblex-2026-10-12']
mapping={
 'NP01':('npc_joao_barbosa','escort ally','feng_tu/escolta_do_peregrino'),
 'NP02':('npc_desertor_durao','rescue point','durao/desertores'),
 'NP03':('npc_vitima_enfeiticada','rescue point','shendilavri/vitimas_drenadas'),
 'NP04':('npc_nyxara','first reward ally','shendilavri/vitimas_drenadas'),
 'NP05':('npc_vaelis','second reward ally','shendilavri/vitimas_drenadas'),
 'NP06':('npc_grazzt_aliado','pact point and reward ally','goranthis/o_nome_tres_vezes'),
 'NP07':('npc_reaper_barqueiro','pact point','shedaklah/barqueiro_do_estige'),
 'NP08':('npc_vhaerith_aetherion','pact point','durao/vhaerith_na_jaula'),
 'NP09':('npc_mercador_rivenheart','pact point','shendilavri/mercador_de_rivenheart'),
 'PT01':('estrela_do_norte','pilgrimage point','feng_tu/peregrinacao_da_estrela'),
 'PT02':('trono_zuggtmoy','collect target','shedaklah/pedido_de_zuggtmoy'),
 'PT03':('arco_pedra','collect target','shedaklah/portal_sem_vao'),
 'PT04':('massa_thullgrime','intercept target','molor/ritual_de_estagnacao'),
 'PT05':('coracao_limo','drop from elite','shedaklah/pedido_de_zuggtmoy'),
 'PT06':('esporo_zuggtmoy','collect item','shedaklah/portal_sem_vao'),
 'PT07':('limo_juiblex','collect item','shedaklah/portal_sem_vao'),
 'MJ01':('manifestacao_de_juiblex','static boss sprite','shedaklah/pedido_de_zuggtmoy')}
events=json.loads((ROOT/'data/stage_events.json').read_text(encoding='utf-8'))
entries=[];receipts=[];native_count=0
for directory in packages:
    package=ROOT/'.atena/generated'/directory
    receipt=json.loads((package/'visual-acceptance.json').read_text(encoding='utf-8'))
    assert receipt['status']=='APPROVED_EXPLICITLY' and receipt['content_state']=='DRAFT'
    receipts.append({'path':(package/'visual-acceptance.json').relative_to(ROOT).as_posix(),'sha256':sha(package/'visual-acceptance.json'),'owner_reply':receipt['owner_reply']})
    native_count+=len(list((package/'sources').glob('*.png')))
    for accepted in receipt['accepted']:
        assert sha(ROOT/accepted['path'])==accepted['sha256']
        code=accepted['code'];name,usage,event=mapping[code]
        stage,event_id=event.split('/')
        assert any(e['id']==event_id for e in events[stage]),event
        entries.append({**accepted,'content_state':'DRAFT_VISUALLY_ACCEPTED','proposed_destination':'assets/'+('enemies/' if code=='MJ01' else 'interactions/')+name+'.png','usage':usage,'event':event,'transformation':'PROPOSED_GODOT_DERIVATIVE_CROP_ALPHA_PADDING_ASPECT_BASELINE_WITH_ORIGINAL_PRESERVED','runtime_admission':False})
assert len(entries)==17 and native_count==27
source_snapshot=json.loads((ROOT/'.atena/generated/art032-juiblex-2026-10-12/protected-snapshot.json').read_text(encoding='utf-8'))
rootpath=ROOT/'.atena/state/plan.yaml'
before=rootpath.read_text(encoding='utf-8')
for path,expected in source_snapshot.items():
    actual=hashlib.sha256(before.split('active_plan:',1)[1].encode()).hexdigest() if '#active_plan_tail' in path else sha(ROOT/path)
    assert actual==expected,path
runtime_paths=['core/happenings.gd','ui/overlay.gd','ui/enemy_view.gd','data/stage_events.json','assets/enemies/manifestacao_de_juiblex.png']
runtime=[{'path':p,'sha256':sha(ROOT/p)} for p in runtime_paths]
manifest={'revision':'ART032-IMPLEMENTATION-PREFLIGHT/v01','date':'2026-10-12','owner_request':'atena, proxima imagem, depois iplemente','request_classification':'PLAN_CHANGE_REQUEST','status':'PREFLIGHT_COMPLETE_REQUEST_CLARIFICATION_PENDING','approval_mode':'per-plan','accepted_sources':17,'historical_native_sources':27,'receipts':receipts,'entries':entries,'runtime_snapshot':runtime,'checks':{'source_acceptance_hashes':'PASS','event_consumption_ids':'PASS','prior_sources_runtime_and_plan071':'UNCHANGED_HASH_VERIFIED'},'pending_decision':'Which new image/front comes first, and whether later implementation means ART-032','image_generation':False,'image_transformation':False,'runtime_admission':False,'integration':False,'canonical_promotion':False,'commit_push_build':False}
(OUT/'manifest.json').write_text(json.dumps(manifest,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
rows='\n'.join('| '+e['code']+' '+e['revision']+' | '+e['usage']+' | `'+e['event']+'` | `'+e['proposed_destination']+'` |' for e in entries)
report='''# ART-032 — préflight de implementação DRAFT v01

Pedido: **“atena, proxima imagem, depois iplemente”**. As fontes previstas de ART-032 estão completas: dezessete revisões DRAFT visualmente aceitas em vinte e sete originais, quatro recibos. Nenhuma próxima imagem desta frente está definida no plano fechado. Pergunta de escopo enviada: implementar as dezessete agora ou qual outra imagem antes, confirmando se a implementação posterior é ART-032. Classificação PLAN_CHANGE_REQUEST; modalidade per-plan preservada. Este documento é preparação independente, não autorização de geração, transformação ou runtime.

## Inventário e consumo propostos

| Revisão | Uso | Evento | Destino proposto |
|---|---|---|---|
'''+rows+'''

[Manifesto/revisões/hashes](manifest.json). Todos os dezessete hashes de fontes e quatro recibos conferidos; IDs de eventos existem. Snapshot dos ativos/runtime e cadeia PLAN-071 permanece igual. A imagem atual de Juiblex continua o provisório; este préflight não modifica nenhum PNG ou código do jogo.

## Impacto delimitado para futuro plano ART-032

1. Preparar derivados no Godot com alfa/caixa/padding/proporção e âncora de base, preservando bytes dos originais. Definir dimensões finais no plano aprovado, com prévias 48/80/128px e contraste em cenas reais. Resíduos nativos de alfa 1/255 devem ser tratados no contrato dos derivados, sem retocar originais.
2. Conectar arte por metadata de eventos, mantendo regras, horários, custos e recompensas. Interações já têm campo `asset` em `_add_point`; collect items/rescue/star e drops de elite precisam propagar a imagem. Allies usam hoje `sprite` em `assets/enemies`; propor campo de arte de evento em `assets/interactions` com fallback compatível, preservando tintas das novas imagens.
3. Diferenciar Nyxara e Vaelis na recompensa de dois aliados, sem novos atributos ou alterações de RNG. Conectar João na escolta, Graz'zt no pacto/aliado, demais NPCs em pontos existentes. Coletáveis 48px, NPCs/props a altura definida no contrato; rótulos/anel/seta/vida/interação permanecem acessíveis.
4. Admitir derivado MJ01 somente no caminho estático do chefe. `ui/enemy_view.gd` já carrega por ID; não criar animações novas ou mudar mecânica de chefe. Restaurar provisório via snapshot se necessário.
5. Validar imports/refs e manifesto, testes de eventos (coleta por drop, resgate, escolta, recompensas das Irmãs/Graz'zt, estrelas, pactos e alvo), renderização e capturas em biomas. Rodar checks aplicáveis existentes e suite; relatar playtest humano como pendente.

Não há fonte do templo-alvo da escolta, jaula ou canoa entre estas dezessete. Contexto desses props foi textual nos planos aceitos e permanece conteúdo adiado; não alegar cobertura de todos os pontos/props ou inventar novos assets sem escopo. ART-032 continua aberto até admissão/validação. Aparências/lore continuam DRAFT salvo promoção explícita.

## Fila conferida

Registros locais reconciliados de FILA-022 (36/36), FILA-023 (60/60) e FILA-027 (20/20) evitam regeneração por cursores históricos. Erik/Arlindo têm extração/normalização pendente e fontes retidas; não reiniciar a passada cancelada. FILA-028 e altar possuem fontes/derivados aceitos, com admissão pendente. ART-033 lista costas dos heróis, e Korrak está explicitamente adiado; esse inventário não escolhe ou autoriza nova frente.

Préflight concluído: inventário e mapa de consumo (2/2). Próximo objetivo depende da definição da imagem e do alvo de implementação; depois preparar plano limitado com checkpoints. Geração, transformação, admissão, integração, CANON, commit, push e build não executados. Bugs: P0=0, quatro P1 abertos, quatorze implementados aguardando playtest.
'''
(OUT/'preflight.md').write_text(report,encoding='utf-8')
state='''version: 1
request: ART032-NEXT-REQUEST
revision: v01
owner_request: 'atena, proxima imagem, depois iplemente'
request_classification: PLAN_CHANGE_REQUEST
approval_mode: per-plan
status: PREFLIGHT_COMPLETE_REQUEST_CLARIFICATION_PENDING
checkpoint: G0/REQUEST_CLARIFICATION
preflight_ordered_steps: [INVENTORY, CONSUMPTION_MAP]
preflight_completed_steps: 2
preflight_total_steps: 2
accepted_draft_sources: 17
evidence: .atena/generated/art032-implementation-preflight-2026-10-12/preflight.md
manifest: .atena/generated/art032-implementation-preflight-2026-10-12/manifest.json
pending_question: 'Implementar ART-032 agora ou qual nova imagem antes; confirmar o alvo da implementação posterior'
new_image_scope: UNDEFINED
runtime_implementation_scope: PENDING_CONFIRMATION
next_execution_authorized: false
preserved_checkpoint: PLAN071_AND_HERO_EXTRACTION_REVIEW
next_objective: 'Resolver sequência/imagem/alvo de implementação, depois preparar plano limitado'
'''
(ROOT/'.atena/state/art032-next-request-2026-10-12.yaml').write_text(state,encoding='utf-8')
if 'art032_next_request_2026_10_12:' not in before:
    block='''art032_next_request_2026_10_12:
  request: ART032-NEXT-REQUEST
  revision: v01
  state_file: .atena/state/art032-next-request-2026-10-12.yaml
  request_classification: PLAN_CHANGE_REQUEST
  status: PREFLIGHT_COMPLETE_REQUEST_CLARIFICATION_PENDING
  mode: per-plan
  checkpoint: G0/REQUEST_CLARIFICATION
  evidence: .atena/generated/art032-implementation-preflight-2026-10-12/preflight.md
  next_execution_authorized: false
'''
    rootpath.write_text('version: 2\n'+block+before[len('version: 2\n'):],encoding='utf-8')
    assert rootpath.read_text(encoding='utf-8').split('art032_juiblex_2026_10_12:',1)[1]==before.split('art032_juiblex_2026_10_12:',1)[1]
print('Preflight 2/2 complete: seventeen accepted hashes/events mapped, runtime unchanged. Sequence/new-image/implementation target clarification remains pending.')
