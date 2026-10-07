# Diagnóstico inicial da corrida de Durvall

Inspeção de 06/10/2026 para preparar SPEC-133/PLAN-066. Não houve geração de imagens nem alteração de gameplay ou assets oficiais.

- Runtime: ui/hero_view.gd carrega seis quadros a 10 fps nas cinco fontes E, SE, S, N, NE; W/SW/NW são espelhos no código atual.
- Altura-alvo 60 px; altura de referência do idle 231 px-fonte; célula 256×384. Escala aproximada 0,2597.
- core/hero.gd define velocidade base 190 px/s; modificadores existentes afetam essa velocidade.
- move_e.png, move_se.png e idle.png foram inspecionados visualmente. Há pouca mudança de tronco e braço entre poses; a diagonal mantém uma leitura próxima de caminhada. Trata-se de análise de poses estáticas, não de uma nova medição de escorregamento em run.
- EVID-158 de 05/10 estima abertura 36,4 px e razão 1,57 para Durvall. O próprio método inclui roupa na faixa dos pés e não rastreia o pé de apoio, portanto não determina sozinho a cadência correta.
- EVID-158 e BUG-028 registram cadência acelerada/speed_scale testados e rejeitados/revertidos. O plano propõe arte primeiro, com controle de escala e velocidade.
- SPEC-106 e PLAN-001 §26 estabelecem identidade, células, gates e oito direções independentes no alvo do programa; o runtime atual ainda espelha três.
- Estado central consultado: active_plan null. O novo plano é proposta específica de Durvall; planos anteriores não foram reativados.
- Backlog: P0=0; quatro P1 abertos (025/027/028/029), sete implementados aguardando playtest e oito verificações manuais. Nenhum bug foi fechado.
- Dois UIDs não rastreados já estavam presentes no início deste pedido: tools/capture_ability_hud.gd.uid e tools/capture_character_sheet.gd.uid. Foram preservados.

## Referências

- [EVID-158](../../evidence/EVID-158-velocidade-de-movimento-x-passo-da-arte-2026-10-05.md)
- [SPEC-106](../../specs/SPEC-106-pacote-integral-animacoes-durvall.md)
- [SPEC-123](../../specs/SPEC-123-revisao-da-movimentacao-dos-herois.md)
- [Aprovação histórica de Durvall](../canon/ASSET-APPROVAL-REGISTER-002-durvall-brook-2026-09-27.md)
- [Contrato canônico](../canon/PLAN-001-nottgard-survivors.md)
