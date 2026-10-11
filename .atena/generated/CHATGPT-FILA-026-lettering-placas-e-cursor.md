---
id: "CHATGPT-FILA-026"
title: "Fila de geração: lettering, placas de título e cursor (ART-039, ART-040)"
status: "Dez PNGs v01 aceitos e admitidos, validacao PASS; S013 aguarda commit de arte; L02 opcional deferida"
priority: "3ª: PLAN-053 (heróis) → FILA-025 (ficha C) → esta → FILA-021 → FILA-022/023"
created: "2026-10-06"
relations: ["[[ART-PROMPTS-058-lettering-placas-e-cursor]]", "[[SPEC-132-lettering-e-cursor-do-jogo]]", "[[PLAN-065-lettering-e-cursor-2026-10-06]]"]
---

# CHATGPT-FILA-026: lettering, placas e cursor

Compilação operacional de [[ART-PROMPTS-058-lettering-placas-e-cursor]]; em caso de dúvida, o ART-PROMPTS prevalece (traz os prompts completos, tamanhos finais e critérios de aceite).

## Ordem de envio

1. Uma peça por chamada. Anexar as referências do ART-PROMPTS-058 e dizer o papel de cada uma.
2. **L01 (logo) primeiro**; as demais só depois da aprovação visual da L01 (portão G1).
3. Candidatas em `.atena/generated/art-candidates/lettering/<id>_v01.png` (cursores em `.../cursor/`), até 3 por peça. Nada entra em `assets/` antes da prévia em escala real e da aprovação do dono (portão G2).
4. Peças L: conferir a grafia letra a letra; duas candidatas com erro = a peça cai para placa + fonte.
5. Marque `[x]` ao gerar e `[a]` ao aprovar.

## Fila

- [x] gerada · [a] aprovada — L01 `logo` (v01 CANON visual G1; v02 DRAFT não selecionada; ciano)
- [x] gerada · [a] aprovada — L03 `banner_vitoria` v01 CANON visual G2
- [x] gerada · [a] aprovada — L04 `banner_derrota` v01 CANON visual G2
- [x] gerada · [a] aprovada — L05 `banner_evolucao` v01 CANON visual G2
- [x] gerada · [a] aprovada — P01 `placa_titulo_larga` v01 CANON visual G2
- [x] gerada · [a] aprovada — P02 `placa_titulo_secao` v01 CANON visual G2
- [x] gerada · [a] aprovada — P03 `placa_chefe` v01 CANON visual G2
- [x] gerada · [a] aprovada — C01 `cursor_ponteiro` v01 CANON visual G2
- [x] gerada · [a] aprovada — C02 `cursor_mao` v01 CANON visual G2
- [x] gerada · [a] aprovada — C03 `cursor_mira` v01 CANON visual G2
- [ ] gerada · [ ] aprovada — L02 `prompt_clique` (opcional)

Alinhamento com a ficha C: as placas P01 e P02 só são geradas **depois da aprovação da A01** da FILA-025, para herdarem o mesmo ferro e ouro.

## Mensagens

Admissão posterior em 2026-10-11: **“Autorizo a admissão e validação”**. Dez PNGs (L01 + nove G2) admitidos; imports e testes de cursor/lettering sem falhas. [Recibo](fila026-remaining-2026-10-11/admission-receipt.json) e [evidência](../evidence/fila026-admission-2026-10-11.md). Commit de arte S013, hookups S014 e verificação completa S015 permanecem pendentes; registros abaixo são históricos.

Retomada 2026-10-11: [galeria L01](fila026-l01-2026-10-11/index.html), [auditoria](fila026-l01-2026-10-11/audit.json). Dono escolheu explicitamente L01 v01 no G1; v02 não selecionada. [Galeria G2 das nove peças](fila026-remaining-2026-10-11/index.html), [auditoria G2](fila026-remaining-2026-10-11/audit.json). Fontes e prévias preservadas, sem admissão runtime, commit ou publicação. L02 continua opcional.

Aceite posterior em 2026-10-11: **“Aprovo as nove revisões v01”**. G2 concluído, nove fontes/derivados CANON visual, [registro](../vault/canon/ASSET-APPROVAL-FILA026-G2-v01.md) e [recibo](fila026-remaining-2026-10-11/owner-approval.json). S013 aguarda gate de admissão; [proposta dos dez PNGs e hotspots](fila026-remaining-2026-10-11/admission-proposal.json), sem execução runtime.

Os textos completos de cada mensagem estão em [[ART-PROMPTS-058-lettering-placas-e-cursor]] (seções L01 a L05, P01 a P03, C01 a C03).
