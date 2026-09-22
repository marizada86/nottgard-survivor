param(
    [Parameter(Mandatory = $true)][string]$AssetId,
    [Parameter(Mandatory = $true)][string]$Family,
    [Parameter(Mandatory = $true)][string]$SourcePath,
    [Parameter(Mandatory = $true)][int]$Width,
    [Parameter(Mandatory = $true)][int]$Height,
    [Parameter(Mandatory = $true)][ValidateSet(0, 1)][int]$Alpha,
    [ValidateSet("Cover", "Contain")][string]$Fit = "Cover",
    [int]$Version = 1,
    [string]$ManifestPath = ".atena/generated/ASSET-PRODUCTION-MANIFEST-001.json"
)

$ErrorActionPreference = "Stop"
Add-Type -AssemblyName System.Drawing

if (-not (Test-Path -LiteralPath $SourcePath)) {
    throw "Generated source not found: $SourcePath"
}

$manifest = Get-Content -LiteralPath $ManifestPath -Raw -Encoding UTF8 | ConvertFrom-Json
$entry = @($manifest.entries | Where-Object { $_.asset_id -eq $AssetId -and $_.family -eq $Family })
if ($entry.Count -ne 1) {
    throw "Expected one manifest entry for $Family/$AssetId; found $($entry.Count)"
}
$entry = $entry[0]

$candidateDir = Join-Path ".atena/generated/art-candidates" $Family
New-Item -ItemType Directory -Force -Path $candidateDir | Out-Null
$candidatePath = Join-Path $candidateDir ("{0}_v{1:d2}.png" -f $AssetId, $Version)
Copy-Item -LiteralPath $SourcePath -Destination $candidatePath -Force

$finalPath = [string]$entry.final_path
$finalDir = Split-Path -Parent $finalPath
New-Item -ItemType Directory -Force -Path $finalDir | Out-Null

if (Test-Path -LiteralPath $finalPath) {
    $backupPath = Join-Path ".atena/evidence/legacy-backup" $finalPath
    if (-not (Test-Path -LiteralPath $backupPath)) {
        New-Item -ItemType Directory -Force -Path (Split-Path -Parent $backupPath) | Out-Null
        Copy-Item -LiteralPath $finalPath -Destination $backupPath
    }
}

$src = [System.Drawing.Image]::FromFile((Resolve-Path -LiteralPath $candidatePath))
$hasAlpha = $Alpha -eq 1
$pixelFormat = if ($hasAlpha) { [System.Drawing.Imaging.PixelFormat]::Format32bppArgb } else { [System.Drawing.Imaging.PixelFormat]::Format24bppRgb }
$dst = New-Object System.Drawing.Bitmap $Width, $Height, $pixelFormat
$g = [System.Drawing.Graphics]::FromImage($dst)
$g.CompositingMode = [System.Drawing.Drawing2D.CompositingMode]::SourceCopy
$g.CompositingQuality = [System.Drawing.Drawing2D.CompositingQuality]::HighQuality
$g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::NearestNeighbor
$g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::Half
$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::None
if ($hasAlpha) { $g.Clear([System.Drawing.Color]::Transparent) } else { $g.Clear([System.Drawing.Color]::Black) }

$scaleX = $Width / [double]$src.Width
$scaleY = $Height / [double]$src.Height
$scale = if ($Fit -eq "Cover") { [Math]::Max($scaleX, $scaleY) } else { [Math]::Min($scaleX, $scaleY) }
$drawW = [int][Math]::Round($src.Width * $scale)
$drawH = [int][Math]::Round($src.Height * $scale)
$drawX = [int][Math]::Floor(($Width - $drawW) / 2)
$drawY = [int][Math]::Floor(($Height - $drawH) / 2)
$g.DrawImage($src, $drawX, $drawY, $drawW, $drawH)
$dst.Save((Join-Path (Get-Location) $finalPath), [System.Drawing.Imaging.ImageFormat]::Png)
$g.Dispose()
$dst.Dispose()
$src.Dispose()

$sha = [System.Security.Cryptography.SHA256]::Create()
$stream = [System.IO.File]::OpenRead((Resolve-Path -LiteralPath $finalPath))
try {
    $hash = ([System.BitConverter]::ToString($sha.ComputeHash($stream))).Replace("-", "").ToLowerInvariant()
} finally {
    $stream.Dispose()
    $sha.Dispose()
}
$entry.status = "integrated"
$entry.selected_version = ("v{0:d2}" -f $Version)
$entry.sha256 = $hash
$entry.qa_notes = @($entry.qa_notes) + @("processed ${Width}x${Height}; fit=$Fit; alpha=$hasAlpha")

$json = $manifest | ConvertTo-Json -Depth 12
[System.IO.File]::WriteAllText((Join-Path (Get-Location) $ManifestPath), $json, [System.Text.UTF8Encoding]::new($false))

[PSCustomObject]@{
    asset = "$Family/$AssetId"
    candidate = $candidatePath
    final = $finalPath
    dimensions = "${Width}x${Height}"
    sha256 = $hash
}
