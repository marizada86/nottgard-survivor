# PLAN-003 — Geração total dos assets visuais de Nottgard Survivors

Status: **DRAFT — aguardando aprovação; nenhuma imagem autorizada**  
Data: 2026-09-21  
Escopo: todos os assets visuais necessários ao jogo atual, sem áudio e sem material de loja/publicação.

## 1. Resultado pretendido

Substituir placeholders e arte provisória por uma biblioteca visual completa, coerente, rastreável e carregada por IDs estáveis, sem alterar a lore para acomodar imagens.

O plano preserva a exigência em duas macrofases:

1. **completar e aprovar todos os prompts, referências e contratos antes de gerar imagens**;
2. **gerar, processar, integrar e validar em lotes pequenos**, começando por um piloto representativo.

Inventário detalhado: `../../generated/ASSET-MATRIX-002-total-2026-09-21.md`.  
Referências locais: `../research/RESEARCH-002-biblioteca-visual-desktop-2026-09-21.md`.

## 2. Recomendação

Usar um pipeline **híbrido**:

- ImageGen para personagens, inimigos, props, objetos, thumbnails, fundos e ícones de conteúdo;
- atlas modular para pisos;
- Godot/shaders/partículas para VFX, telegráfos, cooldowns, sombras, auras e regras de camada;
- SVG/NinePatch/código para ícone do aplicativo, molduras, painéis, barras e pictogramas utilitários;
- reuso por alias para conquistas, upgrades e itens homônimos.

Essa é a melhor forma para este jogo. Gerar cada efeito e cada estado como PNG multiplicaria o volume, introduziria inconsistência e dificultaria animação, escala e balanceamento visual. A IA deve produzir a identidade visual; o motor deve produzir o comportamento visual.

## 3. Fontes e resolução de conflitos

Ordem obrigatória:

1. **vault canônico de Nottgard** — espécie, história conhecida, objetos, símbolos, relações e limites de spoiler;
2. **dados e código do jogo** — IDs, função mecânica, escala, consumer e caminho;
3. **`C:\Users\gui-m\Desktop\nottgard`** — aparência/identidade e atmosfera aprovadas;
4. **pesquisa de D&D registrada em `RESEARCH-001`** — apoio para camadas do Abismo, nunca para substituir decisões próprias de Nottgard;
5. **decisão artística derivada** — apenas onde as fontes não definem algo.

Em conflito, o prompt pausa. Nenhuma escolha estética pode alterar o cânone ou revelar spoiler que o jogo não deve mostrar.

## 4. Contrato técnico

### Caminhos finais

```text
assets/
  portraits/<hero_id>.png
  heroes/<hero_id>.png
  enemies/<enemy_id>.png
  tiles/<stage_id>_ground.png
  props/<prop_id>.png
  interactions/<interaction_id>.png
  pickups/<pickup_id>.png
  icons/abilities/<ability_id>.png
  icons/weapons/<weapon_id>.png
  icons/items/<item_id>.png
  icons/passives/<passive_id>.png
  icons/boons/<boon_id>.png
  icons/stages/<stage_id>_<rule>.png
  icons/ui/<ui_id>.png
  stages/<stage_id>_thumb.png
  ui/backgrounds/<screen_id>.png
```

Candidatas ficam em `.atena/generated/art-candidates/<família>/<id>_vNN.png`, fora da árvore importada pelo Godot e excluídas do Git por regra específica. O aprovado é copiado para `assets/` sem o sufixo. O nome final sempre usa o ID do JSON em `snake_case`; arte nunca renomeia gameplay.

### Formatos principais

| Categoria | Matriz | Final | Fundo |
|---|---:|---:|---|
| Retrato | 1536×1024 | 640×427 | opaco |
| Herói | 1024×1536 | 256×384 | alfa real |
| Inimigo comum/elite | 1024×1536 | 320×480 | alfa real |
| Piso | 1024×512 | atlas 128×64 | opaco e repetível |
| Prop | 1024×1024 | até 256×256 | alfa real |
| Interação | 1024×1024 | 192×192 | alfa real |
| Ícone/pickup | 1024×1024 | 128×128 / 64×64 | alfa real |
| Thumbnail | 1536×1024 | 480×320 | opaco |
| Fundo de tela | 1536×1024 | 1920×1080 ou crop seguro 16:9 | opaco |

O import usa nearest-neighbor para pixel art. Sprites compartilham luz superior esquerda, câmera de três quartos e base/pés alinhados. Fundos 16:9 precisam de zona segura central e lateral para UI em 1280×720.

## 5. Fase 1 — completar prompts e preparar a produção

Nenhuma imagem é gerada nesta fase.

### 5.1 Congelar o inventário

- Extrair consumidores de `data/*.json`, cenas e scripts.
- Registrar os 236 PNGs finais, aliases e arte procedural em um manifesto YAML/JSON.
- Fazer a auditoria falhar quando um ID não tiver `final_path` ou `prompt_id`/`reuse_ref`/`procedural_ref`.
- Marcar os 15 arquivos atuais como `legacy`, sem sobrescrevê-los.

### 5.2 Catalogar referências

- Usar `RESEARCH-002` como índice da pasta do Desktop.
- Para cada personagem, abrir também sua página do vault e registrar somente traços confirmados.
- Classificar cada referência como `identity`, `costume`, `object`, `palette`, `composition` ou `atmosphere`.
- Não anexar imagens extras “por inspiração”; cada anexo precisa ter função explícita.
- Criar hashes dos arquivos efetivamente usados para que o prompt permaneça reproduzível.

### 5.3 Reconciliar os prompts existentes

- Revisar `ART-PROMPTS-001` com o contrato deste plano e piloto ampliado.
- Ampliar `ART-PROMPTS-002` para os dez retratos, inclusive harmonização dos cinco existentes.
- Validar `003..006` contra o vault, `enemies.json` e as regras/fases de chefe.
- Validar `007..010` contra os novos consumers das `SPEC-012..014`.
- Trocar referências genéricas ao antigo repositório por arquivos locais identificados ou páginas exatas do vault.
- Transformar oito ícones duplicados de arma/item em aliases, salvo necessidade visual comprovada.

### 5.4 Criar os pacotes faltantes

- `ART-PROMPTS-011-herois-run-e-inimigos-legado.md`: 10 heróis e 10 remasters condicionais.
- `ART-PROMPTS-012-habilidades-regras-pickups.md`: 10 habilidades, 8 regras e 3 pickups.
- `ART-PROMPTS-013-telas-e-identidade-do-app.md`: 3 fundos e diretiva vetorial do ícone.
- `ART-SPEC-001-vfx-e-ui-procedural.md`: vocabulário de efeitos, cores, duração, prioridade e limites de poluição visual; não é prompt de imagem.

Cada prompt deve ser autocontido e registrar: use case, asset type, style, composição, câmera, luz, conteúdo obrigatório, restrições, negativos, matriz, final, alfa, âncora, referências, papel de cada referência e checklist.

### 5.5 Gate da Fase 1

- 100% dos consumers têm destino: geração, alias/reuso ou procedural.
- 100% dos assets gerados têm exatamente um prompt e caminho final.
- Nenhum prompt depende de “igual ao anterior” sem repetir os traços necessários.
- Divergências de lore estão zeradas ou explicitamente aprovadas.
- Nyrelia e qualquer referência ambígua têm identidade aprovada.
- As referências que serão enviadas ao ImageGen foram aprovadas por lote.
- O manifesto e os prompts passaram por revisão independente de contagem, links e IDs.

Somente então criar uma spec de execução da Fase 2 e pedir aprovação.

## 6. Fase 2 — gerar, processar, integrar e verificar

### 6.1 Lote piloto — 10 imagens

1. retrato de `durvall`;
2. sprite de run de `durvall`;
3. remaster de `cultista_adaga`;
4. novo `notivago`;
5. chefe `sacerdote_mente_derretida`;
6. `dagruve_ground`;
7. `pilar_01`;
8. `chest_closed`;
9. ícone `espada_sombria`;
10. `dagruve_thumb`.

O piloto testa todas as decisões caras: identidade, portrait→sprite, legado→remaster, comum→chefe, alfa, piso repetível, objeto, ícone e paisagem. Nada entra em volume até esse lote estar visível na cena real a 1280×720.

### 6.2 Ondas de produção

| Onda | Conteúdo | Gate para avançar |
|---|---|---|
| A | piloto de 10 | estilo, escala, câmera, alfa e legibilidade aprovados |
| B | 10 retratos + 10 sprites de herói, descontando os aprovados no piloto | identidade cruzada retrato/sprite e seleção de herói coerentes |
| C | Dagruve completa | todos os consumers do MVP sem placeholder e run completa legível |
| D | Shedaklah → Molor → Durao | uma camada por vez, com chefe e regra validados |
| E | Feng-tu → Shendilavri → Goranthis → Pilares | uma camada por vez; Síntese Abissal por último |
| F | armas, itens, habilidades, passivas e bênçãos | leitura a 48 px e mapeamento correto nas ofertas/HUD |
| G | regras, pickups, HUD, thumbnails e fundos | navegação, combate e resultados sem placeholder |
| H | aliases de conquistas/upgrades, ícone do app e polimento | auditoria total verde e build de revisão |

Lotes normais têm 4–8 imagens. Chefes, protagonistas e fundos de tela ficam em lotes menores.

### 6.3 Fluxo por asset

1. Confirmar linha do manifesto, lore, prompt e referências.
2. Se houver referência local, obter o gate de envio remoto daquele lote.
3. Fazer **uma chamada de ImageGen por imagem distinta**.
4. Salvar como `_v01` em `.atena/generated/art-candidates/`; inspecionar composição, identidade, câmera, alfa, marcas e restrições.
5. Gerar `_v02` ou `_v03` somente para corrigir falha descrita; nunca rerrolar “até ficar bonito”.
6. Selecionar uma candidata e registrar versão/hash.
7. Processar sem alterar proporções: recorte, resize nearest-neighbor, limpeza de halo, alinhamento da base e conversão correta de cor/alfa.
8. Copiar para o caminho canônico, importar no Godot e exibir na galeria.
9. Testar na cena real; aprovar ou voltar a `qa_failed` com motivo objetivo.

Nunca sobrescrever o legado antes de existir uma comparação funcional. A troca final é reversível pelo manifesto e pelo arquivo anterior.

## 7. Tratamento de variações

- **Retrato e sprite do mesmo herói:** compartilham a mesma referência de identidade; mudam apenas enquadramento, câmera e simplificação.
- **Props 01–03:** material, luz, escala e base fixos; só silhueta secundária, desgaste e montagem variam.
- **Elite/chefe:** diferença por proporção e silhueta, não somente por recolor.
- **Ilusões:** reutilizam o sprite verdadeiro com shader/transparência quando a identidade é a mesma; só gerar outro PNG se a silhueta for canonicamente diferente.
- **Itens homônimos:** arma e inventário apontam para a mesma âncora visual.
- **Estados ativo/gasto:** usar a imagem ativa como referência obrigatória e preservar geometria/câmera.
- **VFX:** intensidade varia no motor; não criar frames raster para cada nível.

## 8. Validação

### Automatizada

- IDs dos JSONs versus manifesto e arquivos finais.
- dimensões, formato PNG, modo de cor e canal alfa por família;
- transparência real e ausência de pixels quase brancos na borda;
- margem mínima, bounding box e alinhamento de pés/base;
- nomes `snake_case`, ausência de `_vNN` dentro de `assets/` e ausência de duplicatas órfãs;
- referências/links dos prompts existentes;
- atlas de piso repetido em grade 8×8 para detectar costura;
- build/import Godot sem erro.

### Visual

- galeria em escala real com fundo dos oito biomas;
- retrato ao lado do sprite do mesmo herói;
- comum, elite e chefe comparados na mesma tela;
- ícones a 128, 48 e 32 px, coloridos e em escala de cinza;
- cenas de combate com 30–60 inimigos para testar massa visual;
- screenshots de menu, level-up, chefe, vitória e derrota em 1280×720;
- revisão de watermark, texto acidental, mãos/membros, halos, recortes e inconsistência de luz.

### Lore e privacidade

- checklist de fonte do vault por personagem, chefe, item único e camada;
- nenhum spoiler além do permitido pelo `PLAN-001`;
- nenhuma imagem do Desktop enviada sem registro e aprovação do lote;
- nenhuma referência externa incorporada como arquivo final.

## 9. Critérios de pronto

O plano visual está concluído quando:

1. os 236 PNGs finais previstos existem ou têm redução de escopo explicitamente aprovada;
2. todo consumer resolve para arquivo, alias ou implementação procedural;
3. nenhuma cena de jogo depende de placeholder geométrico não aprovado;
4. todos os assets passam nas validações técnicas e na galeria;
5. cada uma das oito camadas foi jogada do início ao chefe com o conjunto final;
6. heróis mantêm identidade entre retrato, sprite, habilidade e item associado;
7. telas e ícones permanecem legíveis em 1280×720;
8. arte com watermark, fundo verde, texto acidental ou alfa falso está ausente;
9. evidências por onda estão em `.atena/evidence/`;
10. manifesto, prompts e fatos operacionais foram reconciliados após a integração.

## 10. Estimativa e controle de custo

- Piso recomendado: 228 chamadas de geração para a coleção harmonizada.
- Cenário econômico: manter 5 retratos e 10 inimigos legados reduz para 213, mas aceita inconsistência visual.
- Limite de segurança: até três candidatas por asset, porém somente com falha objetiva; não reservar 684 chamadas antecipadamente.
- A produção pode parar ao fim de qualquer onda sem quebrar o jogo, porque placeholders/legados continuam funcionando até a troca aprovada.

## 11. Aprovação necessária

A aprovação deste draft autoriza apenas transformá-lo em spec da **Fase 1** e completar/reconciliar prompts e manifesto. Ela não autoriza geração de imagens. A Fase 2 terá uma aprovação separada após o gate dos prompts e das referências remotas.
