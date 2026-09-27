# SPEC-035 — Defesas tipadas e crítico por excedente

Status: implementada com testes automatizados aprovados (2026-09-27). Smoke visual pendente de falha preexistente fora do escopo.

## Intenção

Substituir a sobreposição atual entre CA/CAM e esquiva por defesas tipadas de leitura simples e tornar o crítico consequência de uma rolagem de ataque excepcional, sem permitir imunidade geral ou transformar um erro em acerto.

## Estado atual relevante

- CA/CAM são defesas de d20 contra ataques físico/mágico; um 20 natural acerta;
- `dodge` é uma segunda rolagem independente depois do acerto;
- crítico é 20 natural ou faixa expandida, dobra o dano e pode acionar efeitos extras;
- críticos de faixa expandida são atualmente acertos automáticos, mesmo quando o total não supera a defesa do inimigo.

## Proposta A — CA/CAM como esquiva tipada

- `CA` concede esquiva contra dano físico e `CAM` contra dano mágico;
- somente pontos acima de 10 contam: `esquiva tipada = 3% × max(0, defesa - 10)`;
- teto da esquiva tipada: 30%; teto combinado com esquiva genérica: 45%;
- os dois valores combinam multiplicativamente, não por soma;
- precisão de elites/chefes reduz a esquiva tipada; a tabela exata é calibrada no playtest;
- a Maré de Névoa é perigo ambiental: não usa CA, CAM nem esquiva genérica. Resistência específica à névoa pode reduzir parte do dano, mas não anulá-lo.

Exemplo: CA 20 dá 30% de esquiva física. Com 10% de esquiva genérica, a chance combinada é 37%, abaixo do teto de 45%.

## Proposta B — crítico por excedente (recomendada)

1. Um 1 natural sempre erra e não pode critar.
2. O ataque precisa acertar normalmente antes de poder critar.
3. Um 20 natural sempre acerta e é crítico garantido.
4. Para os demais acertos, calcular `total de ataque = d20 + proficiência + modificador do atributo + precisão + bônus da habilidade`.
5. `excedente = max(0, total de ataque - 20)`.
6. `chance de crítico = min(40%, excedente × 3% + bônus de crítico)`; rolar essa chance uma vez.
7. Crítico mantém multiplicador inicial de 2×; efeitos de crítico existentes só disparam quando a rolagem realmente crítica.

Exemplo solicitado: 19 no d20 + modificador de Força 3 (mais modificadores aplicáveis, se houver) resulta em total ao menos 22. O excedente de 2 concede 6% de chance de crítico antes de bônus. Um 20 natural continua crítico garantido.

## Por que 3%, não 4–5%

- 3% torna personagens iniciais normalmente críticos em cerca de 6–8% dos acertos e permite que builds dedicadas cresçam até o teto aprovado;
- 4–5% acelerariam demais builds com alta precisão e muitos projéteis, especialmente quando críticos ativam efeitos adicionais.

## Migração de bônus existentes — proposta

- `crit_range: 1` passa a `crit_overflow_bonus: 0.03`;
- `crit_range: 2` passa a `crit_overflow_bonus: 0.06`;
- `crit_step` passa a acrescentar 3 pontos percentuais a cada dois níveis, preservando o ritmo atual da melhoria Sorte;
- nomes, textos de itens, bênçãos, conquista e passivas deixam de prometer “19–20” e passam a indicar a chance adicional por excedente;
- ataques/zonas que não fazem rolagem não podem critar, salvo uma regra explícita própria.

## Impactos

- reescrever a resolução de acerto e crítico do combate;
- migrar dados de heróis, itens, passivas, bênçãos, upgrades e conquistas que usam `crit_range`/`crit_step`;
- atualizar HUD/descrições e testes determinísticos;
- rebalancear bônus de precisão de inimigos, elites e chefes após a conversão da defesa tipada.

## Critérios de aceite

1. CA 20/CAM 20 nunca produzem imunidade e respeitam o teto composto.
2. Maré de Névoa não pode ser anulada por CA, CAM ou esquiva genérica.
3. 1 natural erra; 20 natural acerta e crita; um crítico por excedente exige acerto normal.
4. O caso 19 + 3 = 22 resulta em 6% de chance de crítico antes de bônus externos.
5. Chance final de crítico nunca excede 40% fora de uma exceção explicitamente aprovada.
6. Dados, descrições, testes e efeitos de crítico permanecem coerentes após a migração.

## Plano de validação após aprovação

1. Testes headless determinísticos para os limiares de defesa, esquiva, precisão e crítico.
2. Simulações com heróis iniciais, builds defensivas e builds de precisão.
3. Medição de dano por segundo e taxa real de crítico por fase.
4. Playtest da Maré de Névoa após chefe, verificando clareza, decisão e ausência de imunidade indevida.
