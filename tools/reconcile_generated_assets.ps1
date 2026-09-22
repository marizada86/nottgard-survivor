param(
    [string]$ManifestPath = ".atena/generated/ASSET-PRODUCTION-MANIFEST-001.json"
)

$ErrorActionPreference = "Stop"

$manifest = Get-Content -LiteralPath $ManifestPath -Raw -Encoding UTF8 | ConvertFrom-Json
$updated = 0

foreach ($entry in $manifest.entries) {
    $candidateDir = Join-Path ".atena/generated/art-candidates" ([string]$entry.family)
    if (-not (Test-Path -LiteralPath $candidateDir)) { continue }

    $pattern = "{0}_v*.png" -f ([string]$entry.asset_id)
    $candidate = Get-ChildItem -LiteralPath $candidateDir -Filter $pattern -File |
        Sort-Object Name -Descending |
        Select-Object -First 1
    if ($null -eq $candidate) { continue }

    $finalPath = [string]$entry.final_path
    if (-not (Test-Path -LiteralPath $finalPath)) {
        throw "Candidate exists but final asset is missing: $($entry.family)/$($entry.asset_id)"
    }

    $match = [regex]::Match($candidate.BaseName, '_v(?<version>\d+)$')
    if (-not $match.Success) { continue }

    $entry.status = "integrated"
    $entry.selected_version = "v$($match.Groups['version'].Value)"
    $sha = [System.Security.Cryptography.SHA256]::Create()
    $stream = [System.IO.File]::OpenRead((Resolve-Path -LiteralPath $finalPath))
    try {
        $entry.sha256 = ([System.BitConverter]::ToString($sha.ComputeHash($stream))).Replace("-", "").ToLowerInvariant()
    } finally {
        $stream.Dispose()
        $sha.Dispose()
    }
    if ($null -eq $entry.qa_notes) { $entry.qa_notes = @() }
    $updated++
}

$json = $manifest | ConvertTo-Json -Depth 12
[System.IO.File]::WriteAllText((Join-Path (Get-Location) $ManifestPath), $json, [System.Text.UTF8Encoding]::new($false))

[PSCustomObject]@{
    reconciled = $updated
    manifest = $ManifestPath
}
