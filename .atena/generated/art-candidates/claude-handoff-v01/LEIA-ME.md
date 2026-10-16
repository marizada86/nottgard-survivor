# Artes para Claude — entrega v01

Pedido do dono em 2026-10-16, execução aprovada por plano. Este documento é **DRAFT de entrega**; cada arte conserva o estado registrado no [manifesto](manifest.json). Nenhuma alteração de runtime, geração de arte ou promoção canônica foi feita nesta entrega.

## Ordem de implementação

1. **FILA-028: 34 artes com preparação visual aceita**, em `fila028/`: 13 ícones de armas/equipamentos, 2 bênçãos, Arcanista, 11 peças de segredos/ruínas, 6 eventos e 1 altar. O estado é `CANON_PREPARATION_VISUAL_ONLY`: o aceite da preparação não equivale à admissão no runtime. Conferir o checkpoint de admissão com o dono antes de executar a integração.
2. **Durvall: 4 tiras v03 DRAFT**, em `durvall-v03/`: `move_e`, `move_se`, `move_s`, `attack`. O dono aprovou provisoriamente no laboratório; a reavaliação depois das direções finais continua pendente. São candidatas para a futura migração, não um conjunto completo pronto para substituir o runtime.

Para cada entrada, o manifesto registra `source`, `path`, `sha256`, `revision`, `content_state`, `runtime_destination`, `runtime_before_sha256`, `status`, `admission_gate`, `integration` e `records`. Os destinos são propostas baseadas no contrato de prompt: validar os IDs efetivos dos dados e o carregamento no código. Não presumir que copiar um PNG implementa sua exibição.

## Integração da FILA-028

- **IC01–IC06:** `assets/icons/weapons/`; conferir `data/weapons.json` e resolução de ícones. **IC07–IC13:** `assets/icons/items/`; conferir `data/items.json`. **I01–I02:** `assets/icons/boons/`; conferir `data/boons.json`. Substituir os ícones emprestados apenas nos itens correspondentes e testar ofertas/detalhes/baús.
- **AR01:** `assets/interactions/arcanista.png`; `ui/overlay.gd` já procura este nome. Conferir desenho, escala de NPC e contato com o solo.
- **EV01–EV06:** destinos propostos `assets/interactions/<nome>.png`. Confrontar `data/random_events.json`, `core/random_events.gd` e `ui/overlay.gd`: vincular o ID do evento à imagem, preservando suas regras e interação. Estes seis eventos não são os acontecimentos da ART-032, que já têm arte integrada.
- **SE01–SE11:** conferir `data/secrets.json`, a exibição dos Ecos, câmaras fechadas/abertas e o cenário por fase. O desenho atual dos Ecos é procedural; não basta colocar `eco.png` na pasta. Preservar localização, colisão e regras dos segredos.
- **AL01:** usar exclusivamente `AL01_loop_v03.png`, revisão `AL01-CORR/v01`, seis quadros horizontais, célula 192×192, ciclo total **900 ms**. Os seis quadros estão em `fila028/altar-frames/` como apoio. Nunca reutilizar o `AL01_v02.png` retido por variação do corpo. `ui/overlay.gd` já carrega atlas em `assets/animations/interactions/altar_active.png`; conferir a duração, o estado estático e a âncora.

Não alterar raster, silhueta, paleta ou identidade ao implementar. Se for necessário adaptar arte, abrir o respectivo escopo visual e seus gates. As fontes, os recortes e os aceites continuam disponíveis nos caminhos do manifesto.

## Piloto Durvall

Célula de **512×512**; seis quadros por movimento e quatro no ataque. As quatro fontes em grade estão em `durvall-v03/sources/`. A migração precisa conferir metadados, baseline, escala, FPS e todas as direções no laboratório (`ui/hero_view.gd`). Não espelhar para substituir W/SW/NW: espada e mãos são assimétricas. Os cinco retornos N/NE/W/SW/NW ainda faltam. Respeitar o gate do PLAN-103/M1 e a aceitação provisória D22.

## O que não deve ser implementado de novo

- NPCs/pontos/Manifestação de Juiblex da ART-032; lettering e cursores da FILA-026: integração documentada em `.atena/evidence/assets-preparation-merge-2026-10-13.md`.
- Erik/Arlindo: retratos e 18 tiras admitidos; `.atena/generated/hero-admission-2026-10-13/admission-receipt.json`. Registros mais antigos de quatro tiras faltantes foram superados.
- VFX recentes de projéteis/habilidades: `.atena/evidence/vfx-projectiles-hero-abilities-admission-2026-10-13.md`; Pulso e Ampulheta têm suas evidências de admissão. O playtest humano pendente não torna a implementação ausente.
- Dez peças da ficha C: `.atena/evidence/fila-025-integracao-2026-10-06.json` (PLAN-072), apesar de recibos antigos de geração ainda declararem admissão fora do escopo.
- Inimigos, HQs e cenários históricos: conferir o inventário e as evidências, sem repetir geração/admissão por causa de uma tabela antiga.

## Retidas, ausentes e cobertura

[Pendências](PENDENCIAS.md) distingue novas imagens ausentes, gates e candidatas históricas retidas. [held-candidates.json](held-candidates.json) indexa os pacotes antigos Durvall/Leoric já presentes no repositório; não são alternativas aprovadas às direções do piloto atual.

[generated-image-audit.json](generated-image-audit.json) cobre as **2.371 imagens locais** existentes em `.atena/generated/` antes das cópias desta entrega, incluindo arquivos ignorados. [group-summary.csv](group-summary.csv) resume por pasta e [DISPOSICAO.md](DISPOSICAO.md) explica o tratamento. Imagem idêntica em `assets/` prova presença de arquivo, não funcionamento ou aceite humano. Capturas de tela, pranchas, backups e tentativas antigas não são novas artes finais. O inventário não afirma encontrar imagens que só existam em outra máquina ou conversa externa.

## Verificação e entrega da implementação

Antes de substituir qualquer arquivo, preservar backup e confrontar o hash atual com `runtime_before_sha256`. Executar `pwsh -NoProfile -ExecutionPolicy Bypass -File tools/prepare_claude_art_handoff.ps1 -VerifyOnly` para conferir este pacote; o modo normal só cria uma entrega nova e recusa sobrescrever a existente.

Na futura implementação, atualizar os contratos/manifestos de assets adotados pelo projeto, executar a suíte Godot e smoke das nove fases, verificar imports/caminhos e capturar as telas/estados afetados. Preparar roteiro antes de todo playtest: build, objetivo, procedimento, observações, critérios e feedback esperado. O dono avalia legibilidade, movimento e sensação; os testes automáticos não encerram esses aceites.

Respeitar `AGENTS.md`, `.atena/add.yaml` e o plano persistente. A aprovação desta entrega autoriza seu pacote e sua publicação em branch própria; os gates de implementação, conteúdo visual, merge, main, build/exportação e envio de mensagens continuam próprios. Não há sessão do Claude iniciada automaticamente.
