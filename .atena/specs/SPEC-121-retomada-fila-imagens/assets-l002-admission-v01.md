# L-002 — admissão conjunta de sete habilidades / v01

PLAN053/SPEC121 S007, PLAN_CHANGE_REQUEST limitada à admissão das42fontes aceitas. Proposta prospectiva; modo unconfigured, execução pendente. Não inclui geração/edição artística nova, dependência, promoção CANON ou Git. PLAN071/B006/S011 preservado.

## Entradas, autoridade e prontidão visual

[Seleção42fontes/hashes](../../generated/assets-l002-admission-2026-10-14/selected-sources.json), [aceite39fases](../../generated/assets-l002-review-2026-10-13/visual-acceptance.json), [aceiteH402v03/H406v02](../../generated/sylas-two-frame-correction-2026-10-13/visual-acceptance.json), [bíblia L002](assets-l002-review-v01.md). H403v02 histórico aprovado imutável; outras41fases aceitas DRAFT. Selecionar Sylas H402v03/H403v02/H406v02, demais39v01. H402v01/v02 e H406v01 preservados como históricos não selecionados. Autoridade ART-PROMPTS054/FILA023 rev2026-10-01, registros10bd31c e correções built-in imagegen. Nativos1254quadrados, dimensões/pivô de runtime ainda pendentes.

Identidade de personagem N/A para raster: VFX abstratos isolados, nenhum corpo/retrato. IDs dos heróis identificam destino/evento, sem lore nova. Contexto: combate isométrico, branco/cinza em preto convertidos para luz aditiva com tintas atuais. Sylas fumaça/máscaras para direita e término em resíduos; Kayron anel de arcos elétricos/centro vazio; Korrak choque radial/rachaduras/línguas de chama; Leoric oitoestrelas/constelação; Nyrelia olho/espiral; Zynara relógio/ponteiros/fragmentos; Bromnor escudo/chevrons. Preservar forma, chamas radiais e ciclos que o dono aceitou, sem reinterpretar direção artística durante integração. Pequenas diferenças de canais registradas serão tratadas tecnicamente como luminância, não repintura.

## Derivados e calibração

Godot normaliza42fontes para cópias1024 de auditoria e gera **sete atlas1536×256**, seis células256cada. Destinos assets/vfx/{sylas_passo_pelas_sombras,kayron_sobrecarga_mistica,korrak_impacto_de_xargath,leoric_constelacao,nyrelia_dominacao,zynara_suspensao_temporal,bromnor_concordia}.png/imports. RGBbranco/alfaRec709, piso<=2/255 só nos derivados. Fontes originais e versões aceitas não alteradas. Quadro selecionado continua DRAFT autorizado para uso; promoção CANON independente.

Uma origem/escala constantes por sequência, medidas geometricamente em referência aceita: origemcanvas para rastroSylas, anel/sigilo para radiais; não usar centro fotométrico como pivô nem ajustar posição/brilho por quadro. Manter glow/fragmentos dentro de margens e registrar limites; picoKorrak quase toca a borda nativa, conferir transparência/cortes no derivado. Se packing exigir redução uniforme comum aos seisquadros de uma família para margem, registrar transformação técnica sem repintar; não aplicar correções diferentes por fase. Se requer mudança artística, parar só a família afetada e apresentar antes de admitir.

## Comportamento visual por habilidade

| Família/evento estrito | Apresentação proposta | Vida útil e posição |
|---|---|---|
| Sylas/passopelassombras, active hero_id=sylas + ability_id=passo_pelas_sombras | seisfases em0,30s (20fps), rastro orientado pelo deslocamento real, escala pelo comprimento real do dash | Origem real anterior ao dash, direção da origem ao event.pos final; forma de chão por MeleeVfx.projection. Não acompanhar o herói depois, não alongar ao máximo se uma parede encurtou deslocamento. Sem deslocamento, não criar rastro; usar ringfallback. Isca/explosão existentes preservadas. |
| Kayron/sobrecargamistica, active hero_id=kayron + ability_id=sobrecarga_mistica | ciclo6quadros12fps, raio visual1,0tile, centro vazio, aura_accent da ativação | Seguir herói enquanto Battle.active_buff_t>0 (7s atuais), terminar quando buff acabar. Sem criar/reaplicar aceleração. |
| Korrak/impactodexargath, nova weapon=impacto_de_xargath + dtype=fogo, battle.hero.id=korrak | pulso6fases0,35s, impact_accent, raio do evento nova existente | Posição fixa do evento no chão; somente nova toca atlas. Evento active mantém ring/áudio/ação atuais, sem segundo atlas. Dano/roubo/burn/alcance inalterados. |
| Leoric/constelacao, active hero_id=leoric + ability_id=constelacao | pulso6fases0,35s, raio visual fixo2tiles (o eventoactive mantém alcance11 dos projéteis; ver resultado), aura_accent | Origem fixa de ativação. Não substituir oito projéteis nem admitir orbes neles; velocidade/alcance/dano/count permanecem. |
| Nyrelia/dominacao, active hero_id=nyrelia + ability_id=dominacao | ciclo6quadros12fps, raio estético0,85tile, aura_accent da ativação, sob o alvo dominado | Resolver ID do alvo efetivamente escolhido uma vez; seguir esse Enemy enquanto vivo, presente em battle.enemies e charmed_t>0 (7s atuais). Não escolher outro mais próximo. Terminar em morte, remoção ou fim de domínio. Ativação falhada não cria atlas. |
| Zynara/suspensaotemporal, active hero_id=zynara + ability_id=suspensao_temporal | pulso6fases0,35s, aura_accent, raio visual do evento (7tiles atuais) | Posição fixa da ativação; é feedback breve, não anel persistente ou nova área lógica. time_slow_t/4s e alvos reais da simulação permanecem, sem limitar o código global ao raio desenhado. |
| Bromnor/concordia, nova weapon=concordia + dtype=radiante, battle.hero.id=bromnor | pulso6fases0,35s, impact_accent, raio do evento nova existente | Posição fixa da nova; active conserva ring/áudio/ação atuais, sem segundo atlas. Guarda5s/carga/repulsão/dano não alterados, não manter escudo desenhado após pulso. |

Arlindo/Erik e heróis anteriores fora dessa allowlist não recebem estesatlas. Snapshot de cor na ativação/nova, sem misturar família por dtype compartilhado ou icon_like. Radiais usam projeção elíptica de chão conforme receita atual; não aplicar rotação de projétil a anéis. Rastro usa alcance/direção real. Tamanho e brilho finais precisam de avaliação humana em runtime.

## Integração, metadados e limites

Ampliar os helpers locais existentes **core/hero_active_vfx.gd e ui/hero_active_vfx.gd** com seleção explícita por sete IDs, sem framework genérico novo. ui/run.gd conecta active/nova, preservando fallback e Brook/Maelor. Reusar SpriteFrames/cache/projeção/convenções atuais. Um efeito por habilidade/run, reativação substitui anterior, sem estado por inimigo além da referência ao alvo escolhido. Simulação continua dona de charges/buffs/charm/cooldown/dano/RNG.

**core/battle.gd: somente dois metadados opcionais no evento active bem-sucedido.** Para dash_weaken de Sylas, salvar posição anterior e acrescentar `visual_origin`; direção/comprimento derivam de event.pos já existente menos origem. Para charm de Nyrelia, acrescentar `visual_target_id` (instanceID) do charm_target efetivamente selecionado. Não fazer segunda busca nearest, nova rolagem ou mudar ordem/escolha de alvo. Capturar variáveis para apresentação, preencher chaves apenas nesses eventos depois do sucesso. Sem esses campos/IDs inválidos, usar fallback, não inferir origem/alvo. Não alterar definições, lógica ou conteúdo de outros eventos. Auditoria do diff e comparação determinística com baseline antes da mudança comprovam escopo.

Pausa do SceneTree e battle.state não running suspendem avanço visual; fimdead/won/runfree limpa tudo; alternar reduzido remove atlas ativo. Kayron usa active_buff_t, Nyrelia usa charmed_t do alvo, nenhuma duração lógica nova. Pulsos/rastro expiram em tempo de jogo running, acompanhando speed_scale como controlador atual. Retomar pausa não reinicia os quadros nem cria efeito duplicado.

Reduzido, metadado faltante, alvo ausente, atlas ausente/inválido conservam ring/procedural anterior. Dimensões/células validadas antes de suprimir fallback. Não falhar toda a família por falta de outra textura; não deixar loop preso. Korrak/Bromnor usam _nova_effect: tentar atlashero somente em nova qualificada e preservar Pulso/Ampulheta/outros caminhos. Não duplicar o atlas no evento active.

## Caminhos, impacto e recuperação

Permitidos: setePNG/imports novos; core/hero_active_vfx.gd, ui/hero_active_vfx.gd, ui/run.gd; core/battle.gd somente metadados acima; novo teste focado/UID; artefatos .atena/generated/assets-l002-admission-2026-10-14/ e registros ADD/backlog. Proteger por hash data, ui/overlay.gd, core/melee_vfx.gd, helpers/camada/atlases/testes dos trêsprojéteis, Pulso/Ampulheta, recursos dos heróis e atlas Brook/Maelor/L001. Testes existentes não reescritos para mascarar regressão.

Antes: backup verificável de quatro scripts/estados, inventário novos destinos e hash de todas áreas protegidas. Recuperação restaura esses scripts e referências, mantém novas candidatas não selecionadas e fontes antigas; nada apaga arquivos históricos/resetGit. Não inclui mudança material de arquitetura, deps, permissões, geração, publicação, exportação, commit/push/merge. Caso apareça necessidade fora do limite, analisar impacto/checkpoint antes de executar.

## Etapas, lotes e validação

1. S001/B001: revalidar42hashes/aceites, backups; normalizados/seteatlas; auditoria de alfa/margens/resíduos/silhueta/calibração e prévias técnicas. PASS antes de instalar.
2. S002/B002: metadados mínimosSylas/Nyrelia e dispatch/helpers; integração do rastro e trêsloops (Kayron/Nyrelia e regressão Brook), preservandoMaelor. Checks reais do dash encurtado/zerado, alvo fixo/remoção e duração/pausa.
3. S003/B002: quatro pulsosKorrak/Leoric/Zynara/Bromnor (Korrak/Bromnor só nova), fallback, tints, lifetimes e teto por habilidade. Garantir oito projéteisLeoric e guardas/efeitos lógicos intactos.
4. S004/B003: teste focado, suíte completa e smoke9fases; capturas por seteativações reais/seisfases, oito direçõesSylas, duas tintas, pausas/reduzido, recurso ausente/inválido, origem/alvo metadados ausentes, buff/charm expirado/morte/remoção, recast/runfree, Korrakmargens/raioZynara. **Comparação determinística da Battle anterior à mudança vs atual**, com seeds/alvos/movimento/bloqueio/fracasso suficientes: RNG/HP/dano/status/cargas/timers/trajetórias/eventos idênticos exceto duas chaves visuais e IDs de instância canonicalizados. Snapshot antes/depois da apresentação também igual fora do consumo normal dos eventos. Regressões L001/corpoacorpofísico/C/D/trêsprojéteis/Pulso/Ampulheta/Arlindo/Erik; áreas protegidas iguais por hash. APPDATA/save QA isolados.
5. S005/B003: contrato/links/hashes/evidência/estado reconciliados, build local0.4.0+l002 identificado, galeria/roteiro/atalhos de sete heróis e modos para playtest. Técnico5/5 pode concluir; sensação/leitura/ritmo aguardam relato humano.

Modalidades: per-plan autoriza S001–S005 no escopo completo; per-batch B001/B002/B003 estáveis; per-step pausa antes de cada S001…S005. Modo **unconfigured** não executável. Aceite visual autorizou preparar esta proposta, não executar normalização ou integrar.

## Prontidão e playtest

BLOCKING: aprovação deste escopo/modo. RESOLVABLE: calibrações/margens, metadados e lifecycle emS001–003, com checksS004. Defaults recomendados rastro0,30s, pulsos0,35s, ciclos12fps; Kayron1tile/Nyrelia0,85tile e demaisraios do evento; mesmos buffs/cooldowns. DEFERRED: conforto e legibilidade humanos, playtests anteriores sem relato e bugs025/027/028/029. Nenhum outro bloqueio principal conhecido.

Antes de cada playtest informar build/escopo/objetivo/procedimento. Roteiro a preparar: seteheróis emDagruve/perfilQA; Sylas em8direções e perto de parede/isca; Kayron mover e observar fim7s; Nyrelia dominar alvo/mover/matar/expirar sem salto para outro; Korrak/Bromnor pulso sem duplicar atlas e lógica da guarda preservada; Leoric oito projéteis; Zynara flash breve com lentidão4s preservada; duas tintas/reduzido/pausa. Observar fumaça/máscaras, raios/chamas/estrelas/olho/relógio/escudo, alinhamento e sobreposição/conforto. Feedback esperado herói/modo/cor/direção, aceitável ou problema e fase/ciclo/pulso. Atena verifica funcionamento/consistência; dono avalia sensação/dificuldade/diversão. Métricas não provam diversão; sem relato playtest permanece pendente.

## Autorização

Dono selecionou1Porplano para escopo integralv01. Modo per-plan aprovado; menções anteriores a unconfigured são histórico da proposta. [Recibo](../../generated/assets-l002-admission-2026-10-14/authorization.json). BLOCKING de aprovação resolvido.

## Resultado e esclarecimento de calibração

Técnico5/5 entregue,42fontes/seteatlas/setehabilidades, suíte0/smoke9,paridade140cenários/12600passos e221capturasPASS. Leoric usa raio visual2tiles previsto: evento na verdade traz11 de p.range; não alterar evento/projéteis. Premissa incorreta da proposta corrigida explicitamente após primeira captura, mantendo tamanho visual pretendido e gameplay. Apenas quatro scripts autorizados mudaram; fontes/áreas protegidas intactas. [Evidência](../../evidence/assets-l002-admission-2026-10-14.md), [roteiro](../../generated/assets-l002-admission-2026-10-14/PLAYTEST.md). Feedback humano runtime pendente; sem CANON/Git/exportação.
