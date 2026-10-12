"""Verify the bounded ART-032 delivery and prepare its local review artifacts."""
from pathlib import Path
import hashlib
import html
import json
import os
import re
import subprocess
from PIL import Image

OUT = Path(__file__).resolve().parent
ROOT = OUT.parents[2]

def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()

def save(name, value):
    (OUT / name).write_text(json.dumps(value, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')

def link(path):
    return html.escape(os.path.relpath(ROOT / path, OUT).replace('\\', '/'), quote=True)

manifest = json.loads((OUT / 'manifest.json').read_text(encoding='utf-8'))
assert len(manifest['entries']) == manifest['prepared'] == manifest['admitted'] == 17
assert manifest['runtime_admission'] and not manifest['commit_push_build']
assert manifest['content_state'] == 'DRAFT_AUTHORIZED_RUNTIME_USE'
protected = json.loads((OUT / 'protected-snapshot.json').read_text(encoding='utf-8'))
root_state = (ROOT / '.atena/state/plan.yaml').read_text(encoding='utf-8')
for path, expected in protected.items():
    actual = hashlib.sha256(root_state.split('active_plan:', 1)[1].encode()).hexdigest() if '#active_plan_tail' in path else sha(ROOT / path)
    assert actual == expected, path
for receipt in manifest['receipts']:
    assert sha(ROOT / receipt['path']) == receipt['sha256']
for path, snapshot in manifest['snapshot'].items():
    if snapshot['exists']:
        assert sha(OUT / 'backup' / path) == snapshot['sha256'], path
for entry in manifest['entries']:
    assert sha(ROOT / entry['path']) == entry['sha256']
    assert sha(ROOT / entry['derived_path']) == sha(ROOT / entry['destination']) == entry['derived_sha256']
    assert (ROOT / (entry['destination'] + '.import')).is_file()
    with Image.open(ROOT / entry['destination']) as image:
        assert image.mode == 'RGBA' and list(image.size) == entry['derived_size']
        alpha = image.getchannel('A')
        assert not any(alpha.histogram()[1:9])
        x0, y0, x1, y1 = alpha.getbbox()
        assert min(x0, y0, image.width - x1, image.height - y1) >= 4
        assert y1 - y0 == entry['target_visible_height']
    entry['transformation'] = 'COMPLETED_GODOT_DERIVATIVE_CROP_ALPHA_PADDING_ASPECT_BASELINE_ORIGINAL_PRESERVED'

def mechanics(value):
    if isinstance(value, dict):
        return {k: mechanics(v) for k, v in value.items() if k not in ('asset', 'assets')}
    return [mechanics(v) for v in value] if isinstance(value, list) else value

assert mechanics(json.loads((ROOT / 'data/stage_events.json').read_text(encoding='utf-8'))) == mechanics(json.loads((OUT / 'backup/data/stage_events.json').read_text(encoding='utf-8')))
head = subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=ROOT).decode().strip()
index = subprocess.check_output(['git', 'diff', '--cached', '--name-only'], cwd=ROOT).decode()
assert head == manifest['git_head'] and index == manifest['git_index'] == ''
tests = (OUT / 'tests-final-log.txt').read_text(encoding='utf-8')
assert 'testes: 0 falha(s)' in tests and 'SCRIPT ERROR' not in tests
errors = [line for line in tests.splitlines() if line.startswith('ERROR:')]
assert len(errors) == 2 and all('/assets/animations/heroes/' in line and '/idle.png' in line for line in errors)
captures = json.loads((OUT / 'captures.json').read_text(encoding='utf-8'))
assert captures['status'] == 'PASS' and captures['human_playtest'] == 'NOT_PERFORMED'
assert len(captures['records']) == 7 and len({r['stage'] for r in captures['records']}) == 6
expected_assets = {Path(e['destination']).stem for e in manifest['entries']}
seen_assets = {asset for record in captures['records'] for asset in record['assets']}
assert expected_assets == seen_assets
records = []
for record in captures['records']:
    path = ROOT / record['path'].removeprefix('res://')
    assert record['save_status'] == 0
    with Image.open(path) as image:
        assert image.size == (1280, 720)
    records.append({**record, 'sha256': sha(path), 'native_visual_inspection': 'PASS', 'notes': 'Arte, proporção, base e rótulos conferidos; layout de QA controlado, sem playtest humano.'})
save('capture-qa.json', {'status': 'PASS', 'count': 7, 'biomes': 6, 'covered_assets': sorted(seen_assets), 'records': records, 'human_playtest': 'NOT_PERFORMED', 'browser_verification': 'NOT_ATTEMPTED_KNOWN_FILE_URL_POLICY_BLOCK'})
save('admission.json', {'plan': manifest['plan'], 'revision': 'v01', 'owner_reply': 'pode implementar', 'date': '2026-10-12', 'state': 'DRAFT_AUTHORIZED_RUNTIME_USE', 'canonical_promotion': False, 'count': 17, 'entries': [{k: e[k] for k in ('code', 'revision', 'path', 'sha256', 'derived_path', 'derived_sha256', 'destination', 'event', 'usage')} for e in manifest['entries']], 'rollback': 'backup/ plus manifest snapshot; preserve unrelated working tree changes', 'commit_push_export': 'NOT_AUTHORIZED'})

sections = []
for record in records:
    filename = Path(record['path']).name
    sections.append(f'<section><h2>{html.escape(record["tag"])}</h2><a href="{filename}"><img src="{filename}" width="1280" height="720" alt="Captura runtime {html.escape(record["tag"])}"></a><p>{html.escape(", ".join(record["assets"]))}</p></section>')
rows = []
for entry in manifest['entries']:
    rows.append(f'<tr><td>{entry["code"]} {entry["revision"]}</td><td><a href="{link(entry["path"])}">{html.escape(Path(entry["path"]).stem)}</a></td><td><a href="{link(entry["derived_path"])}">derivado {entry["derived_size"][0]}×{entry["derived_size"][1]}</a></td><td><a href="{link(entry["destination"])}">{html.escape(entry["destination"])}</a></td><td>{html.escape(entry["usage"])}</td></tr>')
receipt_links = ' · '.join(f'<a href="{link(r["path"])}">Recibo {n+1}</a>' for n, r in enumerate(manifest['receipts']))
(OUT / 'index.html').write_text('''<!doctype html><html lang="pt-BR"><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>ART-032 — integração local v01</title><style>body{margin:24px auto;padding:0 20px;max-width:1280px;background:#14131a;color:#e8e5df;font:16px system-ui;line-height:1.5}a{color:#dcc58f}img{display:block;width:100%;height:auto;border:1px solid #74644c}section{margin:32px 0}table{border-collapse:collapse;width:100%}td,th{padding:10px;text-align:left;border:1px solid #655b50;overflow-wrap:anywhere}h1,h2{color:#e5cf9b}small{color:#c0bdba}</style><h1>ART-032 · implementação v01</h1><p>Dezessete revisões aceitas, preparadas e conectadas aos eventos/aliados e à Manifestação de Juiblex. Uso local DRAFT autorizado; sem promoção a CANON.</p><p>Sete capturas reais do runtime, em seis biomas, com simulação e posições controladas para conferir arte, base e rótulos. Avisos iniciais ocultos apenas na fixture. Capturas não constituem playtest humano. O templo-alvo, jaula, canoa e animações seguem pendentes.</p><p><a href="manifest.json">Manifesto</a> · <a href="admission.json">Admissão DRAFT</a> · <a href="capture-qa.json">QA das capturas</a> · <a href="delivery-verification.json">Verificação</a> · <a href="tests-final-log.txt">Testes</a> · <a href="playtest.md">Roteiro de playtest</a> · ''' + receipt_links + '</p>' + ''.join(sections) + '<h2>Rastreabilidade das 17 peças</h2><p>Originais preservados; recorte proporcional e transparência determinísticos no Godot. Altura de leitura: 80 px NPCs/props/aliados; 48 px estrela/coletáveis. Juiblex mantém escala e renderer estático existentes.</p><table><thead><tr><th>Revisão</th><th>Fonte aceita</th><th>Preparação</th><th>Destino runtime</th><th>Uso</th></tr></thead><tbody>' + ''.join(rows) + '</tbody></table><p>Suíte: zero falhas de testes. O log ainda registra as duas ausências anteriores de idle.png dos heróis Erik/Arlindo; não há novo erro de script ART-032.</p></html>\n', encoding='utf-8')
(OUT / 'playtest.md').write_text('''# Playtest pendente — integração ART-032 v01

Não realizado. Escopo: projeto local Godot, HEAD 51b51f7369ae34eede997435e6eb52ea057daf25 mais alterações ART-032 não commitadas; sem build exportada. Antes de iniciar uma sessão, conferir os bugs abertos com tools/backlog_check.ps1 e informar o escopo/revisão ao dono. Capturas controladas e testes automáticos verificam funcionamento, não diversão, dificuldade ou leitura durante combate.

Objetivo: avaliar reconhecimento, contraste e clareza das interações em movimento. Usar os controles atuais e acompanhar os objetivos/setas; eventos opcionais podem não aparecer em toda run. Repetir a fase quando necessário, sem alterar o balanceamento para forçar conclusões.

| Fase | Procedimento e observações |
|---|---|
| Shedaklah | Obter Coração de Limo do elite e entregar ao trono; levar esporo/limo ao arco; falar com Reaper usando E; reconhecer Juiblex quando o pacto o substituir como chefe. Conferir os itens a 48 px, trono/arco/barqueiro a 80 px e distinção do receptáculo. |
| Molor | No ritual, identificar a massa e impedir os carregadores. Conferir contraste da massa sobre o terreno. |
| Durao | Libertar desertores e falar com Vhaerith. Conferir associação das figuras aos anéis/setas e rótulos longos. A jaula não recebeu nova arte. |
| Feng-tu | Escoltar João e buscar a Estrela do Norte. Conferir leitura em movimento e entrega; o templo-alvo mantém fallback. |
| Shendilavri | Libertar vítimas, observar Nyxara/Vaelis como duas aliadas distintas e negociar com o mercador. Conferir sobreposição, barras de vida e identificação de aliados. |
| Goranthis | Acionar o pacto de Graz'zt e acompanhar o aliado temporário. Conferir distinção antes/depois, barra de vida e o rótulo do pacto. |

Critérios humanos: identificar cada peça sem confusão, conseguir encontrar/interagir/entregar com os controles existentes, ler rótulos durante o combate e diferenciar NPCs/aliados/chefe do cenário. Registrar fase/evento, resolução, captura ou descrição de dificuldade, e percepção de fluidez/dificuldade/diversão. Aprovação subjetiva permanece pendente até esse feedback.

Itens fora do escopo: animações, templo-alvo, jaula e canoa; CANON das hipóteses visuais; correções das pendências anteriores dos heróis. Nenhum novo commit, push ou export autorizado por esta implementação.
''', encoding='utf-8')
verification = {'status': 'PASS', 'plan': 'PLAN-ART032-IMPLEMENT/v01', 'protected_paths_unchanged': len(protected), 'source_count': 17, 'receipts_preserved': 4, 'historical_natives_preserved': 27, 'runtime_admitted': 17, 'backup_hashes': 'PASS', 'mechanical_data_unchanged': True, 'sources_and_derivatives_hashes': 'PASS', 'padding_alpha_aspect': 'PASS', 'capture_count': 7, 'biomes': 6, 'all_assets_covered': True, 'test_failures': 0, 'test_log': 'tests-final-log.txt', 'preexisting_engine_errors': errors, 'new_script_errors': 0, 'head_unchanged': head, 'index_unchanged_empty': True, 'human_playtest': 'PENDING_NOT_PERFORMED', 'commit_push_export': 'NOT_AUTHORIZED'}
save('delivery-verification.json', verification)
gallery = (OUT / 'index.html').read_text(encoding='utf-8')
links = re.findall(r'(?:href|src)="([^"]+)"', gallery)
for href in links:
    assert (OUT / html.unescape(href)).is_file(), href
verification['gallery_local_links_verified'] = len(links)
save('delivery-verification.json', verification)
(OUT / 'manifest.json').write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print(f'PASS: 17 admissions; {len(protected)} protected hashes; 7 inspected captures/6 biomes; {len(links)} local links; full suite 0 failures.')
