# EVID-085 — Correção fiel do Rio Estige

Data: 2026-09-27  
Escopo: execução do PLAN-027 e da SPEC-055.

## Resultado

O contrato ambiental agora é `styx_memory` e aparece somente em Shedaklah,
Durao, Shendilavri e Goranthis. Ele preserva o Teste de Lucidez e o
Esquecimento aprovados na SPEC-039. Dagruve, Docas, Molor, Feng-tu e Pilares
não declaram o contrato, não possuem zona de Estige e não iniciam exposição.

Foram removidos da implementação: gelatina de Juiblex, Chamado, derrota por
cronômetro, imbuimento de raros e qualquer empurrão atribuído ao rio. A rotação
de Pilares continua independente.

## Validação automatizada

- `godot --headless --path . -s tests/run_all.gd`: `testes: 0 falha(s)`.
- `godot --headless --path . res://tools/smoke.tscn`: `smoke: ok`, com os nove
  andares em estado `running`.
- A matriz de batalha cobre entrada e Esquecimento nos quatro mapas e garante
  que os outros cinco não têm contrato nem exposição.
- A matriz de terreno confirma presença apenas nos quatro trechos documentados
  e água ausente nos cinco mapas excluídos.

Os avisos de certificado, log `user://` e recursos de renderização em modo
headless são preexistentes e não fatais; ambos os comandos terminaram com
sucesso.

## Capturas locais

| Andar | Evidência | SHA-256 |
| --- | --- | --- |
| Shedaklah | `EVID-085-estige-shedaklah-2026-09-27.png` | `0E0135578BE1F7D30E9E133EB0D1DAC3FCE28F013964916A5DACEAA2312B7C06` |
| Durao | `EVID-085-estige-durao-2026-09-27.png` | `F673355C61E68062FCEC67D39150D5E52C065D2EAADA88F282FB3D8B30F7BA10` |
| Shendilavri | `EVID-085-estige-shendilavri-2026-09-27.png` | `E19FD26B79B87F6E2E62653F9D299C0A440D52D0C2A851542C8C756C39D32919` |
| Goranthis | `EVID-085-estige-goranthis-2026-09-27.png` | `4A8E05D3778D007EB127484092F53377E1479B0520DD2C67960BCF7DB704731E` |

Inspeção visual independente em Durao confirma água lenta, HUD de exposição e
feedback de falha de Lucidez, sem indicador de Chamado ou efeito de raro.

## Reconciliação

A seção 25 do `PLAN-001-nottgard-survivors.md` é a decisão canônica vigente.
PLAN-023, SPEC-054 e EVID-084 foram preservados e marcados como supersedidos;
SPEC-039 foi reconciliada para conservar apenas Lucidez/Esquecimento, e
SPEC-040 foi marcada como histórico supersedido.
