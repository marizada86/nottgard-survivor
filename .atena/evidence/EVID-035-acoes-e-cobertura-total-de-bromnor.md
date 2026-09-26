# EVID-035 - Acoes e cobertura total de Bromnor

Data: 2026-09-25

## Escopo executado

Com aprovacao humana, foram integradas as tres folhas finais restantes de
Bromnor:

- `assets/animations/heroes/bromnor/attack.png` - 1024x384, quatro quadros;
- `assets/animations/heroes/bromnor/active.png` - 1536x384, seis quadros;
- `assets/animations/heroes/bromnor/death.png` - 1536x384, seis quadros.

As tres sairam de grades-fonte RGBA com alfa zero no canto e foram
normalizadas por interpolacao nearest-neighbor em tiras de runtime com celulas
de 256x384.

## Qualidade visual

- `attack`: arco controlado do Martelo da Gloria com luz dourada/prateada
  curta; a arma permanece um martelo.
- `active`: a primeira candidata foi descartada por adicionar detritos e
  fachos verticais. A `active_v02` foi aprovada com apenas a nova radial baixa
  de Concórdia ao redor dos pes.
- `death`: queda lateral sem gore; o martelo permanece corporeo e o brilho se
  apaga.

Todas preservam Bromnor como anao idoso de barba branca, armadura de bronze e
aco e tecido azul profundo, sem orelhas pontudas, aura estourada ou anatomia
extra.

## Cobertura reconciliada

O manifesto registra Bromnor com as nove fontes completas:
`idle`, `move_n`, `move_ne`, `move_e`, `move_se`, `move_s`, `attack`, `active`
e `death`. O runtime continua derivando `move_nw`, `move_w` e `move_sw` por
espelhamento, sem gerar folhas redundantes.

## Verificacao

1. Reimportacao local do Godot das tres novas texturas concluida.
2. `D:\Godot\Godot_v4.7.2-stable_win64.exe --headless --path . -s tests/run_all.gd`: **0 falhas**.
3. `D:\Godot\Godot_v4.7.2-stable_win64.exe --headless --path . -s tools/audit_prompt_execution.gd`: **0 falhas**.
4. A suite agora instancia `ui/hero_view.tscn` com `bromnor` e confirma as
   nove animacoes no `AnimatedSprite2D`, incluindo o acionamento de `attack`,
   `active` e `death`: **0 falhas**.

## Rastreabilidade

- Plano: `../vault/drafts/PLAN-007-geracao-controlada-das-animacoes-de-bromnor-2026-09-25.md`.
- Evidencia anterior: `EVID-034-bromnor-idle-e-movimentos.md`.
- Manifesto: `../generated/HERO-ANIMATION-PROMPT-MANIFEST-001.json`.
- Registros: `../generated/prompt-execution/HERO-bromnor-{idle,move_n,move_ne,move_e,move_se,move_s,attack,active,death}.json`.
