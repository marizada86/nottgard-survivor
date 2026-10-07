from pathlib import Path
import hashlib
import json
import shutil

root = Path(__file__).resolve().parents[4]
out = Path(__file__).resolve().parent
ws = root / '.atena'
evidence_name = 'EVID-185-quartel-botao-jogar-2026-10-06.md'
for name, count in [('menu-start-report.json', 21), ('integration-report.json', 90)]:
    report = json.loads((out / name).read_text(encoding='utf-8'))
    assert len(report['checks']) == count and not report['failures']
assert 'testes: 0 falha(s)' in (out / 'suite.log').read_text(encoding='utf-8')
mobile = root / '.atena/generated/mobile-controls/v02/buttons-report.json'
report = json.loads(mobile.read_text(encoding='utf-8'))
assert len(report['checks']) == 144 and not report['failures']
shutil.copy2(mobile, out / 'mobile-buttons-report.json')
# Restaurar exatamente o relatorio anterior preservado antes desta regressao.
shutil.copy2(out / 'recovery/mobile-buttons-report.json', mobile)

launcher = (out.parent / 'v01/Abrir-teste-Xbox.cmd').read_text(encoding='utf-8')
launcher = launcher.replace(r'v01\pilot.log', r'v02\pilot.log')
(out / 'Abrir-teste-Xbox.cmd').write_text(launcher, encoding='utf-8')
guide = (out.parent / 'v01/Como-testar-Xbox.md').read_text(encoding='utf-8').replace('P068-v01', 'P068-v02')
guide = guide.replace('Faça uma tentativa do título ao resultado', 'Na aba **Jogar** do Quartel, escolha herói e fase. Pressione **direita duas vezes** a partir da lista de heróis para chegar ao botão **JOGAR** no rodapé e confirme com **A** (ou B no Legado). O botão também aceita clique/toque.\n\nFaça uma tentativa do título ao resultado')
guide += '\nP068-v02 corrige o acesso ao botão Jogar (BUG-030). Usa o mesmo perfil de teste v01 para preservar suas preferências e progresso. Aceite físico continua pendente.\n'
(out / 'Como-testar-Xbox.md').write_text(guide, encoding='utf-8')

central_path = ws / 'state/plan.yaml'
state_path = ws / 'state/plan-068-controles-xbox-playstation.yaml'
for path in [central_path, state_path, ws / 'backlog/BUGS.md', ws / 'backlog/README.md', ws / 'backlog/MECANICAS.md']:
    target = out / 'recovery' / path.relative_to(root)
    target.parent.mkdir(parents=True, exist_ok=True)
    if not target.exists():
        shutil.copy2(path, target)
central = central_path.read_text(encoding='utf-8-sig')
central = central.replace('PLAN-068 / SPEC-135: P068-v01 implementado e validado localmente; 90 verificacoes controle, 144 mobile, suite zero falhas e smoke nove fases. Aceite fisico Xbox pendente.', 'PLAN-068 / SPEC-135: P068-v02 corrige Jogar no Quartel (BUG-030); 21 verificacoes acesso, 90 controle, 144 mobile e suite zero falhas. Aceite fisico Xbox pendente.')
central_path.write_text(central, encoding='utf-8')
state = state_path.read_text(encoding='utf-8')
state = state.replace("    output_path: .atena/generated/controller-experience/v01/", "    output_path: .atena/generated/controller-experience/v02/")
state = state.replace('  local_pilot: .atena/generated/controller-experience/v01/Abrir-teste-Xbox.cmd', '  local_pilot: .atena/generated/controller-experience/v02/Abrir-teste-Xbox.cmd')
state = state.replace("    request: 'vamos la: iniciar PLAN-068 aprovado apos entrega local mobile; retorno preservado.'", "    request: 'Dono: no Quartel com herois e fases falta o botao jogar; nao conseguiu iniciar tentativa.'")
state = state.replace('Dono testar P068-v01', 'Dono retestar acesso a Jogar no P068-v02')
state += '''  local_correction:
    classification: IN_PLAN
    date: '2026-10-06'
    bug: BUG-030
    status: LOCAL_VALIDATED_OWNER_RETEST_PENDING
    approval: EXISTING_PER_PLAN
    evidence: .atena/evidence/EVID-185-quartel-botao-jogar-2026-10-06.md
    menu_start_checks: 21
    exact_owner_screen_cause: NOT_CONFIRMED
    hardware_acceptance: false
'''
state_path.write_text(state, encoding='utf-8')

bugs_path = ws / 'backlog/BUGS.md'
bugs = bugs_path.read_text(encoding='utf-8-sig')
row = '| BUG-030 | P1 | Botão Jogar não encontrado no Quartel com heróis/fases; dono não conseguiu iniciar tentativa com Xbox | Dono, 2026-10-06; [EVID-185](../evidence/EVID-185-quartel-botao-jogar-2026-10-06.md) | **IMPLEMENTADO LOCAL 2026-10-06 — P068-v02:** botão fixado fora das colunas, ícone de confirmação e área reservada; 21 verificações de acesso e início sem falhas. Causa exata na tela do dono não confirmada; aguarda reteste físico | SPEC-135 |\n'
bugs = bugs.replace('## Abertos\n', '## Abertos\n\n' + row, 1)
bugs_path.write_text(bugs, encoding='utf-8')
readme_path = ws / 'backlog/README.md'
readme_path.write_text(readme_path.read_text(encoding='utf-8-sig').replace('BUG-030', 'BUG-031'), encoding='utf-8')
mechanics_path = ws / 'backlog/MECANICAS.md'
mechanics = mechanics_path.read_text(encoding='utf-8-sig')
lines = mechanics.splitlines()
for index, line in enumerate(lines):
    if line.startswith('| MEC-050 |'):
        lines[index] = line.replace('P068-v01, 90', 'P068-v02; botão Jogar fixo no Quartel, 21 verificações de acesso; 90') + ' Correção: [EVID-185](../evidence/EVID-185-quartel-botao-jogar-2026-10-06.md).'
mechanics_path.write_text('\n'.join(lines) + '\n', encoding='utf-8')

evidence = '''---
id: EVID-185
title: Botão Jogar acessível no Quartel
created: 2026-10-06
kind: owner-feedback-correction
origin: guided-add
implementation_preceded_spec: false
spec: "../specs/SPEC-135-experiencia-controles-xbox-playstation-2026-10-06.md"
state: "../state/plan-068-controles-xbox-playstation.yaml"
---

# Correção local P068-v02 — BUG-030

O dono informou “atena no menu inicial falta o botão jogar, não consegui iniciar uma tentativa” e esclareceu: **Quartel com heróis e fases**. Classificação **IN_PLAN**, S-007/S-010 revalidados dentro da aprovação per-plan de PLAN-068. Checkpoint físico B-004/S-011 e retornos mobile/Durvall preservados. Nenhum commit, exportação ou publicação.

## Resultado e limites

O botão existia dentro da coluna de fases; a captura anterior 1280×720 o mostrava. A causa exata no monitor/build usado pelo dono não foi confirmada. A correção elimina a dependência do botão em relação ao tamanho dessa coluna: **JOGAR** agora é filho direto do menu, ancorado no rodapé, com área própria reservada abaixo das listas. Aparece somente na aba Jogar e respeita a área segura mobile. O ícone acompanha família e confirmação Padrão/Legado. Direcional continua Herói → Fase → Jogar. Gerador da cena também atualizado.

## Validação

- [21 verificações de acesso](../generated/controller-experience/v02/menu-start-report.json), zero falhas: botão inteiro em 1280×720, 1600×900, 1920×1080, 1024×768, 1280×600 e 960×540; conteúdo excedente de 900 px não desloca o botão; abas ocultam/restauram; direcional alcança; A no Padrão e B no Legado iniciam tentativas; clique e mouse emulado de toque iniciam; perfil real preservado. [Execução com renderização](../generated/controller-experience/v02/menu-start.log), [headless](../generated/controller-experience/v02/menu-start-headless.log).
- [90 verificações de controle](../generated/controller-experience/v02/integration-report.json), zero falhas: jornada e contextos existentes preservados, incluindo quatro famílias e abas LB/L1 e RB/R1. [Log](../generated/controller-experience/v02/integration.log).
- [144 verificações mobile](../generated/controller-experience/v02/mobile-buttons-report.json), zero falhas. Relatório mobile anterior restaurado exatamente do snapshot anterior à regressão; nenhum aceite nativo inventado. [Log](../generated/controller-experience/v02/mobile-buttons.log).
- [Suíte completa](../generated/controller-experience/v02/suite.log): zero falhas.
- Capturas de todas as seis dimensões; inspeção visual em [720p](../generated/controller-experience/v02/quartel_1280x720.png) e [janela mais baixa](../generated/controller-experience/v02/quartel_1280x600.png) confirma botão separado e legível.

Godot 4.7.2 local. Eventos sintetizados e perfis descartáveis. O teste de toque verifica o mouse emulado usado pela UI; o dispositivo mobile físico continua pendente. Capturas adaptam o ícone ao último método de entrada; movimento real do mouse durante redimensionamento pode mostrar versão sem ícone. A verificação de ícone ocorre após comando deliberado do controle. A primeira versão do verificador usou nome vazio e abriu o guia de boas-vindas; a fixture foi corrigida para representar o piloto nomeado. Os testes finais acima passaram.

Avisos de encerramento já existentes ficam nos logs (suíte: 3 RIDs, 30 objetos, 5 recursos; integração/acesso: 4 objetos e 2 recursos; mobile: 6 objetos e 3 recursos). Captura apresenta indisponibilidade do cache de shaders no ambiente restrito. Nenhuma permissão alterada.

## Entrega e retorno

[Abrir piloto P068-v02](../generated/controller-experience/v02/Abrir-teste-Xbox.cmd), [guia](../generated/controller-experience/v02/Como-testar-Xbox.md), [manifesto](../generated/controller-experience/v02/pilot-manifest.json), [validação documental](../generated/controller-experience/v02/delivery-validation.json). O perfil piloto v01 é reutilizado para preservar preferências/progresso do dono. Recuperação desta mudança em [recovery](../generated/controller-experience/v02/recovery/); fontes v01 e evidência EVID-184 permanecem históricas. BUG-030 implementado localmente, **reteste Xbox pendente**. S-011 continua aberto; DS4/DualSense não testados fisicamente.
'''
(ws / 'evidence' / evidence_name).write_text(evidence, encoding='utf-8')
spec_path = ws / 'specs/SPEC-135-experiencia-controles-xbox-playstation-2026-10-06.md'
spec = spec_path.read_text(encoding='utf-8')
spec += '\n## Correção dentro do plano — 2026-10-06\n\nRelato do dono no Quartel classificado IN_PLAN: botão Jogar fixo e revalidação da entrada na tentativa. Entrega P068-v02; [EVID-185](../evidence/EVID-185-quartel-botao-jogar-2026-10-06.md). Aceite físico e retornos preservados.\n'
spec_path.write_text(spec, encoding='utf-8')

old = json.loads((out.parent / 'v01/pilot-manifest.json').read_text(encoding='utf-8'))
names = sorted(set(old['sources']) | {'ui/menu.tscn', 'tools/build_scenes.gd', 'tools/menu_start_check.gd', 'tools/menu_start_check.tscn'})
sources = {name: hashlib.sha256((root / name).read_bytes()).hexdigest() for name in names}
fingerprint = hashlib.sha256(json.dumps(sources, sort_keys=True, separators=(',', ':')).encode()).hexdigest()
manifest = {'id': 'P068-v02', 'date': '2026-10-06', 'baseline_commit': old['baseline_commit'], 'uncommitted_local_delta': True, 'fingerprint_scope': 'controller_sources_glyphs_menu_scene_generator', 'fingerprint_algorithm': 'sha256_of_sorted_compact_json_sources', 'fingerprint': fingerprint, 'sources': sources, 'previous_manifest': '../v01/pilot-manifest.json', 'pilot_profile': '../v01/pilot-profile.json', 'hardware_acceptance': False}
(out / 'pilot-manifest.json').write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print('P068-v02 reconciliado; fontes:', len(sources), '; fingerprint:', fingerprint[:16])
