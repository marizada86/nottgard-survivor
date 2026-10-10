from pathlib import Path
import hashlib,json,re
base=Path(__file__).parent;root=base.parents[2]
source=root/'.atena/generated/ART-PROMPTS-061-eventos-arcanista-icones-segredos-e-altar.md'
text=source.read_text(encoding='utf-8')
common=re.search(r'## Bloco comum — props e personagens de evento\s+```text\s+(.*?)```',text,re.S)[1]
jobs=[]
for code,item in [('AR01','arcanista'),('SE01','eco'),('SE02','camara_selada')]:
    section=re.search(r'### '+code+r'\s.*?```text\s+(.*?)```',text,re.S)[1]
    section=re.sub(r'\[Bloco comum[^\]]*\]', '',section).strip()
    prompt=common.replace('fundo liso magenta #FF00FF (ciano #00FFFF se o objeto tiver roxo)','fundo liso ciano #00FFFF')+'\n'+section+'\nRequest square native 1024x1024. Entire isolated subject centered with empty padding. Keep cyan background perfectly flat and uniform; no gradient, no scenery. No readable glyphs. References 1 and 2 are style anchors only.'
    refs=['assets/interactions/loja.png','assets/interactions/doacao.png']
    if code=='AR01':
        refs.append('assets/interactions/curandeiro.png');prompt+=' Reference 3 is the healer: make the Arcanist clearly different, purple robe, closed book and a raised palm with violet wisp; do not copy the healer stall or cauldron.'
    jobs.append(dict(code=code,item=item,prompt=prompt,references=[dict(path=p,sha256=hashlib.sha256((root/p).read_bytes()).hexdigest(),role='style anchor' if i<2 else 'differentiation reference') for i,p in enumerate(refs)],state='APPROVED_PENDING_GENERATION',content_state='DRAFT',runtime_admission=False))
manifest=dict(plan='PLAN-053/SPEC-121',revision='FILA-028-AR-SE/v01',scope_approval='APPROVED',approval_mode='per-plan',owner_reply='Aprovo esse plano',tool='built-in imagegen',source_prompt_file=str(source.relative_to(root)),source_prompt_sha256=hashlib.sha256(source.read_bytes()).hexdigest(),jobs=jobs)
(base/'jobs.json').write_text(json.dumps(manifest,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
print('3 approved jobs prepared, references hashed.')
