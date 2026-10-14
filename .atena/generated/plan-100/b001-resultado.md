# PLAN-100 / B-001 — resultado (DRAFT, 2026-10-13)

SPEC-173, MEC-065. Filtro visual de tela: Desligado (padrao), Pixel do mundo, Paleta e dither, Gravura.
> **Atualização (2026-10-13):** a variante "Pixel do mundo" foi descartada pelo dono; restam Desligado, Paleta e dither e Gravura. Ver EVID-242, seção 5.

## Entregue (local, sem commit)
- `ui/visual_filter.gdshader`, `ui/visual_filter.gd` (CanvasLayer), `settings.visual_filter` (migracao em `core/profile.gd`), `Game.set_visual_filter` e sinal `visual_settings_changed`, opcao "Visual" em `OptionsPanel`, ligacao em `ui/run.gd`, testes em `tests/test_visual_filter.gd`, ferramenta `tools/capture_visual_filter.*`.
- Camadas na partida: mundo 0 < filtro 1 < texto do mundo 2 (segue a camera) < HUD 3 < encontros 20.
- Achado nas capturas: o texto do mundo (numeros de dano, falas, rotulos de interacao e de aliados) era filtrado e ficava ilegivel no modo Pixel. Resolvido movendo-o para a camada de texto, acima do filtro: `Overlay` ganhou o modo "text" (fila de rotulos da instancia "over"); `_float_text` e `_bark_now` usam `_text_fx`. A HUD sobe de camada 1 para 3.
- Ajuste da Gravura apos captura em Goranthis (contorno pesado como vitral): limiar 0.10 -> 0.22, forca 0.65 -> 0.5.

## Verificacao
- `tests/run_all.gd`: 0 falhas. Smoke: ok (9 fases). `controller_check`: 94/0. `mobile_buttons_check`: 146/0.
- Capturas: `.atena/generated/plan-100/capturas/` (3 biomas x 4 modos, 1280x720). Dagruve e Goranthis em Gravura reimpressas apos o ajuste; Molor foi capturado com o limiar antigo.
- Custo de quadro nesta maquina (GPU desta maquina, VSync desligado, 180 quadros, mundo parado): Desligado 0.97 a 1.58 ms; com filtro +0.0 a +0.15 ms por quadro (Molor e Goranthis; Dagruve ficou ruidoso por aquecimento). Limite: nao representa maquina fraca nem GPU integrada.

## Pendente (subjetivo, do dono)
- Qual variante, se alguma, "fica bonita"; legibilidade; cansaco visual. Nenhuma metrica substitui o playtest.
