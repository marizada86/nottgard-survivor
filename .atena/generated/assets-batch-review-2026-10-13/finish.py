from pathlib import Path
import hashlib,json,re
out=Path(__file__).resolve().parent;root=out.parents[2]
v=json.loads((out/'verification.json').read_text(encoding='utf-8'));assert v['status']=='PASS' and v['hashes_verified']==30
protected=json.loads((out/'protected.json').read_text(encoding='utf-8'));sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
assert all(sha(root/p)==h for p,h in protected.items())
evidence='''# Lote L-001 — revisão ampliada de 30 fontes / v01

PLAN053/SPEC121 S007 IN_PLAN, per-plan existente; pedido explícito do dono para continuar e aumentar lotes. Preferência operacional aplicada: sequências completas, cinco famílias/30 imagens neste lote e próxima proposta sete heróis/42. Não altera gameplay, arquitetura, cânon ou políticas de aprovação. Mudança na composição de propostas de admissão será analisada antes de executar; aprovação de revisão não autoriza integração.

S-001: autoridades ART-PROMPTS052/054 e FILA021/023; histórico local10bd31c, registros de geração e auditorias de cinco sequências. [Spec e prontidão](../specs/SPEC-121-retomada-fila-imagens/assets-batch-review-v01.md). Registros históricos025/026/032/033/034 copiados somente para provenance, mantendo sua proveniência, sem escrever em canon. Identidade de personagem N/A: VFX abstratos isolados; contexto de uso registrado por arma/habilidade.

S-002: 30 fontes recuperadas por hash exato e lidas sem transformar pixels. E01/E02v02; demaisEv01; Fv01; H102v02, H201v02, demaisHv01. Cinco gates históricos E03/F03/H103/H201/H301 preservados; 25 fases adicionais DRAFT pendentes de aceite. Versões rejeitadas não selecionadas. Margens sem brilho>12 nas bordas; não alegar preto/cinza matematicamente exatos. [Manifesto](../generated/assets-batch-review-2026-10-13/manifest.json), [auditoria](../generated/assets-batch-review-2026-10-13/audit.json).

S-003: galeria conjunta com navegação por família, prévias animadas/pranchas históricas identificadas, nativos exatos e versões96px via navegador. Atena inspecionou cinco pranchas: E/F crescem/dissipam e distinguem raios de chamas; Durvall mantém rasgo escuro e afinamento; Brook/Maelor mantêm anéis/marcas e diferenças de motivo. Estrelas de Brook permanecem as do gate histórico, sem redesenho para reinterpretar o texto. Inspeção não é aceite humano, e animação histórica/cadência ilustrativa não é validação de runtime. [Galeria](../generated/assets-batch-review-2026-10-13/index.html).

S-004: contrato/links/estado reconciliados; 3033 arquivos runtime protegidos e intactos. [Verificação](../generated/assets-batch-review-2026-10-13/verification.json). Testes do jogo não repetidos porque não houve mudança runtime; apenas leitura de pixels e cópias nativas. PLAN071/B006/S011 preservado. Bugs025/027/028/029 continuam abertos, P0zero. Nenhuma geração, normalização, admissão, promoção CANON, Git, exportação ou publicação.

Próximo objetivo: aceite visual agrupado das25fases restantes ou exceções por código/versão. Entradas: galeria/manifesto/hash e cinco gates preservados. Saída: recibo humano; checks: coerência, expansão/afinamento, resíduos, leitura96px e fechamento Brook/Maelor. Aprovação visual pendente independente. Depois preparar proposta conjunta de admissão das famílias aceitas e selecionar modo antes de execução; próximos42heróis seguem proposta, não geração automática.
'''
(root/'.atena/evidence/assets-batch-review-2026-10-13.md').write_text(evidence,encoding='utf-8')
p=root/'.atena/state/assets-batch-review.yaml';s=p.read_text(encoding='utf-8').replace('status: IN_PROGRESS','status: TECHNICAL_REVIEW_COMPLETE_AWAITING_OWNER_VISUAL_ACCEPTANCE').replace('S-001/AUTHORITY_AND_INPUTS','S-004/VISUAL_BATCH_ACCEPTANCE').replace('current_step_position: 1','current_step_position: 4').replace('completed_steps: 0','completed_steps: 4').replace('remaining_steps_after_current: 3','remaining_steps_after_current: 0');s+='''manifest: .atena/generated/assets-batch-review-2026-10-13/manifest.json
gallery: .atena/generated/assets-batch-review-2026-10-13/index.html
verification: .atena/generated/assets-batch-review-2026-10-13/verification.json
evidence: .atena/evidence/assets-batch-review-2026-10-13.md
next_objective: Dono aceitar 25 fases adicionais agrupadas ou indicar excecoes por codigo/versao.
next_inputs: Galeria 30 fontes, cinco gates historicos, manifesto/hashes.
next_output: Recibo de aceite visual agrupado; depois proposta conjunta de admissao.
next_checks: Coerencia, expansao/afinamento, residuos, leitura96px, fechamento Brook/Maelor.
approval_status: PENDING_VISUAL_ACCEPTANCE
''';p.write_text(s,encoding='utf-8')
block='''assets_batch_review_2026_10_13:
  plan: PLAN-053
  revision: assets-batch-review/v01
  classification: IN_PLAN
  state_file: .atena/state/assets-batch-review.yaml
  mode: per-plan
  status: TECHNICAL_REVIEW_COMPLETE_AWAITING_OWNER_VISUAL_ACCEPTANCE
  checkpoint: S-004/VISUAL_BATCH_ACCEPTANCE
  completed_steps: 4
  total_steps: 4
  batch: L-001
  images: 30
  additional_phases_pending_acceptance: 25
  historical_gates_preserved: 5
  preference: Larger complete-sequence review batches requested explicitly by owner.
  next_proposed_batch_images: 42
  content_state: DRAFT_WITH_HISTORICAL_GATES_PRESERVED
  runtime_admission: false
  canonical_promotion: false
  evidence: .atena/evidence/assets-batch-review-2026-10-13.md
  return_plan: PLAN-071
  return_checkpoint: B-006/S-011
'''
for n in ['plan.yaml','plan-053-imagens.yaml']:
 p=root/'.atena/state'/n;s=p.read_text(encoding='utf-8')
 if n=='plan-053-imagens.yaml':
  s=s.replace('S-007/VFX/ONDA_CORTANTE/OWNER_DELIVERY_ACCEPTANCE_RECORDED','S-007/VFX/L-001/VISUAL_BATCH_ACCEPTANCE').replace('status: ONDA_CORTANTE_OWNER_ACCEPTED_LOCAL_DELIVERY','status: L001_30_IMAGES_REVIEWED_AWAITING_OWNER')
  start=s.index('plan_cursor:');end=s.index('identity_gate:',start)
  s=s[:start]+'''plan_cursor:
  current: 'L-001: 30 fontes E/F/H1/H2/H3 recuperadas por hash; cinco sequencias conferidas; aceite de25fases DRAFT pendente.'
  next: 'Aceite visual agrupado com excecoes; preparar proposta conjunta de admissao e depois lote42herois.'
  review: '.atena/generated/assets-batch-review-2026-10-13/index.html'
  evidence: '.atena/evidence/assets-batch-review-2026-10-13.md'
'''+s[end:]
 p.write_text(s+block,encoding='utf-8')
with (root/'.atena/specs/SPEC-121-retomada-fila-imagens/assets-batch-review-v01.md').open('a',encoding='utf-8') as f:f.write('\nResultado técnico4/4:30hashes/fonteintacta,cincofamílias e3033arquivos runtime preservados. Gate VISUAL_BATCH_ACCEPTANCE pendente; [evidência](../../evidence/assets-batch-review-2026-10-13.md).\n')
targets=[root/'.atena/evidence/assets-batch-review-2026-10-13.md',root/'.atena/specs/SPEC-121-retomada-fila-imagens/assets-batch-review-v01.md'];count=0
for p in targets:
 for link in re.findall(r'\]\(([^)]+)\)',p.read_text(encoding='utf-8')):assert (p.parent/link).exists(),link;count+=1
central=(root/'.atena/state/plan.yaml').read_text(encoding='utf-8');assert re.search(r'active_plan:\s+id: PLAN-071',central)
v.update({'technical_steps_completed':4,'document_links_verified':count,'atena_visual_review':'FIVE_HISTORICAL_MONTAGES_INSPECTED','owner_visual_acceptance':'PENDING','active_plan071_preserved':True})
(out/'verification.json').write_text(json.dumps(v,indent=2)+'\n',encoding='utf-8')
print('PASS: 4/4 technical, 30 exact sources, five families; owner batch visual gate pending.')
