# EVID-052 — Baseline da SPEC-043

Data: 2026-09-27  
Escopo: baseline autorizado pelo PLAN-012; nenhuma correção de asset, renderer,
metadado visual ou cena foi executada.

## Referência de falha

Captura fornecida pelo dono nesta tarefa em 2026-09-27. Ela mostra rochas e
pilares visualmente separados de suas sombras e fundamenta a reabertura da
validação de contato visual. O relato também identifica animações de Nyrelia
como bugadas; a inspeção das folhas revela base inconsistente e VFX nas bordas
de células como hipóteses a validar no piloto.

## Suite determinística

Comando: `Godot_v4.7.2-stable_win64.exe --headless --path . -s tests/run_all.gd`

Resultado: `testes: 0 falha(s)`.

Avisos ambientais não bloqueantes:

- não foi possível escrever `user://logs/godot.log`;
- não foi possível ler o repositório de certificados do sistema.

## Smoke das fases

Comando: `Godot_v4.7.2-stable_win64.exe --headless --path . res://tools/smoke.tscn`

Resultado: `smoke: ok` nas fases Dagruve, Docas, Shedaklah, Molor, Durao,
Feng Tu, Shendilavri, Goranthis e Pilares.

O encerramento relatou quatro instâncias ObjectDB e dois recursos ainda em uso;
como o smoke concluiu com êxito, isso é um aviso de limpeza preexistente a
acompanhar e não foi alterado nesta SPEC.

## Conclusão

O baseline automatizado não reproduz o defeito perceptivo. A execução continua
bloqueada pelo gate da SPEC-043 até que o dono aprove o piloto visual e os
arquivos candidatos.
