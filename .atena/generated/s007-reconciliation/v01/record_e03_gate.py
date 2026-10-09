from pathlib import Path
import json,re,hashlib
from datetime import datetime,timezone
root=Path(__file__).resolve().parents[4];out=Path(__file__).parent
read=lambda p:p.read_text(encoding='utf-8-sig')
audit=json.loads(read(out/'e03-audit-2026-10-09.json'))
native=json.loads(read(out/'e03-native-result-2026-10-09.json'))
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
assert sha(root/audit['candidate'])==audit['sha256']==sha(Path(native['original_path']))
assert audit['canvas_square'] and audit['outer_border_max_luminance']<=2
assert audit['visible_bbox_above12'][0]>0 and audit['visible_bbox_above12'][2]<audit['native_dimensions'][0]
manifest=json.loads(read(root/'.atena/generated/PRIORITY-IMAGES-2026-10-02.json'))
assert manifest['count']==len(manifest['assets'])==202
gate=dict(id='GATE-FILA-021-E03-2026-10-09',timestamp=datetime.now(timezone.utc).isoformat(),plan='PLAN-053',spec='SPEC-121',checkpoint='S-007/VFX/FILA-021/E03-APPROVAL',status='PENDING_OWNER_APPROVAL',frame='E03',version='v01',candidate=audit['candidate'],sha256=audit['sha256'],visual_inspected=True,review='.atena/generated/s007-reconciliation/v01/e03-reference-comparison-2026-10-09.png',prompt='.atena/generated/s007-reconciliation/v01/e03-prompt-2026-10-09.json',audit='.atena/generated/s007-reconciliation/v01/e03-audit-2026-10-09.json',source_instruction='.atena/generated/CHATGPT-FILA-021-vfx-corpo-a-corpo-excecoes.md',instruction='Para cada efeito, gere primeiro o quadro marcado GATE, pare e devolva ao dono.',visual_review=dict(direction='RIGHT',view='flat top-down',subject='wide radiant arc with short rays and star-shaped glints',no_character_weapon_hand_text=True,readable_at96=True,approved_pilot_style_comparison=True,no_visible_cuts=True),technical_notes=['Native output is 1254x1254; requested canvas 1024x1024. Native is preserved; later technical downsampling is required for admission.','Background appears black; outer border luminance is 0-2/255, channel difference up to11/255. Do not claim exact zero RGB or exact channel equality. No source cleanup performed.'],runtime_admission=False,manifest_assets=202,remaining_native_vfx_frames=107,other_E_frames_generated=0,next_if_approved='Generate E01/E02/E04/E05/E06 individually using E03 as the approved reference; next F03 gate follows only after E.',ranking_return='PLAN-071 B-006/S-011 preserved')
(out/'e03-owner-gate-2026-10-09.json').write_text(json.dumps(gate,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
q=root/'.atena/generated/CHATGPT-FILA-021-vfx-corpo-a-corpo-excecoes.md';t=read(q)
old='- [ ] gerada · [ ] aprovada · candidata: `'+audit['candidate']+'`'
assert t.count(old)==1
t=t.replace(old,old.replace('[ ] gerada','[x] gerada')+' — E03 v01: gate humano pendente, fonte nativa preservada.')
t=t.replace('E e F pendentes; EVID-145','E03 v01 gerada com gate pendente; demais E e F pendentes; EVID-145')
q.write_text(t,encoding='utf-8')
for rel in ['.atena/state/plan.yaml','.atena/state/plan-053-imagens.yaml']:
 p=root/rel;t=read(p).replace('EXECUTING_GATE','AWAITING_OWNER_APPROVAL').replace('S-007/VFX/FILA-021/E03','S-007/VFX/FILA-021/E03-APPROVAL')
 t=t.replace('S-007 reconciliado: historicos preservados; gerando somente E03 para gate humano.','S-007 reconciliado; E03 v01 gerada e revisada; gate visual humano pendente. Manifesto202 preservado.')
 t=t.replace('Gerar E03 e aguardar aprovacao visual antes dos cinco quadros restantes do arco radiante. Retorno PLAN-071 preservado.','Aguardar aprovacao E03 antes dos cinco quadros restantes do arco radiante; 107 fontes VFX restantes. Retorno PLAN-071 preservado.')
 t=t.replace('S-007 VFX em execucao ate gate E03.','S-007 VFX aguardando gate humano E03.')
 if rel.endswith('plan-053-imagens.yaml'):
  assert '\nvfx_gate:' not in t
  t+='\nvfx_gate:\n  id: GATE-FILA-021-E03-2026-10-09\n  status: PENDING_OWNER_APPROVAL\n  frame: E03\n  version: v01\n  generated: 1\n  remaining_native_vfx_frames: 107\n  official_manifest_assets: 202\n  runtime_admission: false\n  receipt: .atena/generated/s007-reconciliation/v01/e03-owner-gate-2026-10-09.json\n'
 p.write_text(t,encoding='utf-8')
ev=root/'.atena/evidence/s007-vfx-e03-gate-2026-10-09.md'
ev.write_text('# S-007 — reconciliação e gate E03\n\nPLAN-053/SPEC-121, IN_PLAN, aprovação per-plan preservada. Pilares concluído localmente: 26 fontes, cinco tiras, build e verificações registradas no [recibo](../generated/pilares-complete-build-validation-2026-10-08.json); playtest humano pendente. [Reconciliação](../generated/s007-reconciliation/v01/reconciliation-2026-10-09.json): lote1 oito assets presentes e HQ histórica14/56 preservada; FILA024 concluída segundo o registro atual EVID-145; U01–U06 fora do aceite SPEC121 e trilha C condicionada a MEC015. Nenhuma mecânica nova.\n\n[Gate E03](../generated/s007-reconciliation/v01/e03-owner-gate-2026-10-09.json), [prancha comparativa](../generated/s007-reconciliation/v01/e03-reference-comparison-2026-10-09.png), [prompt e referência](../generated/s007-reconciliation/v01/e03-prompt-2026-10-09.json), [auditoria](../generated/s007-reconciliation/v01/e03-audit-2026-10-09.json). Gerador nativo built-in imagegen, um único pico radiante v01; aprovação humana PENDENTE. Arco largo voltado à direita, raios curtos, cintilações, sem arma/personagem/texto e legível a96px, inspecionado junto ao piloto A03v02 aprovado.\n\nFonte nativa1254x1254 preservada byte a byte, SHA256 '+audit['sha256']+'. O pedido era1024x1024: normalização técnica necessária antes de futura admissão. Fundo visualmente preto, luminância externa0–2/255 e diferença máxima entre canais11/255; não se declara preto zero exato ou canais exatamente iguais. Sem limpeza de pixels. Só a prancha foi redimensionada para revisão. Nenhuma integração runtime; manifesto202 inalterado. 107 fontes VFX ainda faltantes; os outros cinco quadros E aguardam o gate obrigatório da FILA021. Todos os pontos de retorno PLAN071 preservados.\n',encoding='utf-8')
entry='\n2026-10-09 — S-007 reconciliado: lote1 oito assets e HQ histórica14/56 presentes, FILA024 concluída; condicionais U01–U06/MEC015 preservados. Somente E03 arco radiante peak v01 gerada via imagegen e inspecionada junto ao piloto aprovado, gate humano pendente conforme FILA021. Nenhuma admissão/runtime; manifesto202 preservado, 107 fontes VFX faltantes. Evidência s007-vfx-e03-gate-2026-10-09.md; recibo .atena/generated/s007-reconciliation/v01/e03-owner-gate-2026-10-09.json. Retorno PLAN071 preservado.\n'
for rel in ['.atena/evidence/EVID-145-fila-de-imagens-prioritaria-2026-10-02.md','.atena/specs/SPEC-121-retomada-fila-imagens/tasks.md','.atena/specs/SPEC-121-retomada-fila-imagens/plan.md','.atena/vault/drafts/PLAN-053-fila-de-imagens-2026-10-02.md']:
 p=root/rel;p.write_text(read(p)+entry,encoding='utf-8')
targets=[root/'.atena/evidence/pilares-complete-2026-10-08.md',root/'.atena/vault/canon/ASSET-APPROVAL-REGISTER-024-pilares-identidade-2026-10-08.md',ev]
links=[]
for p in targets:
 for target in re.findall(r'\]\(([^)]+)\)',read(p)):
  if '://' in target:continue
  resolved=(p.parent/target).resolve();assert resolved.is_file(),(p,target)
  links.append(dict(document=p.relative_to(root).as_posix(),target=target,exists=True))
(out/'e03-gate-links-validation-2026-10-09.json').write_text(json.dumps(dict(status='PASSED',links=links,manifest_assets=202,pending_owner_gate=gate['id']),indent=2)+'\n',encoding='utf-8')
print(json.dumps(dict(status=gate['status'],frame='E03',links_checked=len(links),manifest_assets=202,remaining_native_vfx_frames=107)))
