# Névoa — entrega para implementação

Conteúdo: DRAFT v01, fontes e preparadas aceitas visualmente pelo dono em 2026-10-15. Responsabilidade: produção nesta frente; implementação por Claude, conforme pedido do dono. Este arquivo é uma entrega local, não confirmação de envio ou integração por outro agente.

| Arquivo | Dimensão | Papel |
|---|---|---|
| [nevoa_mundo_borda_01.png](nevoa_mundo_borda_01.png) | 1536×384 RGBA8 | Faixa rasteira repetível horizontalmente; base densa embaixo; 128 px superiores transparentes |
| [nevoa_mundo_frente_01.png](nevoa_mundo_frente_01.png) | 1280×360 RGBA8 | Frente da Maré, crista preservada, 90 px superiores transparentes e pontas atenuadas |

[Manifesto e hashes](manifest.json), [aceite das preparadas](visual-acceptance.json), [galeria](index.html). RGB constante 224/232/240, alfa por luminância Rec.709 já convertido. O consumer deve tingir pelo modulate; não remover preto nem reconverter luminância no PNG pronto. Não emendar verticalmente a NB01. A NB02 não é uma textura horizontalmente repetível por contrato.

Consumers de referência: `ui/edge_fog.gd` (MEC-059), `ui/run.gd:_update_fog_overlay` (MEC-060), SPEC-158. Destinos sugeridos, ainda não admitidos: `assets/fx/nevoa_mundo_borda_01.png` e `assets/fx/nevoa_mundo_frente_01.png`. Não substituir automaticamente `nevoa_borda_01.png`, que tem outro papel. Dano, faixa, ritmo e outras mecânicas não fazem parte desta entrega.

Antes de integrar, confirmar o escopo autorizado de admissão no contexto da implementação. Preservar fontes/derivadas e promover somente conteúdo/revisão explicitamente aceitos se houver decisão canônica. Checks de implementação a definir pelo responsável: importação, consumidores, suíte/smoke pertinentes, capturas de borda/Maré e leitura de combate. Contraste no fundo claro é baixo; modulação/composição e cenas reais devem ser avaliadas. Perigo percebido, avanço e preservação de leitura em combate exigem playtest humano; nenhum foi realizado nesta entrega.

Nenhuma mudança em assets oficiais, código ou dados executada aqui. Commit/push/exportação desta preparação ainda não solicitados.
