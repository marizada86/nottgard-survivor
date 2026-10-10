from pathlib import Path
from PIL import Image
import json,hashlib,html,re,shutil
base=Path(__file__).parent;root=base.parents[2];native=root/'.atena/generated/art-candidates/heroes-novos'
rows=[
 ('ER03','erik','e','../erik-gait-pilot/layered-v01','erik-move-e-layered-1536x384.png','er03-move_e-layered-v01.png','OWNER_APPROVED_PILOT_FOR_TRIAL'),
 ('ER04','erik','se','template-cycle-v01','erik-move-se-templates-1536x384.png','er04-move_se-templates-v01.png','DRAFT_ART_REVIEW_PENDING'),
 ('ER05','erik','s','erik-south-cycle-v01','erik-move-s-templates-1536x384.png','er05-move_s-templates-v01.png','DRAFT_ART_REVIEW_PENDING'),
 ('ER06','erik','ne','erik-northeast-cycle-v01','erik-move-ne-templates-1536x384.png','er06-move_ne-templates-v01.png','DRAFT_ART_REVIEW_PENDING'),
 ('ER07','erik','n','erik-north-cycle-v01','erik-move-n-templates-1536x384.png','er07-move_n-templates-v01.png','DRAFT_ART_REVIEW_PENDING'),
 ('AO03','arlindo','e','arlindo-east-cycle-v02','arlindo-move-e-templates-1536x384.png','ao03-move_e-templates-v02.png','DRAFT_TEXTURE_REFINEMENT_REQUIRED'),
 ('AO04','arlindo','se','arlindo-template-cycle-v02','arlindo-move-se-templates-1536x384.png','ao04-move_se-templates-v02.png','DRAFT_ART_REVIEW_PENDING'),
 ('AO05','arlindo','s','arlindo-south-cycle-v01','arlindo-move-s-templates-1536x384.png','ao05-move_s-templates-v01.png','DRAFT_ART_REVIEW_PENDING'),
 ('AO06','arlindo','ne','arlindo-northeast-cycle-v02','arlindo-move-ne-templates-1536x384.png','ao06-move_ne-templates-v02.png','DRAFT_ART_REVIEW_PENDING'),
 ('AO07','arlindo','n','arlindo-north-cycle-v01','arlindo-move-n-templates-1536x384.png','ao07-move_n-templates-v01.png','DRAFT_ART_REVIEW_PENDING'),
]
labels={'e':'Leste','se':'Sudeste','s':'Sul','ne':'Nordeste','n':'Norte'};cards=[];results=[]
jobs_path=root/'.atena/generated/erik-arlindo-complete-2026-10-09/jobs.json';jobs=json.loads(jobs_path.read_text(encoding='utf-8-sig'))
original_hashes=[]
for j in jobs['jobs']:
    p=root/j['destination'];same=hashlib.sha256(p.read_bytes()).hexdigest()==j['sha256'];assert same,j['code'];original_hashes.append({'code':j['code'],'unchanged':same})
for code,hero,direction,folder,filename,candidate_name,status in rows:
    p=base/folder/filename;dest=native/hero/candidate_name;sha=hashlib.sha256(p.read_bytes()).hexdigest()
    if dest.exists():assert hashlib.sha256(dest.read_bytes()).hexdigest()==sha
    else:shutil.copyfile(p,dest)
    atlas=Image.open(p);assert atlas.mode=='RGBA' and atlas.size==(1536,384)
    frames=[atlas.crop((256*i,0,256*(i+1),384)) for i in range(6)]
    boxes=[f.getchannel('A').point(lambda v:255 if v>=26 else 0).getbbox() for f in frames]
    for box in boxes:assert box and box[0]>=10 and box[2]<=246 and box[1]>=10 and box[3]==368,(code,box)
    distinct=len({hashlib.sha256(f.tobytes()).hexdigest() for f in frames});assert distinct==6,(code,distinct)
    upper={hashlib.sha256(f.crop((0,0,256,200)).tobytes()).hexdigest() for f in frames};assert len(upper)==1,(code,'upper body drift')
    alpha=atlas.getchannel('A').getextrema();assert alpha[0]==0 and alpha[1]>200
    record={'code':code,'hero':hero,'direction':direction,'candidate':str(dest.relative_to(root)).replace('\\','/'),'sha256':sha,'frames':6,'size':[1536,384],'alpha_extrema':alpha,'bounds':boxes,'distinct_frames':distinct,'support_baseline':368,'upper_body_pixels_identical':True,'artistic_status':status,'runtime_admission':False}
    results.append(record)
    if code!='ER03':
        j=next(j for j in jobs['jobs'] if j['code']==code)
        j['controlled_gait_candidate']=record
    badge='Piloto aprovado para teste' if code=='ER03' else ('Acabamento da calça pendente' if code=='AO03' else 'Candidata para revisão')
    note='Pernas alternadas; verificar emendas, passada e continuidade do loop.'
    if code=='AO03':note='Alternância controlada; deformação da calça impede considerar esta versão final.'
    flag=' warning' if code=='AO03' else ''
    cards.append(f'''<article class="card{flag}"><h2>{hero.title()} · {labels[direction]} <small>{code}</small></h2><p class="badge">{badge}</p><div class="stage"><canvas width="256" height="384" data-src="{folder}/{filename}" aria-label="Caminhada {hero} {labels[direction]}"></canvas></div><p>{note}</p><nav><a href="{folder}/contacts-1-4.png">Contatos 1 e 4</a><a href="{folder}/six-frames.png">Seis quadros</a><a href="{folder}/{filename}">PNG</a></nav></article>''')
    # Approved pilot's older gallery has no six-frames.png; use native strip instead.
    if code=='ER03':cards[-1]=cards[-1].replace(f'{folder}/six-frames.png',f'{folder}/{filename}')
doc='''<!doctype html><html lang="pt-BR"><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>Caminhadas — Erik e Arlindo</title>
<style>body{margin:0;background:#12181e;color:#e4eaf0;font:16px system-ui;padding:28px}h1{margin:0 0 10px}header{max-width:960px}header p{line-height:1.6}button,input{font:inherit}button{background:#283b47;border:1px solid #517384;color:white;border-radius:7px;padding:9px 14px;cursor:pointer}button:focus-visible,a:focus-visible{outline:3px solid #f0ba64}.controls{position:sticky;top:0;background:#12181ef2;padding:14px 0;display:flex;gap:10px;align-items:center;flex-wrap:wrap;z-index:2}.grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(280px,1fr));gap:18px;margin-top:20px}.card{border:1px solid #374b58;border-radius:12px;background:#1b252e;padding:16px}.warning{border-color:#c69d5c}h2{font-size:19px;display:flex;justify-content:space-between}small{color:#a6bdca;font-size:13px}.badge{color:#99d0c7;font-size:14px}.warning .badge{color:#efc782}.stage{height:384px;display:flex;justify-content:center;align-items:end;background:#303843;border-radius:8px}.stage canvas{image-rendering:pixelated;max-width:100%;height:auto}.game .stage canvas{width:55px;height:82px}.game .stage{height:120px}.card p{line-height:1.5;font-size:14px;min-height:42px}nav{display:flex;gap:14px;flex-wrap:wrap}a{color:#a6dafa}output{min-width:92px}</style>
<header><h1>Caminhadas de Erik e Arlindo</h1><p>Nove novas candidatas e o piloto leste aprovado. Compare os contatos 1 e 4: cada perna assume sua vez. As versões novas continuam como rascunhos para revisão artística. Arlindo leste ainda precisa de acabamento na calça.</p><p>Grade 1536 × 384, seis quadros distintos, transparência real, margens e base y = 368 verificadas. Tronco, identidade e mão da tocha preservados. A prévia permite avaliar a rigidez do tronco e a passagem entre os quadros; aprovação artística e teste no jogo permanecem pendentes.</p></header>
<div class="controls"><button id="pause">Pausar</button><button id="next">Próximo quadro</button><button id="contacts">Contatos 1 ↔ 4</button><button id="scale">Ver no tamanho de jogo</button><label>Velocidade <input id="fps" type="range" min="4" max="14" value="10"></label><output id="position">Quadro 1 · 10 fps</output></div><main class="grid">'''+''.join(cards)+'''</main>
<script>const canvases=[...document.querySelectorAll('canvas')];let frame=0,playing=true,fps=10,last=0;for(const c of canvases){c.asset=new Image;c.asset.onload=()=>draw();c.asset.onerror=()=>{c.parentNode.textContent='Falha ao carregar PNG: '+c.dataset.src};c.asset.src=c.dataset.src}function draw(){for(const c of canvases){if(!c.asset.complete||!c.asset.naturalWidth)continue;const ctx=c.getContext('2d');ctx.imageSmoothingEnabled=false;ctx.clearRect(0,0,256,384);ctx.drawImage(c.asset,frame*256,0,256,384,0,0,256,384)}document.getElementById('position').value='Quadro '+(frame+1)+' · '+fps+' fps'}function tick(t){if(playing&&t-last>=1000/fps){frame=(frame+1)%6;last=t;draw()}requestAnimationFrame(tick)}requestAnimationFrame(tick);function pause(){playing=false;document.getElementById('pause').textContent='Reproduzir'}document.getElementById('pause').onclick=function(){playing=!playing;this.textContent=playing?'Pausar':'Reproduzir';last=performance.now()};document.getElementById('next').onclick=()=>{pause();frame=(frame+1)%6;draw()};document.getElementById('contacts').onclick=()=>{pause();frame=frame===0?3:0;draw()};document.getElementById('fps').oninput=e=>{fps=Number(e.target.value);draw()};document.getElementById('scale').onclick=function(){document.body.classList.toggle('game');this.textContent=document.body.classList.contains('game')?'Ver ampliado':'Ver no tamanho de jogo'};</script></html>'''
for link in re.findall(r'(?:href|data-src)="([^"]+)"',doc):assert (base/link).exists(),link
(base/'index.html').write_text(doc,encoding='utf-8')
(base/'review-audit.json').write_text(json.dumps({'date':'2026-10-10','request_classification':'IN_PLAN','approval_mode':'per-plan','nine_new_derivatives':True,'eight_candidates_for_art_review':True,'one_texture_refinement_required':'AO03','originals':original_hashes,'rows':results,'gallery_links':'PASS','runtime_admission':False,'commit_push':False,'limitations':['Review is not owner artistic approval.','Trunk/flame fixed: focus is gait correction; evaluate stiffness.','No full game admission or gameplay test.','Frame-to-frame smoothing and coat hems may still need art adjustments.']},indent=2),encoding='utf-8')
jobs_path.write_text(json.dumps(jobs,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
queue=root/'.atena/generated/CHATGPT-FILA-027-erik-e-arlindo.md'
with queue.open('a',encoding='utf-8') as f:
    f.write('\n## Correção controlada das caminhadas — 2026-10-10\n\n[Galeria de dez direções, contatos e reprodução](erik-gait-reference-production/index.html). Nove candidatas novas: oito aguardam revisão artística e AO03 requer refinamento da calça. Seis quadros distintos, alpha, grade, margens e base368 conferidos. Originais preservados; runtime não alterado.\n')
for state_name in ['plan.yaml','dev-024-art045-pilots.yaml']:
    state=root/'.atena/state'/state_name;text=state.read_text(encoding='utf-8-sig')
    text=text.replace('DEV-024/GAIT-REFERENCE/ER04-LAYER-REFINEMENT','DEV-024/GAIT-REFERENCE/REVIEW-10').replace('GAIT-REFERENCE/ER04-LAYER-REFINEMENT','GAIT-REFERENCE/REVIEW-10').replace('checkpoint: ER04-LAYER-REFINEMENT','checkpoint: REVIEW-10')
    if state_name=='plan.yaml':text=text.replace('request_classification: PLAN_DEVIATION','request_classification: IN_PLAN',1)
    state.write_text(text,encoding='utf-8')
side=root/'.atena/state/dev-024-art045-pilots.yaml'
with side.open('a',encoding='utf-8') as f:f.write('\ncontrolled_walk_review:\n  new_candidates: 9\n  human_art_review_pending: 8\n  texture_refinement_required: AO03\n  gallery: .atena/generated/erik-gait-reference-production/index.html\n  audit: .atena/generated/erik-gait-reference-production/review-audit.json\n  runtime_admission: false\n')
evidence=root/'.atena/evidence/hero-walk-controlled-correction-2026-10-10.md'
evidence.write_text('''# Caminhadas controladas de Erik e Arlindo

Classificação IN_PLAN. Pedido do dono: “continue estou quase desistindo”. Aprovação per-plan anterior mantida. Método local por camadas já autorizado; nenhuma alteração canônica ou integração no jogo.

Resultado: nove novas tiras, além do piloto ER03 aprovado. ER04–ER07 e AO04–AO07 têm alternância de contatos legível na revisão dos seis quadros; aguardam aceite artístico. AO03 alterna a geometria, mas a deformação da calça ainda exige refinamento. Não é uma conclusão integral dos personagens nem aceite automático de todas as imagens.

As tentativas de geração/limpeza que repetiram a passada e os derivados com textura inadequada foram preservados e rejeitados. O derivado final usa máscaras e poses controladas; as pinturas de frente/trás das pernas são reposicionadas nos quadris, com oclusão apropriada. Isso preserva a aparência geral e corrige a alternância, mas não valida a continuidade artística de materiais ou emendas.

Checks automáticos: dez atlas RGBA1536x384; seis quadros distintos por atlas; margens>=10px; apoio368 em cada quadro; pixels da parte superior iguais entre quadros; hashes dos16 originais conferidos; links da galeria existentes. Esses checks não provam anatomia. Contatos1/4 e todos os quadros intermediários dos nove derivados foram inspecionados visualmente. Tronco e chama estão fixos; rigidez, emendas do casaco e transições ainda pertencem à revisão artística. Não houve teste completo de gameplay, admissão, commit ou push.

Galeria: ../generated/erik-gait-reference-production/index.html
Auditoria: ../generated/erik-gait-reference-production/review-audit.json
''',encoding='utf-8')
print(json.dumps({'gallery':str(base/'index.html'),'new_candidates':9,'contracts_passed':10,'originals_unchanged':16,'texture_refinement_required':'AO03'}))
