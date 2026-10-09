# Shendilavri — Escravo de Rivenheart

PLAN-053 / SPEC-121, IN_PLAN, aprovacao por plano e identidades pelo dono. 20 quadros selecionados, quatro tiras instaladas localmente. Marcha arrastada aceita explicitamente pelo dono; nenhuma excecao transferida aos demais atores.

[Recibo, fontes, hashes e checks](../generated/shendilavri-resume/v01/escravo-completion-receipt.json). [Prancha](../generated/priority-review/escravo_de_rivenheart_all_states.png). [Captura real](../generated/priority-review/escravo_de_rivenheart_runtime.png).

Queue, runtime de ator real, suite e smoke nove fases passaram sem erros de script. Manifesto: 163 hashes conferidos. Recuperados CursorSkin, UID e dados existentes, identicos a replica local somente leitura. Corrigida duplicidade de _exit_tree preservando ambos os comportamentos; teste de fila usa arquivo persistente dentro do workspace, evitando falso verde por erro de escrita fora do sandbox. Essas correcoes foram necessarias para instanciar e validar o runtime atual.

Death03 v02 evita salto para cima; variacao de cinco pixels entre death03/04 vem de braco/cabelo na pose colapsada. Fontes nativas preservadas, sem limpeza de alfa ou redesenho por script. Integracao local; sem commit, push ou publicacao. Proximo: Sucubo.
