from pathlib import Path
import json,re
out=Path(__file__).resolve().parent
root=out.parents[2]
v=json.loads((out/'verification.json').read_text(encoding='utf-8'))
parity=json.loads((out/'parity.json').read_text(encoding='utf-8'))
evidence=f'''# Onda Cortante admission/v01 — evidência técnica local

Estado DRAFT, PLAN-053/SPEC-121, execução per-plan explicitamente aprovada antes da transformação/integração. Técnico 4/4 concluído. Build `{v['build_id']}`. PLAN-071/B-006/S-011 preservado. Sem CANON, Git, exportação ou publicação.

[Autorização e oito hashes](../generated/onda-cortante-admission-2026-10-13/authorization.json), [aceite visual](../generated/onda-cortante-review-2026-10-13/visual-acceptance.json), [contrato](../specs/SPEC-121-retomada-fila-imagens/onda-cortante-admission-v01.md). R01v02/R05v02 e seis demais v01 preservados. Identidade de personagem N/A, VFX abstrato conforme bíblia/revisão vinculada na spec; sem nova direção artística.

S-001: Godot normalizou oito RGB1254 para cópias1024 e atlas diretos com quatro células256 por animação. BrancoRGB/alfa luminânciaRec709; piso<=2/255 somente em derivados. Fontes intactas, bordas transparentes, resíduosR08 e pontas/raios preservados. Pivô fixo de voo(137,5;127), escala18/112; R01 maior componente brilhante8conectado fornece origem geométrica e altura112. Impacto(128;128), escala12/40, raio principalR06 por mediana radial. Nenhum ajuste por quadro. [Auditoria](../generated/onda-cortante-admission-2026-10-13/derivative-audit.json), [packing](../generated/onda-cortante-admission-2026-10-13/packing.json).

S-002: dois atlas, helperCuttingWaveVfx e terceira seleção na camada compartilhada. Somente herói/bolt/magico/Lâmina Trovejante ou Tempestade. Reusa cache/projeção/cadência, snapshot de cores, altura16, impacto0,24s e teto32 compartilhado. Fallback procedural e reduzido mantidos. Dos {v['protected_preexisting_files']} arquivos runtime preexistentes protegidos, somente ui/radiant_orb_layer.gd mudou; Battle/data/run/overlay, dois orbes, Pulso/Ampulheta e testes anteriores iguais por hash.

S-003: teste focado0falhas, suíte0falhas e smoke9fases. Capturas automáticas:22 Onda/três famílias,24 regressão Arcano,23 Radiante =69. Verificados disparos/hits reais das duas armas, oito direções, quatro fases de voo/retorno e impacto, quatro projéteisTempestade, tintasLliira/TouUm, orçamento32trêsfamílias, pausa/expiração/limpeza, independência de números de dano, textura ausente/reduzido e secundários excluídos; Pulso/Ampulheta roteados intactos. Imagens inspecionadas: oito direções, quatro tiros, pico e cena mista. [Galeria](../generated/onda-cortante-admission-2026-10-13/index.html).

Paridade contra Battle anterior à admissão: {parity['counts']['scenarios']} cenários/{parity['counts']['steps']} passos, {parity['counts']['hit']}hits/{parity['counts']['miss']}misses/{parity['counts']['crit']}críticos e {parity['counts']['piercing_contacts']} observações de contatos múltiplos; RNG, trajetória, perfuração, HP/dano/status/eventos idênticos exceto campos weapon/kind já admitidos antes deste plano. [Relatório](../generated/onda-cortante-admission-2026-10-13/parity.json). Assertivas/compilação sem erros nos logs finais. Tentativa inicial de smoke usou --script inadequadamente; corrigida para smoke.tscn, somente execução final conta. Avisos conhecidos: certificado do sistema indisponível no sandbox, carregamento Image em teste antigo e recursos de teardown da suíte/saída antecipada dos atalhos; não são prova de playtest humano ou exportação.

S-004: cinco atalhos com APPDATA/perfil QA isolados, executados15quadros headless cada; roteiro preparado antes do playtest humano. [Verificação](../generated/onda-cortante-admission-2026-10-13/verification.json), [roteiro](../generated/onda-cortante-admission-2026-10-13/PLAYTEST.md). Próximo objetivo: dono avaliar crescente/pontas/raios, estabilidade/perfuração, conforto e ritmo nas duas armas, reduzido/cor alternativa e três famílias juntas. Entradas: build/roteiro/atalhos; saída: feedback arma/modo/cor/direção. Autorização da integração concluída; aceite subjetivo em runtime PENDENTE_NÃO_REALIZADO. Não inferir diversão de métricas. Playtests anteriores sem procedimento relatado permanecem assim. Depois, conferir fila existente antes de propor próxima admissão.
'''
(root/'.atena/evidence/onda-cortante-admission-2026-10-13.md').write_text(evidence,encoding='utf-8')
p=root/'.atena/state/onda-cortante-review.yaml';s=p.read_text(encoding='utf-8').replace('admission_mode: unconfigured','admission_mode: per-plan').replace('admission_execution_authorized: false','admission_execution_authorized: true');s=re.sub(r'next_objective:.*','next_objective: Admissao tecnica entregue; aguardar playtest humano runtime.',s);s+='admission_state: .atena/state/onda-cortante-admission.yaml\nadmission_status: LOCAL_TECHNICAL_DELIVERED_AWAITING_OWNER_PLAYTEST\n';p.write_text(s,encoding='utf-8')
p=root/'.atena/specs/SPEC-121-retomada-fila-imagens/onda-cortante-admission-v01.md'
with p.open('a',encoding='utf-8') as f:f.write('\n## Resultado\n\nAdmissão DRAFT local técnica4/4 entregue no escopo per-plan aprovado: duas armas/dois atlas, suíte0falhas/smoke9fases,69capturas e paridade32cenários/2880passos PASS. Somente camada compartilhada mudou dentre runtime preexistente; fontes e demais famílias intactas por hash. [Evidência](../../evidence/onda-cortante-admission-2026-10-13.md), [roteiro](../../generated/onda-cortante-admission-2026-10-13/PLAYTEST.md). Feedback humano runtime pendente; sem CANON/Git/exportação.\n')
for rel in ['.atena/backlog/ARTE.md','.atena/generated/CHATGPT-FILA-022-vfx-projeteis-e-explosoes.md']:
 with (root/rel).open('a',encoding='utf-8') as f:f.write('\n2026-10-13 — ART-029: Onda Cortante oito fontes aceitas (R01v02/R05v02 e demaisv01) admitidas localmente DRAFT, onda-cortante-admission/v01 técnico4/4. Só Lâmina Trovejante/Tempestade; suíte0/smoke9,69capturas e paridade32cenários PASS. Battle/data e dois orbes/Pulso/Ampulheta preservados. Playtest humano pendente; sem fechar subjetivamente toda FILA022, sem CANON/Git/exportação. Evidência: `.atena/evidence/onda-cortante-admission-2026-10-13.md`.\n')
p=out/'packing.json';a=json.loads(p.read_text(encoding='utf-8'));a['canvas_center']=a.pop('pivot');a['runtime_pivots']={'flight':[137.5,127],'impact':[128,128]};a['calibration']='Fixed geometry per animation; derivative-audit.json; native pixels unchanged.';p.write_text(json.dumps(a,indent=2)+'\n',encoding='utf-8')
for name in ['audit.py','derivative-audit.json']:
 p=out/name;p.write_text(p.read_text(encoding='utf-8').replace('Q/RGB-derived','RGB-derived'),encoding='utf-8')
p=out/'prepare.gd';p.write_text(p.read_text(encoding='utf-8').replace('"pivot": [128,128]','"canvas_center": [128,128]'),encoding='utf-8')
targets=[root/'.atena/evidence/onda-cortante-admission-2026-10-13.md',root/'.atena/specs/SPEC-121-retomada-fila-imagens/onda-cortante-admission-v01.md',out/'PLAYTEST.md'];checked=0
for p in targets:
 for target in re.findall(r'\]\(([^)]+)\)',p.read_text(encoding='utf-8')):
  assert (p.parent/target).exists(),(p,target)
  checked+=1
links=re.findall(r'(?:src|href)="([^"]+)"',(out/'index.html').read_text(encoding='utf-8'))
assert all((out/link).exists() for link in links)
central=(root/'.atena/state/plan.yaml').read_text(encoding='utf-8')
assert re.search(r'active_plan:\s+id: PLAN-071',central) and 'checkpoint: B-006/S-011' in central
result={'status':'PASS','document_links_verified':checked,'gallery_links_verified':len(links),'captures':69,'technical_steps_completed':4,'active_plan071_preserved':True,'human_playtest':'PENDING_NOT_PERFORMED','canonical_promotion':False,'git_operations':'NONE'}
(out/'final-checks.json').write_text(json.dumps(result,indent=2)+'\n',encoding='utf-8')
print(json.dumps(result))
