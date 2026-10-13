# SPEC-121 — Admissão local de Erik e Arlindo / v01

Estado: **proposta DRAFT; execução pendente de aprovação**. Preparada em 2026-10-13 antes de implementação. Origem: continuação solicitada do checkpoint de retratos; não é spec post-hoc.

## Intenção e autoridade

Admitir as 18 tiras/101 quadros DRAFT aceitos na frente PLAN-053, substituindo a integração antiga v04 sem redesenhar as personagens. [Manifesto local de destinos, bytes atuais e candidatos](../../generated/hero-admission-preparation-2026-10-13/admission-manifest.json) e [inventário aceito importado sem alteração](../../generated/hero-final-four-2026-10-13/accepted-hero-inventory.json) delimitam os arquivos. Recibos anteriores cobrem preparação visual, não admissão nem CANON. AO01/ER01 v01 são os mesmos bytes dos retratos atuais; não precisam de cópia/substituição. Aceite visual destes dois retratos neste checkpoint fica pendente.

A continuidade foi recuperada do worktree ffff, somente lido. [Snapshot do estado anterior](../../generated/hero-admission-preparation-2026-10-13/provenance/hero-final-four.yaml) preserva sua proveniência. O PLAN-071 B-006/S-011 e seus retornos permanecem registrados no estado central; esta proposta é PLAN_CHANGE_REQUEST da frente de arte, não autorização para retomar ranking ou executar integração. Não há inferência de autorização de merge entre worktrees.

## Bíblia visual aplicável — DRAFT v01

Autoridade textual: [ART-PROMPTS-060](../../generated/ART-PROMPTS-060-erik-e-arlindo-jogaveis.md), SPEC-160 e referências aceitas por hash nos recibos do inventário. Referências atuais de acabamento: `assets/portraits/brook.png` e `leoric.png`. AO01/ER01 v01, e idles AO02/ER02 candidatas v02, foram vistos nesta preparação. Referências históricas de identidade 036–038 no antigo worktree 20f4 não estão acessíveis nesta sessão; não serão inventadas ou promovidas. O escopo usa as fontes preservadas e os idles expressamente aceitos, sem produção artística nova nem revisão da identidade.

- Arlindo: rosto envelhecido, barba grisalha curta, chapéu marrom, sobretudo escuro, cachecol vinho e luvas; magia teal/violeta. AO01 mostra mãos juntas e rua molhada com lampião âmbar.
- Erik: adulto forte, cabelo/barba escuros, cicatriz na testa, cachecol creme, couro/pelo, espada às costas e amuleto luminoso; tocha no sprite. ER01 mostra ruínas/floresta fria e foco dourado no peito. Ambas as imagens são pictóricas e compatíveis com as referências de acabamento na inspeção do modelo; isso não constitui aceite humano.
- Cena: seleção/ficha/HUD para retratos; Dagruve e demais cenários existentes para sprite isométrico, luz superior esquerda e porte 62/64 px. Preservar câmera, UI e cadência existentes. Sem nova lore, personagem, cenário ou acessório.
- Animações: identidade, desenhos, efeitos, poses e proporções já aceitos; ER03 tem sete poses, ER06 seis (última fonte v03). Exceções aceitas AO04=14 px, AO07=13 px, ER06=13 px permanecem restritas aos hashes aprovados; limite geral 12 px não muda.
- Legibilidade/acessibilidade: validar retratos no tamanho real de menu/HUD e efeitos a 62/64 px; opinião humana permanece pendente. Sem alteração de contraste/opções de acessibilidade neste lote.
- Produção: somente empacotamento técnico por Godot local; sem geração remota, dependência ou redesenho. Identidade não é N/A: há duas entidades nomeadas. Novos cenários e áudio são N/A ao escopo.

## Proposta técnica e escopo limitado

O runtime atual usa 384×384 por herói, ER03=7 e ER06=5. As candidatas aceitas usam 256×384 (movimento/idle) e 512×512 (ações). Copiá-las diretamente quebraria as regiões do atlas.

Recomendação: derivados comuns de **512×512**, sem reamostragem/pintura. Colar cada célula 256×384 em (128,80) da nova célula, alinhando centro x=256 e pés y=448. As ações 512×512 já têm centro/base 256/448 e permanecem iguais. Medir e confirmar cada base antes de admitir; divergência interrompe a etapa. Não escalar os desenhos para preencher a célula. Comparar RGBA por quadro após retirar o padding, com igualdade exata; preservar hashes dos atlas aceitos.

Após autorização: atualizar exclusivamente células/base de Arlindo/Erik no `ui/hero_view.gd` para 512×512/y448 e ER06 para seis quadros. Manter display 62/64, alturas corporais 290/300, ER03=7, taxas, espelhamento, habilidades, unlocks e demais heróis. Derivar `assets/heroes/arlindo.png` e `erik.png` da primeira pose idle com a mesma âncora, verificando uso/fallback. Admitir 18 destinos de animação definidos no manifesto. Não alterar os retratos idênticos; registrar sua conferência. Não atualizar genericamente `move.png` se não usado/existente: inspecionar consumidores antes e resolver como ajuste IN_PLAN documentado.

Arquivos de código permitidos: `ui/hero_view.gd`; testes/ferramentas de validação diretamente afetados pela célula/base/contagem. Candidatos, backups e evidências ficam em `.atena/generated/hero-admission-2026-10-13/` e registros operacionais relacionados. Nenhuma promoção CANON neste plano. Guardar inventário e bytes anteriores de todos os destinos alterados, código e testes antes de substituir. Rollback restaura os bytes de backup e as tabelas antigas, sem reset Git nem remoção de dados.

## Etapas e lotes estáveis

1. **S-001 / B-001 — Derivados e prévia:** backup verificável, 18 atlas/101 quadros e dois estáticos 512×512 DRAFT, auditoria de igualdade RGBA/padding/âncoras/margens, galeria. Entrada: manifesto e recibos aceitos. Saída: manifesto de derivados e comparação. Gate: escopo/modo aprovados; qualquer diferença artística exige novo aceite.
2. **S-002 / B-002 — Admissão local:** substituir só destinos aprovados, aplicar tabelas de célula/base/ER06 e adaptar validações afetadas. Entrada: S-001 PASS. Saída: integração local reversível. Sem nova aprovação entre etapas quando per-plan estiver aprovado.
3. **S-003 / B-003 — Verificação:** importação Godot, teste de animações/suíte, smoke das nove fases e capturas reais dos dois heróis em idle, oito direções/espelhamento, ataque, ativa e morte; perfil QA isolado. Conferir seleção, ficha/HUD e fallback estático; não gravar no save real. Comparar resultados com critérios e registrar falhas.
4. **S-004 / B-003 — Evidência e convite de playtest:** hashes, links, checklist de contrato, backup e critérios reconciliados. Publicar apenas resultado local no chat, explicar procedimento antes de solicitar playtest. Concluir entrega técnica se checks passarem; aceite subjetivo continua pendente até feedback humano.

Modo: **unconfigured**, não executável. Opções: per-plan, per-batch (B-001/B-002/B-003) ou per-step (S-001…S-004). Commit, push, merge, exportação, publicação e compartilhamento externos ficam fora desta proposta.

## Prontidão e critérios

**BLOCKING:** aprovação explícita do escopo de admissão e escolha do modo; necessários porque a autorização anterior terminou na preparação. Aceite humano dos retratos deve identificar AO01/ER01 v01; se retidos, mantê-los atuais e delimitar por escrito o escopo de animações. Não promover CANON por aprovação operacional.

**RESOLVABLE no S-001:** uniformizar células/base sem alterar pixels; confirmar margens, uso estático e consumidores. Recomendada a opção 512×512 acima. Se não couber ou houver perda/alteração, parar antes da escrita em `assets/`.

**DEFERRED:** opinião sobre fluidez/beleza, dificuldade/diversão, quatro bugs globais abertos, áudio emprestado, publicação e Git. Aprovação técnica não fecha BUG-025/027/028/029.

Aceite técnico: 18 atlas/101 poses e dois estáticos válidos, nenhum corte ou mudança de pixels da fonte, âncoras/base e porte coerentes, ER03=7/ER06=6, recursos/ações carregados, checks sem regressão, fontes e save real preservados. Aceite artístico dos retratos e movimento pelo dono é independente.

Playtest futuro (ainda não realizado): checkout local com esta integração, Dagruve, mesmo gameplay. Objetivo: avaliar continuidade, porte, pés e efeitos completos no tamanho real. Procedimento: escolher cada herói; andar 30–60 s nas oito direções, observar ataque automático, acionar ativa, testar morte quando possível; conferir menu/HUD. Registrar herói/direção/ação/quadro e captura se houver corte, salto de tamanho, troca da mão ou efeito ilegível. Critério técnico: ausência desses defeitos; feedback humano esperado: aparência/fluidez aceitáveis ou defeitos específicos. Atena confere funcionamento; o dono avalia sensação e prazer de jogar.

## Autorização de execução — 2026-10-13

Dono: “Aprovo os dois retratos v01” e “1. Por plano — uma aprovação para todo o escopo planejado.” Modo per-plan aprovado para todo o escopo acima. Gates de escopo/modo e retratos resolvidos; os estados de pendência na proposta original são histórico anterior ao aceite. Nenhum BLOCKING de aprovação permanece. [Recibo](../../generated/hero-admission-2026-10-13/authorization.json). Conteúdo permanece DRAFT, sem promoção CANON.

## Resultado da execução

Quatro etapas técnicas concluídas. [Evidência](../../evidence/hero-admission-2026-10-13.md) e [verificação](../../generated/hero-admission-2026-10-13/verification.json). Entrega local DRAFT; aceite humano em runtime pendente. Gates de Git/publicação/CANON não foram acionados.
