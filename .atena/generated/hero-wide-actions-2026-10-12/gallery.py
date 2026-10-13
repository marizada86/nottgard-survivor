"""Build the local review gallery from audited native files; no image manipulation."""
from pathlib import Path
import html
import json
import os
import re

OUT=Path(__file__).resolve().parent
ROOT=OUT.parents[2]
m=json.loads((OUT/'manifest.json').read_text(encoding='utf-8'))
a=json.loads((OUT/'audit.json').read_text(encoding='utf-8'))
assert a['strips']==4 and a['frames']==20
sections=[]
jobs=[]
names={'AO08':'Arlindo · ataque Memória Alterada','ER08':'Erik · ataque de tocha','ER09':'Erik · Navios em Chamas','ER10':'Erik · morte'}
for src,result in zip(m['records'],a['records']):
    idle=os.path.relpath(ROOT/src['idle_reference']['path'],OUT).replace('\\','/')
    count=len(result['frames']);target=src['idle_reference']['target_body_height']
    note='Referência inicial de morte: 285 px, por já estar inclinada. A queda comprime a silhueta naturalmente, sem zoom por quadro.' if src['code']=='ER10' else 'A ativa conserva o agachamento; apoio dos pés e fogo abaixo deles têm coordenadas separadas.' if src['code']=='ER09' else 'Escala constante em toda a tira; efeito inteiro cabe no canvas.'
    cells=''.join(f'<a href="{f["path"]}"><img src="{f["path"]}" width="128" height="128" alt="{src["code"]} quadro {f["frame"]}"></a>' for f in result['frames'])
    sections.append(f'<section><h2>{src["code"]} · {names[src["code"]]}</h2><p>{note}</p><p>Referência corporal: {src["reference_body_height"]} px; escala única {result["uniform_scale"]:.4f}; PNG {result["size"][0]}×512; margem mínima {min(min(f["margins_px"]) for f in result["frames"])} px.</p><div class="pair" data-code="{src["code"]}"><figure><canvas width="512" height="512" data-role="idle"></canvas><figcaption>Idle aceito, sem reescala</figcaption></figure><figure><canvas width="512" height="512" data-role="action"></canvas><figcaption>Ação v01 · <span class="frame-label">quadro 1/{count}</span></figcaption></figure></div><p><a href="{result["strip"]}">Tira completa</a> · <a href="{html.escape(idle,quote=True)}">Referência aceita</a></p><div class="cells">{cells}</div></section>')
    jobs.append({'code':src['code'],'strip':result['strip'],'idle':idle,'frames':count,'body':target})
page='''<!doctype html><html lang="pt-BR"><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>Erik e Arlindo · ações 512×512 v01</title><style>body{max-width:1536px;margin:24px auto;padding:16px;background:#19171f;color:#e9e2d8;font:16px system-ui;line-height:1.5}a,h1,h2{color:#dec794}section{margin:32px 0;border-top:1px solid #645845;padding-top:16px}img.board{width:100%;height:auto}figure{margin:8px}canvas,.cells img{background:#25232b}canvas{border:1px solid #78684e;max-width:100%}.pair,.cells{display:flex;flex-wrap:wrap;gap:18px;align-items:end}button,select{padding:10px;background:#343039;border:1px solid #a08963;color:#eee}.controls{position:sticky;top:0;background:#19171feb;padding:12px;z-index:1}</style><h1>Quatro ações · candidatas wide v01</h1><p>PLAN-053 / DEV-024/hero-wide-actions-v01 aprovado por plano. Quatro tiras e vinte células 512×512 DRAFT. Fontes, extrações e oito candidatas já aceitas foram preservadas. Nenhum asset runtime admitido.</p><p>Compare identidade/figurino, porte e escala corporal com os idles, continuidade da pose, efeito inteiro e contato com o chão. Corpo a 85 px na opção padrão; o canvas não define a altura aparente. Crouch/queda não são ampliados artificialmente quadro a quadro. Massa/aparência são critérios humanos; a auditoria técnica não os aprova.</p><p><a href="manifest.json">Referências/marcações</a> · <a href="audit.json">Auditoria</a> · <a href="preparation.json">Registro Godot</a> · <a href="review-board.png">Prancha completa</a></p><p>Prancha: linhas AO08/ER08/ER09/ER10; colunas idle aceito / primeira pose / pico ou final. Linha dourada y=448 e eixo ciano do corpo.</p><img class="board" src="review-board.png" width="1536" height="2048" alt="Idles e ações comparados na mesma escala"><div class="controls"><button id="pause">Pausar</button> <button id="next">Avançar quadro</button> <label>Cadência <select id="speed"><option value="160">160 ms/quadro</option><option value="220">220 ms/quadro</option><option value="320">320 ms/quadro</option></select></label> <label>Corpo de referência <select id="size"><option value="85">85 px</option><option value="120">120 px</option><option value="240">240 px</option></select></label> <label><input id="grid" type="checkbox" checked> Base/eixo</label></div>'''+''.join(sections)+'''<script>
const jobs='''+json.dumps(jobs,ensure_ascii=False)+''';let paused=false,tickIndex=0;const views=jobs.map(j=>{const el=document.querySelector('.pair[data-code="'+j.code+'"]');const strip=new Image(),idle=new Image();strip.src=j.strip;idle.src=j.idle;return{...j,el,strip,idle,idleCanvas:el.querySelector('[data-role="idle"]'),actionCanvas:el.querySelector('[data-role="action"]')}});const reset=document.createElement('button');reset.textContent='Reiniciar sequências';reset.onclick=()=>{tickIndex=0;paused=false;document.querySelector('#pause').textContent='Pausar';draw()};document.querySelector('.controls').append(reset);
function resize(){for(const v of views){const px=512*Number(document.querySelector('#size').value)/v.body;for(const c of[v.idleCanvas,v.actionCanvas]){c.style.width=px+'px';c.style.height=px+'px'}}}
function axes(c){if(!document.querySelector('#grid').checked)return;c.strokeStyle='#ccb77d';c.beginPath();c.moveTo(0,448);c.lineTo(512,448);c.stroke();c.strokeStyle='#68b5bd';c.setLineDash([3,7]);c.beginPath();c.moveTo(256,10);c.lineTo(256,502);c.stroke();c.setLineDash([])}
function draw(){for(const v of views){const i=v.code==='ER10'?Math.min(tickIndex,v.frames-1):tickIndex%v.frames;const ac=v.actionCanvas.getContext('2d'),ic=v.idleCanvas.getContext('2d');ac.clearRect(0,0,512,512);ic.clearRect(0,0,512,512);if(v.strip.complete&&v.strip.naturalWidth)ac.drawImage(v.strip,i*512,0,512,512,0,0,512,512);if(v.idle.complete&&v.idle.naturalWidth)ic.drawImage(v.idle,0,0,256,384,128,80,256,384);axes(ac);axes(ic);v.el.querySelector('.frame-label').textContent='quadro '+(i+1)+'/'+v.frames}}
document.querySelector('#pause').onclick=e=>{paused=!paused;e.target.textContent=paused?'Retomar':'Pausar'};document.querySelector('#next').onclick=()=>{paused=true;document.querySelector('#pause').textContent='Retomar';tickIndex++;draw()};document.querySelector('#size').onchange=resize;document.querySelector('#grid').onchange=draw;function tick(){draw();if(!paused)tickIndex++;setTimeout(tick,Number(document.querySelector('#speed').value))}resize();tick();
</script><p>Prévia de revisão, sem playtest. Compatibilidade do canvas ampliado com o renderer do jogo não foi testada nem implementada. Integração, CANON, commit, push e exportação têm gates próprios.</p></html>\n'''
accepted=(OUT/'visual-acceptance.json').exists()
if accepted:
    page=page.replace('Fontes, extrações e oito candidatas já aceitas foram preservadas.','Quatro wide v01 visualmente aceitas pelo dono, mantidas DRAFT. Fontes, extrações e oito candidatas já aceitas foram preservadas.')
    page=page.replace('<a href="manifest.json">Referências/marcações</a>','<a href="visual-acceptance.json">Aceite das quatro</a> · <a href="accepted-hero-inventory.json">Inventário aceito</a> · <a href="manifest.json">Referências/marcações</a>')
(OUT/'index.html').write_text(page,encoding='utf-8')
links=re.findall(r'(?:href|src)="([^"]+)"',page)
for href in links:assert (OUT/html.unescape(href)).is_file(),href
for job in jobs:
    assert (OUT/job['strip']).is_file() and (OUT/job['idle']).is_file()
qa={'status':'LOCAL_FILES_AND_METADATA_PASS','links':len(links),'animation_jobs':4,'native_canvas':[512,512],'idle_reference_copy':'first 256x384 placed at x128/y80 without resizing','small_display_basis':'512 * chosen body height / 290 or 300, same geometry for idle and action','native_visual_inspection':'FOUR_STRIPS_AND_COMPARISON_BOARD_INSPECTED','browser_controls_test':'NOT_PERFORMED_KNOWN_FILE_URL_POLICY_BLOCK','human_visual_acceptance':'PENDING'}
if accepted:qa['human_visual_acceptance']='FOUR_WIDE_V01_APPROVED_EXPLICITLY_DRAFT'
(OUT/'gallery-qa.json').write_text(json.dumps(qa,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
print('Gallery ready: four comparative sequences,',len(links),'local links, native board and all twenty cells; no browser execution claimed.')
