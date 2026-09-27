# PLAN-016 — Regeneração controlada dos assets de Leoric

Status: **concluído — Leoric admitido como oficial** (2026-09-27).

## Objetivo

Regenerar as animações de Leoric para que o gnomo astrônomo seja legível na
escala de jogo, preservando chapéu largo, barba grisalha, manto verde-musgo,
constelações douradas e foco azul — sem trocar qualquer byte oficial antes de
seleção e admissão rastreável.

## Diagnóstico

Os nove strips atuais estão presentes, têm dimensão e alfa válidos, mas a
prancha oficial mostra corpo fragmentado e dominado por traços/partículas. A
ressalva de QA já registrada na SPEC-044 se confirma: o problema é perceptivo,
não ausência de arquivo ou de integração.

## Escopo

### Piloto obrigatório

| Strip | Frames | Critério central |
| --- | ---: | --- |
| `idle` | 4 | Chapéu, barba, corpo e manto reconhecíveis. |
| `move_se` | 6 | Passo diagonal e contato com o chão. |
| `attack` | 4 | Corpo permanece claro durante Sopro de Estrela. |

### Expansão após aceite do piloto

`move_n`, `move_ne`, `move_e`, `move_s`, `active` e `death`, com espelhamento
de `move_w`, `move_nw` e `move_sw` preservado pelo runtime.

## Contrato visual e técnico

1. Célula RGBA 256×384, fundo transparente, visão isométrica 3/4 e pé visível
   em y=367 com margem lateral mínima de 8 px.
2. Leoric é um gnomo adulto, nunca chibi: chapéu escuro largo, barba grisalha,
   manto verde-musgo, detalhes de constelação dourados e foco azul.
3. A leitura em 72 px exige silhueta corporal preenchida; VFX azul/dourado não
   pode apagar o mago nem tocar a borda da célula.
4. `idle` e `attack` terão quatro frames; os demais strips, seis. Nenhuma
   célula pode cruzar a vizinha.

## Plano de voo

1. Criar SPEC e brief local com referências, prompts, negativos e critérios de
   descarte, sem gerar nem alterar arquivos oficiais.
2. Gerar e inspecionar as 14 células do piloto em área versionada fora de
   `assets/`; montar tiras candidatas e renderizar QA na escala real.
3. Apresentar o piloto ao dono. Apenas um piloto aceito permite a expansão.
4. Gerar o lote restante, validar base, alfa, margens, frames, espelhamentos,
   runtime e testes.
5. Após autorização de admissão, preservar os PNGs anteriores, substituir os
   paths oficiais, reimportar, atualizar lock/registro e registrar evidência.

## Não objetivos

- Mudar dados, lore, Sopro de Estrela, Constelação, cenas, SFX ou gameplay.
- Gerar outros heróis ou props.
- Sobrescrever arquivos oficiais antes da admissão.

## Gates

1. Aprovar este plano cria apenas a SPEC e o brief local.
2. Aprovar a SPEC autoriza a preparação local, não a geração.
3. Autorizar a geração permite produzir candidatos; aceite artístico do piloto
   e admissão nos paths oficiais continuam decisões distintas.
