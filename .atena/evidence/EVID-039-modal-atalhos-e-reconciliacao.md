# EVID-039 — Modal, atalhos e reconciliação

Data: 2026-09-26

## Escopo executado

- O atalho do Navegador QA passou a exigir o acorde simultâneo `Ctrl+O+P`,
  conforme a referência de Nottcard e a aprovação do responsável.
- Execuções visíveis de depuração agora habilitam o perfil QA Interno; exports
  release e processos headless permanecem protegidos por feature de build.
- O sandbox QA converte `user://qa-sandbox/...` em caminho absoluto antes de
  criar a pasta e informa falhas de abertura ao playtester, em vez de falhar em
  silêncio.
- O cálculo de tamanho do modal de boas-vindas foi extraído para uma função
  determinística, preservando margem de 24 px, máximo de 820 x 560 e rolagem
  vertical do conteúdo.
- Brook foi reconciliado no manifesto: as nove sequências-fonte estão completas
  e as três direções inversas continuam derivadas por espelhamento no runtime.

## Validação

Comando executado:

```text
D:\Godot\Godot_v4.7.2-stable_win64.exe --headless --path . -s tests/run_all.gd
```

Resultado: `testes: 0 falha(s)`.

`tests/test_playtest.gd` cobre o tamanho do modal em 1280 x 720, 375 x 667 e
320 x 480, o mapeamento de F5, F6, F7, F11 e F12, e as condições positivas e
negativas do acorde QA.

## Pendências deliberadas

As SPEC-019 e SPEC-020 seguem em execução. Ainda é necessário um smoke visual
interativo do modal e a validação integrada dos perfis de build, captura/ZIP,
sandbox de save e catálogo de cenários QA. Nenhuma alteração local fora deste
lote foi versionada, removida ou publicada.
