param(
    [string]$ProjectRoot = (Get-Location).Path,
    [int]$CellWidth = 256,
    [int]$CellHeight = 384,
    [int]$Padding = 8
)

$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing

$sourceRoot = Join-Path $ProjectRoot '.atena/generated/art-candidates/enemy-pilot/cultista_adaga'
$outputRoot = Join-Path $ProjectRoot 'assets/animations/enemies/cultista_adaga'
$states = [ordered]@{
    idle = @(0, 1, 2, 3)
    move = @(0, 1, 2, 3, 4, 5)
    attack = @(0, 1, 2, 3)
    death = @(0, 1, 2, 3, 4, 5)
}

$sources = @()
foreach ($state in $states.Keys) {
    foreach ($frame in $states[$state]) {
        $name = 'cultista_adaga_{0}_{1:D2}_alpha_v01.png' -f $state, $frame
        $path = Join-Path $sourceRoot $name
        if (-not (Test-Path -LiteralPath $path)) { throw "Missing approved alpha candidate: $path" }
        $sources += $path
    }
}
if (Test-Path -LiteralPath $outputRoot) {
    throw "Refusing to overwrite existing integration directory: $outputRoot"
}

function Get-AlphaBounds([System.Drawing.Bitmap]$Bitmap) {
    $rect = [System.Drawing.Rectangle]::new(0, 0, $Bitmap.Width, $Bitmap.Height)
    $data = $Bitmap.LockBits($rect, [System.Drawing.Imaging.ImageLockMode]::ReadOnly, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    try {
        $stride = [Math]::Abs($data.Stride)
        $bytes = New-Object byte[] ($stride * $Bitmap.Height)
        [System.Runtime.InteropServices.Marshal]::Copy($data.Scan0, $bytes, 0, $bytes.Length)
        $minX = $Bitmap.Width; $minY = $Bitmap.Height; $maxX = -1; $maxY = -1
        for ($y = 0; $y -lt $Bitmap.Height; $y++) {
            for ($x = 0; $x -lt $Bitmap.Width; $x++) {
                if ($bytes[$y * $stride + $x * 4 + 3] -gt 8) {
                    if ($x -lt $minX) { $minX = $x }
                    if ($x -gt $maxX) { $maxX = $x }
                    if ($y -lt $minY) { $minY = $y }
                    if ($y -gt $maxY) { $maxY = $y }
                }
            }
        }
        if ($maxX -lt $minX -or $maxY -lt $minY) { throw 'candidate has no visible pixels' }
        return [System.Drawing.Rectangle]::new($minX, $minY, $maxX - $minX + 1, $maxY - $minY + 1)
    }
    finally { $Bitmap.UnlockBits($data) }
}

New-Item -ItemType Directory -Force -Path $outputRoot | Out-Null
$report = @()
foreach ($state in $states.Keys) {
    $frames = $states[$state]
    $strip = [System.Drawing.Bitmap]::new($CellWidth * $frames.Count, $CellHeight, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $graphics = [System.Drawing.Graphics]::FromImage($strip)
    try {
        $graphics.Clear([System.Drawing.Color]::Transparent)
        $graphics.CompositingMode = [System.Drawing.Drawing2D.CompositingMode]::SourceCopy
        $graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::NearestNeighbor
        $graphics.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::Half
        for ($index = 0; $index -lt $frames.Count; $index++) {
            $frame = $frames[$index]
            $sourcePath = Join-Path $sourceRoot ('cultista_adaga_{0}_{1:D2}_alpha_v01.png' -f $state, $frame)
            $source = [System.Drawing.Bitmap]::FromFile($sourcePath)
            try {
                $bounds = Get-AlphaBounds $source
                $availableWidth = $CellWidth - 2 * $Padding
                $availableHeight = $CellHeight - 2 * $Padding
                $scale = [Math]::Min($availableWidth / [double]$bounds.Width, $availableHeight / [double]$bounds.Height)
                $width = [int][Math]::Round($bounds.Width * $scale)
                $height = [int][Math]::Round($bounds.Height * $scale)
                $x = $index * $CellWidth + [int][Math]::Floor(($CellWidth - $width) / 2)
                $y = $CellHeight - $Padding - $height
                $graphics.DrawImage($source, [System.Drawing.Rectangle]::new($x, $y, $width, $height), $bounds, [System.Drawing.GraphicsUnit]::Pixel)
            }
            finally { $source.Dispose() }
        }
        $outputPath = Join-Path $outputRoot "$state.png"
        $strip.Save($outputPath, [System.Drawing.Imaging.ImageFormat]::Png)
        $report += [PSCustomObject]@{ state = $state; frames = $frames.Count; path = $outputPath; dimensions = "$($strip.Width)x$($strip.Height)" }
    }
    finally { $graphics.Dispose(); $strip.Dispose() }
}
$report
