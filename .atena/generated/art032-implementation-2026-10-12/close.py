"""Reconcile only the approved implementation records and its backlog facts."""
from pathlib import Path
import json
import re

OUT = Path(__file__).resolve().parent
ROOT = OUT.parents[2]
audit = json.loads((OUT / 'delivery-verification.json').read_text(encoding='utf-8'))
assert audit['status'] == 'PASS' and audit['runtime_admitted'] == 17 and audit['test_failures'] == 0
manifest = json.loads((OUT / 'manifest.json').read_text(encoding='utf-8'))
assert manifest['completed_steps'] == 5 and manifest['current_step_position'] == 6
evidence = ROOT / '.atena/evidence/art032-implementation-2026-10-12.md'
evidence.write_text('''# ART-032 — implementação local, 2026-10-12

[PLAN-ART032-IMPLEMENT/v01](../vault/drafts/PLAN-ART032-IMPLEMENT-v01.md) concluído tecnicamente, **6/6**. Contrato preparado antes da execução. A resposta **“pode implementar”** confirma preparação, admissão e integração local das dezessete fontes aceitas ART-032; modalidade per-plan preservada. Uso runtime DRAFT autorizado; sem promoção a CANON, commit, push ou exportação.

## Resultados por passo

| Passo | Resultado e evidência |
|---|---|
| S-001 | Contrato, referências/revisões, identidade/contextos e backups registrados antes da mudança. Dezessete fontes selecionadas, vinte e sete nativas históricas e quatro recibos preservados. [Manifesto](../generated/art032-implementation-2026-10-12/manifest.json), [snapshot](../generated/art032-implementation-2026-10-12/protected-snapshot.json). |
| S-002 | Godot 4.7.2: dezessete derivados RGBA, recorte proporcional Lanczos, alfa residual <=8/255 limpo apenas no derivado, quatro px transparentes em cada lado. Altura visível 240 px NPCs/props/chefe e 96 px estrela/coletáveis; fontes byte a byte iguais. [Auditoria de preparação](../generated/art032-implementation-2026-10-12/preparation-audit.json). |
| S-003 | Dezesseis PNGs em interactions e arte própria da Manifestação de Juiblex. Campos de arte conectados a pontos/itens/drop do elite, escolta, pactos, resgates e recompensas. Duas Irmãs usam Nyxara/Vaelis distintas; Graz'zt e João usam artes próprias. Bbox visível ancora base e mantém proporção: NPCs/props/aliados 80 px; coletáveis/estrela 48 px. Renderer/escala existentes do chefe preservados. Fallbacks e aliados legados preservados. [Admissão DRAFT](../generated/art032-implementation-2026-10-12/admission.json). |
| S-004 | Suíte completa final: **testes: 0 falha(s)**. Teste ART-032 cobre imports, margens, proporção/base, itens/drop, eventos, escolta, duas Irmãs, Graz'zt, legado e comparação do estado RNG/posições com e sem metadados de arte. Definições mecânicas iguais ao backup excluindo somente asset/assets. [Log final](../generated/art032-implementation-2026-10-12/tests-final-log.txt), [auditoria dos dados](../generated/art032-implementation-2026-10-12/data-audit.json). |
| S-005 | Sete capturas 1280×720 em seis biomas, cobrindo dezessete peças: import, proporção/base, contraste e rótulos conferidos nativamente. Corrigida largura dos rótulos longos dos pactos. [Galeria](../generated/art032-implementation-2026-10-12/index.html), [capturas/QA/hashes](../generated/art032-implementation-2026-10-12/capture-qa.json). |
| S-006 | Plano/estado/backlog e registro de admissão reconciliados; cadeia de retorno PLAN-071/revisão de heróis preservada. [Verificação final](../generated/art032-implementation-2026-10-12/delivery-verification.json), [roteiro de playtest](../generated/art032-implementation-2026-10-12/playtest.md). |

## Limites observados e recuperação

A suíte exige acesso aos seus diretórios temporários user://test_*; a execução inicial na sandbox falhou por acesso ao perfil/evidence zip, não por ART-032. A tentativa de redirecionar user-data não criou diretórios: Godot sanitiza o caminho, portanto foi encerrada e não reutilizada. A suíte final executou com a permissão local aprovada pelo auto-review e perfil de controlador isolado no pacote; não substituiu o perfil do jogador. Nenhuma dependência instalada. Logs diagnósticos iniciais foram preservados separadamente.

Zero novas falhas de teste/erros de script ART-032. O log final ainda contém duas mensagens anteriores de abertura de arquivo: idle.png de Arlindo e Erik, vinculadas à frente de heróis pendente. Não declarar log integralmente livre de erros. Aviso do repositório de certificados também permanece no runtime local.

Capturas usam cenas reais de run/overlay/inimigos em SubViewport, posições controladas, simulação congelada e avisos iniciais ocultos apenas na fixture. Não constituem uma partida humana, nem validam diversão/dificuldade. Navegador file:// não foi usado devido ao bloqueio de política já conhecido; imagens foram inspecionadas nativamente e os 75 links locais da galeria verificados.

Auditoria final: **2.966 hashes protegidos iguais**, originais/recibos/backups iguais, dezessete derivados iguais aos destinos admitidos, todas as dezessete imports presentes. HEAD 51b51f7369ae34eede997435e6eb52ea057daf25 e índice vazio preservados. Nenhuma alteração dos outros assets/runtime ou da cauda active_plan; alterações anteriores das outras frentes mantidas. Recuperação por backup local e snapshot dos destinos; não usar reset/limpeza global. Templo-alvo, jaula, canoa e animações não fazem parte das dezessete fontes e seguem pendentes.

Próximo objetivo preparado: playtest humano da integração local, com escopo, procedimento, observações e critérios no roteiro. Avaliação subjetiva **PENDING_NOT_PERFORMED**, não bloqueante para a conclusão técnica. Qualquer CANON, commit, push ou exportação continua com gate próprio e não foi realizado aqui.
''', encoding='utf-8')

plan_path = ROOT / '.atena/vault/drafts/PLAN-ART032-IMPLEMENT-v01.md'
plan = plan_path.read_text(encoding='utf-8').replace('status: APPROVED_IN_PROGRESS', 'status: COMPLETED_TECHNICAL_DRAFT')
old = 'S-001 concluído, 1/6; atual S-002 (2/6), quatro passos depois do atual.'
assert old in plan
plan = plan[:plan.index(old)] + '''S-001–S-006 concluídos, 6/6; zero passos técnicos restantes. Dezessete derivados admitidos e conectados, suíte final zero falhas, sete capturas revisadas em seis biomas. [Resultados/evidência](../../evidence/art032-implementation-2026-10-12.md) e [verificação final](../../generated/art032-implementation-2026-10-12/delivery-verification.json). Pendência não bloqueante: playtest humano; duas ausências anteriores de idle dos heróis registradas, sem nova falha ART-032. Próximo objetivo: executar o roteiro local e recolher feedback humano quando solicitado, sem novo commit/push/exportação autorizado. Conteúdo continua DRAFT com uso runtime autorizado.
'''
plan_path.write_text(plan, encoding='utf-8')
state_path = ROOT / '.atena/state/art032-implementation.yaml'
state = state_path.read_text(encoding='utf-8')
state = re.sub(r'^next_objective:.*$', "next_objective: 'Playtest humano da integração local conforme roteiro; pendente, não realizado'", state, flags=re.M)
state += 'technical_status: PASS\nnew_test_failures: 0\ncaptures: 7\nbiomes: 6\nprotected_hashes_preserved: 2966\ngallery: .atena/generated/art032-implementation-2026-10-12/index.html\nverification: .atena/generated/art032-implementation-2026-10-12/delivery-verification.json\nplaytest_guide: .atena/generated/art032-implementation-2026-10-12/playtest.md\nnext_execution_authorized: false\n'
state_path.write_text(state, encoding='utf-8')

request_path = ROOT / '.atena/state/art032-next-request-2026-10-12.yaml'
request = request_path.read_text(encoding='utf-8').replace('status: RESOLVED_IMPLEMENT_ART032', 'status: IMPLEMENTATION_COMPLETED').replace('checkpoint: IMPLEMENTATION_SCOPE_CONFIRMED', 'checkpoint: IMPLEMENTATION_TECHNICALLY_COMPLETED').replace('next_execution_authorized: true', 'next_execution_authorized: false')
request = re.sub(r'^pending_question:.*$', 'pending_question: null', request, flags=re.M)
request = re.sub(r'^next_objective:.*$', "next_objective: 'Playtest humano pendente; implementação concluída, nenhuma nova imagem solicitada'", request, flags=re.M)
request_path.write_text(request, encoding='utf-8')
root_path = ROOT / '.atena/state/plan.yaml'
before = root_path.read_text(encoding='utf-8')
prefix, preserved = before.split('art032_juiblex_2026_10_12:', 1)
implementation, request_block = prefix.split('art032_next_request_2026_10_12:', 1)
implementation += '  technical_status: PASS\n  human_playtest: PENDING_NOT_PERFORMED\n  captures: 7\n  biomes: 6\n  gallery: .atena/generated/art032-implementation-2026-10-12/index.html\n  next_objective: "Playtest humano conforme roteiro; pendente, não realizado"\n  next_execution_authorized: false\n'
request_block = request_block.replace('status: RESOLVED_IMPLEMENT_ART032', 'status: IMPLEMENTATION_COMPLETED').replace('checkpoint: IMPLEMENTATION_SCOPE_CONFIRMED', 'checkpoint: IMPLEMENTATION_TECHNICALLY_COMPLETED').replace('next_execution_authorized: true', 'next_execution_authorized: false')
root_path.write_text(implementation + 'art032_next_request_2026_10_12:' + request_block + 'art032_juiblex_2026_10_12:' + preserved, encoding='utf-8')
assert root_path.read_text(encoding='utf-8').split('art032_juiblex_2026_10_12:', 1)[1] == preserved

backlog_path = ROOT / '.atena/backlog/ARTE.md'
backlog = backlog_path.read_text(encoding='utf-8')
lines = backlog.splitlines()
for i, line in enumerate(lines):
    if line.startswith('| ART-032 |'):
        line = line.replace('arte própria da Manifestação de Juiblex (hoje usa a do receptáculo). Hoje: figura e losango provisórios', 'arte própria da Manifestação de Juiblex. Dezessete artes estáticas DRAFT integradas localmente em 2026-10-12; animações, templo-alvo, jaula e canoa pendentes')
        line = line.replace('Admissão de ART-032 ainda aberta.', 'Admissão local das dezessete revisões concluída em 2026-10-12, uso runtime DRAFT autorizado: PLAN-ART032-IMPLEMENT/v01 6/6, suíte zero falhas, sete capturas em seis biomas. Sem CANON/commit/push/export; playtest humano pendente. [Implementação](../evidence/art032-implementation-2026-10-12.md).')
        lines[i] = line
        break
else:
    raise AssertionError('ART-032 backlog row missing')
backlog_path.write_text('\n'.join(lines) + '\n', encoding='utf-8')
print('S-006 records reconciled; protected return chain and unrelated backlog rows preserved; ready to mark 6/6.')
