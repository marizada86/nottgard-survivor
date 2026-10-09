$ErrorActionPreference='Stop'
$queueCheckRoot=(Get-Location).Path
$queueOut=Join-Path $queueCheckRoot '.atena/generated/image-queue-publication-2026-10-09'
$queueProfile=Join-Path $queueOut 'local-profile'
New-Item -ItemType Directory -Force -Path $queueProfile | Out-Null
$env:APPDATA=$queueProfile
$env:LOCALAPPDATA=$queueProfile
$queueExe='F:/dev/nottgard-survivor/Godot_v4.7.2-stable_win64.exe'
$queueChecks=@(
 @{Name='import-isolated';Args=@('--editor','--import','--quit');Marker='loading_editor_layout'},
 @{Name='suite';Args=@('-s','tests/run_all.gd');Marker='testes: 0 falha(s)'},
 @{Name='smoke';Args=@('res://tools/smoke.tscn');Marker='smoke: ok'}
)
$queueRows=@()
foreach($queueCheck in $queueChecks){
 $queueLog=Join-Path $queueOut ($queueCheck.Name+'.log')
 $queueArgs=@('--headless','--path',('"'+$queueCheckRoot+'"'),'--log-file',('"'+$queueLog+'"'))+$queueCheck.Args
 $queueProcess=Start-Process -FilePath $queueExe -ArgumentList $queueArgs -WindowStyle Hidden -PassThru
 if(!$queueProcess.WaitForExit(60000)){throw "Own QA process timed out: PID=$($queueProcess.Id)"}
 $queueText=Get-Content -LiteralPath $queueLog -Raw
 $queueBlockingErrors=@($queueText -split "`n" | Where-Object {$_ -match 'ERROR:' -and $_ -notmatch '^ERROR: Failed to read the root certificate store\.'})
 $queuePassed=$queueProcess.ExitCode -eq 0 -and !$queueText.Contains('SCRIPT ERROR') -and $queueBlockingErrors.Count -eq 0 -and $queueText.Contains($queueCheck.Marker)
 $queueRows+=@{check=$queueCheck.Name;exit=$queueProcess.ExitCode;passed=$queuePassed;log=$queueLog;marker=$queueCheck.Marker;environment_certificate_notice=$queueText.Contains('Failed to read the root certificate store');blocking_errors=$queueBlockingErrors}
 $queueRows | ConvertTo-Json -Depth 4 | Set-Content -LiteralPath (Join-Path $queueOut 'checks.json') -Encoding utf8
 if(!$queuePassed){throw "QA failed: $($queueCheck.Name), exit=$($queueProcess.ExitCode). Inspect $queueLog"}
 Write-Output "$($queueCheck.Name) passed, exit=$($queueProcess.ExitCode)"
}
