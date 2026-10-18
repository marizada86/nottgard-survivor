$ErrorActionPreference='Stop'
$taskRoot=(Resolve-Path (Join-Path $PSScriptRoot '../../..')).Path
$taskRecords=@(Get-ChildItem -LiteralPath (Join-Path $PSScriptRoot 'records') -Filter '*.json'|ForEach-Object {Get-Content $_.FullName -Raw|ConvertFrom-Json})
$taskGenerated=@($taskRecords|ForEach-Object {$_.id.Substring(0,4)}|Sort-Object -Unique).Count
$taskPath=Join-Path $taskRoot '.atena/state/asset-lot15-heroes-back-walk.yaml'
$taskT=Get-Content -LiteralPath $taskPath -Raw
$taskT=[regex]::Replace($taskT,'(?m)^generated: \d+\r?$','generated: '+$taskGenerated)
$taskT=[regex]::Replace($taskT,'(?m)^generation_attempts: \d+\r?$','generation_attempts: '+$taskRecords.Count)
[IO.File]::WriteAllText($taskPath,$taskT,[Text.UTF8Encoding]::new($false))
$taskPlanP=Join-Path $taskRoot '.atena/state/plan.yaml'
$taskPlan=Get-Content -LiteralPath $taskPlanP -Raw
$taskBlock='asset_lot15_heroes_back_walk_2026_10_17:'+ [Environment]::NewLine+(($taskT.TrimEnd() -split '\r?\n'|ForEach-Object {if($_.Trim()){'  '+$_}else{''}})-join [Environment]::NewLine)+[Environment]::NewLine+[Environment]::NewLine
$taskPlan=[regex]::Replace($taskPlan,'(?ms)^asset_lot15_heroes_back_walk_2026_10_17:.*?(?=^\S|\z)',[Text.RegularExpressions.MatchEvaluator]{param($m)$taskBlock})
[IO.File]::WriteAllText($taskPlanP,$taskPlan,[Text.UTF8Encoding]::new($false))
[ordered]@{generated=$taskGenerated;attempts=$taskRecords.Count}|ConvertTo-Json
