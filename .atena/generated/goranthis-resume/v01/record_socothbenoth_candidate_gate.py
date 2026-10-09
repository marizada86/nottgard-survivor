from pathlib import Path
from PIL import Image, ImageDraw
import hashlib, json, re

root = Path(__file__).resolve().parents[4]
out = Path(__file__).parent
base = root / '.atena/generated/art-candidates/enemies-goranthis/socothbenoth'
packing = json.loads((base / 'strips/packing.json').read_text())
audit = json.loads((out / 'socothbenoth-selected-source-audit.json').read_text())
assert len(audit) == 26 and all(not f['clipped'] and f['solidity'] >= .9 for f in audit)
selection = json.loads((base / 'frame-selection.json').read_text())
assert all(selection[f'move_{i:02}']['approval_status'] == 'PENDING_OWNER_DECISION' for i in [3, 4])
sources = []
for f in audit:
    path = root / f['path'].removeprefix('res://')
    sources.append({**f, 'path': path.relative_to(root).as_posix(), 'sha256': hashlib.sha256(path.read_bytes()).hexdigest()})
strips = []
states = ['idle', 'move', 'attack', 'death', 'special']
state_frames = {}
for state in states:
    path = base / 'strips' / f'{state}.png'
    strip = Image.open(path).convert('RGBA')
    count = len(packing['sources'][state])
    strips.append(dict(state=state, path=path.relative_to(root).as_posix(), sha256=hashlib.sha256(path.read_bytes()).hexdigest(), size=strip.size, official=False))
    frames = []
    for i in range(count):
        frame = strip.crop((256*i+8, 150, 256*i+248, 380)).resize((320,307), Image.Resampling.NEAREST)
        bg = Image.new('RGBA', (320, 340), '#25252e')
        bg.alpha_composite(frame, (0, 27))
        ImageDraw.Draw(bg).text((10,8), f'{state}_{i:02}', fill='white')
        frames.append(bg.convert('RGB'))
    state_frames[state] = frames
    frames[0].save(out / f'socothbenoth_{state}_owner_preview.gif', save_all=True, append_images=frames[1:], duration=180, loop=0)
all_frames = []
for tick in range(12):
    canvas = Image.new('RGB', (1600,340), '#25252e')
    for column,state in enumerate(states):
        canvas.paste(state_frames[state][tick % len(state_frames[state])], (column*320,0))
    all_frames.append(canvas)
all_frames[0].save(out / 'socothbenoth_all_cycles_owner_preview.gif', save_all=True, append_images=all_frames[1:], duration=180, loop=0)
manifest = json.loads((root / '.atena/generated/PRIORITY-IMAGES-2026-10-02.json').read_text(encoding='utf-8-sig'))
assert len(manifest['assets']) == 192
assert all(hashlib.sha256((root / f['path']).read_bytes()).hexdigest() == f['sha256'] for f in manifest['assets'])
assert not (root / 'assets/animations/enemies/socothbenoth').exists()
assert '"socothbenoth":' not in (root / 'ui/enemy_view.gd').read_text(encoding='utf-8')
receipt = dict(date='2026-10-08', plan='PLAN-053', spec='SPEC-121', actor='socothbenoth',
    status='GENERATED_PACKED_AWAITING_OWNER_CYCLE_DECISION', selected_frames=26,
    native_png_versions=len(list(base.glob('socothbenoth_*_v*.png'))), sources=sources, candidate_strips=strips,
    packing=packing, source_and_cell_bounds_passed=True, native_alpha_preserved=True, packed_review_inspected=True,
    reviewed_anatomy='Two humanoid arms/hands, two attached shadow-serpent heads, four dominant horn prongs retained.',
    reviewed_cycles='Readable anticipation/strike/recovery, progressive side collapse and final settled body, rising/peak/recovery special.',
    unresolved='move_03 and move_04 keep the same foreground leg leading after three versions; no clear opposite contact.',
    gate='.atena/generated/goranthis-resume/v01/socothbenoth-move-owner-gate-2026-10-08.json',
    preview='.atena/generated/goranthis-resume/v01/socothbenoth_all_cycles_owner_preview.gif',
    integration_blocked=True, runtime_checks='Not run for this actor; pending owner cycle decision and installation.',
    official_manifest_hashes_verified=192, human_playtest='PENDING')
receipt_path = out / 'socothbenoth-candidate-review-receipt-2026-10-08.json'
receipt_path.write_text(json.dumps(receipt, indent=2)+'\n', encoding='utf-8')
evidence = root / '.atena/evidence/goranthis-socothbenoth-candidate-gate-2026-10-08.md'
evidence.write_text('# Socothbenoth — candidato completo, decisão da marcha pendente\n\nPLAN-053/SPEC-121 IN_PLAN, per-plan aprovado; identidade I04 aprovada. 26 fontes selecionadas e cinco tiras candidatas, sem integração. Todas as fontes e células passaram limites e solidez >=0.90; alfa/RGB nativos preservados por amostragem nearest. Prancha empacotada inspecionada: dois braços/mãos, duas cabeças de serpente, quatro chifres principais; ataque, queda e especial legíveis. As escalas uniformes dos quadros largos da morte e a ancoragem horizontal estão rastreadas no frame-selection.json.\n\nMove03/04: três versões preservadas para cada quadro, sem contato oposto claro. v03 serve apenas à prévia; nenhuma quarta tentativa, exceção ou aprovação foi presumida. Decisão do dono pendente antes de instalar, ligar especial, validar runtime e exportar. Aprovação anterior da marcha do Escravo de Rivenheart não se estende a este ator.\n\n[Recibo, hashes e limites](../generated/goranthis-resume/v01/socothbenoth-candidate-review-receipt-2026-10-08.json). [Prévia dos cinco ciclos](../generated/goranthis-resume/v01/socothbenoth_all_cycles_owner_preview.gif). [Gate da marcha](../generated/goranthis-resume/v01/socothbenoth-move-owner-gate-2026-10-08.json).\n\nGoranthis: 86 fontes selecionadas geradas (82 novos quadros após identidades); três atores/12 tiras oficiais validados. Cinco tiras de Socothbenoth candidatas aguardam decisão. Manifesto oficial de 192 assets conferido, sem instalação de Socothbenoth. Testes de runtime, captura e build deste ator não executados; playtest humano pendente. Retorno ao PLAN-071 preservado.\n', encoding='utf-8')
for rel in ['.atena/state/plan.yaml', '.atena/state/plan-053-imagens.yaml']:
    path = root / rel
    text = path.read_text(encoding='utf-8-sig')
    text = re.sub(r'  status: EXECUTING_CYCLES', '  status: AWAITING_OWNER_CYCLE_DECISION', text, count=1)
    text = re.sub(r"  current: '[^\n]+", "  current: 'S-006 Goranthis: 86 fontes geradas; Socothbenoth 26 quadros e cinco tiras candidatas revistos, marcha03-04 pendente.'", text, count=1)
    text = re.sub(r"  next: '[^\n]+", "  next: 'Aguardar decisao da marcha antes de integrar Socothbenoth, validar runtime/especial e exportar Goranthis; retorno PLAN-071 preservado.'", text, count=1)
    if rel.endswith('/plan.yaml'):
        text = re.sub(r'  checkpoint: S-006/GORANTHIS/[^\n]+', '  checkpoint: S-006/GORANTHIS/SOCOTHBENOTH/BEFORE-INTEGRATION', text, count=1)
    else:
        text = re.sub(r'  cycles_generated: \d+', '  cycles_generated: 82', text, count=1)
        text = re.sub(r'  remaining_new_frames: \d+', '  remaining_new_frames: 0', text, count=1)
        text = re.sub(r"  review: '[^\n]+'", "  review: '.atena/generated/goranthis-resume/v01/socothbenoth_all_cycles_owner_preview.gif'", text, count=1)
        text = re.sub(r"  evidence: '[^\n]+'", "  evidence: '.atena/evidence/goranthis-socothbenoth-candidate-gate-2026-10-08.md'", text, count=1)
        text = text.replace('  independent_work: Other approved attack/death/special source frames.', '  independent_work: COMPLETED; all 26 source frames reviewed and packed as candidates.')
    assert 'ranking_return_after_images:' in text if rel.endswith('/plan.yaml') else 'completed_identity_gates:' in text
    path.write_text(text, encoding='utf-8')
path = root / '.atena/generated/CHATGPT-FILA-018-mobs-goranthis.md'
text = path.read_text(encoding='utf-8'); start = text.index('### `socothbenoth`')
text = text[:start] + text[start:].replace('- [ ]', '- [x]')
text = re.sub(r'^status:.*', 'status: "86 fontes geradas; 3 atores/12 tiras integrados; Socothbenoth candidato aguarda decisao da marcha"', text, count=1, flags=re.M)
path.write_text(text, encoding='utf-8')
path = root / '.atena/generated/ART-PROMPTS-049-mobs-goranthis.md'
text = re.sub(r'^status:.*', 'status: "86 fontes geradas; Socothbenoth 26 quadros candidatos, marcha03-04 aguarda decisao antes da integracao"', path.read_text(encoding='utf-8'), count=1, flags=re.M)
path.write_text(text, encoding='utf-8')
note = '\n2026-10-08 — Socothbenoth: 26 fontes selecionadas/5 tiras candidatas revistos, limites e alfa passaram; gate da marcha03-04 pendente após três versões. Goranthis 86 fontes geradas; 12 tiras oficiais, manifesto 192 hashes conferido. Evidência: goranthis-socothbenoth-candidate-gate-2026-10-08.md. Sem integração/runtime/build deste ator; retorno PLAN-071 preservado.\n'
for rel in ['.atena/evidence/EVID-145-fila-de-imagens-prioritaria-2026-10-02.md', '.atena/specs/SPEC-121-retomada-fila-imagens/tasks.md']:
    path = root / rel
    path.write_text(path.read_text(encoding='utf-8') + note, encoding='utf-8')
assert all((root / f['path']).exists() for f in sources + strips)
assert all((evidence.parent / target).resolve().is_file() for target in re.findall(r'\]\(([^)]+)\)', evidence.read_text(encoding='utf-8')))
print('26 selected sources/5 candidate strips: bounds, alpha, source hashes, 192 official hashes and evidence links verified; persistent gate pending, no installation.')
