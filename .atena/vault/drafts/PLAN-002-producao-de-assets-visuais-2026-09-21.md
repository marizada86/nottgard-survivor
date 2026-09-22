# PLAN-002 — Produção de assets visuais do Nottgard Survivors

Status: **DRAFT — fase 1 de prompts concluída; geração de imagens aguardando aprovação separada**
Data: 2026-09-21

## 1. Objetivo

Substituir os placeholders visuais do jogo por uma família coerente de arte isométrica sombria, preservando os pilares do `PLAN-001`:

- leitura imediata em 1280×720;
- poucas dezenas de inimigos visíveis, sem poluição visual;
- perspectiva isométrica 2:1;
- atmosfera de *Diablo II* / *Halls of Torment*;
- conteúdo e identidade reaproveitados do Nottcard quando houver uma referência adequada;
- integração por id estável, sem acoplar regras do jogo ao arquivo de imagem.

Este plano trata primeiro de inventário, prompts e contrato técnico. A geração das imagens só começa depois da aprovação do lote piloto.

## 2. Diagnóstico atual

O projeto já possui:

- 5 retratos: `durvall`, `brook`, `maelor`, `sylas`, `kayron`;
- 10 inimigos reaproveitados do Nottcard: `zumbi`, `slime_corrosivo`, os três cultistas, `criatura_corrompida`, os dois guardiões, `mimico` e `sacerdote_mente_derretida`;
- fontes e ícone do projeto.

Ainda são placeholders desenhados por código:

- herói dentro da run;
- piso isométrico dos 8 biomas;
- todos os props dos cenários;
- baú, fonte, altar, ritual e portal;
- pickups, projéteis e grande parte dos efeitos;
- ícones de armas, itens, passivas, bênçãos e conquistas.

Dos 49 inimigos declarados em `data/enemies.json`, 39 não possuem PNG. Dos 10 heróis, 5 não possuem retrato e nenhum possui sprite próprio para a run.

## 3. Recomendação de produção

Usar um pipeline híbrido, não geração indiscriminada de PNGs:

1. **IA generativa:** personagens, inimigos, retratos, props, interações, thumbnails e ícones únicos.
2. **Atlas modular:** pisos e variações de props por bioma. Gerar uma folha coerente e fatiá-la de forma determinística.
3. **Godot:** sombras, flashes de dano, telegráfos, projéteis simples, áreas, partículas, brilho, dissolução, névoa, corrente de almas e animação de interface.
4. **Reuso do Nottcard:** usar as imagens existentes como referência de identidade; copiar arte diretamente somente quando composição e escala funcionarem no contexto isométrico.
5. **Animação:** começar com uma pose isométrica estática mais movimento/bob/squash em código. Não gerar animações quadro a quadro antes de o estilo e a escala estarem aprovados.

Esse método reduz custo, mantém consistência e evita centenas de quadros de animação que seriam difíceis de estabilizar com geração de imagem.

## 4. Contrato técnico proposto

### 4.1 Estrutura de pastas

```text
assets/
  _raw/                         # matrizes e candidatas; fora do export final
  portraits/<hero_id>.png
  heroes/<hero_id>.png
  enemies/<enemy_id>.png
  tiles/<stage_id>_ground.png
  props/<kind>_<variant>.png
  interactions/<kind>_<state>.png
  icons/weapons/<weapon_id>.png
  icons/items/<item_id>.png
  icons/passives/<passive_id>.png
  icons/boons/<boon_id>.png
  icons/achievements/<achievement_id>.png
  stages/<stage_id>_thumb.png
  ui/<ui_id>.png
```

`assets/_raw/` deve entrar no `.gitignore`. Os arquivos finais processados permanecem versionados.

### 4.2 Nomes e versões

- O nome final é sempre o id do JSON, em minúsculas e `snake_case`.
- Candidatas: `<id>_v01.png`, `<id>_v02.png`, `<id>_v03.png`.
- Aprovado: `<id>.png`, sem sufixo.
- Nunca mudar um id de gameplay para acomodar a arte.
- Cada prompt registra `asset final`, `bruto`, referências, proporção, fundo e critérios de aceite.

### 4.3 Formatos

| Categoria | Matriz recomendada | Final | Fundo | Regra visual |
|---|---:|---:|---|---|
| Retrato | 1536×1024 | 640×427 | opaco | busto 3:2, identidade do Nottcard |
| Herói na run | 1024×1536 | 256×384 | alfa | corpo inteiro, três quartos isométrico, pés na mesma linha |
| Inimigo | 1024×1536 | 256×384 | alfa | corpo inteiro, silhueta legível a 48–110 px |
| Chefe | 1024×1536 | 320×480 | alfa | mesma linha de pés; escala definida pelo JSON |
| Piso | 1024×512 | atlas 128×64 | opaco | quatro células isométricas de 64×32, repetição sem emenda |
| Prop | 1024×1024 | até 256×256 | alfa | três quartos isométrico, ponto de contato central inferior |
| Interação | 1024×1024 | 192×192 | alfa | legível a 40–64 px |
| Ícone | 1024×1024 | 128×128 | alfa | uma forma dominante, sem texto |
| Thumbnail de fase | 1536×1024 | 480×320 | opaco | composição 3:2, espaço para texto da UI |

O filtro de textura continua em nearest-neighbor. O processamento deve preservar alfa, alinhar o ponto dos pés e rejeitar halos claros ou fundo xadrez pintado.

## 5. Direção de arte comum

- Pixel art densa e sombria, com pixels nítidos, dithering controlado, contorno escuro e blocos de cor definidos.
- Câmera de três quartos, aproximadamente 30° acima do chão, coerente com a projeção 2:1.
- Luz principal no alto à esquerda para todas as figuras e props.
- Silhueta antes de detalhe: a identidade deve sobreviver ao tamanho real dentro do jogo.
- Paleta geral fria e dessaturada; cada bioma recebe uma cor-acento própria.
- Sem texto, números, marca d’água, moldura ou símbolos não definidos pelo canon.
- Sem fundo pintado nos sprites; usar alfa real.
- Evitar realismo 3D, anime, cartoon e pintura suave sem leitura de pixel art.

### Paleta por bioma

| Fase | Base | Acento | Material/forma dominante |
|---|---|---|---|
| `dagruve` | cinza-azulado, carvão | âmbar e roxo doentio | cais, pedra molhada, pilares, cera |
| `shedaklah` | marrom fungo, violeta escuro | rosa de esporo | cogumelos, micélio, lodo |
| `molor` | verde-negro | verde ácido | bolhas, cavernas viscosas |
| `durao` | ferrugem, basalto | azul de almas | rocha, jaula, corrente de almas |
| `feng_tu` | ardósia azul | vermelho e verde pestilento | torii, templo, estátuas |
| `shendilavri` | vinho, preto | magenta e prata | cristal, luxo corrompido, ilusões |
| `goranthis` | dourado gasto, marfim | verde-água | cachoeiras e falso paraíso |
| `pilares` | violeta quase preto | lilás elétrico | monólitos abissais e céu rasgado |

## 6. Inventário de produção

### 6.1 Heróis

#### Retratos faltantes — 5

`korrak`, `leoric`, `nyrelia`, `zynara`, `bromnor`.

Os cinco retratos existentes permanecem como âncoras de estilo. Antes da geração, confirmar se os retratos novos devem repetir exatamente o acabamento semi-pintado atual ou migrar toda a coleção para pixel art mais marcado.

#### Sprites da run — 10

`durvall`, `brook`, `maelor`, `sylas`, `kayron`, `korrak`, `leoric`, `nyrelia`, `zynara`, `bromnor`.

Primeiro lote com pose neutra isométrica única. Animações direcionais ficam fora desta produção inicial.

### 6.2 Inimigos

#### Já existentes como referência — 10

`zumbi`, `slime_corrosivo`, `cultista_adaga`, `cultista_arqueiro`, `cultista_cajado`, `criatura_corrompida`, `guardiao_copia`, `guardiao_verdadeiro`, `mimico`, `sacerdote_mente_derretida`.

Eles podem entrar no piloto, mas devem ser avaliados em jogo. Se a vista frontal destoar demais do novo sprite isométrico, criar versões específicas para Survivors sem apagar os originais durante a comparação.

#### Faltantes — 39

| Bioma/lote | Inimigos |
|---|---|
| Dagruve | `notivago`, `arch_hag`, `tentaculo_kraken` |
| Shedaklah | `gargula`, `cogumelo_fungico`, `servo_de_zuggtmoy`, `esporo_voador`, `pudim_negro`, `slime_de_juiblex`, `zuggtmoy` |
| Molor | `bolha_de_slime`, `cultista_thullgrime`, `receptaculo_de_juiblex`, `blogbog` |
| Durao | `alma_penada`, `demonio_de_gehenna`, `carcereiro_de_pedra`, `molydeus_menor`, `molydeus_chefe`, `aberracao_shu`, `ezro` |
| Feng-tu | `larva_de_lu_yueh`, `cultista_de_feng_tu`, `estatua_do_templo`, `discipulo_pestilento`, `lu_yueh`, `cultista_ghaunadaur` |
| Shendilavri | `escravo_de_rivenheart`, `sucubo`, `ilusao_de_sucubo`, `guarda_do_castelo`, `master_of_cruelties`, `malcanthet` |
| Goranthis | `ilusao_de_socothbenoth`, `guardiao_de_goranthis`, `cultista_de_socothbenoth`, `socothbenoth`, `death_tyrant` |
| Pilares | `sintese_abissal` |

### 6.3 Biomas

- 8 atlas de piso, um por `stage_id`, com quatro variações por atlas.
- 8 famílias de props: `pilar`, `cogumelo`, `bolha`, `rocha`, `torii`, `cristal`, `cachoeira`, `pilar_abissal`.
- Gerar três variantes por família de prop: **24 sprites**.
- Props devem preservar colisão visual semelhante ao `half_width` usado na cena.

### 6.4 Interações — 8 sprites iniciais

- `chest_closed`, `chest_open`;
- `fountain_active`, `fountain_spent`;
- `altar_active`, `altar_spent`;
- `ritual`;
- `portal`.

Estados animados devem usar pulsação, partículas e shader em Godot, sem multiplicar quadros estáticos neste momento.

### 6.5 Ícones de conteúdo

| Família | Quantidade | Estratégia |
|---|---:|---|
| Armas/habilidades | 30 | reaproveitar arte do Nottcard quando existir; gerar lacunas e evoluções |
| Itens-base | 13 | um ícone por base; afixos não criam outro ícone |
| Itens únicos | 18 | ícone próprio por id |
| Passivas | 14 | símbolos simples de alta leitura |
| Bênçãos | 12 | uma linguagem por divindade, sem texto |
| Conquistas | 18 | baixa prioridade; podem reutilizar ícones de conteúdo na primeira versão |

### 6.6 Interface e seleção

- 8 thumbnails de fase, um por `stage_id`;
- fundo do Quartel/menu, somente depois de o layout permanecer estável;
- ícones de moeda, abate, CA, CAM, vida, XP, alvo e essência;
- moldura de retrato e painel de chefe podem ser construídos por NinePatch/SVG ou desenho em Godot, não por geração raster.

## 7. Fase 1 — Criar e aprovar todos os prompts

### 7.1 Fontes

Para cada id, cruzar:

1. `data/*.json`: nome, mecânica, escala, bioma e descrição curta;
2. `PLAN-001`: identidade do plano/camada e limites de lore;
3. arte existente no Nottcard: referência de personagem ou criatura;
4. screenshot atual: escala e necessidade de legibilidade;
5. código consumidor: caminho, tamanho e ponto de ancoragem.

### 7.2 Arquivos de prompt

Criar documentos por família em `.atena/generated/`:

1. `ART-PROMPTS-001-direcao-e-piloto.md`;
2. `ART-PROMPTS-002-herois.md`;
3. `ART-PROMPTS-003-inimigos-dagruve-shedaklah.md`;
4. `ART-PROMPTS-004-inimigos-molor-durao.md`;
5. `ART-PROMPTS-005-inimigos-feng-tu-shendilavri.md`;
6. `ART-PROMPTS-006-inimigos-goranthis-pilares.md`;
7. `ART-PROMPTS-007-biomas-e-props.md`;
8. `ART-PROMPTS-008-interacoes.md`;
9. `ART-PROMPTS-009-icones-armas-e-itens.md`;
10. `ART-PROMPTS-010-icones-passivas-bencaos-e-ui.md`.

Cada documento deve conter frontmatter, bloco de estilo, tabela prompt→asset, referências a anexar, prompt autocontido, critérios de conferência e checklist.

### 7.3 Lote piloto obrigatório

Criar prompts e aprovar, antes do restante:

- sprite de run de `durvall`;
- versão Survivors de `cultista_adaga`;
- novo `notivago`;
- chefe `sacerdote_mente_derretida` ou sua versão isométrica;
- atlas do piso de `dagruve`;
- variantes `pilar_01..03`;
- `chest_closed` e `portal`;
- um ícone de arma e um item único.

O piloto testa escala, perspectiva, alfa, contraste, integração, custo e consistência entre categorias.

### 7.4 Gate da fase 1

- Todo asset do lote atual tem caminho e prompt únicos.
- Nenhum prompt conflita com o id ou a mecânica do JSON.
- Referências e limites de lore estão explícitos.
- Tamanho, fundo, luz, câmera e ponto de contato estão definidos.
- O piloto foi aprovado antes da geração em volume.

## 8. Fase 2 — Gerar, processar e validar

### Ordem de produção

1. **Piloto Dagruve**, integrado e testado em 1280×720.
2. **10 heróis:** sprites da run; depois os 5 retratos faltantes.
3. **Dagruve completa:** os três inimigos faltantes, piso, props e interações.
4. **Bioma por bioma:** Shedaklah → Molor → Durao → Feng-tu → Shendilavri → Goranthis → Pilares.
5. **Ícones de armas e itens**, priorizando o que aparece nas runs iniciais.
6. **Passivas, bênçãos, thumbnails e HUD.**
7. **Conquistas e polimento opcional.**

### Fluxo por imagem

1. Gerar uma candidata por mensagem/chamada.
2. Inspecionar composição, identidade, alfa, perspectiva e proibições.
3. Salvar como `_v01`; gerar até `_v03` somente quando houver motivo objetivo.
4. Escolher a candidata, copiar para o nome canônico e processar.
5. Abrir no contexto real do jogo; não aprovar só olhando o PNG isolado.
6. Marcar o checklist e executar a auditoria novamente.

### Tratamento de variações

- Personagens recorrentes usam uma imagem-âncora fixa; não redesenhar rosto, roupa ou proporções entre retrato e sprite.
- Variantes de props mantêm material, iluminação, escala e base; mudam apenas silhueta secundária e desgaste.
- Chefe/elite pode reutilizar a espécie somente se houver diferença inequívoca de escala, cor-acento e silhueta.
- Ilusões reutilizam o sprite original com shader/transparência no Godot quando forem semanticamente a mesma criatura.
- Evoluções de arma podem derivar do ícone-base, mantendo forma e mudando energia/acento.

## 9. Validações e automação necessárias

Antes da produção em volume, criar:

1. `scripts/audit_assets.gd` ou equivalente para extrair ids dos JSONs e comparar com os caminhos esperados.
2. Processador que redimensione, preserve alfa, alinhe pés/base e ignore candidatos `_vNN`.
3. Testes de dimensão, modo RGBA, margem, transparência e existência por categoria.
4. Cena `tools/art_gallery.tscn` mostrando heróis, inimigos, props e ícones em escala real.
5. Screenshot automatizado por lote usando `tools/shot.tscn`.

O `--check` da auditoria deve permitir fases: inicialmente exige apenas o piloto e Dagruve; depois amplia a lista obrigatória a cada bioma aprovado.

## 10. Critérios de pronto

### Por asset

- caminho e nome iguais ao contrato;
- PNG final nas dimensões previstas;
- fundo/alfa corretos, sem halo;
- silhueta legível no tamanho real;
- perspectiva, luz e linha dos pés coerentes;
- nenhuma violação de lore, texto ou marca d’água;
- carregado pelo jogo e presente na galeria;
- aprovado no checklist do prompt.

### Por bioma

- piso sem emenda visível;
- pelo menos três props visualmente distintos;
- todos os inimigos usados pelas ondas têm sprite;
- chefe lê imediatamente como maior e mais perigoso;
- interações continuam distinguíveis durante combate;
- HUD, telegráfos e pickups mantêm contraste sobre o cenário;
- screenshot de evidência em 1280×720.

### Projeto completo

- 10 heróis com sprite e retrato;
- 49 inimigos cobertos e coerentes;
- 8 biomas com piso, props e thumbnail;
- interações e conteúdo de menu com ícones;
- auditoria sem faltas na lista obrigatória;
- testes e smoke test passando;
- nenhuma queda perceptível de desempenho ou crescimento desnecessário da build.

## 11. Decisões que precisam ser congeladas antes dos prompts

1. Manter os 5 retratos atuais como arte final ou refazer todos em uma linguagem mais pixel-art.
2. Usar os 10 inimigos atuais diretamente ou apenas como referência para versões isométricas.
3. Confirmar pose estática como escopo inicial dos heróis/inimigos; animação fica para uma fase posterior.
4. Confirmar o tamanho final de sprite após o piloto em tela.
5. Confirmar se os ícones do Nottcard podem ser copiados como finais ou somente usados como referência.

## 12. Revisão após pesquisa de lore e auditoria

Artefatos derivados:

- `vault/research/RESEARCH-001-abismo-bestiario-visual-2026-09-21.md` — cruzamento entre D&D e o vault;
- `generated/ASSET-MATRIX-001-imagens-e-prompts-2026-09-21.md` — inventário, ordem e contrato prompt → asset;
- `specs/SPEC-011-fase-1-prompts-de-arte.md` — plano de voo limitado à redação dos prompts.

A auditoria confirmou 44 lacunas consumidas hoje: 39 sprites de inimigo e 5 retratos. Sprites de herói, pisos, props, interações, thumbnails e ícones permanecem como segundo nível, pois ainda exigem integração ou contrato próprio.

O repertório adicional de D&D permanece em backlog. Nenhum hezrou, vrock, chasme, rutterkin, otyugh, yugoloth, marilith, lilitu ou demônio das sombras será acrescentado aos dados ou aos prompts obrigatórios sem aprovação de expansão de escopo.
