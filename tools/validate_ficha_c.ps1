param([ValidateSet('import','tests','capture')][string]$Mode = 'import', [switch]$Mobile)
$ErrorActionPreference = 'Stop'
$taskRoot = Split-Path -Parent $PSScriptRoot
$taskOutput = Join-Path $taskRoot '.atena/generated/ficha-c-integration/v01'
$env:APPDATA = Join-Path $taskOutput 'godot-user'
$env:LOCALAPPDATA = $env:APPDATA
New-Item -ItemType Directory -Force $env:APPDATA | Out-Null
$taskArgs = @('--path', $taskRoot, '--log-file', (Join-Path $taskOutput ($Mode + $(if ($Mobile) {'-mobile'} else {''}) + '.log')))
if ($Mode -eq 'import') { $taskArgs += @('--headless', '--editor', '--quit') }
if ($Mode -eq 'tests') { $taskArgs += @('--headless', '--script', 'tests/run_all.gd') }
if ($Mode -eq 'capture') { $taskArgs += @('res://tools/capture_ficha_c_art.tscn', '--resolution', '1280x720') }
$taskArgs += @('--', '--controller-profile', (Join-Path $taskOutput 'qa-profile.json'))
if ($Mobile) { $taskArgs += '--mobile-controls' }
& 'D:\Godot\godot.exe' @taskArgs
exit $LASTEXITCODE
