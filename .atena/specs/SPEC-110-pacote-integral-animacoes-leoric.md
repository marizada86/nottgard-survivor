---
id: "SPEC-110"
title: "Pacote integral de animações e efeitos de Leoric"
status: "aprovada pelo dono em 2026-09-30; lote inicial gerado; revisão de arte pendente"
created: "2026-09-30"
relations:
  - "[[PLAN-049-animacoes-integrais-dos-herois-2026-09-30]]"
  - "[[PLAN-001-nottgard-survivors]]"
  - "[[SPEC-105-inventario-animacoes-e-efeitos-herois]]"
  - "[[SPEC-106-pacote-integral-animacoes-durvall]]"
  - "[[SPEC-044-aprovacao-rastreavel-de-assets-oficiais]]"
  - "[[EVID-133-inventario-visual-herois-2026-09-30]]"
---

# SPEC-110 — Pacote integral de animações e efeitos de Leoric

## Intenção

Produzir candidatos revisáveis para completar a leitura direcional de Leoric e
dar suporte visual às ações que já existem, usando o voo de prova de Durvall
como modelo. O primeiro lote é deliberadamente pequeno: valida a silhueta
lateral, a marcha oposta independente, o gesto de conjuração e a leitura de
Constelação antes de qualquer ampliação. Não altera combate.

## Escopo

- Cobrir somente Leoric: `idle`, oito movimentos, ataques por família, `active`,
  dano e morte, sempre como candidatos isolados.
- Completar o contrato de oito fontes independentes de movimento. Hoje existem
  `move_n`, `move_ne`, `move_e`, `move_se` e `move_s`; faltam `move_sw`,
  `move_w` e `move_nw`.
- Seguir a matriz de famílias já auditada: `attack_melee`, `attack_bolt`,
  `cast_nova` e `cast_zone`; a arma inicial Sopro de Estrela usa `nova`.
- Tratar a habilidade Constelação (`star_burst`) como ativação radial: a pose
  preserva o facing disponível e o VFX mostra a formação de oito estrelas sem
  substituir os projéteis ou as regras runtime existentes.
- Gerar primeiro quatro pranchas transparentes de prova, não tiras finais:
  `move_e`, `move_w`, `attack_bolt_e` e `constellation_star_burst`.

## Contrato visual

Leoric é um gnomo adulto, baixo e compacto, com cartola preta de faixa marrom,
barba grisalha cheia, sobretudo marrom gasto, cajado de madeira entalhada e
foco azul. A pixel art deve preservar a leitura dos PNGs oficiais atuais:
câmera isométrica 3/4, corpo inteiro, luz superior esquerda, contorno nítido e
base consistente. A energia azul do foco é um acento; Constelação acrescenta
estrelas radiantes douradas e azuis sem ocultar o corpo.

Cada futura tira corporal usa células RGBA `256×384`, quatro quadros para
`idle`/ataques e seis para movimento/`active`/morte. O lote inicial usa pranchas
de contato RGBA `1536×1024`: grade 3×2 para cada movimento e 2×2 para ataque e
VFX. Essas pranchas servem somente à revisão; não são assets importáveis.

## Não objetivos

- Não substituir ou normalizar os PNGs oficiais, o retrato, a skin ou os dados
  de Leoric.
- Não mudar atributos, armas, habilidade, velocidade, cooldown, alcance,
  projéteis, dano, colisão, VFX procedurais, SFX ou regras de combate.
- Não gerar arte para os outros nove heróis, inimigos, interface ou cenário.
- Não admitir candidatos, publicar, enviar, mesclar ou criar dependências.

## Critérios de aceite

1. O lote de prova contém as quatro pranchas nomeadas, com transparência real,
   sem texto, cenário, moldura, marca-d'água ou outro personagem.
2. `move_e` e `move_w` mostram seis poses distinguíveis de marcha, em sentidos
   opostos, com pés e chapéu legíveis; `move_w` não é um espelhamento de arquivo.
3. `attack_bolt_e` mostra quatro fases distinguíveis — preparar, apontar o
   cajado, emissão azul breve e recuperação — dirigidas para leste visual.
4. `constellation_star_burst` mostra quatro fases de formação/expansão de oito
   estrelas, separado do corpo e compatível com a leitura em escala de jogo.
5. Corpo, cartola, barba, sobretudo, cajado e foco preservam a identidade
   oficial; não há aparência infantil/chibi, troca de arma ou redesenho de lore.
6. Nenhum arquivo sob `assets/`, `data/`, `ui/` ou `core/` é alterado. Os
   candidatos, prompts, manifesto e revisão ficam somente em
   `.atena/generated/leoric-animation-package/v01/`.
7. Antes de ampliar o lote, a revisão registra proporção, base, variedade de
   pose, recorte, leitura em escala de jogo e decisão do dono para cada prancha.

## Impactos previstos

Somente novos candidatos e documentação sob `.atena/generated/`, mais uma
evidência local após a revisão. A implementação runtime e os assets oficiais
permanecem intactos até uma aprovação rastreável posterior conforme SPEC-044.

## Plano de voo

1. Registrar os caminhos oficiais, o estado local pré-existente e a cobertura
   do inventário; não tocar em alterações de outros trabalhos.
2. Congelar para a prova somente cinco referências oficiais de animação:
   `idle.png`, `move_e.png`, `move_s.png`, `attack.png` e `active.png` em
   `assets/animations/heroes/leoric/`.
3. Após autorização explícita de transferência dessas cinco referências, gerar
   as quatro pranchas no ImageGen integrado e copiá-las para o diretório de
   candidatos da SPEC, sem sobrescrever nenhum arquivo.
4. Inspecionar visualmente transparência, identidade, contagem de poses,
   silhueta, base e leitura em tamanho de jogo; registrar o prompt e o resultado.
5. Apresentar a prancha de revisão ao dono. Somente uma decisão explícita pode
   autorizar normalização em tiras, expansão do pacote ou admissão posterior.
6. Reconciliar paths, hashes, evidência e critérios de aceite. Não fazer commit,
   push, publicação ou integração nesta SPEC.

## Riscos e controles

| Risco | Controle |
|---|---|
| Leoric perder a identidade atual ao usar referências antigas | As cinco fontes oficiais atuais são as únicas referências externas permitidas; comparar cartola, barba, cajado, foco e escala antes de avançar. |
| `move_w` ser só uma inversão visual | Exigir marcha independente e revisar sequência/posição da mão no cajado. |
| Efeito radial cobrir o personagem | Gerar o VFX separado e validar âncora/composição somente após revisão. |
| O lote de contato ser confundido com uma tira final | Declarar os candidatos como pranchas não importáveis e mantê-los fora de `assets/`. |
| Transferência remota excessiva | Limitar explicitamente a cinco PNGs; qualquer referência adicional exige nova autorização. |

## Gate de execução

O dono aprovou esta SPEC e autorizou, em 2026-09-30, o envio ao ImageGen
integrado das cinco referências listadas no passo 2. A autorização vale somente
para o lote inicial de quatro pranchas e não aprova normalização, substituição
de assets ou alterações runtime.

## Execução inicial — 2026-09-30

O ImageGen integrado recebeu exclusivamente `idle.png`, `move_e.png`,
`move_s.png`, `attack.png` e `active.png` de
`assets/animations/heroes/leoric/`. Foram selecionadas quatro pranchas em
`.atena/generated/leoric-animation-package/v01/candidates/`; cada uma mede
`1536×1024`, tem alfa 0 no canto `(0,0)` e no espaço central entre células.
O primeiro `move_e` e o primeiro VFX não cumpriram a dimensão de prova e foram
preservados como candidatos v01 não selecionados; as versões v02 corrigidas são
as selecionadas. O manifesto e a evidência [[EVID-137-lote-inicial-leoric-
2026-09-30]] registram prompts, hashes e a revisão técnica.

Nenhum arquivo oficial, lógica de runtime, dado ou regra de combate foi
alterado. A próxima decisão é a revisão artística do dono por prancha; ela não
autoriza, por si só, normalização ou admissão.
