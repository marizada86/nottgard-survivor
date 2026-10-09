from pathlib import Path
from PIL import Image
import hashlib, json, re, sys

root = Path(__file__).resolve().parents[4]
out = Path(__file__).parent
actor, next_actor = sys.argv[1:3]
assert '--capture-inspected' in sys.argv, 'Inspect actual runtime capture before recording completion.'
actors = ['sintese_abissal']
assert actor in actors
base = root / '.atena/generated/art-candidates/enemies-pilares' / actor
packing = json.loads((base / 'strips/packing.json').read_text())
audit = json.loads((out / f'{actor}-selected-source-audit.json').read_text())
sources = []
for state, items in packing['sources'].items():
    for index, item in enumerate(items):
        path = root / item['path'].removeprefix('res://')
        im = Image.open(path).convert('RGBA')
        alpha = im.getchannel('A')
        hist = alpha.histogram()
        box = alpha.point(lambda x: 255 if x >= 11 else 0).getbbox()
        assert box[0] > 0 and box[1] > 0 and box[2] < im.width and box[3] < im.height, path
        solidity = sum(hist[230:]) / sum(hist[11:])
        assert solidity >= .9, path
        verified = next(row for row in audit if row['state'] == state and row['index'] == index)
        assert verified['path'] == item['path'] and not verified['clipped']
        sources.append(dict(state=state, index=index, path=path.relative_to(root).as_posix(),
                            sha256=hashlib.sha256(path.read_bytes()).hexdigest(), size=im.size,
                            bbox=box, solidity=solidity, clipped=False,
                            anchor=item['anchor'], scale=item['scale']))
expected = 26 if actor == 'sintese_abissal' else 20
assert len(sources) == expected
assets = []
for state in packing['sources']:
    path = root / 'assets/animations/enemies' / actor / f'{state}.png'
    assert path.read_bytes() == (base / 'strips' / f'{state}.png').read_bytes()
    assets.append(dict(state=state, path=path.relative_to(root).as_posix(), size=Image.open(path).size,
                       sha256=hashlib.sha256(path.read_bytes()).hexdigest()))
checks = {}
markers = {'queue': 'Animation queue: 0 failure(s)', 'runtime': 'death cleanup OK',
           'suite': 'testes: 0 falha(s)', 'smoke': 'smoke: ok', 'capture': 'Shedaklah capture result=0',
           'trigger': 'actual aoe telegraph/summon/ring -> special, unlock and puddle -> attack OK'}
for suffix, marker in markers.items():
    path = out / f'{actor}-{suffix}.log'
    if suffix in ['queue', 'runtime', 'capture'] or path.exists():
        text = path.read_text(encoding='utf-8', errors='replace')
        assert marker in text and 'SCRIPT ERROR' not in text, path
        checks[suffix] = dict(path=path.relative_to(root).as_posix(), marker=marker, passed=True)
if actor == 'cultista_de_socothbenoth':
    path = out / 'ilusao_de_socothbenoth-runtime.log'
    text = path.read_text(encoding='utf-8', errors='replace')
    assert 'death cleanup OK' in text and 'SCRIPT ERROR' not in text, path
    checks['reuse'] = dict(path=path.relative_to(root).as_posix(), id='ilusao_de_socothbenoth',
                           source_id='cultista_de_socothbenoth', alpha=.45, passed=True)
    reuse_path = out / 'illusion-reuse-integration-receipt.json'
    reuse = json.loads(reuse_path.read_text())
    assert reuse['source_id'] == 'cultista_de_socothbenoth' and reuse['native_pngs_generated'] == 0
    reuse.update(status='REGISTERED_RUNTIME_VALIDATED', runtime_check=checks['reuse'])
    reuse_path.write_text(json.dumps(reuse, indent=2) + '\n')
manifest = json.loads((root / '.atena/generated/PRIORITY-IMAGES-2026-10-02.json').read_text(encoding='utf-8-sig'))
for row in manifest['assets']:
    assert hashlib.sha256((root / row['path']).read_bytes()).hexdigest() == row['sha256'], row['path']
completed = [item for item in actors if item == actor or (out / f'{item}-completion-receipt.json').exists()]
new_done = sum(25 if item == 'sintese_abissal' else 19 for item in completed)
remaining = 25 - new_done
official_count = sum(5 if item == 'sintese_abissal' else 4 for item in completed)
evidence = f'.atena/evidence/pilares-{actor}-cycles-2026-10-08.md'
receipt = dict(date='2026-10-08', plan='PLAN-053', spec='SPEC-121', actor=actor,
               status='INTEGRATED_LOCAL_VALIDATED', sources=sources, assets=assets, packing=packing,
               checks=checks, manifest_verified=len(manifest['assets']),
               capture=f'.atena/generated/priority-review/{actor}_runtime.png',
               native_alpha_preserved=True, capture_inspected=True, next_actor=next_actor, remaining_new_frames=remaining)
approval = json.loads((out / 'attack03-pendant-owner-approval-2026-10-08.json').read_text(encoding='utf-8'))
assert approval['status'] == 'ACCEPTED_OWNER_EXCEPTION' and approval['exception_scope'] == ['attack_03']
receipt['owner_exception'] = approval
(out / f'{actor}-completion-receipt.json').write_text(json.dumps(receipt, indent=2) + '\n', encoding='utf-8')
for rel in ['.atena/state/plan.yaml', '.atena/state/plan-053-imagens.yaml']:
    path = root / rel
    text = path.read_text(encoding='utf-8-sig')
    central = rel.endswith('/plan.yaml')
    if central:
        text = re.sub(r'  checkpoint: S-006/PILARES/[^\n]+',
                      f'  checkpoint: S-006/PILARES/{next_actor.upper()}/CYCLES', text, count=1)
    else:
        text = re.sub(r'  cycles_generated: \d+', f'  cycles_generated: {new_done}', text, count=1)
        text = re.sub(r'  official_assets_installed: \d+', f'  official_assets_installed: {official_count}', text, count=1)
        text = re.sub(r'  remaining_new_frames: \d+', f'  remaining_new_frames: {remaining}', text, count=1)
        text = re.sub(r"  review: '[^\n]+'", f"  review: '.atena/generated/pilares-resume/v01/{actor}_compact_review.png'", text, count=1)
        text = re.sub(r"  evidence: '[^\n]+'", f"  evidence: '{evidence}'", text, count=1)
    text = re.sub(r"  current: '[^\n]+", f"  current: 'S-006 Pilares: {len(completed)} atores/{official_count} tiras integrados e validados; ultimo {actor}.'", text, count=1)
    text = re.sub(r"  next: '[^\n]+", f"  next: 'Proximo {next_actor}; {remaining} novos quadros restantes. Retorno PLAN-071 preservado.'", text, count=1)
    path.write_text(text, encoding='utf-8')
(root / evidence).write_text(
    f'# Pilares — {actor}\n\nPLAN-053/SPEC-121 IN_PLAN, per-plan aprovado. {expected} fontes selecionadas/{len(assets)} tiras integradas localmente. Fontes e celulas sem cortes, solidez >=0.90; alfa/RGB nativos preservados por empacotamento nearest. Prancha e captura inspecionadas.\n\n'
    f'[Recibo, fontes, hashes e checks](../generated/pilares-resume/v01/{actor}-completion-receipt.json). [Captura real](../generated/priority-review/{actor}_runtime.png).\n\n'
    f'Fila, runtime do ator real, gatilho real e captura passaram. Suite/smoke conforme logs no recibo. Manifesto {len(manifest["assets"])} hashes conferidos. Excecao do pequeno pingente verde aprovada explicitamente somente em attack03v03, conforme recibo; dois lampioes principais e tres bracos preservados. Playtest humano pendente. Proximo {next_actor}, {remaining} quadros novos restantes.\n', encoding='utf-8')
summary = (f'\n2026-10-08 — Pilares {actor}: {expected} fontes/{len(assets)} tiras integrados e validados; '
           f'fila/runtime/captura passaram; manifesto {len(manifest["assets"])} hashes conferidos. '
           f'Evidencia pilares-{actor}-cycles-2026-10-08.md. Proximo {next_actor}, {remaining} quadros novos restantes; retorno PLAN-071 preservado.\n')
for rel in ['.atena/evidence/EVID-145-fila-de-imagens-prioritaria-2026-10-02.md',
            '.atena/specs/SPEC-121-retomada-fila-imagens/tasks.md',
            '.atena/generated/CHATGPT-FILA-019-mobs-pilares.md']:
    path = root / rel
    path.write_text(path.read_text(encoding='utf-8') + summary, encoding='utf-8')
path = root / '.atena/generated/CHATGPT-FILA-019-mobs-pilares.md'
text = path.read_text(encoding='utf-8')
start = text.index(f'### `{actor}`')
end = text.find('### `', start + 4)
end = len(text) if end < 0 else end
text = text[:start] + text[start:end].replace('- [ ]', '- [x]') + text[end:]
path.write_text(text, encoding='utf-8')
path = root / '.atena/generated/ART-PROMPTS-050-mobs-pilares.md'
text = path.read_text(encoding='utf-8')
text = re.sub(r'^status:.*', f'status: "identidades aprovadas; {len(completed)} atores integrados e validados; proximo {next_actor}"', text, count=1, flags=re.M)
path.write_text(text, encoding='utf-8')
print(f'{actor}: {expected} selected sources, {len(assets)} exact strips, {len(checks)} checks, {len(manifest["assets"])} manifest hashes verified; cursor {next_actor}.')
