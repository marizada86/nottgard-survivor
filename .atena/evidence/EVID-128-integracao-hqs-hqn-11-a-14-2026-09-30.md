---
id: "EVID-128"
title: "Integração das HQN-11 a HQN-14"
created: "2026-09-30"
relations:
  - "[[SPEC-099-integracao-hqs-hqn-11-a-14]]"
  - "[[ART-PROMPTS-029-hqs-onda-2]]"
  - "[[EVID-124-hqn-11-a-14-candidatas-2026-09-30]]"
---

# EVID-128 — Integração das HQN-11 a HQN-14

## Escopo e integridade

As 16 imagens finais aprovadas foram admitidas em `assets/hq/`, sem edição. As
fontes permanecem preservadas em `.atena/generated/art-candidates/hq/`. Todas
têm 1672×941 px. HQN-14 Q1 usa `hq_n14_q1_v02.png`; a v01 anterior permanece
preservada fora do jogo. SHA-256 de cada destino foi comparado com a candidata
final correspondente; resultado: 16/16 correspondências.

| Arquivo em `assets/hq/` | SHA-256 |
|---|---|
| `hq_n11_q1.png` | `eb001ceba4cd99e2cfdac9277cb16125090cb6948928dc436501d7d65309aa04` |
| `hq_n11_q2.png` | `2258503f4d4283d974186f3d849667ab6664c782e19cce1d9eee5ea92853c142` |
| `hq_n11_q3.png` | `4dd10234a0a9c5fe342cbc294d3207a2a04a1edb775ceae6e33087820b2838d3` |
| `hq_n11_q4.png` | `4c44fbf01dee6fa34b6e413dd5fbad3ae06d9ee609ce6fc24fb4d9294445c478` |
| `hq_n12_q1.png` | `7aa2cb4aa296758b092ddd8373735fdb2da2b13e3d8fc0b7fc1fa0470c5254ff` |
| `hq_n12_q2.png` | `f8873015741439ae8a5d4ec00edc097312087879cb00f706914051cce64e04f0` |
| `hq_n12_q3.png` | `bee89493fc7bd681886e436ba8ac305cb5e50438159aac7537b47e5494fc9817` |
| `hq_n12_q4.png` | `8ab100f4dacbbece5abd8711dbff2cc0c0cbdd8ae094342738bf2d7520da51be` |
| `hq_n13_q1.png` | `b2a892130b09b78444c96b81b38235f7b6daa5e6bfae76310b1c6de826c0d893` |
| `hq_n13_q2.png` | `7e7977dfbe8fa3b666a5bc5d0688373788685533984ab12427d6da3c48f48372` |
| `hq_n13_q3.png` | `b7dfefbf827e1b4ad1bb121f6b558793f6a198f63e0dbc072f62abf92b977f83` |
| `hq_n13_q4.png` | `3259baaf6e7c30e7479890f54fc91926e6a66bae18879217eb5628124580e00e` |
| `hq_n14_q1.png` | `e355bd3850af28da13884382c4106b957321317353fcdd141f3c27684c5ef727` |
| `hq_n14_q2.png` | `287335149c247dbecf98da56504460a230238f928232f3738efe7e32114db8fe` |
| `hq_n14_q3.png` | `bc3ba59a87783bcc66c761852f39f6a47a9de111afd611074fc5e294e5e0cd55` |
| `hq_n14_q4.png` | `d45f7cfbc4412a8bcdfd833a15c2fb527180ab2818323a72712480db80f7688e` |

## Integração e validação

- `data/hqs.json` registra quatro HQs, cada uma com quatro quadros, captions
  aprovadas e a conquista existente correspondente: HQN-11 →
  `cacador_de_chefes`; HQN-12 → `aluris`; HQN-13 → `mestre_de_camadas`; HQN-14
  → `pilares_ativos`.
- O leitor abre após uma nova conquista, antes do resultado da run; clique,
  Enter ou Espaço avança, Esc encerra. A aba Diário só lista HQs liberadas e
  permite revê-las, inclusive em saves antigos. O esquema do save não mudou.
- A imagem ocupa o retângulo de tela cheia com `KEEP_ASPECT_CENTERED`, evitando
  deformação ou corte também em 1280×720 e 1920×1080. A validação do layout foi
  estrutural; não foi capturada uma sessão visual interativa nessas resoluções.
- `rtk proxy godot --headless --path . -s tests/run_all.gd`: exit code 0;
  `testes: 0 falha(s)`.
- `rtk proxy godot --headless --path . res://tools/smoke.tscn --quit-after 120`:
  exit code 0.
- A importação do editor Godot terminou com exit code 0 e identificou os 16
  PNGs. Os ambientes headless exibiram avisos de escrita em
  `user://logs/godot.log`, leitura da loja de certificados e recursos residuais;
  não houve falha de teste nem erro de script após a correção do leitor.
- `git diff --check`: limpo antes dos commits.

## Commits e publicação

- Branch: `codex/hq-story-integration`.
- Arte e atualização de `ART-PROMPTS-029`: `11d0c600c176d84f8cd25b4162ffa7ab782b75c1`.
- Mecânicas, leitor, Diário, SPEC e testes: `fab9e012d12684c2d0956bcab1a12167d1c9a9bc`.
- Push para `origin/codex/hq-story-integration` concluído em 2026-09-30; o
  comando retornou sucesso e configurou o upstream. Nenhum PR ou merge foi
  criado.
- O remoto informou que o repositório mudou para
  `https://github.com/marizada86/nottgard-survivor`; o push foi aceito pelo URL
  atualmente configurado em `origin`.
