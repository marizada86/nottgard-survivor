# PLAN-029 — Triagem da evidência QA de 2026-09-27 (Leoric transparente + backlog de UX)

Status: **achado de Leoric encerrado (resolvido pelo dono, 2026-09-27); backlog
de UX (notas 1–5) segue proposto, aguardando priorização.**

> Nota do dono (2026-09-27): "o leoric já foi resolvido, essa evidência é um
> pouco antiga; considere que qualquer atualização a partir das 19:20 pode ser
> posterior a essa evidência." Esta evidência (EVID-088) permanece como registro
> histórico do que foi observado na sessão QA-20260927-200612, mas **não deve
> ser usada para reabrir ou reavaliar o estado atual do asset de Leoric** — o
> estado atual já foi corrigido por trabalho posterior não coberto por este
> documento.

## Contexto observado

Recebido `NS-EV-qa-20260927-200612.zip`, pacote exportado pelo kit de
evidências (perfil `qa`) descrito em
[[SPEC-020-ferramentas-playtest-e-qa]]. Cópia integral do conteúdo em
[[EVID-088-qa-leoric-dagruve-2026-09-27]]. A sessão contém 6 notas e 6
capturas de tela, todas dentro de uma run com **Leoric em Dagruve** (regra
`rituals`, nível 15/16, 24/24 PV), embora o campo `qa.cenario` herdado do
Navegador QA ainda aponte para `qa.durao.running` — imprecisão de rótulo, não
perda de dados, já registrada em EVID-088 para decisão futura.

Este documento apenas categoriza a evidência e propõe encaminhamento. Nenhuma
implementação foi iniciada.

## Achado de Leoric — ENCERRADO (regressão visual, Nota 6)

**Status: resolvido.** As hipóteses e passos de verificação abaixo ficam como
registro do raciocínio original; nenhuma ação adicional é necessária aqui. Se
uma regressão semelhante aparecer no futuro, este histórico pode ser reciclado.

> "o personagem Leoric está funcionando mas seu asset está bugado, quase
> transparente com pixel soltos."

As seis capturas da sessão não mostram um sprite de personagem visível na
posição do jogador, o que corrobora o relato. Isso ocorre no mesmo dia em que
o lote de Leoric foi admitido como oficial ([[SPEC-049-preparacao-da-regeneracao-do-piloto-de-leoric]],
[[EVID-081-leoric-admissao-oficial-2026-09-27]]) — é uma regressão recente, não
um problema histórico.

### Hipóteses, em ordem de verificação

1. **Alfa insuficiente/corrompido no lote v01 admitido.** `ui/hero_view.gd`
   espera 9 folhas de `256×384` por célula (`idle`×4, `move_*`×6 cada,
   `attack`×4, `active`×6, `death`×6 — os mesmos 50 frames que SPEC-049
   registra como gerados). Os "contratos técnicos" validados em SPEC-049
   cobrem dimensão, margem de 8 px e base em y=367, mas **não** verificam
   cobertura/opacidade da silhueta. Uma folha com alfa majoritariamente baixo
   (personagem quase todo transparente, com poucos pixels opacos residuais)
   passaria por esses contratos sem ser percebida.
2. **Import desatualizado.** Os nove `.import` de Leoric aparecem como
   modificados no `git status` atual — consistente com reimportação recente —
   mas vale confirmar que nenhum ficou com textura em cache de um estado
   intermediário do lote.
3. **Deslocamento/escala fora do quadro.** `hero_view.gd` usa
   `DISPLAY_HEIGHT = 72.0` sobre células de 384 px (`scale ≈ 0.1875`); se o
   conteúdo de algum frame não estiver centrado na célula 256×384 esperada, o
   resultado renderizado poderia ficar minúsculo ou fora da área visível.
4. **Conflito de composição.** Improvável: `sync_visual()` só altera
   `modulate` do sprite para os estados `dead` (alfa 0.65) ou `flash`; Leoric
   estava com 24/24 PV e sem flash nas capturas, então não deveria haver
   modulação ativa.

### Verificação proposta (não destrutiva, antes de qualquer correção)

1. Comparar os PNGs oficiais atuais de Leoric com o backup em
   `previous-official/` (referenciado em EVID-081) quanto a canal alfa e
   cobertura de pixels opacos por frame.
2. Rodar o jogo no perfil QA/editor e observar Leoric parado (`idle`), fora de
   combate, para confirmar se o problema aparece já em repouso.
3. Se a hipótese 1 se confirmar, a mitigação mais segura e imediata é reverter
   localmente para os PNGs em `previous-official/` (backup já existente),
   mantendo `ASSET-OFFICIAL-LOCK-011.json` sob revisão, enquanto um novo lote é
   preparado sob spec própria.

## Backlog de UX/feature (Notas 1–5)

| Nota | Tema | Resumo | Encaminhamento sugerido |
|---|---|---|---|
| 1 | Navegação por teclado na tela de level-up | Escolher opções/recompensas com WASD + Enter | Estender estado `levelup`/`altar` já coberto por SPEC-020, ou nova spec pequena de input acessível nas decisões de run |
| 2 | Menu de pausa (Esc) | Catálogo de itens (desbloqueados visíveis, bloqueados escurecidos e sem info), tela de opções/configurações, guia de "como jogar" | Nova spec de escopo maior — toca Quartel/Códex existentes; recomenda-se especificar separadamente do restante do backlog |
| 3 | HUD — progresso da fase | Barra indicando tempo restante até o fim do mapa | Adição pontual de HUD; verificar se há spec de HUD ativa para anexar |
| 4 | Ficha de personagem em run | Tecla `C` abre efeitos/itens/magias/bênçãos coletados na run atual | Nova spec pequena, autocontida |
| 5 | Legibilidade dos números de dano | Aumentar tamanho/contraste dos números; referências citadas: "Death Must Die" e "Vampire Survivors" | Ajuste visual pontual; avaliar se cabe como revisão de [[SPEC-033-legibilidade-visual-e-retorno-divino]] |

## Plano de voo

1. Confirmar com o dono a prioridade: tratar a regressão de Leoric (Nota 6)
   primeiro e isoladamente, por comprometer um herói recém-admitido como
   oficial.
2. Abrir uma spec dedicada só para a regressão visual (hipótese, reprodução,
   critério de reversão), no mesmo padrão de investigação usado em
   [[PLAN-004-regressao-movimento-sudoeste-2026-09-23]].
3. Para as notas 1–5, agrupar em specs por afinidade (decisões de run; menu e
   meta/catálogo; HUD; legibilidade) e priorizar com o dono antes de abrir
   qualquer uma. Nenhuma implementação começa sem spec aprovada
   (`autonomy.execution_approval: per-spec` em `.atena/add.yaml`).
4. Registrar EVID de cada execução, no padrão já usado no projeto.

## Critérios de aceite (desta triagem)

1. As 6 notas da sessão `NS-EV-qa-20260927-200612` estão categorizadas e
   rastreáveis a uma spec futura ou já aberta.
2. A regressão de Leoric tem hipóteses ordenadas e um passo de verificação
   não destrutivo definido antes de qualquer correção.
3. Nenhum arquivo oficial (`assets/`, locks, save) foi alterado por esta
   triagem — apenas documentação em `.atena/`.

## Limites

- Esta triagem não abre, aprova nem executa nenhuma spec nova por conta
  própria; aguarda decisão do dono item a item.
- Nenhum commit git foi feito; `git.local_commits` e `publishing` continuam
  sob aprovação explícita conforme `.atena/add.yaml`.
