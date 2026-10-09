from pathlib import Path
from PIL import Image
import json, hashlib
root=Path(__file__).resolve().parents[4]
out=Path(__file__).parent
actor='escravo_de_rivenheart'
base=root/'.atena/generated/art-candidates/enemies-shendilavri'/actor
packing=json.loads((base/'strips/packing.json').read_text())
rows=[]
for state,sources in packing['sources'].items():
 for item in sources:
  p=root/item['path'].removeprefix('res://')
  im=Image.open(p).convert('RGBA'); a=im.getchannel('A'); h=a.histogram()
  box=a.point(lambda v:255 if v>=11 else 0).getbbox()
  row=dict(state=state,path=p.relative_to(root).as_posix(),sha256=hashlib.sha256(p.read_bytes()).hexdigest(),size=im.size,bbox=box,solidity=sum(h[230:])/sum(h[11:]),clipped=box[0]==0 or box[1]==0 or box[2]==im.width or box[3]==im.height)
  assert row['solidity']>=.9 and not row['clipped'],row
  rows.append(row)
assert len(rows)==20
official=[]
for p in sorted((root/'assets/animations/enemies'/actor).glob('*.png')):
 official.append(dict(path=p.relative_to(root).as_posix(),sha256=hashlib.sha256(p.read_bytes()).hexdigest(),size=Image.open(p).size))
assert len(official)==4
recoveries=[]
for rel in ['ui/cursor_skin.gd','ui/cursor_skin.gd.uid','data/cursor.json']:
 p=root/rel; q=Path('F:/dev/nottgard-survivor')/rel
 assert p.read_bytes()==q.read_bytes()
 recoveries.append(dict(path=rel,sha256=hashlib.sha256(p.read_bytes()).hexdigest(),provenance=str(q),byte_identical=True))
checks={}
for name,marker in [('escravo-queue.log','Animation queue: 0 failure(s)'),('escravo-runtime.log','death cleanup OK'),('escravo-suite-fixed.log','testes: 0 falha(s)'),('escravo-smoke.log','smoke: ok')]:
 t=(out/name).read_text(encoding='utf-8',errors='replace')
 assert marker in t and 'SCRIPT ERROR' not in t,name
 checks[name]=dict(path=(out/name).relative_to(root).as_posix(),marker=marker,no_script_errors=True)
manifest=json.loads((root/'.atena/generated/PRIORITY-IMAGES-2026-10-02.json').read_text(encoding='utf-8-sig'))
mismatches=[]
for row in manifest['assets']:
 p=root/row['path']
 if not p.exists() or hashlib.sha256(p.read_bytes()).hexdigest()!=row['sha256']:
  mismatches.append(row['path'])
assert not mismatches,mismatches
receipt=dict(date='2026-10-07',plan='PLAN-053',spec='SPEC-121',actor=actor,status='INTEGRATED_LOCAL_VALIDATED',selected_sources=rows,official_assets=official,checks=checks,manifest_verified=len(manifest['assets']),recovered_existing_dependencies=recoveries,gait_exception='Owner explicitly accepted dragging gait; move03 v03 selected; not extended to other actors.',death_review='Side collapse; death03 v02 replaces upward jump. Folded arm and hair change height 71 to 76 px, then final 72 px; no standing or resurrection.',repairs=['Merged duplicate _exit_tree in ui/run.gd preserving cursor disconnect/reset and Playtest recording.','Evidence queue test uses res://.atena/generated/test-state for writable isolated persistence and fails explicitly on enqueue failure; production unchanged.'])
(out/'escravo-completion-receipt.json').write_text(json.dumps(receipt,indent=2)+'\n',encoding='utf-8')
p=root/'.atena/state/plan.yaml';t=p.read_text(encoding='utf-8');t=t.replace('S-006/SHENDILAVRI/ESCRAVO-CYCLES','S-006/SHENDILAVRI/SUCUBO-CYCLES').replace('dono aprovou I01-I05 com atena, aprovado prossiga em 2026-10-07; geracao dos ciclos do Escravo em andamento.','Escravo integrado (20 quadros, quatro tiras), excecao de marcha aceita; checks zero falhas. Gerar Sucubo.');p.write_text(t,encoding='utf-8')
p=root/'.atena/state/plan-053-imagens.yaml';t=p.read_text(encoding='utf-8');t=t.replace('Escravo idle/move/attack gerados; dono aceitou marcha arrastada como excecao, move03 v03 selecionado. Gerar seis mortes, validar e integrar.','Escravo concluido e integrado: 20 quadros, quatro tiras, marcha arrastada aceita; suite/queue/runtime/smoke passaram. Gerar Sucubo.').replace('Gerar 101 quadros restantes','Gerar 82 quadros restantes').replace('cycles_generated: 0','cycles_generated: 19').replace('official_assets_installed: 0','official_assets_installed: 4');p.write_text(t,encoding='utf-8')
p=root/'.atena/generated/CHATGPT-FILA-017-mobs-shendilavri.md';t=p.read_text(encoding='utf-8');a=t.index('### `escravo_de_rivenheart`');b=t.index('### `sucubo`');t=t[:a]+t[a:b].replace('- [ ]','- [x]')+t[b:];t+='\n2026-10-07 — Escravo concluido: 20 fontes selecionadas e quatro tiras oficiais. Dono aceitou marcha arrastada como excecao; move03 v03 e death03 v02 selecionados. Fontes, hashes, recuperacao de CursorSkin e reparos locais de validacao registrados em shendilavri-resume/v01/escravo-completion-receipt.json; queue, runtime, suite e smoke nove fases passaram. Proximo Sucubo; 82 quadros novos restantes no lote.\n';p.write_text(t,encoding='utf-8')
p=root/'.atena/evidence/shendilavri-escravo-cycles-2026-10-07.md'
p.write_text('# Shendilavri — Escravo de Rivenheart\n\nPLAN-053 / SPEC-121, IN_PLAN, aprovacao por plano e identidades pelo dono. 20 quadros selecionados, quatro tiras instaladas localmente. Marcha arrastada aceita explicitamente pelo dono; nenhuma excecao transferida aos demais atores.\n\n[Recibo, fontes, hashes e checks](../generated/shendilavri-resume/v01/escravo-completion-receipt.json). [Prancha](../generated/priority-review/escravo_de_rivenheart_all_states.png). [Captura real](../generated/priority-review/escravo_de_rivenheart_runtime.png).\n\nQueue, runtime de ator real, suite e smoke nove fases passaram sem erros de script. Manifesto: 163 hashes conferidos. Recuperados CursorSkin, UID e dados existentes, identicos a replica local somente leitura. Corrigida duplicidade de _exit_tree preservando ambos os comportamentos; teste de fila usa arquivo persistente dentro do workspace, evitando falso verde por erro de escrita fora do sandbox. Essas correcoes foram necessarias para instanciar e validar o runtime atual.\n\nDeath03 v02 evita salto para cima; variacao de cinco pixels entre death03/04 vem de braco/cabelo na pose colapsada. Fontes nativas preservadas, sem limpeza de alfa ou redesenho por script. Integracao local; sem commit, push ou publicacao. Proximo: Sucubo.\n',encoding='utf-8')
print('20 selected sources, 4 official strips, 163 manifest hashes, 4 checks and 3 exact recoveries verified; cursor advanced.')
