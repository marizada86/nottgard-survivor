---
id: "SPEC-099"
title: "Integração das HQN-11 a HQN-14 no jogo"
status: "em execução — plano de voo aprovado"
created: "2026-09-30"
relations:
  - "[[PLAN-040-hqs-novas-highlights-do-vault-2026-09-29]]"
  - "[[SPEC-080-hqs-de-transicao-do-nottcard]]"
  - "[[SPEC-098-geracao-de-hqs-trilha-b]]"
  - "[[EVID-124-hqn-11-a-14-candidatas-2026-09-30]]"
---

# SPEC-099 — Integração das HQN-11 a HQN-14 no jogo

## Descoberta

As 16 imagens finais de HQN-11 a HQN-14 estão aprovadas em
`.atena/generated/art-candidates/hq/`. HQN-14 Q1 usa a v02 aprovada; a v01
anterior permanece preservada. Os 16 quadros finais têm 1672×941 pixels e
somam cerca de 37,66 MiB. O projeto ainda não tem `assets/hq/`, `data/hqs.json` ou leitor de
HQs. As quatro histórias já estão ligadas a conquistas existentes no
[[PLAN-040-hqs-novas-highlights-do-vault-2026-09-29]].

## Interpretação e escopo

"Todas as imagens" refere-se às 16 imagens finais recém-aprovadas de HQN-11 a
HQN-14, quatro quadros por história. Integrá-las como quatro HQs jogáveis e
reassistíveis:

1. Copiar as 16 imagens finais para `assets/hq/hq_n<nn>_q<n>.png`, sem alterar
   os originais ou redimensionar os PNGs aprovados. A interface preserva a
   proporção ao exibi-los.
2. Criar `data/hqs.json` com título, conquista de desbloqueio e caminho de
   imagem por quadro. Usar somente falas/legendas já registradas em
   `ART-PROMPTS-029` e `PLAN-040`; não escrever lore ou texto novo.
3. Adicionar leitor em tela cheia: clique/Enter avança, Esc encerra a HQ; ao
   ganhar pela primeira vez a conquista correspondente, exibir a HQ uma vez
   antes do resultado da run.
4. Adicionar a aba Diário no Quartel para abrir HQs cujo requisito já consta
   em `profile.data.achievements`. Isso também torna as HQs acessíveis em
   perfis antigos que já tenham as conquistas, sem reprodução automática após
   a atualização.
5. Mapear os gatilhos existentes: HQN-11 → `cacador_de_chefes`; HQN-12 →
   `aluris`; HQN-13 → `mestre_de_camadas`; HQN-14 → `pilares_ativos`.

Como o evento de conquista só é novo uma vez, não é necessário adicionar estado
de HQ ao perfil nem migrar saves. A lista do Diário deriva das conquistas já
existentes.

Essas escolhas de exibição valem somente para HQN-11 a HQN-14 e não resolvem
as decisões pendentes de SPEC-080 sobre as HQs antigas do Nottcard.

## Não objetivos

- Não integrar HQN-01 a HQN-10, HQN-15 a HQN-18 ou as HQs antigas do Nottcard.
- Não criar conquistas, recompensas, textos, lore ou gatilhos novos.
- Não redimensionar, editar ou sobrescrever as candidatas aprovadas.
- Não mudar combate, progressão existente, esquema de conquistas ou outros
  sistemas de assets.
- Não fazer merge ou publicação além do push da branch solicitada.

## Critérios de aceite

1. Os 16 arquivos em `assets/hq/` correspondem byte a byte às versões finais
   aprovadas (HQN-14 Q1 v02; demais quadros v01); candidatos originais seguem
   preservados.
2. Os quatro registros em `data/hqs.json` apontam para 4 imagens válidas cada,
   com títulos e conquistas corretos.
3. Uma conquista recém-obtida abre a HQ associada uma única vez antes da tela
   de resultado; derrota ou execução sem nova conquista não abre HQ.
4. Clique/Enter avança quadro a quadro e Esc encerra imediatamente; a HQ
   disponível pode ser aberta novamente pelo Diário.
5. Perfis existentes sem campo adicional continuam válidos; o Diário revela
   apenas histórias cujo requisito já foi obtido.
6. Layout mantém imagens inteiras, sem distorção ou corte, em 1280×720 e
   1920×1080; testes automatizados e smoke test do Godot passam.
7. Evidência registra hashes, testes e commits. Arte e mecânica ficam em
   commits separados, conforme PLAN-040; ambos são enviados à branch remota
   dedicada, sem incluir alterações alheias preexistentes.

## Impactos

- Novos PNGs em `assets/hq/` e atualização do estado de geração em
  `ART-PROMPTS-029`.
- Novo catálogo declarativo, leitor, integração no resultado da run, aba Diário
  e testes. Sem mudança no formato do save.
- Branch `codex/hq-story-integration` criada a partir do `main` limpo e
  sincronizado com `origin/main`; sem alterações alheias no checkout.
- O CLI `game-dev` da habilidade de vendoring de assets não está instalado.
  A integração proposta é de arte já gerada, aprovada e pertencente ao projeto;
  usará o destino `assets/hq/` já proposto pela SPEC-080, comparação SHA-256 e
  validação de importação do Godot, sem alegar recibo de vendoring externo.

## Plano de voo

1. Concluído: plano aprovado; branch dedicada criada a partir do `main` limpo.
2. Concluído: 16 imagens admitidas e comparadas por SHA-256; commit de arte
   `11d0c60`.
3. Concluído: catálogo, leitor, gatilhos de conquista, Diário e testes
   automatizados implementados; commits de mecânica e evidência pendentes.
4. Concluído: suíte `tests/run_all.gd` e smoke test do Godot passaram. A cena do
   leitor usa âncoras de tela cheia e `KEEP_ASPECT_CENTERED`.
5. Em andamento: concluir reconciliação, registrar commits finais e fazer push
   da branch para `origin`; não fazer merge.

## Evidência e reconciliação

O plano está aprovado. A evidência final será registrada em
`.atena/evidence/` com inventário e hashes das imagens admitidas, resultados dos
testes, links para os commits e destino do push.
