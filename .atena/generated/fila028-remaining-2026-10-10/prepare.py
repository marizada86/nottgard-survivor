from pathlib import Path
import re,json,hashlib
base=Path(__file__).parent;root=base.parents[2]
p61=root/'.atena/generated/ART-PROMPTS-061-eventos-arcanista-icones-segredos-e-altar.md';p59=root/'.atena/generated/ART-PROMPTS-059-icones-das-bencaos-novas.md'
t=p61.read_text(encoding='utf-8');b=p59.read_text(encoding='utf-8')
common=re.search(r'## Bloco comum — props e personagens de evento\s+```text\s+(.*?)```',t,re.S)[1]
boon_common=re.search(r'## Bloco comum\s+```text\s+(.*?)```',b,re.S)[1]
jobs=[]
identity='.atena/generated/fila028-ar-se-2026-10-10/native-sources/SE02_v03.png'
approved=json.loads((root/'.atena/generated/fila028-acceptance-2026-10-10/approved-sources.json').read_text(encoding='utf-8'))
assert hashlib.sha256((root/identity).read_bytes()).hexdigest()==next(x['sha256'] for x in approved['entries'] if x['code']=='SE02')
def add(code,item,prompt,refs):
    jobs.append(dict(code=code,item=item,prompt=prompt,references=[dict(path=p,sha256=hashlib.sha256((root/p).read_bytes()).hexdigest(),role=role) for p,role in refs],state='PENDING_SCOPE_APPROVAL',content_state='DRAFT',runtime_admission=False))
props=[('assets/interactions/loja.png','style anchor'),('assets/interactions/doacao.png','style anchor')]
se03=re.search(r'### SE03\s.*?```text\s+(.*?)```',t,re.S)[1]
se03=re.sub(r'\[Bloco comum[^\]]*\]','',se03).strip()
add('SE03','camara_aberta',common.replace('fundo liso magenta #FF00FF (ciano #00FFFF se o objeto tiver roxo)','fundo liso ciano #00FFFF')+'\n'+se03+'\nReference 3 is the approved chamber identity. Preserve its camera, stone silhouette, scale and palette. Exactly three broken seals on the floor, no intact seals on door. No banners or new ornament. Request square native high resolution.',props+[(identity,'approved identity authority')])
for code,item,phase,request in re.findall(r'\| (SE\d{2}) \| `([^`]+)` \| ([^|]+) \| (.*?) \|',t):
    if int(code[2:])<4:continue
    request=request.replace('**','')
    add(code,item,common.replace('fundo liso magenta #FF00FF (ciano #00FFFF se o objeto tiver roxo)','fundo liso ciano #00FFFF')+'\nPrimary request: '+request+'\nCompact isolated ruin prop for '+phase.strip()+', not a panoramic scene. No characters, no readable text, no insignia. Entire composition centered with clear empty padding. Request square native high resolution.',props)
for code,item in [('I01','lliira_juramento'),('I02','tou_um_caminho')]:
    request=re.search(r'\*\*'+code+r'\*\*.*?Pedido: (.*)',b)[1]
    refs=[('assets/icons/boons/lliira_alegria.png','deity family anchor'),('assets/icons/boons/lliira_sorte.png','deity family anchor')] if code=='I01' else [('assets/icons/boons/tou_um_estrela.png','deity family anchor')]
    add(code,item,boon_common+'\nPrimary request: '+request+'\nRequest square native 1024x1024, genuine alpha background, entire symbol with at least 18 percent clear padding. Preserve family form and palette from references.',refs)
assert len(jobs)==11
manifest=dict(plan='PLAN-053/SPEC-121',revision='FILA-028-REMAINING/v01',approval_mode='per-plan',scope_approval='PENDING',sources=[dict(path=str(p.relative_to(root)),sha256=hashlib.sha256(p.read_bytes()).hexdigest()) for p in [p61,p59]],jobs=jobs)
(base/'jobs.json').write_text(json.dumps(manifest,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
print('11 pending jobs prepared; all reference hashes and approved SE02 identity verified.')
