# EVID-081 — Admissão oficial de Leoric

Data: 2026-09-27  
SPEC: `SPEC-049-preparacao-da-regeneracao-do-piloto-de-leoric.md`

## Autorização e promoção

O dono aprovou explicitamente a promoção: **“aprovar Leoric como oficial”**.
Os nove strips candidatos foram copiados para
`assets/animations/heroes/leoric/` somente após o backup dos oficiais
anteriores.

## Integridade e reversibilidade

- `previous-official/` contém os nove PNGs anteriores e seus hashes conferem
  com `ASSET-OFFICIAL-LOCK-010.json`.
- Os nove paths oficiais conferem byte a byte com os candidatos do lote v01.
- `ASSET-OFFICIAL-LOCK-011.json` atualiza somente os hashes de Leoric e inclui
  o registro canônico 011.

## Integração e verificação

- O editor do Godot escaneou e reimportou `idle`, os seis movimentos, `attack`,
  `active` e `death`.
- A captura [EVID-081-leoric-oficial-runtime-v01.png](EVID-081-leoric-oficial-runtime-v01.png)
  confirma o carregamento dos novos oficiais em escala de jogo.
- Os avisos do Godot referem-se aos diretórios de cache/log e ao certificado do
  ambiente isolado; a reimportação dos PNGs foi concluída.
- `ASSET-OFFICIAL-LOCK-011.json` foi revalidado contra os 126 assets oficiais:
  126 de 126 hashes conferem.
- A suíte `tests/run_all.gd` terminou com `testes: 0 falha(s)`.

## Próxima reconciliação

Manter os nove originais no backup para recuperação local caso seja necessária
uma reversão autorizada.
