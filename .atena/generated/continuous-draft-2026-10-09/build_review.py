from pathlib import Path
from PIL import Image,ImageDraw,ImageChops,ImageStat
import json,re,hashlib,html,os
r=Path.cwd();b=r/'.atena/generated/continuous-draft-2026-10-09';data=json.loads((b/'jobs.json').read_text(encoding='utf-8'));assert data['generated']==41
qfile=r/'.atena/generated/CHATGPT-FILA-023-vfx-habilidades-dos-herois.md';q=qfile.read_text(encoding='utf-8');sections=list(re.finditer(r'#### (H\d+) - `([^`]+)`[^\n]*\n(.*?)(?=\n#### |\n## H|\Z)',q,re.S));records=[]
jobmap={j['code']:j for j in data['jobs']}
for m in sections:
 code,name,section=m.groups()
 if code in jobmap:
  j=jobmap[code];p=r/j['destination'];assert hashlib.sha256(p.read_bytes()).hexdigest()==j['sha256'];rec=dict(j)
 else:
  path=re.search(r'candidata: `([^`]+)`',section)
  assert path,(code,section[:200]);p=r/path.group(1);rec=dict(code=code,name=name,destination=path.group(1),sha256=hashlib.sha256(p.read_bytes()).hexdigest(),status='PREVIOUSLY_GENERATED')
 assert p.exists();rec['absolute_path']=str(p);records.append(rec)
assert len(records)==60
groups={}
for rec in records:groups.setdefault(int(rec['code'][1:])//100,[]).append(rec)
all_sheet=Image.new('RGB',(6*180,10*200),(12,14,18));draw=ImageDraw.Draw(all_sheet);gallery=[];metrics=[]
for row,(key,items) in enumerate(sorted(groups.items())):
 items.sort(key=lambda j:int(j['code'][1:]));frames=[];row_sheet=Image.new('RGB',(6*256,282),(12,14,18));rd=ImageDraw.Draw(row_sheet)
 for col,j in enumerate(items):
  im=Image.open(j['absolute_path']).convert('RGB');small=im.resize((256,256),Image.Resampling.LANCZOS);frames.append(small)
  row_sheet.paste(small,(col*256,24));rd.text((col*256+8,5),j['code'],fill='white')
  all_sheet.paste(im.resize((180,180),Image.Resampling.LANCZOS),(col*180,row*200+20));draw.text((col*180+5,row*200+4),j['code'],fill='white')
 sheet=b/('H'+str(key)+'-contact.png');row_sheet.save(sheet);gif=b/('H'+str(key)+'-preview.gif');frames[0].save(gif,save_all=True,append_images=frames[1:],duration=150,loop=0)
 diff=[ImageStat.Stat(ImageChops.difference(frames[i],frames[(i+1)%6]).convert('L')).mean[0] for i in range(6)]
 met=dict(effect=items[0]['name'].split('_')[0],group=key,frames=6,adjacent_difference_mean=diff,loop_seam_difference=diff[-1],human_acceptance='PENDING',runtime_ready=False)
 metrics.append(met)
 gallery.append('<section><h2>'+html.escape(items[0]['name'].split('_')[0].title())+' · DRAFT</h2><img class="sheet" src="'+sheet.name+'"><img class="anim" src="'+gif.name+'"><p>'+ ' · '.join('<a href="'+html.escape(os.path.relpath(j['absolute_path'],b).replace('\\','/'))+'">'+j['code']+'</a>' for j in items)+'</p></section>')
all_sheet.save(b/'all60-contact.png')
heroes=[]
for who,portrait,idle in [('erik','er01-retrato-v01.png','er02-idle-v02.png'),('arlindo','ao01-retrato-v01.png','ao02-idle-v01.png')]:
 d=r/'.atena/generated/art-candidates/heroes-novos'/who;im=Image.open(d/idle).convert('RGBA');frames=[]
 for i in range(4):
  cell=im.crop((i*im.width//4,0,(i+1)*im.width//4,im.height)).resize((256,384),Image.Resampling.LANCZOS);bg=Image.new('RGBA',cell.size,(76,87,97,255));bg.alpha_composite(cell);frames.append(bg.convert('RGB'))
 gif=b/(who+'-idle-preview.gif');frames[0].save(gif,save_all=True,append_images=frames[1:],duration=220,loop=0)
 heroes.append('<section><h2>'+who.title()+'</h2><p>Retrato aprovado; idle '+('aprovado visualmente, normalização pendente' if who=='erik' else 'DRAFT para revisão')+'.</p><img class="portrait" src="'+os.path.relpath(d/portrait,b).replace('\\','/')+'"><img class="anim" src="'+gif.name+'"></section>')
doc='''<!doctype html><html lang="pt-BR"><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>Revisão de assets — 9 outubro 2026</title><style>body{background:#10141b;color:#e6edf5;font:16px system-ui;margin:32px auto;max-width:1250px;padding:0 20px}h1{font-size:32px}section{background:#19212c;padding:20px;margin:24px 0;border-radius:12px}.sheet{width:100%;height:auto}.anim{max-width:256px;vertical-align:middle;margin:12px}.portrait{width:min(700px,65%)}a{color:#9cceff}p{line-height:1.6}</style><h1>64 assets para revisão</h1><p>60 imagens VFX e quatro peças de Erik/Arlindo. Esta execução acrescentou 41 VFX + AO02. Novos VFX e AO02 são DRAFT. ER01, ER02 e AO01 foram aprovados visualmente. Nada foi admitido ao runtime nesta execução.</p><p>Verifique identidade, leitura em tamanho pequeno e progressão das seis fases. GIFs usam as imagens na ordem temporal, com redução uniforme para prévia: não corrigem pivô nem escala. Kayron/Nyrelia precisam de revisão do ciclo; Korrak tem leitura vertical de chamas; Sylas H402 tem cauda maior que o esperado. Todos os novos VFX vieram1254×1254 em vez1024×1024. Idles vieram2048×768 e precisam de grade/altura/pivô validados.</p>'''+''.join(heroes)+''.join(gallery)+'</html>'
(b/'index.html').write_text(doc,encoding='utf-8')
manifest=r/'.atena/generated/PRIORITY-IMAGES-2026-10-02.json';mh=hashlib.sha256(manifest.read_bytes()).hexdigest();assert mh=='09928dd3c6f336d8ed1fc356f088e062a1d7adaf61d08fd51754cb3dfc56c913'
receipt=dict(status='NATIVE_GENERATION_COMPLETE_REVIEW_PENDING',vfx_count=60,new_vfx=41,new_hero_idle=1,hero_pilot_pieces=4,hash_checks=60,manifest_sha256=mh,runtime_admission=False,metrics=metrics,flags=[dict(code=j['code'],flags=j.get('technical_flags',[])) for j in records if j.get('technical_flags')],visual_pending={'Sylas':'H402 reach/leftward tail; H406 opacity fading needs review','Korrak':'Flames have vertical appearance; assess flat topdown contract','Kayron/Nyrelia':'Subtle phase variation; seam and rotation review','All':'Native size and exact pivot normalization; human acceptance'},records=records)
(b/'completion-audit.json').write_text(json.dumps(receipt,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
q=re.sub(r'status: "[^"]*"','status: "FILA02360/60 nativas geradas; novas41 DRAFT; revisao humana e normalizacao pendentes; sem runtime"',q,count=1)
for m in reversed(sections):
 code=m.group(1)
 if code not in jobmap:continue
 old=m.group(0);j=jobmap[code];line='- [x] gerada · [ ] aprovada · candidata: `'+j['destination']+'` — DRAFT; revisão humana adiada por autorização contínua.'
 new=re.sub(r'- \[[ x]\] gerada[^\n]*',line,old,count=1)
 if new==old:
  new=old.replace('```text',line+'\n\n```text',1)
 q=q[:m.start()]+new+q[m.end():]
q=q.replace('H403v02 Sylas gate pendente','H403v02 Sylas aprovada')
qfile.write_text(q,encoding='utf-8')
for p in [r/'.atena/state/plan.yaml',r/'.atena/state/plan-053-imagens.yaml']:
 t=p.read_text(encoding='utf-8');t=t.replace('checkpoint: S-007/VFX/FILA-023/CONTINUOUS-DRAFT','checkpoint: S-007/VFX/FILA-023/REVIEW-60')
 t=t.replace("current: 'H403v02 aprovada; prioridade ART045 detectada; FILA02319/60.'","current: 'FILA02360/60 geradas; quatro pilotos ART045 gerados; revisao e normalizacao pendentes.'")
 t=re.sub(r"  next: 'ER01 aprovada; ER02v02 auditada[^\n]*", "  next: 'Revisar galeria64; normalizar grade/pivo; admissao runtime depende do aceite.'",t)
 t+='\ncontinuous_generation_result:\n  status: NATIVE_GENERATION_COMPLETE_REVIEW_PENDING\n  native_vfx: 60\n  remaining_native_vfx_frames: 0\n  hero_pilot_pieces: 4\n  gallery: .atena/generated/continuous-draft-2026-10-09/index.html\n  audit: .atena/generated/continuous-draft-2026-10-09/completion-audit.json\n  runtime_admission: false\n'
 p.write_text(t,encoding='utf-8')
(r/'.atena/evidence/continuous-draft-generation-2026-10-09.md').write_text('# Geração contínua — revisão v02\n\nDono autorizou execução por plano sem pausas por lote e revisão posterior. Escopo nativo concluído: 41 VFX restantes da FILA023 e AO02, 42 novos assets. FILA023 agora60/60; ART045 quatro pilotos gerados. [Galeria](../generated/continuous-draft-2026-10-09/index.html), [auditoria](../generated/continuous-draft-2026-10-09/completion-audit.json), [prompts](../generated/continuous-draft-2026-10-09/jobs.json). Ferramenta integrada imagegen. Originais preservados; 60 hashes conferidos; manifesto oficial inalterado. Não houve admissão runtime ou publicação.\n\nAceite: geração nativa e referências concluídas; dimensões exatas/pivô, critérios visuais subjetivos e integração permanecem pendentes. VFX novosDRAFT; ER01/ER02/AO01 promovidos separadamente por aceite expresso. Rejeições/correções futuras preservam versões. Próximo objetivo: revisão da galeria, correção técnica e admissão dos candidatos aceitos.\n',encoding='utf-8')
print(json.dumps({'vfx':60,'new_assets':42,'hash_checks':60,'gallery':str(b/'index.html'),'manifest_unchanged':True}))
