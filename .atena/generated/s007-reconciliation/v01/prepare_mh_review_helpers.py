from pathlib import Path
out=Path(__file__).parent
p=out/'review_m_sequence.py';assert not p.exists()
t=(out/'review_n_sequence.py').read_text(encoding='utf-8').replace('nm-generation-jobs','mh-generation-jobs').replace('n03-owner-gate','m03-owner-gate').replace('pulso-radiante','ampulheta-silencio').replace("'N0","'M0").replace('for N01-N04','for M01-M04')
p.write_text(t,encoding='utf-8')
p=out/'review_h103.py';assert not p.exists()
t=(out/'review_m03.py').read_text(encoding='utf-8').replace('nm-generation-jobs','mh-generation-jobs').replace('M03','H103').replace('m03-reference-comparison','h103-reference-comparison').replace('ampulheta silencio','Ruptura Sombria Durvall')
p.write_text(t,encoding='utf-8')
print('Two native review helpers prepared; previews only, no source edits')
