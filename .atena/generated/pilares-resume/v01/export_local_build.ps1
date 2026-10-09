$ErrorActionPreference='Stop'
$taskRoot=(Get-Location).Path
$taskOut=Join-Path $taskRoot '.atena/generated/pilares-resume/v01'
$taskBuildDir=Join-Path $taskRoot 'build/image-priority-pilares-complete'
$taskExe=Join-Path $taskBuildDir 'NottgardSurvivors.exe'
$taskGodot='F:/dev/nottgard-survivor/Godot_v4.7.2-stable_win64.exe'
& tools/backlog_check.ps1 | Tee-Object -FilePath (Join-Path $taskOut 'backlog-preexport.log')
& tools/stamp_build.ps1
New-Item -ItemType Directory -Path $taskBuildDir -Force | Out-Null
$taskExportLog=Join-Path $taskOut 'pilares-export.log'
$taskProcess=Start-Process -FilePath $taskGodot -ArgumentList @('--headless','--path','.', '--log-file',('"'+$taskExportLog+'"'),'--export-release','"Windows Desktop"',('"'+$taskExe+'"')) -WindowStyle Hidden -PassThru
if(!$taskProcess.WaitForExit(60000)){throw "Export timeout; own PID=$($taskProcess.Id)"}
$taskExportExit=$taskProcess.ExitCode
$taskExportText=Get-Content -LiteralPath $taskExportLog -Raw
if($taskExportExit -ne 0 -or $taskExportText.Contains('SCRIPT ERROR') -or !$taskExportText.Contains('[ DONE ] savepack')){throw "Export failed exit=$taskExportExit"}
if(!(Test-Path -LiteralPath $taskExe)){throw 'Export did not produce executable'}
$taskExeLog=Join-Path $taskOut 'pilares-exe.log'
$taskProcess=Start-Process -FilePath $taskExe -WorkingDirectory $taskBuildDir -ArgumentList @('--headless','--log-file',('"'+$taskExeLog+'"'),'--quit-after','60') -WindowStyle Hidden -PassThru
if(!$taskProcess.WaitForExit(60000)){throw "Executable timeout; own PID=$($taskProcess.Id)"}
$taskLaunchExit=$taskProcess.ExitCode
$taskLaunchText=Get-Content -LiteralPath $taskExeLog -Raw
if($taskLaunchExit -ne 0 -or $taskLaunchText.Contains('SCRIPT ERROR') -or !$taskLaunchText.Contains('Godot Engine v4.7.2')){throw "Executable failed exit=$taskLaunchExit"}
$taskReceipt=[ordered]@{date=(Get-Date).ToUniversalTime().ToString('o');path=$taskExe;export_exit=$taskExportExit;exe_exit=$taskLaunchExit;exe_frames=60;bytes=(Get-Item -LiteralPath $taskExe).Length;sha256=(Get-FileHash -LiteralPath $taskExe -Algorithm SHA256).Hash.ToLowerInvariant()}
$taskReceipt | ConvertTo-Json -Depth 4 | Set-Content -LiteralPath (Join-Path $taskOut 'local-build-process-receipt.json') -Encoding utf8
Write-Output "Pilares local export and executable passed, bytes=$($taskReceipt.bytes)"
