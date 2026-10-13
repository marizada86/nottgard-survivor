---
plan: PLAN-065
spec: SPEC-132
revision: FILA026-INTEGRATION/v01
request_classification: IN_PLAN
status: IMPLEMENTED_LOCAL_PENDING_PLAYTEST_AND_CODE_COMMIT
approval_mode: per-plan
---

# FILA-026 — integração local

Continuação autorizada pelo dono: **“atena, vamos seguir para o proximo”**. Executados S-014, S-015 e a preparação local de S-016 dentro do plano aprovado em 2026-10-06. S-016 continua no gate de commit de código separado. A autorização anterior de commit/push foi consumida no checkpoint de arte; não foi estendida ao código novo.

## Conteúdo e referências

L01 v01 e L03–L05/P01–P03/C01–C03 v01 já são CANON visual admitido: [G1](../vault/canon/ASSET-APPROVAL-FILA026-L01-v01.md), [G2](../vault/canon/ASSET-APPROVAL-FILA026-G2-v01.md), [admissão](../vault/canon/ASSET-APPROVAL-REGISTER-031-fila026-admission-2026-10-11.json). Nenhuma fonte, PNG runtime, hotspot ou manifesto mudou nesta integração. SPEC-132 e PLAN-065 permanecem documentos no vault de drafts com escopo aprovado; não houve nova promoção de intenção ou lore.

Identidade de entidade N/A para lettering/cursor. Referências: ART-PROMPTS-058 e peças CANON já aceitas. Contextos verificados: título, Quartel, HQ inicial “Uma Noite sem Fim”, vitória/derrota, evolução Espada Sombria → Espada do Receptáculo, chefe Sacerdote da Mente Derretida e ficha C. Nenhuma lacuna BLOCKING. G5 atendida: commits `7c4da5d` e `1ef33bf` são ancestrais de HEAD e HUD/ficha/hero_panel estavam sem mudanças locais antes da execução.

## Resultado por etapa

- **S-014 concluída:** banners em resultados e evolução; placas com lettering em Quartel, HQ, chefe e seções da ficha C. Logo e cursor usam os hookups já existentes. Os Labels continuam contendo seus textos; imagens ignoram mouse; reutilização de resultado não duplica o banner. Ausência de imagem restaura texto e tamanho original do banner. Cabeçalho touch ajustado para acomodar a placa.
- **S-015 concluída:** suíte completa `tests/run_all.gd`, exit 0, **0 falhas**; auditoria `tools/audit_projeto.gd`, exit 0, **0 erros/9 avisos**; `tools/smoke.tscn`, exit 0, **9 fases running e smoke ok**. 16 capturas runtime (oito telas × 1280×720/1920×1080) mais duas touch simuladas. Inspeção técnica visual concluída. Cabeçalho touch: título termina em y=72, subtítulo ocupa y=80–99 e abas começam em y=120, sem sobreposição.
- **S-016 preparada:** este registro, galeria/auditoria, cartões e “O que testar” reconciliados. SPEC marcada `implemented-pending-playtest`. Próximo objetivo: commit isolado de MEC-058/código da FILA-026, com estes registros e checks, após aprovação explícita. Não houve commit, push, merge, exportação ou build nesta continuação.

## Evidências e verificações

[Galeria](../generated/fila026-integration-2026-10-11/index.html) · [auditoria reproduzível](../generated/fila026-integration-2026-10-11/audit.json) · [verificador](../generated/fila026-integration-2026-10-11/verify_integration.py) · [capturador Godot](../generated/fila026-integration-2026-10-11/capture.gd).

[Suíte](../generated/fila026-integration-2026-10-11/tracked-logs/suite.txt), [diagnósticos](../generated/fila026-integration-2026-10-11/tracked-logs/suite-errors.txt), [auditoria do projeto](../generated/fila026-integration-2026-10-11/tracked-logs/project-audit.txt), [smoke](../generated/fila026-integration-2026-10-11/tracked-logs/smoke.txt), [geometria touch](../generated/fila026-integration-2026-10-11/mobile/header-layout.json). Godot 4.7.2.stable.official.ed1daf0bf; processos aguardados até saída real.

O verificador confirma 18 imagens/dimensões/hashes, dez PNGs idênticos ao aceite e HEAD, manifesto intacto, dados de cursor/lettering e versão/export inalterados, G5, estado ativo e cadeia de retorno de PLAN-071 intactos, logs sem SCRIPT ERROR/Parse Error e `git diff --check` PASS. O relatório original das capturas 1080p chama-se [captures_2880x1620.json](../generated/fila026-integration-2026-10-11/captures_2880x1620.json): o nome refletiu a alocação da textura do viewport; as oito imagens e seus registros são **1920×1080**, conferidos pelo PNG. O capturador foi corrigido para nomear relatórios pelo tamanho real da última imagem.

O teste de regressão acrescentado cobre a troca vitória→derrota no mesmo Label e a queda para texto quando a arte está ausente. Os testes existentes de cursor cobrem AUTO/MOUSE e modais; não comprovam a aparência do cursor nativo na janela real.

Limitações existentes preservadas: faltam sprites/idle próprios de Arlindo e Erik em HEAD, diagnosticados pela suíte; os nove avisos da auditoria correspondem aos dois sprites e sete apresentações de chefe sem entrada. Há diagnósticos de recursos/RIDs no encerramento. A primeira execução da suíte em sandbox não conseguiu salvar arquivos temporários de teste; a execução final com acesso autorizado concluiu com exit 0/zero falhas. As capturas locais emitiram restrições de log/certificados do sandbox, sem impedir gravação e renderização. Nada disso foi convertido em aceite humano.

## Playtest pendente — roteiro preparado

Não realizado nesta etapa. Usar uma próxima build autorizada que contenha o commit de integração, registrar versão e build_id reais antes de jogar. Nenhum executável foi produzido aqui; capturas usam runtime de desenvolvimento 0.4.0/qa dev, perfil sintético, resultados e evolução preparados para QA.

Objetivo: avaliar leitura e operação da interface/cursor, mantendo o fluxo de combate. Procedimento: conferir título, Quartel, HQ e ficha C em 720p/1080p; obter vitória/derrota/evolução e ver o anúncio de chefe; testar menus/botões, AUTO→MOUSE, pausa, nível, altar e ficha C. Em janela real, observar ponteiro 32 px, mão 32 px e mira 40 px com centro correto; modais devem voltar ao ponteiro e restaurar a mira ao fechar. Conferir mouse, teclado/controle e, separadamente, aparelho móvel real.

Critérios e feedback: nenhum texto cortado, sobreposto ou ilegível; cabeçalhos dinâmicos cabem e controles continuam acessíveis; cursor reconhecível e tiro alinhado ao centro. Informar tela, resolução, forma do cursor, resultado esperado/observado e build_id de cada problema. Legibilidade subjetiva e aparelho real continuam sem aceite até o dono jogar. [Lista de testes](../backlog/RELEASES.md).

## Recuperação e continuidade

Código novo delimitado a `ui/lettering.gd`, `ui/hud.gd`, `ui/run.gd`, `ui/hq_screen.gd`, `ui/menu.gd`, `ui/character_sheet.gd` e `tests/test_lettering_assets.gd`. Restaurar apenas esses hunks desfaz a integração; commit de arte `86c453f` é independente e permanece publicado. Não reverter arquivos inteiros com trabalho de outras sessões.

Estado: S-016/16, quinze passos concluídos, nenhum passo após o atual; gate **CODE_COMMIT_PENDING_EXPLICIT_APPROVAL**. PLAN-071 e revisão/extracção de heróis preservados. Nenhuma mudança nos quatro P1 abertos (BUG-025/027/028/029) nem nos 14 bugs implementados pendentes de playtest.

2026-10-11 — Commit local separado autorizado explicitamente com **“atena, commit e vamos criar as proximas imagens”**. Checkpoint em execução; receipt e SHA só serão registrados após o Git confirmar o commit. Sem autorização nova de push ou build.
