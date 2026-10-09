from pathlib import Path
out=Path(__file__).parent;s=(out/'review_n03.py').read_text(encoding='utf-8').replace('rn-generation-jobs','nm-generation-jobs').replace('N03','M03').replace('n03-reference-comparison','m03-reference-comparison').replace('pulso radiante','ampulheta silencio');p=out/'review_m03.py';assert not p.exists();p.write_text(s,encoding='utf-8');print('M03 review helper ready.')
