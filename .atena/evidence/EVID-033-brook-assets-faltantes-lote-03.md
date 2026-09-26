# EVID-033 — Lote de fontes faltantes de Brook

Data: 2026-09-25

## Escopo executado

`BATCH-brook-missing-sources-03` gerou quatro folhas candidatas, sem
normalização, integração, commit ou publicação.

| Prompt | Candidata | Resultado atual |
|---|---|---|
| `HERO-brook-move_s` | `move_s_v01.png` | rejeitada em QA: orelhas pontudas; `move_s_v02.png` aceita e integrada em 2026-09-25 |
| `HERO-brook-attack` | `attack_v01.png` | aceita visualmente em 2026-09-25 |
| `HERO-brook-active` | `active_v03.png` | aceita visualmente em 2026-09-25 |
| `HERO-brook-death` | `death_v01.png` | aceita visualmente em 2026-09-25 |

Todas estão em `.atena/generated/animation-candidates/heroes/brook/` e têm
matriz 1024×1536, formato PNG RGBA e alfa zero no canto superior esquerdo.
Esse teste confirma transparência real na área vazia; não é uma aprovação de
recorte, grade final ou integração.

## Exceção de referências

O lote foi aprovado com `assets/portraits/brook.png` e
`assets/heroes/brook.png` como referências autorizadas. Na inspeção, ambas
exibem orelhas pontudas legadas, em conflito com a regra canônica de orelhas
anãs curtas e arredondadas. Elas foram usadas apenas em `move_s_v01`, com a
orelha explicitamente excluída, mas a saída ainda falhou. As três chamadas
posteriores não transmitiram referências locais e usaram somente as restrições
canônicas do prompt.

## Próximo gate

O usuário aprovou visualmente `attack_v01`, `active_v03` e `death_v01` em
2026-09-25. Essa aprovação não autoriza recorte, normalização ou alteração de
`assets/`; essas ações continuam sujeitas a um gate separado.

## Normalização e integração autorizadas

Após a instrução do usuário para continuar, as três candidatas aceitas foram
normalizadas sem sobrescrever nenhum arquivo existente e integradas como:

- `assets/animations/heroes/brook/attack.png` — 1024×384;
- `assets/animations/heroes/brook/active.png` — 1536×384;
- `assets/animations/heroes/brook/death.png` — 1536×384.

As três tiras passaram pela verificação estática de dimensão, pixels visíveis e
alfa transparente no canto. `tests/test_animation_assets.gd` passou a exigir
esses três destinos. A suíte Godot e a verificação de importação não foram
executadas porque não há executável Godot disponível neste ambiente.

## Movimento sul recuperado

Após a aprovação visual de `move_s_v02`, a tira foi normalizada e integrada em
`assets/animations/heroes/brook/move_s.png` com 1536×384 e alfa transparente.
O teste de assets agora também exige esse destino. O conjunto operacional de
Brook passa a ter as cinco fontes de caminhada; oeste, noroeste e sudoeste são
derivados por espelhamento no runtime.
