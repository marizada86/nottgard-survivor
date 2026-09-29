param(
    [string]$ProjectRoot = (Get-Location).Path
)

$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing
$manifestPath = Join-Path $ProjectRoot '.atena/generated/HERO-ANIMATION-PROMPT-MANIFEST-001.json'
$auditDirectory = Join-Path $ProjectRoot '.atena/generated/asset-audit'
$auditPath = Join-Path $auditDirectory 'HERO-ANIMATION-AUDIT-001.json'
New-Item -ItemType Directory -Force -Path $auditDirectory | Out-Null

function Get-ImageMetadata([string]$Path) {
    $image = [System.Drawing.Image]::FromFile($Path)
    try {
        $hasAlpha = (($image.PixelFormat -band [System.Drawing.Imaging.PixelFormat]::Alpha) -ne 0) -or
            (($image.PixelFormat -band [System.Drawing.Imaging.PixelFormat]::PAlpha) -ne 0)
        return [ordered]@{ width = $image.Width; height = $image.Height; alpha = $hasAlpha }
    }
    finally { $image.Dispose() }
}

function Get-Sha256([string]$Path) {
    $algorithm = [System.Security.Cryptography.SHA256]::Create()
    $stream = [System.IO.File]::OpenRead($Path)
    try {
        return -join ($algorithm.ComputeHash($stream) | ForEach-Object { $_.ToString('x2') })
    }
    finally {
        $stream.Dispose()
        $algorithm.Dispose()
    }
}

function Get-Candidates([string]$Hero, [string]$Sequence) {
    $roots = @(
        (Join-Path $ProjectRoot ".atena/generated/asset-candidates/animations/heroes/$Hero"),
        (Join-Path $ProjectRoot ".atena/generated/animation-candidates/heroes/$Hero")
    ) | Where-Object { Test-Path -LiteralPath $_ }
    $matches = foreach ($root in $roots) {
        Get-ChildItem -LiteralPath $root -Recurse -File -Filter "$Sequence*.png" | ForEach-Object {
            [pscustomobject][ordered]@{
                path = $_.FullName.Substring($ProjectRoot.Length + 1).Replace('\', '/')
                sha256 = Get-Sha256 $_.FullName
                dimensions = Get-ImageMetadata $_.FullName
            }
        }
    }
    return @($matches | Sort-Object path -Unique)
}

$manifest = Get-Content -Raw -LiteralPath $manifestPath | ConvertFrom-Json
$sourceSequences = @($manifest.generation_sequence_contract)
$heroIds = @($manifest.heroes.psobject.Properties.Name)
$records = foreach ($hero in $heroIds) {
    foreach ($sequence in $sourceSequences) {
        $finalPath = "assets/animations/heroes/$hero/$($sequence.id).png"
        $finalFullPath = Join-Path $ProjectRoot $finalPath
        $finalExists = Test-Path -LiteralPath $finalFullPath
        $metadata = if ($finalExists) { Get-ImageMetadata $finalFullPath } else { $null }
        $expectedWidth = [int]$sequence.cell[0] * [int]$sequence.frames
        $expectedHeight = [int]$sequence.cell[1]
        $candidates = Get-Candidates $hero $sequence.id
        $frameContractMatches = $finalExists -and $metadata.width -eq $expectedWidth -and $metadata.height -eq $expectedHeight
        $classification = if (-not $finalExists) { 'final_ausente' }
            elseif (-not $frameContractMatches) { 'contrato_de_frames_divergente' }
            elseif ($candidates.Count -eq 0) { 'candidato_ausente' }
            else { 'verificavel_sem_hash_de_manifesto' }

        [pscustomobject][ordered]@{
            asset_id = "$hero.$($sequence.id)"
            hero_id = $hero
            sequence = $sequence.id
            final_path = $finalPath
            final_exists = $finalExists
            final_sha256 = if ($finalExists) { Get-Sha256 $finalFullPath } else { $null }
            dimensions = if ($null -eq $metadata) { $null } else { "{0}x{1}" -f $metadata.width, $metadata.height }
            alpha = if ($null -eq $metadata) { $null } else { $metadata.alpha }
            frames = $sequence.frames
            cell = "$($sequence.cell[0])x$($sequence.cell[1])"
            fps = $sequence.fps
            frame_contract_matches = $frameContractMatches
            candidate_variants = $candidates
            traceability_classification = $classification
            approval_decision = 'unreviewed'
        }
    }
}

$classifications = [ordered]@{}
$records | Group-Object traceability_classification | Sort-Object Name | ForEach-Object { $classifications[$_.Name] = $_.Count }
$nyrelia = @($records | Where-Object { $_.hero_id -eq 'nyrelia' })
$report = [ordered]@{
    schema_version = 1
    generated_at = (Get-Date).ToUniversalTime().ToString('o')
    source_manifest = '.atena/generated/HERO-ANIMATION-PROMPT-MANIFEST-001.json'
    declared_source_sequences = $manifest.counts.total_source_sequences
    audited_records = @($records).Count
    classifications = $classifications
    nyrelia_critical_review = $nyrelia
    records = $records
}
$report | ConvertTo-Json -Depth 10 | Set-Content -LiteralPath $auditPath -Encoding utf8

Write-Output "audit=$auditPath"
Write-Output "records=$(@($records).Count)"
foreach ($name in $classifications.Keys) { Write-Output "$name=$($classifications[$name])" }
