param(
    [string]$ProjectRoot = (Get-Location).Path,
    [string]$LockPath = '.atena/generated/asset-audit/ASSET-OFFICIAL-LOCK-009.json'
)

$ErrorActionPreference = 'Stop'
$auditPath = Join-Path $ProjectRoot '.atena/generated/asset-audit/ASSET-AUDIT-001.json'
$rendererPath = Join-Path $ProjectRoot 'tools/render_prop_review_board.ps1'
$indexPath = Join-Path $ProjectRoot '.atena/generated/asset-audit/ASSET-REVIEW-BOARD-INDEX-001.json'
$audit = Get-Content -Raw -LiteralPath $auditPath | ConvertFrom-Json
$lock = Get-Content -Raw -LiteralPath (Join-Path $ProjectRoot $LockPath) | ConvertFrom-Json
$officialIds = @($lock.entries.asset_id)
$unofficial = @($audit.records | Where-Object { $_.asset_id -notin $officialIds })
$index = @()

foreach ($familyGroup in $unofficial | Group-Object family | Sort-Object Name) {
    $items = @($familyGroup.Group | Sort-Object asset_id)
    for ($offset = 0; $offset -lt $items.Count; $offset += 18) {
        $chunk = @($items | Select-Object -Skip $offset -First 18)
        $chunkNumber = [int]($offset / 18) + 1
        $boardId = ('unofficial-' + $familyGroup.Name.Replace('/','-') + '-' + $chunkNumber).Replace(' ','-')
        $title = "SPEC-044 / $($familyGroup.Name) - lote $chunkNumber"
        $chunkIds = [string[]]@($chunk | ForEach-Object { $_.asset_id })
        $result = & $rendererPath -AssetIds $chunkIds -Family $familyGroup.Name -BoardId $boardId -Title $title -ProjectRoot $ProjectRoot
        $outputPath = ($result | Where-Object { $_ -like 'board=*' } | Select-Object -First 1).Substring(6)
        $index += [pscustomobject][ordered]@{
            board_id = $boardId
            family = $familyGroup.Name
            count = $chunk.Count
            asset_ids = @($chunk.asset_id)
            path = $outputPath.Substring($ProjectRoot.Length + 1).Replace('\','/')
        }
    }
}

$report = [ordered]@{
    schema_version = 1
    source_lock = $LockPath
    unofficial_asset_count = $unofficial.Count
    board_count = $index.Count
    boards = $index
}
$report | ConvertTo-Json -Depth 6 | Set-Content -LiteralPath $indexPath -Encoding utf8
Write-Output "index=$indexPath"
Write-Output "unofficial_assets=$($unofficial.Count)"
Write-Output "boards=$($index.Count)"
