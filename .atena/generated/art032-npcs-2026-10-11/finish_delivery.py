"""Reconcile the approved draft delivery. Reads PNGs; never modifies source pixels."""
import hashlib
import json
from html.parser import HTMLParser
from pathlib import Path
import re
from PIL import Image

OUT = Path(__file__).resolve().parent
ROOT = OUT.parents[2]
jobs = json.loads((OUT / 'jobs.json').read_text(encoding='utf-8'))
audit = json.loads((OUT / 'audit.json').read_text(encoding='utf-8'))
assert audit['status'] == 'PASS_WITH_NATIVE_ALPHA_NOTE'
assert [(j['code'], j['revision']) for j in jobs['jobs']] == [('NP01', 'v02'), ('NP02', 'v01'), ('NP03', 'v01'), ('PT01', 'v01')]

class GalleryParser(HTMLParser):
    def __init__(self):
        super().__init__()
        self.links = []
        self.previews = []
    def handle_starttag(self, tag, attrs):
        attrs = dict(attrs)
        for key in ('src', 'href', 'data-source'):
            if key in attrs:
                self.links.append(attrs[key])
        if tag == 'canvas':
            self.previews.append(attrs)

parser = GalleryParser()
parser.feed((OUT / 'index.html').read_text(encoding='utf-8'))
for link in parser.links:
    assert (OUT / link).is_file(), link
assert len(parser.previews) == 5
assert sorted(int(p['data-height']) for p in parser.previews) == [48, 80, 80, 80, 80]
for job in jobs['jobs']:
    previews = [p for p in parser.previews if Path(p['data-source']).name == Path(job['destination']).name]
    assert [int(p['data-height']) for p in previews] == job['preview_heights']
    assert all(json.loads(p['data-box']) == job['audit']['bbox_alpha_above8'] for p in previews)
with Image.open(OUT / 'review-reading.png') as preview:
    assert preview.size == (1000, 560)
log = (OUT / 'preview-renderer/render-log.txt').read_text(encoding='utf-8')
assert 'Rendered five reading previews' in log
assert 'SCRIPT ERROR' not in log

qa = {
    'plan': jobs['plan'], 'revision': 'v01', 'content_state': 'DRAFT',
    'gallery_local_links': 'PASS', 'gallery_metadata': 'PASS', 'preview_count': 5,
    'preview_heights': [80, 80, 80, 48, 80],
    'browser_render_verification': 'NOT_PERFORMED_URL_POLICY_BLOCKED_FILE_PROTOCOL',
    'browser_workaround_attempted': False,
    'reading_render': 'GODOT_OPENGL_COMPATIBILITY', 'reading_image': 'review-reading.png',
    'reading_image_sha256': hashlib.sha256((OUT / 'review-reading.png').read_bytes()).hexdigest(),
    'reading_inspection': 'COMPLETED_BY_ATENA',
    'reading_observations': {
        'NP01_v02_80px': 'Staff and blue/ivory silhouette remain identifiable; proposed physical identity awaits owner.',
        'NP02_v01_80px': 'Hood and guarded silhouette remain distinct; face/species deliberately concealed.',
        'NP03_v01_80px': 'Stooped posture, hand on chest and pale/mauve clothing remain distinguishable.',
        'PT01_v01_48_80px': 'Bright core and principal rays readable at both sizes; final map contrast remains deferred.'
    },
    'renderer_environment_notes': ['Shader cache unavailable under sandbox; preview rendered successfully.', 'System certificate-store warning; no network operation was performed.'],
    'renderer_repair': 'Initial script type inference failed; explicit String corrected it. Successful render log preserved.',
    'human_visual_acceptance': 'PENDING', 'playtest': 'NOT_PERFORMED',
    'native_pixels_changed_by_preview': False
}
(OUT / 'gallery-qa.json').write_text(json.dumps(qa, ensure_ascii=False, indent=2)+'\n', encoding='utf-8')
audit['gallery_qa'] = 'gallery-qa.json'
audit['reading_preview'] = 'review-reading.png'
audit['browser_render_verification'] = qa['browser_render_verification']
(OUT / 'audit.json').write_text(json.dumps(audit, ensure_ascii=False, indent=2)+'\n', encoding='utf-8')
jobs.update({'current_step': 'S-005/OWNER_VISUAL_REVIEW', 'status': 'GENERATED_AUDITED_WAITING_VISUAL_APPROVAL', 'gallery_qa': 'gallery-qa.json', 'reading_preview': 'review-reading.png', 'completed_steps': 4, 'total_steps': 5})
jobs['step_results'] = [
    {'step': 'S-001', 'status': 'COMPLETED', 'result': 'Sources, inventory, bible and explicit production approval recorded.'},
    {'step': 'S-002', 'status': 'COMPLETED', 'result': 'Four candidates in five native calls; targeted NP01 framing correction v02; v01 preserved.'},
    {'step': 'S-003', 'status': 'COMPLETED', 'result': 'Native hashes/RGBA/margins/source authority/protected files pass; alpha note and reading inspection recorded.'},
    {'step': 'S-004', 'status': 'COMPLETED', 'result': 'HTML links/metadata validated; static Godot reading sheet inspected; browser inspection blocked and disclosed.'},
    {'step': 'S-005', 'status': 'PENDING_OWNER_VISUAL_REVIEW', 'result': 'Owner must identify acceptance or adjustments for NP01 v02, NP02 v01, NP03 v01, PT01 v01.'}
]
(OUT / 'jobs.json').write_text(json.dumps(jobs, ensure_ascii=False, indent=2)+'\n', encoding='utf-8')

statepath = ROOT / '.atena/state/art032-npcs-piloto.yaml'
state = statepath.read_text(encoding='utf-8')
updates = {
    'status': 'GENERATED_AUDITED_WAITING_VISUAL_APPROVAL',
    'checkpoint': 'S-005/OWNER_VISUAL_REVIEW', 'current_step_position': '5', 'completed_steps': '4',
    'proposed_sources': '[NP01_JOAO_BARBOSA_v02, NP02_DESERTOR_v01, NP03_VITIMA_v01, PT01_ESTRELA_DO_NORTE_v01]',
    'next_objective': "'Revisão do dono das quatro revisões DRAFT; registrar aceite ou ajustes identificados, sem integração ou promoção automática'"
}
for key, value in updates.items():
    state, n = re.subn(r'^'+re.escape(key)+r':.*$', key+': '+value, state, flags=re.M)
    assert n == 1, key
state += '\nremaining_steps_after_current: 0\nnative_outputs_preserved: 5\ntechnical_status: PASS_WITH_NATIVE_ALPHA_NOTE\nevidence: .atena/evidence/art032-npcs-piloto-2026-10-11.md\nreading_preview: .atena/generated/art032-npcs-2026-10-11/review-reading.png\ngallery_browser_verification: NOT_PERFORMED_URL_POLICY_BLOCKED\ncompleted_ordered_steps: [S-001, S-002, S-003, S-004]\n'
statepath.write_text(state, encoding='utf-8')

rootpath = ROOT / '.atena/state/plan.yaml'
rootstate = rootpath.read_text(encoding='utf-8')
prefix, tail = rootstate.split('fila026_remaining_2026_10_11:', 1)
active_before = hashlib.sha256(rootstate.split('active_plan:', 1)[1].encode()).hexdigest()
for key, value in updates.items():
    if key == 'proposed_sources':
        continue
    prefix, n = re.subn(r'^  '+re.escape(key)+r':.*$', '  '+key+': '+value, prefix, flags=re.M)
    assert n == 1, key
prefix = prefix.replace('PROPOSE_SELECTED_FRONT_NOW_PRESERVE_PLAN071_AND_HERO_REVIEW', 'EXECUTE_APPROVED_DRAFT_FRONT_PRESERVE_PLAN071_AND_HERO_REVIEW')
prefix += '  remaining_steps_after_current: 0\n  review_candidates: [NP01_v02, NP02_v01, NP03_v01, PT01_v01]\n  human_visual_acceptance: PENDING\n  evidence: .atena/evidence/art032-npcs-piloto-2026-10-11.md\n'
newroot = prefix + 'fila026_remaining_2026_10_11:' + tail
assert hashlib.sha256(newroot.split('active_plan:', 1)[1].encode()).hexdigest() == active_before
rootpath.write_text(newroot, encoding='utf-8')

planpath = ROOT / '.atena/vault/drafts/PLAN-ART032-NPCS-PILOTO-v01.md'
plan = planpath.read_text(encoding='utf-8').replace('status: APPROVED_IN_EXECUTION', 'status: GENERATED_AUDITED_WAITING_VISUAL_APPROVAL')
plan = plan.replace('Quatro chamadas individuais built-in imagegen, DRAFT; sem CANON/admissão.', 'Concluído: quatro candidatas DRAFT em cinco chamadas built-in imagegen, com correção de margem NP01 v02 e histórico v01 preservado; sem CANON/admissão.')
plan = plan.replace('Hash/PNG/dimensões/alfa/margem, inspeção nativa, leitura em prévia; no máximo três versões por defeito.', 'Concluído: hashes/PNG/RGBA/margens e leitura Godot 48/80 px; ressalva nativa de alfa 1/255 em três bordas registrada.')
plan = plan.replace('Fontes, prompts, miniaturas, alertas reais e roteiro de revisão por peça.', 'Concluído: fontes, prompts, galeria e prancha estática com evidências; HTML validado por links/metadados, renderização browser não verificada por bloqueio de file://.')
plan += '\n## Entrega do checkpoint — 2026-10-11\n\n4/5 passos concluídos; S-005 pendente. Candidatas para revisão: **NP01 v02, NP02 v01, NP03 v01, PT01 v01**, todas DRAFT. NP01 v01 não selecionada por margem e preservada como histórico. Evidência: [auditoria e revisão](../../evidence/art032-npcs-piloto-2026-10-11.md). Próximo objetivo: o dono avaliar estilo, leitura e hipóteses físicas nas revisões exatas; saída é aceite visual identificado ou ajustes por código. Integração, normalização final e demais peças de ART-032 dependem de planos/checkpoints futuros. Nenhum commit, push, build ou promoção executado neste lote.\n'
planpath.write_text(plan, encoding='utf-8')

evidence = '''# ART-032 — quatro fontes DRAFT, 2026-10-11

Plano [PLAN-ART032-NPCS-PILOTO/v01](../vault/drafts/PLAN-ART032-NPCS-PILOTO-v01.md), aprovado antes da produção com **“Aprovo as quatro peças DRAFT”**, modo per-plan. Classificação/rota preservadas: produção selecionada agora, mantendo PLAN-071 e revisão de heróis. Quatro de cinco passos concluídos; S-005 revisão visual do dono pendente. Estado: [art032-npcs-piloto.yaml](../state/art032-npcs-piloto.yaml). Nenhuma promoção a CANON, admissão runtime, commit, push ou build neste lote.

## Fontes e revisões

| Peça DRAFT | Fonte nativa | Margem mínima (alfa > 8) | Alfa máximo na borda |
|---|---|---:|---:|
| NP01 João Barbosa v02 | [PNG](../generated/art032-npcs-2026-10-11/sources/NP01_joao_barbosa_v02.png) | 15,15% | 0/255 |
| NP02 desertor de Durao v01 | [PNG](../generated/art032-npcs-2026-10-11/sources/NP02_desertor_durao_v01.png) | 11,40% | 1/255 |
| NP03 vítima enfeitiçada v01 | [PNG](../generated/art032-npcs-2026-10-11/sources/NP03_vitima_enfeiticada_v01.png) | 12,52% | 1/255 |
| PT01 Estrela do Norte v01 | [PNG](../generated/art032-npcs-2026-10-11/sources/PT01_estrela_do_norte_v01.png) | 12,44% | 1/255 |

Cinco saídas nativas preservadas em quatro candidatas. [NP01 v01](../generated/art032-npcs-2026-10-11/sources/NP01_joao_barbosa_v01.png) tinha margem mínima de 5,58%; uma correção dirigida de enquadramento via imagegen produziu v02, mantendo a identidade proposta. Histórico não selecionado e não apagado. Fontes reais 1254×1254 PNG RGBA, apesar do pedido 1024×1024. Cópias byte a byte idênticas aos originais do built-in **image_gen**; sem limpeza ou redimensionamento nativo. Três bordas têm alfa residual 1/255, registrado, sem corte visível do objeto. Alfa > 8 é uma aproximação da caixa visível; brilhos muito fracos podem ultrapassá-la.

Referências/autoridade: direção CANON PLAN-001; sprites locais de Durvall/curandeiro apenas para câmera/acabamento; João Barbosa, Tou Um, Tou Um e Lu Yueh, Sessões 16/18 do vault somente leitura para papéis/contexto. Revisões e hashes completos em [jobs.json](../generated/art032-npcs-2026-10-11/jobs.json). Aparência de João/desertor é hipótese DRAFT; espécie/gênero do desertor não definidos, rosto oculto. Vítima humana adulta genérica. PT01 é miragem/ponto de orientação, identidade de personagem N/A; geometria luminosa não é símbolo canônico.

## Verificação e limites

[Auditoria](../generated/art032-npcs-2026-10-11/audit.json): PASS_WITH_NATIVE_ALPHA_NOTE. PNG/RGBA/transparência verdadeira/hash/dimensões/margem/corpo inteiro conferidos; hashes das referências, dos arquivos runtime/assets/data/testes protegidos e da cadeia ativa PLAN-071 inalterados. HEAD continua fc5c709f3ef5c4acdc7c5a8a842747b72c7f70ec. Nenhuma suite de gameplay reexecutada: produção isolada, sem alteração runtime; isto não é playtest.

[Galeria HTML](../generated/art032-npcs-2026-10-11/index.html) entregue com links locais e metadados das cinco prévias validados. A inspeção de renderização pelo navegador não ocorreu: sua política bloqueia URLs file://. Não foi tentado contorno do bloqueio. Alternativa independente: [prancha estática Godot](../generated/art032-npcs-2026-10-11/review-reading.png), renderizada em OpenGL Compatibility e inspecionada, com recortes somente em memória e alturas de motivo de 80 px (atores) e 48/80 px (estrela). Não equivale à normalização PNG final nem a uma captura do jogo. [QA](../generated/art032-npcs-2026-10-11/gallery-qa.json) e [log de render](../generated/art032-npcs-2026-10-11/preview-renderer/render-log.txt) registram execução/limites. Avisos ambientais de cache de shader e certificados não impediram o PNG; não houve operação de rede. Erro inicial de inferência de tipo do script corrigido antes da execução válida.

Inspeção Atena: cajado e traje azul/marfim distinguem João; capuz/pose retraída distinguem desertor; postura curvada/mão no peito e roupa malva distinguem vítima a 80 px. Núcleo e pontas da estrela legíveis a 48/80 px. Contraste sobre mapas, identidade definitiva, adequação subjetiva e conforto dependem de revisão humana/etapas futuras; não são aceites inferidos.

[Prompts completos](../generated/art032-npcs-2026-10-11/prompts.md) incluem revisões finais e histórico; [correção João v02](../generated/art032-npcs-2026-10-11/correction-NP01-v02.txt). Native outputs/default tool origin and SHA256 remain in jobs.json.

## Próximo checkpoint

S-005, posição 5/5, quatro concluídos, zero após o passo atual. Objetivo: o dono avaliar **NP01 v02, NP02 v01, NP03 v01, PT01 v01** na prancha/fontes. Conferir estilo/câmera, proposta física de João, rosto oculto/neutralidade de espécie do desertor, leitura da vítima a 80 px e da estrela a 48/80 px. Saída: aceite visual das revisões explicitamente identificadas ou ajustes por código. Aceite ainda PENDENTE; não autoriza automaticamente integração, CANON, commit ou push. Demais peças de ART-032 permanecem abertas.
'''
evidencepath = ROOT / '.atena/evidence/art032-npcs-piloto-2026-10-11.md'
evidencepath.write_text(evidence, encoding='utf-8')
backlogpath = ROOT / '.atena/backlog/ARTE.md'
backlog = backlogpath.read_text(encoding='utf-8')
line = next(line for line in backlog.splitlines() if line.startswith('| ART-032 |'))
assert line.endswith('| aberto |')
new_line = line[:-len('aberto |')] + '**PARCIAL DRAFT 2026-10-11:** NP01 v02, NP02/NP03/PT01 v01 gerados e auditados; revisão visual S-005 pendente. [Evidência](../evidence/art032-npcs-piloto-2026-10-11.md). Demais peças e admissão abertas |'
backlogpath.write_text(backlog.replace(line, new_line), encoding='utf-8')
for doc in [evidencepath, planpath]:
    for target in re.findall(r'\]\(([^)]+)\)', doc.read_text(encoding='utf-8')):
        assert (doc.parent / target).is_file(), (doc, target)
snapshot = json.loads((OUT / 'protected-snapshot.json').read_text(encoding='utf-8'))
for path, expected in snapshot.items():
    if '#active_plan_tail' in path:
        actual = hashlib.sha256(rootpath.read_text(encoding='utf-8').split('active_plan:', 1)[1].encode()).hexdigest()
    else:
        actual = hashlib.sha256((ROOT / path).read_bytes()).hexdigest()
    assert actual == expected, path
print('Delivery reconciled: 4/5 steps completed; exact four DRAFT revisions at S-005; links/preview metadata PASS; protected runtime and PLAN071 unchanged.')
