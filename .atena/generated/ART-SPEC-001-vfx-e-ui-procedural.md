# ART-SPEC-001 — VFX e UI procedural

Status: **approved-for-implementation**  
Data: 2026-09-22

## Princípio

Efeitos comunicam regra; não competem com sprites. Usar Godot `draw_*`, partículas e shaders simples, sem PNG gerado por efeito ou nível.

## Vocabulário

| Função | Forma | Cor principal | Duração/limite |
|---|---|---|---|
| físico | arco/risco angular | branco sujo/vermelho seco | até 0,18 s |
| radiante | estrela/anel aberto | branco, dourado, azul | até 0,35 s |
| mágico | losango/onda | violeta, azul | até 0,40 s |
| fogo | núcleo + três línguas | âmbar/vermelho | partículas contidas |
| ácido/slime | poça orgânica | verde-negro | borda pulsante lenta |
| sombra | pós-imagem/dissolução | carvão/roxo | alfa máximo 70% |
| controle | anel quebrado | azul-violeta | sem cobrir silhueta |
| cura | pulso interno | azul-claro/dourado | um pulso, não contínuo |

## Regras de legibilidade

- máximo de três efeitos grandes simultâneos por quadrante de tela;
- telégrafo sempre aparece antes do dano e usa borda distinta do impacto;
- jogador, chefe e interação nunca ficam totalmente cobertos;
- cor não é o único sinal: variar forma, direção e ritmo;
- cooldown é máscara radial/escurecimento na UI, não nova imagem;
- ilusões reutilizam sprite com shader magenta/translúcido e leve deslocamento;
- corrente, raios, névoa, poças e fases de chefe são procedurais;
- validar em 1280×720 com 30–60 inimigos.

## Componentes estruturais

Painéis, barras, slots, molduras, foco, prompts de tecla e ícones simples de upgrade são SVG/NinePatch/desenho Godot. Texto permanece texto acessível e nunca rasterizado em uma imagem gerada.

