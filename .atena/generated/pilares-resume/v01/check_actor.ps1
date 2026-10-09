param([Parameter(Mandatory=$true)][string]$EnemyId,[string]$Biome='pilares',[string[]]$ReuseIds=@(),[switch]$Suite,[switch]$Capture)
$ErrorActionPreference='Stop'
$taskRoot=(Get-Location).Path
$taskOut=Join-Path $taskRoot '.atena/generated/pilares-resume/v01'
$taskExe='F:/dev/nottgard-survivor/Godot_v4.7.2-stable_win64.exe'
function Invoke-LocalGodotCheck([string]$Name,[string[]]$Extra,[string]$Marker,[bool]$Headless=$true) {
 $taskLog=Join-Path $taskOut "$Name.log"
 $taskArgs=@('--path','.', '--log-file',('"'+$taskLog+'"'))
 if($Headless){$taskArgs=@('--headless')+$taskArgs}
 $taskArgs+=$Extra
 $taskProcess=Start-Process -FilePath $taskExe -ArgumentList $taskArgs -WindowStyle Hidden -PassThru
 if(!$taskProcess.WaitForExit(60000)){throw "$Name timed out; own Godot PID=$($taskProcess.Id)"}
 $taskText=Get-Content -LiteralPath $taskLog -Raw
 if($taskProcess.ExitCode -ne 0 -or $taskText.Contains('SCRIPT ERROR') -or !$taskText.Contains($Marker)){throw "$Name failed exit=$($taskProcess.ExitCode): $taskText"}
 Write-Output "$Name passed"
}
Invoke-LocalGodotCheck "$EnemyId-queue" @('-s','tools/check_animation_queue.gd') 'Animation queue: 0 failure(s)'
foreach($taskActorId in @($EnemyId)+$ReuseIds){Invoke-LocalGodotCheck "$taskActorId-runtime" @('-s','tools/check_molor_runtime.gd','--',"--id=$taskActorId",'--actual-actor') 'death cleanup OK'}
if($Suite){
 Invoke-LocalGodotCheck "$EnemyId-suite" @('-s','tests/run_all.gd') 'testes: 0 falha(s)'
 Invoke-LocalGodotCheck "$EnemyId-smoke" @('res://tools/smoke.tscn') 'smoke: ok'
}
if($Capture){Invoke-LocalGodotCheck "$EnemyId-capture" @('--resolution','1440x1080','--quit-after','300','res://tools/capture_shedaklah_animations.tscn','--',"--id=$EnemyId","--biome=$Biome") 'Shedaklah capture result=0' $false}
