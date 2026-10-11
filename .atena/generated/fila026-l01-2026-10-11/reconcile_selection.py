from pathlib import Path
import json
import hashlib

base = Path(__file__).parent
selection = json.loads((base/'owner-selection.json').read_text(encoding='utf-8'))
audit_path = base/'audit.json'
audit = json.loads(audit_path.read_text(encoding='utf-8'))
assert selection['selected'] == 'v01'
source = base/'sources/L01_v01.png'
assert hashlib.sha256(source.read_bytes()).hexdigest() == '4018e2bbc3ed4b41628e4296e3308d2748ea36050a013e75de48d02ff3feb5c2'
audit.update(owner_selection=selection, revision='L01/v01', content_state='MIXED_CANON_VISUAL_G1_V01_DRAFT_V02', gate='G1_ACCEPTED', selected='v01')
for record in audit['records']:
    accepted = record['revision'] == 'v01'
    record['content_state'] = 'CANON_VISUAL_G1_REFERENCE' if accepted else 'DRAFT_NOT_SELECTED'
    record['checks']['human_style_acceptance'] = 'ACCEPTED_G1' if accepted else 'NOT_SELECTED'
    record['checks']['human_small_size_acceptance'] = 'ACCEPTED_G1' if accepted else 'NOT_SELECTED'
audit_path.write_text(json.dumps(audit, ensure_ascii=False, indent=2)+'\n',encoding='utf-8')
page_path = base/'index.html'
page = page_path.read_text(encoding='utf-8')
page = page.replace('L01 · logo — DRAFT v02','L01 · logo — v01 aceita no G1')
page = page.replace('PLAN-065 · etapa 9/16 · portão G1 pendente. Avalie o tom ouro/ferro/roxo e a leitura das duas palavras na caixa 300×48. A v02 é recomendada; nenhuma versão foi admitida, promovida a CANON, commitada ou publicada.', 'PLAN-065 · G1 aceito: “Aprovo L01 v01”. L01 v01 é CANON visual de referência; v02 continua DRAFT não selecionada. Nenhuma admissão runtime. As demais peças seguem para G2.')
page = page.replace('Legibilidade e gosto visual final aguardam o dono.', 'Estilo e leitura da v01 aceitos pelo dono no G1.')
page = page.replace('L01 v01 · DRAFT','L01 v01 · CANON visual G1').replace('L01 v02 · DRAFT','L01 v02 · DRAFT não selecionada')
page = page.replace('Histórica: mais alta, linha inferior menor','Escolhida pelo dono — referência para a FILA-026').replace('Recomendada para G1','Recomendação histórica; dono escolheu v01')
page = page.replace('Após G1: L03 Vitória!, seguindo a ordem aprovada.', 'G1 concluído: geração das demais peças liberada, começando por L03 Vitória!.')
page_path.write_text(page,encoding='utf-8')
print(json.dumps(dict(gate='G1_ACCEPTED',selected='v01',runtime_admission=False)))
