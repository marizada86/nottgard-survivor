from pathlib import Path
import json,re,hashlib
root=Path.cwd();base=root/'.atena/generated/erik-arlindo-complete-2026-10-09'
data=json.loads((base/'jobs.json').read_text(encoding='utf-8'))
assert data['generated']==16 and data['remaining']==0
assert all((root/j['destination']).is_file() for j in data['jobs'])
assert all(hashlib.sha256((root/j['destination']).read_bytes()).hexdigest()==j['sha256'] for j in data['jobs'])
source=root/'.atena/generated/art045-priority-review/v01/CHATGPT-FILA-027-erik-e-arlindo.md'
queue=source.read_text(encoding='utf-8').replace('nenhuma peça gerada; aguardando o dono enviar ao ChatGPT','20 peças nativas geradas; revisão visual e normalização pendentes')
queue=re.sub(r'- \[ \] gerada · \[ \] aprovada — (ER\d\d|AO\d\d)',lambda m:'- [x] gerada · ['+('x' if m[1] in ('ER01','ER02','AO01') else ' ')+'] aprovada — '+m[1],queue)
queue+='\n\n## Continuação local DEV-024 v03\n\nSnapshot de origem preservado em `art045-priority-review/v01`; esta cópia registra os fatos atuais. Aprovação visual anterior: ER01, ER02 e AO01. AO02 foi usado como referência DRAFT experimental. Nenhuma nova peça foi admitida no runtime.\n\n[Galeria de revisão](erik-arlindo-complete-2026-10-09/index.html).\n\n'
for j in data['jobs']:queue+=f'- {j["code"]}: [{Path(j["destination"]).name}]({j["destination"].removeprefix(".atena/generated/")}) — '+', '.join(j['technical_flags']+j.get('visual_flags',[]))+'\n'
(root/'.atena/generated/CHATGPT-FILA-027-erik-e-arlindo.md').write_text(queue,encoding='utf-8')
gallery='.atena/generated/erik-arlindo-complete-2026-10-09/index.html'
for path in [root/'.atena/state/plan.yaml',root/'.atena/state/plan-053-imagens.yaml']:
    text=path.read_text(encoding='utf-8').replace('DEV-024/S-006/ER03','DEV-024/REVIEW-20')
    text=text.replace('FILA02360/60 geradas; quatro pilotos ART045 gerados; revisao e normalizacao pendentes.','FILA02360/60 e FILA02720/20 nativas geradas; revisao e normalizacao pendentes.')
    text=text.replace('Revisar galeria64; normalizar grade/pivo; admissao runtime depende do aceite.','Revisar galeria20 Erik/Arlindo e galeria60 VFX; corrigir alertas e normalizar grade/pivo antes da admissao.')
    text=text.replace('status: EXECUTING\n','status: NATIVE_GENERATION_COMPLETE_REVIEW_PENDING\n')
    path.write_text(text,encoding='utf-8')
path=root/'.atena/state/dev-024-art045-pilots.yaml';text=path.read_text(encoding='utf-8')
text=text.replace('status: EXECUTING_FULL_HERO_DRAFT_SCOPE','status: NATIVE_GENERATION_COMPLETE_REVIEW_PENDING').replace('checkpoint: S-006/ER03','checkpoint: REVIEW-20')
text=text.replace('return_checkpoint: S-007/VFX/FILA-023/H-REMAINING','return_checkpoint: S-007/VFX/FILA-023/REVIEW-60')
steps=''.join('  - {id: S-'+str(index+6).zfill(3)+', task: '+job['code']+', status: GENERATED_AUDITED_PENDING_REVIEW}\n' for index,job in enumerate(data['jobs']))
text=text.replace('runtime_admission: false\ncontent_state: DRAFT',steps+'runtime_admission: false\ncontent_state: DRAFT',1)
text=text.replace('task: ER02 idle, status: GENERATED_AUDITED_PENDING_ACCEPTANCE','task: ER02 idle, status: APPROVED_BY_OWNER')
text+='\ncompletion_review:\n  native_pieces: 20\n  newly_generated_strips: 16\n  gallery: '+gallery+'\n  audit: .atena/generated/erik-arlindo-complete-2026-10-09/review-audit.json\n  human_review: PENDING\n  grid_and_pivot_normalization: PENDING\n  runtime_admission: false\n'
path.write_text(text,encoding='utf-8')
report={ 'native_count':20,'new_strips':16,'correction_candidates':sum(len(j.get('rejected_versions',[])) for j in data['jobs']), 'hashes_verified':16,'native_alpha_verified':all(j['alpha_extrema'][0]==0 for j in data['jobs']),'exact_grid_passed':sum('DIMENSION_MISMATCH' not in j['technical_flags'] for j in data['jobs']),'runtime_admission':False,'human_review':'PENDING','planned_godot_checks':'NOT_RUN: engine not found at configured D:/Godot/godot.exe; audit_strip_edges.gd absent; runtime motion audit requires admitted strips','recovery':'Previous originals and every retry retained; official manifest and runtime untouched'}
(base/'completion.json').write_text(json.dumps(report,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
evidence='''# Erik e Arlindo — produção DEV-024 v03, 2026-10-09

Pedido do dono: continuar os assets e finalizar as peças faltantes de Erik e Arlindo. Escopo registrado em scope-extension-v03.json, com execução DRAFT por plano e revisão humana adiada conforme autorização existente.

Geradas as 16 tiras faltantes: cinco direções, ataque, habilidade e morte por herói. Somadas aos quatro pilotos anteriores, são 20 peças nativas presentes. Versões anteriores e originais do gerador preservados; hashes e alfa registrados em jobs.json. As sete novas versões de correção não constituem aprovação do dono.

Galeria: .atena/generated/erik-arlindo-complete-2026-10-09/index.html. Prévias GIF são divisões uniformes provisórias, somente para revisão; não substituem o empacotamento final. Todas as tiras ainda precisam da grade 256x384, normalização de corpo/baseline/pivô e revisão dos alertas de borda, mão e ciclo de caminhada. Dimensões nativas não satisfazem o contrato final, portanto nenhum arquivo foi admitido no jogo.

Verificação: 20 arquivos presentes; 16 hashes novos conferidos; alfa transparente real nos 16 novos; links da galeria conferidos. Checks Godot planejados não executados: executável configurado indisponível e audit_strip_edges.gd ausente neste checkout. Auditoria Pillow é leitura de candidatos, não substitui a validação de movimento no runtime.

ER01, ER02 e AO01 mantêm aprovação visual anterior. AO02 e novas tiras permanecem DRAFT. Manifesto oficial e arquivos de runtime preservados. Novo commit/push não solicitado neste checkpoint. Retorno PLAN-053/FILA-023/REVIEW-60 preservado.
'''
(root/'.atena/evidence/erik-arlindo-complete-2026-10-09.md').write_text(evidence,encoding='utf-8')
print(json.dumps(report))
