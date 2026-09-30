---
id: "PLAN-041"
title: "Skin de Leoric: cartola preta e sobretudo marrom"
status: "aprovado para preparação local; geração e admissão continuam bloqueadas"
created: "2026-09-29"
relations:
  - "[[ASSET-APPROVAL-REGISTER-011-leoric-regenerado-2026-09-27]]"
  - "[[SPEC-049-preparacao-da-regeneracao-do-piloto-de-leoric]]"
  - "[[EVID-081-leoric-admissao-oficial-2026-09-27]]"
---

# PLAN-041 — Skin de Leoric: cartola preta e sobretudo marrom

## Direção do dono

A skin de Leoric passa a ter **cartola preta** no lugar do chapéu de mago e
**sobretudo marrom** no lugar do manto verde-musgo. A referência anexada pelo
dono é a âncora estética; ela não será enviada a nenhum serviço externo sem
autorização específica.

## Achado e impacto

Os assets oficialmente admitidos em 2026-09-27 ainda definem Leoric como um
gnomo astrônomo com chapéu largo, manto verde-musgo, constelações douradas e
foco azul. A mudança proposta substitui dois desses traços de identidade
visual, mas não altera nome, papel, habilidades, hitbox, animações, SFX, dados
ou gameplay.

Para a skin ser coerente, todas as aparições visuais de Leoric devem refletir a
mesma silhueta: seleção (`assets/heroes/leoric.png`), retrato
(`assets/portraits/leoric.png`) e os nove strips em
`assets/animations/heroes/leoric/`. Os contratos já usados pelo runtime se
mantêm: PNG RGBA, célula 256×384, base em y=367, frames e direções atuais.

## Escopo proposto

- Trocar o chapéu de mago por uma cartola preta, com copa e aba legíveis em
  escala de jogo e sem ocultar rosto, barba ou orelhas.
- Vestir Leoric com sobretudo marrom de leitura nítida, preservando corpo
  adulto, barba grisalha e silhueta isométrica 3/4.
- Reinterpretar somente os detalhes visuais que conflitem com a referência.
  O foco azul e os detalhes de constelação só permanecem se a aprovação do
  piloto mostrar que não competem com a nova roupa.
- Produzir, avaliar e admitir somente os mesmos onze artefatos visuais já
  existentes: sprite estático, retrato e nove strips (`idle`, `move_n`,
  `move_ne`, `move_e`, `move_se`, `move_s`, `attack`, `active`, `death`).

## Não objetivos

- Mudar lore, classe, Sopro de Estrela, Constelação, habilidades, números,
  cenas, colisão, UI, áudio ou gameplay.
- Criar uma skin selecionável, sistema de cosméticos ou variantes adicionais.
- Alterar arquivos oficiais antes da seleção artística e da admissão explícita.
- Transferir a referência anexada, gerar imagens, contratar serviço ou gastar
  créditos sem autorização posterior e específica.

## Critérios de aceite

1. Em sprite, retrato e cada frame, Leoric é identificável por cartola preta e
   sobretudo marrom; nenhum chapéu de mago ou manto verde-musgo permanece.
2. A cartola e o sobretudo mantêm uma silhueta clara em 72 px, com rosto, barba
   e pés visíveis, sem recorte nem VFX escondendo o personagem.
3. Os nove strips preservam quantidade de frames, ordem, direção, tamanho,
   transparência, base e margens exigidos pelo runtime; o espelhamento continua
   funcionando nas três direções derivadas.
4. A seleção, o retrato e uma run de QA mostram a mesma skin, sem regressão de
   carregamento, animação ou legibilidade sobre o cenário.
5. Os PNGs atualmente oficiais são preservados com hashes antes de qualquer
   admissão; o registro canônico, lock e evidência de runtime são reconciliados
   somente após aprovação explícita do lote final.

## Plano de voo

1. **Especificar após aprovação deste plano.** Criar uma SPEC limitada e um
   brief local que registrem a referência, a paleta, o que permanece de Leoric,
   prompts/negativos e a matriz dos onze artefatos. Nenhuma imagem será gerada.
2. **Preparar um piloto reversível.** Mediante autorização para geração local,
   produzir fora de `assets/` um trio de validação: sprite estático, retrato e
   `idle`. Validar cartola, sobretudo, transparência, base e leitura em escala
   real.
3. **Gate artístico.** Apresentar o piloto ao dono. Só o aceite do piloto libera
   as oito animações restantes; rejeição ajusta o brief, não os arquivos
   oficiais.
4. **Expandir e validar.** Preparar os demais strips em área versionada;
   verificar frames, alfa, margens, base, direções, espelhamento e captura no
   runtime.
5. **Admitir somente com ordem explícita.** Fazer backup dos onze PNGs oficiais,
   promover os candidatos aceitos, reimportar no Godot, rodar a regressão,
   atualizar hash lock, registro de aprovação e evidência.
6. **Reconciliar.** Registrar o resultado e exceções na SPEC/evidência; atualizar
   o cânone visual apenas quando a admissão estiver aprovada e demonstrada.

## Gates e decisões do dono

| ID | Decisão necessária | Recomendação |
| --- | --- | --- |
| D1 | Aprovar esta nova intenção visual e o plano? | Aprovar o plano para criar apenas a SPEC e o brief local. |
| D2 | A cartola e o sobretudo devem substituir todas as aparições de Leoric, inclusive retrato? | Sim; evita duas identidades visuais no jogo. |
| D3 | Manter foco azul e constelações douradas como detalhes discretos? | Sim, desde que o piloto preserve a leitura da cartola e do sobretudo. |
| D4 | Autorizar depois a geração local de candidatos? | Decidir somente após revisar a SPEC; sem transferência da referência sem uma autorização separada. |
| D5 | Admitir o lote nos paths oficiais? | Decidir somente após ver o piloto/lote e a evidência de QA. |

## Riscos e mitigação

- **Silhueta alta da cartola:** pode sair da célula ou dominar o sprite. O piloto
  mede margem superior e leitura em 72 px antes de expandir as animações.
- **Incoerência entre arte estática e movimento:** o piloto inclui sprite,
  retrato e `idle`; a admissão exige revisão conjunta dos onze artefatos.
- **Deriva do personagem:** barba, proporção adulta e postura isométrica são
  âncoras obrigatórias; a roupa muda, não o personagem jogável.
- **Sobrescrita indevida:** candidatos ficam fora de `assets/`; a promoção é um
  gate separado, com backup, hashes e aprovação expressa.

## Aprovação do plano

O dono aprovou este plano em 2026-09-29. A autorização cobre somente a criação
da SPEC e do brief local previstos no passo 1. Ela não autoriza geração,
transferência da referência anexada, gastos, alteração de assets oficiais ou
reconciliação canônica.

## Estado atual

Lote admitido e validado após autorização explícita do dono. Os oficiais
anteriores foram preservados, o lock/registro foram atualizados, e a correção
mínima do helper de textura em `ui/run.gd` permitiu concluir smoke e testes.
