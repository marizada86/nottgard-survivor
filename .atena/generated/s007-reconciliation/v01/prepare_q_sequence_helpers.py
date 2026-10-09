from pathlib import Path
out=Path(__file__).parent
src=(out/'review_p_sequence.py').read_text(encoding='utf-8')
src=src.replace('pq-generation-jobs','qr-generation-jobs').replace('p01-owner-gate','q01-owner-gate').replace('orbe-radiante','orbe-arcano').replace("'P0","'Q0")
assert "['Q01','Q02','Q03','Q04','Q05','Q06','Q07','Q08']" in src
dest=out/'review_q_sequence.py';assert not dest.exists();dest.write_text(src,encoding='utf-8')
print('Q sequence preview and source/hash/flight-center audit prepared.')
