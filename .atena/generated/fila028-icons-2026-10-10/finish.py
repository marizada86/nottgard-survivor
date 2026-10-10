from pathlib import Path
import json, html, hashlib, re
base=Path(__file__).parent; root=base.parents[2]
jobs=json.loads((base/'jobs.json').read_text(encoding='utf-8'))
geometry=json.loads((base/'geometry-audit.json').read_text(encoding='utf-8'))['reports']
versions=['v01','v02','v02','v02','v03','v01','v01','v02','v02','v01','v01','v02','v02']
notes={'IC03':'Margem 14,99%; passa apenas com tolerância explícita de um pixel. Critério nominal não atingido.', 'IC04':'RESSALVA: v02 com margem 14,51%, abaixo de 15%. v03 rejeitada por névoa acrescentada. Três tentativas esgotadas; exceção não aprovada.', 'IC05':'v03 separa três partes grandes; confirmar leitura dessa separação a 48 px.', 'IC09':'Confirmar as três pontas do pingente e distinguir conectores superiores.'}
selected=[]; cards=[]
for job,version in zip(jobs['jobs'],versions):
    code=job['code']; name=f'{code}_{version}'; receipt=json.loads((base/'receipts'/f'{name}.json').read_text(encoding='utf-8'))
    report=next(r for r in geometry if r['code']==code and r['version']==version)
    for ref in job['references']:
        assert hashlib.sha256((root/ref['path']).read_bytes()).hexdigest()==ref['sha256']
    for ref in receipt.get('actual_references',[]): assert Path(ref).is_file()
    file=f'native-sources/{name}.png'; assert (base/file).is_file()
    entry=dict(code=code,item=job['item'],version=version,file=file,geometry=report,note=notes.get(code,''),human_approval=False,content_state='DRAFT')
    selected.append(entry)
    job.update(state='GENERATED_PENDING_VISUAL_ACCEPTANCE',selected_version=version,selected_source=receipt['destination'],scope_approval='APPROVED')
    e=html.escape
    cards.append(f'<article><h2>{code} · {e(job["item"])}</h2><p>DRAFT {version} · {report["size"][0]}×{report["size"][1]} · margem {report["margin_fraction"]*100:.2f}%</p><a href="{file}"><img class="large" src="{file}" alt="{e(job["item"])}"></a><div class="sizes"><figure><img width="128" height="128" src="{file}" alt="Prévia 128 px"><figcaption>128 px</figcaption></figure><figure><img width="48" height="48" src="{file}" alt="Prévia 48 px"><figcaption>48 px</figcaption></figure></div><p class="note">{e(entry["note"])}</p><p><a href="receipts/{name}.json">Prompt exato e referências</a></p><details><summary>Histórico de versões</summary>'+''.join(f'<a href="native-sources/{p.stem}.png">{p.stem}</a> ' for p in sorted((base/'receipts').glob(f'{code}_*.json')))+ '</details></article>')
jobs.update(scope_approval='APPROVED',status='GENERATED_AUDITED_AWAITING_OWNER_REVIEW',completed_steps=14)
(base/'jobs.json').write_text(json.dumps(jobs,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
audit=dict(revision='FILA-028-IC/v01',content_state='DRAFT',tool='built-in imagegen',selected=selected,versions=len(geometry),native_alpha_pass=all(r['native_alpha_pass'] for r in geometry),selected_margin_pass=sum(s['geometry']['margin_pass'] for s in selected),reference_hashes_pass=True,source_copy_hashes_pass=True,visual_review='PENDING_OWNER',runtime_admission=False,exception_approval=False,rejected_versions={'IC04_v03':'Unrequested gray fog/background around composition'},pending=['IC04 margin exception or future correction scope','IC03 one-pixel tolerance review','Artistic acceptance and 48px readability for all icons','Native square dimensions vary; final 128px export deferred'])
(base/'audit.json').write_text(json.dumps(audit,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
page='<!doctype html><html lang="pt-BR"><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>FILA-028 · 13 ícones DRAFT</title><style>body{background:#10121a;color:#e8e5db;font:16px system-ui;margin:32px}a{color:#bdcdfd}header{max-width:1000px}main{display:grid;grid-template-columns:repeat(auto-fit,minmax(300px,1fr));gap:24px}article{background:#1c202c;border:1px solid #454959;border-radius:12px;padding:18px}h2{font-size:18px}img{object-fit:contain;image-rendering:pixelated;background:repeating-conic-gradient(#353945 0% 25%,#252935 0% 50%) 50%/16px 16px}.large{width:100%;height:280px}.sizes{display:flex;align-items:center;gap:24px}figure{margin:12px 0}figcaption{font-size:13px}.note{color:#ffd394}details{line-height:1.8}</style><header><h1>FILA-028 · IC01–IC13</h1><p>DRAFT · revisão v01 · geração e auditoria concluídas; aceite visual pendente.</p><p>Compare identidade, consistência de família e leitura a 48 px. As prévias usam a fonte inteira, sem recorte ou exportação final. Clique na imagem para abrir o PNG nativo.</p><p>IC04 v02 tem margem insuficiente (14,51%); a v03 foi rejeitada por névoa. IC03 usa tolerância de um pixel. Nenhuma exceção foi aprovada.</p><p><a href="audit.json">Auditoria da seleção</a> · <a href="geometry-audit.json">Todas as versões</a> · <a href="jobs.json">Plano e prompts originais</a></p></header><main>'+''.join(cards)+'</main></html>'
(base/'index.html').write_text(page,encoding='utf-8')
links=re.findall(r'(?:href|src)="([^"]+)"',page)
assert all((base/p).is_file() for p in links)
assert len(selected)==13 and len(cards)==13 and audit['selected_margin_pass']==12
print(f'{len(selected)} candidates; {len(geometry)} native versions; {len(links)} local links verified; 12 margin passes, 1 unresolved exception.')
