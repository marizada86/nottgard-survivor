# EVID-105 — Geração e verificação do executável Playtest Público

Data: 2026-09-29
PLAN: [[PLAN-036-playtest-primeira-vez-guia-autossuficiente-2026-09-29]]

## Contexto

O dono pediu o executável do playtest para envio, mas não tinha os modelos de
exportação do Godot 4.7.2 instalados (pré-requisito do motor pra gerar
qualquer build nativo). Optou por eu mesma baixar e instalar, em vez de
fazer pelo editor.

## O que foi feito

1. Baixados do release oficial do Godot no GitHub
   (`godotengine/godot`, tag `4.7.2-stable`) apenas os 4 arquivos
   necessários para exportação Windows x86_64 (debug/release, com/sem
   console) — não o pacote `.tpz` completo (1,19 GiB, cobre todas as
   plataformas) — extraídos diretamente para
   `%APPDATA%/Godot/export_templates/4.7.2.stable/`.
2. Criada a pasta `build/` (não existia; sem ela o Godot recusa a
   exportação com "caminho de exportação não existe").
3. Executado `Godot_v4.7.2-stable_win64.exe --headless --path . --export-release
   "Windows Playtest Publico" build/NottgardSurvivors-Playtest.exe` —
   sucesso, sem erros.
4. **Verificação real**: executei o `.exe` gerado, confirmei que o processo
   sobe e se mantém estável (não é um crash-on-launch), tirei um print da
   janela do jogo e confirmei visualmente:
   - Menu do Quartel carrega normalmente (heróis, fases, abas).
   - Rodapé mostra `Nottgard Survivors v0.1.0 · build de public` —
     confirma que o perfil resolvido é Playtest Público (`public_playtest`),
     não produção nem QA.
   - Encerrei o processo de teste depois da verificação.

## Resultado

- `build/NottgardSurvivors-Playtest.exe` — 203.488.128 bytes.
- SHA-256: `cb816d1d388a1726d6a0701ef0b2629ec19aec01f837cddf67ffa5f8fa407d45`
- `build/` está no `.gitignore` — o executável não foi nem será commitado;
  cabe ao dono distribuir o arquivo (link de download, per
  [[PLAN-036-playtest-primeira-vez-guia-autossuficiente-2026-09-29]]).

## Limites

- Só os modelos de exportação Windows x86_64 foram instalados (os
  necessários para os 3 presets deste projeto, todos Windows Desktop
  x86_64). Outras plataformas (Linux, macOS, Web, mobile) exigiriam baixar
  os modelos correspondentes separadamente, se um dia forem necessárias.
- Verificação cobriu abertura do menu e o rótulo de build; não cobre uma
  run completa (gameplay) do executável exportado — o comportamento de
  jogo já é validado pela suíte/smoke rodando direto do projeto-fonte, não
  do binário exportado.
