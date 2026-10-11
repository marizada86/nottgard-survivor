"""Independent read-only pixel comparison, hashes and report/HTML output."""
from pathlib import Path
from PIL import Image
import numpy as np, json, hashlib, re

base=Path(__file__).parent
root=base.parents[2]
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
inputs=json.loads((base/'inputs.json').read_text(encoding='utf-8'))
unchanged=[dict(path=e['path'],unchanged=sha(root/e['path'])==e['sha256']) for e in inputs['protected']]
original=np.asarray(Image.open(base/'base.png').convert('RGBA'))
body=np.asarray(Image.open(base/'masks/body.png').convert('L'))>0
fire=np.asarray(Image.open(base/'masks/fire.png').convert('L'))>0
allowed=np.asarray(Image.open(base/'masks/allowed-effects.png').convert('L'))>0
frames=[];reports=[]
params=json.loads((base/'parameters.json').read_text(encoding='utf-8'))
for i in range(6):
    p=base/'frames'/f'AL01_loop_v03_f{i}.png'
    im=Image.open(p);f=np.asarray(im);frames.append(f)
    different=np.any(f!=original,axis=2)
    yy,xx=np.where(f[:,:,3]>0)
    reports.append(dict(frame=i,sha256=sha(p),mode=im.mode,size=list(im.size),body_changed_pixels=int(different[body].sum()),outside_allowed_changed_pixels=int(different[~allowed].sum()),nonopaque_body_pixels=int((f[:,:,3][body]!=255).sum()),effect_changed_pixels=int(different[allowed].sum()),bbox=[int(xx.min()),int(yy.min()),int(xx.max()+1),int(yy.max()+1)],edge_alpha_pixels=int((f[0,:,3]>0).sum()+(f[-1,:,3]>0).sum()+(f[:,0,3]>0).sum()+(f[:,-1,3]>0).sum())))
transitions=[]
for i in range(6):
    j=(i+1)%6
    delta=np.abs(frames[i].astype(np.int16)-frames[j].astype(np.int16))
    transitions.append(dict(from_frame=i,to_frame=j,changed_pixels=int(np.any(delta>0,axis=2).sum()),body_changed_pixels=int(np.any(delta>0,axis=2)[body].sum()),effect_rgba_l1=int(delta[allowed].sum())))
sheet=Image.open(base/'normalized/AL01_loop_v03.png');s=np.asarray(sheet)
pack_matches=sheet.size==(1152,192) and all(np.array_equal(s[:,i*192:(i+1)*192],frames[i]) for i in range(6))
safe=bool((~(body&allowed)).all() and (body|fire)[original[:,:,3]>0].all() and not (body&fire).any())
unique=len({r['sha256'] for r in reports})
anchor=all(r['bbox']==reports[0]['bbox'] for r in reports)
shift_wrap=[]
for effect in params['effects']:
    values=[next(e for e in f['effects'] if e['name']==effect['name'])['shift'] for f in params['timeline']]
    shift_wrap.append(dict(name=effect['name'],max_absolute_shift=max(abs(v) for v in values),max_cyclic_step=max(abs(values[(i+1)%6]-values[i]) for i in range(6))))
seam_normal=transitions[-1]['effect_rgba_l1']<=max(t['effect_rgba_l1'] for t in transitions[:-1])*1.25
passes=dict(protected_inputs_unchanged=all(e['unchanged'] for e in unchanged),mask_partition_disjoint=safe,body_invariant_all_pixels=all(r['body_changed_pixels']==0 for r in reports),outside_effects_invariant_all_pixels=all(r['outside_allowed_changed_pixels']==0 for r in reports),body_opaque_all_segmented_pixels=all(r['nonopaque_body_pixels']==0 for r in reports),frames_rgba_192=all(r['size']==[192,192] and r['mode']=='RGBA' for r in reports),packed_rgba_1152_192=sheet.mode=='RGBA' and pack_matches,anchor_invariant=anchor,transparent_outer_borders=all(r['edge_alpha_pixels']==0 for r in reports),at_least_four_distinct_frames=unique>=4,motion_bounded_cyclic=all(e['max_absolute_shift']<=1 and e['max_cyclic_step']<=1 for e in shift_wrap),seam_delta_in_adjacent_range=seam_normal)
report=dict(revision='AL01-CORR/v01',status='TECHNICALLY_VERIFIED_DRAFT_OWNER_REVIEW_PENDING' if all(passes.values()) else 'HELD_CORRECTION_FAILED',content_state='DRAFT',runtime_admission=False,checks=passes,source_hashes=unchanged,body_pixels=int(body.sum()),fire_pixels=int(fire.sum()),allowed_effect_pixels=int(allowed.sum()),unique_frames=unique,frames=reports,transitions=transitions,motion=shift_wrap,sheet_sha256=sha(base/'normalized/AL01_loop_v03.png'),mask_authority='Manual fire regions inspected against base image before frame production',seam_criterion='Wrap L1 <= 1.25 times maximum adjacent non-wrap L1; human rhythm acceptance still pending',limitations=['Mask classification is a visual judgment; opacity/invariance measured over every pixel in those masks.','Three flames use brightness-only fallback; right flame shifts by up to one pixel.','No runtime test or owner loop acceptance performed.'])
(base/'audit.json').write_text(json.dumps(report,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
frames_html=''.join(f'<figure><img src="frames/AL01_loop_v03_f{i}.png" width="192" height="192"><figcaption>Quadro {i}</figcaption></figure>' for i in range(6))
cards=''.join(f'<div class="stage {bg}"><div class="loop"></div><p>{label}</p></div>' for bg,label in [('dark','Fundo escuro'),('light','Fundo claro'),('checker','Transparência')])
html='''<!doctype html><html lang="pt-BR"><meta charset="utf-8"><title>AL01-CORR/v01 · altar DRAFT</title><style>body{font:16px system-ui;background:#17191f;color:#eee;margin:24px}a{color:#9ed9ff}button{font:inherit;padding:8px 16px}h2{margin-top:32px}.row{display:flex;gap:18px;flex-wrap:wrap}.stage{padding:16px;min-width:192px}.dark{background:#292934}.light{background:#eee;color:#111}.checker{background:repeating-conic-gradient(#999 0 25%,#ccc 0 50%) 0/20px 20px;color:#111}img,.loop{image-rendering:pixelated}.loop{width:192px;height:192px;background-image:url(normalized/AL01_loop_v03.png);animation:flames var(--speed,900ms) steps(6) infinite}.old{background-image:url(../fila028-preparation-2026-10-10/normalized/AL01_v02.png)}@keyframes flames{to{background-position:-1152px 0}}figure{margin:0}figcaption{text-align:center}.zoom{max-width:min(768px,100%)}.ok{color:#9ee7ac}</style><h1>AL01-CORR/v01 · candidata DRAFT</h1><p class="ok">Corpo fixo e opaco em todos os pixels da máscara. Seis quadros distintos. Revisão humana do ritmo e aparência pendente.</p><p>Fonte CANON AL01 v02 preservada; demais 33 derivadas aceitas intactas. Chama direita oscila até 1 px; três chamas e brasas variam brilho. Sem integração, commit ou push.</p><p><a href="audit.json">Auditoria</a> · <a href="parameters.json">Parâmetros</a> · <a href="inputs.json">Hashes das entradas</a> · <a href="normalized/AL01_loop_v03.png">Tira RGBA 1152×192</a></p><div class="row"><button onclick="speed(600)">600 ms</button><button onclick="speed(900)">900 ms</button><button onclick="speed(1200)">1200 ms</button><button onclick="pause(this)">Pausar</button></div><p id="speed">Cadência: 900 ms por ciclo</p><h2>Correção em tamanho real</h2><div class="row">'''+cards+'''</div><h2>Comparação: base fixa, loop anterior retido e candidata</h2><div class="row"><figure class="stage dark"><img width="192" height="192" src="base.png"><figcaption>Primeiro quadro / corpo de referência</figcaption></figure><figure class="stage dark"><div class="loop old"></div><figcaption>Loop anterior: corpo variável, retido</figcaption></figure><figure class="stage dark"><div class="loop"></div><figcaption>Correção v01 / loop_v03 DRAFT</figcaption></figure></div><h2>Máscaras revisadas</h2><p>Verde: pixels de chama/brasas; azul: margem livre de oscilação. Pedra, pano, bacia e corpos das velas excluídos dos efeitos.</p><img class="zoom" src="masks-preview.png"><p><a href="masks/body.png">Corpo fixo</a> · <a href="masks/fire.png">Fogo</a> · <a href="masks/allowed-effects.png">Área de efeito</a></p><h2>Seis quadros corrigidos</h2><div class="row">'''+frames_html+'''</div><details><summary>Fonte CANON AL01 v02</summary><img class="zoom" src="../fila028-generation-2026-10-10/native-sources/AL01_v02.png"></details><p>Para aceitar: verificar conservação do altar/quatro velas, contornos nos três fundos, se a pulsação parece fogo e se a transição final→inicial é confortável. Escolher 600, 900 ou 1200 ms. Não há playtest do jogo nesta etapa.</p><script>function speed(ms){document.documentElement.style.setProperty('--speed',ms+'ms');document.getElementById('speed').textContent='Cadência: '+ms+' ms por ciclo'}function pause(button){const paused=button.textContent==='Pausar';document.querySelectorAll('.loop').forEach(el=>el.style.animationPlayState=paused?'paused':'running');button.textContent=paused?'Continuar':'Pausar'}</script></html>'''
if not all(passes.values()):html=html.replace('class="ok"','').replace('Corpo fixo e opaco em todos os pixels da máscara. Seis quadros distintos.','CORREÇÃO RETIDA: consultar checks da auditoria.')
(base/'index.html').write_text(html,encoding='utf-8')
print(json.dumps(dict(status=report['status'],checks=passes,body_pixels=int(body.sum()),unique_frames=unique,transition_l1=[t['effect_rgba_l1'] for t in transitions]),ensure_ascii=False))
assert all(passes.values()),passes
