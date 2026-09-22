param(
    [string]$ManifestPath = ".atena/generated/ASSET-PRODUCTION-MANIFEST-001.json",
    [string]$EvidenceDir = ".atena/evidence"
)

$ErrorActionPreference = "Stop"
Add-Type -AssemblyName System.Drawing
New-Item -ItemType Directory -Force -Path $EvidenceDir | Out-Null

function Draw-Checker([System.Drawing.Graphics]$Graphics, [System.Drawing.Rectangle]$Rect, [int]$Size = 16) {
    $dark = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(255, 20, 16, 28))
    $light = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(255, 34, 27, 43))
    try {
        for ($y = $Rect.Y; $y -lt $Rect.Bottom; $y += $Size) {
            for ($x = $Rect.X; $x -lt $Rect.Right; $x += $Size) {
                $brush = if (((($x - $Rect.X) / $Size) + (($y - $Rect.Y) / $Size)) % 2 -eq 0) { $dark } else { $light }
                $Graphics.FillRectangle($brush, $x, $y, [Math]::Min($Size, $Rect.Right - $x), [Math]::Min($Size, $Rect.Bottom - $y))
            }
        }
    } finally {
        $dark.Dispose()
        $light.Dispose()
    }
}

function Draw-ContainedImage([System.Drawing.Graphics]$Graphics, [System.Drawing.Image]$Image, [System.Drawing.Rectangle]$Rect) {
    $scale = [Math]::Min($Rect.Width / [double]$Image.Width, $Rect.Height / [double]$Image.Height)
    $width = [int][Math]::Round($Image.Width * $scale)
    $height = [int][Math]::Round($Image.Height * $scale)
    $x = $Rect.X + [int][Math]::Floor(($Rect.Width - $width) / 2)
    $y = $Rect.Y + [int][Math]::Floor(($Rect.Height - $height) / 2)
    $Graphics.DrawImage($Image, $x, $y, $width, $height)
}

$manifest = Get-Content -LiteralPath $ManifestPath -Raw -Encoding UTF8 | ConvertFrom-Json
$entries = @($manifest.entries | Sort-Object family, asset_id)
$columns = 8
$cellWidth = 160
$cellHeight = 176
$rows = [int][Math]::Ceiling($entries.Count / [double]$columns)
$sheet = [System.Drawing.Bitmap]::new($columns * $cellWidth, $rows * $cellHeight, [System.Drawing.Imaging.PixelFormat]::Format24bppRgb)
$graphics = [System.Drawing.Graphics]::FromImage($sheet)
$font = [System.Drawing.Font]::new([System.Drawing.FontFamily]::GenericSansSerif, 9)
$familyFont = [System.Drawing.Font]::new([System.Drawing.FontFamily]::GenericSansSerif, 8, [System.Drawing.FontStyle]::Bold)
$textBrush = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(235, 226, 238))
$familyBrush = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(190, 150, 226))
$borderPen = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(72, 55, 88), 1)
try {
    $graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::NearestNeighbor
    $graphics.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::Half
    for ($i = 0; $i -lt $entries.Count; $i++) {
        $entry = $entries[$i]
        $column = $i % $columns
        $row = [int][Math]::Floor($i / $columns)
        $cell = [System.Drawing.Rectangle]::new($column * $cellWidth, $row * $cellHeight, $cellWidth, $cellHeight)
        $imageRect = [System.Drawing.Rectangle]::new($cell.X + 16, $cell.Y + 6, 128, 128)
        Draw-Checker $graphics $imageRect 16
        $image = [System.Drawing.Image]::FromFile((Resolve-Path -LiteralPath $entry.final_path).Path)
        try { Draw-ContainedImage $graphics $image $imageRect } finally { $image.Dispose() }
        $graphics.DrawRectangle($borderPen, $imageRect)
        $name = [string]$entry.asset_id
        if ($name.Length -gt 24) { $name = $name.Substring(0, 23) + "…" }
        $family = [string]$entry.family
        if ($family.Length -gt 25) { $family = $family.Substring(0, 24) + "…" }
        $graphics.DrawString($name, $font, $textBrush, $cell.X + 7, $cell.Y + 137)
        $graphics.DrawString($family, $familyFont, $familyBrush, $cell.X + 7, $cell.Y + 154)
    }
    $assetOutput = Join-Path $EvidenceDir "EVID-009-assets-contact-sheet.png"
    $sheet.Save((Join-Path (Get-Location) $assetOutput), [System.Drawing.Imaging.ImageFormat]::Png)
} finally {
    $borderPen.Dispose()
    $familyBrush.Dispose()
    $textBrush.Dispose()
    $familyFont.Dispose()
    $font.Dispose()
    $graphics.Dispose()
    $sheet.Dispose()
}

$stages = @("dagruve", "shedaklah", "molor", "durao", "feng_tu", "shendilavri", "goranthis", "pilares")
$stageWidth = 640
$stageHeight = 360
$stageSheet = [System.Drawing.Bitmap]::new(1280, 1440, [System.Drawing.Imaging.PixelFormat]::Format24bppRgb)
$stageGraphics = [System.Drawing.Graphics]::FromImage($stageSheet)
try {
    $stageGraphics.Clear([System.Drawing.Color]::Black)
    $stageGraphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    for ($i = 0; $i -lt $stages.Count; $i++) {
        $stage = $stages[$i]
        $path = Join-Path $EvidenceDir "asset-screenshots/$stage.png"
        if (-not (Test-Path -LiteralPath $path)) { throw "Missing stage screenshot: $path" }
        $image = [System.Drawing.Image]::FromFile((Resolve-Path -LiteralPath $path).Path)
        try {
            $rect = [System.Drawing.Rectangle]::new(($i % 2) * $stageWidth, [int][Math]::Floor($i / 2) * $stageHeight, $stageWidth, $stageHeight)
            Draw-ContainedImage $stageGraphics $image $rect
        } finally { $image.Dispose() }
    }
    $stageOutput = Join-Path $EvidenceDir "EVID-010-stage-screenshots-contact-sheet.png"
    $stageSheet.Save((Join-Path (Get-Location) $stageOutput), [System.Drawing.Imaging.ImageFormat]::Png)
} finally {
    $stageGraphics.Dispose()
    $stageSheet.Dispose()
}

[PSCustomObject]@{
    assets = $entries.Count
    asset_sheet = (Join-Path $EvidenceDir "EVID-009-assets-contact-sheet.png")
    stages = $stages.Count
    stage_sheet = (Join-Path $EvidenceDir "EVID-010-stage-screenshots-contact-sheet.png")
}
