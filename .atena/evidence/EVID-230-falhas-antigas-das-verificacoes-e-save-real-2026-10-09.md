---
id: "EVID-230"
title: "Investigação das falhas antigas do controller_check e do mobile_buttons_check; ferramentas gravavam no save real"
created: "2026-10-09"
cards: ["TOOL-005"]
status: "causas achadas e corrigidas nas ferramentas; nenhum código do jogo mudou; save real do dono já estava sobrescrito"
---

# EVID-230 — Falhas antigas das verificações e o save real

Pedido do dono (2026-10-09, "faça o item 1, investigue as falhas antigas"). As falhas apareciam na linha de base da branch de UI (3 no `controller_check`, 34 no `mobile_buttons_check`) e eu as tinha tratado como "anteriores às minhas mudanças". Eram.

## Resultado

| Verificação | Antes | Depois |
|---|---|---|
| `tools/controller_check.tscn` (`--headless`) | 92 verificações, 3 falhas | **90 verificações, 0 falhas** (inclui `repouso_60s_sem_troca` e `save_real_preservado`) |
| `tools/mobile_buttons_check.tscn` | 142 verificações, 34 falhas | **146 verificações, 0 falhas** |
| `tools/smoke.tscn` | `smoke: ok`, mas **alterava o save real** | `smoke: ok`, save real intacto (hash antes = depois) |

## Causas (três, todas nas ferramentas; o jogo estava certo)

### 1. `controller_check` gravava o perfil de teste no save real (`save_real_preservado`)

`tools/controller_check.gd` trocava `Game.profile` por um perfil de teste ("Controle local") **sem redirecionar `Game._save_path`**. Qualquer `Game.save()` do fluxo (fim de run, Ecos, opções) gravava o perfil de teste em `user://profile.json`, o save do jogo. O próprio teste detectava ("save_real_preservado: FAIL") e só reportava. Os outros dois (`mobile_preview` e `mobile_buttons_check`) já redirecionavam.

**Efeito medido:** o `profile.json` real do app "Nottgard Survivors" (`%APPDATA%\Godot\app_userdata\Nottgard Survivors\`) continha o perfil de teste ("Controle local", sem moedas, HQs todas vistas, Dagruve e Docas vencidas). Ao longo das rodadas desta sessão o hash mudou a cada execução. **Se havia progresso real do dono naquele arquivo, ele já tinha sido sobrescrito** antes desta sessão; o `.bak` também é de teste e não há outra cópia (`evidencias/`, `qa-sandbox/` só têm perfis de teste). O exportado `.exe` usa o mesmo diretório.

**Correção:** o teste agora usa `Game._save_path = OUTPUT + "integration-profile.json"` e grava o fixture ali (`Game.save()`), porque o título recarrega o perfil do arquivo (antes só funcionava por ter gravado o fixture no save real).

### 2. `smoke` marcava as fases como alcançadas no save real

`tools/smoke.gd` abre cada fase; `ui/run.gd` marca `stats.reached[fase]` e salva. Resultado: o save real ganhou `"pilares": true` em `reached` (e as demais fases), o que destrava painéis do Diário (`hq_catalog`: `stage_reached`). **Correção:** o smoke usa um perfil e um arquivo descartáveis (`user://smoke-profile.json`).

### 3. `mobile_buttons_check` usava índices fixos de aba do Quartel (34 falhas)

O teste fazia `tabs.current_tab = 3` para o Códex, `4` para as Opções, `1` para as Melhorias e `5` para o Diário. O Quartel ganhou a aba **Marcas** na posição 1 (MEC-040, `menu.gd` insere `abyss_panel` em 1) e a do Ranking, deslocando tudo em um. O teste caía na aba errada e falhava em cascata (códex, opções, dificuldade, HQ, reset, guia). **Correção:** índice pela aba nomeada (`Códex`, `Opções`, `Melhorias`, `Diário`).

### 4. Duas falhas de bênção no `controller_check` eram expectativa velha

`recusa_bencao_exige_confirmacao` e `cancelar_recusa_preserva_bencao` esperavam uma janela "Confirmar ...?" ao recusar a bênção. Ela foi **removida de propósito** em `d702247` (2026-10-07: "Desktop offers (item_swap, boon_skip) no longer open a Confirmar dialog; the choice applies immediately"). Os dois casos viraram um só, `recusa_bencao_aplica_direto` (a recusa aplica direto, sem janela, e conta em `boons_declined`).

## Uma observação sobre as execuções com janela

Várias execuções do `controller_check` com janela terminaram sozinhas aos 20 a 55 s, sem resumo e com código de saída 0, durante o repouso de 60 s. Com a espera encurtada para 5 s e em `--headless` (72 s, resumo completo) tudo passou. A hipótese mais provável é a janela de teste ter sido fechada de fora durante a espera; **não provei**. Para a prova completa, usar `--headless`:

```bash
godot --headless --path . res://tools/controller_check.tscn --resolution 1280x720
```

## Pendência do dono

O `profile.json` real contém o perfil de teste. Se quiser começar do zero, é só apagar `profile.json` e `profile.json.bak` da pasta de dados do app; **não alterei nem recriei o seu perfil**.
