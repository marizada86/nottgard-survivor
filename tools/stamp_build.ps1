# Grava data/build_info.json com o hash curto do commit atual.
# Rode antes de exportar uma build de playtest; o CI faz o mesmo passo.
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$commit = (git -C $root rev-parse --short HEAD).Trim()
$dirty = if ((git -C $root status --porcelain -- core ui data assets).Length -gt 0) { '+' } else { '' }
$json = @{ commit = "$commit$dirty"; date = (Get-Date).ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ssZ') } | ConvertTo-Json
[IO.File]::WriteAllText((Join-Path $root 'data/build_info.json'), $json, (New-Object Text.UTF8Encoding $false))
Write-Output "build_info.json: $commit$dirty"
