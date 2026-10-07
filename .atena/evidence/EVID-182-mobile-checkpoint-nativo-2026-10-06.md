---
id: EVID-182
plan: PLAN-067
spec: SPEC-134
batch: B-003
created: 2026-10-06
status: AWAITING_DEVICE_VALIDATION
---

# Prontidão para o checkpoint nativo

Parte local de S-008 concluída: suíte zero falhas, smoke nove fases e capturas dos três formatos em [EVID-180](EVID-180-mobile-combate-local-2026-10-06.md) e [EVID-181](EVID-181-mobile-menus-local-2026-10-06.md). Aparelho/modelo/SO ainda não informado. S-008 é parcial até essa informação; S-009 não começou e S-010 teve apenas reconciliação local provisória.

Inspeção read-only: Godot 4.7.2 em D:/Godot/godot.exe; template android_debug.apk presente em AppData/Roaming/Godot/export_templates/4.7.2.stable/. Java/adb não encontrados no PATH, variáveis JAVA_HOME/ANDROID_HOME/ANDROID_SDK_ROOT não configuradas. Editor settings Java vazio, SDK apontado a AppData/Local/Android/Sdk e adb ausente nesse destino. Nenhuma ferramenta foi instalada nem configuração global alterada.

[Proposta de checkpoint Android](../vault/drafts/PLAN-067-checkpoint-android-2026-10-06.md) descreve preset, pacote candidato, destino, permissões, ferramentas e roteiro de aceite. Perguntas ao dono solicitam aparelho e autorização independente para ferramentas/exportação. Instalação no aparelho segue gate próprio; ausência de resposta não é aprovação.

## Resultado por critério

| Critério SPEC-134 | Resultado |
|---|---|
| 1–4 Entrada, dedos, mouse emulado e modais | PASS local; confirmar no aparelho |
| 5 Fluxo inteiro e estados raros somente por toque | Implementado; cobertura local parcial, playtest completo pendente |
| 6 Proporções e acessibilidade | Capturas e área segura simulada PASS; conforto/dp/recortes reais pendentes |
| 7 Desktop/controle | Regressão automatizada PASS; playtest físico pendente |
| 8 Suíte e smoke | PASS, zero falhas/nove fases |
| 9 Aparelho, tentativa e dez minutos de desempenho | NOT_RUN |

Não existe APK produzido, teste nativo, medição FPS/tempos de quadro ou aceite final do dono. Estado AWAITING_DEVICE_VALIDATION explícito; PLAN-067 continua ativo e Durvall suspenso com retorno preservado. MEC-049/ART-036 são implementação local aguardando aceite mobile, sem fechamento definitivo. Canon e lore não foram alterados; nenhum commit/merge/push/publicação.

Manifesto local e hashes: [manifest.json](../generated/mobile-controls/v01/manifest.json). Contrato ADD, links dos registros tocados e backlog são verificados ao concluir a reconciliação; resultado operacional em [reconciliation.json](../generated/mobile-controls/v01/reconciliation.json).
