# Sylas — correção agrupada de H402/H406 / v01

PLAN053/SPEC121 S007, PLAN_CHANGE_REQUEST limitada às duas exceções do L002. Proposta prospectiva preparada após o dono aceitar39fases DRAFT e reservar H402v01/H406v01 para correção. Essa decisão autoriza preparar a proposta, não gerar ou integrar. Modo unconfigured até escolha explícita. H403v02 histórico preservado;39fases aceitas não serão refeitas. Sem promoção CANON/Git/admissão/exportação. PLAN071/B006/S011 preservado.

## Prontidão visual e entradas

Autoridade ART-PROMPTS054/FILA023 rev2026-10-01, [bíblia L002](assets-l002-review-v01.md), [manifesto42hashes](../../generated/assets-l002-review-2026-10-13/manifest.json), [aceite39/exclusões](../../generated/assets-l002-review-2026-10-13/visual-acceptance.json). Entidade/personagem N/A: VFX isolado de Passo pelas Sombras, sem corpo/retrato. Contexto textual: fumaça horizontal rasgada para direita, glints abstratos de máscara, vista superior plana, branco/cinza em preto, origem no centro do canvas, margens seguras, futura tinta aditiva em combate isométrico. Nenhum ajuste de lore/gameplay.

Referências locais inspecionadas: H401v01 início e H403v02 pico para crescimento; H405v01 quebra para dissipação. H402v01/H406v01 são **alvos de edição** preservados como histórico, não referências de geometria correta. H403v02 é referência de estilo/identidade imutável, não alvo. H401/H405 são referências de sequência, não alvos. Cada entrada tem caminho/hash no recibo de prompts. H403v02 SHA256 d9b23e455cf3b7a83e8e6c10820227b2cb829cb09949ed2b1abeb16bb9aa9919.

H402v01 excede pico: largura visível1022px contra649px, luminância média7,38 contra4,99; cauda longa passa muito à esquerda da origem. H406v01 mantém cabeça/rastro coerentes e5758pixels de luminância>128 contra5512emH405. Corrigir forma/fase, não disfarçar só com opacidade ou deslocamento por script.

## Produção limitada

Usar skill imagegen, modo built-in, edição com referências locais vistas antes de cada chamada; uma chamada por imagem, duas imagens distintas, nunca spritesheet. Fundo preto opaco preservado (`transparent_background=false`); alfa técnico será tratado só em futura admissão aprovada. Pedir canvas quadrado1024; se gerador retornar outra resolução quadrada, registrar tamanho nativo e diferir normalização sem reamostrar. Sem CLI/API/key/dependência nova.

**H402v02:** reconstituir somente a fase de crescimento, entre H401 e H403. Fumaça/ribbon para direita com a mesma linguagem pintada; extensão principal aproximadamente60%do pico. Origem no centro, efeito predominantemente no lado direito, cabeça aproximadamentex0,78–0,82/y0,5, sem cauda atravessando o lado esquerdo como emv01. Menos área/brilho/alcance que o pico, maior que início; conservar motivos discretos de máscara. Não regenerar o pico, inventar arma/personagem ou aumentar halo.

**H406v02:** substituir cabeça/seta/rastro contínuos por poucos fragmentos e specks muito fracos, coerentes com os remanescentes de H405. Sem ponta brilhante reconhecível, linha contínua, máscaras inteiras ou reacendimento. Quase todo canvas preto; resíduos ficam nos locais finais do efeito aceito. Precisa terminar mais fraco/fragmentado que H405, legível como dissipação também96px.

Salvar nativos novos como siblings `sylas_passo_pelas_sombras_grow_v02.png` e `sylas_passo_pelas_sombras_specks_v02.png` sob art-candidates/vfx/sylas_passo_pelas_sombras. Se um destino já existir, não sobrescrever: usar próxima versão livre e registrar. Copiar resultado original gerado para workspace, preservar original/candidatos anteriores e registrar hash, prompt, referências, ferramenta e dimensões. Não selecionar automaticamente o candidato novo como aceito.

Permitir no máximo uma iteração dirigida adicional por quadro se a primeira falhar em checks objetivos/continuidade (até4chamadas totais neste escopo). Cada iteração altera só a falha encontrada, versões separadas. Se o limite não resolver, devolver o quadro pendente com evidência e pedir próxima decisão, sem regenerar as outras39fases. Sem edição de pixels por Python ou substituição por SVG; ferramentas determinísticas apenas leem métricas, copiam arquivos e exibem HTML. Prévias podem escalar no navegador, sem alterar nativos.

## Etapas e recuperação

S001/B001: revalidar39aceites,42hashes, prontidão e referências; backup de estados e inventário de destinos; hashes de runtime. S002/B001: editar H402/H406 em duas chamadas independentes, conferir e iterar só se necessário no limite acima. S003/B002: inspeção de motivos/forma/progressão, leitura de margens/canais/luminância/alcance e comparação com H401/H403/H405; galeria conjunta das duas correções no contexto de seis fases, nativos e96px, versões/hashes explícitos. S004/B002: conferir contrato/links/fontes/runtime, reconciliar evidências/estado e pedir **um aceite visual dos dois candidatos**.

per-plan aprova integralmente S001–S004; per-batch usa B001/B002; per-step pausa antes de cada S001…S004. Modo atual unconfigured. Gates visuais humanos independentes permanecem; geração não implica aceite, CANON ou integração.

Caminhos permitidos: dois novos candidatos versionados, artefatos `.atena/generated/sylas-two-frame-correction-2026-10-13/`, documentos/estado/evidência/cursorPLAN053. Nenhuma alteração de assets/core/ui/data/tests ou fontes aceitas. Recuperação: candidatos novos continuam DRAFT não selecionados, estado/evidência preservam rejeições; nada apaga/reescreve fontes históricas, nenhum resetGit.

Aceite técnico: duas versões novas registradas; fontes antigas e39aceites intactos; H402 deixa de exceder o pico em alcance/brilho e não cruza cauda pelo lado esquerdo; H406 sem cabeça contínua e com intensidade/área residual inferiores aH405. Métricas são diagnóstico e não prova de estética. Se conflito entre medidas e leitura, registrar e submeter ao dono. Sem runtime, não há build/playtest novo; testes do jogo não se justificam por cópias DRAFT, mas hashes das áreas protegidas devem permanecer iguais.

## Pendências e próximo checkpoint

BLOCKING: aprovação do escopo/modo desta correção. RESOLVABLE: aderência das duas imagens e eventuais dimensões nativas emS002/S003. DEFERRED: normalização/atlas/pivôs/runtime dos sete heróis, ciclos aceitos, playtests anteriores e bugs025/027/028/029. Nenhum outro bloqueio principal conhecido.

Após execução: gate OWNER_TWO_FRAME_VISUAL_ACCEPTANCE. Entradas:39aceites+H403histórico, duas novas versões/hashes, comparação de seis fases. Saída: aceite humano conjunto ou exceções. Depois preparar **uma proposta de admissão do L002 completo** com todas as42fontes selecionadas; essa admissão não está autorizada por este plano de correção.

## Autorização

Dono selecionou1Porplano para o escopov01; modo per-plan aprovado. Proposta/unconfigured acima é histórico. BLOCKING de aprovação resolvido; execução segue até o gate visual dos dois candidatos. [Recibo](../../generated/sylas-two-frame-correction-2026-10-13/authorization.json).

## Resultado

Técnico4/4: três chamadas built-in, H402v03/H406v02 candidatos propostos; H402v02 preservada/não proposta.39fases e H403v02 intactos; fontes1254nativas preservadas, normalização diferida. Gate visual humano dos dois pendente. [Evidência](../../evidence/sylas-two-frame-correction-2026-10-13.md), [galeria](../../generated/sylas-two-frame-correction-2026-10-13/index.html). Sem runtime/CANON/Git.

2026-10-14 — Dono aceitou “AprovoH402v03eH406v02DRAFT (Recomendado)”. Dois hashes conferidos,39aceites/H403v02 preservados, fontes/runtime intactos. Recibo `.atena/generated/sylas-two-frame-correction-2026-10-13/visual-acceptance.json`. Proposta conjunta assets-l002-admission/v01 preparada:42fontes/seteatlas/setehabilidades, dois metadados opcionais de apresentação e validação determinística; escopo/modo pendentes. Nenhuma normalização/admissão/Git/CANON nesta ação.
