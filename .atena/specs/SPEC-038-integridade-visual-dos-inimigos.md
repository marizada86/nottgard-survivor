# SPEC-038 — Integridade visual dos inimigos repetidos

Status: **verificada — sem alteração de produção necessária** (2026-09-27).

## Intenção

Eliminar o fallback visual incorreto que transforma cópias simultâneas de um
mesmo inimigo estático no retângulo vermelho defensivo. Manter o pipeline de
arte atual, os IDs de dados e as regras de combate, ampliando a cobertura de
testes para que a regressão não volte a passar despercebida.

## Diagnóstico de partida

- `data/enemies.json` contém 49 IDs e `assets/enemies/` possui os mesmos 49
  PNGs; não há arquivo ausente ou órfão.
- Somente `zumbi` e `sacerdote_mente_derretida` usam folhas animadas. Os outros
  47 IDs usam a textura estática carregada por `EnemyView`.
- Em `ui/enemy_view.gd`, `_apply_id()` preenche `tex` após consultar
  `_tex_cache`, inclusive quando o caminho já estava em cache. A hipótese de
  que a segunda instância ficaria sem textura não se reproduziu no checkout
  atual.
- A suíte existente valida importação e dimensões das duas famílias animadas,
  mas não instancia duas cópias de um inimigo estático.

## Fontes e precedência

1. `.atena/vault/canon/PLAN-001-nottgard-survivors.md`, seções 10 e 17;
2. `SPEC-015-producao-total-de-assets-visuais.md` e
   `EVID-011-producao-total-assets.md`;
3. `data/enemies.json`, `ui/enemy_view.gd`, `ui/run.gd` e
   `tests/test_animation_assets.gd`;
4. esta spec, apenas para a correção local de renderização e sua validação.

## Escopo

- Confirmar a atribuição de textura em cache no `EnemyView` e corrigi-la apenas
  se uma instância repetida a deixar nula, sem mudar a chave de cache, os
  caminhos dos assets ou o comportamento de animações.
- Criar teste de regressão que configure duas instâncias do mesmo inimigo
  estático e confirme que as duas resolvem uma textura válida, sem fallback.
- Cobrir os 49 IDs de `data/enemies.json` com auditoria de existência e
  importação do PNG correspondente; manter as verificações de dimensão e alfa
  aplicáveis às folhas animadas.
- Exercitar uma composição de QA representativa com inimigos repetidos para
  conferir leitura, escala e ausência do retângulo vermelho no viewport do
  jogo; o teste automatizado cobre todos os IDs estáticos.
- Registrar evidência técnica e reconciliar esta spec com os testes e
  consumidores efetivamente alterados.

## Não objetivos

- Substituir, regenerar ou apagar PNGs de inimigos nesta entrega.
- Alterar IDs, dados de combate, escalas, colisão, lore, chefes ou ondas.
- Tornar os outros 47 inimigos animados; eles permanecem estáticos pelo
  contrato visual atual.
- Adicionar dependências, publicar, criar build distribuível, fazer commit ou
  push.

## Decisão artística separada: Molydeus

`molydeus_menor` e `molydeus_chefe` não são o mesmo arquivo, porém apresentam
silhuetas muito próximas. A leitura de chefe depende mais da escala de dados do
que da identidade do asset. Uma nova candidata para o chefe deve enfatizar
porte, arma, chaves/grilhões e armadura cerimonial, preservando espécie e
câmera. Essa geração e a eventual substituição de asset ficam fora desta spec
até aprovação humana explícita para arte nova.

## Plano de voo

1. Adicionar primeiro o teste de regressão para duas instâncias estáticas do
   mesmo ID e confirmar que ele reproduz a condição antes da correção.
2. Verificar que a atribuição de `tex` executa tanto no primeiro carregamento
   quanto em um acerto de cache; alterar o consumidor somente se essa condição
   não estiver satisfeita.
3. Criar a auditoria data-driven dos 49 IDs, verificando que cada caminho
   `res://assets/enemies/<id>.png` existe e é importável pelo Godot.
4. Rodar a suíte headless completa e os testes específicos de assets.
5. Capturar uma cena de QA representativa com cópias de inimigos estáticos e
   inspecionar o viewport em 1280×720; manter a cobertura de todos os IDs no
   teste automatizado.
6. Registrar os comandos, resultados e capturas em `.atena/evidence/`; comparar
   o resultado aos critérios abaixo antes de marcar a entrega como verificada.

## Critérios de aceite

1. Duas ou mais instâncias simultâneas de qualquer inimigo estático exibem o
   PNG correto; nenhuma usa o retângulo vermelho de fallback quando o arquivo
   existe e foi importado.
2. Os 49 IDs de inimigo resolvem para exatamente um PNG em `assets/enemies/`.
3. Zumbi e Sacerdote da Mente Derretida preservam suas folhas, estados e
   dimensões animadas atuais.
4. A suíte headless e os testes novos terminam sem falhas.
5. A captura de QA mostra inimigos repetidos legíveis em 1280×720, sem regressão
   de escala, sombra, barra de vida, elite ou chefe.
6. Não há mudança em dados, lore, assets finais, dependências ou serviços
   externos.

## Resultado da execução

- `EnemyView` já atribuía `tex` a partir de `_tex_cache`, tanto após o primeiro
  carregamento quanto em acertos posteriores para o mesmo caminho. A execução
  confirmou esse comportamento; nenhuma modificação no consumidor foi
  necessária.
- `test_animation_assets.gd` audita os 49 PNGs declarados em
  `data/enemies.json` e, para cada um dos 47 inimigos estáticos, instancia duas
  visualizações após limpar o cache. O teste exige textura válida e a mesma
  referência de textura em ambas as instâncias.
- A suíte completa e o smoke das nove fases passaram. A captura de Shedaklah em
  1280×720 mostra cópias estáticas sem o fallback vermelho.
- `molydeus_menor` e `molydeus_chefe` permanecem inalterados. A possível nova
  candidata artística continua fora do escopo e depende de aprovação humana.

## Evidência e reconciliação

- Saída dos testes específicos e da suíte headless completa.
- Captura de QA com IDs repetidos, fase, seed e resolução identificadas.
- Revisão do diff de `ui/enemy_view.gd` e do novo teste, vinculada a cada
  critério de aceite.
- Evidência em `.atena/evidence/` e atualização do status desta spec somente
  após confirmação independente de que o fallback permanece apenas defensivo.

Evidência técnica: `../evidence/EVID-047-integridade-visual-dos-inimigos-2026-09-27.md`.

