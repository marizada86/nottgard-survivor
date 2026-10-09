from pathlib import Path
out=Path(__file__).parent
src=(out/'review_q_sequence.py').read_text(encoding='utf-8')
src=src.replace('qr-generation-jobs','rn-generation-jobs').replace('q01-owner-gate','r01-owner-gate').replace('orbe-arcano','onda-cortante').replace("'Q0","'R0")
src=src.replace('not exact ring pivot','not exact crescent pivot')
p=out/'review_r_sequence.py';assert not p.exists();p.write_text(src,encoding='utf-8')
src=(out/'review_r01.py').read_text(encoding='utf-8').replace('qr-generation-jobs','rn-generation-jobs').replace('R01','N03').replace('r01-reference-comparison','n03-reference-comparison').replace('onda cortante','pulso radiante')
p=out/'review_n03.py';assert not p.exists();p.write_text(src,encoding='utf-8')
print('Review helpers prepared; no native images modified.')
