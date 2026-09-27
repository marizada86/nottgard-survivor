param(
    [string[]]$HeroIds = @(),
    [string[]]$AssetIds = @(),
    [Parameter(Mandatory = $true)]
    [string]$BaseLockPath,
    [Parameter(Mandatory = $true)]
    [string]$OutputPath,
    [Parameter(Mandatory = $true)]
    [string[]]$DecisionRegisters,
    [string]$ProjectRoot = (Get-Location).Path
)

$ErrorActionPreference = 'Stop'
$heroAuditPath = Join-Path $ProjectRoot '.atena/generated/asset-audit/HERO-ANIMATION-AUDIT-001.json'
$assetAuditPath = Join-Path $ProjectRoot '.atena/generated/asset-audit/ASSET-AUDIT-001.json'
if ($HeroIds.Count -eq 0 -and $AssetIds.Count -eq 0) { throw 'specify HeroIds or AssetIds' }
$baseLock = Get-Content -Raw -LiteralPath $BaseLockPath | ConvertFrom-Json
$heroAudit = Get-Content -Raw -LiteralPath $heroAuditPath | ConvertFrom-Json
$assetAudit = Get-Content -Raw -LiteralPath $assetAuditPath | ConvertFrom-Json

$heroEntries = foreach ($record in $heroAudit.records | Where-Object { $_.hero_id -in $HeroIds }) {
    [pscustomobject][ordered]@{
        asset_id = $record.asset_id
        family = 'animations/heroes'
        official_path = $record.final_path
        sha256 = $record.final_sha256
        dimensions = $record.dimensions
        alpha = $record.alpha
        runtime_use = "$($record.hero_id) source animation: $($record.sequence)"
    }
}
$assetEntries = foreach ($record in $assetAudit.records | Where-Object { $_.asset_id -in $AssetIds }) {
    [pscustomobject][ordered]@{
        asset_id = $record.asset_id
        family = $record.family
        official_path = $record.final_path
        sha256 = $record.actual_sha256
        dimensions = $record.actual_dimensions
        alpha = $record.actual_alpha
        runtime_use = 'Asset final de producao; uso de runtime a confirmar por familia'
    }
}
$newEntries = @($heroEntries + $assetEntries)

foreach ($entry in $newEntries) {
    $actual = (Get-FileHash -Algorithm SHA256 -LiteralPath (Join-Path $ProjectRoot $entry.official_path)).Hash.ToLowerInvariant()
    if ($actual -ne $entry.sha256) { throw "hash mismatch for $($entry.asset_id)" }
}

$allEntries = @($baseLock.entries + $newEntries | Sort-Object asset_id)
if (@($allEntries.asset_id | Select-Object -Unique).Count -ne $allEntries.Count) { throw 'duplicate asset_id in generated lock' }

$lockNumber = [regex]::Match((Split-Path -Leaf $OutputPath), 'LOCK-(\d+)').Groups[1].Value
$lock = [ordered]@{
    schema_version = 1
    lock_id = "ASSET-OFFICIAL-LOCK-$lockNumber"
    scope = 'SPEC-044 approved batches through the current decision'
    decision_registers = $DecisionRegisters
    entry_count = $allEntries.Count
    entries = $allEntries
}
$lock | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $OutputPath -Encoding utf8
Write-Output "lock=$OutputPath"
Write-Output "entries=$($allEntries.Count)"
