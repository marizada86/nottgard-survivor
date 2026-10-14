from pathlib import Path
import hashlib,json,re
out=Path(__file__).resolve().parent;root=out.parents[2]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
manifest=json.loads((out/'manifest.json').read_text(encoding='utf-8'));protected=json.loads((out/'protected.json').read_text(encoding='utf-8'))
assert all(sha(root/e['path'])==e['sha256'] for e in manifest['sources'])
assert all(sha(root/p)==h for p,h in protected.items())
findings={'revision':'assets-l002-review/v01','atena_inspection':'Seven historical contact sheets inspected; source metrics read-only; human loop/rhythm acceptance not inferred','recommendation':'Approve other 39 DRAFT sources if visually acceptable; reserve H402v01/H406v01 for correction proposal. H403v02 historical approval preserved. No correction execution authorized yet.','recommended_exclusions':[{'code':'H402','version':'v01','reason':'Growth trail extends substantially farther left and is brighter than accepted H403 peak; sequence decreases extent into peak.','bbox_width_native':1022,'accepted_peak_bbox_width_native':649,'mean_luminance':7.38,'accepted_peak_mean_luminance':4.99},{'code':'H406','version':'v01','reason':'Dissipation retains coherent bright head/trail rather than only faint specks; hot-pixel count slightly rises vs H405.','pixels_luminance_gt128':5758,'previous_frame_pixels_luminance_gt128':5512}],'other_review_notes':{'Korrak':'Radial burst with flame tongues; historical vertical-appearance warning remains explicit owner evaluation. No automatic rejection from a contact sheet; native borders pass, peak margin tight and derivative calibration deferred.','Kayron/Nyrelia':'Motifs and six phases coherent on contact sheets; cycle seam/rotation needs owner evaluation in historical GIF.','Leoric':'Eight outer stars/lines visible; center junction is bright. Owner visual acceptance pending.','Zynara':'Clock motif and fading visible; channel deltas>12 only H905 one pixel/H906 five pixels; H703 one pixel too. Not exact grayscale; future approved technical alpha normalization may handle minor channel deviation without artistic redraw.','Bromnor':'Central shield/ring preserved, transitions to fragments; owner visual acceptance pending.'},'sources_edited':False,'human_acceptance':'PENDING'}
(out/'visual-findings.json').write_text(json.dumps(findings,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=out/'index.html';page=p.read_text(encoding='utf-8');note='<p class="flag"><strong>Recomendação Atena:</strong> revisar/aprovar as outras 39 fases DRAFT; reservar H402 v01 e H406 v01 para proposta de correção. H402 tem cauda maior/mais brilhante que o pico H403 aprovado; H406 mantém ponta luminosa em vez de poucos resíduos. Você pode aceitar exceções conscientemente ou indicar outros problemas. Nenhuma correção foi executada. <a href="visual-findings.json">Notas e medidas</a></p>';page=page.replace('<nav>',note+'<nav>',1)
for code in ['H402','H406']:page=page.replace(f'<h3>{code} v01</h3>',f'<h3>{code} v01 · AJUSTE RECOMENDADO</h3>')
p.write_text(page,encoding='utf-8')
evidence='''# L002 revisão/v01 — 42 fontes, decisão agrupada

PLAN053/SPEC121 S007 IN_PLAN/per-plan, continuação “atena commit e proximo”. L001 commit local2b96638 concluído, conferido e árvore limpa antes desta revisão. Sem push/merge; recibo em [l001-commit-receipt](../generated/assets-l002-review-2026-10-13/l001-commit-receipt.json). Aceite local da entregaL001 registrado, procedimento de playtest humano não relatado; não afirmar critérios subjetivos específicos realizados.

S001 autoridades/readiness: ART-PROMPTS054/FILA023, histórico local10bd31c continuous-draft e gateH403v02. [Spec](../specs/SPEC-121-retomada-fila-imagens/assets-l002-review-v01.md). Fontes já geradas sob autorização contínua histórica:41DRAFT mais H403v02 aprovado. Nenhuma geração nova. Identidade de personagem N/A: efeitos isolados, sem corpos/retratos; motivos/contexto por habilidade na spec, sem lore novo. Registros históricos somente lidos/copiados emprovenance; nenhuma escrita emcanon.

S002:42fontes recuperadas por hash; H403v02 preservado, demaisv01. Dimensões nativas1254quadradas, margens sem brilho>12 na borda. Leitura de canais encontrou diferença>12 em H703/H905(1pixel cada) eH906(5pixels), máximos13/13/17: não alegar cinza/preto matematicamente exatos. [Manifesto](../generated/assets-l002-review-2026-10-13/manifest.json), [auditoria](../generated/assets-l002-review-2026-10-13/audit.json). Sem edição/normalização dos pixels.

S003: sete pranchas históricas inspecionadas por Atena; galeria com seteGIFshistóricos/cadência ilustrativa,42nativos/96px e flags. [Galeria](../generated/assets-l002-review-2026-10-13/index.html), [achados](../generated/assets-l002-review-2026-10-13/visual-findings.json). Recomendação: separar **H402v01/H406v01** para proposta de correção; outras39fasesDRAFT podem receber aceite agrupado humano, mantendo H403v02 histórico. H402 cauda1022px largura versus649px do pico, luminância média7,38 versus4,99; crescimento excede pico em extensão/brilho. H406 mantém ponta/rastro coerentes;5758pixels luminância>128 contra5512emH405, não termina apenas em poucos resíduos. Métricas apoiam a inspeção, não substituem decisão humana.

Demais notas: Korrak radial/com línguas de chama, perspectiva precisa de avaliação explícita do dono; sem reprovar todos os quadros automaticamente. Kayron/Nyrelia padrões coerentes nas pranchas, fechamento/rotação dosGIFs depende de avaliação humana. Leoric oitoestrelas/linhas, Zynara relógio/fragmentos, Bromnor escudo/onda presentes. PicoKorrak tem margem estreita mas borda técnica passa; escala/pivô/packing ficam para futura admissão aprovada. Não afirmar verificação subjetiva de ritmo/loop por imagem estática.

S004:42hashes/fonteintacta,3049arquivosruntime iguais, links conferidos, estados/evidência reconciliados. [Verificação](../generated/assets-l002-review-2026-10-13/verification.json). Sem testes de jogo repetidos por não haver alteração runtime. PLAN071/B006/S011 preservado; bugs025/027/028/029 continuamabertos/P0zero. Sem CANON/Git/admissão/exportação neste lote.

Próximo objetivo: decisão visual agrupada —39fases aceitas e2reservadas para correção (recomendado), ou aceite consciente/novas exceções. Entradas: galeria42/manifesto/achados/H403v02. Saída: recibo humano com lista exata de aceites/exceções; checks: cauda/fim de Sylas, plano das chamasKorrak, fechamentoKayron/Nyrelia, motivos/resíduos/leitura96px. Decisão pendente. Aprovação visual só autoriza preparar proposta de correção/admissão; nenhuma nova execução ou normalização antecipada.
'''
(root/'.atena/evidence/assets-l002-review-2026-10-13.md').write_text(evidence,encoding='utf-8')
p=root/'.atena/state/assets-l002-review.yaml';s=p.read_text(encoding='utf-8').replace('status: IN_PROGRESS','status: TECHNICAL_REVIEW_COMPLETE_AWAITING_OWNER_VISUAL_DECISION').replace('S-001/AUTHORITY_AND_INPUTS','S-004/OWNER_VISUAL_BATCH_DECISION').replace('current_step_position: 1','current_step_position: 4').replace('completed_steps: 0','completed_steps: 4').replace('remaining_steps_after_current: 3','remaining_steps_after_current: 0');s+='''manifest: .atena/generated/assets-l002-review-2026-10-13/manifest.json
gallery: .atena/generated/assets-l002-review-2026-10-13/index.html
findings: .atena/generated/assets-l002-review-2026-10-13/visual-findings.json
verification: .atena/generated/assets-l002-review-2026-10-13/verification.json
evidence: .atena/evidence/assets-l002-review-2026-10-13.md
next_objective: Dono decidir aceite39fases e reservaH402/H406 ou indicar outras excecoes.
next_inputs: Galeria42, manifesto/hashes, achados e gateH403v02 preservado.
next_output: Recibo humano com aceites/excecoes; depois proposta limitada de correcao/admissao.
next_checks: Cauda/fimSylas, chamasKorrak, ciclosKayron/Nyrelia, motivos/residuos/leitura96px.
approval_status: PENDING_VISUAL_DECISION
recommended_exclusions: [H402v01, H406v01]
recommended_additional_acceptance_count: 39
''';p.write_text(s,encoding='utf-8')
block='''assets_l002_review_2026_10_13:
  plan: PLAN-053
  revision: assets-l002-review/v01
  classification: IN_PLAN
  state_file: .atena/state/assets-l002-review.yaml
  mode: per-plan
  status: TECHNICAL_REVIEW_COMPLETE_AWAITING_OWNER_VISUAL_DECISION
  checkpoint: S-004/OWNER_VISUAL_BATCH_DECISION
  completed_steps: 4
  total_steps: 4
  images: 42
  additional_frames_pending_acceptance: 41
  historical_gates_preserved: 1
  recommended_exclusions: [H402v01, H406v01]
  content_state: DRAFT_WITH_H403_V02_HISTORICAL_GATE_PRESERVED
  runtime_admission: false
  canonical_promotion: false
  evidence: .atena/evidence/assets-l002-review-2026-10-13.md
  return_plan: PLAN-071
  return_checkpoint: B-006/S-011
'''
for n in ['plan.yaml','plan-053-imagens.yaml']:
 p=root/'.atena/state'/n;s=p.read_text(encoding='utf-8')
 if n=='plan-053-imagens.yaml':
  s=s.replace('S-007/VFX/L-001/OWNER_DELIVERY_ACCEPTANCE_RECORDED','S-007/VFX/L-002/OWNER_VISUAL_BATCH_DECISION').replace('status: L001_OWNER_ACCEPTED_LOCAL_DELIVERY','status: L002_42_IMAGES_REVIEWED_AWAITING_OWNER')
  start=s.index('plan_cursor:');end=s.index('identity_gate:',start)
  s=s[:start]+'''plan_cursor:
  current: 'L001 commit2b96638 local concluido; L00242fontes recuperadas, sete sequencias revisadas, recomendacao reservarH402/H406.'
  next: 'Decisao visual agrupada L002; depois proposta de correcao/admissao limitada, sem regeneracao automatica.'
  review: '.atena/generated/assets-l002-review-2026-10-13/index.html'
  evidence: '.atena/evidence/assets-l002-review-2026-10-13.md'
'''+s[end:]
 s+='''l001_git_receipt_2026_10_13:
  owner_reply: 'atena commit e proximo'
  status: COMMITTED_LOCAL
  commit: 2b96638
  scope: L001 review/admission and evidence
  evidence: .atena/generated/assets-l002-review-2026-10-13/l001-commit-receipt.json
  pushed: false
  merged: false
  canonical_promotion: false
'''+block
 p.write_text(s,encoding='utf-8')
p=root/'.atena/state/assets-l001-admission.yaml';s=p.read_text(encoding='utf-8');s=re.sub(r'next_objective:.*','next_objective: Commit local2b96638 concluido; revisaoL002 em gate visual.',s);s+='git_status: COMMITTED_LOCAL_NOT_PUSHED\ncommit: 2b96638\n';p.write_text(s,encoding='utf-8')
with (root/'.atena/specs/SPEC-121-retomada-fila-imagens/assets-l002-review-v01.md').open('a',encoding='utf-8') as f:f.write('\nResultado técnico4/4:42hashes/fontesintactas,3049arquivosruntimepreservados,7pranchas conferidas. Recomendação reservarH402v01/H406v01 para correção; decisão humana agrupada pendente. [Evidência](../../evidence/assets-l002-review-2026-10-13.md).\n')
with (root/'.atena/backlog/ARTE.md').open('a',encoding='utf-8') as f:f.write('\n2026-10-13 — ART-030 L002:42fontes dos7heróis restantes recuperadas por hash, runtimeintacto; revisão agrupada com recomendação reservarH402/H406(Sylas) para correção. Demais39fasesDRAFT e exceções dependem de decisão visual; H403v02 preservado. Sem geração/admissão/CANON/Git neste lote. Evidência `.atena/evidence/assets-l002-review-2026-10-13.md`. L001 commitlocal2b96638 concluído, sempush.\n')
checked=0
for p in [root/'.atena/evidence/assets-l002-review-2026-10-13.md',root/'.atena/specs/SPEC-121-retomada-fila-imagens/assets-l002-review-v01.md']:
 for target in re.findall(r'\]\(([^)]+)\)',p.read_text(encoding='utf-8')):assert (p.parent/target).exists(),target;checked+=1
links=re.findall(r'(?:src|href)="([^"]+)"',page);assert all(l.startswith('#') or (out/l).exists() for l in links)
central=(root/'.atena/state/plan.yaml').read_text(encoding='utf-8');assert re.search(r'active_plan:\s+id: PLAN-071',central) and 'checkpoint: B-006/S-011' in central
v=json.loads((out/'verification.json').read_text(encoding='utf-8'));v.update({'status':'PASS_TECHNICAL_REVIEW_OWNER_DECISION_PENDING','technical_steps_completed':4,'document_links_verified':checked,'gallery_links_verified':len(links),'atena_visual_review':'SEVEN_HISTORICAL_CONTACT_SHEETS_INSPECTED','recommended_exclusions':['H402v01','H406v01'],'owner_visual_acceptance':'PENDING','active_plan071_preserved':True});(out/'verification.json').write_text(json.dumps(v,indent=2)+'\n',encoding='utf-8')
print('PASS 4/4 technical; 42 source hashes, 3049 runtime files unchanged; owner visual decision pending.')
