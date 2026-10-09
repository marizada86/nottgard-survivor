from pathlib import Path
import json,re,hashlib,sys
from datetime import datetime,timezone
root=Path(__file__).resolve().parents[4];out=Path(__file__).parent
assert '--visual-inspected' in sys.argv
read=lambda p:p.read_text(encoding='utf-8-sig')
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
save=lambda p,d:p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
d=json.loads(read(out/'qr-generation-jobs-2026-10-09.json'));j=next(j for j in d['jobs'] if j['code']=='R01')
seq=json.loads(read(out/'orbe-arcano-sequence-audit-2026-10-09.json'))
assert seq['status']=='COMPLETE_CANDIDATE_SEQUENCE_VISUALLY_REVIEWED' and j['status']=='GENERATED_VISUALLY_INSPECTED'
assert sha(root/j['destination'])==j['sha256']==sha(Path(j['original_path']))
for row in seq['sources']:assert sha(root/row['path'])==row['sha256']
for rejected in d.get('rejected_native_versions',[]):assert sha(root/rejected['destination'])==rejected['sha256']==sha(Path(rejected['original_path']))
manifest=root/'.atena/generated/PRIORITY-IMAGES-2026-10-02.json';m=json.loads(read(manifest));assert m['count']==len(m['assets'])==202
prior=json.loads(read(out/'q01-owner-gate-2026-10-09.json'));assert prior['status']=='APPROVED' and sha(manifest)==prior['manifest_file_sha256']
assert (out/'r01-reference-comparison-2026-10-09.png').is_file()
g=dict(id='GATE-FILA-022-R01-2026-10-09',timestamp=datetime.now(timezone.utc).isoformat(),plan='PLAN-053',spec='SPEC-121',checkpoint='S-007/VFX/FILA-022/R01-APPROVAL',status='PENDING_OWNER_APPROVAL',frame='R01',version=j['version'],candidate=j['destination'],sha256=j['sha256'],visual_inspected=True,review='.atena/generated/s007-reconciliation/v01/r01-reference-comparison-2026-10-09.png',prompts_and_native_audit='.atena/generated/s007-reconciliation/v01/qr-generation-jobs-2026-10-09.json',source_instruction='.atena/generated/CHATGPT-FILA-022-vfx-projeteis-e-explosoes.md',canonical_source='.atena/generated/ART-PROMPTS-053-vfx-projeteis-e-explosoes.md',instruction='Para cada efeito, gere primeiro o quadro marcado GATE, pare e devolva ao dono.',visual_review=dict(subject='Thin flying crescent blade with fine jagged lightning along its edge',view='flat top-down',direction='RIGHT',tips='backward LEFT',readable_at96=True,no_visible_cuts=True,no_character_weapon_hand_readable_text=True,approved_pilot_style_compared=True),technical_notes=dict(native_dimensions=j['native_dimensions'],requested_dimensions=[1024,1024],outer_border_max_luminance=j['outer_border_max_luminance'],maximum_channel_difference=j['maximum_channel_difference'],normalization='Native bytes preserved; future technical downsample to1024; exact zero RGB not claimed'),rejected_versions=d.get('rejected_native_versions',[]),runtime_admission=False,official_manifest_assets=202,manifest_file_sha256=sha(manifest),remaining_native_vfx_frames=79,other_R_frames_generated=0,next_if_approved='Generate R02-R08 individually using approved R01: three flight and four impact frames, then N01 mandatory gate',ranking_return='PLAN-071 B-006/S-011 preserved')
g['next_if_approved']='Generate R02-R08 individually using approved R01: three flight and four impact frames, then N03 mandatory peak gate before remaining radiant pulse frames.'
gp=out/'r01-owner-gate-2026-10-09.json';assert not gp.exists();save(gp,g)
q=root/'.atena/generated/CHATGPT-FILA-022-vfx-projeteis-e-explosoes.md';t=read(q)
pattern=r'(#### R01[^\n]+\n\n)- \[ \] gerada[^\n]+'
t,n=re.subn(pattern,r'\g<1>- [x] gerada · [ ] aprovada · candidata: `'+j['destination']+'` — gate humano pendente; fonte nativa preservada.',t);assert n==1
old='Orbe arcano oito quadros gerados/revisados, Q01 v03 aprovada; R/N/M pendentes';new='Orbe arcano oito quadros gerados/revisados, Q01 v03 aprovada; R01 '+j['version']+' candidata com gate pendente; demais19 quadros pendentes';assert old in t;t=t.replace(old,new);q.write_text(t,encoding='utf-8')
art=root/'.atena/generated/ART-PROMPTS-053-vfx-projeteis-e-explosoes.md';t=read(art)
old='Orbe arcano oito candidatas revisadas, Q01 v03 aprovada; R/N/M pendentes';new='Orbe arcano oito candidatas revisadas, Q01 v03 aprovada; R01 '+j['version']+' candidata com gate pendente; demais19 quadros pendentes';assert old in t;art.write_text(t.replace(old,new),encoding='utf-8')
for rel in ['.atena/state/plan.yaml','.atena/state/plan-053-imagens.yaml']:
 p=root/rel;t=read(p).replace('EXECUTING_R_GATE','AWAITING_OWNER_APPROVAL').replace('S-007/VFX/FILA-022/R01','S-007/VFX/FILA-022/R01-APPROVAL')
 t=t.replace('S-007 orbe arcano oito fontes candidatas revisadas; gerando somente gate R01. Manifesto202 preservado.','S-007 orbe arcano oito candidatas revisadas; R01 '+j['version']+' gerada, gate humano pendente. Manifesto202 preservado.')
 t=t.replace('Aguardar gate R01 antes dos sete demais quadros da onda cortante. Retorno PLAN-071 preservado.','Aguardar aprovacao R01 antes dos sete demais R; 79 fontes VFX restantes. Retorno PLAN-071 preservado.')
 t=t.replace('S-007 Q em geracao apos aceite Q01 v03; proximo gate R01. PLAN-071 preservado.','S-007 orbe arcano completo como candidata; aguardando gate humano R01. PLAN-071 preservado.')
 if rel.endswith('plan-053-imagens.yaml'):
  match=re.search(r'\nvfx_gate:\n(.*?)(?=\n\S|\Z)',t,re.S);previous=match.group(1);assert 'status: APPROVED' in previous and 'frame: Q01' in previous
  b='\nvfx_gate:\n  id: '+g['id']+'\n  status: PENDING_OWNER_APPROVAL\n  frame: R01\n  version: '+j['version']+'\n  generated: 1\n  remaining_native_vfx_frames: 79\n  official_manifest_assets: 202\n  runtime_admission: false\n  receipt: .atena/generated/s007-reconciliation/v01/r01-owner-gate-2026-10-09.json\n';t=t[:match.start()]+b+t[match.end():]
  assert '\ncompleted_vfx_gates:\n' in t and '\n  orbe_arcano:\n' not in t
  t+='\n  orbe_arcano:\n'+''.join('  '+line+'\n' for line in previous.rstrip().splitlines())+'    completion_receipt: .atena/generated/s007-reconciliation/v01/orbe-arcano-sequence-audit-2026-10-09.json\n'
 p.write_text(t,encoding='utf-8')
ev=root/'.atena/evidence/s007-orbe-arcano-completo-r01-gate-2026-10-09.md'
text='# S-007 — Orbe arcano gerado e gate da onda cortante\n\n'
text+='PLAN-053/SPEC-121, IN_PLAN, per-plan preservado. Dono respondeu “atena, aprovado, continue” ao pedido de aprovação Q01 v03 e geração de sete quadros. [Aprovação](../generated/s007-reconciliation/v01/q01-owner-approval-2026-10-09.json), [registro canônico](../vault/canon/ASSET-APPROVAL-REGISTER-028-vfx-orbe-arcano-2026-10-09.md).\n\n'
text+='Orbe arcano: oito candidatas revisadas, Q01 v03 aprovado, sete demais quadros inspecionados tecnicamente sem alegar aceite humano individual. [Recibo da sequência](../generated/s007-reconciliation/v01/orbe-arcano-sequence-audit-2026-10-09.json), [prancha96px](../generated/s007-reconciliation/v01/orbe-arcano-eight-frame-review-2026-10-09.png), [voo em GIF](../generated/s007-reconciliation/v01/orbe-arcano-flight-review-2026-10-09.gif), [impacto em GIF](../generated/s007-reconciliation/v01/orbe-arcano-impact-review-2026-10-09.gif). Voo mantém núcleo, anel com motivos circulares e rastro esquerdo, variando luz/detalhes/cauda; fechamento Q04/Q01 revisto. Quatro impactos sem rastro: flash pequeno, pico Q06, fragmentos/anel cinza, resíduos fracos. Centro quente do voo auditado como proxy, sem alegar pivô geométrico exato; sem cortes visíveis e miniaturas96px inspecionadas.\n\n'
text+='R01 onda cortante fly00 '+j['version']+' gerada/revisada: lâmina fina em crescente, pontas para esquerda, avanço para direita e raios finos irregulares na borda; branco/cinza, vista de cima achatada. [Gate pendente](../generated/s007-reconciliation/v01/r01-owner-gate-2026-10-09.json), [prancha](../generated/s007-reconciliation/v01/r01-reference-comparison-2026-10-09.png), [fontes e prompts nativos](../generated/s007-reconciliation/v01/qr-generation-jobs-2026-10-09.json). Nenhum outro quadro R gerado; gate obrigatório FILA022 antes de sete demais R.\n\n'
text+='Hashes de nove fontes selecionadas e links conferidos; versões nativas preservadas, inclusive eventuais rejeitadas listadas nos jobs. Saídas quadradas preservadas requerem normalização técnica futura para1024; fundo visualmente preto e ruído mínimo dos canais auditados, sem alegar zero RGB exato. Nenhuma limpeza de pixels; redimensionamento apenas de prévias. Manifesto202 byte a byte inalterado desde Q01. Sem nova alteração runtime/build ou atribuição de novos resultados de suite/build a candidatas. Restam79 fontes VFX:19 FILA022 e60 FILA023. S007 permanece aberto; retorno PLAN071 e demais suspensões preservados.\n'
if any(x['code']=='R01' for x in d.get('rejected_native_versions',[])):
 text+='\nR01 v01 preservada e rejeitada por leitura insuficiente dos raios finos; edição nativa da candidata '+j['version']+' reforça os filamentos elétricos na borda, mantendo crescente e direção. [Comparação da versão rejeitada](../generated/s007-reconciliation/v01/r01-v01-rejected-lightning-review-2026-10-09.png). Nenhuma versão R tem aceite humano nesta entrega.\n'
ev.write_text(text,encoding='utf-8')
entry='\n2026-10-09 — Q01 v03 aprovada com “atena, aprovado, continue”; oito candidatas do orbe arcano geradas/revisadas, fontes nativas preservadas. R01 onda cortante '+j['version']+' candidata gerada/revisada, gate humano pendente antes dos sete demais R. FILA02217/36 fontes geradas;79 fontes VFX restantes. Manifesto202 inalterado, nenhuma admissão runtime. Evidência s007-orbe-arcano-completo-r01-gate-2026-10-09.md; recibo .atena/generated/s007-reconciliation/v01/r01-owner-gate-2026-10-09.json. Retorno PLAN071 preservado.\n'
for rel in ['.atena/evidence/EVID-145-fila-de-imagens-prioritaria-2026-10-02.md','.atena/specs/SPEC-121-retomada-fila-imagens/tasks.md','.atena/specs/SPEC-121-retomada-fila-imagens/plan.md','.atena/vault/drafts/PLAN-053-fila-de-imagens-2026-10-02.md','.atena/evidence/s007-orbe-radiante-completo-q01-gate-2026-10-09.md']:
 p=root/rel;p.write_text(read(p)+entry,encoding='utf-8')
backlog=root/'.atena/backlog/ARTE.md';lines=read(backlog).splitlines();found=0
for i,line in enumerate(lines):
 if line.startswith('| ART-029 |'):
  found+=1;fields=line.split('|');fields[-2]=' **2026-10-09:** orbe arcano oito candidatas revisadas, Q01 v03 aprovado; R01 onda cortante '+j['version']+' candidata, gate humano pendente antes de sete R. FILA02217/36 fontes geradas;19 faltantes. [Evidência](../evidence/s007-orbe-arcano-completo-r01-gate-2026-10-09.md). Integração pendente; item aberto. ';lines[i]='|'.join(fields)
assert found==1;backlog.write_text('\n'.join(lines)+'\n',encoding='utf-8')
links=[]
for p in [ev,root/'.atena/vault/canon/ASSET-APPROVAL-REGISTER-028-vfx-orbe-arcano-2026-10-09.md']:
 for target in re.findall(r'\]\(([^)]+)\)',read(p)):
  assert (p.parent/target).resolve().is_file(),(p,target);links.append(dict(document=p.relative_to(root).as_posix(),target=target,exists=True))
save(out/'qr-links-validation-2026-10-09.json',dict(status='PASSED',links=links,source_hashes_verified=9,rejected_native_hashes_verified=len(d.get('rejected_native_versions',[])),manifest_assets=202,manifest_sha256=sha(manifest),gate=g['id']))
print(json.dumps(dict(status='Q_COMPLETE_R01_PENDING_OWNER_APPROVAL',remaining_native_vfx_frames=79,official_manifest_assets=202,links_checked=len(links))))
