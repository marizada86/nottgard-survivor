---
id: "EVID-084"
type: "evidência de execução"
status: "exceção de validação aceita"
date: "2026-09-27"
relations:
  - "[[SPEC-054-vfx-procedural-para-areas-de-terreno]]"
  - "[[PLAN-023-efeitos-de-area-e-assets-procedurais-2026-09-27]]"
---

# EVID-084 — SPEC-054: VFX procedural para áreas de terreno

## Entrega implementada

`ui/overlay.gd` agora apresenta zonas por linguagem procedural específica, sem
alterar `core/battle.gd`, `data/stage_rules.json` ou valores mecânicos:

- poças recebem silhueta orgânica estável, borda pulsante e bolhas;
- rituais recebem aro segmentado, geometria interna e arco de progresso;
- telégrafos recebem preenchimento leve, borda acelerada e marcas de direção;
- bolhas de Molor inflam, mostram pressão no chão e brilho de ruptura;
- santuários usam halo dourado; os falsos mantêm a aparência inicial e exibem
  fissura violeta discreta;
- Cera Fervente e Colar dos Tentáculos possuem tratamentos próprios;
- a corrente ativa dos Pilares recebe linhas espectrais no chão;
- acentos grandes são limitados a três por quadrante, enquanto a área-base
  continua visível.

`tools/shot.gd` recebeu a flag local `vfx`, que semeia uma cena determinística
de evidência. Ela não é acessível durante uma partida normal.

## Verificação realizada

| Verificação | Resultado |
|---|---|
| Smoke em todas as fases | Passou: Dagruve, Docas, Shedaklah, Molor, Durao, Feng-tu, Shendilavri, Goranthis e Pilares em `running`; `smoke: ok`. |
| Compilação de `ui/overlay.gd` no runtime | Passou dentro da fumaça depois da correção de tipagem; as nove cenas receberam `battle` sem erro de script. |
| Alteração de regra de combate | Não realizada: os arquivos de regra e simulação ficaram fora do lote. |

Comando de smoke: `D:\Godot\godot.exe --headless --path . res://tools/smoke.tscn`.

## Exceção de validação

O renderer headless deste ambiente não expõe `ViewportTexture`: a chamada de
captura retorna textura nula e não pode salvar PNG. A superfície de controle
visual desta sessão não tinha janela nativa de Godot disponível. Por isso, não
foi possível inspecionar a captura 1280×720 nem confirmar visualmente o teto
de três acentos grandes por quadrante.

O runner completo `tests/run_all.gd` foi disparado, mas o ambiente encerrou a
coleta de saída antes de devolver o resumo `testes: N falha(s)`; não há resultado
de suíte a alegar nesta evidência.

## Próxima verificação necessária

Em uma sessão com renderer gráfico, executar:

`godot --path . res://tools/shot.tscn -- .atena/evidence/SPEC-054-vfx-areas-2026-09-27.png 1.2 run pilares durvall vfx`

e inspecionar a imagem a 1280×720. Depois, executar `tests/run_all.gd` até o
resumo final. Somente então esta SPEC pode ser reconciliada como verificada.

## Aceite da exceção

O dono aceitou em 2026-09-27 a conclusão local com esta exceção aberta. O
aceite não transforma a captura ou a suíte sem resultado em validação aprovada;
ele apenas permite encerrar o lote preservando a pendência para futura sessão
gráfica.
