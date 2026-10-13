from pathlib import Path
import hashlib
import json

base = Path(__file__).parent
root = base.parents[2]
receipt = json.loads((base/'owner-approval.json').read_text(encoding='utf-8'))
register = root/'.atena/vault/canon/ASSET-APPROVAL-FILA026-G2-v01.md'
lines = ['# FILA-026 — nove revisões v01 aceitas no G2', '',
         'Data: 2026-10-11. PLAN-065 / SPEC-132. Resposta explícita do dono: **“Aprovo as nove revisões v01”**, à pergunta que nomeou individualmente L03, L04, L05, P01, P02, P03, C01, C02 e C03 v01.', '',
         'As nove fontes e seus derivados preparados exibidos na galeria são promovidos a **CANON_VISUAL_G2**. O aceite inclui capitulares góticas estilizadas de L03/L04, leitura/contraste e cursores em 32/40 px. Essa promoção é visual; admissão, integração, commit, push, build e publicação não foram autorizados por esta resposta. L01 v01 mantém seu registro G1 separado; L02 opcional continua deferida.', '',
         '[Recibo com hashes](../../generated/fila026-remaining-2026-10-11/owner-approval.json) · [Galeria aceita](../../generated/fila026-remaining-2026-10-11/index.html) · [Auditoria técnica](../../generated/fila026-remaining-2026-10-11/audit.json).', '',
         '| Peça | Final | SHA256 fonte | SHA256 preparado |', '|---|---|---|---|']
for r in receipt['records']:
    lines.append(f"| {r['code']} {r['revision']} | {r['size'][0]}×{r['size'][1]} | `{r['source_sha256']}` | `{r['prepared_sha256']}` |")
lines.extend(['', 'Identidade N/A: assets de UI, sem personagem/entidade ou lore nova. Referências locais e direção de L01 v01 foram verificadas na produção. Os hotspots aceitos são C01 (1,1), C02 (4,1) e C03 (20,20); permanecem fora de `data/cursor.json` até admissão autorizada.', '',
              'Próximo objetivo: S-013, revisar e autorizar a admissão dos dez PNGs aceitos (L01 + estas nove peças), com hotspots reais. Manifesto proposto em [admission-proposal.json](../../generated/fila026-remaining-2026-10-11/admission-proposal.json). S-014 integra os usos restantes e S-015 verifica funcionamento/capturas. Nenhuma dessas etapas é declarada implementada pelo aceite visual.'])
register.write_text('\n'.join(lines)+'\n', encoding='utf-8')

destinations = {
    'L01': 'assets/ui/title/logo.png',
    'L03': 'assets/ui/lettering/banner_vitoria.png',
    'L04': 'assets/ui/lettering/banner_derrota.png',
    'L05': 'assets/ui/lettering/banner_evolucao.png',
    'P01': 'assets/ui/lettering/placa_titulo_larga.png',
    'P02': 'assets/ui/lettering/placa_titulo_secao.png',
    'P03': 'assets/ui/lettering/placa_chefe.png',
    'C01': 'assets/ui/cursor/cursor_ponteiro.png',
    'C02': 'assets/ui/cursor/cursor_mao.png',
    'C03': 'assets/ui/cursor/cursor_mira.png',
}
entries = []
for code, destination in destinations.items():
    source = base.parent/'fila026-l01-2026-10-11/prepared/L01_v01.png' if code=='L01' else base/f'prepared/{code}_v01.png'
    target = root/destination
    entries.append(dict(code=code, revision='v01', source=source.relative_to(root).as_posix(),
                        sha256=hashlib.sha256(source.read_bytes()).hexdigest(), destination=destination,
                        destination_exists=target.exists(), runtime_admission=False))
proposal = dict(plan='PLAN-065', step='S-013', status='PROPOSED_NOT_EXECUTED', png_count=10,
                entries=entries, data_change=dict(path='data/cursor.json', hotspots={'cursor_ponteiro':[1,1], 'cursor_mao':[4,1], 'cursor_mira':[20,20]}),
                behavior='Admission may activate the logo and cursor immediately through existing code. Remaining UI hookups are S-014.',
                checks=['Accepted PNG hashes match before copy', 'No unapproved overwrite', 'Manifest/register and Godot imports', 'Existing cursor and lettering checks'],
                required_approval='Explicit runtime admission authorization; G2 only accepts visuals.',
                commit=False, push=False, build=False)
(base/'admission-proposal.json').write_text(json.dumps(proposal, ensure_ascii=False, indent=2)+'\n', encoding='utf-8')
print(json.dumps(dict(register=register.relative_to(root).as_posix(), admission_proposed=10,
                      existing_destinations=[r['destination'] for r in entries if r['destination_exists']])))
