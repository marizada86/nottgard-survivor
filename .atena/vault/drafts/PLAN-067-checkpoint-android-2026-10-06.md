---
plan: PLAN-067
spec: SPEC-134
created: 2026-10-06
status: AWAITING_NATIVE_APPROVAL_AND_DEVICE
canonical: false
---

# Checkpoint Android do piloto mobile

Os controles e menus foram implementados e verificados localmente. Esta proposta prepara S-009; não autoriza instalação de ferramentas, exportação ou instalação em aparelho. A aprovação local de PLAN-067 continua válida.

## Artefato proposto

| Campo | Proposta |
|---|---|
| Alvo | Android, aparelho e versão do sistema a confirmar pelo dono |
| Preset | Android Mobile Playtest, novo preset de debug separado dos presets Windows |
| Nome | Nottgard Survivors — Mobile Playtest |
| Identificador | `com.marizada.nottgardsurvivors.playtest`, candidato a confirmar antes da exportação |
| Destino local | `.atena/generated/mobile-controls/v02/NottgardSurvivors-Mobile-Playtest.apk` |
| Renderização | GL Compatibility existente; horizontal |
| Entrada | Perfil touch automático; joystick exclusivamente para andar |
| Conteúdo | Cenas, scripts, dados JSON e assets de runtime; excluir `.atena/`, `tests/`, `tools/`, builds e documentação |
| Permissões | Nenhuma permissão adicional de rede, armazenamento externo, câmera, microfone ou localização; revisar o manifesto gerado antes da instalação |
| Assinatura | Debug local do Godot, sem credenciais de publicação |
| Distribuição | Arquivo local; sem loja, upload, publicação ou envio externo |

O APK precisa receber identificação real de versão/hash após ser gerado. P067-v02 identifica o piloto local de código e não é um APK existente. O teste usará perfil próprio do pacote de playtest; não migrar nem substituir o save do jogo normal. Confirmar a compatibilidade do aparelho e as arquiteturas antes de fixar o preset.

## Ferramentas e autorização

Godot 4.7.2 e o template Android debug já estão presentes. A inspeção local não encontrou `java` ou `adb` no PATH. `JAVA_HOME`, `ANDROID_HOME` e `ANDROID_SDK_ROOT` não estavam configurados; o editor registra Java vazio e o caminho `C:/Users/gui-m/AppData/Local/Android/Sdk`, sem `platform-tools/adb.exe` nesse destino. Isso comprova que o ambiente inspecionado está incompleto, sem afirmar que não exista outra instalação no computador.

A [documentação oficial do Godot 4.7](https://docs.godotengine.org/en/4.7/tutorials/export/exporting_for_android.html) recomenda OpenJDK 17 e lista SDK platform-tools 35.0.0 ou superior, build-tools 35.0.1, platform 35, command-line tools, CMake 3.10.2.4988404 e NDK 28.1.13356709. O piloto deve usar o template precompilado existente, sem introduzir plugin ou build Gradle personalizado.

Proposta de preparação, se autorizada: procurar instalações existentes primeiro; se insuficientes, obter OpenJDK 17 e ferramentas Android de fontes oficiais em uma pasta local separada `.atena/generated/mobile-controls/android-toolchain/`, aceitar as licenças somente com autorização do dono e configurar os caminhos apenas para esse processo de exportação. Não alterar variáveis globais, instalar Android Studio ou configurar ferramentas de outros projetos. Registrar versões, fontes, hashes disponíveis e qualquer alteração necessária ao preset. Caso a origem ou instalação exija outra autorização, apresentar a decisão concreta antes de executar.

Autorizações independentes a resolver: instalação/configuração de JDK/SDK e aceitação das licenças; exportação local do APK com o preset acima; instalação em um aparelho escolhido e conectado pelo dono. Nenhuma delas permite publicação, commit, push ou canon novo. O gate vem de [SPEC-134](../../specs/SPEC-134-controles-e-menus-mobile-2026-10-06.md), seção Gaps e checkpoints, e das regras de dependências e permissões do AGENTS.md do projeto.

## Roteiro no aparelho

Registrar modelo, SO, resolução, recortes, DPI, build ID e hash. Verificar título/Quartel, seleção de herói/fase, opções e ajuda; combate com dois dedos, soltura/cancelamento, dez habilidades, interação contextual, ficha, compras/equipar/vender, ofertas/rerrolagem, HQ, reviver/recusar e resultado/repetir. Confirmar extração/abandono e o retorno após cancelar; testar segundo plano e retorno sem comando preso. Conferir alvos de toque e conforto em dp reais.

Executar uma tentativa completa e um cenário carregado por pelo menos dez minutos. Registrar FPS e tempos de quadro: alvo de pelo menos 95% dos quadros até 33,3 ms. Registrar travamentos, aquecimento e consumo quando mensuráveis. Esses dados ainda não existem; o PC não comprova aceite nativo. Qualquer otimização material precisa de proposta própria.

## Recuperação e retorno

Preservar preset Windows, saves e snapshots locais. Em falha, conservar logs e APK/hash para diagnóstico; não apagar dados do aparelho nem desinstalar outro pacote. S-010 permanece aberto até comparar os critérios e registrar o aceite ou as pendências. Depois de mobile, retomar PLAN-066 em B-002/S-005 conforme a suspensão registrada em [plan.yaml](../../state/plan.yaml).
