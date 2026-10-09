from pathlib import Path
import json

root = Path(__file__).resolve().parents[4]
out = Path(__file__).parent
source_id = 'cultista_de_socothbenoth'
actor_id = 'ilusao_de_socothbenoth'
base = root / '.atena/generated/art-candidates/enemies-goranthis' / source_id
packing = json.loads((base / 'strips/packing.json').read_text())
for state in ['idle', 'move', 'attack', 'death']:
    assert (root / 'assets/animations/enemies' / source_id / f'{state}.png').read_bytes() == (base / 'strips' / f'{state}.png').read_bytes()
height = int(packing['body_height'] + .5)
path = root / 'ui/enemy_view.gd'
text = path.read_text(encoding='utf-8-sig')
assert f'"{actor_id}":' not in text, 'Reuse already registered; inspect before rerunning.'
states = '"idle": 4, "move": 6, "attack": 4, "death": 6'
entry = f'\t"{actor_id}": {{"source_id": "{source_id}", "cell": Vector2i(256, 384), "body_height": {height}.0, "states": {{{states}}}, "flip_h_for_move": true}},'
text = text.replace('const ANIMATED := {', 'const ANIMATED := {\n' + entry, 1)
text = text.replace('const FEET_Y := {', f'const FEET_Y := {{\n\t"{actor_id}": 356.0,', 1)
path.write_text(text, encoding='utf-8')
path = root / 'tests/test_animation_assets.gd'
text = path.read_text(encoding='utf-8-sig')
assert f'"{actor_id}":' not in text
states = '&"idle": 4, &"move": 6, &"attack": 4, &"death": 6'
entry = f'\t"{actor_id}": {{"source_id": "{source_id}", "cell": Vector2i(256, 384), "states": {{{states}}}}},'
text = text.replace('const WAVE_ONE_ENEMY_ANIMATIONS := {', 'const WAVE_ONE_ENEMY_ANIMATIONS := {\n' + entry, 1)
path.write_text(text, encoding='utf-8')
receipt = dict(date='2026-10-08', actor=actor_id, source_id=source_id, native_pngs_generated=0,
               body_height=height, feet_y=356, states=dict(idle=4, move=6, attack=4, death=6),
               existing_alpha=.45, status='REGISTERED_AWAITING_RUNTIME',
               authorization='ART-PROMPTS-049 reuse rule under approved PLAN-053/SPEC-121.',
               static_asset_preserved=True, combat_data_unchanged=True)
(out / 'illusion-reuse-integration-receipt.json').write_text(json.dumps(receipt, indent=2) + '\n')
print(f'{actor_id}: registered {source_id}, no new PNG, existing alpha .45; validate runtime next.')
