$ErrorActionPreference='Stop'
$taskRoot=(Resolve-Path (Join-Path $PSScriptRoot '../../..')).Path
$taskRecords=@(Get-ChildItem (Join-Path $PSScriptRoot 'records') -Filter '*.json'|ForEach-Object {Get-Content $_.FullName -Raw|ConvertFrom-Json})
$taskGenerated=@($taskRecords|ForEach-Object {$_.id.Substring(0,4)}|Sort-Object -Unique).Count
$taskP=Join-Path $taskRoot '.atena/state/asset-lot17-durvall-sw-source-repair.yaml'
$taskT=Get-Content $taskP -Raw
$taskT=[regex]::Replace($taskT,'(?m)^generated: \d+\r?$','generated: '+$taskGenerated)
$taskT=[regex]::Replace($taskT,'(?m)^generation_attempts: \d+\r?$','generation_attempts: '+$taskRecords.Count)
[IO.File]::WriteAllText($taskP,$taskT,[Text.UTF8Encoding]::new($false))
$taskBlock='asset_lot17_durvall_sw_source_repair_2026_10_17:'+"`n"+(($taskT.TrimEnd() -split '\r?\n'|ForEach-Object {if($_.Trim()){'  '+$_}else{''}}) -join "`n")+"`n"
$taskP=Join-Path $taskRoot '.atena/state/plan.yaml'
$taskPlan=Get-Content $taskP -Raw
$taskPlan=[regex]::Replace($taskPlan,'(?ms)^asset_lot17_durvall_sw_source_repair_2026_10_17:.*?(?=^\S|\z)',[Text.RegularExpressions.MatchEvaluator]{param($m)$taskBlock})
[IO.File]::WriteAllText($taskP,$taskPlan,[Text.UTF8Encoding]::new($false))
[ordered]@{generated=$taskGenerated;attempts=$taskRecords.Count}|ConvertTo-Json
