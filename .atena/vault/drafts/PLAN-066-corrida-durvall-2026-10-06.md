---
id: PLAN-066
title: Refinamento da corrida de Durvall
created: 2026-10-06
status: B002_AWAITING_VISUAL_REVIEW
origin: guided-add
implementation_preceded_spec: false
approval_mode: per-batch
approved: 2026-10-06
approved_checkpoint: B-002
spec: "../../specs/SPEC-133-corrida-durvall-2026-10-06.md"
---

# Refinamento da corrida de Durvall

A recomendação é ampliar a passada por meio de novas poses e aprovar um piloto antes de produzir todas as direções. O primeiro piloto mantém seis quadros e 10 fps para avaliar a contribuição da arte com a velocidade atual.

## Plano de voo

| Lote | Trabalho | Entrega e checkpoint |
|---|---|---|
| B-001 | Diagnóstico local de Durvall: captura uniforme, referência do chão, apoios, ciclo, escala e transições | Comparação da baseline e guia de poses; nenhuma alteração oficial. |
| B-002 | Piloto E: contato, compressão/apoio, impulso/recuperação e alternância da outra perna; câmera e corpo consistentes | Candidata em tamanho real e ampliada; decisão visual do dono antes de ampliar a produção. |
| B-003 | Produzir e revisar SE, NE, S, N, W, SW e NW a partir do piloto aceito | Oito fontes de corrida coerentes; aprovação por sequência; originais preservados. |
| B-004 | Admitir aprovadas, selecionar fontes de Durvall no runtime, testar e preparar playtest local | Relatório, hashes e rollback local; commit e publicação dependem de autorização própria. |

Passos estáveis: S-001 baseline; S-002 guia; S-003 autorização de referência/geração; S-004 piloto; S-005 comparação e gate; S-006 direções restantes; S-007 gates por sequência; S-008 admissão/roteamento; S-009 testes; S-010 evidência e reconciliação.

Em 2026-10-06, o dono pediu testar a v03 no jogo antes de decidir. Classificação IN_PLAN em S-005: preparar cópia local jogável com adaptador visual E/W e alternância F8 atual/piloto. Esse adaptador serve à revisão; não admite a arte oficial nem inicia B-004. Cópia, cache e perfil ficam separados do projeto principal, sem alteração da velocidade.

## Comparações recomendadas

A comparação principal é atual versus nova passada, ambas com seis quadros a 10 fps. Avaliar lado a lado sobre o mesmo chão, com Durvall na escala de 60 pixels e velocidade base de 190 pixels/s.

Se a nova arte precisar de ajuste fino, apresentar uma segunda comparação de cadência somente para Durvall, por exemplo 10 e 12 fps, sem escolher automaticamente. Não repetir como padrão a tentativa rejeitada de 15 fps/speed_scale.

Uma versão com oito quadros pode melhorar a distribuição das fases do movimento. Ela exige seleção explícita e adaptação de contagem somente para Durvall; duração de ciclo e cadência entram na comparação. Não alterar contagens ou fps globais dos heróis.

## Preservação visual

Espada Sombria, mão, anatomia, rosto, cabelo, armadura e roupa permanecem como nas referências oficiais. A origem corporal fica estável; apoio dos pés, compressão e eventual suspensão são poses intencionais. O enquadramento deixa margem para a passada maior e a espada. Nenhuma correção automática por escala individual de quadro.

## Aprovação e produção

Modo recomendado: **por lote**, porque o resultado do piloto determina o restante da produção. Também há modo por plano ou por etapa. Em qualquer modo, o gate visual permanece antes da admissão de cada sequência.

Modo selecionado: **por lote**. B-001 concluído na [EVID-169](../../evidence/EVID-169-durvall-corrida-b001-2026-10-06.md), com [guia E](durvall-guia-piloto-e-2026-10-06.md). B-002 e o uso das três referências no ImageGen aprovados em 2026-10-06; três tentativas registradas na [EVID-170](../../evidence/EVID-170-durvall-piloto-e-b002-2026-10-06.md). S-005 aguarda decisão visual e revisão da direção artística antes de continuar.

A geração usa ImageGen. As referências locais autorizadas são assets/animations/heroes/durvall/idle.png, move_e.png e move_se.png. Seu uso foi autorizado no S-003, conforme SPEC-106; nenhuma referência adicional do usuário foi enviada.

Nenhum candidato será sobrescrito sobre o oficial durante a revisão. A aprovação do plano não substitui o aceite da arte, nem autoriza commit, push, publicação ou mudanças de gameplay. O estado central passa a registrar este plano após a aprovação do B-001 em 2026-10-06.

## Aceite e recuperação

Os [critérios da SPEC-133](../../specs/SPEC-133-corrida-durvall-2026-10-06.md) incluem leitura de corrida pelo dono, contato dos pés, loop, identidade, oito fontes independentes e ausência de regressões nos outros heróis. Recusar o piloto preserva a baseline e limita a revisão ao lote; no máximo três tentativas antes de rever a direção artística.

A entrega encerra somente o recorte Durvall validado. As pendências dos outros personagens, a arte já rejeitada pelo dono e o backlog geral não são promovidos a concluídos.
