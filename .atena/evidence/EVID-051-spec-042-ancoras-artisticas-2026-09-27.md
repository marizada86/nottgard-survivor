# EVID-051 — SPEC-042: âncoras artísticas e sombras de props

Data: 2026-09-27  
Estado: verificada localmente

## Resultado

Cada variante coberta usa uma ficha visual por caminho de asset. A arte é
desenhada pelo pé artístico normalizado; sua sombra só existe quando é
necessária, tem tamanho proporcional à arte e permanece sobreposta à base.
Props planos não recebem a elipse escura genérica.

## Cobertura

- Rochas e pilares abissais: três variantes de cada.
- Props de Dagruve e Docas: barril, braseiro, caixote, carga, livros, velas,
  doca, margem, ossos e rede — três variantes de cada.
- QA `prop_grounding`: cruz verde é a âncora lógica e contorno amarelo é a
  área da sombra dinâmica. Os guias só aparecem nesse alvo QA.

## Validações

| Verificação | Resultado |
| --- | --- |
| Suíte (`tests/run_all.gd`) | 0 falhas |
| Smoke das fases | OK: 9 fases carregadas |
| Captura 1280×720 | Dagruve, Docas, Durao e Pilares aprovadas |

Os avisos conhecidos do ambiente headless do Godot (log, certificados e
recursos no encerramento) não impediram testes ou smoke.

## Capturas

- `SPEC-042-dagruve-ancoras-2026-09-27.png`
- `SPEC-042-docas-ancoras-2026-09-27.png`
- `SPEC-042-durao-ancoras-2026-09-27.png`
- `SPEC-042-pilares-ancoras-2026-09-27.png`

## Mudanças reconciliadas

- `data/prop_visuals.json`
- `ui/prop.gd`
- `ui/run.gd`
- `core/battle.gd`
- `tests/test_prop_grounding.gd`
- `tests/test_prop_visuals.gd`
