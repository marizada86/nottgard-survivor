---
id: "EVID-133"
title: "Inventário das animações e efeitos visuais dos heróis"
created: "2026-09-30"
relations:
  - "[[SPEC-105-inventario-animacoes-e-efeitos-herois]]"
  - "[[PLAN-049-animacoes-integrais-dos-herois-2026-09-30]]"
  - "[[HERO-ANIMATION-INVENTORY-001]]"
  - "[[EVID-129-auditoria-piloto-movimento-herois-2026-09-30]]"
  - "[[EVID-132-piloto-runtime-escala-direcional-durvall-2026-09-30]]"
---

# EVID-133 — Inventário das animações e efeitos visuais dos heróis

## Resultado

O inventário cobriu os dez heróis e leu **106 PNGs oficiais** sob
`assets/animations/heroes/`. Todos os 106 arquivos têm células
`256×384`, tiras com quantidade esperada (4 quadros para idle/attack e 6
para movimento/active/death), nenhum quadro alfa vazio e nenhuma falha de grade.
A medição usou alfa ≥10%; largura/altura inclui arma e pixels de efeito — não
isola anatomia. 47 folhas têm pelo menos um quadro com alfa a 1 px
da borda (somando 219 quadros); é indicador para inspeção, não
reprovação automática.

Matriz e medidas por folha: [[HERO-ANIMATION-INVENTORY-001]].

## Cobertura direcional

O runtime atualmente carrega cinco fontes (`n`, `ne`, `e`, `se`, `s`)
e espelha oeste, noroeste e sudoeste. PLAN-001 §26 aprova oito fontes
independentes. O estado encontrado:

| Heróis | Fontes disponíveis | Situação |
|---|---:|---|
| Durvall, Kayron, Korrak, Maelor e Sylas | 8/8 | Três folhas opostas existem, mas não são carregadas pelo runtime. |
| Brook, Bromnor, Leoric, Nyrelia e Zynara | 5/8 | Faltam `move_sw`, `move_w`, `move_nw` em cada herói. |

Logo, **15 das 80 folhas direcionais-alvo faltam**; outras 15 existem como
arquivos, mas ainda exigem validação e não são consumidas. A cobertura lógica
atual continua funcionando por espelhamento.

## Medidas de proporção

Faixas de movimento são as medianas de altura alfa nas fontes que existem. A
base mostra a faixa das linhas inferiores medianas entre direções (variação em
pixels-fonte). Estados usam largura × altura alfa mediana por folha:

| Herói | Movimentos | Faltam | Altura movimento | Base mediana (faixa; var.) | Idle | Attack | Active |
|---|---:|---|---:|---|---:|---:|---:|
| Durvall | 8/8 | — | 211–368 | 376–376 (0) | 240×293 | 240×284 | 240×238 |
| Brook França | 5/8 | move_sw, move_w, move_nw | 245–360 | 368–368 (0) | 232×259 | 232×276 | 232×222 |
| Maelor | 8/8 | — | 302–369 | 361–377 (16) | 256×345 | 243×332 | 256×307 |
| Sylas Malafaia | 8/8 | — | 303–349 | 352–374 (22) | 254×373 | 251×369 | 253×207 |
| Kayron Lioran | 8/8 | — | 327–363 | 356–373 (17) | 248×371 | 246×355 | 253×321 |
| Korrak Nammat | 8/8 | — | 278–368 | 328–374 (46) | 246×316 | 247×322 | 221×355 |
| Leoric | 5/8 | move_sw, move_w, move_nw | 215–244 | 368–368 (0) | 225×313 | 236×255 | 230×266 |
| Nyrelia | 5/8 | move_sw, move_w, move_nw | 298–352 | 368–368 (0) | 180×352 | 208×352 | 223×344 |
| Zynara Vellen | 5/8 | move_sw, move_w, move_nw | 367–368 | 376–376 (0) | 166×368 | 240×367 | 211×368 |
| Bromnor Martelo da Luz | 5/8 | move_sw, move_w, move_nw | 251–290 | 351–375 (24) | 246×343 | 248×296 | 256×250 |

Em Durvall, a base mediana é y=376 em
todas as direções. A pose lateral é baixa e horizontal: `move_e`
240×226px e `move_w`
240×211px, ambos com
largura 240px em idle (240×293px).
A razão alfa largura/altura é 1.06
em leste e 1.14 em
oeste; isso é silhueta, não escala aplicada pelo renderer. Ataque mede
240×284px; sua altura varia
236–294px nos quatro quadros, contra idle
240×293px. A sequência de ataque é única,
orientada à direita; `move_w` não é consumida hoje.

Leoric tem movimento disponível 215–244px
contra idle de 313px. Bromnor varia
24px na base mediana entre as folhas presentes.
Algumas folhas têm quadros a 1 px da borda; revisar margem/recorte quando arma
ou efeitos se aproximam da célula.

## Animações e facing das ações

`ui/hero_view.gd` carrega idle (4 quadros, 8 fps), cinco fontes de movimento
(6 quadros, 10 fps), attack (4 quadros, 12 fps), active (6 quadros, 12 fps) e
death (6 quadros, 9 fps); ações/death não fazem loop. Um `move.png` genérico
de seis quadros existe somente para Durvall. Todos compartilham escala uniforme
72/384; Nyrelia é a única com âncora y=368, os demais usam y=384.

O evento contém o vetor de mira, mas ele não é passado a `HeroView.play_action`.
O facing do sprite atualiza só durante movimento; attack/active mantêm o último
facing visual, que pode divergir do alvo. Melee e bolts iniciam `attack`; nova
e zone não. Não existe animação `hurt`: dano usa flash, tremor, número e
partículas procedurais.

## Armas, habilidades e efeitos

| Herói | Arma inicial (ID) | Habilidade ativa (nome; tipo) |
|---|---|---|
| Durvall | `espada_sombria` | Ruptura Sombria (`cleave`) |
| Brook França | `sentenca_de_lliira` | Guarda de Lliira (`guard`) |
| Maelor | `raio_de_luz` | Comunhão (`healing_aura`) |
| Sylas Malafaia | `raio_enfraquecedor` | Passo pelas Sombras (`dash_weaken`) |
| Kayron Lioran | `descarga_estelar` | Sobrecarga Mística (`overdrive`) |
| Korrak Nammat | `machado_de_xargath` | Impacto de Xar'gath (`slam`) |
| Leoric | `sopro_de_estrela` | Constelação (`star_burst`) |
| Nyrelia | `dominar_pessoa` | Dominação (`charm`) |
| Zynara Vellen | `ampulheta` | Suspensão Temporal (`time_stop`) |
| Bromnor Martelo da Luz | `martelo_da_gloria` | Concórdia (`guard_nova`) |

Fonte das identidades e tipos: `data/heroes.json`, `data/abilities.json` e
`data/weapons.json`. A habilidade ativa não é deduzida pelo nome da animação:
cada linha identifica o herói, sua arma inicial e o tipo de habilidade usado
pelo runtime.

Os 30 perfis de `data/weapons.json` dividem-se em 14 ofertas base de level-up
disponíveis a qualquer herói, 8 evoluções e 8 perfis concedidos por itens. A
lista abaixo conserva os IDs consultáveis e o `kind` que dirige o efeito visual
procedural observado; a disponibilidade de cada perfil continua condicionada
às regras existentes de evolução/item.

| `kind` | Ofertas base (14) | Evoluções (8) | Itens (8) |
|---|---|---|---|
| `melee` | `espada_sombria`, `golpe_esmagador`, `adaga_rapida`, `golpe_atordoante`, `estocada_mistica` | `espada_do_receptaculo`, `rajada_infinita`, `golpe_do_juizo` | `chicote_avarento`, `martelo_da_gloria`, `machado_de_xargath`, `lamina_da_digestao` |
| `bolt` | `raio_de_luz`, `raio_enfraquecedor`, `lamina_trovejante`, `dominar_pessoa`, `marca_da_retidao` | `luz_mais_pura`, `tempestade` | `cajado_dos_desejos` |
| `nova` | `sentenca_de_lliira`, `descarga_estelar`, `vela_sagrada` | `julgamento_da_gloria`, `chuva_de_estrelas` | `sopro_de_estrela`, `ampulheta` |
| `zone` | `cera_fervente` | `inferno_de_cera` | `colar_dos_tentaculos` |

O runtime não seleciona uma animação de corpo diferente pelo ID da arma. `melee`
e `bolt` disparam a folha `attack`; `nova` e `zone` não disparam essa folha e
usam seus efeitos de categoria. A próxima SPEC de Durvall deve dizer se usa
poses genéricas por família ou variantes por arma; as combinações
personagem×arma podem multiplicar o volume. Os perfis que compartilham `kind`
compartilham a implementação visual atual, não necessariamente a identidade
final da arte.

Os efeitos atuais são reutilizados e procedurais:
`melee` (5 bases): cone sweep drawn with `Polygon2D`; uses attack sheet.
`bolt` (5 bases): projectile drawn as circle plus directional line; uses attack sheet.
`nova` (3 bases): expanding procedural ring; does not trigger the attack sheet.
`zone` (1 base): procedural ring plus persistent typed area; wax and tentacle variants have code-drawn accents.

As dez habilidades próprias compartilham uma tira `active` por herói e o mesmo
anel procedural de ativação; os tipos são cleave, guard, healing aura, dash,
overdrive, slam, projéteis radiais, charm, time stop e guard-nova. Não há folhas
de gameplay VFX específicas por herói; a busca por "vfx/effect/projectile/
impact" encontra apenas ícones estáticos/áudio, não sequências de combate.

## Recomendação para a próxima SPEC — pacote Durvall

1. Definir o facing de ataque: oito orientações quando pose/arma exigir e como
   usar o vetor de mira; hoje ele orienta o efeito, não o sprite.
2. Tratar oito movimentos, ataque da espada, Ruptura Sombria, morte, transições
   e efeitos como um pacote revisável. Testar `move_e/move_w→attack→idle`.
3. Esclarecer o alcance de ataques-base universais: ponto inicial recomendado
   é uma pose por família com VFX compartilhado, e exceções por arma quando a
   pose/identidade exigir.
4. Conferir corpo, espada, brilhos e efeitos separadamente. Corrigir arte ou
   ancoragem, sem repetir fator uniforme por altura.

Isto é diagnóstico/recomendação, não aprovação da produção de Durvall. A
tentativa de perfil de escala em EVID-132 foi revertida; a escala atual é
uniforme. Nenhum PNG, código ou manifesto de produção mudou.

## Método e validação

A varredura somente leitura percorreu cada quadro (limiar alfa 10%) e guardou
largura, altura, linha inferior, quadros vazios e contato de borda na matriz:
[[HERO-ANIMATION-INVENTORY-001]].

EVID-129 cobre as cinco direções-fonte antigas. O artefato histórico
`.atena/generated/asset-audit/HERO-ANIMATION-AUDIT-001.json` registra 90
folhas com grade/alfa válidos e status `unreviewed`; ele não é aprovação
operacional atual por herói. Capturas do EVID-132 são históricas.

Nenhum arquivo em `assets/`, `data/`, `ui/` ou `core/` mudou; não houve
geração/alteração de candidatos nem atualização de manifesto de produção. Não
foram necessários testes ou smoke de gameplay para esta auditoria estática.

