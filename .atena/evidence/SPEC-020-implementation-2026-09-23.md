# SPEC-020 — evidência de implementação

Data: 2026-09-23

## Alterações realizadas

- Perfis de build `production`, `public_playtest` e `qa_internal`, com fallback
  seguro para produção e presets Windows público e interno.
- Kit de evidências em `user://evidence-kit/<perfil>/`, com rascunho atômico,
  manifesto sem progresso/nome de sistema, ZIP temporário e recuperação local.
- F12 de diagnóstico higienizado; Ctrl+O, P abre o Navegador QA somente no
  perfil interno.
- Navegador para abas do Quartel, todos os heróis/fases declarados, estados de
  level-up, altar, chefe/viradas, portal, resultado e regra de fase.
- Sandbox QA separado do `user://profile.json`, com assinatura do save real
  conferida ao encerrar a sessão.
- Testes unitários adicionados para resolução de perfil e cenários da simulação.

## Verificações executadas

- `git diff --check`: sem problemas de whitespace.
- Busca de referências obsoletas (`PLAYTEST_BUILD`, `DRAFT_DIR`,
  `FALLBACK_DIR`): nenhuma referência ativa encontrada.

## Exceção de validação

Não foi possível executar a suíte Godot nem o smoke nesta máquina: o binário
`godot` não está disponível no PATH e não foi localizado nos diretórios locais
verificados. A execução da suíte e do smoke permanece necessária antes de mudar
a SPEC-020 para executada.
