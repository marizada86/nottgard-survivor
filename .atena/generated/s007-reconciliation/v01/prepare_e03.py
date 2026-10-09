from pathlib import Path
import json,re,hashlib
from datetime import datetime,timezone
root=Path(__file__).resolve().parents[4]
out=Path(__file__).parent
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
read=lambda p:p.read_text(encoding='utf-8-sig')
save=lambda name,data:(out/name).write_text(json.dumps(data,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
paths=re.findall(r'admitida: `(assets/[^`]+)`',read(root/'.atena/generated/CHATGPT-FILA-001-prompts-prontos.md'))
assert len(paths)==8
hqs=json.loads(read(root/'data/hqs.json'))
hqpaths=[panel['image'].removeprefix('res://') for hq in hqs.values() for panel in hq['panels']]
assert len(hqs)==14 and len(hqpaths)==56
for p in paths+hqpaths:assert (root/p).is_file(),p
reference=out/'approved-pilot-A03-v02-reference.png'
assert sha(reference)=='a31737e4d14662677063a6b7a9c19681b207b57bfe8a43b00d40e5adaeff9991'
queue=root/'.atena/generated/CHATGPT-FILA-021-vfx-corpo-a-corpo-excecoes.md'
text=read(queue)
prompt=re.search(r'#### E03[^\n]+.*?```text\s*(.*?)\s*```',text,re.S).group(1)
canonical=read(root/'.atena/generated/ART-PROMPTS-052-vfx-corpo-a-corpo-excecoes.md')
assert re.search(r'Subject: (.*?) Frame 3 of 6',prompt).group(1) in canonical
dest=root/'.atena/generated/art-candidates/vfx/arco_largo_radiante/arco_largo_radiante_peak_v01.png'
assert not dest.exists()
dest.parent.mkdir(parents=True,exist_ok=True)
prompt+='\n\nThe attached image is a STYLE REFERENCE ONLY: the approved physical pilot peak. Match its painted line texture, white core and gray glow, but draw the new wider radiant arc of about 220 degrees specified above, with short light rays and tiny star-shaped glints. The arc is centered on the exact image center as its pivot and faces RIGHT. Keep the whole arc, glow, ray ends and sparks inside the square with black margins. Generate this single peak frame only.'
save('e03-prompt-2026-10-09.json',dict(plan='PLAN-053',spec='SPEC-121',checkpoint='S-007/VFX/FILA-021/E03',generator='built-in imagegen',frame='E03',version='v01',prompt=prompt,transparent_background=False,destination=dest.relative_to(root).as_posix(),reference=dict(role='approved style reference',path=str(reference),original_path='F:/dev/nottgard-survivor/.atena/generated/art-candidates/vfx-pilot/melee_fisico_corte_medio_03_v02.png',sha256=sha(reference),approval_source='.atena/generated/CHATGPT-FILA-020-piloto-vfx-corpo-a-corpo-fisico.md'),source=queue.relative_to(root).as_posix(),canonical_source='.atena/generated/ART-PROMPTS-052-vfx-corpo-a-corpo-excecoes.md'))
save('reconciliation-2026-10-09.json',dict(timestamp=datetime.now(timezone.utc).isoformat(),plan='PLAN-053',spec='SPEC-121',classification='IN_PLAN',approval='per-plan',pilares_receipt='.atena/generated/pilares-complete-build-validation-2026-10-08.json',manifest_assets=202,lote_1=[dict(path=p,sha256=sha(root/p)) for p in paths],historical_hq=dict(catalog='data/hqs.json',stories=14,frames=56,assets=[dict(path=p,sha256=sha(root/p)) for p in hqpaths],action='preserve existing admitted images'),heroes_fila024='completed; current EVID-145 completion supersedes historical pending entries',conditional_ui='U01-U06 outside SPEC-121 acceptance; no mechanics added',optional_hq_trilha_c='conditional MEC-015; no new generation authorized at this checkpoint',remaining_vfx=dict(fila021=12,fila022=36,fila023=60,total=108),next='Generate E03 only and return peak for required owner approval; then five other E frames',ranking_return='PLAN-071 B-006/S-011 preserved'))
for rel in ['.atena/state/plan.yaml','.atena/state/plan-053-imagens.yaml']:
 p=root/rel;t=read(p)
 t=t.replace('RECONCILING_REMAINING_QUEUE','EXECUTING_GATE').replace('S-007/RECONCILIATION','S-007/VFX/FILA-021/E03')
 t=t.replace('S-006 Pilares concluido localmente: 26 fontes/5 tiras e build validados; S-007 em reconciliacao.','S-007 reconciliado: historicos preservados; gerando somente E03 para gate humano.')
 t=t.replace('Reconciliar S-007 e executar somente pendencias autorizadas ate o proximo gate humano. Retorno PLAN-071 preservado.','Gerar E03 e aguardar aprovacao visual antes dos cinco quadros restantes do arco radiante. Retorno PLAN-071 preservado.')
 t=t.replace('PLAN-053 retomado; Shendilavri e Goranthis validados localmente. Proximo piloto Pilares. PLAN-071 suspenso com retorno acima.','PLAN-053 retomado; biomas ate Pilares completos localmente. S-007 VFX em execucao ate gate E03. PLAN-071 suspenso com retorno acima.')
 p.write_text(t,encoding='utf-8')
print(json.dumps(dict(status='S007_RECONCILED_E03_READY',lote1=len(paths),hq=len(hqpaths),remaining_vfx=108,prompt_file=str(out/'e03-prompt-2026-10-09.json')),ensure_ascii=False))
