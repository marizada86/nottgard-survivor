param(
    [Parameter(Mandatory = $true)][string]$SourcePath,
    [Parameter(Mandatory = $true)][string]$OutputPath,
    [Parameter(Mandatory = $true)][int]$Columns,
    [Parameter(Mandatory = $true)][int]$Rows,
    [Parameter(Mandatory = $true)][int]$FrameCount,
    [Parameter(Mandatory = $true)][int]$CellWidth,
    [Parameter(Mandatory = $true)][int]$CellHeight,
    [int]$Padding = 8
)

$ErrorActionPreference = "Stop"
Add-Type -AssemblyName System.Drawing

if (-not (Test-Path -LiteralPath $SourcePath)) {
    throw "Source sheet not found: $SourcePath"
}
if ($FrameCount -gt $Columns * $Rows) {
    throw "FrameCount exceeds grid capacity"
}

$source = [System.Drawing.Bitmap]::FromFile((Resolve-Path -LiteralPath $SourcePath))
$sourceCellWidth = [int][Math]::Floor($source.Width / $Columns)
$sourceCellHeight = [int][Math]::Floor($source.Height / $Rows)
$strip = New-Object System.Drawing.Bitmap ($CellWidth * $FrameCount), $CellHeight, ([System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$graphics = [System.Drawing.Graphics]::FromImage($strip)
$graphics.Clear([System.Drawing.Color]::Transparent)
$graphics.CompositingMode = [System.Drawing.Drawing2D.CompositingMode]::SourceCopy
$graphics.CompositingQuality = [System.Drawing.Drawing2D.CompositingQuality]::HighQuality
$graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$graphics.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::Half

for ($index = 0; $index -lt $FrameCount; $index++) {
    $column = $index % $Columns
    $row = [int][Math]::Floor($index / $Columns)
    $sourceX = $column * $sourceCellWidth
    $sourceY = $row * $sourceCellHeight
    $width = if ($column -eq $Columns - 1) { $source.Width - $sourceX } else { $sourceCellWidth }
    $height = if ($row -eq $Rows - 1) { $source.Height - $sourceY } else { $sourceCellHeight }

    $cell = $source.Clone((New-Object System.Drawing.Rectangle $sourceX, $sourceY, $width, $height), [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $data = $cell.LockBits((New-Object System.Drawing.Rectangle 0, 0, $cell.Width, $cell.Height), [System.Drawing.Imaging.ImageLockMode]::ReadOnly, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $bytes = New-Object byte[] ([Math]::Abs($data.Stride) * $cell.Height)
    [System.Runtime.InteropServices.Marshal]::Copy($data.Scan0, $bytes, 0, $bytes.Length)
    $cell.UnlockBits($data)

    $minX = $cell.Width
    $minY = $cell.Height
    $maxX = -1
    $maxY = -1
    for ($y = 0; $y -lt $cell.Height; $y++) {
        for ($x = 0; $x -lt $cell.Width; $x++) {
            $alpha = $bytes[$y * [Math]::Abs($data.Stride) + $x * 4 + 3]
            if ($alpha -gt 8) {
                if ($x -lt $minX) { $minX = $x }
                if ($x -gt $maxX) { $maxX = $x }
                if ($y -lt $minY) { $minY = $y }
                if ($y -gt $maxY) { $maxY = $y }
            }
        }
    }
    if ($maxX -lt $minX -or $maxY -lt $minY) {
        $cell.Dispose()
        continue
    }

    $bounds = New-Object System.Drawing.Rectangle $minX, $minY, ($maxX - $minX + 1), ($maxY - $minY + 1)
    $availableWidth = $CellWidth - $Padding * 2
    $availableHeight = $CellHeight - $Padding * 2
    $scale = [Math]::Min($availableWidth / [double]$bounds.Width, $availableHeight / [double]$bounds.Height)
    $drawWidth = [int][Math]::Round($bounds.Width * $scale)
    $drawHeight = [int][Math]::Round($bounds.Height * $scale)
    $drawX = $index * $CellWidth + [int][Math]::Floor(($CellWidth - $drawWidth) / 2)
    $drawY = $CellHeight - $Padding - $drawHeight
    $graphics.DrawImage($cell, (New-Object System.Drawing.Rectangle $drawX, $drawY, $drawWidth, $drawHeight), $bounds, [System.Drawing.GraphicsUnit]::Pixel)
    $cell.Dispose()
}

$directory = Split-Path -Parent $OutputPath
if ($directory) { New-Item -ItemType Directory -Force -Path $directory | Out-Null }
$strip.Save((Join-Path (Get-Location) $OutputPath), [System.Drawing.Imaging.ImageFormat]::Png)
$graphics.Dispose()
$strip.Dispose()
$source.Dispose()

[PSCustomObject]@{
    source = $SourcePath
    output = $OutputPath
    frames = $FrameCount
    frame_size = "${CellWidth}x${CellHeight}"
}
