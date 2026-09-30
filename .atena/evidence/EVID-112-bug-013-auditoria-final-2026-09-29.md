# EVID-112A — Auditoria final do BUG-013

Data: 2026-09-29  
Origem: `data/prop_visuals.json`, `assets/props/*.png`.

A diferença é estimada para altura de renderização de 80 px. Valor positivo significa que a âncora fica abaixo da base opaca e a arte aparenta flutuar.

| Asset | Base opaca | Âncora | Dif. px | Veredito |
|---|---:|---:|---:|---|
| `barril_01.png` | 0.914 | 0.910 | -0.3 | ok |
| `barril_02.png` | 0.883 | 0.879 | -0.3 | ok |
| `barril_03.png` | 0.844 | 0.840 | -0.3 | ok |
| `bolha_01.png` | 0.961 | 0.961 | +0.0 | ok |
| `bolha_02.png` | 0.875 | 0.875 | +0.0 | ok |
| `bolha_03.png` | 0.930 | 0.930 | +0.0 | ok |
| `braseiro_01.png` | 0.895 | 0.891 | -0.3 | ok |
| `braseiro_02.png` | 0.895 | 0.891 | -0.3 | ok |
| `braseiro_03.png` | 0.918 | 0.914 | -0.3 | ok |
| `cachoeira_01.png` | 0.953 | 0.953 | +0.0 | ok |
| `cachoeira_02.png` | 0.984 | 0.984 | +0.0 | ok |
| `cachoeira_03.png` | 0.922 | 0.922 | +0.0 | ok |
| `caixote_01.png` | 0.977 | 0.957 | -1.6 | ok |
| `caixote_02.png` | 0.875 | 0.871 | -0.3 | ok |
| `caixote_03.png` | 0.945 | 0.957 | +0.9 | ok |
| `carga_01.png` | 0.855 | 0.851 | -0.4 | ok |
| `carga_02.png` | 0.758 | 0.754 | -0.3 | ok |
| `carga_03.png` | 0.805 | 0.801 | -0.3 | ok |
| `cogumelo_01.png` | 0.961 | 0.961 | +0.0 | ok |
| `cogumelo_02.png` | 0.926 | 0.926 | +0.0 | ok |
| `cogumelo_03.png` | 0.820 | 0.820 | +0.0 | ok |
| `coluna_01.png` | 0.949 | 0.949 | +0.0 | ok |
| `corrente_01.png` | 0.723 | 0.723 | +0.0 | ok |
| `corrente_02.png` | 0.852 | 0.852 | +0.0 | ok |
| `cristal_01.png` | 0.965 | 0.965 | +0.0 | ok |
| `cristal_02.png` | 0.883 | 0.883 | +0.0 | ok |
| `cristal_03.png` | 0.922 | 0.922 | +0.0 | ok |
| `doca_01.png` | 0.746 | 0.746 | -0.0 | ok |
| `doca_02.png` | 0.801 | 0.801 | +0.0 | ok |
| `doca_03.png` | 0.750 | 0.750 | +0.0 | ok |
| `espelho_ornado_01.png` | 0.961 | 0.961 | +0.0 | ok |
| `esporo_01.png` | 0.918 | 0.918 | +0.0 | ok |
| `esporo_02.png` | 0.973 | 0.973 | +0.0 | ok |
| `estalactite_01.png` | 0.961 | 0.961 | +0.0 | ok |
| `estalactite_02.png` | 0.809 | 0.809 | +0.0 | ok |
| `flor_01.png` | 0.742 | 0.742 | +0.0 | ok |
| `fragmento_01.png` | 0.871 | 0.871 | +0.0 | ok |
| `lanterna_01.png` | 0.879 | 0.879 | +0.0 | ok |
| `lanterna_02.png` | 0.910 | 0.910 | +0.0 | ok |
| `livros_01.png` | 0.930 | 0.926 | -0.3 | ok |
| `livros_02.png` | 0.914 | 0.910 | -0.3 | ok |
| `livros_03.png` | 0.871 | 0.867 | -0.3 | ok |
| `lodo_01.png` | 0.879 | 0.879 | +0.0 | ok |
| `margem_01.png` | 0.777 | 0.777 | -0.0 | ok |
| `margem_02.png` | 0.848 | 0.848 | +0.0 | ok |
| `margem_03.png` | 0.719 | 0.719 | +0.0 | ok |
| `nucleo_01.png` | 0.828 | 0.828 | +0.0 | ok |
| `osso_01.png` | 0.727 | 0.727 | +0.0 | ok |
| `ossos_01.png` | 0.734 | 0.734 | -0.0 | ok |
| `ossos_02.png` | 0.719 | 0.719 | +0.0 | ok |
| `ossos_03.png` | 0.730 | 0.730 | -0.0 | ok |
| `pilar_01.png` | 1.000 | 1.000 | +0.0 | ok |
| `pilar_02.png` | 0.863 | 0.863 | +0.0 | ok |
| `pilar_03.png` | 0.988 | 0.988 | +0.0 | ok |
| `pilar_abissal_01.png` | 0.973 | 0.950 | -1.8 | ok |
| `pilar_abissal_02.png` | 0.969 | 0.948 | -1.7 | ok |
| `pilar_abissal_03.png` | 0.965 | 0.946 | -1.5 | ok |
| `rede_01.png` | 0.906 | 0.906 | -0.0 | ok |
| `rede_02.png` | 0.816 | 0.816 | -0.0 | ok |
| `rede_03.png` | 0.781 | 0.781 | -0.0 | ok |
| `resina_01.png` | 0.750 | 0.750 | +0.0 | ok |
| `rocha_01.png` | 0.953 | 0.935 | -1.4 | ok |
| `rocha_02.png` | 0.859 | 0.855 | -0.4 | ok |
| `rocha_03.png` | 0.918 | 0.918 | +0.0 | ok |
| `runa_01.png` | 0.863 | 0.863 | +0.0 | ok |
| `sino_01.png` | 0.891 | 0.891 | +0.0 | ok |
| `taca_01.png` | 0.848 | 0.848 | +0.0 | ok |
| `taca_dourada_01.png` | 0.809 | 0.809 | +0.0 | ok |
| `torii_01.png` | 0.961 | 0.961 | +0.0 | ok |
| `torii_02.png` | 0.949 | 0.949 | +0.0 | ok |
| `torii_03.png` | 0.961 | 0.961 | +0.0 | ok |
| `velas_01.png` | 0.887 | 0.883 | -0.3 | ok |
| `velas_02.png` | 0.844 | 0.840 | -0.3 | ok |
| `velas_03.png` | 0.934 | 0.930 | -0.3 | ok |
| `veu_01.png` | 0.887 | 0.887 | +0.0 | ok |

Fora da tolerância de 2 px: **0** — nenhum.
