---
id: EVID-187
plan_id: PLAN-071
spec_id: SPEC-138
date: 2026-10-06
status: LOCAL_DELIVERED_AWAITING_DEVICE_ACCEPTANCE
synthetic_data_only: true
---

# Playtest e ranking: entrega local

Escopo aprovado antes da implementação: iniciar e executar B-001 a B-006 por plano. Fontes locais são o resultado; nenhuma operação Git, publicação, migração real ou configuração de credenciais foi feita nesta entrega. A consolidação Git solicitada em outro chat possui autorização e recibos próprios.

Implementado: contrato comum de partidas, builds completas e histórico; contadores exclusivos e dano efetivo; score v1; log Windows automático final/ativo e rotação; central pública F4 (QA preservado), F5/F6; Web Playtest/Relatar/Capturar, consentimento, fila persistente, retry e recibo por revisão; APIs com tester aprovado; importação Discord assinada por comando/anexo limitado; ranking de pontos, sobrevivência e percurso concluído, por grupo e melhor partida do jogador; relatórios e anexos privados. Hash comparável inclui build imutável, score e dezoito tabelas de gameplay. Sem dependências novas.

## Verificação

- [Suíte Godot](../generated/playtest-ranking/v01/tests.log): zero falhas. Aviso de cinco recursos em uso na saída já observado na linha de base; não representa falha da suíte.
- [Smoke](../generated/playtest-ranking/v01/smoke.log): nove fases passam.
- [Interop](../generated/playtest-ranking/v01/interop.log): dois registros produzidos pelo código Godot, Web/Windows, aceitos pelo validador do site; fixtures declaradamente sintéticos, QA/acelerados/dev e sem ranking humano.
- [Site](../generated/playtest-ranking/v01/site-tests.log): 80 testes, zero falhas e zero skips; migração, exclusão, idempotência, autoria/contexto, QA, importer e relatório em banco sintético.
- [Discord](../generated/playtest-ranking/v01/discord-tests.log): 27 testes passam; [tipagem](../generated/playtest-ranking/v01/discord-types.log) passa.
- TypeScript do site sem emissão passou. [Build completo do site](../generated/playtest-ranking/v01/site-build-result.json): exit 0, banco isolado, sem DB real. [Log](../generated/playtest-ranking/v01/site-build.log).
- [Exportação Web](../generated/playtest-ranking/v01/web.log): exit 0, PCK com project.binary. Compressão ETC2 habilitada, exigida pelo preset mobile Web; apenas templates já instalados usados.
- [HTTP real local](../generated/playtest-ranking/v01/http-checks.json): quinze verificações passam, incluindo anônimo/pendente/origem inválida, notas privadas, equipe, importação assinada, recibos repetidos e ranking.
- [Navegador real](../generated/playtest-ranking/v01/browser-checks.json): central, nota sem upload antes do consentimento, retry 401 preservado, reload, sessão fictícia aprovada, recibo da nota/PNG e run jogada de desenvolvimento recebida como diagnóstico. [Painel corrigido](../generated/playtest-ranking/v01/web-relato-1280.png); [recibo](../generated/playtest-ranking/v01/web-recibo-1280.png); [run](../generated/playtest-ranking/v01/web-run-recibo-1280.png). Ranking público e detalhes da build fictícia conferidos. Ambiente local com proxy somente para a exportação e banco sintético.

## Comparação com os dez critérios

1. PASS: contrato comum/score e idempotência/conflito por testes de produtor e servidor.
2. PASS código/testes: final/ativo independem de relato/print; diretório seguro e limite. Aceite do executável Windows ainda manual.
3. PASS local Chromium/janela: botões, nota corrigida, central e captura. Testes verificam seleção de perfil/atalhos. Chrome, Edge, Firefox finais, fullscreen e toque ainda PENDING_MANUAL; não declarar homologação universal.
4. PASS: persistência/reload/retry/ACK antigo e backoff; auth 401 exercido no navegador. Offline/timeout cobertos pela fila e testes; perda de dados privados/limpeza do navegador explicitada, sem garantia de durabilidade nesses casos.
5. PASS: aprovação no servidor, assinatura e autoria/contexto; áreas administrativas isoladas; nenhum token nos registros exportados.
6. PASS: schema, tamanho/finito, URL/anexo, build/task e recibos. Sem banco real.
7. PASS: ranking separado, top por jogador/recorde próprio e detalhes; filtro de build/balanceamento. Partida dev do browser excluída como diagnóstico.
8. PASS: denominadores/cobertura explícitos, pequenas amostras e builds completas; nenhum dado humano usado nos ensaios.
9. PASS automatizado/local; homologação de dispositivos/navegadores/executável final pendente explícita.
10. PASS: contrato ADD e links validados; estados/decisões reconciliados com origem anterior à execução e pontos de retorno preservados.

## Limites e ativação

Código e evidências locais entregues. Pipeline pertence ao dono. Antes de ir ao ar: revisão/backup da migração, builds e tasks permitidos, flag de coleta, registro autorizado de comandos e homologação dos clientes finais. [Guia no site](D:/dev/marizverso.com/docs/playtest-ranking.md). Retenção local implementada (90 dias anexos/365 dias partidas) só executa no ambiente publicado após ativação; não executada contra dados reais. Cliente Windows não é autoridade anticheat. DPS é por tempo da run, não tempo equipado. Dados Windows dependem dos arquivos enviados; Web depende dos recibos recebidos.

Os planos anteriores do jogo e o checkpoint PLAN-060/B-002/S-005 do site permanecem recuperáveis. Backlog: 0 P0, 4 P1 abertos, 8 P1 implementados aguardando playtest e 8 verificações manuais; zero alertas de organização. Esses itens não foram fechados por estes testes.
