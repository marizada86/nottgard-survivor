---
id: "PLAN-026"
type: "plano-de-voo"
title: "Sobreposição visual das divindades"
status: "executado e reconciliado"
created: "2026-09-27"
approved: "2026-09-27"
relations:
  - "[[PLAN-001-nottgard-survivors]]"
  - "[[SPEC-033-legibilidade-visual-e-retorno-divino]]"
  - "[[RESEARCH-003-paleta-das-deidades-2026-09-27]]"
---

# PLAN-026 — Sobreposição visual das divindades

## Intenção

Implementar somente a camada visual das afinidades divinas. Cada herói mantém
sua identidade cromática inicial; depois de aceitar uma bênção de altar, a
última divindade escolhida sobrepõe sua paleta em dano, aura, projéteis,
trilhas e impactos. A aura continua ausente antes da primeira bênção.

## Escopo delimitado

- Afinidades: Shar, Sendrinah, Mask, Lliira, Ghaunadaur, Tou Um e Selûne.
- Paletas aprovadas em `RESEARCH-003`, incluindo Ghaunadaur verde com efeitos
  roxos.
- Uma estrutura de sobreposição visual, sem alterar estatísticas, comportamento
  de combate, RNG, save, loot, IA, áudio ou cenas de jogo.
- Helion permanece fora do sistema: é mago local, não deidade.

## Não objetivos

- Buffs, tiers de buff, combinação de temas, priorização de múltiplos buffs ou
  aura de buff.
- Alterar a identidade-base dos heróis; Kayron continua vermelho abissal antes
  de uma escolha de altar.
- Criar divindades, lore, assets raster, dependências, publicação ou serviços
  externos.

## Arquitetura proposta

```text
HeroBaseTheme + DivineAffinityOverlay (última bênção) -> ResolvedVisualTheme
ResolvedVisualTheme -> dano, aura, projétil, trilha e impacto
```

O overlay contém `damage_primary`, `aura_accent`, `outline` e motivos de
emissão. Qualquer projétil ou impacto recebe um snapshot dessa resolução ao
nascer, para não trocar de cor no ar se uma escolha posterior for feita.

## Critérios de aceite propostos

1. Antes de qualquer bênção, o herói usa apenas sua identidade-base e não tem
   aura persistente.
2. Após uma bênção, dano, aura, projétil, trilha e impacto usam a mesma
   paleta divina sobreposta.
3. Uma nova bênção substitui integralmente a sobreposição divina anterior.
4. Shar preserva o vermelho-base de Kayron antes da bênção; Ghaunadaur tem
   verde dominante e efeitos roxos; Helion não aparece como afinidade divina.
5. Contornos e contraste mantêm leitura em 1280×720, sem ocultar herói,
   inimigos, telegráfos, itens, interações ou HUD.
6. Não há mudanças mecânicas, consumo extra de RNG, estado visual órfão nem
   vazamento de tema entre morte, troca de cena ou nova run.
7. Testes, smoke, captura visual e evidência ADD passam antes da reconciliação.

## Plano de voo

1. Elaborar uma SPEC com o formato de `HeroBaseTheme` e
   `DivineAffinityOverlay`, seus consumidores e a matriz exata de paletas.
2. Após aprovação da SPEC, separar a identidade-base da afinidade no caminho
   visual existente e criar o resolvedor determinístico.
3. Integrar os cinco consumidores: número de dano, aura, projétil, trilha e
   impacto; aplicar snapshots aos efeitos emitidos.
4. Validar a troca entre todas as afinidades, a restauração em nova run e as
   cenas de altar, inclusive Ghaunadaur e Selûne.
5. Rodar suíte, smoke, cenários de leitura visual e revisão independente;
   registrar evidência e reconciliar fatos operacionais.

## Aprovações necessárias

A aprovação deste plano autoriza somente criar a SPEC delimitada. A execução
de código, recursos, dados e testes de integração requer aprovação explícita da
SPEC. Qualquer retorno a buffs/tier, nova entidade ou mudança mecânica requer
novo plano e aprovação.

## Registro de aprovação

O dono aprovou este plano em 2026-09-27. A aprovação autorizou a elaboração da
`SPEC-056`, mas não autoriza ainda mudanças de código, recursos, dados ou
testes de integração.

## Reconciliação

A `SPEC-056` foi aprovada e executada em 2026-09-27. A implementação manteve
o escopo de sobreposição exclusiva das sete divindades, preservou as identidades
iniciais e excluiu Helion. A evidência `EVID-086` registra suíte, smoke e as
sete capturas locais; buffs e tiers continuam fora de escopo.
