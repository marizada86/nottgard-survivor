# PLAN-007 — Geração dos assets-fonte faltantes de Brook

Status: **quatro fontes faltantes de Brook normalizadas e integradas em 2026-09-25; validação Godot pendente por indisponibilidade do executável.**

## Objetivo

Gerar candidatas para as quatro folhas-fonte de animação de Brook que ainda não
existem em `assets/animations/heroes/brook/`, preservando sua identidade
canônica e o contrato operacional de `SPEC-021`.

## Escopo

| Prompt | Entrega candidata | Contrato da folha | Destino final pretendido |
|---|---|---|---|
| `HERO-brook-move_s` | uma candidata `v01` | 6 quadros, grade 3×2, célula 256×384; caminhada para baixo na tela | `assets/animations/heroes/brook/move_s.png` |
| `HERO-brook-attack` | uma candidata `v01` | 4 quadros, grade 2×2, célula 256×384; Sentença de Lliira | `assets/animations/heroes/brook/attack.png` |
| `HERO-brook-active` | uma candidata corretiva `v03` | 6 quadros, grade 3×2, célula 256×384; Guarda de Lliira | `assets/animations/heroes/brook/active.png` |
| `HERO-brook-death` | uma candidata `v01` | 6 quadros, grade 3×2, célula 256×384; queda lateral sem gore | `assets/animations/heroes/brook/death.png` |

O prompt base será o texto já aprovado em
`.atena/generated/ART-PROMPTS-016-animacoes-dos-herois.md`, estruturado para a
geração com o bloco comum de animações e sem introduzir lore, acessórios ou
efeitos novos.

## Fatos e restrições imutáveis

- Brook é um jovem anão adulto, baixo e robusto, com barba e cabelo
  castanho-escuros, armadura de aço escuro e couro, maça compacta e um pequeno
  acento dourado de Lliira.
- As orelhas são curtas, arredondadas e parcialmente cobertas pelo cabelo;
  nunca longas, pontudas ou élficas.
- Todas as folhas usam corpo inteiro, linha de base comum, câmera isométrica em
  três quartos, luz superior esquerda e alfa verdadeiro.
- Não pode haver cenário, fundo sólido, sombra projetada, texto, marca-d’água,
  personagens, armas ou membros duplicados, nem redesenho da identidade.
- `active` deve corrigir somente as falhas objetivas da v02 (artefatos e linha
  de base) e manter a Guarda de Lliira discreta, sem asas ou halo.

## Fora de escopo

- Não regenerar `idle`, `move_n`, `move_ne`, `move_e` ou `move_se`, que já
  existem no destino final.
- Não gerar `move_w`, `move_nw` e `move_sw`: o contrato atual os produz por
  espelhamento das fontes `move_e`, `move_ne` e `move_se`.
- Não corrigir ou integrar `move_e`; seu registro segue `qa_failed` e requer
  um plano corretivo próprio.
- Não recortar, normalizar, mover para `assets/`, alterar cenas, fazer commit
  ou publicar nesta etapa.

## Plano de voo

1. Registrar `HERO-brook-move_s` como `queued` e reconfirmar, nos quatro
   registros do lote, a releitura de `ART-PROMPTS-001`, `ART-PROMPTS-016`, do
   manifesto e dos dados de herói, arma e habilidade.
2. Montar quatro chamadas independentes com o modo padrão de geração de imagem,
   uma por prompt, com fundo transparente real. Incluir as referências locais
   `assets/portraits/brook.png` (identidade, barba e armadura) e
   `assets/heroes/brook.png` (silhueta e paleta) somente após a autorização
   explícita de envio remoto deste lote.
3. Gerar no máximo uma candidata por chamada: `move_s_v01`, `attack_v01`,
   `active_v03` e `death_v01`, sempre fora de `assets/`, em
   `.atena/generated/animation-candidates/heroes/brook/`.
4. Fazer QA independente de identidade, orelhas, ação/direção, contagem e
   grade de quadros, linha de base, câmera, iluminação, alfa, halos e ausência
   dos artefatos proibidos. Registrar resultado e motivo objetivo em cada JSON
   de execução.
5. Apresentar as quatro candidatas juntas para revisão visual. Candidatas
   rejeitadas recebem um único motivo de correção; nenhuma iteração acontece
   sem nova autorização dentro do limite de três candidatas por prompt.
6. Após a aprovação visual do conjunto, solicitar um gate separado para
   recorte, normalização, integração nos destinos finais e validação no Godot.

## Critérios de aceite deste lote de geração

1. Existem quatro candidatas rastreáveis, uma para cada prompt da tabela, e
   nenhuma foi integrada automaticamente.
2. Cada registro de execução contém as leituras obrigatórias, referências,
   versão, caminho e checklist de QA completo.
3. Cada folha cumpre grade, quantidade de quadros, tamanho de célula, direção
   visual, identidade de Brook e alfa real, sem halos ou artefatos.
4. A folha `active_v03` resolve as falhas documentadas em `active_v02` sem
   alterar espécie, equipamento, pose de bloqueio ou efeito contido da Guarda
   de Lliira.
5. A revisão visual humana decide a aceitação antes de qualquer processamento
   ou mudança em `assets/`.

## Evidência e reconciliação

- Registros: `.atena/generated/prompt-execution/HERO-brook-<sequencia>.json`.
- Candidatas: `.atena/generated/animation-candidates/heroes/brook/`.
- Ao concluir a geração, registrar uma evidência com prompts, versões, QA,
  decisões e divergências; reconciliar o manifesto apenas após a integração
  aprovada em etapa posterior.

## Gates necessários

1. Aprovação deste plano de voo.
2. Aprovação explícita do lote de quatro `prompt_id`s e da transferência remota
   das duas referências locais indicadas.
3. Aprovação visual das candidatas.
4. Aprovação independente para normalização e integração no jogo.
