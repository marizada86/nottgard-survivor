from pathlib import Path
import json,re
out=Path(__file__).resolve().parent
root=out.parents[2]
p=root/'.atena/state/orbe-arcano-review.yaml'
s=p.read_text(encoding='utf-8').replace('admission_mode: unconfigured','admission_mode: per-plan').replace('admission_execution_authorized: false','admission_execution_authorized: true').replace('next_objective: Selecionar modo e aprovar orbe-arcano-admission/v01 antes da execucao.','next_objective: Admissao tecnica entregue; aguardar playtest humano runtime.')
s+='admission_state: .atena/state/orbe-arcano-admission.yaml\nadmission_status: LOCAL_TECHNICAL_DELIVERED_AWAITING_OWNER_PLAYTEST\n'
p.write_text(s,encoding='utf-8')
p=root/'.atena/specs/SPEC-121-retomada-fila-imagens/orbe-arcano-admission-v01.md'
with p.open('a',encoding='utf-8') as f:f.write('\n## Resultado\n\nAdmissão local DRAFT entregue,4/4técnico no escopo per-plan aprovado. Dois atlas/três armas; suíte0falhas/smoke9fases,24capturas Arcano/misto+23de regressão Radiante. Battle/data/run/overlay e recursos radiantes intactos por hash; só a camada compartilhada mudou entre arquivos runtime preexistentes. [Evidência](../../evidence/orbe-arcano-admission-2026-10-13.md), [roteiro/atalhos](../../generated/orbe-arcano-admission-2026-10-13/PLAYTEST.md). Feedback humano runtime pendente; sem CANON ou Git.\n')
for rel in ['.atena/backlog/ARTE.md','.atena/generated/CHATGPT-FILA-022-vfx-projeteis-e-explosoes.md']:
    with (root/rel).open('a',encoding='utf-8') as f:f.write('\n2026-10-13 — ART-029: Orbe Arcano oito fases admitidas localmente DRAFT, orbe-arcano-admission/v01 técnico4/4. Suíte0falhas/smoke9fases,24capturas Arcano/misto+23regressão Radiante PASS. Só Raio Enfraquecedor/Dominar Pessoa/Cajado dos Desejos; Battle/data intactos. Playtest humano pendente; próxima família proposta Onda Cortante. Sem CANON/Git. Evidência: `.atena/evidence/orbe-arcano-admission-2026-10-13.md`.\n')
p=out/'packing.json';packing=json.loads(p.read_text(encoding='utf-8'));packing['canvas_center']=packing.pop('pivot');packing['runtime_pivots']={'flight':[135,128],'impact':[128.5,124]};packing['calibration']='Fixed measured annulus origin per animation; see derivative-audit.json; native pixels unchanged.';p.write_text(json.dumps(packing,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=out/'prepare.gd';s=p.read_text(encoding='utf-8').replace('"pivot": [128,128]','"canvas_center": [128,128]');p.write_text(s,encoding='utf-8')
for rel in ['audit.py','derivative-audit.json']:
    p=out/rel;s=p.read_text(encoding='utf-8').replace('p08_residue_preserved','q08_residue_preserved');p.write_text(s,encoding='utf-8')
targets=[root/'.atena/evidence/orbe-arcano-admission-2026-10-13.md',root/'.atena/specs/SPEC-121-retomada-fila-imagens/orbe-arcano-admission-v01.md',out/'PLAYTEST.md']
checked=0
for p in targets:
    for target in re.findall(r'\]\(([^)]+)\)',p.read_text(encoding='utf-8')):
        assert (p.parent/target).exists(),(str(p),target)
        checked+=1
page=(out/'index.html').read_text(encoding='utf-8')
gallery_links=re.findall(r'(?:src|href)="([^"]+)"',page)
assert all((out/link).exists() for link in gallery_links)
central=(root/'.atena/state/plan.yaml').read_text(encoding='utf-8')
assert re.search(r'active_plan:\s+id: PLAN-071',central) and 'checkpoint: B-006/S-011' in central
result={'status':'PASS','document_links_verified':checked,'gallery_links_verified':len(gallery_links),'captures':47,'technical_steps_completed':4,'active_plan071_preserved':True,'human_playtest':'PENDING_NOT_PERFORMED','canonical_promotion':False,'git_operations':'NONE'}
(out/'final-checks.json').write_text(json.dumps(result,indent=2)+'\n',encoding='utf-8')
print(json.dumps(result))
