# SPEC-045 — Diagnóstico limitado dos assets de Nyrelia

Status: **diagnóstico concluído — aguardando decisão de direção de arte** (2026-09-27).

## Intenção

Executar o primeiro gate aprovado do PLAN-014: separar defeito comprovado de
percepção visual ainda não observada em runtime. Esta SPEC não altera os
assets, o lock oficial, metadados, cenas, código ou identidade de Nyrelia.

## Fontes e precedência

1. PLAN-014 aprovado pelo dono em 2026-09-27;
2. o lock e o registro canônico de aprovação vigente, que mantêm os nove
   strips como bytes oficiais com ressalvas visuais;
3. arquivos atuais sob `assets/` e cópias recuperáveis da SPEC-043;
4. comportamento efetivo de `ui/hero_view.gd` e
   `ui/sprite_strip_frames.gd`;
5. observação visual do dono como sinal prioritário a ser reproduzido, não
   como justificativa para substituir bytes sem diagnóstico.

## Escopo

- Inventariar as nove folhas de Nyrelia, sua geometria por frame, margens e
  linha de base.
- Confirmar como o runtime cria `SpriteFrames`, escala e ancora os strips.
- Relacionar hero asset, retrato e ícone à identidade visual de referência,
  sem tratá-los como substitutos automáticos do sprite animado.
- Preparar a evidência e o plano de piloto para `idle`, `move_se` e `attack`.

## Não objetivos

- Criar candidato, editar PNG, `.import`, cena, SFX, código, dados ou lock.
- Corrigir conteúdo, escolher estilo, regenerar arte, chamar provedor remoto
  ou consumir orçamento.
- Alterar lore, máscara, arma, habilidade, atributos, colisão, y-sort ou
  gameplay.

## Baseline executado

- `tools/analyze_nyrelia_frames.gd` abriu e percorreu os 50 frames declarados
  nas nove folhas: `idle` (4), cinco movimentos-fonte (30), `attack` (4),
  `active` (6) e `death` (6).
- Em todos os 50 frames, o limite alfa fraco alcança `y=368`, a linha de base
  esperada pelo runtime. A margem horizontal mínima observada é de 8 px; não
  há pixel alfa cruzando uma divisão de célula de 256 px.
- `ui/hero_view.gd` aplica especificamente `NYRELIA_BASELINE_Y = 368` e escala
  a célula de 384 px para 72 px de exibição. Como todas as nove folhas estão
  presentes, o asset estático `assets/heroes/nyrelia.png` é apenas fallback e
  não explica a aparência da animação em uma run normal.
- Assim, ainda não há prova de defeito de base/corte nos bytes atuais. O risco
  residual está em leitura na escala de jogo, ritmo de quadros, VFX e
  coerência perceptiva entre ações. A captura QA interativa continua
  necessária para decidir se há reparo.
- O utilitário `game-dev` não está disponível neste host; como não haverá
  geração, normalização nem package nesta SPEC, a auditoria local de Godot é
  a fonte técnica usada nesta fase.

## Resultado da cena QA aprovada

- As capturas de runtime foram executadas no renderer normal em Dagruve e em
  duas cenas QA novas, externas à run normal. A tentativa headless não produz
  framebuffer; não foi usada como evidência estética.
- `SPEC-045-nyrelia-qa-baseline-v3.png` mostra `idle`, `move_se` e `attack`
  em escala real e 2,35x, ancorados no mesmo ponto lógico de chão.
- `SPEC-045-nyrelia-pilot-frames.png` congela os 14 frames dos três clips
  pilotos no `AnimatedSprite2D` efetivamente construído pelo runtime.
- `idle` e `move_se` mantêm o contato com o chão, mas sua silhueta é quase
  só contorno dourado na escala real. Nos quatro frames de `attack`, não há
  corpo/silhueta estável e legível que acompanhe o efeito.
- Os backups anteriores à normalização têm hashes diferentes, mas mostram a
  mesma leitura insuficiente. A normalização alterou o alinhamento, não criou
  esse problema de direção de arte.

## Recomendação e próximo gate

O piloto deve ser classificado como `regerar ou redesenhar manualmente`, nunca
como simples ajuste de âncora, brilho ou recorte. A recuperação automática não
consegue reconstruir a silhueta ausente de `attack`, e uma recoloração
arbitrária mudaria a direção de arte sem decisão do dono.

O próximo passo exige escolha humana entre manter a exceção atual, produzir um
brief de retoque manual, ou produzir uma proposta de regeneração. As duas
últimas opções precisam de uma SPEC posterior com referência visual, escopo de
clips, política de licença e, para qualquer provedor remoto, autorização de
orçamento explícita.

## Critérios de aceite desta fase

1. Os nove strips e todos os 50 frames possuem resultado de leitura e
   geometria rastreável.
2. A hipótese de desalinhamento de base ou vazamento entre células é aceita ou
   descartada por medida, e não por inferência.
3. O próximo gate deixa explícito que não há autorização para editar bytes
   oficiais antes de aprovação adicional.
4. Evidência, lock e registros canônicos permanecem coerentes e aditivos.

## Verificação

- A cena QA e a folha de frames renderizaram com sucesso no renderer normal.
- `tests/run_all.gd` terminou com zero falhas depois da adição dos artefatos de
  QA. Os avisos conhecidos de log e certificados do ambiente não afetaram o
  resultado.
- Os PNGs oficiais e o lock não foram alterados. Uma eventual admissão de
  candidato continua sendo um gate independente.
