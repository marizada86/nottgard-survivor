param([Parameter(Mandatory=$true)][ValidateSet('servo_de_zuggtmoy','cogumelo_fungico','esporo_voador','slime_de_juiblex','pudim_negro','gargula','receptaculo_de_juiblex','zuggtmoy','alma_penada','demonio_de_gehenna','carcereiro_de_pedra','aberracao_shu','ezro','molydeus_chefe','larva_de_lu_yueh','cultista_de_feng_tu','estatua_do_templo','cultista_ghaunadaur','discipulo_pestilento','lu_yueh','escravo_de_rivenheart','sucubo','guarda_do_castelo','master_of_cruelties','malcanthet','guardiao_de_goranthis','cultista_de_socothbenoth','death_tyrant','socothbenoth','sintese_abissal')][string]$EnemyId, [ValidateSet('shedaklah','durao','feng-tu','shendilavri','goranthis','pilares')][string]$Biome='shedaklah')
$ErrorActionPreference='Stop'
$taskRoot=Split-Path -Parent $PSScriptRoot
$taskSource=Join-Path $taskRoot ".atena/generated/art-candidates/enemies-$Biome/$EnemyId/strips"
$taskPacking=Get-Content -Raw -LiteralPath (Join-Path $taskSource 'packing.json') | ConvertFrom-Json
$taskSelectionPath=Join-Path (Split-Path -Parent $taskSource) 'frame-selection.json'
if(Test-Path -LiteralPath $taskSelectionPath){
 $taskSelection=Get-Content -Raw -LiteralPath $taskSelectionPath | ConvertFrom-Json
 foreach($taskChoice in $taskSelection.PSObject.Properties){
  if($taskChoice.Value.approval_status -eq 'PENDING_OWNER_DECISION'){throw "Pending owner decision: $EnemyId/$($taskChoice.Name)"}
 }
}
$taskStates=[ordered]@{idle=4;move=6;attack=4;death=6}
if($EnemyId -in @('zuggtmoy','molydeus_chefe','lu_yueh','malcanthet','socothbenoth','sintese_abissal')){$taskStates.special=6}
foreach($taskState in $taskStates.Keys){if(!(Test-Path -LiteralPath (Join-Path $taskSource "$taskState.png"))){throw "Missing $taskState"}}
$taskBody=[Math]::Round($taskPacking.body_height)
$taskViewPath=Join-Path $taskRoot 'ui/enemy_view.gd'
$taskView=Get-Content -Raw -LiteralPath $taskViewPath
if(!$taskView.Contains('"'+$EnemyId+'":')){
 $taskSpec='"idle": 4, "move": 6, "attack": 4, "death": 6'
 if($EnemyId -in @('zuggtmoy','molydeus_chefe','lu_yueh','malcanthet','socothbenoth','sintese_abissal')){$taskSpec+=', "special": 6'}
 $taskEntry="`t`"${EnemyId}`": {`"cell`": Vector2i(256, 384), `"body_height`": $taskBody.0, `"states`": {$taskSpec}, `"flip_h_for_move`": true},"
 $taskView=$taskView.Replace('const ANIMATED := {',"const ANIMATED := {`n$taskEntry").Replace('const FEET_Y := {',"const FEET_Y := {`n`t`"${EnemyId}`": 356.0,")
 Set-Content -LiteralPath $taskViewPath -Encoding UTF8 -Value $taskView.TrimEnd()
}
$taskTestPath=Join-Path $taskRoot 'tests/test_animation_assets.gd'
$taskTest=Get-Content -Raw -LiteralPath $taskTestPath
if(!$taskTest.Contains('"res://assets/animations/enemies/'+$EnemyId+'/idle.png"')){
 $taskEntries=@()
 foreach($taskState in $taskStates.Keys){$taskWidth=256*$taskStates[$taskState];$taskEntries+="`t`"res://assets/animations/enemies/$EnemyId/$taskState.png`": Vector2i($taskWidth, 384),"}
 $taskTest=$taskTest.Replace('const ASSETS := {',"const ASSETS := {`n"+($taskEntries -join "`n"))
 $taskSpec='&"idle": 4, &"move": 6, &"attack": 4, &"death": 6'
 if($EnemyId -in @('zuggtmoy','molydeus_chefe','lu_yueh','malcanthet','socothbenoth','sintese_abissal')){$taskSpec+=', &"special": 6'}
 $taskTest=$taskTest.Replace('const WAVE_ONE_ENEMY_ANIMATIONS := {',"const WAVE_ONE_ENEMY_ANIMATIONS := {`n`t`"${EnemyId}`": {`"cell`": Vector2i(256, 384), `"states`": {$taskSpec}},")
 Set-Content -LiteralPath $taskTestPath -Encoding UTF8 -Value $taskTest.TrimEnd()
}
$taskDest=Join-Path $taskRoot "assets/animations/enemies/$EnemyId"
New-Item -ItemType Directory -Force -Path $taskDest | Out-Null
$taskManifestPath=Join-Path $taskRoot '.atena/generated/PRIORITY-IMAGES-2026-10-02.json'
$taskManifest=Get-Content -Raw -LiteralPath $taskManifestPath | ConvertFrom-Json
foreach($taskState in $taskStates.Keys){
 $taskFile=Join-Path $taskDest "$taskState.png"
 Copy-Item -LiteralPath (Join-Path $taskSource "$taskState.png") -Destination $taskFile
 $taskPath="assets/animations/enemies/$EnemyId/$taskState.png"
 $taskManifest.assets=@($taskManifest.assets | Where-Object {$_.path -ne $taskPath})
 $taskManifest.assets+=[pscustomobject]@{path=$taskPath;width=256*$taskStates[$taskState];height=384;corner_alpha=0;sha256=(Get-FileHash -LiteralPath $taskFile -Algorithm SHA256).Hash.ToLowerInvariant()}
}
$taskManifest.count=$taskManifest.assets.Count
$taskManifest | ConvertTo-Json -Depth 15 | Set-Content -LiteralPath $taskManifestPath -Encoding UTF8
Write-Output "$EnemyId installed: body=$taskBody, assets=$($taskManifest.count)"
