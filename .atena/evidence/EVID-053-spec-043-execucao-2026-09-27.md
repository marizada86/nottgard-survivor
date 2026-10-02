# EVID-053 — Execução da SPEC-043

Data: 2026-09-27  
Escopo executado: normalização local de Nyrelia e contato de sombra de props;
sem mudanças de lore, colisão, posição lógica, y-sort, gameplay ou serviços
remotos.

## Nyrelia

- `tools/analyze_nyrelia_frames.gd` mediu a base por célula. A maior divergência
  observada em caminhada foi de 21 px entre quadros.
- `tools/normalize_nyrelia_frames.gd` normalizou as nove folhas-fonte para
  linha de base visível `y = 368`, mantendo 256×384 por célula e preservando
  alfa/conteúdo de cada strip.
- As candidatas permanecem em
  `.atena/generated/animation-candidates/heroes/nyrelia/v01/`; os originais
  recuperáveis estão em
  `.atena/evidence/legacy-backup/assets/animations/heroes/nyrelia/2026-09-27-spec-043/`.
- `ui/hero_view.gd` alinha a linha de base normalizada de Nyrelia ao contato
  lógico sem alterar o comportamento dos demais heróis.

## Props

- `ui/prop.gd` limita a sombra dinâmica ao ponto de contato: sua borda inferior
  não pode ficar mais que dois pixels abaixo da origem visual do prop.
- A mudança preserva os perfis existentes por asset e evita o aspecto de elipse
  destacada abaixo de rochas, pilares e outros props dinâmicos.
- `tests/test_prop_grounding.gd` protege a regra geométrica de contato.

## Verificação

1. `Godot_v4.7.2-stable_win64.exe --headless --path . -s tests/run_all.gd`
   terminou com `testes: 0 falha(s)`.
2. `Godot_v4.7.2-stable_win64.exe --headless --path . res://tools/smoke.tscn`
   terminou com `smoke: ok` nas nove fases.
3. Os avisos ambientais de `user://logs/godot.log`, certificados do sistema e
   limpeza de recursos no encerramento persistem do baseline; não bloquearam
   os testes nem foram alterados por esta SPEC.

## Exceção visual

O modo headless não disponibilizou framebuffer para `tools/shot.tscn`, e a
superfície de automação do computador não expôs uma janela nativa de Godot.
Assim, a inspeção interativa em 1280×720 de Nyrelia, Dagruve, Docas e Durao
permanece pendente. Esta evidência não afirma aceite visual final; ela registra
apenas validação estrutural e automatizada.
