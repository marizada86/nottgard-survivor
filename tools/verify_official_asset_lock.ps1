param(
    [Parameter(Mandatory = $true)][string]$LockPath,
    [string]$ProjectRoot = (Get-Location).Path
)

$ErrorActionPreference = 'Stop'

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

$lock = Get-Content -Raw -LiteralPath $LockPath | ConvertFrom-Json
$mismatches = @()
foreach ($entry in $lock.entries) {
    $path = Join-Path $ProjectRoot $entry.official_path
    if (-not (Test-Path -LiteralPath $path)) {
        $mismatches += "$($entry.asset_id): ausente"
        continue
    }
    if ((Get-Sha256 $path) -ne $entry.sha256) {
        $mismatches += "$($entry.asset_id): hash divergente"
    }
}
if ($mismatches.Count -gt 0) {
    $mismatches | ForEach-Object { Write-Error $_ }
    exit 1
}
Write-Output "lock=$($lock.lock_id)"
Write-Output "verified_entries=$($lock.entries.Count)"
