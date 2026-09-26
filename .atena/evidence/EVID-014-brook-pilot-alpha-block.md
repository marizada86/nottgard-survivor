# EVID-014 — Bloqueio de alfa no piloto de Brook

Data: 2026-09-23
Lote: `BATCH-brook-pilot-01`

## Processamento local autorizado

A candidata `idle_v02.png` foi processada de forma deterministica, com limiar
conservador `14`, conforme autorizacao explicita do usuario. O derivado
`idle_v02_alpha.png` preserva a grade-fonte 2x2 em `1024x1536`, removeu
`1.509.470` pixels de fundo conectado e tem alfa confirmado nos cantos.

Naquele momento, nao houve normalizacao, alteracao em `assets/` ou integracao
no Godot. A aprovacao posterior e o resultado da integracao estao registrados
na secao seguinte.

## Integracao aprovada

A primeira normalizacao com limiar `14` revelou perda de detalhes escuros e foi
descartada antes de qualquer teste. A variante local `t06` preservou a armadura
no tamanho de jogo e foi normalizada para
`assets/animations/heroes/brook/idle.png` (`1024x384`, quatro quadros de
`256x384`). O arquivo final era novo; nao houve substituicao nem backup
necessario. A validacao automatica agora cobre esse asset.

## Escopo aprovado

- `HERO-brook-idle`
- `HERO-brook-move_e`
- `HERO-brook-move_sw`
- `HERO-brook-active`

Referências autorizadas e usadas somente na chamada de idle:

- `assets/portraits/brook.png` — barba, armadura e identidade;
- `assets/heroes/brook.png` — silhueta e paleta de sprite.

## Resultado

Foram produzidas três candidatas para `HERO-brook-idle`:

| Versão | Caminho | Resultado |
|---|---|---|
| v01 | `.atena/generated/animation-candidates/heroes/brook/idle_v01.png` | orelhas élficas e fundo opaco/gradiente |
| v02 | `.atena/generated/animation-candidates/heroes/brook/idle_v02.png` | orelhas corrigidas; fundo opaco/gradiente persiste |
| v03 | `.atena/generated/animation-candidates/heroes/brook/idle_v03.png` | edição exclusiva de fundo; fundo opaco/gradiente persiste |

O registro canônico da chamada está em
`.atena/generated/prompt-execution/HERO-brook-idle.json`, com estado
`qa_failed` e o motivo objetivo. O limite de três candidatas foi respeitado.

`HERO-brook-move_e`, `HERO-brook-move_sw` e `HERO-brook-active` não foram
enviados e continuam em `compiled`, pois o defeito de alfa afetaria o lote
inteiro.

## Validação

`D:\Godot\Godot_v4.7.2-stable_win64.exe --headless --path . -s tools/audit_prompt_execution.gd`
terminou com `audit-prompt-execution: 0 falha(s)`.

## Próxima decisão necessária

Escolher uma estratégia adicional para obter alfa real antes de retomar o
lote: aprovar processamento determinístico de remoção de fundo das candidatas
ou autorizar uma nova estratégia de geração que substitua, e não ultrapasse, o
limite atual de tentativas.
