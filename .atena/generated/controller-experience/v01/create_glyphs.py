from pathlib import Path

root = Path(__file__).resolve().parents[4]
letters = {
    'A': 'M0 16 L5 0 L10 16 M2 10 H8', 'B': 'M0 16 V0 H5 Q12 0 9 7 Q14 16 5 16 Z M0 7 H6',
    'X': 'M0 0 L10 16 M10 0 L0 16', 'Y': 'M0 0 L5 8 L10 0 M5 8 V16',
    'L': 'M0 0 V16 H10', 'R': 'M0 16 V0 H5 Q13 0 9 8 H0 M5 8 L11 16',
    'S': 'M10 2 Q0 -3 0 5 Q0 9 5 9 Q13 9 10 15 Q5 19 0 14',
    '1': 'M1 4 L6 0 V16 M1 16 H11', '3': 'M0 0 H8 L3 7 Q13 7 10 14 Q6 19 0 14',
}

def text_paths(text):
    width = len(text) * 14 - 4
    return ''.join(f'<path transform="translate({32-width/2+i*14},8)" d="{letters[c]}"/>' for i, c in enumerate(text))

for family in ['xbox', 'ps4', 'ps5', 'generic']:
    folder = root / 'assets/icons/controller' / family
    folder.mkdir(parents=True, exist_ok=True)
    for button in [0, 1, 2, 3, 4, 6, 7, 8, 9, 10]:
        frame = '<rect x="4" y="2" width="56" height="28" rx="8" fill="#16131e" stroke="#d9c68a" stroke-width="2"/>'
        shape = ''
        if button <= 3:
            if family in ['ps4', 'ps5']:
                shape = [
                    '<path d="M25 9L39 23M39 9L25 23"/>',
                    '<circle cx="32" cy="16" r="9"/>',
                    '<rect x="24" y="8" width="16" height="16"/>',
                    '<path d="M32 6L43 25H21Z"/>',
                ][button]
            elif family == 'generic':
                shape = ['<path d="M24 12L32 22L40 12"/>', '<path d="M28 8L38 16L28 24"/>', '<path d="M36 8L26 16L36 24"/>', '<path d="M24 20L32 10L40 20"/>'][button]
            else:
                shape = text_paths('ABXY'[button])
        elif button == 4:
            if family == 'ps4':
                shape = '<path d="M22 21V15Q22 10 31 10H40M35 5L40 10L35 15"/>'
            elif family == 'ps5':
                shape = '<path d="M23 23L29 17M32 6V14M41 23L35 17"/>'
            else:
                shape = '<rect x="22" y="8" width="14" height="12"/><rect x="28" y="12" width="14" height="12"/>'
        elif button == 6:
            shape = '<path d="M22 9H42M22 16H42M22 23H42"/>'
        elif button in [7, 8]:
            shape = text_paths(('L' if button == 7 else 'R') + ('3' if family in ['ps4', 'ps5'] else 'S'))
        else:
            shape = text_paths(('L' if button == 9 else 'R') + ('1' if family in ['ps4', 'ps5'] else 'B'))
        svg = f'<svg xmlns="http://www.w3.org/2000/svg" width="64" height="32" viewBox="0 0 64 32">{frame}<g fill="none" stroke="#f1e8cb" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">{shape}</g></svg>\n'
        (folder / f'{button}.svg').write_text(svg, encoding='utf-8')
    for name, shape in {
        'move': '<circle cx="32" cy="16" r="7"/><path d="M19 16H9M13 12L9 16L13 20M45 16H55M51 12L55 16L51 20"/>',
        'aim': '<circle cx="32" cy="16" r="9"/><path d="M32 2V11M32 21V30M18 16H27M37 16H46"/>',
        'dpad': '<path d="M27 4H37V11H44V21H37V28H27V21H20V11H27Z"/>',
    }.items():
        (folder / f'{name}.svg').write_text(f'<svg xmlns="http://www.w3.org/2000/svg" width="64" height="32" viewBox="0 0 64 32">{frame}<g fill="none" stroke="#f1e8cb" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">{shape}</g></svg>\n', encoding='utf-8')
print('52 icones vetoriais locais criados.')
