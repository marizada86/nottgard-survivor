# Orbe Radiante — normalização e admissão / v01

Estado: proposta DRAFT, execução pendente; modo unconfigured. PLAN-053/SPEC-121, PLAN_CHANGE_REQUEST limitada à admissão visual desta família. Preparada antes da implementação. [Recuperação/hashes](../../generated/orbe-radiante-review-2026-10-13/recovery.json), [aceite visual](../../generated/orbe-radiante-review-2026-10-13/visual-acceptance.json), [revisão/bíblia](orbe-radiante-review-v01.md). P01 v01 mantém aprovação histórica do registro027; P02–P08 v01 aceitos DRAFT pelo dono. Nenhuma promoção CANON.

## Escopo e prontidão visual

Oito fontes RGB1254×1254 aceitas: P01–P04 voo em loop, P05–P08 impacto. Identidade de personagem N/A: projétil abstrato compartilhado. Núcleo branco/halo cinza, estrelas e cauda à esquerda para voo à direita, impacto máximo P06 e dissipação P07/P08. Referências ART-PROMPTS-053/FILA022 e P01 aprovado. Contexto: combate isométrico, projétil elevado16px sobre posição projetada; voo orientado pela direção projetada, impacto no alvo. Sem cenário/arma/personagem/lore novo. Legibilidade96px aceita; ritmo/tamanho/brilho em jogo ainda pendentes. Não achatar o orbe como uma zona de chão; orientação segue `Iso.to_screen(dir)` e posição atual. Fontes intactas.

Somente projéteis owner=hero, kind=bolt, dtype=radiante, arma em `raio_de_luz`, `luz_mais_pura`, `marca_da_retidao`. Sem outras armas/habilidades, projéteis inimigos, Orbe Arcano ou Onda Cortante. Não alterar raio lógico0,4, velocidade/alcance, count/spread, pierce, hit/miss, críticos, status, dano, timers, áudio ou RNG.

## Proposta técnica e impacto

Godot local produzirá oito cópias1024×1024 para auditoria e dois atlas1024×256 (quatro células256×256 cada): `assets/vfx/orbe_radiante_voo.png` e `assets/vfx/orbe_radiante_impacto.png`. Redução uniforme do canvas1254→256, sem reposicionar/redimensionar fases individualmente. Converter somente derivados para RGB branco/alfa luminância Rec.709, piso<=2/255zero, material aditivo; fontes preservadas byte a byte. Registrar filtro/transforms/hashes/margens e resíduos de P08. Não quadrar a luz por duplicar luminância em RGB e alfa.

Default proposto: voo12fps (loop de quatro em≈0,333s); impacto quatro fases em0,24s, uma vez, sem flash adicional. Canvas/pivô comum128/128; calibrar raio do núcleo de P01 para aproximadamente5px, preservando tamanho do círculo procedural atual, e pico principal P06 para aproximadamente12px, raios decorativos fora dessa medição. Uma escala comum por animação, não por quadro; medir/registrar valores exatos em S-001. Cauda prevista próxima à atual14px, conferir em captura. Se deslocamento, corte ou perda de aparência exigir mudança além desta calibração, parar e apresentar derivado antes da admissão.

Voo atual é círculo5px+linha14px em `ui/overlay.gd`, na posição `Iso.to_screen(pr.pos)+(0,-16)`; `pr.p` já carrega arma/tipo. Proposta: helper `core/radiant_orb_vfx.gd` para allowlist, textura/cache e impacto; camada visual própria `ui/radiant_orb_layer.gd` Node2D aditiva desenha os voos elegíveis a partir da lista existente, sem inserir IDs/estado em projéteis ou alterar simulação. Relógio exclusivamente visual, suspenso com pausa da batalha/árvore. Overlay deixa de desenhar o fallback somente quando a camada e os recursos válidos atenderem o projétil. Ausência/atlas inválido deve conservar círculo+linha. Essa camada não altera material/cor dos demais elementos do overlay. Sem alocação de nós por projétil por frame; camada removida junto ao overlay/run.

O evento primário de dano `hit` em `Battle._hero_hit` hoje não contém arma/kind. Mudança limitada em `core/battle.gd`: acrescentar `weapon` (usando `_audio_id`/id já existentes) e `kind` do parâmetro ao dicionário do hit primário, sem alterar ordem/quantidade de eventos ou execução. Eventos secundários de onda crítica/ambiente/reflexo permanecem sem atribuição para este efeito. Não inventar impacto em miss, expiração ou saída do mapa; cada hit primário qualificado, inclusive perfuração real, mostra um impacto. `ui/run.gd` encaminha hits elegíveis, fora do limite/merge de números de dano; não duplicar dano, áudio, partículas existentes ou efeito em hits secundários. Hit segue posição do alvo com o mesmo deslocamento vertical16px. Voos usam `visual_theme.primary`, impactos `visual_theme.impact_accent`, preservando snapshots existentes de tinta divina. Sem interferir em Pulso/Ampulheta ou efeitos atuais.

Com Reduzir efeitos de impacto, conservar apresentação procedural de voo e efeitos mínimos atuais; nenhum novo flash/atlas de impacto. Recursos ausentes/inválidos retornam ao fallback sem erro de script. Impactos têm duração limitada e liberação ao fim; respeitar pausa/transição de cena e evitar sobreposição ilimitada (limite visual explícito e testado; não descartar hits da simulação). Essas adaptações do renderer e metadados fazem parte do escopo solicitado, sem subsistema ou dependência novos.

## Etapas e recuperação

1. **S-001 / B-001 — Derivados e prévia.** Revalidar fontes/aceites; snapshot hashes/backups. Produzir cópias, dois atlas e relatório de filtro/alfa/pivô/calibração. Conferir oito fases, margens, cores/resíduos e continuidade; sem instalar antes de PASS técnico.
2. **S-002 / B-002 — Admissão local.** Instalar dois atlas/helper/camada e adaptar overlay, roteamento hit em run e somente metadados descritos em battle. Checks: allowlist, posição/direção/tinta/cadência, fallback, impacto reduzido, pausas e liberação; manter simulação igual.
3. **S-003 / B-003 — Verificação.** Teste focado, suíte completa, smoke9fases; capturas reais e eventos das três armas, oito direções projetadas, voo/impacto nas oito fases, transição P04→P01, duas tintas, multitiro/pierce/crit/miss, fim de vida/ausência de recurso/reduzido/pausa/limpeza. Comparar simulação com backup em cenário determinístico para igualdade de RNG, dano, projéteis/hits/pierce e eventos salvo os dois metadados. Verificar que hits secundários e demais famílias mantêm apresentação anterior. APPDATA e saves QA isolados.
4. **S-004 / B-003 — Entrega/playtest preparado.** Reconciliar contrato, hashes, links e evidência; identificação de build local e roteiro/launcher sem exportação. Técnico pode concluir4/4; feedback humano runtime permanece pendente até relato do dono.

Arquivos permitidos: dois PNG/imports; helper/camada novos e UIDs; `ui/overlay.gd`, `ui/run.gd`; edição restrita de metadados em `core/battle.gd`; testes focados/registro na suíte se necessário; ferramentas/artifacts em `.atena/generated/orbe-radiante-admission-2026-10-13/`; registros ADD/backlog. Dados/gameplay e demais assets protegidos por hash, exceto edição de metadados explicitamente descrita. Backups verificáveis antes da escrita; novos destinos inventariados. Recuperação restaura bytes anteriores e remove referências novas sem reset Git nem apagar fontes históricas. Não instalar dependência, gerar/pintar imagens novas, promover CANON, commitar, push, merge, publicar ou exportar.

Modo **unconfigured**, não executável: escolher per-plan; per-batch com B-001/B-002/B-003; ou per-step S-001…S-004. Mesmo com per-plan, parar se surgir alteração visual não prevista ou lacuna técnica relevante.

## Prontidão e aceite

BLOCKING: aprovação deste escopo/modo. RESOLVABLE em S-001/S-002: calibração exata e cache/camada limitados, preservação de resíduos e anotação de hit. Defaults descritos acima são recomendados. DEFERRED: feedback de intensidade/ritmo/legibilidade em jogo, playtests anteriores, demais famílias VFX e BUG025/027/028/029. PLAN071 B006/S011 preservado. Nenhuma outra pendência principal impede iniciar após aprovação.

Aceite técnico: fontes intactas, dois atlas válidos, oito fases e pivôs/direções corretos, somente três armas, sem retângulo de fundo ou cortes, fallback/reduzido preservados, custo visual limitado, ausência de nós órfãos, simulação inalterada e suíte/smoke PASS. Aceite subjetivo depende do dono.

Antes de cada playtest humano informar build e escopo. Procedimento preparado em S-004: projeto local0.4.0+orbe-radiante-admission-v01, perfil QA em Dagruve; usar Raio de Luz, Luz Mais Pura e Marca da Retidão, mirar em oito direções, observar voo e hits perfurantes em piso claro/escuro, repetir com tinta divina alternativa e Reduzir efeitos. Objetivo: confirmar orientação, conforto, leitura de voo/impacto e ritmo. Feedback esperado: arma/modo/cor, aceitável ou problema e fase/direção; screenshot quando útil. Atena confere funcionamento/consistência; o dono avalia sensação. Playtest não realizado.

## Autorização

Dono escolheu “1. Por plano — uma aprovação para todo o escopo planejado. (Recomendado)”. Escopo v01 integral aprovado, modo per-plan; os trechos de proposta/unconfigured acima descrevem o estado anterior. [Recibo](../../generated/orbe-radiante-admission-2026-10-13/authorization.json). Nenhum BLOCKING de aprovação permanece.

## Resultado

Admissão local DRAFT entregue,4/4técnico, por escopo per-plan aprovado. Dois atlas e três armas; suíte0falhas/smoke9fases/paridade80cenários/23capturas. [Evidência](../../evidence/orbe-radiante-admission-2026-10-13.md), [roteiro de playtest](../../generated/orbe-radiante-admission-2026-10-13/PLAYTEST.md). Feedback humano em runtime permanece pendente. Nenhuma promoção CANON ou operação Git.
