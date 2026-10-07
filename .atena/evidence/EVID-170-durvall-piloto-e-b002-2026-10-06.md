---
id: EVID-170
created: 2026-10-06
plan: PLAN-066
spec: SPEC-133
batch: B-002
status: AWAITING_OWNER_VISUAL_DIRECTION
official_assets_changed: false
---

# Piloto lateral de Durvall — B-002

O dono respondeu “b-002 aprovado” à pergunta conjunta que autorizava o lote e o uso específico de idle.png, move_e.png e move_se.png de Durvall no ImageGen. Classificação IN_PLAN. Produção via ImageGen integrado, seguindo a skill imagegen; sem CLI/API com chave própria, vault, perfil ou outros personagens.

## Saídas e prompts exatos

| Tentativa | Referências | Imagem preservada | Prompt | Resultado |
|---|---|---|---|---|
| v01 | idle, move_e, move_se oficiais | [v01](../generated/durvall-run-refinement/v01/pilot-e-raw-v01.png) | [Prompt v01](../generated/durvall-run-refinement/v01/pilot-e-prompt-v01.txt) | Passada ampla; 2172×724, figuras atravessam limites de colunas. Não admissível. |
| v02 | v01 gerada + move_e oficial | [v02](../generated/durvall-run-refinement/v01/pilot-e-raw-v02.png) | [Prompt v02](../generated/durvall-run-refinement/v01/pilot-e-prompt-v02.txt) | Correção focada no enquadramento, mas continua com figuras nas bordas e dimensões incompatíveis. |
| v03 | move_e + idle oficiais | [v03](../generated/durvall-run-refinement/v01/pilot-e-raw-v03.png) | [Prompt v03](../generated/durvall-run-refinement/v01/pilot-e-prompt-v03.txt) | Seis poses isoladas em grade 3×2, 1536×1024, alfa real. Anatomia/apoio pendentes; não é tira oficial pronta. |

Nenhuma quarta tentativa: o PLAN-066 prevê rever a direção artística após três tentativas. A grade 3×2 da terceira imagem é apenas apresentação; o contrato final 1536×384 não mudou.

- [Comparação capturada em Godot](../generated/durvall-run-refinement/v01/pilot-e-comparison-v03.png), atual/candidata em escala real e 3×.
- [Reprodução animada](../generated/durvall-run-refinement/v01/pilot-e-comparison-v03.html), seis quadros a 10 fps, chão a 190 px/s, pausa e quadro individual. Sintaxe verificada; interação no navegador não testada, preservando o limite de URLs locais da EVID-169.
- [Auditoria alfa/dimensões/bordas](../generated/durvall-run-refinement/v01/pilot-e-audit.json).
- [Manifesto e hashes](../generated/durvall-run-refinement/v01/pilot-e-manifest.json).
- [Log Godot](../generated/durvall-run-refinement/v01/pilot-comparison.log).

## Método e limites

O PNG apresenta quadros congelados, não uma captura temporal de partida. SpriteFrames tem seis quadros a 10 fps; HTML reproduz sua progressão temporal e chão uniforme. Não substitui playtest completo.

Baseline: célula 256×384, origem horizontal 128, apoio 376, fator 60/231. Candidata: célula bruta 512×512, origem horizontal 256, apoio de referência 470, fator único 60/360. O fator converte sua resolução para altura-alvo próxima de 60 px (equivale à conversão uniforme 231/360 antes da escala de jogo). Não há escala/reposicionamento por quadro, máscara corretiva, remoção de fundo ou redesenho local. Os PNGs brutos permanecem intactos. A v03 ainda depende de empacotamento validado para uso no runtime oficial.

Na v03, a altura alfa bruta dos quadros é 358, 361, 363, 353, 360, 362 px: aproximadamente 58,8–60,5 px na apresentação. Alfa global detectado como blend; canto da imagem alfa 0; nenhum limite visível toca as bordas de célula na triagem alfa ≥0,10. As bordas inferiores inclusivas são 467, 472, 471, 456, 465, 465. O quadro 4 termina 14 px brutos acima da referência de apoio (≈2,33 px de tela), embora pareça representar contato. Não foi alinhado individualmente para ocultar o defeito.

Limites de silhueta não identificam apoio anatômico. Não se declarou medida exata de foot sliding, ausência de patinação ou correção completa. Alfa real, isoladamente, não aprova os efeitos secundários da imagem.

## Avaliação visual e recomendação

Passada ampla, joelho alto e inclinação comunicam mais urgência. Cabelo e tecido acompanham o movimento. O dono precisa confirmar identidade e direção visual. Ainda há defeitos:

- Pares 1/4, 2/5, 3/6 parecem repetir a mesma configuração de pernas; a alternância anatômica não está convincente.
- Contato do quadro 4 está alto; corrigir ou definir conscientemente uma fase aérea legível.
- Conferir câmera, rotação do torso e continuidade da mão da espada contra move_e; a leitura mais lateral não foi aceita implicitamente.
- Dimensão/layout bruto v03 não atende a tira final do runtime. Loop, transições e admissão oficial ainda não validados.

Recomendação: usar v03 para decidir se a passada ampla e a inclinação são desejadas; não admiti-la como asset final. Rever a direção artística após a decisão do dono, corrigindo alternância, contato e registro antes de expandir às outras direções.

## Verificação e reconciliação

Auditoria headless e captura Windows/OpenGL no Godot 4.7.2 concluídas sem erro nos logs finais. Sintaxe JavaScript e captura PNG verificadas. Links, contrato ADD e hashes dos 23 originais conferidos antes da entrega. Nenhum asset oficial ou gameplay alterado; nenhum bug fechado. Admissão e testes de gameplay continuam no B-004.

S-003 e S-004 concluídos; S-005 preparado e aguardando avaliação visual. B-002 parcial, B-003 não autorizado, B-004 não iniciado. Prompts e candidatas preservados no workspace, mantendo também os arquivos originais gerados no diretório padrão do Codex. Nenhum commit, push ou publicação.

Nota de publicação (2026-10-07): fontes, imagens e projetos de teste dos pilotos Durvall permanecem locais, aguardando decisão do dono após bloqueio da revisão automática. As referências históricas a `.atena/generated/durvall-*` registram trabalho local; não indicam assets admitidos ou publicados. Os registros e o mapa das referências pendentes estão na evidência de consolidação.
