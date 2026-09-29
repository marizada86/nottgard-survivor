# RECEBIMENTO DE ASSETS — candidatas vindas do ChatGPT

Procedimento para receber os PNGs brutos gerados fora do projeto, triar, montar
a prancha de revisão e (só com aprovação do dono) admitir em `assets/`.
Vale para as três filas de prompts.

## O que está esperando chegada

| Fila | Prompts | Numeração | Situação | Origem |
|---|---:|---|---|---|
| [CHATGPT-FILA-001](../generated/CHATGPT-FILA-001-prompts-prontos.md) | 39 | P01–P39 | **Em andamento** (já enviada) | Lote 1, piloto de HQ, Lote 2 |
| [CHATGPT-FILA-002](../generated/CHATGPT-FILA-002-hqs-ondas-1-e-2.md) | 52 | H01–H52 | Pronta, não enviada | HQs, Ondas 1 e 2 |
| [CHATGPT-FILA-003](../generated/CHATGPT-FILA-003-hqs-trilha-c.md) | 16 | C01–C16 | Opcional, não enviada | HQs, Trilha C |

Total esperado: **107 imagens** (35 assets de jogo + 72 quadros de HQ), listadas
uma a uma em [CANDIDATES-MANIFEST-001.json](../generated/CANDIDATES-MANIFEST-001.json).
**As filas não se misturam:** cada uma tem numeração, origem e nomes de arquivo próprios.

## Onde colocar os arquivos

A pasta `.atena/generated/art-candidates/` **é ignorada pelo git** (as imagens
não vão para o repositório). Estrutura já criada:

| Pasta | Recebe |
|---|---|
| `lote-1/` | P01–P08 (névoa, baú de chefe, ímã, NPCs) |
| `hq/` | todos os quadros de HQ (P09–P12, H01–H52, C01–C16) |
| `scenery/` | P13–P39 (estrutura, remendo e trilha por bioma), **sem subpasta por bioma** |
| `_inbox/` | qualquer arquivo ainda sem nome certo; a Atena renomeia |

Nome do arquivo: `<id>_v01.png` (`_v02`, `_v03` para nova tentativa do mesmo
prompt). O `<id>` está no título de cada prompt: `nevoa_textura_01`,
`dagruve_estrutura_01`, `hq_n02_q1`… Se não souber o nome, jogue em `_inbox/`.

## Triagem automática (somente leitura)

```powershell
powershell -File tools\check_candidates.ps1                 # tudo
powershell -File tools\check_candidates.ps1 -Fila 002       # só uma fila
powershell -File tools\check_candidates.ps1 -OnlyFound      # só o que já chegou
powershell -File tools\check_candidates.ps1 -Inbox          # arquivos soltos
```

Para cada imagem que chegou, o script informa a versão mais recente, o tamanho e
sinaliza:

- **Assets de jogo:** formato (quadrada ou paisagem), cor de fundo nos 4 cantos
  (magenta `#FF00FF`, ciano `#00FFFF`, verde `#00FF00` ou preto `#000000`, conforme
  o prompt), arquivo pequeno demais.
- **Quadros de HQ:** proporção 16:9, resolução baixa, arquivo pequeno.

Status: `OK`, `REVISAR` (algum alerta), `FALTA` (não chegou), `ERRO`. Isso é só
triagem: **a aprovação visual é sempre do dono.**

## Fluxo depois que os PNGs chegam

1. **Triagem** com o script acima e checagem visual rápida.
2. **Prancha de revisão** por lote/HQ, montada pela Atena, para você marcar
   aprovadas e reprovadas.
3. **Reprovadas:** regerar (`_v02`) com o mesmo prompt. Defeitos que reprovam:
   silhueta translúcida, pixels soltos, halo, texto, moldura, gore, personagem
   fora do retrato de referência.
4. **Aprovadas — assets de jogo:** remover a cor de fundo para obter o alfa real
   (a névoa converte a **luminância em alfa**), recortar e redimensionar.
5. **Aprovadas — HQs:** redimensionar para 1280×720 (filtro de área) e admitir
   conforme a SPEC-080.
6. **Admissão em `assets/`** com backup de qualquer arquivo substituído, suíte e
   smoke verdes, e evidência `EVID-110` em diante.

## Travas de admissão (não admitir antes)

| Item | Trava |
|---|---|
| Lote 2 (cenário) | **BUG-013** (props flutuando) fechado e spec de decais (**SPEC-079**, reservada) aberta |
| Todas as HQs | Decisões **D1 a D5** da SPEC-080 e **D-N1 a D-N6** do PLAN-040; tela de HQ é o **MEC-025**, em commit separado da arte |
| Trilha C | Só se o **MEC-015** (venda de HQs) for aprovado |
| Lote 1 | Nenhuma trava técnica; ART-008, 009, 011 e 015 continuam abertos até a admissão |

## Regras de commit

- Imagens brutas **não** entram no git (pasta ignorada).
- Arte e mecânica em commits separados (regra do backlog).
- Cada fila em commit próprio, para não misturar com pedidos em andamento.
- O manifesto muda só quando um prompt novo ou um nome de arquivo mudar.

## Para regenerar o manifesto

O manifesto é derivado das três filas. Se uma fila mudar, peça à Atena para
regerar o `CANDIDATES-MANIFEST-001.json` e conferir a contagem (107).
