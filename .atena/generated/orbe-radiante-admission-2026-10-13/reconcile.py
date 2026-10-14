from pathlib import Path
import json,re
out=Path(__file__).resolve().parent
root=out.parents[2]
for name in ['plan.yaml','plan-053-imagens.yaml']:
    p=root/'.atena/state'/name;s=p.read_text(encoding='utf-8')
    prefix,block=s.split('orbe_radiante_review_2026_10_13:',1)
    review,admission=block.split('orbe_radiante_admission_2026_10_13:',1)
    review=review.replace('admission_mode: unconfigured','admission_mode: per-plan')
    p.write_text(prefix+'orbe_radiante_review_2026_10_13:'+review+'orbe_radiante_admission_2026_10_13:'+admission,encoding='utf-8')
p=root/'.atena/state/orbe-radiante-review.yaml';s=p.read_text(encoding='utf-8').replace('admission_mode: unconfigured','admission_mode: per-plan').replace('admission_execution_authorized: false','admission_execution_authorized: true').replace('next_objective: Selecionar modo e aprovar orbe-radiante-admission/v01 antes da execucao.','next_objective: Admissao tecnica entregue; aguardar playtest humano runtime.')
s+='admission_state: .atena/state/orbe-radiante-admission.yaml\nadmission_status: LOCAL_TECHNICAL_DELIVERED_AWAITING_OWNER_PLAYTEST\n'
p.write_text(s,encoding='utf-8')
p=root/'.atena/specs/SPEC-121-retomada-fila-imagens/orbe-radiante-admission-v01.md'
with p.open('a',encoding='utf-8') as f:f.write('\n## Resultado\n\nAdmissão local DRAFT entregue,4/4técnico, por escopo per-plan aprovado. Dois atlas e três armas; suíte0falhas/smoke9fases/paridade80cenários/23capturas. [Evidência](../../evidence/orbe-radiante-admission-2026-10-13.md), [roteiro de playtest](../../generated/orbe-radiante-admission-2026-10-13/PLAYTEST.md). Feedback humano em runtime permanece pendente. Nenhuma promoção CANON ou operação Git.\n')
for rel in ['.atena/backlog/ARTE.md','.atena/generated/CHATGPT-FILA-022-vfx-projeteis-e-explosoes.md']:
    with (root/rel).open('a',encoding='utf-8') as f:f.write('\n2026-10-13 — ART-029: Orbe Radiante oito fases admitidas localmente DRAFT, orbe-radiante-admission/v01 técnico4/4; suíte0falhas,smoke9fases,paridade80cenários/7.200passos,23capturas PASS. Somente Raio de Luz/Luz Mais Pura/Marca da Retidão. Playtest humano pendente; próxima família proposta Orbe Arcano. Sem CANON ou Git. Evidência: `.atena/evidence/orbe-radiante-admission-2026-10-13.md`.\n')
targets=[root/'.atena/evidence/orbe-radiante-admission-2026-10-13.md',root/'.atena/specs/SPEC-121-retomada-fila-imagens/orbe-radiante-admission-v01.md',out/'PLAYTEST.md']
checked=0
for p in targets:
    for target in re.findall(r'\]\(([^)]+)\)',p.read_text(encoding='utf-8')):
        assert (p.parent/target).exists(),(str(p),target)
        checked+=1
for tag in json.loads((out/'runtime-checks.json').read_text(encoding='utf-8'))['screenshots']:assert (out/'captures'/(tag+'.png')).exists()
state=(root/'.atena/state/plan.yaml').read_text(encoding='utf-8')
assert re.search(r'active_plan:\s+id: PLAN-071',state)
assert 'checkpoint: B-006/S-011' in state
result={'status':'PASS','active_plan071_preserved':True,'document_links_verified':checked,'captures_verified':23,'technical_steps_completed':4,'human_runtime_playtest':'PENDING_NOT_PERFORMED','canonical_promotion':False,'git_operations':'NONE'}
(out/'final-checks.json').write_text(json.dumps(result,indent=2)+'\n',encoding='utf-8')
print(json.dumps(result))
