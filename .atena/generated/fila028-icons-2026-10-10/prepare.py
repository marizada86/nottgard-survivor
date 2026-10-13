from pathlib import Path
import hashlib,json,re
root=Path(__file__).resolve().parents[3];base=Path(__file__).parent
source=root/'.atena/generated/ART-PROMPTS-061-eventos-arcanista-icones-segredos-e-altar.md'
common='Use case: stylized-concept. One painted dark pixel-art game item or ability icon, thick dark outline, clear readable materials, high contrast, upper-left lighting. Single central object or compact magical gesture, three-quarter view, at least 15 percent clear margin on every side. Genuine transparent background. Square native source, request 1024x1024. Readable silhouette at 48px, eventual game target 128x128. No lettering, numerals, extra hands, frame, scenery, logo or watermark; no color touching image edges. References are style anchors unless explicitly identified as object identity. No background disk or decorative border. '
weapons=['assets/icons/weapons/descarga_estelar.png','assets/icons/weapons/golpe_esmagador.png']
items=['assets/icons/items/machado_de_xargath.png','assets/icons/items/colar_dos_tentaculos.png']
jobs=[]
for line in source.read_text(encoding='utf-8').splitlines():
    if not re.match(r'^\| IC\d\d \|',line):continue
    cols=[s.strip() for s in line.split('|')[1:-1]];code,item,request=cols
    refs=list(weapons if int(code[2:])<=6 else items)
    if code=='IC06':refs.append('assets/icons/weapons/dominar_pessoa.png')
    if code=='IC13':refs.append('.atena/generated/item-refs/coracao-da-dominancia-referencia.webp')
    jobs.append(dict(code=code,item=item.strip('`'),prompt=common+code+': '+request.replace('**','')+(' The owner heart-staff reference is the authoritative identity, overriding textual visual details if they differ.' if code=='IC13' else ''),references=[dict(path=p,sha256=hashlib.sha256((root/p).read_bytes()).hexdigest(),role='identity authority' if code=='IC13' and 'item-refs' in p else 'family style anchor') for p in refs],native_destination=f'.atena/generated/art-candidates/fila028-icons/{code}_v01.png',state='PENDING_SCOPE_APPROVAL',content_state='DRAFT',runtime_admission=False))
assert len(jobs)==13
data=dict(plan='PLAN-053/SPEC-121',revision='FILA-028-IC/v01',source_prompt_file=str(source.relative_to(root)),source_prompt_sha256=hashlib.sha256(source.read_bytes()).hexdigest(),approval_mode='per-plan',scope_approval='PENDING',tool='built-in imagegen',jobs=jobs)
(base/'jobs.json').write_text(json.dumps(data,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'prepared':len(jobs),'references_exist':True,'generated':0,'scope_approval':'PENDING'}))
