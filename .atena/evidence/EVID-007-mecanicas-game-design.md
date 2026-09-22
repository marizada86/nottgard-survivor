# EVID-007 — Mecânicas de aprofundamento (2026-09-22)

Relacionada às SPEC-012, SPEC-013 e SPEC-014.

## Entregas verificadas
- Dez habilidades ativas orientadas por dados, com Q/botão direito/controle, recarga e HUD.
- Level-up estruturado entre sinergia, defesa e nova direção.
- Extração versus descida com build preservada, recuperação decrescente, pressão de elites e multiplicador crescente.
- Uma regra principal por camada; Os Pilares alternam regras a cada minuto.
- Duas fases orientadas por dados para cada um dos oito chefes.
- Consequência jogável para todas as bênçãos existentes.
- Seis itens únicos transformadores com efeitos limitados por eventos.

## Verificações automáticas
- `tests/run_all.gd`: **0 falhas**, incluindo `test_game_design.gd` e integridade cruzada dos novos JSONs.
- `tools/smoke.tscn`: **8/8 fases** instanciadas e simuladas; `smoke: ok`.
- `ui/run.tscn --quit-after 120`: interface e HUD carregam sem erro de script.
- Bot `durvall 1 dagruve 0.08 1`: venceu Dagruve, preservou a build ao descer para Shedaklah e reportou profundidade 1 / multiplicador ×1,25.

## Correções feitas durante a validação
- Ritual sem ondas agora se encerra com segurança nos testes unitários.
- Leitura de evidências usa `DirAccess.open`, eliminando erro ao não existir rascunho.
- Bot usa habilidades ativas e inclui profundidade/multiplicador no relatório.

## Observações
- O ambiente headless restrito não consegue gravar `user://logs/godot.log` nem ler o repositório de certificados do Windows; não são falhas do jogo.
- O smoke mantém o aviso preexistente de duas instâncias `ObjectDB` no encerramento.
- Pendente humano: sensação das habilidades, clareza das regras de camada, leitura das fases de chefes e ajuste fino de risco/recompensa.
