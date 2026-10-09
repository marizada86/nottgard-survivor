from pathlib import Path
p=Path(__file__).parent/'finalize_p_q01_gate.py';t=p.read_text(encoding='utf-8')
old='Q01 v01 preservada e rejeitada por deslocamento à direita; v02 corrige a posição com imagegen nativo.'
assert old in t
t=t.replace(old,'Q01 v01/v02 preservadas e rejeitadas pelo deslocamento do núcleo à direita. Q01 v03 corrige o alinhamento com imagegen nativo; centro luminoso como proxy difere menos de0,23% por eixo do centro da tela, sem alegar pivô geométrico exato. [Auditoria de posição](../generated/s007-reconciliation/v01/q01-centering-audit-2026-10-09.json).')
t=t.replace("source_hashes_verified=9,manifest_assets=202", "source_hashes_verified=9,rejected_native_hashes_verified=2,manifest_assets=202")
p.write_text(t,encoding='utf-8')
print('Selected v03 correction and two preserved rejected native versions recorded truthfully.')
