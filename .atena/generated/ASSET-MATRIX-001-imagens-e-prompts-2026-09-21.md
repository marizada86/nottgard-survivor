---
id: "ASSET-MATRIX-001"
type: "generated"
title: "Matriz de imagens e prompts do Nottgard Survivors"
status: "draft"
created: "2026-09-21"
relations:
  - "[[PLAN-002-producao-de-assets-visuais-2026-09-21]]"
  - "[[RESEARCH-001-abismo-bestiario-visual-2026-09-21]]"
  - "[[SPEC-011-fase-1-prompts-de-arte]]"
sources:
  - "data/*.json, assets/enemies e assets/portraits"
  - "vault canônico de Nottgard"
  - "nottcard-ai/.atena/generated"
---

# Matriz de imagens e prompts

> Artefato derivado. Não altera o cânone nem autoriza geração de imagens.

## 1. Resultado da auditoria

### Lacunas consumidas pelo jogo hoje

| Categoria | Declarados | PNG existente | Falta |
|---|---:|---:|---:|
| Inimigos | 49 | 10 | **39** |
| Retratos de herói | 10 | 5 | **5** |
| Total imediato | 59 | 15 | **44** |

Os inimigos existentes são RGBA 320×480. Os retratos existentes são RGB 640×427. O código procura `assets/enemies/<enemy_id>.png` e `assets/portraits/<hero_id>.png`.

### Assets planejados, ainda dependentes de integração ou contrato

| Família | Quantidade | Observação |
|---|---:|---|
| Sprites de run dos heróis | 10 | hoje o herói é desenhado por código |
| Atlas de piso | 8 | um por `stage_id` |
| Props | 24 | três variantes por bioma |
| Interações | 8 | baú 2, fonte 2, altar 2, ritual e portal |
| Thumbnails | 8 | um por fase |
| Armas/habilidades | 30 | priorizar heróis e primeiras drops |
| Itens-base | 13 | 5 armas, 4 armaduras, 2 amuletos e 2 anéis |
| Itens únicos | 18 | podem compartilhar âncora, não arquivo final |
| Passivas | 14 | ícones simples |
| Bênçãos | 12 | linguagem por divindade |
| HUD | 8 | moeda, abate, CA, CAM, vida, XP, alvo e essência |
| Conquistas | 18 | reutilizar ícones no primeiro passe |

Primeiro fecham-se os 44 arquivos já consumidos; depois cada família recebe integração e gate próprios.

## 2. Matriz dos 39 inimigos faltantes

| Lote | IDs | Estado | Nota |
|---|---|---|---|
| Dagruve | `notivago`, `arch_hag`, `tentaculo_kraken` | pronto | vault e gameplay concordam |
| Shedaklah | `gargula`, `cogumelo_fungico`, `servo_de_zuggtmoy`, `esporo_voador`, `pudim_negro`, `slime_de_juiblex`, `zuggtmoy` | pronto com ressalva | gárgula é reuso; Zuggtmoy sem morte implícita |
| Molor | `bolha_de_slime`, `cultista_thullgrime`, `receptaculo_de_juiblex`, `blogbog` | pronto | suporte direto no vault |
| Durao | `alma_penada`, `demonio_de_gehenna`, `carcereiro_de_pedra`, `molydeus_menor`, `molydeus_chefe`, `aberracao_shu`, `ezro` | seis prontos; um depende de decisão | congelar a anatomia do demônio de Gehenna; Shu/Ezro são reuso canônico |
| Feng-tu | `larva_de_lu_yueh`, `cultista_de_feng_tu`, `estatua_do_templo`, `discipulo_pestilento`, `lu_yueh`, `cultista_ghaunadaur` | pronto | estrela, templo e epidemia; evitar ornamento genérico |
| Shendilavri | `escravo_de_rivenheart`, `sucubo`, `ilusao_de_sucubo`, `guarda_do_castelo`, `master_of_cruelties`, `malcanthet` | pronto com referências | ilusão por shader quando possível; Master é reuso |
| Goranthis | `ilusao_de_socothbenoth`, `guardiao_de_goranthis`, `cultista_de_socothbenoth`, `socothbenoth`, `death_tyrant` | pronto com referências | Death Tyrant é canônico realocado; prever corrupção de Socothbenoth |
| Pilares | `sintese_abissal` | depende das âncoras | gerar por último |

## 3. Retratos faltantes

`korrak`, `leoric`, `nyrelia`, `zynara`, `bromnor`.

Os cinco retratos existentes permanecem como âncoras. Os novos ficam em 640×427; não se migra a coleção inteira neste lote.

## 4. Convenção obrigatória dos prompts

Padrão herdado de `nottcard-ai/.atena/generated`:

1. frontmatter com `id`, `type`, `title`, `status`, `created`, `relations` e `sources`;
2. aviso de artefato derivado;
3. seção "Como usar" com ordem e dependências;
4. especificação técnica exata da família;
5. bloco de estilo comum;
6. prompt autocontido por imagem;
7. caminho bruto e final, tamanho, escala e papel no gameplay;
8. tabela de registro da candidata aprovada;
9. checklist de triagem e validação em jogo.

Para o ImageGen atual, pedir **transparência real**, não chroma-key. Magenta ou verde sólido só será recuperação explícita. Cada imagem distinta usa uma chamada própria.

## 5. Contrato prompt → asset

```text
### <número> <nome exibido>
ID: <id do JSON>
Uso: <fase, onda, elite, chefe, menu>
Arquivo final: assets/<família>/<id>.png
Bruto/candidatas: assets/_raw/<família>/<id>_vNN.png
Referências: <arquivos e papel de cada um>
Dependências: <asset aprovado anteriormente>
Tamanho final: <largura>x<altura>, RGBA/RGB
Escala/encaixe: <altura relativa, base e margens>
Fonte de lore: <vault/D&D/gameplay>
Prompt: <bloco autocontido>
Aceite: <checklist específico>
```

Uma entrada gera um arquivo final. Retrato, sprite e ícone da mesma identidade recebem prompts próprios e usam o anterior como imagem-âncora.

## 6. Documentos e ordem

| Ordem | Documento | Conteúdo |
|---:|---|---|
| 1 | `ART-PROMPTS-001-direcao-e-piloto.md` | contrato e piloto Dagruve |
| 2 | `ART-PROMPTS-002-retratos-e-herois.md` | 5 retratos; sprites preparados para lote posterior |
| 3 | `ART-PROMPTS-003-inimigos-dagruve-shedaklah.md` | 10 lacunas |
| 4 | `ART-PROMPTS-004-inimigos-molor-durao.md` | 11 lacunas |
| 5 | `ART-PROMPTS-005-inimigos-feng-tu-shendilavri.md` | 12 lacunas |
| 6 | `ART-PROMPTS-006-inimigos-goranthis-pilares.md` | 6 lacunas |
| 7 | `ART-PROMPTS-007-biomas-props-thumbnails.md` | pisos, props e thumbnails |
| 8 | `ART-PROMPTS-008-interacoes.md` | 8 interações |
| 9 | `ART-PROMPTS-009-icones-armas-itens.md` | armas, bases e únicos |
| 10 | `ART-PROMPTS-010-icones-passivas-bencaos-ui.md` | passivas, bênçãos e HUD |

## 7. Gate antes da redação integral

- Decidir `demonio_de_gehenna`: demônio autoral ou yugoloth.
- Manter os cinco retratos existentes como âncoras neste ciclo.
- Manter os dez inimigos existentes como finais provisórios e referências.
- Figuras começam com uma pose estática; animação fica fora.
- Nenhuma criatura adicional de D&D entra sem novo ID/spec aprovada.
