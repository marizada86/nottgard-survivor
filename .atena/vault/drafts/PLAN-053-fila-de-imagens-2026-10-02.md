---
id: PLAN-053
title: Execução da fila de imagens por prioridade
created: 2026-10-02
status: em execução
---

# Fila de imagens

Autorização: pedido do dono em 2026-10-02 para executar os prompts, criar as imagens e adicionar ao jogo. A integração local está autorizada; commits e publicação não foram pedidos.

## Ordem

1. ART-024: miniatura de Docas (ART-PROMPTS-039).
2. T01: título (CHATGPT-FILA-009).
3. C03–C11: props do piloto; depois C01–C02: fundos (CHATGPT-FILA-010).
4. S01–S02: isca de Sylas; reconciliar animações existentes antes de produzir novamente.
5. Mobs: Molor, Shedaklah, Durao, Feng Tu, Shendilavri, Goranthis, Pilares. Identidade e validação de cada bioma antes do seguinte.
6. Reconciliar lote 1 com assets já admitidos; gerar só faltantes.
7. S03–S05: ampulheta, doação e aposta.
8. HQs pendentes, respeitando decisões de mecânica; Trilha C permanece condicionada à aprovação de MEC-015.
9. UI/VFX da fila 012; ART-004 depende da decisão da mecânica.
10. VFX novos: piloto 020 antes das filas 021–023. A prioridade relativa deste bloco não estava definida na tabela de 2026-10-01.

## Método

Usar imagegen integrado, uma chamada por asset. Guardar matriz versionada em `.atena/generated/art-candidates/`, conferir aparência e contrato técnico, normalizar dimensões e preservar alfa. Fundos opacos; props com transparência real substituem o chroma-key originalmente previsto. Integrar em caminhos consumidos pelo jogo e registrar o resultado. Não criar mecânicas condicionadas a playtest apenas para consumir arte.

## Progresso

- Miniatura: gerada e integrada em `assets/stages/docas_thumb.png`, RGB 480×320.
- Título: gerado e integrado em `assets/ui/title/title_background.png`, RGB 1920×1080.
- FILA-010 C01–C11: integrados os nove props e os dois fundos; estrada validada em runtime após correção isométrica. Cais usa dimensões e espaçamento próprios nos dados. Carroça e carga usam destrutíveis existentes com dois novos IDs e eventos de áudio reaproveitados.
- FILA-011 S01–S05: isca (segunda versão), explosão 2×2, ampulheta, altar de doação e mesa de aposta integrados e capturados no jogo.
- FILA-012 U07–U09: subida de nível, flare de evolução e moldura integrados; efeitos respeitam Reduzir efeitos de impacto. Margem do painel corrigida após captura.
- Molor I01–I03: candidatas guardadas, nenhuma admitida. I01 foi tentada três vezes, todas com halo externo; interromper repetição automática conforme `max_retries: 3` em `.atena/add.yaml`. I02/I03 também têm halo. Os ciclos de animação dependem de identidades tecnicamente válidas e da revisão visual prevista na FILA-014.
- FILA-020 A03: piloto de estilo gerado; ainda sem os demais quadros e sem integração. A FILA-020 pede devolução ao dono neste ponto para aprovar o estilo.
- Testes após os dois primeiros assets: 0 falhas. Smoke das nove fases: ok. Godot reportou avisos de recursos em uso ao encerrar; não é validação visual interativa.
- U01–U06: pendentes, ligados a MEC-002/003/004 ainda sem implementação no backlog; não implementar novos sistemas apenas para consumir imagens.
- HQs reconciliadas: HQN-01–14 já registradas em `data/hqs.json`, 56 caminhos conferidos sem ausências; integração e prévia documentadas em EVID-128/EVID-133. Não regenerar a remessa histórica.
- Lote 1 reconciliado: P01–P08 oficiais existem; EVID-110 documenta admissão. Lote 2 já admitido por EVID-127. Não há geração nova necessária nessas remessas históricas.
- Build Windows exportada em `build/image-priority/NottgardSurvivors.exe`, identificação `38cbc95+` (árvore local com alterações), inicialização headless conferida. Não publicada.
- A03 v02 e B03 aprovados pelo dono. Piloto completo de 12 quadros gerado e integrado em dois atlas; oito direções e sete cores conferidas. Build local atualizada em `build/image-priority-vfx/NottgardSurvivors.exe`, identificação `0217b2f+`.
- FILA-021 C03 v02 apresentado para o próximo gate. Molor I02/I03 v02 não resolveram o halo; limpeza técnica por Godot ou nova geração aguardam escolha do dono.
- Filas 013–019 e 021–023: pendentes das validações dos pilotos. Não declarar a fila inteira concluída.

Prompts executados: ART-PROMPTS-039, T01 literal da FILA-009, C03 da FILA-010 com transparência real e correção de alinhamento; C04 da FILA-010 com transparência real.

Complemento: todos os C01–C11 da FILA-010, todos os S01–S05 da FILA-011, U07–U09 da FILA-012, I01–I03 de ART-PROMPTS-045 e A03 da FILA-020. Usado apenas imagegen integrado. Fundo magenta/ciano substituído por transparência real; nenhuma matriz bruta apagada. Destinos e validação em EVID-145.

Atualização da prioridade: FILA-024 / ART-PROMPTS-055 (BUG-025) passa à frente dos próximos lotes, conforme pedido do dono registrado no backlog em 2026-10-02. Concluir primeiro a geração do Cultista já disparada, preservar candidatos e iniciar W01 Kayron move_se. Não iniciar os ciclos de Blogbog ou os próximos biomas antes de atender esta prioridade. C03 v02, D03 v01 e as três identidades limpas de Molor já foram aprovados; Estocada, Chicote e Bolha de Slime estão integrados localmente. Suite: zero falhas; smoke: nove fases ok; escala, âncora, término de ataque e limpeza após morte da Bolha conferidos.
- Cultista concluído: 20 quadros e quatro strips integrados, ataque02 corrigido em v02, pranchas inspecionadas e runtime conferido. Zero falhas na suite e smoke das nove fases ok. Total local: 33 PNGs integrados. Build atualizada em image-priority-molor, identificação4510c64+.
- FILA-024 W01: v01–v03 preservadas; halo persiste, limite de três tentativas alcançado; decisão do dono sobre extensão da limpeza de alfa por código pendente. W02 Korrak move_e iniciado e em correção de corte do machado. Nenhuma tira nova de herói integrada ainda.
- W02 Korrak move_e concluído e integrado: seis quadros267px/base350, massa99–103%doidle, sem cortes. Captura no jogo conferida; ativado na direita, demais sete direções provisórias. Suite finalzero falhas. Build4510c64+ (image-priority-molor) atualizada, SHA256 A55E3C7EFA5F2590C2376DBC1D9814300759CD4CD8E58785549DA16CA0B5E352, inicialização exit0. Próxima pendência: escolha sobre limpeza do alfa de W01, que continua candidato após três tentativas. Não declarar toda a fila pronta.
