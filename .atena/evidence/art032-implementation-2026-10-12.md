# ART-032 — implementação local, 2026-10-12

[PLAN-ART032-IMPLEMENT/v01](../vault/drafts/PLAN-ART032-IMPLEMENT-v01.md) concluído tecnicamente, **6/6**. Contrato preparado antes da execução. A resposta **“pode implementar”** confirma preparação, admissão e integração local das dezessete fontes aceitas ART-032; modalidade per-plan preservada. Uso runtime DRAFT autorizado; sem promoção a CANON, commit, push ou exportação.

## Resultados por passo

| Passo | Resultado e evidência |
|---|---|
| S-001 | Contrato, referências/revisões, identidade/contextos e backups registrados antes da mudança. Dezessete fontes selecionadas, vinte e sete nativas históricas e quatro recibos preservados. [Manifesto](../generated/art032-implementation-2026-10-12/manifest.json), [snapshot](../generated/art032-implementation-2026-10-12/protected-snapshot.json). |
| S-002 | Godot 4.7.2: dezessete derivados RGBA, recorte proporcional Lanczos, alfa residual <=8/255 limpo apenas no derivado, quatro px transparentes em cada lado. Altura visível 240 px NPCs/props/chefe e 96 px estrela/coletáveis; fontes byte a byte iguais. [Auditoria de preparação](../generated/art032-implementation-2026-10-12/preparation-audit.json). |
| S-003 | Dezesseis PNGs em interactions e arte própria da Manifestação de Juiblex. Campos de arte conectados a pontos/itens/drop do elite, escolta, pactos, resgates e recompensas. Duas Irmãs usam Nyxara/Vaelis distintas; Graz'zt e João usam artes próprias. Bbox visível ancora base e mantém proporção: NPCs/props/aliados 80 px; coletáveis/estrela 48 px. Renderer/escala existentes do chefe preservados. Fallbacks e aliados legados preservados. [Admissão DRAFT](../generated/art032-implementation-2026-10-12/admission.json). |
| S-004 | Suíte completa final: **testes: 0 falha(s)**. Teste ART-032 cobre imports, margens, proporção/base, itens/drop, eventos, escolta, duas Irmãs, Graz'zt, legado e comparação do estado RNG/posições com e sem metadados de arte. Definições mecânicas iguais ao backup excluindo somente asset/assets. [Log final](../generated/art032-implementation-2026-10-12/tests-final-log.txt), [auditoria dos dados](../generated/art032-implementation-2026-10-12/data-audit.json). |
| S-005 | Sete capturas 1280×720 em seis biomas, cobrindo dezessete peças: import, proporção/base, contraste e rótulos conferidos nativamente. Corrigida largura dos rótulos longos dos pactos. [Galeria](../generated/art032-implementation-2026-10-12/index.html), [capturas/QA/hashes](../generated/art032-implementation-2026-10-12/capture-qa.json). |
| S-006 | Plano/estado/backlog e registro de admissão reconciliados; cadeia de retorno PLAN-071/revisão de heróis preservada. [Verificação final](../generated/art032-implementation-2026-10-12/delivery-verification.json), [roteiro de playtest](../generated/art032-implementation-2026-10-12/playtest.md). |

## Limites observados e recuperação

A suíte exige acesso aos seus diretórios temporários user://test_*; a execução inicial na sandbox falhou por acesso ao perfil/evidence zip, não por ART-032. A tentativa de redirecionar user-data não criou diretórios: Godot sanitiza o caminho, portanto foi encerrada e não reutilizada. A suíte final executou com a permissão local aprovada pelo auto-review e perfil de controlador isolado no pacote; não substituiu o perfil do jogador. Nenhuma dependência instalada. Logs diagnósticos iniciais foram preservados separadamente.

Zero novas falhas de teste/erros de script ART-032. O log final ainda contém duas mensagens anteriores de abertura de arquivo: idle.png de Arlindo e Erik, vinculadas à frente de heróis pendente. Não declarar log integralmente livre de erros. Aviso do repositório de certificados também permanece no runtime local.

Capturas usam cenas reais de run/overlay/inimigos em SubViewport, posições controladas, simulação congelada e avisos iniciais ocultos apenas na fixture. Não constituem uma partida humana, nem validam diversão/dificuldade. Navegador file:// não foi usado devido ao bloqueio de política já conhecido; imagens foram inspecionadas nativamente e os 75 links locais da galeria verificados.

Auditoria final: **2.966 hashes protegidos iguais**, originais/recibos/backups iguais, dezessete derivados iguais aos destinos admitidos, todas as dezessete imports presentes. HEAD 51b51f7369ae34eede997435e6eb52ea057daf25 e índice vazio preservados. Nenhuma alteração dos outros assets/runtime ou da cauda active_plan; alterações anteriores das outras frentes mantidas. Recuperação por backup local e snapshot dos destinos; não usar reset/limpeza global. Templo-alvo, jaula, canoa e animações não fazem parte das dezessete fontes e seguem pendentes.

Próximo objetivo preparado: playtest humano da integração local, com escopo, procedimento, observações e critérios no roteiro. Avaliação subjetiva **PENDING_NOT_PERFORMED**, não bloqueante para a conclusão técnica. Qualquer CANON, commit, push ou exportação continua com gate próprio e não foi realizado aqui.
