# EVID-008 — Produção e integração total de áudio

Data: 2026-09-22  
Spec: `SPEC-016-audio-total.md`

## Resultado

- Biblioteca original e determinística gerada localmente, sem dependências externas.
- 226 chaves de evento e 450 arquivos WAV PCM 16-bit/22.05 kHz mono.
- Tamanho dos WAVs: 27.085.672 bytes (~25,8 MiB).
- 8 músicas de fase, 8 ambiências de fase e 4 músicas globais.
- Cobertura individual de todas as armas, heróis, inimigos e chefes presentes nos JSONs.
- Buses: `Music`, `Ambience`, `SFX`, `UI`, `Player`, `Enemies` e `Impacts`.
- Pool de 24 vozes com cooldown, variação de pitch, prioridade e roubo controlado.
- Crossfade de música, loops de ambiente e compatibilidade com as chaves legadas.
- Controles persistentes de volume mestre, música, efeitos e ambiência.

## Verificações

1. `node tools/validate_audio.js`
   - 226 eventos.
   - 450 arquivos verificados.
   - Cabeçalho WAV, presença, sinal não silencioso e ausência de clipping.
   - 0 falhas.
2. `Godot 4.7.2 --headless --path . -s tests/run_all.gd`
   - `testes: 0 falha(s)`.
   - Inclui `tests/test_audio.gd` e toda a suíte existente.
3. `Godot 4.7.2 --headless --path . res://tools/smoke.tscn`
   - Menu e as oito fases instanciados.
   - `smoke: ok`.
   - Música, ambiência e eventos contextuais carregados sem erro de recurso ou script.

O ambiente restrito impediu o Godot de escrever o log no perfil do Windows e de ler o
repositório de certificados do sistema. Esses avisos são externos ao projeto; os processos
terminaram com sucesso e as verificações do jogo passaram.

## Critérios reconciliados

- Eventos críticos possuem som e fallback: atendido.
- Música e ambiência distintas por fase: atendido.
- Cobertura de armas, heróis, inimigos e chefes: atendido automaticamente pelo manifesto.
- Prioridade sob alta simultaneidade: atendida pelo pool e metadados de prioridade.
- Persistência dos quatro controles de volume: atendida com merge retrocompatível de perfil.
- Manifesto e arquivos íntegros: atendido por duas validações independentes.
- Drift narrativo: nenhum; apenas fatos operacionais foram adicionados.

## Observação de playtest

A mixagem está tecnicamente válida e sem clipping. O ajuste subjetivo final de timbre e
balanço deve ser feito em uma sessão audível com o dono, sem bloquear esta entrega funcional.
