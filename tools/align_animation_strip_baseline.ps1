param(
    [Parameter(Mandatory = $true)][string]$SourcePath,
    [Parameter(Mandatory = $true)][string]$OutputPath,
    [Parameter(Mandatory = $true)][int]$FrameCount,
    [int]$CellWidth = 256,
    [int]$CellHeight = 384,
    [int]$BaselineY = 367,
    [int]$AlphaThreshold = 26
)

$ErrorActionPreference = "Stop"
Add-Type -AssemblyName System.Drawing

$source = [System.Drawing.Bitmap]::FromFile((Resolve-Path -LiteralPath $SourcePath))
if ($source.Width -ne ($CellWidth * $FrameCount) -or $source.Height -ne $CellHeight) {
    throw "Unexpected strip dimensions: $($source.Width)x$($source.Height)"
}

$output = New-Object System.Drawing.Bitmap $source.Width, $source.Height, ([System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$graphics = [System.Drawing.Graphics]::FromImage($output)
$graphics.Clear([System.Drawing.Color]::Transparent)
$graphics.CompositingMode = [System.Drawing.Drawing2D.CompositingMode]::SourceCopy

for ($frame = 0; $frame -lt $FrameCount; $frame++) {
    $left = $frame * $CellWidth
    $bottom = -1
    for ($y = 0; $y -lt $CellHeight; $y++) {
        for ($x = $left; $x -lt ($left + $CellWidth); $x++) {
            if ($source.GetPixel($x, $y).A -ge $AlphaThreshold) {
                $bottom = [Math]::Max($bottom, $y)
            }
        }
    }
    if ($bottom -lt 0) { throw "Frame $frame has no visible pixels" }
    $offset = $BaselineY - $bottom
    $sourceRect = New-Object System.Drawing.Rectangle $left, 0, $CellWidth, $CellHeight
    $targetRect = New-Object System.Drawing.Rectangle $left, $offset, $CellWidth, $CellHeight
    $graphics.DrawImage($source, $targetRect, $sourceRect, [System.Drawing.GraphicsUnit]::Pixel)
}

$directory = Split-Path -Parent $OutputPath
if ($directory) { New-Item -ItemType Directory -Force -Path $directory | Out-Null }
$output.Save((Join-Path (Get-Location) $OutputPath), [System.Drawing.Imaging.ImageFormat]::Png)
$graphics.Dispose()
$output.Dispose()
$source.Dispose()
